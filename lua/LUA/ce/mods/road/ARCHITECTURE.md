# Architektur `ce.mods.road`

## Zweck

Dieses Paket kapselt die fachliche Logik für Straßenampeln, Fahrspuren und automatisch geschaltete Kreuzungen in EEP. Es ist kein reines Datenmodell, sondern kombiniert Konfiguration, zustandsbehaftete Laufzeitobjekte, Persistenz und direkte EEP-Aufrufe.

Die Kernaufgaben sind aktuell:

- Modellierung von Ampeltypen und konkreten Ampelinstanzen
- Verwaltung von Fahrspuren, Warteschlangen und Anforderungen
- Auswahl und zeitliche Ausführung der nächsten Kreuzungsschaltung
- Pflege von Tipptexten an Signalen und optionalen Strukturen
- Export des Zustands für Web-Server und Web-App
- Bereitstellung kleiner EEP-naher Hilfen wie Straßenbahnweichen und Bus-Callbacks

Die Nutzungsdokumentation für den fachlichen Einsatz liegt in [README.md](./README.md). Das Datenmodell der exportierten Web-Räume ist in [DTO.md](./DTO.md) beschrieben. Diese Datei beschreibt die interne Struktur und den aktuellen Ist-Zustand des Pakets.

## Dateien in `ce/mods/road`

Das Paket ist jetzt in drei Bereiche gegliedert:

- Top-Level:
  [AxisStructureTrafficLight.lua](./AxisStructureTrafficLight.lua),
  [Bus.lua](./Bus.lua),
  [Intersection.lua](./Intersection.lua),
  [RoadCeModule.lua](./RoadCeModule.lua),
  [IntersectionSequence.lua](./IntersectionSequence.lua),
  [IntersectionSettings.lua](./IntersectionSettings.lua),
  [Lane.lua](./Lane.lua),
  [LaneSettings.lua](./LaneSettings.lua),
  [LightStructureTrafficLight.lua](./LightStructureTrafficLight.lua),
  [TrafficLight.lua](./TrafficLight.lua),
  [TrafficLightModel.lua](./TrafficLightModel.lua),
  [TrafficLightState.lua](./TrafficLightState.lua),
  [TramSwitch.lua](./TramSwitch.lua)
- [data/](./data/):
  [RoadDataCollector.lua](./data/RoadDataCollector.lua),
  [RoadDtoFactory.lua](./data/RoadDtoFactory.lua),
  [RoadStatePublisher.lua](./data/RoadStatePublisher.lua),
  [TrafficLightModelDtoFactory.lua](./data/TrafficLightModelDtoFactory.lua),
  [TrafficLightModelStatePublisher.lua](./data/TrafficLightModelStatePublisher.lua),
  [TrafficLightModelsDataCollector.lua](./data/TrafficLightModelsDataCollector.lua),
  [RoadDtoTypes.d.lua](./data/RoadDtoTypes.d.lua),
  [RoadDtoTypes.d.md](./data/RoadDtoTypes.d.md)
- [bridge/](./bridge/):
  [RoadBridgeConnector.lua](./bridge/RoadBridgeConnector.lua)

Wichtige Einordnung:

- `LaneSettings.lua` ist derzeit nur ein kleiner Hilfstyp und kein zentraler Teil des regulären Laufzeitpfads.
- `Bus.lua` und `TramSwitch.lua` sind EEP-Helfer im selben Themenfeld, aber nicht Teil des eigentlichen Kreuzungs-Schedulers.

## Architekturüberblick

Das Paket besteht aktuell aus fünf funktionalen Bereichen:

1. Domänenmodell: `TrafficLightState`, `TrafficLightModel`, `TrafficLight`, `Lane`, `IntersectionSequence`, `Intersection`
2. Modul- und Laufzeitintegration: `RoadCeModule`, `IntersectionSettings`
3. Datenexport: `RoadDataCollector`, `TrafficLightModelsDataCollector`, `RoadDtoFactory`, `TrafficLightModelDtoFactory`
4. Web-Anbindung: `RoadStatePublisher`, `TrafficLightModelStatePublisher`, `RoadBridgeConnector`
5. EEP-Helfer und Wertobjekte: `AxisStructureTrafficLight`, `LightStructureTrafficLight`, `TramSwitch`, `Bus`, `LaneSettings`

Der reguläre Ablauf sieht fachlich so aus:

1. Anwendercode erzeugt Modelle, Ampeln, Fahrspuren, Schaltungen und Kreuzungen.
2. `RoadCeModule.init()` registriert State-Publisher und Remote-Funktionen und ruft `Intersection.initSequences()` auf.
3. `RoadCeModule.run()` ruft zyklisch `Intersection.switchSequences()` auf.
4. `Intersection` berechnet je Kreuzung die nächste Schaltung und plant deren Ablauf über `Task` und `Scheduler`.
5. `TrafficLight` setzt Signalstellungen, Lichtimmobilien, Achsen und Tipptexte in EEP um.
6. Die Publisher senden Web-Zustände über `DataChangeBus`, die Datenbeschaffung dafür liegt in den Collectors unter `data/`.

Wichtig: Die Web-Schicht liest den Zustand aus den Fachobjekten aus, steuert aber nicht den Kernablauf. Die Umschaltlogik liegt vollständig in `Intersection`, `IntersectionSequence`, `Lane` und `TrafficLight`.

## Bausteine

### [RoadCeModule.lua](./RoadCeModule.lua)

Moduleinstieg für den regulären Betrieb in `EEPMain()`.

Verantwortlichkeiten:

- einmalige Initialisierung des Pakets
- Registrierung der State-Publisher und Remote-Funktionen über `RoadBridgeConnector`
- Aufruf von `Intersection.initSequences()` nach Abschluss der Konfiguration
- zyklischer Aufruf von `Intersection.switchSequences()`
- implizites Nachziehen der Scheduler-Abhängigkeit durch Registrierung von `ce.hub.mods.SchedulerCeModule` beim Laden der Datei

### [Intersection.lua](./Intersection.lua)

Zentrales Fachobjekt für eine Kreuzung und Haupt-Orchestrator der Verkehrslogik.

Verantwortlichkeiten:

- Verwaltung aller Kreuzungen in `Intersection.allIntersections`
- Halten von Schaltungen, Fahrspuren, Ampeln, optionalen Kameras und einer optionalen Tipptext-Struktur
- Umschalten zwischen Automatikmodus, manueller Schaltung und strikter Reihenfolge
- Berechnung der nächsten Schaltung über manuelle Vorgabe, Rundlauf oder Prioritätsvergleich
- Planung der zeitlichen Schaltfolge über `Task` und `Scheduler`
- Aktualisierung von Signal- und Struktur-Tipptexten
- Sammel-Reset aller Fahrspuren über `Intersection.resetVehicles()`

Wichtige Zustandsfelder pro Kreuzung:

- `currentSequence`
- `manualSequence`
- `nextSequence`
- `greenPhaseReached`
- `greenPhaseFinished`
- `greenPhaseSeconds`
- `switchInStrictOrder`
- `lanes`
- `trafficLights`
- `staticCams`
- `tippStructure`

Besonderheiten:

- `Intersection.initSequences()` leitet die effektiven Fahrspuren einer Kreuzung aus den registrierten Sequenzen ab.
- `Intersection.switchSequences()` aktualisiert zusätzlich die globalen Signal-ID-Tipptexte für die Signal-IDs `1..1000`, sobald sich `IntersectionSettings.showSignalIdOnSignal` ändert.
- Neben `Intersection.allIntersections` existiert dateiintern noch eine zweite Tabelle `allIntersections`, die in einigen Schleifen ebenfalls verwendet wird.

### [IntersectionSequence.lua](./IntersectionSequence.lua)

Fachobjekt für eine Schaltung innerhalb einer Kreuzung.

Verantwortlichkeiten:

- Gruppierung von Ampeln nach Typ
- Ableitung der zugehörigen Fahrspuren aus den registrierten Ampeln
- Vergleich alter und neuer Schaltung
- Erzeugung des zeitlichen Umschaltplans
- Berechnung und Zwischenspeicherung der mittleren Priorität `prio`

Wichtige Fachlogik:

- `trafficLightsToTurnRedAndGreen(oldSequence)` bestimmt, welche Ampeln ihren Typ oder Zustand wechseln
- `tasksForSwitchingFrom(oldSequence, afterRedTask)` erzeugt die Taskfolge für Rot, Gelb, Rot-Gelb, Grün und Fußgängerphasen
- `lanesSortedByPriority()` berechnet die mittlere Priorität einer Schaltung aus den zugehörigen Fahrspuren
- `sequencePriorityComparator(...)` vergleicht zwei Schaltungen für die automatische Auswahl

Aktueller Stand der Typen:

- Definiert sind `BUS`, `CAR`, `TRAM`, `PEDESTRIAN` und `BICYCLE`
- Im Kernpfad verwendet werden aktuell `CAR`, `TRAM` und `PEDESTRIAN`
- Öffentliche Helfer zum Befüllen gibt es derzeit nur für `addCarLights(...)`, `addTramLights(...)` und `addPedestrianLights(...)`

### [Lane.lua](./Lane.lua)

Zustandsbehaftetes Fachobjekt für eine Fahrspur.

Verantwortlichkeiten:

- Verwaltung von Fahrzeugwarteschlange, Fahrzeuganzahl, Wartezyklen und aktueller Fahrspurphase
- Persistenz des Fahrspurzustands über `StorageUtility`
- Ermittlung von Anforderungen über Kontaktpunkte, Signale oder reservierte Straßentracks
- Berechnung von Fahrspurprioritäten für die Schaltungswahl
- Zuordnung zusätzlicher Anforderungsampeln abhängig von Routen
- Spiegelung des Fahrzustands auf das sichtbare Fahrspursignal

Wichtige Betriebsarten für Anforderungen:

- gezählte Fahrzeuge über `vehicleEntered(...)` und `vehicleLeft(...)`
- Signalabfrage über `useSignalForQueue()`
- Track-Reservierung über `useTrackForQueue(roadId)`

Wichtige Zustandsfelder:

- `vehicleCount`
- `waitCount`
- `phase`
- `queue`
- `firstVehiclesRoute`
- `requestType`
- `trafficLightsToDriveOn`
- `requestTrafficLights`
- `signalUsedForRequest`
- `tracksUsedForRequest`

Persistierte Felder pro Fahrspur:

- `f`: Fahrzeuganzahl
- `w`: Anzahl verpasster Grünzyklen
- `p`: letzte Phase
- `q`: Warteschlange als Pipe-getrennter String

Wichtig: `StorageUtility.saveTable()` und `loadTable()` arbeiten nur mit String-Werten. `Lane` serialisiert Zahlen, Status und Warteschlangen deshalb explizit als Strings.

### [TrafficLight.lua](./TrafficLight.lua)

Fachobjekt für eine konkrete Ampelinstanz.

Verantwortlichkeiten:

- Verknüpfung einer EEP-Signal-ID mit einem `TrafficLightModel`
- Halten der aktuellen Phase
- Schalten des EEP-Signals über `EEPSetSignal(...)`
- Schalten zusätzlicher Lichtimmobilien über `EEPStructureSetLight(...)`
- Schalten zusätzlicher Achsimmobilien über `EEPStructureSetAxis(...)`
- Verteilung von Zustandsänderungen an registrierte Fahrspuren
- Aufbau und Anzeige von Tipptexten an Signalen oder Strukturen

Besonderheiten:

- negative oder nicht nutzbare Signal-IDs werden intern auf eigene negative IDs abgebildet; diese Ampeln sind logisch verwaltet und schalten kein EEP-Signal
- `lightStructures` und `axisStructures` ergänzen die eigentliche Signalsteuerung
- `applyToLane(...)` koppelt eine Ampel an Fahrspuren und nutzt intern `lane:driveOn(...)`
- `showRequestOnSignal(...)` steuert optionale Anforderungslichter an Zusatz-Immobilien
- das Feld `reason` ist zwar als Teil des Objekts vorgesehen und wird in `refreshInfo()` abgefragt, wird im aktuellen Codepfad aber nicht aktiv gesetzt

### [TrafficLightModel.lua](./TrafficLightModel.lua)

Definition eines Ampeltyps.

Verantwortlichkeiten:

- Zuordnung zwischen fachlichen Phasen und EEP-Signalstellungen
- Rückabbildung von Signalstellungen auf fachliche Phasen
- Registrierung aller Modelle in `TrafficLightModel.allModels`
- Bereitstellung vordefinierter Modelle für mehrere EEP-Ampelsets

Das Modell ist statisch und leichtgewichtig. Laufzeit- und Kreuzungszustand liegen in `TrafficLight`, `Lane`, `IntersectionSequence` und `Intersection`.

### [TrafficLightState.lua](./TrafficLightState.lua)

Konstanten- und Hilfsschicht für Ampelphasen.

Aktuelle Phasen:

- `RED`
- `REDYELLOW`
- `YELLOW`
- `GREEN`
- `GREENYELLOW`
- `PEDESTRIAN`
- `OFF`
- `OFF_BLINKING`
- `UNKNOWN`

Wichtig: `canDrive(phase)` behandelt aktuell `GREEN`, `OFF` und `OFF_BLINKING` als freigebende Zustände.

### [IntersectionSettings.lua](./IntersectionSettings.lua)

Paketweite Anzeige- und Diagnoseeinstellungen.

Verantwortlichkeiten:

- Laden und Speichern globaler Kreuzungseinstellungen über `StorageUtility`
- Halten der globalen Bool-Flags für Tipptext-Ausgaben
- Bereitstellung von Setter-Funktionen für den lokalen Code und für Remote-Aufrufe

Aktuelle Settings:

- `showRequestsOnSignal`
- `showSequenceOnSignal`
- `showSignalIdOnSignal`
- `showLanesOnStructure`

Persistenzschlüssel:

- `reqInfo`
- `seqInfo`
- `sigInfo`
- `laneInfo`

### [bridge/RoadBridgeConnector.lua](./bridge/RoadBridgeConnector.lua)

Web-Adapter des Pakets.

Verantwortlichkeiten:

- Registrierung der State-Publisher beim `StatePublisherRegistry`
- Registrierung der erlaubten Remote-Funktionen beim `ServerExchangeCoordinator`

Registrierte Remote-Funktionen:

- `IntersectionSettings.setShowRequestsOnSignal`
- `IntersectionSettings.setShowSequenceOnSignal`
- `IntersectionSettings.setShowSignalIdOnSignal`
- `IntersectionSettings.setShowLanesOnStructure`
- `AkKreuzungSchalteAutomatisch`
- `AkKreuzungSchalteManuell`

### [RoadStatePublisher.lua](./RoadStatePublisher.lua)

State-Publisher für den aktuellen Kreuzungszustand.

Verantwortlichkeiten:

- Export aller Kreuzungen, Schaltungen, Fahrspuren und Ampeln
- Export der moduleigenen Anzeigeeinstellungen
- Normalisierung interner Werte für die Web-API
- Sortierung der Kreuzungen und Fahrspuren für stabile Ausgaben
- Emission der Daten über `DataChangeBus.fireListChange(...)`

Exportierte Räume:

- `road-intersections`
- `road-intersection-lanes`
- `road-intersection-switchings`
- `road-intersection-traffic-lights`
- `road-module-settings`

Wichtig: `syncState()` baut die Nutzdaten zwar intern auf, liefert derzeit aber bewusst ein leeres Tabellenobjekt zurück. Der eigentliche Datentransport erfolgt über `DataChangeBus`.

### [TrafficLightModelStatePublisher.lua](./TrafficLightModelStatePublisher.lua)

State-Publisher für statische Ampelmodelle.

Verantwortlichkeiten:

- Export aller registrierten `TrafficLightModel`-Definitionen
- Emission des Raums `signal-type-definitions` über `DataChangeBus`

Wie bei `RoadStatePublisher` erfolgt der eigentliche Transport aktuell über Events, nicht über den Rückgabewert von `syncState()`.

### [AxisStructureTrafficLight.lua](./AxisStructureTrafficLight.lua)

Wertobjekt für Achsimmobilien einer Ampel.

Verantwortlichkeiten:

- Validierung von Strukturname, Achsname und Positionswerten
- Sofortige Prüfung der referenzierten Achse über `EEPStructureGetAxis(...)`
- Halten der Zielpositionen pro Ampelphase

### [LightStructureTrafficLight.lua](./LightStructureTrafficLight.lua)

Wertobjekt für Lichtimmobilien einer Ampel.

Verantwortlichkeiten:

- Validierung der referenzierten Lichtimmobilien über `EEPStructureGetLight(...)`
- Halten der Strukturzuordnung für Rot, Gelb, Grün und Anforderung

### [TramSwitch.lua](./TramSwitch.lua)

Kleiner EEP-Helfer für Straßenbahnweichen.

Verantwortlichkeiten:

- Registrierung einer Weiche in EEP
- Anlegen des globalen Callbacks `EEPOnSwitch_<switchId>`
- Spiegelung der Weichenstellung auf bis zu drei Lichtimmobilien

### [Bus.lua](./Bus.lua)

Kleiner EEP-Helfer für Busachsen.

Verantwortlichkeiten:

- Öffnen und Schließen typischer Bustüren
- Initialisieren von Fahrer- und Fahrgastachsen
- Bereitstellung des globalen EEP-Callbacks `FAHRZEUG_INITIALISIERE`

### [LaneSettings.lua](./LaneSettings.lua)

Kleiner Hilfstyp für Fahrspureinstellungen.

Aktuelle Rolle:

- bündelt `lane`, `directions`, `routes`, `requestType` und `vehicleMultiplier`
- wird im aktuellen Kernlauf nicht von `Intersection`, `IntersectionSequence` oder dem Web-Export verwendet

## Laufzeitfluss

Der reguläre Ablauf für eine automatisch geschaltete Kreuzung ist aktuell:

1. Anwendercode erzeugt `TrafficLightModel`, `TrafficLight`, `Lane`, `IntersectionSequence` und `Intersection`.
2. `Lane:new(...)` registriert den Save-Slot, koppelt die sichtbare Fahrspurampel an die Fahrspur und lädt gespeicherten Zustand.
3. Zusätzliche Freigabeampeln werden optional über `Lane:driveOn(...)` oder `TrafficLight:applyToLane(...)` verdrahtet.
4. Sequenzen registrieren ihre Ampeln über `addCarLights(...)`, `addTramLights(...)` und `addPedestrianLights(...)`.
5. `RoadCeModule.init()` registriert Web-Anbindung und ruft `Intersection.initSequences()` auf.
6. `Intersection.initSequences()` leitet aus allen Sequenzen die effektiven Fahrspuren und Ampeln je Kreuzung ab.
7. `RoadCeModule.run()` ruft zyklisch `Intersection.switchSequences()` auf.
8. `Intersection.switchSequences()` prüft pro Kreuzung, ob umgeschaltet werden darf, und ruft intern `switch(crossing)` auf.
9. `Intersection:calculateNextSequence()` wählt die nächste Schaltung per manueller Vorgabe, strikter Reihenfolge oder Prioritätsvergleich.
10. `IntersectionSequence:tasksForSwitchingFrom(...)` erzeugt die Taskfolge für Gelb-, Rot-, Rot-Gelb-, Grün- und Fußgängerphasen.
11. `Scheduler:scheduleTask(...)` plant die einzelnen Umschaltvorgänge.
12. `TrafficLight.switchAll(...)` und `TrafficLight:switchTo(...)` setzen Signalstellungen, Lichtimmobilien und Achsen.
13. Nach jedem Zyklus aktualisiert `Intersection` die Signal-Tipptexte und optional die Fahrspurübersicht an einer Struktur.
14. In Exportzyklen senden die State-Publisher den Web-Zustand über `DataChangeBus`.

Der reguläre Ablauf für Anforderungen in einer Fahrspur ist:

1. Ein Fahrzeug wird per Kontaktpunkt gezählt oder die Fahrspur liest ihren Zustand über Signal- oder Trackabfrage ein.
2. `Lane` aktualisiert Warteschlange, Fahrzeuganzahl und gegebenenfalls die erste Fahrzeugroute.
3. `Lane:checkRequests()` baut den Anforderungstext neu auf.
4. `refreshRequests(...)` informiert verknüpfte Anforderungsampeln.
5. `updateLaneSignal(...)` prüft anhand der freigebenden Ampeln und optionaler Routen, ob die sichtbare Fahrspurampel Grün zeigen darf.
6. Der Fahrspurzustand wird über `StorageUtility` gespeichert.

## Zustand

### Prozessweiter Zustand

`Intersection` hält:

- alle bekannten Kreuzungen in `Intersection.allIntersections`
- pro Kreuzung Sequenzen, Fahrspuren, Ampeln, Kameras und optionale Tipptext-Struktur
- den Umschaltzustand über `currentSequence`, `nextSequence`, `manualSequence`, `greenPhaseReached` und `greenPhaseFinished`

`IntersectionSequence` hält:

- die zugeordneten Ampeln mit Typ
- die daraus abgeleiteten Fahrspuren in `lanes`
- die zuletzt berechnete mittlere Priorität `prio`

`Lane` hält:

- Fahrzeuganzahl und Warteschlange
- verpasste Grünzyklen
- aktuelle Phase
- Anforderungsmodus
- optionale Routen- und Freigaberegeln
- Signal- und Trackkonfiguration

`TrafficLight` hält:

- Signal-ID und Modell
- aktuelle Phase
- registrierte Fahrspuren
- Licht- und Achsimmobilien
- vorbereitete Tooltip-Fragmente

`TrafficLightModel` hält:

- statische Signalindex-Zuordnungen je Modell
- die globale Liste aller Modelle

`IntersectionSettings` hält:

- die vier globalen Anzeigeflags
- optional den Persistenzslot `saveSlot`

### Persistenz

Das Paket nutzt aktuell zwei Persistenzformen:

- `Lane` speichert Laufzeitzustand pro Fahrspur über `StorageUtility`
- `IntersectionSettings` speichert die globalen Anzeigeeinstellungen über `StorageUtility`

Persistiert werden nur String-Werte. Deshalb serialisieren die Module Zahlen, Booleans und Warteschlangen vor dem Speichern.

Nicht persistent sind insbesondere:

- die Menge aller Kreuzungen
- die Zuordnung von Sequenzen zu Kreuzungen
- die registrierten State-Publisher und Remote-Funktionen
- statische Kameranamen und Strukturzuordnungen
- aktuelle Scheduler-Tasks

## Wichtige Invarianten

- Jede `Lane` hat genau eine sichtbare Fahrspurampel `trafficLight`.
- Eine `IntersectionSequence` darf nur `TrafficLight`-Objekte enthalten.
- `Intersection.initSequences()` muss nach Abschluss der Konfiguration laufen, bevor `switchSequences()` sinnvoll arbeitet.
- `IntersectionSequence:initSequence()` erwartet, dass die Ampeln ihre Fahrspuren bereits kennen.
- `Lane` und `IntersectionSettings` dürfen in `StorageUtility` nur String-Werte ablegen.
- Negative interne Signal-IDs stehen für logisch verwaltete Ampeln; `TrafficLight:switchSignal(...)` setzt in diesem Fall kein EEP-Signal.
- `lightStructures` und `axisStructures` müssen auf existierende EEP-Strukturen beziehungsweise Achsen verweisen; die Hilfsklassen validieren das sofort.
- Die Web-Kommandos für Kreuzungen werden ausschließlich über `RoadBridgeConnector.registerFunctions()` freigegeben.
- Die State-Publisher müssen stabile Schlüsselfelder (`id` oder `name`) je exportiertem Element setzen.

## Typische Änderungsrisiken

### Inkonsistenter Umschaltablauf

Schon kleine Änderungen in `IntersectionSequence:tasksForSwitchingFrom(...)` können den zeitlichen Ablauf zwischen Rot, Gelb, Rot-Gelb, Grün und Fußgängerphasen fachlich brechen.

### Verlorene oder fehlerhafte Persistenz

Änderungen an `Lane`-Persistenz oder `IntersectionSettings.saveSettings()/loadSettingsFromSlot()` können bestehende Anlagenzustände unlesbar machen oder Bool-Werte falsch interpretieren.

### Falsche Fahrspurzuteilung

Wenn `Intersection.initSequences()`, `TrafficLight:applyToLane(...)` oder `Lane:driveOn(...)` geändert werden, kann die Prioritätsberechnung falsche Fahrspuren einer Schaltung zuordnen.

### Sichtbare Nebenwirkungen in EEP

`TrafficLight`, `TramSwitch` und `Bus` rufen direkt `EEPSetSignal`, `EEPStructureSetLight`, `EEPStructureSetAxis`, `EEPShowInfoSignal`, `EEPShowInfoStructure`, `EEPChangeInfoSignal` oder `EEPSetTrainAxis` auf. Fehler wirken sich sofort sichtbar in EEP aus.

### Web-API-Drift

Änderungen an den State-Publishern können Web-Server, Web-App und das Datenmodell in [DTO.md](./DTO.md) auseinanderlaufen lassen.

### Globale Callback-Kollisionen

`TramSwitch` und `Bus` registrieren globale EEP-Callbacks. Änderungen an Namensschema oder Signatur können mit anderen Paketen kollidieren.

## Relevante Nachbarn

`ce/mods/road` arbeitet aktuell eng mit diesen Paketen zusammen:

- `ce.hub`: `ModuleRegistry`, `StatePublisherRegistry` und weitere Hub-Infrastruktur
- `ce.hub.scheduler`: `Scheduler`, `Task` und `SchedulerCeModule`
- `ce.hub.publish`: `DataChangeBus` für Web-Zustandsänderungen
- `ce.hub.util`: `StorageUtility` für Persistenz
- `ce.hub.util.Queue`: Warteschlangen der Fahrspuren
- `ce.hub.eep.TippTextFormatter`: Aufbau der Tipptexte

## Empfehlung für KI-Agenten

Bei Änderungen in `ce/mods/road` zuerst diese Fragen beantworten:

1. Betrifft die Änderung nur einen State-Publisher oder auch die fachliche Schaltlogik?
2. Verändert sie zustandsbehafteten Laufzeit- oder Persistenzcode?
3. Muss die Web-Seite oder das Datenmodell in [DTO.md](./DTO.md) mit angepasst werden?
4. Greift die Änderung in EEP-nahe Aufrufe, Tipptexte oder globale Callbacks ein?
5. Bleibt der Umschaltablauf zwischen alter und neuer Sequenz fachlich korrekt und zeitlich vollständig?
