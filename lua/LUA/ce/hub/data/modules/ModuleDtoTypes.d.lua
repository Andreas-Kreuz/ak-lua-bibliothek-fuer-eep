---@meta

---@class ModuleDto
---@field id string
---@field name string
---@field enabled boolean

---@class ModuleDtoFactory
---@field createModuleDto fun(moduleName: string, module: CeModule):string,string,string|number,ModuleDto
---@field createModuleDtoList fun(modules: table<string, CeModule>):string,string,table
---@field createModuleReferenceDto fun(moduleId: string):string,string,string|number,ModuleDto
