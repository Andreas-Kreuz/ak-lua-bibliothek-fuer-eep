if AkDebugLoad then print("Loading ak.core.ModulesJsonCollector ...") end
---@class JsonCollector
ModulesJsonCollector = {}
local enabled = true
local initialized = false
ModulesJsonCollector.name = "ak.core.ModulesJsonCollector"
---@type table<string,LuaModule>
local registeredLuaModules = nil

function ModulesJsonCollector.setRegisteredLuaModules(modules) registeredLuaModules = modules end

function ModulesJsonCollector.initialize()
    if not enabled or initialized then return end

    initialized = true
end

function ModulesJsonCollector.collectData()
    local moduleInfo = {}
    moduleInfo.modules = {}
    for moduleName, module in pairs(registeredLuaModules) do
        table.insert(moduleInfo.modules, {id = module.id, name = moduleName, enabled = module.enabled})
    end
    return moduleInfo
end

return ModulesJsonCollector
