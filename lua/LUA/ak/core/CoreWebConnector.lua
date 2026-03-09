if AkDebugLoad then print("[#Start] Loading ak.core.CoreWebConnector ...") end
local CoreWebConnector = {}
local StatePublisherRegistry = require("ak.core.StatePublisherRegistry")
---@type table<string, LuaModule>|nil
local registeredLuaModules = nil
---@param modules table<string, LuaModule>
function CoreWebConnector.setRegisteredLuaModules(modules) registeredLuaModules = modules end

function CoreWebConnector.registerStatePublishers()
    local ModulesStatePublisher = require("ak.core.ModulesStatePublisher")
    local VersionStatePublisher = require("ak.core.VersionStatePublisher")
    assert(registeredLuaModules)
    ModulesStatePublisher.setRegisteredLuaModules(registeredLuaModules)
    StatePublisherRegistry.registerStatePublishers(ModulesStatePublisher, VersionStatePublisher)
end

return CoreWebConnector
