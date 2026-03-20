if AkDebugLoad then print("[#Start] Loading ce.hub.data.modules.ModulesStatePublisher ...") end
local DataChangeBus = require("ce.hub.publish.DataChangeBus")
local ModuleDtoFactory = require("ce.hub.data.modules.ModuleDtoFactory")
local ModulesDataCollector = require("ce.hub.data.modules.ModulesDataCollector")
local TableUtils = require("ce.hub.util.TableUtils")

---@class ModulesStatePublisher
---@field name string
---@field initialize fun():nil
---@field syncState fun():table
ModulesStatePublisher = {}
local enabled = true
local initialized = false
ModulesStatePublisher.name = "ce.hub.ModulesStatePublisher"

---@type table<string,ModuleDto>
local knownModInfos = {}
local function checkModule(moduleName, module)
    local _, _, _, newModInfo = ModuleDtoFactory.createModuleDto(moduleName, module)
    local oldModInfo = knownModInfos[moduleName]
    if not oldModInfo then
        DataChangeBus.fireDataAdded(ModuleDtoFactory.createModuleDto(moduleName, module));
    elseif not TableUtils.sameDictEntries(oldModInfo, newModInfo) then
        DataChangeBus.fireDataChanged(ModuleDtoFactory.createModuleDto(moduleName, module));
    end

    knownModInfos[moduleName] = newModInfo
end
function ModulesStatePublisher.initialize()
    if not enabled or initialized then return end

    local registeredCeModules = ModulesDataCollector.collectModules()
    for moduleName, module in pairs(registeredCeModules) do checkModule(moduleName, module) end

    initialized = true
end

function ModulesStatePublisher.syncState()
    local modInfos = {}
    modInfos.modules = {}

    local registeredCeModules = ModulesDataCollector.collectModules()
    local _, _, modInfosById = ModuleDtoFactory.createModuleDtoList(registeredCeModules)
    for key, value in pairs(modInfosById) do modInfos[key] = value end

    return modInfos
end

return ModulesStatePublisher
