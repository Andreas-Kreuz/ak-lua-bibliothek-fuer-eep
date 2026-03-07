# Architektur `ak.io`

## Zweck

Dieses Paket kapselt die dateibasierte Kommunikation zwischen dem Lua-Code in EEP und dem EEP-Web-Server.

Es hat vier Kernaufgaben:

- Export der eingesammelten Laufzeitdaten aus EEP als JSON
- Export der EEP-Logausgaben in Austauschdateien
- Entgegennahme und Ausführung erlaubter Remote-Kommandos vom Webserver
- Puffern von Events bis zum nächsten Exportzyklus

Die Nutzungsdokumentation der Austauschdateien liegt in [README.md](./README.md). Diese Datei beschreibt die interne Struktur und Verantwortlichkeiten.

## Alle Lua-Dateien in `ak/io`

Im Verzeichnis `ak/io` existieren aktuell genau diese Lua-Dateien:

- [AkCommandExecutor.lua](./AkCommandExecutor.lua)
- [AkWebServerIo.lua](./AkWebServerIo.lua)
- [EventRecorder.lua](./EventRecorder.lua)
- [ServerController.lua](./ServerController.lua)

Im Unterverzeichnis [exchange](./exchange/README.md) liegen aktuell keine weiteren Lua-Dateien.

## Architekturübersicht

Der dateibasierte Austausch wurde gewählt, weil der Lua-Code in EEP läuft und keinen Server starten soll.
Stattdessen wird neben dem Programm EEP der EEP-Web-Server gestartet. Er nimmt die Daten und Logausgaben entgegen und stellt sie über eine Server API für die EEP-Web-App bereit.

Das Paket ist bewusst schichtartig aufgebaut:

1. `ServerController` orchestriert den gesamten Kommunikationszyklus
2. `AkWebServerIo` kapselt das Dateihandling und das Handshake mit dem Web-Server
3. `AkCommandExecutor` führt erlaubte Befehle aus der Eingabedatei aus.
4. `EventRecorder` puffert Eventzeilen bis zum nächsten Schreibvorgang

Wichtig: `ak/io` enthält selbst kaum Fachlogik. Die Fachdaten kommen über registrierte Json-Collector und Remote-Funktionen aus anderen Paketen.

## Bausteine

### [ServerController.lua](./ServerController.lua)

Zentrale Orchestrierung des Pakets.

Verantwortlichkeiten:

- Auswahl des JSON-Encoders (`ak.third-party.json` oder optional `cjson`)
- Registrierung und Initialisierung von Json-Collectoren
- Registrierung erlaubter Remote-Funktionen über `AkCommandExecutor`
- periodisches Einsammeln der Daten aller Collector
- Weitergabe des Exportstrings an `AkWebServerIo`
- Sammeln und Weiterreichen von Laufzeitmetriken an `RuntimeRegistry` und `EventBroker`

Erwartetes Collector-Interface:

- `name`
- `initialize()`
- `collectData()`

Der `ServerController` ist damit die einzige vorgesehene Einstiegsschicht für andere Pakete wie `ak.core`, `ak.data` oder `ak.road`.

### [AkWebServerIo.lua](./AkWebServerIo.lua)

Technischer Dateiadapter für das Austauschverzeichnis.

Verantwortlichkeiten:

- Ermitteln eines schreibbaren Austauschverzeichnisses
- Ableiten aller Dateinamen im `exchange`-Ordner
- Überschreiben von `print`, `warn`, `error` und `clearlog`, damit Ausgaben zusätzlich in Dateien landen
- Prüfen, ob der Web-Server hört und bereit ist
- Schreiben der Exportdatei und des Ready-Markers
- Lesen neuer Befehle aus der Kommandodatei

Dieses Modul ist bewusst infrastrukturell. Es kennt keine Json-Collector und keine Fachobjekte.

### [AkCommandExecutor.lua](./AkCommandExecutor.lua)

Damit EEP auch auf Eingaben reagieren kann, ist es möglich über den EEP-Web-Server Remote-Kommandos zu hinterlegen. Diese schreibt der EEP-Web-Server in die Datei `ak-eep-in.commands`. AkCommandExecutor nimmt die Kommandos aus dieser Datei und führt sie aus, wenn sie erlaubt sind.

Verantwortlichkeiten:

- Verwaltung der erlaubten Funktionsnamen
- Parsen des zeilenbasierten Kommandoformats
- Aufruf via `pcall`, damit ein einzelner Fehler den Kommunikationszyklus nicht abbricht

Akzeptierte Befehle:

- explizit registrierte Remote-Funktionen
- `EEPPause`
- globale `EEP*Set`-Funktionen, die beim Laden in `_G` vorhanden sind

Sicherheitsgrenze:

- Es werden nur Funktionen aus `acceptedRemoteFunctions` ausgeführt
- der Formatvertrag ist `Funktionsname|arg1|arg2|...`

### [EventRecorder.lua](./EventRecorder.lua)

Kleiner Write-Behind-Puffer für Events.

Verantwortlichkeiten:

- einzelne Events als JSON-Zeilen puffern
- gepufferte Events gesammelt zurückgeben und den Puffer leeren

Das Modul schreibt nicht selbst auf Platte. Es liefert nur den String an den `ServerController`, der ihn über `AkWebServerIo` ausgibt.

## Laufzeitfluss

Der reguläre Ablauf pro Kommunikationszyklus ist:

1. Andere Pakete registrieren Json-Collector und Remote-Funktionen beim `ServerController`
2. `ServerController.communicateWithServer(modulus)` wird zyklisch aus `EEPMain()` oder einem Modul aufgerufen
3. `AkWebServerIo.checkWebServer()` prüft das Dateihandshake
4. Beim ersten erfolgreichen Lauf initialisiert `ServerController` alle Collector
5. `AkWebServerIo.processNewCommands()` liest neue Befehle
6. `AkCommandExecutor.execute(...)` führt erlaubte Befehle aus
7. In Exportzyklen sammeln alle Collector ihre Daten
8. `EventRecorder.getAndResetEvents()` liefert die aktuellen Eventzeilen
9. `AkWebServerIo.updateJsonFile(...)` schreibt die Ausgabedatei und markiert sie als fertig

## Dateibasiertes Protokoll

Die zentrale Infrastruktur basiert auf Dateisignalen im Austauschordner:

- `ak-server.iswatching`: Server ist aktiv
- `ak-eep-out-json.isfinished`: EEP hat geschrieben, Server hat noch nicht bestätigt
- `ak-eep-in.commands`: Eingabekanal für Kommandos, wird vom Server geschrieben
- `ak-eep-out.json`: Exportkanal für Daten als Eventzeilen
- `ak-eep-out.log`: Spiegelung von `print`, `warn`, `error`

Wichtig: Das aktuelle Paket behandelt die Ausgabedatei als generischen Textkanal. Der `ServerController` übergibt den Rückgabewert von `EventRecorder.getAndResetEvents()` direkt an `AkWebServerIo.updateJsonFile(...)`. Änderungen an Format oder Dateiverwendung müssen deshalb Ende-zu-Ende betrachtet werden.

## Zustand

### Prozessweiter Zustand

`ServerController` hält:

- registrierte JsonCollector
- gesammelte Exportdaten
- Initialisierungsstatus
- Daten für Metriken, um die Performance der Collectoren und Laufzeiten der Module zu messen

`AkCommandExecutor` hält:

- die Tabelle der erlaubten Remote-Funktionen, damit nur bestimmte Kommandos in EEP ausgeführt werden dürfen und nicht beliebiger Lua-Code

`EventRecorder` hält:

- den flüchtigen Eventpuffer `eventTexts`

`AkWebServerIo` hält:

- das aktive Austauschverzeichnis
- die abgeleiteten Dateinamen
- den offenen Dateihandle für die Kommandodatei
- Zustandsflags zum Serverhandshake

### Persistenz

Das Paket nutzt keine `StorageUtility`-Persistenz. Sein Zustand ist absichtlich flüchtig und lebt in:

- Lua-Modulvariablen
- Austauschdateien im `exchange`-Ordner

## Wichtige Invarianten

- Alle Json-Collector müssen `name`, `initialize()` und `collectData()` besitzen.
- Exportdaten dürfen keine Funktionen enthalten; `ServerController.checkObjects(...)` bricht sonst ab.
- Remote-Kommandos dürfen nur über `acceptedRemoteFunctions` laufen.
- `AkWebServerIo` muss `print` und `clearlog` erst überschreiben und danach als Remote-Funktionen registrieren.
- Das Dateihandshake über `ak-server.iswatching` und `ak-eep-out-json.isfinished` darf nicht still geändert werden; Web-Server und Lua-Seite müssen dasselbe Protokoll sprechen.
- `ak/io` ist ein Infrastrukturpaket; Fachmodule sollten hier keine domainspezifische Logik einbauen.

## Typische Änderungsrisiken

### Formatbruch im Dateiprotokoll

Schon kleine Änderungen an Dateinamen, Markerdateien oder dem Schreibzeitpunkt können die Kommunikation zwischen EEP und Web-Server blockieren.

### Zu breite Remote-Freigaben

Änderungen an `AkCommandExecutor` können die Remote-Angriffsoberfläche vergrößern. Neue freigegebene Funktionen sollten bewusst und restriktiv eingetragen werden.

### Seiteneffekte durch globale Überschreibungen

`AkWebServerIo` ersetzt globale Funktionen wie `print`, `warn`, `error` und `assert`. Änderungen dort betreffen die internen Lua-Funktionen von EEP und dessen ganzes Lua-System.

### Collector-Kopplung

Wenn Collector neue Datentypen oder nicht serialisierbare Werte zurückgeben, scheitert der Export erst im Orchestrator. Fehlerursache und Fehlerort liegen dann in verschiedenen Paketen.

## Relevante Nachbarn

`ak/io` arbeitet eng mit diesen Paketen zusammen:

- `ak.core`: typischer Aufruf von `communicateWithServer(...)`
- `ak.data`, `ak.road`, `ak.public-transport`: liefern Collector und Remote-Funktionen
- `ak.util.EventBroker`: erzeugt Events, die indirekt über `EventRecorder` exportiert werden
- `ak.util.RuntimeRegistry`: sammelt Laufzeitmetriken des Kommunikationszyklus

## Empfehlung für KI-Agenten

Bei Änderungen in `ak/io` zuerst diese Fragen beantworten:

1. Betrifft die Änderung das Dateihandshake, die Befehlsausführung oder nur Logging?
2. Welche andere Seite spricht dasselbe Protokoll mit, insbesondere Web-Server oder Web-App?
3. Wird ein globales Verhalten wie `print` oder `assert` geändert?
4. Kann die Änderung dazu führen, dass Collector oder Remote-Funktionen erst zur Laufzeit scheitern?
5. Muss die Beschreibung in [README.md](./README.md) oder [exchange/README.md](./exchange/README.md) mit angepasst werden?
