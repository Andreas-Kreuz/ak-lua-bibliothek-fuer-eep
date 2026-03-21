if AkDebugLoad then print("[#Start] Loading ce.mods.transit.bridge.TransitBridgeConnector ...") end
local StatePublisherRegistry = require("ce.hub.StatePublisherRegistry")
local ServerExchangeCoordinator = require("ce.databridge.ServerExchangeCoordinator")
local TransitSettings = require("ce.mods.transit.TransitSettings")

---@class TransitBridgeConnector
local TransitBridgeConnector = {}

function TransitBridgeConnector.registerStatePublishers()
    local publicTransportStatePublisher = require("ce.mods.transit.data.TransitStatePublisher")
    StatePublisherRegistry.registerStatePublishers(publicTransportStatePublisher)
end

function TransitBridgeConnector.registerFunctions()
    ServerExchangeCoordinator.registerAllowedCommand(
        "TransitSettings.setShowDepartureTippText",
        function(param) TransitSettings.setShowDepartureTippText(param == "true") end
    )
end

return TransitBridgeConnector
