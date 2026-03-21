# Road DTO-Räume

## Raum `road-intersections`

- Key-ID: `id`
- DtoFactory: `ce.mods.road.data.RoadDtoFactory.createRoadIntersectionDto`

| Name | Typ |
| --- | --- |
| `id` | `number` |
| `name` | `string` |
| `currentSwitching` | `string|nil` |
| `manualSwitching` | `string|nil` |
| `nextSwitching` | `string|nil` |
| `ready` | `boolean` |
| `timeForGreen` | `number` |
| `staticCams` | `table` |

## Raum `road-intersection-lanes`

- Key-ID: `id`
- DtoFactory: `ce.mods.road.data.RoadDtoFactory.createRoadIntersectionLaneDto`

| Name | Typ |
| --- | --- |
| `id` | `string` |
| `intersectionId` | `number` |
| `name` | `string` |
| `phase` | `string` |
| `vehicleMultiplier` | `number` |
| `eepSaveId` | `number` |
| `type` | `string` |
| `countType` | `string` |
| `waitingTrains` | `table` |
| `waitingForGreenCyclesCount` | `number` |
| `directions` | `table` |
| `switchings` | `table` |
| `tracks` | `table` |

## Raum `road-intersection-switchings`

- Key-ID: `id`
- DtoFactory: `ce.mods.road.data.RoadDtoFactory.createRoadIntersectionSwitchingDto`

| Name | Typ |
| --- | --- |
| `id` | `string` |
| `intersectionId` | `string|number` |
| `name` | `string` |
| `prio` | `number` |

## Raum `road-intersection-traffic-lights`

- Key-ID: `id`
- DtoFactory: `ce.mods.road.data.RoadDtoFactory.createRoadIntersectionTrafficLightDto`

| Name | Typ |
| --- | --- |
| `id` | `number` |
| `signalId` | `number` |
| `modelId` | `string` |
| `currentPhase` | `string` |
| `intersectionId` | `number` |
| `lightStructures` | `table<string, IntersectionTrafficLightStructureDto>` |
| `axisStructures` | `IntersectionTrafficLightAxisStructureDto[]` |

## Raum `road-module-settings`

- Key-ID: `name`
- DtoFactory: `ce.mods.road.data.RoadDtoFactory.createRoadIntersectionModuleSettingDto`

| Name | Typ |
| --- | --- |
| `category` | `string` |
| `name` | `string` |
| `description` | `string` |
| `type` | `string` |
| `value` | `boolean` |
| `eepFunction` | `string` |

## Raum `signal-type-definitions`

- Key-ID: `id`
- DtoFactory: `ce.mods.road.data.TrafficLightModelDtoFactory.createSignalTypeDefinitionDto`

| Name | Typ |
| --- | --- |
| `id` | `string` |
| `name` | `string` |
| `type` | `string` |
| `positions` | `SignalTypeDefinitionPositionsDto` |
