# Architektur `ce.databridge`

## Zweck

Dieses Paket kapselt die dateibasierte Kommunikation zwischen dem Lua-Code in EEP und dem EEP-Web-Server.

Es hat vier Kernaufgaben:

- Export der eingesammelten Laufzeitdaten aus EEP als JSON-Zeilen-Events
- Export der EEP-Logausgaben in Austauschdateien
- Entgegennahme und Ausführung erlaubter Remote-Kommandos vom Webserver
- Puffern von Events bis zum nächsten Exportzyklus

Die Nutzungsdokumentation der Austauschdateien liegt in [README.md](./README.md). Diese Datei beschreibt die interne Struktur und Verantwortlichkeiten.

## Alle Lua-Dateien in `ce/databridge`

Im Verzeichnis `ce/databridge` existieren aktuell genau diese Lua-Dateien:

- [IncomingCommandExecutor.lua](./IncomingCommandExecutor.lua)
- [ServerExchangeFileIo.lua](./ServerExchangeFileIo.lua)
- [ServerEventBuffer.lua](./ServerEventBuffer.lua)
- [ServerExchangeCoordinator.lua](./ServerExchangeCoordinator.lua)

Im Unterverzeichnis `exchange/` liegen aktuell keine weiteren Lua-Dateien.

## Architekturübersicht

Der dateibasierte Austausch wurde gewählt, weil der Lua-Code in EEP läuft und keinen Server starten soll.
Stattdessen wird neben dem Programm EEP der EEP-Web-Server gestartet. Er nimmt die Daten und Logausgaben entgegen und stellt sie über eine Server API für die EEP-Web-App bereit.

Das Paket ist bewusst schichtartig aufgebaut:

1. `MainLoopRunner` in `ce.hub` steuert den Gesamtzyklus der Module, StatePublisher und der Serverphase
2. `ServerExchangeCoordinator` wickelt innerhalb dieses Zyklus den Austausch mit dem Web-Server ab
3. `ServerExchangeFileIo` kapselt das Dateihandling und das Handshake mit dem Web-Server
4. `IncomingCommandExecutor` führt erlaubte Befehle aus der Eingabedatei aus
5. `ServerEventBuffer` puffert Eventzeilen bis zum nächsten Schreibvorgang

Wichtig: `ce/databridge` enthält selbst kaum Fachlogik. Die Fachdaten werden in anderen Paketen erzeugt und über Events oder registrierte Remote-Funktionen an diese Infrastruktur angebunden.

## Bausteine

### [ServerExchangeCoordinator.lua](./ServerExchangeCoordinator.lua)

Brücke zwischen `MainLoopRunner` und der dateibasierten Server-I/O.

Verantwortlichkeiten:

- Registrierung erlaubter Remote-Funktionen über `IncomingCommandExecutor`
- Prüfen, ob der Web-Server aktuell bereit für den nächsten Austausch ist
- Lesen und Ausführen neuer Kommandos über `ServerExchangeFileIo.readAndExecuteIncomingCommands()`
- Einsammeln gepufferter Events über `ServerEventBuffer.drainBufferedEvents()`
- Weitergabe des Exportstrings an `ServerExchangeFileIo`
- Rückgabe von Laufzeitdaten der Serverphase an den aufrufenden `MainLoopRunner`

Der `ServerExchangeCoordinator` verwaltet keine StatePublisher und initialisiert sie auch nicht. Diese Aufgaben liegen bei `StatePublisherRegistry` und `MainLoopRunner` im Paket `ce.hub`.

### [ServerExchangeFileIo.lua](./ServerExchangeFileIo.lua)

Technischer Dateiadapter für das Austauschverzeichnis.

Verantwortlichkeiten:

- Ermitteln eines schreibbaren Austauschverzeichnisses
- Ableiten aller Dateinamen im `exchange`-Ordner
- Überschreiben von `print`, `warn`, `error`, `assert` und `clearlog`, damit Ausgaben zusätzlich in Dateien landen
- Prüfen, ob der Web-Server hört und bereit ist
- Schreiben der Exportdatei und des Ready-Markers
- Lesen neuer Befehle aus der Kommandodatei

Dieses Modul ist bewusst infrastrukturell. Es kennt keine Json-Collector und keine Fachobjekte.

### [IncomingCommandExecutor.lua](./IncomingCommandExecutor.lua)

Damit EEP auch auf Eingaben reagieren kann, ist es möglich über den EEP-Web-Server Remote-Kommandos zu hinterlegen. Diese schreibt der EEP-Web-Server in die Datei `commands-to-ce`. IncomingCommandExecutor nimmt die Kommandos aus dieser Datei und führt sie aus, wenn sie erlaubt sind.

Verantwortlichkeiten:

- Verwaltung der erlaubten Funktionsnamen
- Parsen des zeilenbasierten Kommandoformats
- Aufruf via `pcall`, damit ein einzelner Fehler den Kommunikationszyklus nicht abbricht

Akzeptierte Befehle:

- explizit registrierte Remote-Funktionen
- `EEPPause`
- globale `EEP*Set`-Funktionen, die beim Laden in `_G` vorhanden sind

Sicherheitsgrenze:

- Es werden nur Funktionen aus `allowedCommands` ausgeführt
- der Formatvertrag ist `Funktionsname|arg1|arg2|...`

### [ServerEventBuffer.lua](./ServerEventBuffer.lua)

Kleiner Write-Behind-Puffer für Events.

Verantwortlichkeiten:

- einzelne Events als JSON-Zeilen puffern
- gepufferte Events gesammelt zurückgeben und den Puffer leeren

Das Modul schreibt nicht selbst auf Platte. Es liefert nur den String an den `ServerExchangeCoordinator`, der ihn über `ServerExchangeFileIo` ausgibt.

## Laufzeitfluss

Der reguläre Ablauf pro Kommunikationszyklus ist:

1. Andere Pakete registrieren StatePublisher über ihre BridgeConnectoren beim `StatePublisherRegistry`
2. `MainLoopRunner.runCycle(...)` initialisiert Module und noch nicht initialisierte StatePublisher
3. `MainLoopRunner.runCycle(...)` ruft `syncState()` auf allen registrierten StatePublishern auf
4. Die StatePublisher veröffentlichen ihre Nutzdaten überwiegend über Events auf dem `DataChangeBus`
5. `ServerExchangeCoordinator.runServerOutputCycle()` wird als Serverphase aus dem `MainLoopRunner` aufgerufen
6. `ServerExchangeFileIo.isServerReady()` prüft das Dateihandshake
7. `ServerExchangeFileIo.readAndExecuteIncomingCommands()` liest neue Befehle
8. `IncomingCommandExecutor.executeIncomingCommands(...)` führt erlaubte Befehle aus
9. `ServerEventBuffer.drainBufferedEvents()` liefert die aktuellen Eventzeilen
10. `ServerExchangeFileIo.writeOutgoingEvents(...)` schreibt die Ausgabedatei und markiert sie als fertig

## Dateibasiertes Protokoll

Die zentrale Infrastruktur basiert auf Dateisignalen im Austauschordner:

- `commands-to-ce`: Eingabekanal für Kommandos, wird vom Server geschrieben
- `events-from-ce.pending`: EEP hat geschrieben und wartet auf den Server zur Bearbeitung
- `events-from-ce`: Exportkanal für Daten als Eventzeilen
- `log-from-ce`: Spiegelung von `print`, `warn`, `error`
- `server-is-running`: Server ist aktiv

Wichtig: Das aktuelle Paket behandelt die Ausgabedatei als generischen Textkanal. Der `ServerExchangeCoordinator` übergibt den Rückgabewert von `ServerEventBuffer.drainBufferedEvents()` direkt an `ServerExchangeFileIo.writeOutgoingEvents(...)`. Änderungen an Format oder Dateiverwendung müssen deshalb Ende-zu-Ende betrachtet werden.

## Zustand

### Prozessweiter Zustand

`ServerExchangeCoordinator` hält:

- das Debug-Flag des Moduls
- die Option `checkServerStatus` für den Readiness-Check
- einen zyklischen Zähler zur Steuerung des Exportintervalls

`IncomingCommandExecutor` hält:

- die Tabelle der erlaubten Remote-Funktionen, damit nur bestimmte Kommandos in EEP ausgeführt werden dürfen und nicht beliebiger Lua-Code

`ServerEventBuffer` hält:

- den flüchtigen Eventpuffer `recordedEvents`

`ServerExchangeFileIo` hält:

- das aktive Austauschverzeichnis
- die abgeleiteten Dateinamen
- den offenen Dateihandle für die Kommandodatei
- Zustandsflags zum Serverhandshake

### Persistenz

Das Paket nutzt keine `StorageUtility`-Persistenz. Sein Zustand ist absichtlich flüchtig und lebt in:

- Lua-Modulvariablen
- Austauschdateien im `exchange`-Ordner

## Wichtige Invarianten

- Alle StatePublisher müssen `name`, `initialize()` und `syncState()` besitzen; validiert wird das im `StatePublisherRegistry`.
- Remote-Kommandos dürfen nur über `allowedCommands` laufen.
- `ServerExchangeFileIo` muss `print` und `clearlog` erst überschreiben und danach als Remote-Funktionen registrieren.
- Das Dateihandshake über `server-is-running` und `events-from-ce.pending` darf nicht still geändert werden; Web-Server und Lua-Seite müssen dasselbe Protokoll sprechen.
- `ce/databridge` ist ein Infrastrukturpaket; Fachmodule sollten hier keine domainspezifische Logik einbauen.

## Typische Änderungsrisiken

### Formatbruch im Dateiprotokoll

Schon kleine Änderungen an Dateinamen, Markerdateien oder dem Schreibzeitpunkt können die Kommunikation zwischen EEP und Web-Server blockieren.

### Zu breite Remote-Freigaben

Änderungen an `IncomingCommandExecutor` können die Remote-Angriffsoberfläche vergrößern. Neue freigegebene Funktionen sollten bewusst und restriktiv eingetragen werden.

### Seiteneffekte durch globale Überschreibungen

`ServerExchangeFileIo` ersetzt globale Funktionen wie `print`, `warn`, `error` und `assert`. Änderungen dort betreffen die internen Lua-Funktionen von EEP und dessen ganzes Lua-System.

### Event- und Publisher-Kopplung

Wenn StatePublisher ihre Events nicht mehr wie erwartet erzeugen oder nicht serialisierbare Daten in den Event-Strom gelangen, zeigen sich Fehler oft erst spät im Exportpfad. Fehlerursache und Fehlerort liegen dann in verschiedenen Paketen.

## Relevante Nachbarn

`ce/databridge` arbeitet eng mit diesen Paketen zusammen:

- `ce.hub`: typischer Aufruf von `runServerOutputCycle(...)`
- `ce.hub.data`, `ce.mods.road`, `ce.mods.transit`: liefern Collector und Remote-Funktionen
- `ce.hub.publish.DataChangeBus`: erzeugt Events, die über den `ServerEventBuffer` gesammelt werden
- `ce.hub.data.runtime.RuntimeMetrics`: sammelt Laufzeitmetriken des Kommunikationszyklus

## Empfehlung für KI-Agenten

Bei Änderungen in `ce/databridge` zuerst diese Fragen beantworten:

1. Betrifft die Änderung das Dateihandshake, die Befehlsausführung oder nur Logging?
2. Welche andere Seite spricht dasselbe Protokoll mit, insbesondere Web-Server oder Web-App?
3. Wird ein globales Verhalten wie `print` oder `assert` geändert?
4. Kann die Änderung dazu führen, dass Collector oder Remote-Funktionen erst zur Laufzeit scheitern?
5. Muss die Beschreibung in [README.md](./README.md) mit angepasst werden?
