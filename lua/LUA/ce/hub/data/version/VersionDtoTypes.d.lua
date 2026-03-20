---@meta

---@class VersionDto
---@field id string
---@field name string
---@field eepVersion string
---@field luaVersion string
---@field singleVersion string

---@class VersionDtoFactory
---@field createVersionDto fun(
---eepVersion: string, luaVersion: string, singleVersion: string):string,string,string|number,VersionDto
---@field createVersionDtoList fun(eepVersion: string, luaVersion: string, singleVersion: string):string,string,table
