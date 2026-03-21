# Migration von `ak` nach `ce` für deine EEP-Skripte

Du hast bisher deine Anlage mit der Lua-Bibliothek für EEP betrieben und willst jetzt auf die Control Extension für EEP umstellen, dann beachte folgende Umstellungen:

- Alte `require()`-Aufrufe mit `ak.*` funktionieren in der aktuellen Control Extension nicht mehr.
- Der bisherige Einstieg über `ak.LuaForEEP` oder `ak.core.ModuleRegistry` wurde durch `ce.ControlExtension` ersetzt.
- Die alten `*LuaModule`-Module wurden durch neue `*CeModule`-Module ersetzt.
- Viele bisher flache `ak.*`-Bereiche wurden fachlich nach `ce.hub`, `ce.databridge` und `ce.mods.*` aufgeteilt.

Die folgenden Zuordnungen zeigen dir, was du stattdessen laden und aufrufen musst.

## Häufigster Bruch beim Umstieg

Wenn du bisher so gestartet hast:

```lua
local ModuleRegistry = require("ak.core.ModuleRegistry")

ModuleRegistry.debug = true
ModuleRegistry.pauseEepDuringInitialization = true
ModuleRegistry.registerModules(
    require("ak.data.DataLuaModule"),
    require("ak.road.CrossingLuaModule"),
    require("ak.transit.TransitLuaModule")
)

function EEPMain()
    ModuleRegistry.runTasks(1)
    return 1
end
```

dann muss dein Einstieg jetzt so aussehen:

```lua
local ControlExtension = require("ce.ControlExtension")

ControlExtension.setDebug(true)
ControlExtension.setPauseEepDuringInitialization(true)
ControlExtension.addModules(
    require("ce.hub.mods.DataCeModule"),
    require("ce.mods.road.RoadCeModule"),
    require("ce.mods.transit.TransitCeModule")
)

function EEPMain()
    ControlExtension.runTasks(1)
    return 1
end
```

## Öffentliche Funktionszuordnung

| Alt                                                  | Neu                                                      | Hinweis                                                         |
| ---------------------------------------------------- | -------------------------------------------------------- | --------------------------------------------------------------- |
| `require("ak.LuaForEEP")`                            | `require("ce.ControlExtension")`                         | Neuer öffentlicher Einstiegspunkt                               |
| `require("ak.core.ModuleRegistry")`                  | `require("ce.ControlExtension")`                         | Für EEP-Skripte nicht mehr direkt `ce.hub.ModuleRegistry` laden |
| `LuaForEEP.useModules(...)`                          | `ControlExtension.addModules(...)`                       | Registriert Module                                              |
| `ModuleRegistry.registerModules(...)`                | `ControlExtension.addModules(...)`                       | Benutzerpfad                                                    |
| `LuaForEEP.run(cycleCount)`                          | `ControlExtension.runTasks(cycleCount)`                  | Zyklus ausführen                                                |
| `ModuleRegistry.runTasks(cycleCount)`                | `ControlExtension.runTasks(cycleCount)`                  | Benutzerpfad                                                    |
| `LuaForEEP.disableServer()`                          | `ControlExtension.deactivateServer()`                    | Server deaktivieren                                             |
| `ModuleRegistry.deactivateServer()`                  | `ControlExtension.deactivateServer()`                    | Benutzerpfad                                                    |
| `ModuleRegistry.activateServer()`                    | `ControlExtension.activateServer()`                      | Benutzerpfad                                                    |
| `ModuleRegistry.debug = true`                        | `ControlExtension.setDebug(true)`                        | Setter statt Feldzugriff                                        |
| `ModuleRegistry.pauseEepDuringInitialization = true` | `ControlExtension.setPauseEepDuringInitialization(true)` | Setter statt Feldzugriff                                        |
| `ModuleRegistry.useDlls(true)`                       | entfällt                                                 | In `ce.ControlExtension` gibt es dafür keinen öffentlichen Ersatz |

## Ersetzte `*LuaModule`-Requires

Diese alten Modul-Wrapper sind die häufigsten Stellen, an denen deine bestehende Anlage jetzt bricht:

| Alt                                                       | Neu                                                           | Hinweis                                                    |
| --------------------------------------------------------- | ------------------------------------------------------------- | ---------------------------------------------------------- |
| `require("ak.core.CoreLuaModule")`                        | `require("ce.hub.mods.CoreCeModule")`                         | Wird über `ce.ControlExtension` bereits intern registriert |
| `require("ak.data.DataLuaModule")`                        | `require("ce.hub.mods.DataCeModule")`                         | Für Hub-Datenexport                                        |
| `require("ak.scheduler.SchedulerLuaModule")`              | `require("ce.hub.mods.SchedulerCeModule")`                    | Meist nur bei direkter Scheduler-Nutzung nötig             |
| `require("ak.road.CrossingLuaModule")`                    | `require("ce.mods.road.RoadCeModule")`                        | Straßenverkehrsmodul                                       |
| `require("ak.road.CrossingLuaModul")`                     | `require("ce.mods.road.RoadCeModule")`                        | Alter Tippfehler in einigen Anlagen-Dateien                |
| `require("ak.transit.TransitLuaModule")` | `require("ce.mods.transit.TransitCeModule")` | ÖPNV-Modul                                                 |

## Direkte `require()`-Ersetzungen nach Bereich

Die folgenden Ersetzungen decken die typischen direkten Modulzugriffe aus bestehenden Lua-Skripten und Specs ab.

| Alt                                            | Neu                                                  |
| ---------------------------------------------- | ---------------------------------------------------- |
| `require("ak.io.IoInit")`                      | `require("ce.databridge.IoInit")`                    |
| `require("ak.io.ServerExchangeCoordinator")`   | `require("ce.databridge.ServerExchangeCoordinator")` |
| `require("ak.io.DataStoreFileWriter")`         | `require("ce.databridge.DataStoreFileWriter")`       |
| `require("ak.core.eep.EepSimulator")`          | `require("ce.hub.eep.EepSimulator")`                 |
| `require("ak.core.eep.TippTextFormatter")`     | `require("ce.hub.eep.TippTextFormatter")`            |
| `require("ak.events.DataChangeBus")`           | `require("ce.hub.publish.DataChangeBus")`            |
| `require("ak.data.DataStore")`                 | `require("ce.hub.publish.InternalDataStore")`        |
| `require("ak.storage.StorageUtility")`         | `require("ce.hub.util.StorageUtility")`              |
| `require("ak.util.TableUtils")`                | `require("ce.hub.util.TableUtils")`                  |
| `require("ak.util.Queue")`                     | `require("ce.hub.util.Queue")`                       |
| `require("ak.util.RuntimeRegistry")`           | `require("ce.hub.util.RuntimeRegistry")`             |
| `require("ak.scheduler.Scheduler")`            | `require("ce.hub.scheduler.Scheduler")`              |
| `require("ak.scheduler.Task")`                 | `require("ce.hub.scheduler.Task")`                   |
| `require("ak.modellpacker.AkModellInstaller")` | `require("ce.modellpacker.AkModellInstaller")`       |
| `require("ak.modellpacker.AkModellPaket")`     | `require("ce.modellpacker.AkModellPaket")`           |
| `require("ak.modellpacker.AkModellPacker")`    | `require("ce.modellpacker.AkModellPacker")`          |
| `require("ak.third-party.json")`               | `require("ce.third-party.json")`                     |
| `require("ak.third-party.BetterContacts_BH2")` | `require("ce.third-party.BetterContacts_BH2")`       |
| `require("ak.demo-anlagen...")`                | `require("ce.demo-anlagen...")`                      |
| `require("ak.anlagen...")`                     | `require("ce.anlagen...")`                           |
| `require("ak.template...")`                    | `require("ce.template...")`                          |
| `require("ak.rail.Rail")`                      | `require("ce.rail.Rail")`                            |
| `require("ak.road.TramSwitch")`                | `require("ce.mods.road.TramSwitch")`                 |
| `require("ak.road.TrafficLightModel")`         | `require("ce.mods.road.TrafficLightModel")`          |
| `require("ak.road.AxisStructureTrafficLight")` | `require("ce.mods.road.AxisStructureTrafficLight")`  |
| `require("ak.road.LightStructureTrafficLight")`| `require("ce.mods.road.LightStructureTrafficLight")` |
| `require("ak.road.TrafficLight")`              | `require("ce.mods.road.TrafficLight")`               |
| `require("ak.road.Lane")`                      | `require("ce.mods.road.Lane")`                       |
| `require("ak.road.Crossing")`                  | `require("ce.mods.road.Intersection")`                   |
| `require("ak.road.CrossingSequence")`          | `require("ce.mods.road.IntersectionSequence")`           |
| `require("ak.transit.Line")`          | `require("ce.mods.transit.Line")`           |
| `require("ak.transit.LineRegistry")`  | `require("ce.mods.transit.LineRegistry")`   |
| `require("ak.transit.RoadStation")`   | `require("ce.mods.transit.RoadStation")`    |
| `require("ak.transit.RoadStationDisplayModel")` | `require("ce.mods.transit.models.RoadStationDisplayModel")` |
| `require("ak.train.TrainRegistry")`            | `require("ce.hub.data.trains.TrainRegistry")`        |

## Fachmodule: alte Pfade zu neuen Pfaden

Viele bisher flache `ak.*`-Bereiche wurden beim Refactoring fachlich aufgeteilt. Für dich ist vor allem diese Zuordnung relevant:

| Alter Bereich           | Neuer Bereich                                                      | Typische Beispiele                             |
| ----------------------- | ------------------------------------------------------------------ | ---------------------------------------------- |
| `ak.core.*`             | `ce.hub.*`                                                         | Laufzeit, Registry, EEP-Simulator              |
| `ak.io.*`               | `ce.databridge.*`                                                  | Datei- und Serveraustausch                     |
| `ak.events.*`           | `ce.hub.publish.*`                                                 | Event- und Änderungsbus                        |
| `ak.storage.*`          | `ce.hub.util.*`                                                    | Persistenz-Helfer                              |
| `ak.util.*`             | `ce.hub.util.*`                                                    | Tabellen, Queue, Laufzeit-Helfer               |
| `ak.scheduler.*`        | `ce.hub.scheduler.*` und `ce.hub.mods.*`                           | Scheduler-Kern und Scheduler-Modul             |
| `ak.data.*`             | `ce.hub.data.*`, `ce.hub.publish.*` und `ce.hub.mods.*`            | Slots, Signale, Strukturen, Zeit, Tracks, Züge |
| `ak.train.*`            | `ce.hub.data.trains.*` und `ce.hub.data.rollingstock.*`            | Zug- und Rollmaterialdaten                     |
| `ak.road.*`             | `ce.mods.road.*` und `ce.mods.road.data.*`                         | Kreuzungen, Ampeln, Road-Daten                 |
| `ak.transit.*` | `ce.mods.transit.*` und `ce.mods.transit.data.*` | Linien, Haltestellen, ÖPNV-Daten               |
| `ak.roadline.*`         | `ce.mods.transit.*`                                       | Frühere Linien-Tests und Linienlogik           |

## Häufige 1:1-Dateiwechsel

Die folgenden Dateien wurden nicht nur umbenannt, sondern oft auch in die neue fachliche Zielstruktur verschoben:

| Alte Datei                                          | Neue Datei                                                       |
| --------------------------------------------------- | ---------------------------------------------------------------- |
| `ak/LuaForEEP.lua`                                  | `ce/ControlExtension.lua`                                        |
| `ak/core/ModuleRegistry.lua`                        | `ce/hub/ModuleRegistry.lua` und `ce/hub/ControlExtensionHub.lua` |
| `ak/core/MainLoopRunner.lua`                        | `ce/hub/MainLoopRunner.lua`                                      |
| `ak/io/ExchangeDirRegistry.lua`                     | `ce/databridge/ExchangeDirRegistry.lua`                          |
| `ak/io/ServerEventBuffer.lua`                       | `ce/databridge/ServerEventBuffer.lua`                            |
| `ak/events/DataChangeBus.lua`                       | `ce/hub/publish/DataChangeBus.lua`                               |
| `ak/data/DataStore.lua`                             | `ce/hub/publish/InternalDataStore.lua`                           |
| `ak/core/VersionInfo.lua`                           | `ce/hub/data/version/VersionInfo.lua`                            |
| `ak/train/Train.lua`                                | `ce/hub/data/trains/Train.lua`                                   |
| `ak/train/RollingStock.lua`                         | `ce/hub/data/rollingstock/RollingStock.lua`                      |
| `ak/road/CrossingDtoFactory.lua`                    | `ce/mods/road/data/RoadDtoFactory.lua`                       |
| `ak/road/TrafficLightModelDtoFactory.lua`           | `ce/mods/road/data/TrafficLightModelDtoFactory.lua`              |
| `ak/transit/TransitDtoFactory.lua` | `ce/mods/transit/data/TransitDtoFactory.lua`    |

## Praktische Regel für deine bestehende Anlage

Wenn bei dir eine Fehlermeldung wie `module 'ak.core.ModuleRegistry' not found` oder `module 'ak.road.CrossingLuaModule' not found` erscheint, dann genügt meistens diese Reihenfolge:

1. `ak.` durch `ce.` ersetzen.
2. Bei alten Benutzer-Einstiegspunkten `ModuleRegistry` oder `LuaForEEP` auf `ce.ControlExtension` umstellen.
3. Bei alten `*LuaModule`-Dateien auf die neuen `*CeModule`-Dateien wechseln.
4. Bei Daten- und Infrastrukturmodulen prüfen, ob der Pfad jetzt unter `ce.hub` oder `ce.databridge` liegt.
5. Bei Straßenverkehr und ÖPNV prüfen, ob der Pfad jetzt unter `ce.mods.road` oder `ce.mods.transit` liegt.

## Nicht jede Änderung ist 1:1

Einige alte Sammelmodule wurden bewusst aufgeteilt:

| Alt                                            | Neu                                                                                                                                      |
| ---------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| `ak.core.ModuleRegistry`                       | Öffentlicher Einstieg über `ce.ControlExtension`, Laufzeit über `ce.hub.ControlExtensionHub`, Registry intern in `ce.hub.ModuleRegistry` |
| `ak.core.CoreWebConnector`                     | `ce.hub.bridge.CoreBridgeConnector` und `ce.hub.bridge.DataBridgeConnector`                                                              |
| `ak.data.DataLuaModule`                        | `ce.hub.mods.DataCeModule` mit `ce.hub.bridge.DataBridgeConnector`                                                                       |
| `ak.road.CrossingLuaModule`                    | `ce.mods.road.RoadCeModule` mit `ce.mods.road.bridge.RoadBridgeConnector`                                                            |
| `ak.transit.TransitLuaModule` | `ce.mods.transit.TransitCeModule` mit `ce.mods.transit.bridge.TransitBridgeConnector`                  |

Für deine bestehenden Skripte ist der sichere Weg daher: Verwende nur `ce.ControlExtension` und die neuen `*CeModule` direkt und greife nicht mehr auf alte interne `ak.*`-Pfade zurück.
