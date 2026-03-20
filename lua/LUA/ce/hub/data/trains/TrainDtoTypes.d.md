# Train DTO-Räume

## Raum `trains`

- Key-ID: `id`
- DtoFactory: `ce.hub.data.trains.TrainDtoFactory`

| Name | Typ |
| --- | --- |
| `id` | `string` |
| `route` | `string` |
| `rollingStockCount` | `number` |
| `length` | `number` |
| `line` | `string|nil` |
| `destination` | `string|nil` |
| `direction` | `string|nil` |
| `trackType` | `string|nil` |
| `movesForward` | `boolean` |
| `speed` | `number` |
| `occupiedTacks` | `table` |
