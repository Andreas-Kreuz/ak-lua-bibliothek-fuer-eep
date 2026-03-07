# Datenmodell der JSON-Collector in `ak/road`

Diese Datei beschreibt das aktuell aus `lua/LUA/ak/road` erzeugte JSON-Datenmodell.

Wichtige Vorbemerkungen:

- Primaerquellen sind `TrafficLightModelJsonCollector.lua`, `CrossingJsonCollector.lua` und die von ihnen verwendeten Modelle.
- Beide Collector erzeugen ihre Nutzdaten fachlich ueber `DataChangeBus.fireListChange(...)`. `collectData()` liefert aktuell selbst nur leere Tabellen zurueck.
- Der Lua-Collector sendet Listen. Der Web-Server normalisiert diese Listen danach zu Objekt-Mappings nach `keyId` und speichert sie so in `lua/LUA/ak/io/exchange/ak-eep-web-server-state.json`.

## `TrafficLightModelJsonCollector`

| Collector                        | Raumname                  |
| -------------------------------- | ------------------------- |
| `TrafficLightModelJsonCollector` | `signal-type-definitions` |

### Raum `signal-type-definitions`

Jeder Eintrag beschreibt das Verhalten eines bestimmten Modells von Ampeln. Das Model bestimmt, welche Signalstellung für die Ampelschaltung genutzt werden soll, d.h. für rot, gelb, grün, Fußgängergrün usw.
Diese Signalstellungen kann als `signalIndex` für `EEPSetSignal(signalId, signalIndex, 1)` verwendet werden und kommt bei `EEPGetSignal(signalId)` als zweiter Rückgabewert zurück.

| Name                            | Typ und Wertebereich / Beispiel                                  | Beschreibung                                                                               |
| ------------------------------- | ---------------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| `id`                            | `string`, pro Modell eindeutig; Beispiel: `Ampel_3er_XXX_mit_FG` | Technischer Schluessel; identisch zu `name`.                                               |
| `name`                          | `string`; Beispiel: `Ampel_3er_XXX_mit_FG`                       | Modellname aus `TrafficLightModel:new(...)`.                                               |
| `type`                          | `string`, aktuell fest `road`; Beispiel: `road`                  | Kennzeichnet Strassensignalmodelle (Ampeln).                                               |
| `positions`                     | Objekt; Beispiel: `{ "positionRed": 1, "positionGreen": 3 }`     | Signalstellungen für `signalIndex` für `EEPSetSignal(signalId, signalIndex, 1)`            |
| `positions.positionRed`         | `integer >= 1`; Beispiel: `1`                                    | Signalstellung für eine rote Ampel.                                                        |
| `positions.positionGreen`       | `integer >= 1`; Beispiel: `3`                                    | Signalstellung für eine grüne Ampel.                                                       |
| `positions.positionYellow`      | `integer >= 1`; Beispiel: `5`                                    | Signalstellung für eine gelbe Ampel; im Modell optional, faellt sonst auf Rot zurueck.     |
| `positions.positionRedYellow`   | `integer >= 1`; Beispiel: `2`                                    | Signalstellung für eine rot-gelbe Ampel; im Modell optional, faellt sonst auf Rot zurueck. |
| `positions.positionPedestrians` | `integer >= 1` oder nicht gesetzt; Beispiel: `6`                 | Signalstellung für grün für Fußgänger. Der JSON-Feldname ist absichtlich pluralisiert.     |
| `positions.positionOff`         | `integer >= 1` oder nicht gesetzt; Beispiel: `7`                 | Signalstellung für ausgeschaltete Ampel                                                    |
| `positions.positionOffBlinking` | `integer >= 1` oder nicht gesetzt; Beispiel: `8`                 | Signalstellung für gelb blinkende Ampel.                                                   |

## `CrossingJsonCollector`

| Collector               | Raumname                       |
| ----------------------- | ------------------------------ |
| `CrossingJsonCollector` | `intersections`                |
| `CrossingJsonCollector` | `intersection-switchings`      |
| `CrossingJsonCollector` | `intersection-traffic-lights`  |
| `CrossingJsonCollector` | `intersection-lanes`           |
| `CrossingJsonCollector` | `intersection-module-settings` |

### Raum `intersections`

- Jeder Eintrag beschreibt eine Kreuzung mit eindeutiger `id` und einem `namen`.
- Wird eine Kreuzung manuell geschaltet, dann ist `manualSwitching` gesetzt. Dann steuert der Nutzer über die EEP-Web-App die Schaltung.

| Name               | Typ und Wertebereich / Beispiel                     | Beschreibung                                                                                                                    |
| ------------------ | --------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- | --- | ----------------------- |
| `id`               | `integer >= 1`; Beispiel: `1`                       | Laufende numerische ID je Kreuzung, erzeugt beim Collect in alphabetischer Reihenfolge der Kreuzungsnamen.                      |
| `name`             | `string`; Beispiel: `Bahnhofstrasse - Hauptstrasse` | Kreuzungsname aus `Crossing:new(name, ...)`.                                                                                    |
| `currentSwitching` | `string` oder nicht gesetzt; Beispiel: `S1a`        | Name der aktuell aktiven Schaltung aus `crossing:getCurrentSequence().name`. Wegen `nil` kann das Feld im JSON komplett fehlen. |
| `manualSwitching`  | `string` oder nicht gesetzt; Beispiel: `S3`         | Name der manuell genutzten Schaltung aus `crossing:getManualSequence().name`.                                                   |
| `nextSwitching`    | `string` oder nicht gesetzt; Beispiel: `S1a`        | Name der als naechstes vorgesehenen Schaltung aus `crossing:getNextSequence().name`.                                            |
| `ready`            | `boolean`; Beispiel: `false`                        | Status aus `crossing:isGreenPhaseFinished()`: `true`, wenn die Kreuzung wieder umschaltbar ist.                                 |
| `timeForGreen`     | `number > 0`; Beispiel: `15`                        | Standard-Gruenphase in Sekunden aus `Crossing:new(...)` bzw. `CrossingSequence:new(...)`.                                       |
| `staticCams`       | `string[]`; Beispiel: `["Kreuzung 1 (von oben)"]`   | Konfigurierte statische Kameranamen aus `Crossing:addStaticCam(...)`. Diese Namen werden im Web-Server spaeter zu `EEPSetCamera | 0   | <staticCam>` umgesetzt. |

### Raum `intersection-switchings`

- Jeder Eintrag beschreibt eine bestimmte Schaltung für eine Kreuzung
- Die Schaltung enthält eine prio, die sich aus der Wichtung der wartenden Fahrzeuge in den Fahrspuren, die für diese Schaltung grün bekommen, sowie der Zeit in der diese Schaltung nicht grün war berechnet.
- Es kann nur eine Schaltung pro Kreuzung aktiv sein (`currentSwitching` in der Kreuzung)

| Name             | Typ und Wertebereich / Beispiel                                                 | Beschreibung                                                                                                                            |
| ---------------- | ------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| `id`             | `string`, pro Schaltung eindeutig; Beispiel: `Bahnhofstrasse - Hauptstrasse-S1` | Zusammengesetzter Schluessel aus Kreuzungsname und Schaltungsname.                                                                      |
| `intersectionId` | `string`; Beispiel: `Bahnhofstrasse - Hauptstrasse`                             | Referenz auf die Kreuzung. Trotz Feldname ist hier nicht die numerische `intersections.id`, sondern `crossing.name` gespeichert.        |
| `name`           | `string`; Beispiel: `S1`                                                        | Schaltungsname aus `CrossingSequence.name`.                                                                                             |
| `prio`           | `number`; Beispiel: `11.25`                                                     | Aktuelle Prioritaet der Schaltung aus `CrossingSequence.prio`. Sie wird aus der Fahrspur-Logik berechnet, nicht direkt aus EEP gelesen. |

### Raum `intersection-traffic-lights`

- Beschreibt eine Ampel einer Kreuzung.
- Normalerweise werden EEP-Signale genutzt, die als Ampelmodelle ausgeführt sind und sie werden durch Signalstellungen geschaltet, dann ist `signalId` positiv.
- Unabhängig davon, ob EEP-Signale genutzt werden, können verschiedene Immobilien für rot, gelb, grün und Anforderung beleuchtet werden. Dann sind mehrere lightstructures gesetzt. Man kann dabei mehrere gleichzeig mit einem index angeben: `lightStructures.<n>.structureRed`, `lightStructures.<n>.structureYellow`, `lightStructures.<n>.structureGreen`, `lightStructures.<n>.structureRequest`.
- Unabhängig davon, ob EEP-Signale genutzt werden, können Immobilien, die mit Achsen gesteuert werden, genutzt werden. Dann sind `axisStructures` für die jeweiligen gesetzt. Dazu gehört immer ein Immobilienname `structureName`, ein Achsenname `axisName` und die Achsenstellung `position` für die verschiedenen Ampelstellungen rot, gelb, grün, usw.,

| Name                                   | Typ und Wertebereich / Beispiel                                                                                             | Beschreibung                                                                                                                                                                                                     |
| -------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `id`                                   | `integer`, meist Signal-ID; Beispiel: `95`                                                                                  | Primaerschluessel der Ampel. Bei negativ konfigurierten Signalen wird intern ein eigener negativer Schluessel verwendet.                                                                                         |
| `signalId`                             | `integer`; Beispiel: `95`                                                                                                   | Signal-ID aus `TrafficLight:new(name, signalId, ...)`. Positive Werte referenzieren ein EEP-Signal; negative Werte stehen fuer rein logisch verwaltete Signale.                                                  |
| `modelId`                              | `string`; Beispiel: `Unsichtbares Signal`                                                                                   | Name des zugeordneten `TrafficLightModel`.                                                                                                                                                                       |
| `currentPhase`                         | `string`, Werte aus `TrafficLightState`; Beispiel: `Rot`                                                                    | Aktuelle Ampelphase. Bei positiven Signal-IDs initial aus `EEPGetSignal(signalId)` und `TrafficLightModel:phaseOf(...)`, danach aus der Lua-Logik gepflegt. Typische Werte im Snapshot: `Rot`, `Gruen`, `Fussg`. |
| `intersectionId`                       | `integer >= 1`; Beispiel: `1`                                                                                               | Numerische Referenz auf `intersections.id`.                                                                                                                                                                      |
| `lightStructures`                      | Objekt mit String-Schluesseln oder leeres Array/Objekt; Beispiel: `{ "0": { "structureRed": "#5525_Straba Signal Halt" } }` | Zusatz-Immobilien mit Lichtsteuerung. Der Collector serialisiert hier bewusst kein Array, sondern ein Objekt mit Schluesseln `"0"`, `"1"`, ...                                                                   |
| `lightStructures.<n>.structureRed`     | `string` oder nicht gesetzt; Beispiel: `#5525_Straba Signal Halt`                                                           | Immobilie, deren Licht bei Rot oder Rot-Gelb geschaltet wird. Verwendet spaeter `EEPStructureSetLight(...)`.                                                                                                     |
| `lightStructures.<n>.structureGreen`   | `string` oder nicht gesetzt; Beispiel: `#5436_Straba Signal rechts`                                                         | Immobilie fuer Gruen.                                                                                                                                                                                            |
| `lightStructures.<n>.structureYellow`  | `string` oder nicht gesetzt; Beispiel: `#5526_Straba Signal anhalten`                                                       | Immobilie fuer Gelb; faellt beim Anlegen auf `structureRed` zurueck.                                                                                                                                             |
| `lightStructures.<n>.structureRequest` | `string` oder nicht gesetzt; Beispiel: `#5524_Straba Signal A`                                                              | Immobilie fuer Anforderung; wird ueber `TrafficLight:showRequestOnSignal(...)` mit `EEPStructureSetLight(...)` geschaltet.                                                                                       |
| `axisStructures`                       | Objekt-Array; Beispiel: `[{"structureName":"#5816_Warnblink Fussgaenger rechts"}]`                                          | Zusatz-Immobilien mit Achssteuerung.                                                                                                                                                                             |
| `axisStructures[].structureName`       | `string`; Beispiel: `#5816_Warnblink Fussgaenger rechts`                                                                    | Name der Immobilie, deren Achse verstellt wird. Nutzt spaeter `EEPStructureSetAxis(...)`.                                                                                                                        |
| `axisStructures[].axisName`            | `string`; Beispiel: `Blinklicht`                                                                                            | Name der Achse in der Immobilie.                                                                                                                                                                                 |
| `axisStructures[].positionDefault`     | `number`; Beispiel: `0`                                                                                                     | Grundstellung der Achse.                                                                                                                                                                                         |
| `axisStructures[].positionRed`         | `number` oder nicht gesetzt; Beispiel: `0`                                                                                  | Achsstellung fuer Rot.                                                                                                                                                                                           |
| `axisStructures[].positionGreen`       | `number` oder nicht gesetzt; Beispiel: `50`                                                                                 | Achsstellung fuer Gruen.                                                                                                                                                                                         |
| `axisStructures[].positionYellow`      | `number` oder nicht gesetzt; Beispiel: `0`                                                                                  | Achsstellung fuer Gelb; faellt beim Anlegen auf `positionRed` zurueck.                                                                                                                                           |
| `axisStructures[].positionRedYellow`   | `number` oder nicht gesetzt; Beispiel: `50`                                                                                 | Achsstellung fuer Rot-Gelb.                                                                                                                                                                                      |
| `axisStructures[].positionPedestrian`  | `number` oder nicht gesetzt; Beispiel: `50`                                                                                 | Achsstellung fuer Fussgaenger-Gruen.                                                                                                                                                                             |

### Raum `intersection-lanes`

| Name                         | Typ und Wertebereich / Beispiel                                          | Beschreibung                                                                                                                                                        |
| ---------------------------- | ------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `id`                         | `string`, pro Fahrspur eindeutig; Beispiel: `1-K1 - Fahrspur 01`         | Zusammengesetzter Schluessel aus numerischer Kreuzungs-ID und Fahrspurname.                                                                                         |
| `intersectionId`             | `integer >= 1`; Beispiel: `1`                                            | Referenz auf `intersections.id`.                                                                                                                                    |
| `name`                       | `string`; Beispiel: `K1 - Fahrspur 01`                                   | Fahrspurname aus `Lane:new(...)`.                                                                                                                                   |
| `phase`                      | `string`, festes Mapping; Beispiel: `GREEN`                              | Vom Collector normalisierte Phase. Werte: `NONE`, `YELLOW`, `RED`, `RED_YELLOW`, `GREEN`, `PEDESTRIAN`. Quelle ist `lane.phase`, also indirekt die Ampelsteuerung.  |
| `vehicleMultiplier`          | `number >= 0`; Beispiel: `15`                                            | Prioritaetsfaktor aus `lane.fahrzeugMultiplikator`.                                                                                                                 |
| `eepSaveId`                  | `integer`, typischerweise `1..1000` oder `-1`; Beispiel: `8`             | EEP-Datenslot der Fahrspur. Persistenz erfolgt ueber `StorageUtility.saveTable(...)` und `StorageUtility.loadTable(...)`.                                           |
| `type`                       | `string`, `NORMAL`, `TRAM` oder `PEDESTRIAN`; Beispiel: `TRAM`           | Vom Collector abgeleiteter Fahrspurtyp: Fussgaenger bei `Lane.RequestType.FUSSGAENGER`, Tram bei `lane.trafficType == "TRAM"`, sonst `NORMAL`.                      |
| `countType`                  | `string`, `CONTACTS`, `SIGNALS` oder `TRACKS`; Beispiel: `CONTACTS`      | Art der Anforderungsermittlung: Kontaktpunkte, Signalwarteschlange oder Strassen-/Track-Reservierung.                                                               |
| `waitingTrains`              | `string[]`; Beispiel: `["#Linie 10 - Zug 2"]`                            | Aktuelle Fahrspurwarteschlange aus `lane.queue`. Je nach Konfiguration stammen die Namen aus Kontaktpunkten, `EEPGetSignalTrainName(...)` oder Track-Registrierung. |
| `waitingForGreenCyclesCount` | `integer >= 0`; Beispiel: `6`                                            | Anzahl verpasster Gruenzyklen aus `lane.waitCount`.                                                                                                                 |
| `directions`                 | `string[]`, Werte aus `Lane.Directions`; Beispiel: `["LEFT","STRAIGHT"]` | Konfigurierte Fahrtrichtungen. Moegliche Werte: `LEFT`, `HALF-LEFT`, `STRAIGHT`, `HALF-RIGHT`, `RIGHT`.                                                             |
| `switchings`                 | `string[]`; Beispiel: `["S1","S1a"]`                                     | Alle Schaltungen, in denen diese Fahrspur vorkommt. Vom Collector aus den Sequenzen abgeleitet.                                                                     |
| `tracks`                     | `string[]`; Beispiel: `[]`                                               | Optional konfigurierte Gleis-/Strassennamen fuer Hervorhebung. Keine direkte EEP-Abfrage im Collector.                                                              |

### Raum `intersection-module-settings`

- Generelle Einstellungen für das Ampelmodul.
- Hier werden derzeit Anzeigeeinstellungen für Signale und Immobilien hinterlegt, damit man die Schaltungen und Fahrzeugwarteschlangen im Tooltip sehen kann. Diese werden in `CrossingSettings.xxx` abgelegt.

| Name          | Typ und Wertebereich / Beispiel                                                                         | Beschreibung                                                                                |
| ------------- | ------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| `category`    | `string`; Beispiel: `Tipp-Texte fuer Kreuzungen`                                                        | Fachliche Gruppe fuer die Web-App.                                                          |
| `name`        | `string`, pro Setting eindeutig; Beispiel: `Fahrspurzaehler einblenden`                                 | Anzeigename des Settings; zugleich Schluessel des `ListChanged`-Events.                     |
| `description` | `string`; Beispiel: `Zeigt die Belegung der Fahrspuren an einer Kreuzung`                               | Beschreibung fuer den Einstellungsdialog.                                                   |
| `type`        | `string`, aktuell fest `boolean`; Beispiel: `boolean`                                                   | Datentyp fuer die Web-App.                                                                  |
| `value`       | `boolean`; Beispiel: `false`                                                                            | Aktueller Wert aus `CrossingSettings`. Persistiert ueber `StorageUtility.saveTable(...)`.   |
| `eepFunction` | `string`, Name einer akzeptierten Remote-Funktion; Beispiel: `CrossingSettings.setShowLanesOnStructure` | Funktionsname, den die Web-App ueber `CommandEvent.ChangeSetting` an den Web-Server sendet. |

#### Verfuegbare `CrossingSettings`

Alle derzeit verfuegbaren `CrossingSettings` sind boolesche Anzeigeeinstellungen. Sie werden ueber `CrossingSettings.loadSettingsFromSlot(eepSaveId)` geladen und ueber `CrossingSettings.saveSettings()` mit String-Werten in `StorageUtility` persistiert.

| Setting                | Default / Persistenz / Setter                                                                                   | Beschreibung                                                                                                                                                                                                       |
| ---------------------- | --------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `showRequestsOnSignal` | Default: `false`; Persistenzschluessel: `reqInfo`; Setter: `CrossingSettings.setShowRequestsOnSignal(boolean)`  | Blendet an Ampeln die aktuellen Anforderungen bzw. Warteschlangeninformationen ein. Zusaetzlich werden vorhandene `requestStructure`-Immobilien ueber `TrafficLight:showRequestOnSignal(...)` sichtbar geschaltet. |
| `showSequenceOnSignal` | Default: `false`; Persistenzschluessel: `seqInfo`; Setter: `CrossingSettings.setShowSequenceOnSignal(boolean)`  | Zeigt an jeder Ampel die moeglichen Schaltungen der Kreuzung und markiert dabei die gerade aktive Schaltung im Tooltip.                                                                                            |
| `showSignalIdOnSignal` | Default: `false`; Persistenzschluessel: `sigInfo`; Setter: `CrossingSettings.setShowSignalIdOnSignal(boolean)`  | Blendet die Signal-ID bzw. bei virtuellen Signalen die zugeordnete Strukturinformation im Tooltip ein. Das ist vor allem fuer Aufbau, Diagnose und Mapping der Signale hilfreich.                                  |
| `showLanesOnStructure` | Default: `false`; Persistenzschluessel: `laneInfo`; Setter: `CrossingSettings.setShowLanesOnStructure(boolean)` | Zeigt die Belegung der Fahrspuren gesammelt an der fuer die Kreuzung gesetzten Tipp-Struktur an. Wirksam nur, wenn fuer die Kreuzung eine `tippStructure` konfiguriert ist.                                        |

## Abgleich mit Web-Server-State und Web-App

### Tatsaechlicher Transportpfad

1. `TrafficLightModelJsonCollector` und `CrossingJsonCollector` rufen `DataChangeBus.fireListChange(room, keyId, list)` auf.
2. `EventRecorder` schreibt daraus JSON-Zeilen-Events.
3. `ServerController.communicateWithServer(...)` schreibt diese Events in den Austauschkanal; der persistierte State liegt in `lua/LUA/ak/io/exchange/ak-eep-web-server-state.json`.
4. `apps/web-server/src/server/eep/server-data/EepDataStore.ts` normalisiert `ListChanged` zu `rooms[roomName][element[keyId]] = element`.
5. `apps/web-server/src/server/eep/server-data/static/ServerData.ts` serialisiert diese Objekt-Mappings fuer REST und Socket-API.
6. Die Web-App hoert mit `useApiDataRoomHandler(...)` auf den API-Datenraeumen und macht daraus per `Object.values(JSON.parse(payload))` wieder Listen.

### Vergleich Collector-Modell, Web-Server-State und Web-App

Hinweis: Im Auftrag wird `apps/web-app/src/intersections` genannt. Im aktuellen Repo liegen die Road-Consumer tatsaechlich unter `apps/web-app/src/mod/intersections`.

| Raumname                       | Collector-Form in Lua       | Form im Web-Server-State / API | Web-App-Nutzung                                                                                      | Abgleich                                                                                                                                                                                                |
| ------------------------------ | --------------------------- | ------------------------------ | ---------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `signal-type-definitions`      | Liste mit Schluessel `id`   | Objekt-Mapping nach `id`       | Im aktuellen Intersections-Modul ungenutzt                                                           | Inhalt des Snapshots passt zum Collector; die Web-App hat dafuer derzeit keinen Consumer.                                                                                                               |
| `intersections`                | Liste mit Schluessel `id`   | Objekt-Mapping nach `id`       | `useIntersections.tsx`, `useIntersection.tsx`, `IntersectionOverview.tsx`, `IntersectionDetails.tsx` | Passt weitgehend. Achtung: `currentSwitching`, `manualSwitching` und `nextSwitching` koennen im JSON fehlen, sind im TS-Modell aber als Pflicht-`string` typisiert.                                     |
| `intersection-switchings`      | Liste mit Schluessel `id`   | Objekt-Mapping nach `id`       | `useIntersectionSwitchings.tsx`, `useIntersectionSwitching.tsx`, `IntersectionDetails.tsx`           | Wird aktiv genutzt. Wichtig: `intersectionId` ist hier ein `string` mit dem Kreuzungsnamen, nicht die numerische ID. Die Web-App beruecksichtigt das korrekt ueber `useIntersectionSwitching(i?.name)`. |
| `intersection-traffic-lights`  | Liste mit Schluessel `id`   | Objekt-Mapping nach `id`       | Im aktuellen Intersections-Modul ungenutzt                                                           | Snapshot und Collector passen fachlich zusammen. `lightStructures` bleibt auch im Server-State ein Objekt mit String-Indizes.                                                                           |
| `intersection-lanes`           | Liste mit Schluessel `id`   | Objekt-Mapping nach `id`       | Im aktuellen Intersections-Modul ungenutzt                                                           | Daten werden erzeugt und im State gehalten, aktuell aber nicht in `src/mod/intersections` dargestellt.                                                                                                  |
| `intersection-module-settings` | Liste mit Schluessel `name` | Objekt-Mapping nach `name`     | `useIntersectionSettings.tsx`, `ModuleSettingsButton`, `ModuleSetting.tsx`                           | Passt. Die Web-App behandelt die Daten generisch als `LuaSetting<boolean>`.                                                                                                                             |

### Auffaellige Schema- und Integrationsbesonderheiten

- Der Collector liefert Listen, der Web-Server-State speichert dieselben Raeume aber als Objekte nach `keyId`. Das ist die Form, die auch die Web-App empfaengt.
- `intersection-switchings.intersectionId` ist ein Kreuzungsname (`string`), waehrend `intersection-lanes.intersectionId` und `intersection-traffic-lights.intersectionId` numerische IDs sind.
- `intersection-traffic-lights.lightStructures` wird als Objekt mit String-Indizes serialisiert, nicht als JSON-Array.
- Mehrere Felder in `intersections` sind optional, weil Lua `nil`-Felder beim JSON-Export nicht erscheinen.
- Der aktuelle Snapshot in `ak-eep-web-server-state.json` enthaelt bereits alle sechs Road-Raeume.
- Der Web-Server-Reducer merged `ListChanged` aktuell in vorhandene Raumobjekte hinein. Fuer die Road-Raeume ist das nur dann exakt, wenn Schluessel nicht verschwinden oder vorher ein `CompleteReset` erfolgt.

## Events in `ak/road`

### Von den Collectoren erzeugte Daten-Events

| Ursprung in `ak/road`                          | Eventtyp      | Raum / Schluessel                       |
| ---------------------------------------------- | ------------- | --------------------------------------- |
| `TrafficLightModelJsonCollector.collectData()` | `ListChanged` | `signal-type-definitions` / `id`        |
| `CrossingJsonCollector.collectData()`          | `ListChanged` | `intersections` / `id`                  |
| `CrossingJsonCollector.collectData()`          | `ListChanged` | `intersection-lanes` / `id`             |
| `CrossingJsonCollector.collectData()`          | `ListChanged` | `intersection-switchings` / `id`        |
| `CrossingJsonCollector.collectData()`          | `ListChanged` | `intersection-traffic-lights` / `id`    |
| `CrossingJsonCollector.collectData()`          | `ListChanged` | `intersection-module-settings` / `name` |

### In `ak/road` ausgewertete Eingangs-Events und Callbacks

| Ursprung                    | Event / Callback                                     | Weiterleitung / Aufruf                                                                                          | Auswertung in `ak/road`                                                 | Wirkung                                                         |
| --------------------------- | ---------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------- | --------------------------------------------------------------- |
| Web-App Kreuzungsdetail     | `[Intersection Event] Switch Automatically`          | Web-Server erzeugt `AkKreuzungSchalteAutomatisch \| <intersectionName>`                                         | `Crossing.switchAutomatically(crossingName)`                            | Setzt die Kreuzung in den Automatikmodus zurueck.               |
| Web-App Kreuzungsdetail     | `[Intersection Event] Switch Manually`               | Web-Server erzeugt `AkKreuzungSchalteManuell \| <intersectionName> \| <switchingName>`                          | `Crossing.switchManuallyTo(crossingName, sequenceName)`                 | Erzwingt eine bestimmte Schaltung als manuelle Schaltung.       |
| Web-App Einstellungsdialog  | `[Command Event] Change Setting`                     | Web-Server erzeugt `<eepFunction> \| <newValue>` \| `CrossingSettings.setShowRequestsOnSignal(param == "true")` | Schaltet Tipptexte fuer Anforderungen und speichert den Wert.           |
| Web-App Einstellungsdialog  | `[Command Event] Change Setting`                     | Web-Server erzeugt `<eepFunction> \| <newValue>` \| `CrossingSettings.setShowSequenceOnSignal(param == "true")` | Schaltet Tipptexte fuer Schaltungen und speichert den Wert.             |
| Web-App Einstellungsdialog  | `[Command Event] Change Setting`                     | Web-Server erzeugt `<eepFunction> \| <newValue>` \| `CrossingSettings.setShowSignalIdOnSignal(param == "true")` | Schaltet Signal-ID-Tipptexte und speichert den Wert.                    |
| Web-App Einstellungsdialog  | `[Command Event] Change Setting`                     | Web-Server erzeugt `<eepFunction>\| <newValue>` \| `CrossingSettings.setShowLanesOnStructure(param == "true")`  | Schaltet Fahrspurzaehler-Tipptexte und speichert den Wert.              |
| EEP-Weichenereignis         | globaler Callback `EEPOnSwitch_<switchId>`           | Registrierung in `TramSwitch.new(...)` ueber `_G[...]`                                                          | Liest `EEPGetSwitch(switchId)` und schaltet `EEPStructureSetLight(...)` | Spiegelt die Strassenbahnweichenstellung auf Licht-Immobilien.  |
| EEP-Fahrzeuginitialisierung | globaler Callback `FAHRZEUG_INITIALISIERE(fahrzeug)` | Direkter EEP-Aufruf                                                                                             | `Bus.initialisiere(fahrzeug)`                                           | Schaltet Fahrer- und Fahrgastachsen per `EEPSetTrainAxis(...)`. |

### Angrenzende UI-Events, aber nicht in `ak/road` ausgewertet

| Event                          | Zweck                                                            | Tatsaechliche Auswertung                                                                                   |
| ------------------------------ | ---------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| `[Command Event] Change Cam`   | Umschalten auf statische Kamera aus `intersections[].staticCams` | Nicht in `ak/road`, sondern im Web-Server-Command-Modul; daraus wird `EEPSetCamera \| 0   \| <staticCam>`. |
| `[Room] Join` / `[Room] Leave` | Beitritt und Verlassen von Socket-Raeumen                        | Infrastruktur der Web-App/Web-Server-Schicht, nicht `ak/road`.                                             |
