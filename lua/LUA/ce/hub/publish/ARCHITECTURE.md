# Architektur `ce.hub.publish`

## Zweck

Dieses Paket kapselt die Erzeugung und Verteilung von externen Datenänderungen innerhalb der Lua-Bibliothek.

Es hat vier Kernaufgaben:

- Vereinheitlichung der Änderungsereignisse für externe Daten
- Verteilung dieser Ereignisse an registrierte Listener
- Bereitstellung einer kleinen API für Produzenten von Datenänderungen
- Initiales Auslösen eines vollständigen Resets für nachgelagerte Empfänger

Die Nutzungsdokumentation liegt derzeit im Code selbst und in den aufrufenden Collectoren. Diese Datei beschreibt die interne Struktur und Verantwortlichkeiten.

## Alle Lua-Dateien in `ce/hub/publish`

Im Verzeichnis `ce/hub/publish` existieren aktuell genau diese Lua-Dateien:

- [DataChangeBus.lua](./DataChangeBus.lua)

## Architekturübersicht

Das Paket ist bewusst klein gehalten:

1. `DataChangeBus` definiert die Eventtypen
2. `DataChangeBus` nimmt Datenänderungen aus anderen Paketen entgegen
3. `DataChangeBus` verteilt diese Änderungen an alle registrierten Listener
4. `ServerEventBuffer` aus `ce.databridge` zeichnet die verteilten Ereignisse für den späteren Export auf

Wichtig: `ce.hub.publish` enthält keine Fachdaten und keine Dateiausgabe. Es ist nur die interne Drehscheibe für Änderungsereignisse.

## Bausteine

### [DataChangeBus.lua](./DataChangeBus.lua)

Zentrale Ereignisverteiler-Schicht des Pakets.

Verantwortlichkeiten:

- Definition der unterstützten Eventtypen
- Verwaltung registrierter Listener
- Erzeugen einheitlicher Eventobjekte mit `eventCounter`, `type` und `payload`
- Verteilung der erzeugten Eventobjekte an alle Listener
- Bereitstellung spezialisierter Hilfsfunktionen für `DataAdded`, `DataChanged`, `DataRemoved` und `ListChanged`
- Auslösen eines initialen `CompleteReset` beim Laden des Moduls

Wichtig:

- `DataChangeBus` soll die Inhalte von `room`, `keyId`, `element` oder `list` nicht fachlich kennen oder interpretieren
- diese Felder werden nur validiert und an Listener weitergereicht
- `room` und `keyId` duerfen von DtoFactories an den Aufrufpunkt geliefert werden; der Bus bleibt trotzdem generisch
- der einzige Eventtyp, dessen Bedeutung und Payload hier bewusst bekannt sind, ist `CompleteReset`

Unterstützte Eventtypen:

- `CompleteReset`
- `DataAdded`
- `DataChanged`
- `DataRemoved`
- `ListChanged`

Erwartetes Listener-Interface:

- `fireEvent(event)`

## Laufzeitfluss

Der reguläre Ablauf für eine Datenänderung ist:

1. Ein Paket wie `ce.hub.data`, `ce.hub`, `ce.mods.road` oder `ce.mods.transit` ruft eine der fire-Methoden von `DataChangeBus` auf, oft direkt mit Mehrfachrueckgaben einer DtoFactory
2. `DataChangeBus` validiert die Mindeststruktur der Eingabedaten
3. `DataChangeBus` erhöht den internen `eventCounter`
4. `DataChangeBus` erzeugt ein Eventobjekt mit Typ und Payload
5. Alle registrierten Listener erhalten dieses Event über `fireEvent(...)`
6. `ServerEventBuffer` aus `ce.databridge` puffert das Event für den späteren Export

Zusätzlich wird beim Laden des Moduls einmal ein `CompleteReset` erzeugt, damit nachgelagerte Empfänger ihren Zustand vollständig neu aufbauen können.

## Datenmodell

Jedes verteilte Event besitzt:

- `eventCounter`: fortlaufende Nummer
- `type`: Ereignistyp
- `payload`: fachliche Nutzdaten

Die häufigsten Payload-Formen sind:

- Einzelobjekt mit `room`, `keyId` und `element`
- Listenänderung mit `room`, `keyId` und `list`
- Reset-Hinweis mit reinem Info-Inhalt

Bei Einzelobjekten ist zusaetzlich ein Aufrufstil mit `room`, `keyId`, `key`, `element` erlaubt. Der Bus stellt dann sicher, dass das Element den Schluessel fuer nachgelagerte Listener enthaelt.

## Zustand

### Prozessweiter Zustand

`DataChangeBus` hält:

- die Menge aller registrierten Listener
- den fortlaufenden `eventCounter`
- die statische Definition der Eventtypen
- optional einen Debug-Listener für Konsolenausgaben

### Persistenz

Das Paket nutzt keine `StorageUtility`-Persistenz. Sein Zustand ist absichtlich flüchtig und lebt in:

- Lua-Modulvariablen
- den weitergereichten Eventobjekten

## Wichtige Invarianten

- Listener müssen eine Methode `fireEvent(event)` besitzen.
- `eventCounter` muss pro erzeugtem Event genau einmal erhöht werden.
- `fireDataChanged`, `fireDataAdded` und `fireDataRemoved` erwarten ein `element`, das den Schluessel `keyId` enthaelt oder zusammen mit einem separaten `key` geliefert wird.
- `fireListChange` erwartet, dass jedes Listenelement den Schlüssel `keyId` enthält.
- `room`, `keyId`, `element` und `list` bleiben fachlich opaque; das Paket darf daraus keine domänenspezifische Logik ableiten.
- `CompleteReset` muss vor dem regulären Eventstrom möglich sein, damit externe Empfänger ihren Zustand sauber initialisieren können.
- `ce.hub.publish` verteilt Ereignisse nur weiter; Aufzeichnung und Ausgabe liegen außerhalb des Pakets.

## Typische Änderungsrisiken

### Protokollbruch

Schon kleine Änderungen an Eventtypen, Payload-Feldern oder dem Reset-Verhalten können den Server-seitigen Zustandsaufbau brechen.

### Zu frühe Kopplung an I/O

Wenn `DataChangeBus` beginnt, Dateiformate, JSON-Strukturen oder Serverwissen direkt zu kennen, verliert das Paket seine klare Rolle als Verteiler.

### Listener-Nebenwirkungen

Listener werden synchron im selben Lauf aufgerufen. Ein fehlerhafter oder langsamer Listener kann deshalb den gesamten Änderungsfluss beeinflussen.

### Reset-Verhalten

Änderungen am initialen `CompleteReset` wirken sich auf Neustarts, Reconnects und den Wiederaufbau des externen Zustands aus.

## Relevante Nachbarn

`ce.hub.publish` arbeitet eng mit diesen Paketen zusammen:

- `ce.databridge`: `ServerEventBuffer` zeichnet die verteilten Ereignisse auf
- `ce.hub`, `ce.hub.data`, `ce.mods.road`, `ce.mods.transit`, `ce.rail`: erzeugen Datenänderungen
- `ce.hub.util.TableUtils`: unterstützt die Debug-Ausgabe für Listen

## Empfehlung für KI-Agenten

Bei Änderungen in `ce.hub.publish` zuerst diese Fragen beantworten:

1. Betrifft die Änderung nur die interne Benennung oder das externe Änderungsprotokoll?
2. Verändert sich die Struktur eines Events oder nur die Erzeugungsstelle?
3. Müssen Listener außerhalb des Pakets angepasst werden, insbesondere `ServerEventBuffer` oder der Web-Server?
4. Bleibt das Reset-Verhalten beim Start weiterhin konsistent?
5. Ist die Änderung wirklich im Eventsystem richtig aufgehoben oder gehört sie in einen Producer oder Listener?
