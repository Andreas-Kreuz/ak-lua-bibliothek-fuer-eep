---@meta

---@class LuaModule
---@field id string
---@field name string
---@field enabled boolean
---@field init fun():nil
---@field run fun():nil

---@class ModuleDtoFactory
---@field createModuleDto fun(moduleName: string, module: LuaModule):string,string,string|number,ModuleDto
---@field createModuleDtoList fun(modules: table<string, LuaModule>):string,string,table
---@field  createModuleReferenceDto fun(moduleId: string):string,string,string|number,ModuleDto
---@class VersionDtoFactory
---@field createVersionDto
---@field createVersionDto fun(eepVersion: string, luaVersion: string, singleVersion: string):string,string,string|number,VersionDto
---@field createVersionDtoList fun(eepVersion: string, luaVersion: string, singleVersion: string):string,string,table
---@class RuntimeDtoFactory
---@field createRuntimeDto fun(runtimeEntry: table):string,string,string|number,RuntimeDto
---@field createRuntimeDtoList fun(runtimeEntries: table):string,string,table
