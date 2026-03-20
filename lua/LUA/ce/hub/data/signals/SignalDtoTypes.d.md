# Signal DTO-Räume

## Raum `signals`

- Key-ID: `id`
- DtoFactory: `ce.hub.data.signals.SignalDtoFactory`

| Name | Typ |
| --- | --- |
| `id` | `number` |
| `position` | `number` |
| `tag` | `string` |
| `waitingVehiclesCount` | `number` |

## Raum `waiting-on-signals`

- Key-ID: `id`
- DtoFactory: `ce.hub.data.signals.SignalDtoFactory`

| Name | Typ |
| --- | --- |
| `id` | `string` |
| `signalId` | `number` |
| `waitingPosition` | `number` |
| `vehicleName` | `string` |
| `waitingCount` | `number` |
