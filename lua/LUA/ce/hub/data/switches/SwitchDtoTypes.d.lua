---@meta

---@class SwitchDto
---@field id number
---@field position number
---@field tag string

---@class SwitchDtoFactory
---@field createSwitchDto fun(switch: table):string,string,string|number,SwitchDto
---@field createSwitchDtoList fun(switches: table):string,string,table
