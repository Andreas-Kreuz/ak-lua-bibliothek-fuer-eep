# Public-Transport DTO-Räume

## Raum `transit-stations`

- Key-ID: `id`
- DtoFactory: `ce.mods.transit.data.TransitDtoFactory.createTransitStationDto`

| Name | Typ |
| --- | --- |
| `id` | `string` |

## Raum `transit-lines`

- Key-ID: `id`
- DtoFactory: `ce.mods.transit.data.TransitDtoFactory.createTransitLineDto`

| Name | Typ |
| --- | --- |
| `id` | `string` |
| `nr` | `string` |
| `trafficType` | `string` |
| `lineSegments` | `TransitLineSegmentDto[]` |

## Raum `transit-module-settings`

- Key-ID: `name`
- DtoFactory: `ce.mods.transit.data.TransitDtoFactory.createTransitModuleSettingDto`

| Name | Typ |
| --- | --- |
| `category` | `string` |
| `name` | `string` |
| `description` | `string` |
| `type` | `string` |
| `value` | `boolean` |
| `eepFunction` | `string` |

## Raum `transit-line-names`

- Key-ID: `id`
- DtoFactory: `ce.mods.transit.data.TransitDtoFactory.createTransitLineNameDto`

| Name | Typ |
| --- | --- |
| `id` | `string` |
| `nr` | `string` |
| `trafficType` | `string` |
| `lineSegments` | `TransitLineSegmentDto[]` |
