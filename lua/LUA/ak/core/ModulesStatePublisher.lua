if AkDebugLoad then print("[#Start] Loading ak.core.ModulesStatePublisher ...") end
local DataChangeBus = require("ak.events.DataChangeBus")
local TableUtils = require("ak.util.TableUtils")

---@class ModulesStatePublisher
---@field name string
---@field initialize fun():nil
---@field syncState fun():table
ModulesStatePublisher = {}
local enabled = true
local initialized = false
ModulesStatePublisher.name = "ak.core.ModulesStatePublisher"
---@type table<string,LuaModule>
local registeredLuaModules = nil

---@type table<string,LuaModule>
local knownModules = {}
local function toApiV1(moduleName, module) return { id = module.id, name = moduleName, enabled = module.enabled } end
local function checkModule(moduleName, module)
    local newModule = toApiV1(moduleName, module)
    local oldModule = knownModules[moduleName]
    if not oldModule then
        DataChangeBus.fireDataAdded("modules", "id", newModule);
    elseif not TableUtils.sameDictEntries(oldModule, newModule) then
        DataChangeBus.fireDataChanged("modules", "id", newModule);
    end

    knownModules[moduleName] = module
end

function ModulesStatePublisher.setRegisteredLuaModules(modules) registeredLuaModules = modules end

function ModulesStatePublisher.initialize()
    if not enabled or initialized then return end

    for moduleName, module in pairs(registeredLuaModules) do checkModule(moduleName, module) end

    initialized = true
end

function ModulesStatePublisher.syncState()
    local moduleInfo = {}
    moduleInfo.modules = {}

    for _, v in pairs(registeredLuaModules) do moduleInfo[v.id] = { id = v.id, name = v.name, enabled = v.enabled } end

    return moduleInfo
end

return ModulesStatePublisher
