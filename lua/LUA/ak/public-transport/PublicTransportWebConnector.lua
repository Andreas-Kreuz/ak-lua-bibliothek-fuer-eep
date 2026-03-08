if AkDebugLoad then print("[#Start] Loading ak.public-transport.PublicTransportWebConnector ...") end
local ServerController = require("ak.io.ServerController")
local Line = require("ak.public-transport.Line")

---@class PublicTransportWebConnector
local PublicTransportWebConnector = {}

function PublicTransportWebConnector.registerStatePublishers()
    local publicTransportStatePublisher = require("ak.public-transport.PublicTransportStatePublisher")
    ServerController.addStatePublisher(publicTransportStatePublisher)
end

function PublicTransportWebConnector.registerFunctions()
    ServerController.addAcceptedRemoteFunction("Line.setShowDepartureTippText",
                                               function (param) Line.setShowDepartureTippText(param == "true") end)
end

return PublicTransportWebConnector
