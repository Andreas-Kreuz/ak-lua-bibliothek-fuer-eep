# Public-Transport DTO-Räume

## Raum `public-transport-stations`

- Key-ID: `id`
- DtoFactory: `ce.mods.public-transport.data.PublicTransportDtoFactory.createPublicTransportStationDto`

| Name | Typ |
| --- | --- |
| `id` | `string` |

## Raum `public-transport-lines`

- Key-ID: `id`
- DtoFactory: `ce.mods.public-transport.data.PublicTransportDtoFactory.createPublicTransportLineDto`

| Name | Typ |
| --- | --- |
| `id` | `string` |
| `nr` | `string` |
| `trafficType` | `string` |
| `lineSegments` | `PublicTransportLineSegmentDto[]` |

## Raum `public-transport-module-settings`

- Key-ID: `name`
- DtoFactory: `ce.mods.public-transport.data.PublicTransportDtoFactory.createPublicTransportModuleSettingDto`

| Name | Typ |
| --- | --- |
| `category` | `string` |
| `name` | `string` |
| `description` | `string` |
| `type` | `string` |
| `value` | `boolean` |
| `eepFunction` | `string` |

## Raum `public-transport-line-names`

- Key-ID: `id`
- DtoFactory: `ce.mods.public-transport.data.PublicTransportDtoFactory.createPublicTransportLineNameDto`

| Name | Typ |
| --- | --- |
| `id` | `string` |
| `nr` | `string` |
| `trafficType` | `string` |
| `lineSegments` | `PublicTransportLineSegmentDto[]` |
