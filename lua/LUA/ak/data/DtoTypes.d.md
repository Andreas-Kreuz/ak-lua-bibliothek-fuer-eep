# DTO-Raumverträge

Diese Datei dokumentiert den öffentlichen Vertrag der vom Server bereitgestellten Räume.
Die DTO-Felddefinitionen selbst stehen in `DtoTypes.d.lua`.

## SwitchDto

| Raumname | Key-ID | DTO-Typ | Definition in |
| --- | --- | --- | --- |
| `switches` | `id` | `SwitchDto` | `ak.data.SwitchDtoFactory` |

## SignalDto

| Raumname | Key-ID | DTO-Typ | Definition in |
| --- | --- | --- | --- |
| `signals` | `id` | `SignalDto` | `ak.data.SignalDtoFactory` |

## WaitingOnSignalDto

| Raumname | Key-ID | DTO-Typ | Definition in |
| --- | --- | --- | --- |
| `waiting-on-signals` | `id` | `WaitingOnSignalDto` | `ak.data.SignalDtoFactory` |

## StructureDto

| Raumname | Key-ID | DTO-Typ | Definition in |
| --- | --- | --- | --- |
| `structures` | `id` | `StructureDto` | `ak.data.StructureDtoFactory` |

## TimeDto

| Raumname | Key-ID | DTO-Typ | Definition in |
| --- | --- | --- | --- |
| `times` | `id` | `TimeDto` | `ak.data.TimeDtoFactory` |

## DataSlotDto

| Raumname | Key-ID | DTO-Typ | Definition in |
| --- | --- | --- | --- |
| `save-slots` | `id` | `DataSlotDto` | `ak.data.DataSlotDtoFactory` |
| `free-slots` | `id` | `DataSlotDto` | `ak.data.DataSlotDtoFactory` |

## ModuleDto

| Raumname | Key-ID | DTO-Typ | Definition in |
| --- | --- | --- | --- |
| `modules` | `id` | `ModuleDto` | `ak.core.ModuleDtoFactory` |

## VersionDto

| Raumname | Key-ID | DTO-Typ | Definition in |
| --- | --- | --- | --- |
| `eep-version` | `id` | `VersionDto` | `ak.core.VersionDtoFactory` |

## RuntimeDto

| Raumname | Key-ID | DTO-Typ | Definition in |
| --- | --- | --- | --- |
| `runtime` | `id` | `RuntimeDto` | `ak.core.RuntimeDtoFactory` |

## IntersectionDto

| Raumname | Key-ID | DTO-Typ | Definition in |
| --- | --- | --- | --- |
| `intersections` | `id` | `IntersectionDto` | `ak.road.CrossingDtoFactory` |

## IntersectionLaneDto

| Raumname | Key-ID | DTO-Typ | Definition in |
| --- | --- | --- | --- |
| `intersection-lanes` | `id` | `IntersectionLaneDto` | `ak.road.CrossingDtoFactory` |

## IntersectionSwitchingDto

| Raumname | Key-ID | DTO-Typ | Definition in |
| --- | --- | --- | --- |
| `intersection-switchings` | `id` | `IntersectionSwitchingDto` | `ak.road.CrossingDtoFactory` |

## IntersectionTrafficLightDto

| Raumname | Key-ID | DTO-Typ | Definition in |
| --- | --- | --- | --- |
| `intersection-traffic-lights` | `id` | `IntersectionTrafficLightDto` | `ak.road.CrossingDtoFactory` |

## IntersectionModuleSettingDto

| Raumname | Key-ID | DTO-Typ | Definition in |
| --- | --- | --- | --- |
| `intersection-module-settings` | `name` | `IntersectionModuleSettingDto` | `ak.road.CrossingDtoFactory` |

## SignalTypeDefinitionDto

| Raumname | Key-ID | DTO-Typ | Definition in |
| --- | --- | --- | --- |
| `signal-type-definitions` | `id` | `SignalTypeDefinitionDto` | `ak.road.TrafficLightModelDtoFactory` |

## PublicTransportStationDto

| Raumname | Key-ID | DTO-Typ | Definition in |
| --- | --- | --- | --- |
| `public-transport-stations` | `id` | `PublicTransportStationDto` | `ak.public-transport.PublicTransportDtoFactory` |

## PublicTransportLineDto

| Raumname | Key-ID | DTO-Typ | Definition in |
| --- | --- | --- | --- |
| `public-transport-lines` | `id` | `PublicTransportLineDto` | `ak.public-transport.PublicTransportDtoFactory` |

## PublicTransportModuleSettingDto

| Raumname | Key-ID | DTO-Typ | Definition in |
| --- | --- | --- | --- |
| `public-transport-module-settings` | `name` | `PublicTransportModuleSettingDto` | `ak.public-transport.PublicTransportDtoFactory` |

## PublicTransportLineNameDto

| Raumname | Key-ID | DTO-Typ | Definition in |
| --- | --- | --- | --- |
| `public-transport-line-names` | `id` | `PublicTransportLineNameDto` | `ak.public-transport.PublicTransportDtoFactory` |

## TrainDto

| Raumname | Key-ID | DTO-Typ | Definition in |
| --- | --- | --- | --- |
| `trains` | `id` | `TrainDto` | `ak.train.TrainDtoFactory` |

## RollingStockDto

| Raumname | Key-ID | DTO-Typ | Definition in |
| --- | --- | --- | --- |
| `rolling-stocks` | `id` | `RollingStockDto` | `ak.train.RollingStockDtoFactory` |

## TrackDto

| Raumname | Key-ID | DTO-Typ | Definition in |
| --- | --- | --- | --- |
| `auxiliary-tracks` | `id` | `TrackDto` | `ak.data.TrackDtoFactory` |
| `control-tracks` | `id` | `TrackDto` | `ak.data.TrackDtoFactory` |
| `road-tracks` | `id` | `TrackDto` | `ak.data.TrackDtoFactory` |
| `rail-tracks` | `id` | `TrackDto` | `ak.data.TrackDtoFactory` |
| `tram-tracks` | `id` | `TrackDto` | `ak.data.TrackDtoFactory` |
