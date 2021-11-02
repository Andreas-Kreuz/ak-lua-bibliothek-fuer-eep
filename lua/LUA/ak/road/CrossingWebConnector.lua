if AkDebugLoad then print("Loading ak.road.CrossingWebConnector ...") end
local ServerController = require("ak.io.ServerController")
local Crossing = require("ak.road.Crossing")

---@class CrossingWebConnector
local CrossingWebConnector = {}

function CrossingWebConnector.registerJsonCollectors()
    ServerController.addJsonCollector(require("ak.road.TrafficLightModelJsonCollector"))
    ServerController.addJsonCollector(require("ak.road.CrossingJsonCollector"))
end

function CrossingWebConnector.registerFunctions()
    ServerController.addAcceptedRemoteFunction("Crossing.setShowRequestsOnSignal",
                                               function(param) Crossing.setShowRequestsOnSignal(param == "true") end)
    ServerController.addAcceptedRemoteFunction("Crossing.setShowSequenceOnSignal",
                                               function(param) Crossing.setShowSequenceOnSignal(param == "true") end)
    ServerController.addAcceptedRemoteFunction("Crossing.setShowSignalIdOnSignal",
                                               function(param) Crossing.setShowSignalIdOnSignal(param == "true") end)
    ServerController.addAcceptedRemoteFunction("AkKreuzungSchalteAutomatisch", Crossing.switchAutomatically)
    ServerController.addAcceptedRemoteFunction("AkKreuzungSchalteManuell", Crossing.switchManuallyTo)
end

return CrossingWebConnector
