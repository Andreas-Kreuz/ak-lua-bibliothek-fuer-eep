# Architektur `ak.road`

## Zweck

Dieses Paket kapselt die fachliche Logik fuer Ampeln, Fahrspuren und automatisch gesteuerte Kreuzungen in EEP.

Es hat sechs Kernaufgaben:

- Modellierung von Ampeltypen und konkreten Ampeln
- Verwaltung von Fahrspuren, Anforderungen und Warteschlangen
- Berechnung der naechsten Kreuzungsschaltung anhand von Prioritaeten oder manueller Vorgabe
- Ausfuehrung des zeitlichen Schaltablaufs ueber den Scheduler
- Bereitstellung von JSON-Daten fuer Web-Server und Web-App
- Anbindung kleiner EEP-naher Hilfen wie Strassenbahnweichen und Bus-Callbacks

Die Nutzungsdokumentation fuer den fachlichen Einsatz liegt in [README.md](./README.md). Das Datenmodell der exportierten JSON-Raeume ist in [Datenmodell.md](./Datenmodell.md) beschrieben. Diese Datei beschreibt die interne Struktur und Verantwortlichkeiten.

## Alle Lua-Dateien in `ak/road`

Im Verzeichnis `ak/road` existieren aktuell genau diese Lua-Dateien:

- [AxisStructureTrafficLight.lua](./AxisStructureTrafficLight.lua)
- [Bus.lua](./Bus.lua)
- [Crossing.lua](./Crossing.lua)
- [CrossingJsonCollector.lua](./CrossingJsonCollector.lua)
- [CrossingLuaModul.lua](./CrossingLuaModul.lua)
- [CrossingSequence.lua](./CrossingSequence.lua)
- [CrossingSettings.lua](./CrossingSettings.lua)
- [CrossingWebConnector.lua](./CrossingWebConnector.lua)
- [Lane.lua](./Lane.lua)
- [LaneSettings.lua](./LaneSettings.lua)
- [LightStructureTrafficLight.lua](./LightStructureTrafficLight.lua)
- [TrafficLight.lua](./TrafficLight.lua)
- [TrafficLightModel.lua](./TrafficLightModel.lua)
- [TrafficLightModelJsonCollector.lua](./TrafficLightModelJsonCollector.lua)
- [TrafficLightState.lua](./TrafficLightState.lua)
- [TramSwitch.lua](./TramSwitch.lua)

Hinweis:

- `LaneSettings.lua` ist aktuell nur ein kleiner Hilfstyp und nicht der zentrale Laufzeitpfad des Pakets.
- `Bus.lua` und `TramSwitch.lua` sind fachlich benachbarte EEP-Helfer, aber nicht Teil des Kernflusses einer automatisch geschalteten Kreuzung.

## Architekturuebersicht

Das Paket ist bewusst in drei Schichten aufgebaut:

1. Konfigurations- und Domaenenschicht mit `TrafficLightModel`, `TrafficLight`, `Lane`, `CrossingSequence` und `Crossing`
2. Laufzeit- und Integrationsschicht mit `CrossingLuaModul`, `CrossingSettings`, `TramSwitch` und `Bus`
3. Web-Export- und Remote-Schicht mit `CrossingWebConnector`, `CrossingJsonCollector` und `TrafficLightModelJsonCollector`

Der regulaere Daten- und Steuerfluss sieht fachlich so aus:

1. Anwendercode legt Ampelmodelle, Ampeln, Fahrspuren, Schaltungen und Kreuzungen an
2. `CrossingLuaModul.init()` verdrahtet Web-Connector und initialisiert die Sequenzen
3. `CrossingLuaModul.run()` ruft zyklisch `Crossing.switchSequences()` auf
4. `Crossing` waehlt pro Kreuzung die naechste Schaltung und plant den Umschaltablauf ueber `Scheduler`
5. `TrafficLight` setzt Signalstellungen, Lichtimmobilien, Achsen und Tipptexte in EEP um
6. Die JSON-Collector exportieren den aktuellen Zustand ueber `DataChangeBus` an `ak.io`

Wichtig: `ak/road` ist kein reines Datenpaket. Es enthaelt zustandsbehaftete Fachobjekte, Persistenz von Fahrspur- und Anzeigezustand und direkte EEP-Aufrufe.

## Bausteine

### [CrossingLuaModul.lua](./CrossingLuaModul.lua)

Moduleinstieg fuer das Kreuzungspaket.

Verantwortlichkeiten:

- Registrierung des Pakets bei `ak.core.ModuleRegistry`
- Nachziehen der Scheduler-Abhaengigkeit ueber `ak.scheduler.SchedulerLuaModule`
- einmalige Initialisierung des Web-Connectors
- Aufruf von `Crossing.initSequences()` nach Abschluss der Konfiguration
- zyklischer Aufruf von `Crossing.switchSequences()`

`CrossingLuaModul` ist die vorgesehene Einstiegsschicht fuer den regulaeren Betrieb in `EEPMain()`.

### [Crossing.lua](./Crossing.lua)

Zentrales Fachobjekt fuer eine Kreuzung.

Verantwortlichkeiten:

- Verwaltung aller Kreuzungen in `Crossing.allCrossings`
- Halten der Schaltungen, Fahrspuren, Ampeln und optionalen Kameras einer Kreuzung
- Umschalten zwischen Automatikmodus und manueller Schaltung
- Berechnung der naechsten Schaltung anhand manueller Vorgabe, strikter Reihenfolge oder Prioritaetsvergleich
- Planung des Schaltablaufs ueber `Task` und `Scheduler`
- Aktualisierung von Tooltip-Texten fuer Signale und Strukturen
- Sammel-Reset aller Fahrspuren ueber `Crossing.resetVehicles()`

Wichtige Zustandsfelder pro Kreuzung:

- `currentSequence`
- `manualSequence`
- `nextSequence`
- `greenPhaseReached`
- `greenPhaseFinished`
- `greenPhaseSeconds`
- `lanes`
- `trafficLights`
- `staticCams`
- `tippStructure`

`Crossing` ist damit die eigentliche Orchestrierung der Verkehrslogik im Paket.

### [CrossingSequence.lua](./CrossingSequence.lua)

Fachobjekt fuer eine Schaltung innerhalb einer Kreuzung.

Verantwortlichkeiten:

- Gruppierung von Ampeln nach Typ (`CAR`, `TRAM`, `PEDESTRIAN`, ...)
- Ableitung der zugehoerigen Fahrspuren aus den registrierten Ampeln
- Vergleich alter und neuer Schaltung
- Berechnung der Umschalt-Tasks von Rot/Gelb/Gruen/Fussgaengerphasen
- Berechnung und Zwischenspeicherung der Schaltungsprioritaet

Wichtige Fachlogik:

- `trafficLightsToTurnRedAndGreen(oldSequence)` bestimmt, welche Ampeln ihren Zustand aendern muessen
- `tasksForSwitchingFrom(oldSequence, afterRedTask)` erzeugt die Taskfolge fuer den Scheduler
- `lanesSortedByPriority()` bestimmt die aktuelle Prioritaet der Schaltung ueber die zugehoerigen Fahrspuren
- `sequencePriorityComparator(...)` vergleicht zwei Schaltungen fuer die automatische Auswahl

### [Lane.lua](./Lane.lua)

Zustandsbehaftetes Fachobjekt fuer eine Fahrspur.

Verantwortlichkeiten:

- Verwaltung von Fahrzeugwarteschlange, Fahrzeuganzahl und Wartezyklen
- Persistenz des Fahrspurzustands ueber `StorageUtility`
- Ermittlung von Anforderungen ueber Kontaktpunkte, Signale oder Strassentracks
- Berechnung von Fahrspurprioritaeten fuer Schaltungen
- Zuordnung zusaetzlicher Anforderungsampeln ueber Routen
- Spiegelung des Fahrzustands auf das sichtbare Fahrspursignal

Wichtige Betriebsarten fuer Anforderungen:

- gezaehlte Fahrzeuge ueber `vehicleEntered(...)` / `vehicleLeft(...)`
- Signalabfrage ueber `useSignalForQueue()`
- Track-Reservierung ueber `useTrackForQueue(roadId)`

Persistierte Felder pro Fahrspur:

- `f`: Fahrzeuganzahl
- `w`: Anzahl verpasster Gruenzyklen
- `p`: letzte Phase
- `q`: Warteschlange als Pipe-getrennter String

Wichtig: `StorageUtility.saveTable()` und `loadTable()` arbeiten nur mit String-Werten. Deshalb serialisiert `Lane` Zahlen und Status explizit als String.

### [TrafficLight.lua](./TrafficLight.lua)

Fachobjekt fuer eine konkrete Ampelinstanz.

Verantwortlichkeiten:

- Verknuepfung einer EEP-Signal-ID mit einem `TrafficLightModel`
- Halten der aktuellen Phase und des zugehoerigen Grundes
- Schalten des EEP-Signals ueber `EEPSetSignal(...)`
- Schalten zusaetzlicher Lichtimmobilien ueber `EEPStructureSetLight(...)`
- Schalten zusaetzlicher Achsimmobilien ueber `EEPStructureSetAxis(...)`
- Verteilung von Zustandsaenderungen an zugeordnete Fahrspuren
- Aufbau und Anzeige von Tipptexten an Signalen oder Strukturen

Besonderheiten:

- negative `signalId`-Werte werden fuer logisch verwaltete, nicht direkt in EEP schaltbare Signale verwendet
- `lightStructures` und `axisStructures` sind additive Erweiterungen zu normalen EEP-Signalen
- `showRequestOnSignal(...)` koppelt Fahrspuranforderungen an Zusatz-Immobilien

### [TrafficLightModel.lua](./TrafficLightModel.lua)

Definition eines Ampeltyps.

Verantwortlichkeiten:

- Zuordnung zwischen fachlichen Phasen und EEP-Signalstellungen
- Rueckabbildung von Signalstellungen auf fachliche Phasen
- Registrierung aller Modelle in `TrafficLightModel.allModels`
- Bereitstellung vordefinierter Standardmodelle fuer verbreitete EEP-Ampelsets

Das Modell ist absichtlich statisch und leichtgewichtig. Fachzustand liegt in `TrafficLight`, nicht in `TrafficLightModel`.

### [TrafficLightState.lua](./TrafficLightState.lua)

Kleine Konstanten- und Hilfsschicht fuer Ampelphasen.

Verantwortlichkeiten:

- Definition der fachlichen Phasenbezeichner
- Hilfsfunktion `canDrive(phase)` fuer Freigabephasen

### [CrossingSettings.lua](./CrossingSettings.lua)

Paketweite Anzeige- und Diagnoseeinstellungen.

Verantwortlichkeiten:

- Laden und Speichern globaler Kreuzungseinstellungen ueber `StorageUtility`
- Halten der boole'schen Flags fuer Signalinfos und Strukturinfos
- Bereitstellung von Setter-Funktionen, die auch per Remote-Kommando aufrufbar sind

Aktuelle Settings:

- `showRequestsOnSignal`
- `showSequenceOnSignal`
- `showSignalIdOnSignal`
- `showLanesOnStructure`

### [CrossingWebConnector.lua](./CrossingWebConnector.lua)

Web-Adapter des Pakets.

Verantwortlichkeiten:

- Registrierung der JSON-Collector beim `ServerController`
- Registrierung der erlaubten Remote-Funktionen fuer Web-App und Web-Server

Registrierte Remote-Funktionen:

- `CrossingSettings.setShowRequestsOnSignal`
- `CrossingSettings.setShowSequenceOnSignal`
- `CrossingSettings.setShowSignalIdOnSignal`
- `CrossingSettings.setShowLanesOnStructure`
- `AkKreuzungSchalteAutomatisch`
- `AkKreuzungSchalteManuell`

### [CrossingJsonCollector.lua](./CrossingJsonCollector.lua)

JSON-Collector fuer den aktuellen Kreuzungszustand.

Verantwortlichkeiten:

- Export aller Kreuzungen, Schaltungen, Fahrspuren, Ampeln und Moduleinstellungen
- Normalisierung einiger interner Werte fuer die Web-API
- Sortierung der Kreuzungen und Fahrspuren fuer stabile Ausgaben
- Emission der Daten ueber `DataChangeBus.fireListChange(...)`

Exportierte Raeume:

- `intersections`
- `intersection-lanes`
- `intersection-switchings`
- `intersection-traffic-lights`
- `intersection-module-settings`

Wichtig: Der Collector berechnet die Nutzdaten und feuert Events, liefert aber aktuell absichtlich kein direktes Nutzdatenobjekt an `ServerController.collectData()` zurueck.

### [TrafficLightModelJsonCollector.lua](./TrafficLightModelJsonCollector.lua)

JSON-Collector fuer statische Ampelmodelle.

Verantwortlichkeiten:

- Export aller registrierten `TrafficLightModel`-Definitionen
- Emission des Raums `signal-type-definitions` ueber `DataChangeBus`

### [AxisStructureTrafficLight.lua](./AxisStructureTrafficLight.lua)

Wertobjekt fuer Achsimmobilien einer Ampel.

Verantwortlichkeiten:

- Validierung der Struktur- und Achsenkonfiguration
- Halten der Zielpositionen pro Ampelphase

### [LightStructureTrafficLight.lua](./LightStructureTrafficLight.lua)

Wertobjekt fuer Lichtimmobilien einer Ampel.

Verantwortlichkeiten:

- Validierung der Strukturkonfiguration
- Halten der Strukturzuordnung fuer Rot, Gelb, Gruen und Anforderung

### [TramSwitch.lua](./TramSwitch.lua)

Kleiner EEP-Helfer fuer Strassenbahnweichen.

Verantwortlichkeiten:

- Registrierung einer Strassenbahnweiche in EEP
- Anlegen des globalen Callbacks `EEPOnSwitch_<switchId>`
- Spiegelung der Weichenstellung auf Lichtimmobilien

### [Bus.lua](./Bus.lua)

Kleiner EEP-Helfer fuer Busachsen.

Verantwortlichkeiten:

- Oeffnen und Schliessen typischer Bustueren
- Initialisieren von Fahrer- und Fahrgastachsen
- Bereitstellung des globalen EEP-Callbacks `FAHRZEUG_INITIALISIERE`

### [LaneSettings.lua](./LaneSettings.lua)

Kleiner Hilfstyp fuer Fahrspureinstellungen.

Verantwortlichkeiten:

- Binden einer Fahrspur an Richtungen, Routen und `requestType`
- Halten eines `vehicleMultiplier`

Hinweis: Dieses Objekt spielt im aktuellen Kernlauf des Pakets nur eine Nebenrolle und wird nicht vom Web-Export verwendet.

## Laufzeitfluss

Der regulaere Ablauf fuer eine automatisch geschaltete Kreuzung ist:

1. Anwendercode erzeugt `TrafficLightModel`, `TrafficLight`, `Lane`, `CrossingSequence` und `Crossing`
2. Fahrspuren werden ueber ihre Fahrspurampel mit `TrafficLight:applyToLane(...)` verdrahtet
3. Sequenzen registrieren die betroffenen Ampeln ueber `addCarLights(...)`, `addTramLights(...)` oder `addPedestrianLights(...)`
4. `CrossingLuaModul.init()` registriert Web-Collector und Remote-Funktionen
5. `Crossing.initSequences()` leitet aus allen Sequenzen die effektiven Fahrspur- und Ampelzuordnungen der Kreuzung ab
6. `CrossingLuaModul.run()` ruft zyklisch `Crossing.switchSequences()` auf
7. `Crossing.switchSequences()` waehlt pro Kreuzung die naechste Schaltung und ruft intern `switch(crossing)` auf
8. `CrossingSequence:tasksForSwitchingFrom(...)` erzeugt den zeitlichen Umschaltplan
9. `Scheduler:scheduleTask(...)` fuehrt die Teilumschaltungen versetzt aus
10. `TrafficLight.switchAll(...)` und `TrafficLight:switchTo(...)` setzen EEP-Signalstellungen, Lichtimmobilien und Achsen
11. `Crossing` aktualisiert Signaltooltips, Fahrspurinfo und optionale Strukturtooltips
12. In Exportzyklen erzeugen die JSON-Collector den Web-Zustand ueber `DataChangeBus`

Der regulaere Ablauf fuer Anforderungen in einer Fahrspur ist:

1. Ein Fahrzeug wird per Kontaktpunkt, Signalabfrage oder Trackabfrage erkannt
2. `Lane` aktualisiert Warteschlange, Fahrzeuganzahl und gegebenenfalls die erste Route
3. `Lane:checkRequests()` baut den Anforderungstext neu auf
4. `refreshRequests(...)` informiert alle verknuepften Anforderungsampeln
5. `updateLaneSignal(...)` prueft, ob die Fahrspur anhand der gueltigen Ampeln fahren darf
6. Der Fahrspurzustand wird in `StorageUtility` gespeichert

## Zustand

### Prozessweiter Zustand

`Crossing` haelt:

- alle bekannten Kreuzungen in `Crossing.allCrossings`
- pro Kreuzung Schaltungen, Fahrspuren, Ampeln, Kameras und Tooltipstruktur
- den Umschaltzustand ueber `currentSequence`, `nextSequence`, `manualSequence`, `greenPhaseReached` und `greenPhaseFinished`

`CrossingSequence` haelt:

- die zugeordneten Ampeln mit Typ
- die aus den Ampeln abgeleiteten Fahrspuren
- die aktuelle mittlere Prioritaet `prio`

`Lane` haelt:

- Fahrzeuganzahl
- Warteschlange
- verpasste Gruenzyklen
- aktuelle Phase
- Anforderungsmodus und optionale Routenfilter
- Track- und Signalzaehlkonfiguration

`TrafficLight` haelt:

- Signal-ID und Modell
- aktuelle Phase und Begruendung
- registrierte Fahrspuren
- Licht- und Achsimmobilien
- vorbereitete Tooltiptexte

`TrafficLightModel` haelt:

- die statischen Signalindex-Zuordnungen je Modell
- die globale Liste aller Modelle

`CrossingSettings` haelt:

- die vier globalen Anzeigeflags
- optional den Persistenzslot `saveSlot`

### Persistenz

Das Paket nutzt zwei Persistenzformen:

- `Lane` speichert seinen Laufzeitzustand pro Fahrspur ueber `StorageUtility`
- `CrossingSettings` speichert die globalen Anzeigeeinstellungen ueber `StorageUtility`

Persistiert werden nur String-Werte. Deshalb werden Zahlen, Booleans und Warteschlangen vor dem Speichern serialisiert.

Nicht persistent sind insbesondere:

- die Menge aller Kreuzungen
- die Zuordnung von Sequenzen zu Kreuzungen
- statische Kameranamen
- die registrierten Web-Collector und Remote-Funktionen

## Wichtige Invarianten

- Jede `Lane` hat genau eine sichtbare Fahrspurampel `trafficLight`.
- Eine `CrossingSequence` darf nur `TrafficLight`-Objekte enthalten.
- Eine Kreuzung kann fachlich nur eine aktuelle Schaltung gleichzeitig haben.
- `Crossing.initSequences()` muss nach Abschluss der Konfiguration laufen, bevor `switchSequences()` sinnvoll arbeitet.
- `CrossingSequence:initSequence()` erwartet, dass Ampeln bereits ihre Fahrspuren kennen.
- `Lane` und `CrossingSettings` duerfen in `StorageUtility` nur String-Werte ablegen.
- Negative `signalId`-Werte bedeuten logisch verwaltete Signale; `TrafficLight:switchSignal(...)` setzt in diesem Fall kein EEP-Signal.
- `lightStructures` und `axisStructures` muessen auf existierende EEP-Strukturen bzw. Achsen verweisen; die Hilfsklassen validieren das sofort.
- Die Remote-Kommandos fuer Kreuzungen duerfen nur ueber `CrossingWebConnector.registerFunctions()` freigegeben werden.
- JSON-Collector muessen ihre Schluesselfelder (`id` oder `name`) fuer jedes exportierte Element konsistent setzen.

## Typische Aenderungsrisiken

### Inkonsistenter Umschaltablauf

Schon kleine Aenderungen in `CrossingSequence:tasksForSwitchingFrom(...)` koennen den zeitlichen Ablauf zwischen Rot, Gelb, Rot-Gelb und Gruen fachlich brechen.

### Verlorene Persistenz

Aenderungen an `Lane.save/load` oder `CrossingSettings.save/load` koennen bestehende Anlagenzustaende unlesbar machen oder boolesche Werte falsch interpretieren.

### Falsche Fahrspurzuteilung

Wenn `Crossing.initSequences()` oder `TrafficLight:applyToLane(...)` geaendert wird, kann die Prioritaetsberechnung falsche Fahrspuren einer Schaltung zuordnen.

### Nebenwirkungen in EEP

`TrafficLight`, `TramSwitch` und `Bus` rufen direkt `EEPSetSignal`, `EEPStructureSetLight`, `EEPStructureSetAxis`, `EEPShowInfoSignal` oder `EEPSetTrainAxis` auf. Fehler wirken sich sofort sichtbar in EEP aus.

### Web-API-Drift

Aenderungen an den JSON-Collectoren koennen den Web-Server-State und die Consumer in der Web-App brechen, insbesondere bei Raum- oder Feldnamen.

### Globale Callback-Kollisionen

`TramSwitch` und `Bus` registrieren globale EEP-Callbacks. Aenderungen an Namensschema oder Signatur koennen mit anderen Paketen kollidieren.

## Relevante Nachbarn

`ak/road` arbeitet eng mit diesen Paketen zusammen:

- `ak.core`: `ModuleRegistry` initialisiert und betreibt `CrossingLuaModul`
- `ak.scheduler`: fuehrt den zeitlichen Schaltablauf aus
- `ak.io`: registriert JSON-Collector und Remote-Funktionen fuer Web-Server und Web-App
- `ak.events`: nimmt die von den Collectoren erzeugten `ListChanged`-Events entgegen
- `ak.storage`: speichert Fahrspur- und Einstellungszustand
- `ak.util.Queue`: bildet die Warteschlangen der Fahrspuren ab
- `ak.core.eep.TippTextFormatter`: baut die Tooltiptexte fuer Signale und Strukturen

## Empfehlung fuer KI-Agenten

Bei Aenderungen in `ak/road` zuerst diese Fragen beantworten:

1. Betrifft die Aenderung nur einen Datenausgabe-Collector oder auch die fachliche Schaltlogik?
2. Wird damit bestehender zustandsbehafteter Laufzeit- oder Persistenzcode veraendert?
3. Muss die Web-App oder das Datenmodell in [Datenmodell.md](./Datenmodell.md) mit angepasst werden?
4. Greift die Aenderung in EEP-nahe Aufrufe oder globale Callbacks ein?
5. Bleibt der Schaltablauf zwischen alter und neuer Sequenz fachlich korrekt und zeitlich vollstaendig?
