# Architektur `ak.events`

## Zweck

Dieses Paket kapselt die Erzeugung und Verteilung von externen Datenänderungen innerhalb der Lua-Bibliothek.

Es hat vier Kernaufgaben:

- Vereinheitlichung der Änderungsereignisse für externe Daten
- Verteilung dieser Ereignisse an registrierte Listener
- Bereitstellung einer kleinen API für Produzenten von Datenänderungen
- Initiales Auslösen eines vollständigen Resets für nachgelagerte Empfänger

Die Nutzungsdokumentation liegt derzeit im Code selbst und in den aufrufenden Collectoren. Diese Datei beschreibt die interne Struktur und Verantwortlichkeiten.

## Alle Lua-Dateien in `ak/events`

Im Verzeichnis `ak/events` existieren aktuell genau diese Lua-Dateien:

- [DataChangeBus.lua](./DataChangeBus.lua)

## Architekturübersicht

Das Paket ist bewusst klein gehalten:

1. `DataChangeBus` definiert die Eventtypen
2. `DataChangeBus` nimmt Datenänderungen aus anderen Paketen entgegen
3. `DataChangeBus` verteilt diese Änderungen an alle registrierten Listener
4. `ServerEventBuffer` aus `ak.io` zeichnet die verteilten Ereignisse für den späteren Export auf

Wichtig: `ak/events` enthält keine Fachdaten und keine Dateiausgabe. Es ist nur die interne Drehscheibe für Änderungsereignisse.

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
- diese Felder werden nur validiert und unverändert an Listener weitergereicht
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

1. Ein Paket wie `ak.data`, `ak.road`, `ak.core` oder `ak.public-transport` ruft eine der fire-Methoden von `DataChangeBus` auf
2. `DataChangeBus` validiert die Mindeststruktur der Eingabedaten
3. `DataChangeBus` erhöht den internen `eventCounter`
4. `DataChangeBus` erzeugt ein Eventobjekt mit Typ und Payload
5. Alle registrierten Listener erhalten dieses Event über `fireEvent(...)`
6. `ServerEventBuffer` aus `ak.io` puffert das Event für den späteren Export

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
- `fireDataChanged`, `fireDataAdded` und `fireDataRemoved` erwarten ein `element`, das den Schlüssel `keyId` enthält.
- `fireListChange` erwartet, dass jedes Listenelement den Schlüssel `keyId` enthält.
- `room`, `keyId`, `element` und `list` bleiben fachlich opaque; das Paket darf daraus keine domänenspezifische Logik ableiten.
- `CompleteReset` muss vor dem regulären Eventstrom möglich sein, damit externe Empfänger ihren Zustand sauber initialisieren können.
- `ak/events` verteilt Ereignisse nur weiter; Aufzeichnung und Ausgabe liegen außerhalb des Pakets.

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

`ak/events` arbeitet eng mit diesen Paketen zusammen:

- `ak.io`: `ServerEventBuffer` zeichnet die verteilten Ereignisse auf
- `ak.core`, `ak.data`, `ak.road`, `ak.public-transport`, `ak.train`: erzeugen Datenänderungen
- `ak.util.TableUtils`: unterstützt die Debug-Ausgabe für Listen

## Empfehlung für KI-Agenten

Bei Änderungen in `ak/events` zuerst diese Fragen beantworten:

1. Betrifft die Änderung nur die interne Benennung oder das externe Änderungsprotokoll?
2. Verändert sich die Struktur eines Events oder nur die Erzeugungsstelle?
3. Müssen Listener außerhalb des Pakets angepasst werden, insbesondere `ServerEventBuffer` oder der Web-Server?
4. Bleibt das Reset-Verhalten beim Start weiterhin konsistent?
5. Ist die Änderung wirklich im Eventsystem richtig aufgehoben oder gehört sie in einen Producer oder Listener?
