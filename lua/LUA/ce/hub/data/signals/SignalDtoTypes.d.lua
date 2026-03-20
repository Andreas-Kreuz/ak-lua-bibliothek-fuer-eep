---@meta

---@class SignalDto
---@field id number
---@field position number
---@field tag string
---@field waitingVehiclesCount number

---@class WaitingOnSignalDto
---@field id string
---@field signalId number
---@field waitingPosition number
---@field vehicleName string
---@field waitingCount number

---@class SignalDtoFactory
---@field createSignalDto fun(signal: table):string,string,string|number,SignalDto
---@field createSignalDtoList fun(signals: table):string,string,table
---@field createWaitingOnSignalDto fun(waiting: table):string,string,string|number,WaitingOnSignalDto
---@field createWaitingOnSignalDtoList fun(waitingOnSignals: table):string,string,table
