if AkDebugLoad then print("[#Start] Loading ak.core.ModulesJsonCollector ...") end
local EventBroker = require("ak.util.EventBroker")
local TableUtils = require("ak.util.TableUtils")

---@class JsonCollector
ModulesJsonCollector = {}
local enabled = true
local initialized = false
ModulesJsonCollector.name = "ak.core.ModulesJsonCollector"
---@type table<string,LuaModule>
local registeredLuaModules = nil

---@type table<string,LuaModule>
local knownModules = {}
local function toApiV1(moduleName, module) return {id = module.id, name = moduleName, enabled = module.enabled} end
local function checkModule(moduleName, module)
    local newModule = toApiV1(moduleName, module)
    local oldModule = knownModules[moduleName]
    if not oldModule then
        EventBroker.fireDataAdded("modules", "id", newModule);
    elseif not TableUtils.sameDictEntries(oldModule, newModule) then
        EventBroker.fireDataChanged("modules", "id", newModule);
    end

    knownModules[moduleName] = module
end

function ModulesJsonCollector.setRegisteredLuaModules(modules) registeredLuaModules = modules end

function ModulesJsonCollector.initialize()
    if not enabled or initialized then return end

    for moduleName, module in pairs(registeredLuaModules) do checkModule(moduleName, module) end

    initialized = true
end

function ModulesJsonCollector.collectData()
    local moduleInfo = {}
    moduleInfo.modules = {}

    for _, v in pairs(registeredLuaModules) do moduleInfo[v.id] = {id = v.id, name = v.name, enabled = v.enabled} end

    return moduleInfo
end

return ModulesJsonCollector
