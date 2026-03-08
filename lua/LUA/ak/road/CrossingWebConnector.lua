if AkDebugLoad then print("[#Start] Loading ak.road.CrossingWebConnector ...") end
local StatePublisherRegistry = require("ak.core.StatePublisherRegistry")
local ServerController = require("ak.io.ServerController")
local Crossing = require("ak.road.Crossing")
local CrossingSettings = require("ak.road.CrossingSettings")

---@class CrossingWebConnector
local CrossingWebConnector = {}

function CrossingWebConnector.registerStatePublishers()
    local trafficLightModelStatePublisher = require("ak.road.TrafficLightModelStatePublisher")
    local crossingStatePublisher = require("ak.road.CrossingStatePublisher")
    StatePublisherRegistry.registerStatePublishers(trafficLightModelStatePublisher, crossingStatePublisher)
end

function CrossingWebConnector.registerFunctions()
    ServerController.addAcceptedRemoteFunction("CrossingSettings.setShowRequestsOnSignal", function (param)
        CrossingSettings.setShowRequestsOnSignal(param == "true")
    end)
    ServerController.addAcceptedRemoteFunction("CrossingSettings.setShowSequenceOnSignal", function (param)
        CrossingSettings.setShowSequenceOnSignal(param == "true")
    end)
    ServerController.addAcceptedRemoteFunction("CrossingSettings.setShowSignalIdOnSignal", function (param)
        CrossingSettings.setShowSignalIdOnSignal(param == "true")
    end)
    ServerController.addAcceptedRemoteFunction("CrossingSettings.setShowLanesOnStructure", function (param)
        CrossingSettings.setShowLanesOnStructure(param == "true")
    end)
    ServerController.addAcceptedRemoteFunction("AkKreuzungSchalteAutomatisch", Crossing.switchAutomatically)
    ServerController.addAcceptedRemoteFunction("AkKreuzungSchalteManuell", Crossing.switchManuallyTo)
end

return CrossingWebConnector
