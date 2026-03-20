---@meta

---@class ModulesDataCollector
---@field setRegisteredCeModules fun(modules: table<string, CeModule>):nil
---@field collectModules fun():table<string, CeModule>

---@class ModulesStatePublisher
---@field name string
---@field initialize fun():nil
---@field syncState fun():table
