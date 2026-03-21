---
layout: page_with_toc
title: Datenmodell
subtitle: Alle Räume und Datentypen der Control Extension im Überblick
permalink: lua/ce/hub/data/dto/
feature-img: "/docs/assets/headers/SourceCode.png"
img: "/docs/assets/headers/SourceCode.png"
---

# Datenmodell der `*StatePublisher.lua`

Diese Datei dokumentiert das aktuell erzeugte Datenmodell der Lua-Collector.

Grundlagen der Beschreibung:

- Primärquelle ist die aktuelle Implementierung in `*StatePublisher.lua` sowie in den indirekt genutzten Modellen wie `Train`, `RollingStock`, `Line` und `LineSegment`.
- Für Felder, die direkt aus EEP-Funktionen stammen, wurden Typ, Wertebereich und Beschreibung soweit möglich aus `Lua_manual.pdf` abgeleitet.
- Wo das Datenmodell nicht direkt aus EEP stammt, sondern aus Bibliothekslogik, ist das in der Beschreibung vermerkt.

Wichtig:

- Die meisten Collector senden Nutzdaten per `EventBroker.fireListChange(...)`; `syncState()` gibt oft `{}` zurück.
- Die Tabellen unten beschreiben das effektive Modell der Events und, wo relevant, die aktuelle Rückgabeform von `syncState()`.
- Bestehende Schreibweisen im Code bleiben in der Dokumentation erhalten, z. B. `occupiedTacks`.

## Überblick

| Collector                        | Datei                                                          | Effektive Ausgabe                                                                |
| -------------------------------- | -------------------------------------------------------------- | -------------------------------------------------------------------------------- |
| `ModulesStatePublisher`           | `lua/LUA/ce/hub/data/modules/ModulesStatePublisher.lua`               | direkte Rückgabe; zusätzlich `DataAdded`/`DataChanged` für `modules`             |
| `VersionStatePublisher`           | `lua/LUA/ce/hub/data/version/VersionStatePublisher.lua`               | `ListChanged` für `eep-version`; Rückgabe leer                                   |
| `SignalStatePublisher`            | `lua/LUA/ce/hub/data/signals/SignalStatePublisher.lua`                | `ListChanged` für `signals` und `waiting-on-signals`; Rückgabe leer              |
| `SwitchStatePublisher`            | `lua/LUA/ce/hub/data/switches/SwitchStatePublisher.lua`               | `ListChanged` für `switches`; Rückgabe leer                                      |
| `TimeStatePublisher`              | `lua/LUA/ce/hub/data/time/TimeStatePublisher.lua`                     | `ListChanged` für `times`; Rückgabe leer                                         |
| `DataSlotsStatePublisher`         | `lua/LUA/ce/hub/data/slots/DataSlotsStatePublisher.lua`               | `ListChanged` für `save-slots` und `free-slots`; Rückgabe leer                   |
| `StructureStatePublisher`         | `lua/LUA/ce/hub/data/structures/StructureStatePublisher.lua`          | `ListChanged` für `structures`; Rückgabe leer                                    |
| `TrainsAndTracksStatePublisher`   | `lua/LUA/ce/hub/data/trains/TrainsAndTracksStatePublisher.lua`        | indirekte Events für `trains` und `rolling-stocks`; Rückgabe leer                |
| `TrafficLightModelStatePublisher` | `lua/LUA/ce/mods/road/data/TrafficLightModelStatePublisher.lua`       | `ListChanged` für `signal-type-definitions`; Rückgabe leer                       |
| `RoadStatePublisher`          | `lua/LUA/ce/mods/road/data/RoadStatePublisher.lua`                | Events für Kreuzungsdaten; internes Datenobjekt wird derzeit nicht zurückgegeben |
| `TransitStatePublisher`   | `lua/LUA/ce/mods/transit/data/TransitStatePublisher.lua` | Events für ÖPNV-Daten; internes Datenobjekt wird derzeit nicht zurückgegeben     |

## Transportform

| Thema                               | Event-Raum                         | Schlüssel |
| ----------------------------------- | ---------------------------------- | --------- |
| Module                              | `modules`                          | `id`      |
| Version                             | `eep-version`                      | `id`      |
| Signale                             | `signals`                          | `id`      |
| Wartende Fahrzeuge an Signalen      | `waiting-on-signals`               | `id`      |
| Weichen                             | `switches`                         | `id`      |
| Zeit                                | `times`                            | `id`      |
| Belegte Datenslots                  | `save-slots`                       | `id`      |
| Freie Datenslots                    | `free-slots`                       | `id`      |
| Strukturen                          | `structures`                       | `id`      |
| Züge                                | `trains`                           | `id`      |
| RollingStock                        | `rolling-stocks`                   | `id`      |
| Ampelmodell-Definitionen            | `signal-type-definitions`          | `id`      |
| Kreuzungen                          | `road-intersections`                    | `id`      |
| Kreuzungs-Fahrspuren                | `road-intersection-lanes`               | `id`      |
| Kreuzungs-Schaltungen               | `road-intersection-switchings`          | `id`      |
| Kreuzungs-Ampeln                    | `road-intersection-traffic-lights`      | `id`      |
| Kreuzungs-Moduleinstellungen        | `road-module-settings`     | `name`    |
| ÖPNV-Linien                         | `transit-lines`           | `id`      |
| ÖPNV-Stationen                      | `transit-stations`        | `id`      |
| ÖPNV-Moduleinstellungen             | `transit-module-settings` | `name`    |
| Änderungsereignisse für Liniennamen | `transit-line-names`      | `id`      |

## Datenschemata

### `modules`

Elementtyp: Modulstatus

| Name      | Typ                  | Wertebereich        | Beschreibung                             |
| --------- | -------------------- | ------------------- | ---------------------------------------- |
| `id`      | `string` \| `number` | pro Modul eindeutig | Modul-ID aus dem registrierten Lua-Modul |
| `name`    | `string`             | freier Text         | Modulname aus der Registrierung          |
| `enabled` | `boolean`            | `true`, `false`     | Aktivierungsstatus des Moduls            |

Hinweis:

- `syncState()` liefert aktuell kein Listenobjekt, sondern ein Root-Objekt mit leeren `modules = {}` plus Einträgen unter `root[module.id]`.

### `eep-version`

Elementtyp: Versionsinfo

| Name            | Typ      | Wertebereich       | Beschreibung                                                         |
| --------------- | -------- | ------------------ | -------------------------------------------------------------------- |
| `id`            | `string` | fest `versionInfo` | technischer Schlüssel                                                |
| `name`          | `string` | fest `versionInfo` | Anzeigename                                                          |
| `eepVersion`    | `string` | z. B. `16.3`       | EEP-Version aus `EEPVer`; im Collector bewusst als String formatiert |
| `luaVersion`    | `string` | Lua-Versionsstring | `_VERSION` des eingebetteten Lua                                     |
| `singleVersion` | `string` | Versionsstring     | Programmversion des Web-/Single-Prozesses                            |

### `signals`

Elementtyp: Signal

| Name                   | Typ       | Wertebereich                      | Beschreibung                                                                                          |
| ---------------------- | --------- | --------------------------------- | ----------------------------------------------------------------------------------------------------- |
| `id`                   | `integer` | `> 0`                             | Signal-ID aus EEP                                                                                     |
| `position`             | `integer` | `> 0`; `0` wäre "existiert nicht" | Signalstellung aus `EEPGetSignal`; laut Lua-Handbuch liefert `0` ein nicht existierendes Signal       |
| `tag`                  | `string`  | freier Text bis 1024 Zeichen      | Tag-Text des Signals; aktuell aus `EEPSignalGetTagText`, leere Zeichenkette wenn kein Tag gesetzt ist |
| `waitingVehiclesCount` | `integer` | `>= 0`                            | Anzahl der am Signal wartenden Fahrzeugverbände aus `EEPGetSignalTrainsCount`                         |

Abgeleitet aus:

- `EEPGetSignal(signalId)`
- `EEPGetSignalTrainsCount(signalId)`

### `waiting-on-signals`

Elementtyp: Wartender Fahrzeugverband an einem Signal

| Name              | Typ       | Wertebereich                   | Beschreibung                                                        |
| ----------------- | --------- | ------------------------------ | ------------------------------------------------------------------- |
| `id`              | `string`  | `<signalId>-<position>`        | zusammengesetzter technischer Schlüssel                             |
| `signalId`        | `integer` | `> 0`                          | referenziertes Signal                                               |
| `waitingPosition` | `integer` | `>= 1`                         | Position innerhalb der Warteschlange am Signal                      |
| `vehicleName`     | `string`  | Fahrzeugverbandsname oder `""` | Name aus `EEPGetSignalTrainName`; bei fehlendem Namen leerer String |
| `waitingCount`    | `integer` | `>= 0`                         | Gesamtanzahl wartender Fahrzeugverbände an diesem Signal            |

Abgeleitet aus:

- `EEPGetSignalTrainName(signalId, position)`

### `switches`

Elementtyp: Weiche

| Name       | Typ       | Wertebereich                      | Beschreibung                                                                                         |
| ---------- | --------- | --------------------------------- | ---------------------------------------------------------------------------------------------------- |
| `id`       | `integer` | `> 0`                             | Weichen-ID                                                                                           |
| `position` | `integer` | `> 0`; `0` wäre "existiert nicht" | Weichenstellung aus `EEPGetSwitch`; laut Lua-Handbuch liefert `0` eine nicht existierende Weiche     |
| `tag`      | `string`  | freier Text bis 1024 Zeichen      | Tag-Text der Weiche; aktuell aus `EEPSwitchGetTagText`, leere Zeichenkette wenn kein Tag gesetzt ist |

Abgeleitet aus:

- `EEPGetSwitch(switchId)`

### `times`

Elementtyp: EEP-Zeit

| Name           | Typ       | Wertebereich    | Beschreibung                            |
| -------------- | --------- | --------------- | --------------------------------------- |
| `id`           | `string`  | fest `times`    | technischer Schlüssel                   |
| `name`         | `string`  | fest `times`    | Anzeigename                             |
| `timeComplete` | `integer` | `0` bis `86399` | Sekunden seit Mitternacht aus `EEPTime` |
| `timeH`        | `integer` | `0` bis `23`    | Stundenanteil aus `EEPTimeH`            |
| `timeM`        | `integer` | `0` bis `59`    | Minutenanteil aus `EEPTimeM`            |
| `timeS`        | `integer` | `0` bis `59`    | Sekundenanteil aus `EEPTimeS`           |

Abgeleitet aus:

- `EEPTime`
- `EEPTimeH`
- `EEPTimeM`
- `EEPTimeS`

### `save-slots`

Elementtyp: belegter Datenslot

| Name   | Typ                                        | Wertebereich                | Beschreibung                                                 |
| ------ | ------------------------------------------ | --------------------------- | ------------------------------------------------------------ |
| `id`   | `integer`                                  | `1` bis `1000`              | Slotnummer                                                   |
| `name` | `string`                                   | freier Text, fallback `"?"` | Name des Slots aus `AkSlotNamesParser` oder `StorageUtility` |
| `data` | `string` \| `number` \| `boolean` \| `nil` | EEP-Datenslot-Inhalt        | Inhalt aus `EEPLoadData(id)`                                 |

Abgeleitet aus:

- `EEPLoadData(slot)`

### `free-slots`

Elementtyp: freier Datenslot

| Name   | Typ               | Wertebereich        | Beschreibung                  |
| ------ | ----------------- | ------------------- | ----------------------------- |
| `id`   | `integer`         | `1` bis `1000`      | Slotnummer                    |
| `name` | `string` \| `nil` | immer nicht gesetzt | bei freien Slots nicht belegt |
| `data` | `string` \| `nil` | immer nicht gesetzt | bei freien Slots nicht belegt |

### `structures`

Elementtyp: Struktur / Immobilie / Landschaftselement

| Name            | Typ       | Wertebereich                                                              | Beschreibung                                                                    |
| --------------- | --------- | ------------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| `id`            | `string`  | `#<nummer>`                                                               | Lua-Name der Struktur                                                           |
| `name`          | `string`  | `#<nummer>`                                                               | aktuell identisch zu `id`                                                       |
| `pos_x`         | `number`  | Koordinate in Anlagenkoordinaten                                          | X-Position aus `EEPStructureGetPosition`, auf zwei Nachkommastellen gerundet    |
| `pos_y`         | `number`  | Koordinate in Anlagenkoordinaten                                          | Y-Position aus `EEPStructureGetPosition`, auf zwei Nachkommastellen gerundet    |
| `pos_z`         | `number`  | Koordinate in Anlagenkoordinaten                                          | Z-Position aus `EEPStructureGetPosition`, auf zwei Nachkommastellen gerundet    |
| `rot_x`         | `number`  | Winkel in Grad                                                            | Rotation um X aus `EEPStructureGetRotation`, auf zwei Nachkommastellen gerundet |
| `rot_y`         | `number`  | Winkel in Grad                                                            | Rotation um Y aus `EEPStructureGetRotation`, auf zwei Nachkommastellen gerundet |
| `rot_z`         | `number`  | Winkel in Grad                                                            | Rotation um Z aus `EEPStructureGetRotation`, auf zwei Nachkommastellen gerundet |
| `modelType`     | `integer` | EEP-Modelltyp, z. B. `16`, `17`, `18`, `19`, `22`, `23`, `24`, `25`, `38` | Modelltyp aus `EEPStructureGetModelType`                                        |
| `modelTypeText` | `string`  | feste Textmenge                                                           | lesbarer Modelltyptext aus Collector-Mapping                                    |
| `tag`           | `string`  | freier Text bis 1024 Zeichen                                              | Tag-Text aus `EEPStructureGetTagText`                                           |
| `light`         | `boolean` | `true`, `false`                                                           | Lichtzustand aus `EEPStructureGetLight`                                         |
| `smoke`         | `boolean` | `true`, `false`                                                           | Rauchzustand aus `EEPStructureGetSmoke`                                         |
| `fire`          | `boolean` | `true`, `false`                                                           | Feuerzustand aus `EEPStructureGetFire`                                          |

Hinweis:

- Der Collector nimmt nur Strukturen auf, bei denen mindestens eines von `light`, `smoke` oder `fire` verfügbar ist.

Vollständige Liste `modelType` für Strukturen laut `Lua_manual.pdf` und `EEPStructureGetModelType`:

| Wert | Bedeutung                                             |
| ---- | ----------------------------------------------------- |
| `16` | `"Gleisobjekte" Bahngleise`                           |
| `17` | `"Gleisobjekte" Straßenbahn`                          |
| `18` | `"Gleisobjekte" Straßen`                              |
| `19` | `"Gleisobjekte" Wasserwege/Diverse`                   |
| `22` | Immobilien                                            |
| `23` | Landschaftselemente Fauna                             |
| `24` | Landschaftselemente Flora                             |
| `25` | Landschaftselemente Terra                             |
| `38` | Landschaftselemente, Bodenmodelle zur 3D-Texturierung |

### `trains`

Elementtyp: Zug / Fahrzeugverband

| Name                | Typ                     | Wertebereich                                      | Beschreibung                                                                            |
| ------------------- | ----------------------- | ------------------------------------------------- | --------------------------------------------------------------------------------------- |
| `id`                | `string`                | Zugname, typ. `#...`                              | Name des Fahrzeugverbands                                                               |
| `route`             | `string`                | Routenname, fallback `Alle`                       | Route aus `EEPGetTrainRoute`                                                            |
| `rollingStockCount` | `integer`               | `>= 0`                                            | Anzahl Rollmaterialien aus `EEPGetRollingstockItemsCount`                               |
| `length`            | `number`                | Meter, `>= 0`                                     | Zuglänge aus `EEPGetTrainLength`                                                        |
| `line`              | `string` \| `nil`       | freier Text                                       | aus dem Tag-Modell der Bibliothek                                                       |
| `destination`       | `string` \| `nil`       | freier Text                                       | aus dem Tag-Modell der Bibliothek                                                       |
| `direction`         | `string` \| `nil`       | freier Text                                       | aus dem Tag-Modell der Bibliothek                                                       |
| `trackType`         | `string` \| `nil`       | z. B. `rail`, `road`, `tram`, `auxiliary`         | Bibliotheksklassifikation, nicht direkt EEP                                             |
| `movesForward`      | `boolean`               | `true`, `false`                                   | aus der Zuggeschwindigkeit abgeleitete Fahrtrichtung                                    |
| `speed`             | `number`                | km/h; negativ für Rückwärtsfahrt möglich          | aktuelle Geschwindigkeit aus `EEPGetTrainSpeed`                                         |
| `occupiedTacks`     | `table<string, number>` | Welche Track ID und Abstand `trackId -> distance` | durch die Bibliothek ermittelte belegte Tracks; Schreibweise ist im Code absichtlich so |

Abgeleitet aus:

- `EEPGetTrainRoute(trainName)`
- `EEPGetRollingstockItemsCount(trainName)`
- `EEPGetTrainLength(trainName)`
- `EEPGetTrainSpeed(trainName)`

Vollständige Liste `trackType` laut `TrainDetection` / `TrackDetection`:

| Wert        | Bedeutung                                                             |
| ----------- | --------------------------------------------------------------------- |
| `rail`      | Bahngleise                                                            |
| `tram`      | Straßenbahn-Gleise                                                    |
| `road`      | Straßen                                                               |
| `auxiliary` | sonstige Splines / Wasserwege                                         |
| `control`   | Steuerstrecken / nicht direkt einem der vier Track-Systeme zugeordnet |

### `rolling-stocks`

Elementtyp: RollingStock / Fahrzeug

| Name              | Typ                   | Wertebereich                              | Beschreibung                                                                                          |
| ----------------- | --------------------- | ----------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| `id`              | `string`              | Fahrzeugname                              | technischer Schlüssel; aktuell gleich `name`                                                          |
| `name`            | `string`              | Fahrzeugname                              | Name des Rollmaterials                                                                                |
| `trainName`       | `string`              | Zugname oder `""`                         | zugeordneter Fahrzeugverband                                                                          |
| `positionInTrain` | `integer`             | `0`-basiert, `-1` falls unbekannt         | Position im Zugverband                                                                                |
| `couplingFront`   | `integer`             | Statuscode der vorderen Kupplung          | aus `EEPRollingstockGetCouplingFront`                                                                 |
| `couplingRear`    | `integer`             | Statuscode der hinteren Kupplung          | aus `EEPRollingstockGetCouplingRear`                                                                  |
| `length`          | `number`              | Meter                                     | Fahrzeuglänge aus `EEPRollingstockGetLength`                                                          |
| `propelled`       | `boolean` \| `number` | im Projekt als "hat Antrieb" genutzt      | abgeleitet aus `EEPRollingstockGetMotor`; das Lua-Handbuch beschreibt hier die Motor-/Ganginformation |
| `modelType`       | `integer`             | `1` bis `15`                              | Modelltyp aus `EEPRollingstockGetModelType`                                                           |
| `modelTypeText`   | `string`              | feste Textmenge                           | lesbarer Modelltyptext aus lokalem Mapping                                                            |
| `tag`             | `string`              | freier Text bis 1024 Zeichen              | Tag-Text aus `EEPRollingstockGetTagText`                                                              |
| `nr`              | `string` \| `nil`     | freier Text                               | Wagennummer aus dem bibliotheksinternen Tag-Modell                                                    |
| `trackId`         | `integer`             | Track-ID                                  | aus `EEPRollingstockGetTrack`                                                                         |
| `trackDistance`   | `number`              | Meter vom Gleisanfang                     | aus `EEPRollingstockGetTrack`                                                                         |
| `trackDirection`  | `integer`             | `1` oder `0`                              | laut Lua-Handbuch: `1 = in Fahrtrichtung`, `0 = entgegen`                                             |
| `trackSystem`     | `integer`             | `1` bis `4`                               | laut Lua-Handbuch: `1 = Bahngleise`, `2 = Straßen`, `3 = Tram`, `4 = sonstige Splines/Wasserwege`     |
| `trackType`       | `string` \| `nil`     | z. B. `rail`, `road`, `tram`, `auxiliary` | Bibliotheksklassifikation, nicht direkt EEP                                                           |
| `posX`            | `number`              | Anlagenkoordinate                         | X-Position aus `EEPRollingstockGetPosition`                                                           |
| `posY`            | `number`              | Anlagenkoordinate                         | Y-Position aus `EEPRollingstockGetPosition`                                                           |
| `posZ`            | `number`              | Anlagenkoordinate                         | Z-Position aus `EEPRollingstockGetPosition`                                                           |
| `mileage`         | `number`              | Zahl                                      | Zurückgelegte Strecke in Metern seit Einsetzen des Modells aus `EEPRollingstockGetMileage`            |

Abgeleitet aus:

- `EEPRollingstockGetLength`
- `EEPRollingstockGetMotor`
- `EEPRollingstockGetModelType`
- `EEPRollingstockGetTagText`
- `EEPRollingstockGetTextureText` nur intern; nicht im JSON exportiert
- `EEPRollingstockGetTrack`
- `EEPRollingstockGetPosition`
- `EEPRollingstockGetMileage`

Vollständige Liste `trackType` laut `TrainDetection` / `TrackDetection`:

| Wert        | Bedeutung                                                             |
| ----------- | --------------------------------------------------------------------- |
| `rail`      | Bahngleise                                                            |
| `tram`      | Straßenbahn-Gleise                                                    |
| `road`      | Straßen                                                               |
| `auxiliary` | sonstige Splines / Wasserwege                                         |
| `control`   | Steuerstrecken / nicht direkt einem der vier Track-Systeme zugeordnet |

Vollständige Liste `modelType` für RollingStock laut `Lua_manual.pdf` und `EEPRollingstockGetModelType`:

| Wert | Bedeutung            |
| ---- | -------------------- |
| `1`  | Tenderlok            |
| `2`  | Schlepptenderlok     |
| `3`  | Tender               |
| `4`  | Elektrolok           |
| `5`  | Diesellok            |
| `6`  | Triebwagen           |
| `7`  | U- oder S-Bahn       |
| `8`  | Straßenbahn          |
| `9`  | Güterwaggon          |
| `10` | Personenwaggon       |
| `11` | Luftfahrzeug         |
| `12` | Maschine (z.B. Kran) |
| `13` | Wasserfahrzeug       |
| `14` | LKW                  |
| `15` | PKW                  |

### `signal-type-definitions`

Elementtyp: Ampelmodell-Definition

| Name                            | Typ                | Wertebereich        | Beschreibung                           |
| ------------------------------- | ------------------ | ------------------- | -------------------------------------- |
| `id`                            | `string`           | Modellname          | technischer Schlüssel des Ampelmodells |
| `name`                          | `string`           | Modellname          | Anzeigename                            |
| `type`                          | `string`           | aktuell fest `road` | Modellfamilie                          |
| `positions.positionRed`         | `integer` \| `nil` | Signalzustandsindex | Rotphase                               |
| `positions.positionGreen`       | `integer` \| `nil` | Signalzustandsindex | Grünphase                              |
| `positions.positionYellow`      | `integer` \| `nil` | Signalzustandsindex | Gelbphase                              |
| `positions.positionRedYellow`   | `integer` \| `nil` | Signalzustandsindex | Rot-Gelb-Phase                         |
| `positions.positionPedestrians` | `integer` \| `nil` | Signalzustandsindex | Fußgängerphase                         |
| `positions.positionOff`         | `integer` \| `nil` | Signalzustandsindex | ausgeschaltet                          |
| `positions.positionOffBlinking` | `integer` \| `nil` | Signalzustandsindex | Blinkbetrieb                           |

### `road-intersections`

Elementtyp: Kreuzung

| Name               | Typ               | Wertebereich           | Beschreibung                                   |
| ------------------ | ----------------- | ---------------------- | ---------------------------------------------- |
| `id`               | `integer`         | laufende Nummer ab `1` | technischer Schlüssel der Collectorrunde       |
| `name`             | `string`          | freier Text            | Kreuzungsname                                  |
| `currentSwitching` | `string` \| `nil` | Sequenzname            | aktuell aktive Schaltung                       |
| `manualSwitching`  | `string` \| `nil` | Sequenzname            | manuell gewählte Schaltung                     |
| `nextSwitching`    | `string` \| `nil` | Sequenzname            | nächste geplante Schaltung                     |
| `ready`            | `boolean`         | `true`, `false`        | Ergebnis von `crossing:isGreenPhaseFinished()` |
| `timeForGreen`     | `number`          | Sekunden               | Grünphasenlänge                                |
| `staticCams`       | `string[]`        | Kameranamen            | Liste statischer Kameras der Kreuzung          |

### `road-intersection-lanes`

Elementtyp: Fahrspur einer Kreuzung

| Name                         | Typ                | Wertebereich                                                 | Beschreibung                                     |
| ---------------------------- | ------------------ | ------------------------------------------------------------ | ------------------------------------------------ |
| `id`                         | `string`           | `<intersectionId>-<laneName>`                                | technischer Schlüssel                            |
| `intersectionId`             | `integer`          | referenziert `road-intersections.id`                              | zugehörige Kreuzung                              |
| `name`                       | `string`           | freier Text                                                  | Fahrspurname                                     |
| `phase`                      | `string`           | `NONE`, `YELLOW`, `RED`, `RED_YELLOW`, `GREEN`, `PEDESTRIAN` | aus der Ampelphasenlogik der Bibliothek          |
| `vehicleMultiplier`          | `number`           | projektabhängig                                              | Gewichtungsfaktor für Zähler                     |
| `eepSaveId`                  | `integer` \| `nil` | Datenslot-ID                                                 | zugehörige persistente ID                        |
| `type`                       | `string`           | `NORMAL`, `TRAM`, `PEDESTRIAN`                               | Fahrspurtyp                                      |
| `countType`                  | `string`           | `CONTACTS`, `SIGNALS`, `TRACKS`                              | Herkunft der Anforderungserkennung               |
| `waitingTrains`              | `table`            | Queue-Inhalt                                                 | wartende Fahrzeuge/Züge in aktueller Reihenfolge |
| `waitingForGreenCyclesCount` | `integer`          | `>= 0`                                                       | Anzahl Warteschleifen bis Grün                   |
| `directions`                 | `table`            | projektabhängig                                              | Richtungsdefinition der Fahrspur                 |
| `switchings`                 | `string[]`         | Sequenznamen                                                 | Schaltungen, die diese Fahrspur freigeben        |
| `tracks`                     | `table`            | Track-IDs oder Highlight-Daten                               | für Hervorhebung genutzte Tracks                 |

### `road-intersection-switchings`

Elementtyp: Kreuzungs-Schaltung

| Name             | Typ             | Wertebereich                    | Beschreibung                                                                     |
| ---------------- | --------------- | ------------------------------- | -------------------------------------------------------------------------------- |
| `id`             | `string`        | `<crossingName>-<sequenceName>` | technischer Schlüssel                                                            |
| `intersectionId` | `string`        | Kreuzungsname                   | aktueller Code verwendet hier den Namen, nicht die numerische `road-intersections.id` |
| `name`           | `string`        | Sequenzname                     | Name der Schaltung                                                               |
| `prio`           | `number \| nil` | projektabhängig                 | Priorität der Schaltung                                                          |

### `road-intersection-traffic-lights`

Elementtyp: Ampel innerhalb einer Kreuzung

| Name              | Typ                           | Wertebereich                    | Beschreibung                |
| ----------------- | ----------------------------- | ------------------------------- | --------------------------- |
| `id`              | `integer \| string`           | Signal-ID                       | technischer Schlüssel       |
| `signalId`        | `integer`                     | Signal-ID                       | referenziertes EEP-Signal   |
| `modelId`         | `string`                      | Modellname                      | referenziertes Ampelmodell  |
| `currentPhase`    | `number` \| `string` \| `nil` | projektabhängig                 | aktuelle interne Ampelphase |
| `intersectionId`  | `integer`                     | referenziert `road-intersections.id` | zugehörige Kreuzung         |
| `lightStructures` | `table<string, object>`       | indexierte Map                  | zugehörige Lichtstrukturen  |
| `axisStructures`  | `object[]`                    | Liste                           | zugehörige Achsstrukturen   |

Unterobjekt `lightStructures[*]`:

| Name               | Typ               | Wertebereich   | Beschreibung                               |
| ------------------ | ----------------- | -------------- | ------------------------------------------ |
| `structureRed`     | `string` \| `nil` | Immobilienname | Immobilienname für das Rotlicht            |
| `structureGreen`   | `string` \| `nil` | Immobilienname | Immobilienname für das Grünlicht           |
| `structureYellow`  | `string` \| `nil` | Immobilienname | Immobilienname für das Gelblicht           |
| `structureRequest` | `string` \| `nil` | Immobilienname | Immobilienname für die Anforderungsanzeige |

Unterobjekt `axisStructures[*]`:

| Name                 | Typ             | Wertebereich    | Beschreibung                |
| -------------------- | --------------- | --------------- | --------------------------- |
| `structureName`      | `string`        | Immobilienname  | betroffener Immobilienname  |
| `axisName`           | `string`        | Achsname        | betroffene Achse            |
| `positionDefault`    | `number \| nil` | projektabhängig | Default-Position            |
| `positionRed`        | `number \| nil` | projektabhängig | Position bei Rot            |
| `positionGreen`      | `number \| nil` | projektabhängig | Position bei Grün           |
| `positionYellow`     | `number \| nil` | projektabhängig | Position bei Gelb           |
| `positionPedestrian` | `number \| nil` | projektabhängig | Position bei Fußgängerphase |
| `positionRedYellow`  | `number \| nil` | projektabhängig | Position bei Rot-Gelb       |

### `road-module-settings`

Elementtyp: Kreuzungs-Moduloption

| Name          | Typ       | Wertebereich         | Beschreibung                   |
| ------------- | --------- | -------------------- | ------------------------------ |
| `category`    | `string`  | feste Textmenge      | logische Gruppe in der UI      |
| `name`        | `string`  | pro Gruppe eindeutig | Anzeigename der Option         |
| `description` | `string`  | freier Text          | Beschreibung für die UI        |
| `type`        | `string`  | aktuell `boolean`    | Optionstyp                     |
| `value`       | `boolean` | `true`, `false`      | aktueller Wert                 |
| `eepFunction` | `string`  | Lua-Funktionsname    | Setter-Funktion für die Option |

### `transit-lines`

Elementtyp: ÖPNV-Linie

| Name           | Typ        | Wertebereich        | Beschreibung               |
| -------------- | ---------- | ------------------- | -------------------------- |
| `id`           | `string`   | Liniennummer        | technischer Schlüssel      |
| `nr`           | `string`   | Liniennummer        | Anzeigenummer der Linie    |
| `trafficType`  | `string`   | `TRAM` oder `BUS`   | Verkehrstyp der Linie      |
| `lineSegments` | `object[]` | Liste von Segmenten | Routenabschnitte der Linie |

Unterobjekt `lineSegments[*]`:

| Name          | Typ        | Wertebereich   | Beschreibung                       |
| ------------- | ---------- | -------------- | ---------------------------------- |
| `id`          | `string`   | Routenname     | technischer Schlüssel des Segments |
| `destination` | `string`   | freier Text    | Ziel dieses Linienabschnitts       |
| `routeName`   | `string`   | EEP-Routenname | Referenz zur EEP-Route             |
| `lineNr`      | `string`   | Liniennummer   | Rückverweis auf die Linie          |
| `stations`    | `object[]` | Liste          | Halte des Segments in Reihenfolge  |

Unterobjekt `stations[*]`:

| Name            | Typ      | Wertebereich    | Beschreibung             |
| --------------- | -------- | --------------- | ------------------------ |
| `station.name`  | `string` | Stationsname    | Name der Zielstation     |
| `timeToStation` | `number` | Minuten, `>= 0` | Fahrzeit bis zur Station |

### `transit-stations`

Elementtyp: ÖPNV-Station

Aktueller Stand:

- Der Collector erzeugt derzeit immer eine leere Liste.
- Es gibt aktuell kein JSON-Schema, weil noch keine Stationseinträge erzeugt werden.

### `transit-module-settings`

Elementtyp: ÖPNV-Moduloption

| Name          | Typ       | Wertebereich         | Beschreibung                   |
| ------------- | --------- | -------------------- | ------------------------------ |
| `category`    | `string`  | feste Textmenge      | logische Gruppe in der UI      |
| `name`        | `string`  | pro Gruppe eindeutig | Anzeigename der Option         |
| `description` | `string`  | freier Text          | Beschreibung für die UI        |
| `type`        | `string`  | aktuell `boolean`    | Optionstyp                     |
| `value`       | `boolean` | `true`, `false`      | aktueller Wert                 |
| `eepFunction` | `string`  | Lua-Funktionsname    | Setter-Funktion für die Option |

### `transit-line-names`

Elementtyp: Änderungsereignis für Linien

Schema:

- identisch zu `transit-lines`
- wird von `LineRegistry.fireChangeLinesEvent()` gesendet

## Rückgabewerte der `syncState()`-Funktionen

| Collector                                      | Rückgabe heute             | Bemerkung                               |
| ---------------------------------------------- | -------------------------- | --------------------------------------- |
| `ModulesStatePublisher.syncState()`           | Objekt mit Modulen nach ID | einzig relevanter direkter Rückgabewert |
| `VersionStatePublisher.syncState()`           | `{}`                       | Nutzdaten nur im Event                  |
| `SignalStatePublisher.syncState()`            | `{}`                       | Nutzdaten nur im Event                  |
| `SwitchStatePublisher.syncState()`            | `{}`                       | Nutzdaten nur im Event                  |
| `TimeStatePublisher.syncState()`              | `{}`                       | Nutzdaten nur im Event                  |
| `DataSlotsStatePublisher.syncState()`         | `{}`                       | Nutzdaten nur im Event                  |
| `StructureStatePublisher.syncState()`         | `{}`                       | Nutzdaten nur im Event                  |
| `TrainsAndTracksStatePublisher.syncState()`   | leeres `data`              | Nutzdaten über Registries               |
| `TrafficLightModelStatePublisher.syncState()` | `{}`                       | Nutzdaten nur im Event                  |
| `RoadStatePublisher.syncState()`          | `{}`                       | internes Datenobjekt wird verworfen     |
| `TransitStatePublisher.syncState()`   | `{}`                       | internes Datenobjekt wird verworfen     |

## Verwendete EEP-Funktionen und Handbuchbezug

Die wichtigsten direkt genutzten EEP-Funktionen für das Datenmodell sind:

- `EEPGetSignal`, `EEPGetSignalTrainsCount`, `EEPGetSignalTrainName`
- `EEPGetSwitch`
- `EEPLoadData`
- `EEPStructureGetPosition`, `EEPStructureGetRotation`, `EEPStructureGetModelType`, `EEPStructureGetTagText`
- `EEPGetTrainRoute`, `EEPGetTrainLength`, `EEPGetTrainSpeed`
- `EEPRollingstockGetLength`, `EEPRollingstockGetMotor`, `EEPRollingstockGetModelType`, `EEPRollingstockGetTagText`, `EEPRollingstockGetTextureText`, `EEPRollingstockGetTrack`, `EEPRollingstockGetPosition`, `EEPRollingstockGetMileage`
- die Zeitvariablen `EEPTime`, `EEPTimeH`, `EEPTimeM`, `EEPTimeS`

Beschreibungen, Typen und Wertebereiche wurden, soweit vorhanden, aus `Lua_manual.pdf` übernommen oder daraus abgeleitet. Für fachliche Objekte der Bibliothek wie Kreuzungen, Fahrspuren, Linien und Moduloptionen stammt die Beschreibung aus dem Projektcode selbst.
