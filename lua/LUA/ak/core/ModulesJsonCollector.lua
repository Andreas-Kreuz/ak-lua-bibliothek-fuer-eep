if AkDebugLoad then print("Loading ak.core.ModulesJsonCollector ...") end
local EventBroker = require "ak.util.EventBroker"
local TableUtils = require "ak.util.TableUtils"

---@class JsonCollector
ModulesJsonCollector = {}
local enabled = true
local initialized = false
ModulesJsonCollector.name = "ak.core.ModulesJsonCollector"
---@type table<string,LuaModule>
local registeredLuaModules = nil

local knownModules = {}
local function toApiV1(moduleName, module) return {id = module.id, name = moduleName, enabled = module.enabled} end
local function checkModule(moduleName, module)
    local newModule = toApiV1(moduleName, module)
    local oldModule = knownModules[moduleName]
    if not oldModule then
        EventBroker.fireDataChange(EventBroker.eventType.dataAdded, "modules", "id", newModule);
    elseif not TableUtils.deepDictCompare(oldModule, newModule) then
        EventBroker.fireDataChange(EventBroker.eventType.dataChanged, "modules", "id", newModule);
    end

    knownModules[moduleName] = module
end

function ModulesJsonCollector.setRegisteredLuaModules(modules) registeredLuaModules = modules end

function ModulesJsonCollector.initialize()
    if not enabled or initialized then return end

    initialized = true
end

function ModulesJsonCollector.collectData()
    local moduleInfo = {}
    moduleInfo.modules = {}
    for moduleName, module in pairs(registeredLuaModules) do checkModule(moduleName, module) end
    return moduleInfo
end

return ModulesJsonCollector
