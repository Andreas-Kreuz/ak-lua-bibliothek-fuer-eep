if AkDebugLoad then print("[#Start] Loading ce.hub.data.modules.ModulesDataCollector ...") end

local ModulesDataCollector = {}

---@type table<string, CeModule>|nil
local registeredCeModules = nil

---@param modules table<string, CeModule>
function ModulesDataCollector.setRegisteredCeModules(modules) registeredCeModules = modules end

---@return table<string, CeModule>
function ModulesDataCollector.collectModules()
    assert(registeredCeModules)
    return registeredCeModules
end

return ModulesDataCollector
