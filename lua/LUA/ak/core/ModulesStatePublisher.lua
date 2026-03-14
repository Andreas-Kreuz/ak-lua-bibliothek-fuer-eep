if AkDebugLoad then print("[#Start] Loading ak.core.ModulesStatePublisher ...") end
local DataChangeBus = require("ak.events.DataChangeBus")
local ModuleDtoFactory = require("ak.core.ModuleDtoFactory")
local TableUtils = require("ak.util.TableUtils")

---@class ModulesStatePublisher
---@field name string
---@field initialize fun():nil
---@field syncState fun():table
ModulesStatePublisher = {}
local enabled = true
local initialized = false
ModulesStatePublisher.name = "ak.core.ModulesStatePublisher"
---@type table<string, LuaModule>|nil
local registeredLuaModules = nil

---@type table<string,ModuleDto>
local knownModules = {}
local function checkModule(moduleName, module)
    local _, _, _, newModule = ModuleDtoFactory.createModuleDto(moduleName, module)
    local oldModule = knownModules[moduleName]
    if not oldModule then
        DataChangeBus.fireDataAdded(ModuleDtoFactory.createModuleDto(moduleName, module));
    elseif not TableUtils.sameDictEntries(oldModule, newModule) then
        DataChangeBus.fireDataChanged(ModuleDtoFactory.createModuleDto(moduleName, module));
    end

    knownModules[moduleName] = newModule
end

---@param modules table<string, LuaModule>
function ModulesStatePublisher.setRegisteredLuaModules(modules) registeredLuaModules = modules end

function ModulesStatePublisher.initialize()
    if not enabled or initialized then return end

    assert(registeredLuaModules)
    for moduleName, module in pairs(registeredLuaModules) do checkModule(moduleName, module) end

    initialized = true
end

function ModulesStatePublisher.syncState()
    local moduleInfo = {}
    moduleInfo.modules = {}

    assert(registeredLuaModules)
    local _, _, moduleDtos = ModuleDtoFactory.createModuleDtoList(registeredLuaModules)
    for key, value in pairs(moduleDtos) do moduleInfo[key] = value end

    return moduleInfo
end

return ModulesStatePublisher
