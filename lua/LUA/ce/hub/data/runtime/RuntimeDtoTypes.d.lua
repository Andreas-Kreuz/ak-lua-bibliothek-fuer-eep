---@meta

---@class RuntimeDto
---@field id string
---@field count number
---@field time number
---@field lastTime number

---@class RuntimeDtoFactory
---@field createRuntimeDto fun(runtimeEntry: table):string,string,string|number,RuntimeDto
---@field createRuntimeDtoList fun(runtimeEntries: table):string,string,table
