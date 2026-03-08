if AkDebugLoad then print("[#Start] Loading ak.public-transport.PublicTransportWebConnector ...") end
local StatePublisherRegistry = require("ak.core.StatePublisherRegistry")
local ServerExchangeCoordinator = require("ak.io.ServerExchangeCoordinator")
local Line = require("ak.public-transport.Line")

---@class PublicTransportWebConnector
local PublicTransportWebConnector = {}

function PublicTransportWebConnector.registerStatePublishers()
    local publicTransportStatePublisher = require("ak.public-transport.PublicTransportStatePublisher")
    StatePublisherRegistry.registerStatePublishers(publicTransportStatePublisher)
end

function PublicTransportWebConnector.registerFunctions()
    ServerExchangeCoordinator.registerAllowedCommand("Line.setShowDepartureTippText",
                                               function (param) Line.setShowDepartureTippText(param == "true") end)
end

return PublicTransportWebConnector
