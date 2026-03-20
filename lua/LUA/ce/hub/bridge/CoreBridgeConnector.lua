if AkDebugLoad then print("[#Start] Loading ce.hub.bridge.CoreBridgeConnector ...") end
local CoreBridgeConnector = {}
local StatePublisherRegistry = require("ce.hub.StatePublisherRegistry")
---@type table<string, CeModule>|nil
local registeredCeModules = nil
---@param modules table<string, CeModule>
function CoreBridgeConnector.setRegisteredCeModules(modules) registeredCeModules = modules end

function CoreBridgeConnector.registerStatePublishers()
    local ModulesDataCollector = require("ce.hub.data.modules.ModulesDataCollector")
    local ModulesStatePublisher = require("ce.hub.data.modules.ModulesStatePublisher")
    local RuntimeStatePublisher = require("ce.hub.data.runtime.RuntimeStatePublisher")
    local VersionStatePublisher = require("ce.hub.data.version.VersionStatePublisher")
    assert(registeredCeModules)
    ModulesDataCollector.setRegisteredCeModules(registeredCeModules)
    StatePublisherRegistry.registerStatePublishers(ModulesStatePublisher, VersionStatePublisher, RuntimeStatePublisher)
end

return CoreBridgeConnector
