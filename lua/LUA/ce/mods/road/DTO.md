---
layout: page_with_toc
title: Road-Datenmodell
subtitle: JSON-Datenmodell der Ampel- und Kreuzungssteuerung
permalink: lua/ce/mods/road/dto/
feature-img: "/docs/assets/headers/SourceCode.png"
img: "/docs/assets/headers/SourceCode.png"
---

# Datenmodell der JSON-Collector in `ce/mods/road`

Diese Datei beschreibt das aktuell aus `lua/LUA/ce/mods/road` erzeugte JSON-Datenmodell.

Wichtige Vorbemerkungen:

- Primärquellen sind `TrafficLightModelStatePublisher.lua`, `RoadStatePublisher.lua` und die von ihnen verwendeten Modelle.
- Beide Collector erzeugen ihre Nutzdaten fachlich über `DataChangeBus.fireListChange(...)`. `syncState()` liefert aktuell selbst nur leere Tabellen zurück.
- Der Lua-Collector sendet Listen. Der Web-Server normalisiert diese Listen danach zu Objekt-Mappings nach `keyId` und speichert sie so in `lua/LUA/ce/databridge/exchange/server-state.json`.

## `TrafficLightModelStatePublisher`

| Collector                        | Raumname                  |
| -------------------------------- | ------------------------- |
| `TrafficLightModelStatePublisher` | `signal-type-definitions` |

### Raum `signal-type-definitions`

Jeder Eintrag beschreibt das Verhalten eines bestimmten Modells von Ampeln. Das Modell bestimmt, welche Signalstellung für die Ampelschaltung genutzt werden soll, also für rot, gelb, grün, Fußgängergrün usw.
Diese Signalstellungen können als `signalIndex` für `EEPSetSignal(signalId, signalIndex, 1)` verwendet werden und kommen bei `EEPGetSignal(signalId)` als zweiter Rückgabewert zurück.

| Name                            | Typ und Wertebereich / Beispiel                                  | Beschreibung                                                                              |
| ------------------------------- | ---------------------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| `id`                            | `string`, pro Modell eindeutig; Beispiel: `Ampel_3er_XXX_mit_FG` | Technischer Schlüssel; identisch zu `name`.                                              |
| `name`                          | `string`; Beispiel: `Ampel_3er_XXX_mit_FG`                       | Modellname aus `TrafficLightModel:new(...)`.                                             |
| `type`                          | `string`, aktuell fest `road`; Beispiel: `road`                  | Kennzeichnet Straßensignalmodelle (Ampeln).                                              |
| `positions`                     | Objekt; Beispiel: `{ "positionRed": 1, "positionGreen": 3 }` | Signalstellungen für `signalIndex` für `EEPSetSignal(signalId, signalIndex, 1)`.         |
| `positions.positionRed`         | `integer >= 1`; Beispiel: `1`                                    | Signalstellung für eine rote Ampel.                                                      |
| `positions.positionGreen`       | `integer >= 1`; Beispiel: `3`                                    | Signalstellung für eine grüne Ampel.                                                     |
| `positions.positionYellow`      | `integer >= 1`; Beispiel: `5`                                    | Signalstellung für eine gelbe Ampel; im Modell optional, fällt sonst auf Rot zurück.     |
| `positions.positionRedYellow`   | `integer >= 1`; Beispiel: `2`                                    | Signalstellung für eine rot-gelbe Ampel; im Modell optional, fällt sonst auf Rot zurück. |
| `positions.positionPedestrians` | `integer >= 1` oder nicht gesetzt; Beispiel: `6`                 | Signalstellung für grün für Fußgänger. Der JSON-Feldname ist absichtlich pluralisiert.   |
| `positions.positionOff`         | `integer >= 1` oder nicht gesetzt; Beispiel: `7`                 | Signalstellung für ausgeschaltete Ampel.                                                 |
| `positions.positionOffBlinking` | `integer >= 1` oder nicht gesetzt; Beispiel: `8`                 | Signalstellung für gelb blinkende Ampel.                                                 |

## `RoadStatePublisher`

| Collector               | Raumname                       |
| ----------------------- | ------------------------------ |
| `RoadStatePublisher` | `road-intersections`                |
| `RoadStatePublisher` | `road-intersection-switchings`      |
| `RoadStatePublisher` | `road-intersection-traffic-lights`  |
| `RoadStatePublisher` | `road-intersection-lanes`           |
| `RoadStatePublisher` | `road-module-settings` |

### Raum `road-intersections`

- Jeder Eintrag beschreibt eine Kreuzung mit eindeutiger `id` und einem `name`.
- Wird eine Kreuzung manuell geschaltet, dann ist `manualSwitching` gesetzt. Dann steuert der Nutzer über die EEP-Web-App die Schaltung.

| Name               | Typ und Wertebereich / Beispiel                   | Beschreibung                                                                                                                      |
| ------------------ | ------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| `id`               | `integer >= 1`; Beispiel: `1`                     | Laufende numerische ID je Kreuzung, erzeugt beim Collect in alphabetischer Reihenfolge der Kreuzungsnamen.                      |
| `name`             | `string`; Beispiel: `Bahnhofstraße - Hauptstraße` | Kreuzungsname aus `Intersection:new(name, ...)`.                                                                                     |
| `currentSwitching` | `string` oder nicht gesetzt; Beispiel: `S1a`      | Name der aktuell aktiven Schaltung aus `crossing:getCurrentSequence().name`. Wegen `nil` kann das Feld im JSON komplett fehlen. |
| `manualSwitching`  | `string` oder nicht gesetzt; Beispiel: `S3`       | Name der manuell genutzten Schaltung aus `crossing:getManualSequence().name`.                                                    |
| `nextSwitching`    | `string` oder nicht gesetzt; Beispiel: `S1a`      | Name der als nächstes vorgesehenen Schaltung aus `crossing:getNextSequence().name`.                                              |
| `ready`            | `boolean`; Beispiel: `false`                      | Status aus `crossing:isGreenPhaseFinished()`: `true`, wenn die Kreuzung wieder umschaltbar ist.                                  |
| `timeForGreen`     | `number > 0`; Beispiel: `15`                      | Standard-Grünphase in Sekunden aus `Intersection:new(...)` bzw. `IntersectionSequence:new(...)`.                                         |
| `staticCams`       | `string[]`; Beispiel: `["Kreuzung 1 (von oben)"]` | Konfigurierte statische Kameranamen aus `Intersection:addStaticCam(...)`. Diese Namen werden im Web-Server später zu `EEPSetCamera \| 0 \| <staticCam>` umgesetzt. |

### Raum `road-intersection-switchings`

- Jeder Eintrag beschreibt eine bestimmte Schaltung für eine Kreuzung.
- Die Schaltung enthält eine `prio`, die sich aus der Wichtung der wartenden Fahrzeuge in den Fahrspuren, die für diese Schaltung grün bekommen, sowie der Zeit berechnet, in der diese Schaltung nicht grün war.
- Es kann nur eine Schaltung pro Kreuzung aktiv sein (`currentSwitching` in der Kreuzung).

| Name             | Typ und Wertebereich / Beispiel                                               | Beschreibung                                                                                                                              |
| ---------------- | ----------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| `id`             | `string`, pro Schaltung eindeutig; Beispiel: `Bahnhofstraße - Hauptstraße-S1` | Zusammengesetzter Schlüssel aus Kreuzungsname und Schaltungsname.                                                                        |
| `intersectionId` | `string`; Beispiel: `Bahnhofstraße - Hauptstraße`                             | Referenz auf die Kreuzung. Trotz Feldname ist hier nicht die numerische `intersections.id`, sondern `crossing.name` gespeichert.        |
| `name`           | `string`; Beispiel: `S1`                                                      | Schaltungsname aus `IntersectionSequence.name`.                                                                                               |
| `prio`           | `number`; Beispiel: `11.25`                                                   | Aktuelle Priorität der Schaltung aus `IntersectionSequence.prio`. Sie wird aus der Fahrspur-Logik berechnet, nicht direkt aus EEP gelesen. |

### Raum `road-intersection-traffic-lights`

- Beschreibt eine Ampel einer Kreuzung.
- Normalerweise werden EEP-Signale genutzt, die als Ampelmodelle ausgeführt sind und durch Signalstellungen geschaltet werden. Dann ist `signalId` positiv.
- Unabhängig davon, ob EEP-Signale genutzt werden, können verschiedene Immobilien für rot, gelb, grün und Anforderung beleuchtet werden. Dann sind mehrere `lightStructures` gesetzt. Man kann dabei mehrere gleichzeitig mit einem Index angeben: `lightStructures.<n>.structureRed`, `lightStructures.<n>.structureYellow`, `lightStructures.<n>.structureGreen`, `lightStructures.<n>.structureRequest`.
- Unabhängig davon, ob EEP-Signale genutzt werden, können Immobilien, die mit Achsen gesteuert werden, genutzt werden. Dann sind `axisStructures` gesetzt. Dazu gehört immer ein Immobilienname `structureName`, ein Achsenname `axisName` und die Achsenstellung `position` für die verschiedenen Ampelstellungen rot, gelb, grün usw.

| Name                                   | Typ und Wertebereich / Beispiel                                                                                               | Beschreibung                                                                                                                                                                                                       |
| -------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `id`                                   | `integer`, meist Signal-ID; Beispiel: `95`                                                                                    | Primärschlüssel der Ampel. Bei negativ konfigurierten Signalen wird intern ein eigener negativer Schlüssel verwendet.                                                                                            |
| `signalId`                             | `integer`; Beispiel: `95`                                                                                                     | Signal-ID aus `TrafficLight:new(name, signalId, ...)`. Positive Werte referenzieren ein EEP-Signal; negative Werte stehen für rein logisch verwaltete Signale.                                                   |
| `modelId`                              | `string`; Beispiel: `Unsichtbares Signal`                                                                                     | Name des zugeordneten `TrafficLightModel`.                                                                                                                                                                         |
| `currentPhase`                         | `string`, Werte aus `TrafficLightState`; Beispiel: `Rot`                                                                      | Aktuelle Ampelphase. Bei positiven Signal-IDs initial aus `EEPGetSignal(signalId)` und `TrafficLightModel:phaseOf(...)`, danach aus der Lua-Logik gepflegt. Typische Werte im Snapshot: `Rot`, `Grün`, `Fußg`. |
| `intersectionId`                       | `integer >= 1`; Beispiel: `1`                                                                                                 | Numerische Referenz auf `intersections.id`.                                                                                                                                                                        |
| `lightStructures`                      | Objekt mit String-Schlüsseln oder leeres Array/Objekt; Beispiel: `{ "0": { "structureRed": "#5525_Straba Signal Halt" } }` | Zusatz-Immobilien mit Lichtsteuerung. Der Collector serialisiert hier bewusst kein Array, sondern ein Objekt mit Schlüsseln `"0"`, `"1"` usw.                                                                  |
| `lightStructures.<n>.structureRed`     | `string` oder nicht gesetzt; Beispiel: `#5525_Straba Signal Halt`                                                             | Immobilie, deren Licht bei Rot oder Rot-Gelb geschaltet wird. Verwendet später `EEPStructureSetLight(...)`.                                                                                                      |
| `lightStructures.<n>.structureGreen`   | `string` oder nicht gesetzt; Beispiel: `#5436_Straba Signal rechts`                                                           | Immobilie für Grün.                                                                                                                                                                                                |
| `lightStructures.<n>.structureYellow`  | `string` oder nicht gesetzt; Beispiel: `#5526_Straba Signal anhalten`                                                         | Immobilie für Gelb; fällt beim Anlegen auf `structureRed` zurück.                                                                                                                                                  |
| `lightStructures.<n>.structureRequest` | `string` oder nicht gesetzt; Beispiel: `#5524_Straba Signal A`                                                                | Immobilie für Anforderung; wird über `TrafficLight:showRequestOnSignal(...)` mit `EEPStructureSetLight(...)` geschaltet.                                                                                         |
| `axisStructures`                       | Objekt-Array; Beispiel: `[{"structureName":"#5816_Warnblink Fußgänger rechts"}]`                                          | Zusatz-Immobilien mit Achssteuerung.                                                                                                                                                                               |
| `axisStructures[].structureName`       | `string`; Beispiel: `#5816_Warnblink Fußgänger rechts`                                                                        | Name der Immobilie, deren Achse verstellt wird. Nutzt später `EEPStructureSetAxis(...)`.                                                                                                                          |
| `axisStructures[].axisName`            | `string`; Beispiel: `Blinklicht`                                                                                              | Name der Achse in der Immobilie.                                                                                                                                                                                   |
| `axisStructures[].positionDefault`     | `number`; Beispiel: `0`                                                                                                       | Grundstellung der Achse.                                                                                                                                                                                           |
| `axisStructures[].positionRed`         | `number` oder nicht gesetzt; Beispiel: `0`                                                                                    | Achsstellung für Rot.                                                                                                                                                                                              |
| `axisStructures[].positionGreen`       | `number` oder nicht gesetzt; Beispiel: `50`                                                                                   | Achsstellung für Grün.                                                                                                                                                                                             |
| `axisStructures[].positionYellow`      | `number` oder nicht gesetzt; Beispiel: `0`                                                                                    | Achsstellung für Gelb; fällt beim Anlegen auf `positionRed` zurück.                                                                                                                                                |
| `axisStructures[].positionRedYellow`   | `number` oder nicht gesetzt; Beispiel: `50`                                                                                   | Achsstellung für Rot-Gelb.                                                                                                                                                                                         |
| `axisStructures[].positionPedestrian`  | `number` oder nicht gesetzt; Beispiel: `50`                                                                                   | Achsstellung für Fußgänger-Grün.                                                                                                                                                                                   |

### Raum `road-intersection-lanes`

| Name                         | Typ und Wertebereich / Beispiel                                          | Beschreibung                                                                                                                                                          |
| ---------------------------- | ------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `id`                         | `string`, pro Fahrspur eindeutig; Beispiel: `1-K1 - Fahrspur 01`         | Zusammengesetzter Schlüssel aus numerischer Kreuzungs-ID und Fahrspurname.                                                                                           |
| `intersectionId`             | `integer >= 1`; Beispiel: `1`                                            | Referenz auf `intersections.id`.                                                                                                                                      |
| `name`                       | `string`; Beispiel: `K1 - Fahrspur 01`                                   | Fahrspurname aus `Lane:new(...)`.                                                                                                                                     |
| `phase`                      | `string`, festes Mapping; Beispiel: `GREEN`                              | Vom Collector normalisierte Phase. Werte: `NONE`, `YELLOW`, `RED`, `RED_YELLOW`, `GREEN`, `PEDESTRIAN`. Quelle ist `lane.phase`, also indirekt die Ampelsteuerung. |
| `vehicleMultiplier`          | `number >= 0`; Beispiel: `15`                                            | Prioritätsfaktor aus `lane.fahrzeugMultiplikator`.                                                                                                                   |
| `eepSaveId`                  | `integer`, typischerweise `1..1000` oder `-1`; Beispiel: `8`             | EEP-Datenslot der Fahrspur. Persistenz erfolgt über `StorageUtility.saveTable(...)` und `StorageUtility.loadTable(...)`.                                            |
| `type`                       | `string`, `NORMAL`, `TRAM` oder `PEDESTRIAN`; Beispiel: `TRAM`           | Vom Collector abgeleiteter Fahrspurtyp: Fußgänger bei `Lane.RequestType.FUSSGAENGER`, Tram bei `lane.trafficType == "TRAM"`, sonst `NORMAL`.                        |
| `countType`                  | `string`, `CONTACTS`, `SIGNALS` oder `TRACKS`; Beispiel: `CONTACTS`      | Art der Anforderungsermittlung: Kontaktpunkte, Signalwarteschlange oder Straßen-/Track-Reservierung.                                                                 |
| `waitingTrains`              | `string[]`; Beispiel: `["#Linie 10 - Zug 2"]`                          | Aktuelle Fahrspurwarteschlange aus `lane.queue`. Je nach Konfiguration stammen die Namen aus Kontaktpunkten, `EEPGetSignalTrainName(...)` oder Track-Registrierung. |
| `waitingForGreenCyclesCount` | `integer >= 0`; Beispiel: `6`                                            | Anzahl verpasster Grünzyklen aus `lane.waitCount`.                                                                                                                   |
| `directions`                 | `string[]`, Werte aus `Lane.Directions`; Beispiel: `["LEFT","STRAIGHT"]` | Konfigurierte Fahrtrichtungen. Mögliche Werte: `LEFT`, `HALF-LEFT`, `STRAIGHT`, `HALF-RIGHT`, `RIGHT`.                                                              |
| `switchings`                 | `string[]`; Beispiel: `["S1","S1a"]`                                 | Alle Schaltungen, in denen diese Fahrspur vorkommt. Vom Collector aus den Sequenzen abgeleitet.                                                                      |
| `tracks`                     | `string[]`; Beispiel: `[]`                                               | Optional konfigurierte Gleis-/Straßennamen für Hervorhebung. Keine direkte EEP-Abfrage im Collector.                                                                 |

### Raum `road-module-settings`

- Generelle Einstellungen für das Ampelmodul.
- Hier werden derzeit Anzeigeeinstellungen für Signale und Immobilien hinterlegt, damit man die Schaltungen und Fahrzeugwarteschlangen im Tooltip sehen kann. Diese werden in `IntersectionSettings.xxx` abgelegt.

| Name          | Typ und Wertebereich / Beispiel                                                                          | Beschreibung                                                                                |
| ------------- | -------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| `category`    | `string`; Beispiel: `Tipp-Texte für Kreuzungen`                                                          | Fachliche Gruppe für die Web-App.                                                           |
| `name`        | `string`, pro Setting eindeutig; Beispiel: `Fahrspurzähler einblenden`                                  | Anzeigename des Settings; zugleich Schlüssel des `ListChanged`-Events.                      |
| `description` | `string`; Beispiel: `Zeigt die Belegung der Fahrspuren an einer Kreuzung`                               | Beschreibung für den Einstellungsdialog.                                                    |
| `type`        | `string`, aktuell fest `boolean`; Beispiel: `boolean`                                                    | Datentyp für die Web-App.                                                                   |
| `value`       | `boolean`; Beispiel: `false`                                                                             | Aktueller Wert aus `IntersectionSettings`. Persistiert über `StorageUtility.saveTable(...)`.    |
| `eepFunction` | `string`, Name einer akzeptierten Remote-Funktion; Beispiel: `IntersectionSettings.setShowLanesOnStructure` | Funktionsname, den die Web-App über `CommandEvent.ChangeSetting` an den Web-Server sendet. |

#### Verfügbare `IntersectionSettings`

Alle derzeit verfügbaren `IntersectionSettings` sind boolesche Anzeigeeinstellungen. Sie werden über `IntersectionSettings.loadSettingsFromSlot(eepSaveId)` geladen und über `IntersectionSettings.saveSettings()` mit String-Werten in `StorageUtility` persistiert.

| Setting                | Default / Persistenz / Setter                                                                                 | Beschreibung                                                                                                                                                                                                         |
| ---------------------- | ------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `showRequestsOnSignal` | Default: `false`; Persistenzschlüssel: `reqInfo`; Setter: `IntersectionSettings.setShowRequestsOnSignal(boolean)` | Blendet an Ampeln die aktuellen Anforderungen bzw. Warteschlangeninformationen ein. Zusätzlich werden vorhandene `requestStructure`-Immobilien über `TrafficLight:showRequestOnSignal(...)` sichtbar geschaltet. |
| `showSequenceOnSignal` | Default: `false`; Persistenzschlüssel: `seqInfo`; Setter: `IntersectionSettings.setShowSequenceOnSignal(boolean)` | Zeigt an jeder Ampel die möglichen Schaltungen der Kreuzung und markiert dabei die gerade aktive Schaltung im Tooltip.                                                                                              |
| `showSignalIdOnSignal` | Default: `false`; Persistenzschlüssel: `sigInfo`; Setter: `IntersectionSettings.setShowSignalIdOnSignal(boolean)` | Blendet die Signal-ID bzw. bei virtuellen Signalen die zugeordnete Strukturinformation im Tooltip ein. Das ist vor allem für Aufbau, Diagnose und Mapping der Signale hilfreich.                                   |
| `showLanesOnStructure` | Default: `false`; Persistenzschlüssel: `laneInfo`; Setter: `IntersectionSettings.setShowLanesOnStructure(boolean)` | Zeigt die Belegung der Fahrspuren gesammelt an der für die Kreuzung gesetzten Tipp-Struktur an. Wirksam nur, wenn für die Kreuzung eine `tippStructure` konfiguriert ist.                                          |

## Abgleich mit Web-Server-State und Web-App

### Tatsächlicher Transportpfad

1. `TrafficLightModelStatePublisher` und `RoadStatePublisher` rufen `DataChangeBus.fireListChange(room, keyId, list)` auf.
2. `ServerEventBuffer` puffert daraus JSON-Zeilen-Events im Speicher.
3. `ServerExchangeCoordinator.runServerExchangeCycle(...)` schreibt diese Events über `ServerExchangeFileIo.writeOutgoingEvents(...)` in den Austauschkanal; der persistierte State liegt in `lua/LUA/ce/databridge/exchange/server-state.json`.
4. `apps/web-server/src/server/eep/server-data/EepDataStore.ts` normalisiert `ListChanged` zu `rooms[roomName][element[keyId]] = element`.
5. `apps/web-server/src/server/eep/server-data/static/ServerData.ts` serialisiert diese Objekt-Mappings für REST und Socket-API.
6. Die Web-App hört mit `useApiDataRoomHandler(...)` auf den API-Datenräumen und macht daraus per `Object.values(JSON.parse(payload))` wieder Listen.

### Vergleich Collector-Modell, Web-Server-State und Web-App

Hinweis: Im Auftrag wird `apps/web-app/src/intersections` genannt. Im aktuellen Repo liegen die Road-Consumer tatsächlich unter `apps/web-app/src/mod/intersections`.

| Raumname                       | Collector-Form in Lua      | Form im Web-Server-State / API | Web-App-Nutzung                                                                                      | Abgleich                                                                                                                                                                                                 |
| ------------------------------ | -------------------------- | ------------------------------ | ---------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `signal-type-definitions`      | Liste mit Schlüssel `id`   | Objekt-Mapping nach `id`       | Im aktuellen Intersections-Modul ungenutzt                                                           | Inhalt des Snapshots passt zum Collector; die Web-App hat dafür derzeit keinen Consumer.                                                                                                                |
| `road-intersections`                | Liste mit Schlüssel `id`   | Objekt-Mapping nach `id`       | `useIntersections.tsx`, `useIntersection.tsx`, `IntersectionOverview.tsx`, `IntersectionDetails.tsx` | Passt weitgehend. Achtung: `currentSwitching`, `manualSwitching` und `nextSwitching` können im JSON fehlen, sind im TS-Modell aber als Pflicht-`string` typisiert.                                     |
| `road-intersection-switchings`      | Liste mit Schlüssel `id`   | Objekt-Mapping nach `id`       | `useIntersectionSwitchings.tsx`, `useIntersectionSwitching.tsx`, `IntersectionDetails.tsx`           | Wird aktiv genutzt. Wichtig: `intersectionId` ist hier ein `string` mit dem Kreuzungsnamen, nicht die numerische ID. Die Web-App berücksichtigt das korrekt über `useIntersectionSwitching(i?.name)`. |
| `road-intersection-traffic-lights`  | Liste mit Schlüssel `id`   | Objekt-Mapping nach `id`       | Im aktuellen Intersections-Modul ungenutzt                                                           | Snapshot und Collector passen fachlich zusammen. `lightStructures` bleibt auch im Server-State ein Objekt mit String-Indizes.                                                                          |
| `road-intersection-lanes`           | Liste mit Schlüssel `id`   | Objekt-Mapping nach `id`       | Im aktuellen Intersections-Modul ungenutzt                                                           | Daten werden erzeugt und im State gehalten, aktuell aber nicht in `src/mod/intersections` dargestellt.                                                                                                 |
| `road-module-settings` | Liste mit Schlüssel `name` | Objekt-Mapping nach `name`     | `useIntersectionSettings.tsx`, `ModuleSettingsButton`, `ModuleSetting.tsx`                           | Passt. Die Web-App behandelt die Daten generisch als `LuaSetting<boolean>`.                                                                                                                            |

### Auffällige Schema- und Integrationsbesonderheiten

- Der Collector liefert Listen, der Web-Server-State speichert dieselben Räume aber als Objekte nach `keyId`. Das ist die Form, die auch die Web-App empfängt.
- `road-intersection-switchings.intersectionId` ist ein Kreuzungsname (`string`), während `road-intersection-lanes.intersectionId` und `road-intersection-traffic-lights.intersectionId` numerische IDs sind.
- `road-intersection-traffic-lights.lightStructures` wird als Objekt mit String-Indizes serialisiert, nicht als JSON-Array.
- Mehrere Felder in `road-intersections` sind optional, weil Lua-`nil`-Felder beim JSON-Export nicht erscheinen.
- Der aktuelle Snapshot in `server-state.json` enthält bereits alle sechs Road-Räume.
- Der Web-Server-Reducer merged `ListChanged` aktuell in vorhandene Raumobjekte hinein. Für die Road-Räume ist das nur dann exakt, wenn Schlüssel nicht verschwinden oder vorher ein `CompleteReset` erfolgt.

## Events in `ce/mods/road`

### Von den Collectoren erzeugte Daten-Events

| Ursprung in `ce/mods/road`                          | Eventtyp      | Raum / Schlüssel                        |
| ---------------------------------------------- | ------------- | --------------------------------------- |
| `TrafficLightModelStatePublisher.syncState()` | `ListChanged` | `signal-type-definitions` / `id`        |
| `RoadStatePublisher.syncState()`          | `ListChanged` | `road-intersections` / `id`                  |
| `RoadStatePublisher.syncState()`          | `ListChanged` | `road-intersection-lanes` / `id`             |
| `RoadStatePublisher.syncState()`          | `ListChanged` | `road-intersection-switchings` / `id`        |
| `RoadStatePublisher.syncState()`          | `ListChanged` | `road-intersection-traffic-lights` / `id`    |
| `RoadStatePublisher.syncState()`          | `ListChanged` | `road-module-settings` / `name` |

### In `ce/mods/road` ausgewertete Eingangs-Events und Callbacks

| Ursprung                    | Event / Callback                                     | Weiterleitung / Aufruf                                                                                          | Auswertung in `ce/mods/road`                                                 | Wirkung                                                         |
| --------------------------- | ---------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------- | --------------------------------------------------------------- |
| Web-App Kreuzungsdetail     | `[Road Event] Switch Automatically`          | Web-Server erzeugt `AkKreuzungSchalteAutomatisch \| <intersectionName>`                                         | `Intersection.switchAutomatically(crossingName)`                            | Setzt die Kreuzung in den Automatikmodus zurück.                |
| Web-App Kreuzungsdetail     | `[Road Event] Switch Manually`               | Web-Server erzeugt `AkKreuzungSchalteManuell \| <intersectionName> \| <switchingName>`                         | `Intersection.switchManuallyTo(crossingName, sequenceName)`                 | Erzwingt eine bestimmte Schaltung als manuelle Schaltung.       |
| Web-App Einstellungsdialog  | `[Command Event] Change Setting`                     | Web-Server erzeugt `<eepFunction> \| <newValue>`; Aufruf `IntersectionSettings.setShowRequestsOnSignal(param == "true")` | Schaltet Tipptexte für Anforderungen und speichert den Wert.            |
| Web-App Einstellungsdialog  | `[Command Event] Change Setting`                     | Web-Server erzeugt `<eepFunction> \| <newValue>`; Aufruf `IntersectionSettings.setShowSequenceOnSignal(param == "true")` | Schaltet Tipptexte für Schaltungen und speichert den Wert.              |
| Web-App Einstellungsdialog  | `[Command Event] Change Setting`                     | Web-Server erzeugt `<eepFunction> \| <newValue>`; Aufruf `IntersectionSettings.setShowSignalIdOnSignal(param == "true")` | Schaltet Signal-ID-Tipptexte und speichert den Wert.                    |
| Web-App Einstellungsdialog  | `[Command Event] Change Setting`                     | Web-Server erzeugt `<eepFunction> \| <newValue>`; Aufruf `IntersectionSettings.setShowLanesOnStructure(param == "true")` | Schaltet Fahrspurzähler-Tipptexte und speichert den Wert.               |
| EEP-Weichenereignis         | globaler Callback `EEPOnSwitch_<switchId>`           | Registrierung in `TramSwitch.new(...)` über `_G[...]`                                                           | Liest `EEPGetSwitch(switchId)` und schaltet `EEPStructureSetLight(...)` | Spiegelt die Straßenbahnweichenstellung auf Licht-Immobilien.   |
| EEP-Fahrzeuginitialisierung | globaler Callback `FAHRZEUG_INITIALISIERE(fahrzeug)` | Direkter EEP-Aufruf                                                                                             | `Bus.initialisiere(fahrzeug)`                                           | Schaltet Fahrer- und Fahrgastachsen per `EEPSetTrainAxis(...)`. |

### Angrenzende UI-Events, aber nicht in `ce/mods/road` ausgewertet

| Event                          | Zweck                                                            | Tatsächliche Auswertung                                                                                     |
| ------------------------------ | ---------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| `[Command Event] Change Cam`   | Umschalten auf statische Kamera aus `intersections[].staticCams` | Nicht in `ce/mods/road`, sondern im Web-Server-Command-Modul; daraus wird `EEPSetCamera \| 0 \| <staticCam>`. |
| `[Room] Join` / `[Room] Leave` | Beitritt und Verlassen von Socket-Räumen                         | Infrastruktur der Web-App/Web-Server-Schicht, nicht `ce/mods/road`.                                            |
