if AkDebugLoad then print("[#Start] Loading ak.core.CoreWebConnector ...") end
local CoreWebConnector = {}
local StatePublisherRegistry = require("ak.core.StatePublisherRegistry")
local registeredLuaModules = nil
function CoreWebConnector.setRegisteredLuaModules(modules) registeredLuaModules = modules end

function CoreWebConnector.registerStatePublishers()
    local ModulesStatePublisher = require("ak.core.ModulesStatePublisher")
    local VersionStatePublisher = require("ak.core.VersionStatePublisher")
    ModulesStatePublisher.setRegisteredLuaModules(registeredLuaModules)
    StatePublisherRegistry.registerStatePublishers(ModulesStatePublisher, VersionStatePublisher)
end

return CoreWebConnector
