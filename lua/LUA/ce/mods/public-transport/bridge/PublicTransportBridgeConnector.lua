if AkDebugLoad then print("[#Start] Loading ce.mods.public-transport.bridge.PublicTransportBridgeConnector ...") end
local StatePublisherRegistry = require("ce.hub.StatePublisherRegistry")
local ServerExchangeCoordinator = require("ce.databridge.ServerExchangeCoordinator")
local PublicTransportSettings = require("ce.mods.public-transport.PublicTransportSettings")

---@class PublicTransportBridgeConnector
local PublicTransportBridgeConnector = {}

function PublicTransportBridgeConnector.registerStatePublishers()
    local publicTransportStatePublisher = require("ce.mods.public-transport.data.PublicTransportStatePublisher")
    StatePublisherRegistry.registerStatePublishers(publicTransportStatePublisher)
end

function PublicTransportBridgeConnector.registerFunctions()
    ServerExchangeCoordinator.registerAllowedCommand(
        "PublicTransportSettings.setShowDepartureTippText",
        function(param) PublicTransportSettings.setShowDepartureTippText(param == "true") end
    )
end

return PublicTransportBridgeConnector
