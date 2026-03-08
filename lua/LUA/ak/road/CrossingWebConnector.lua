if AkDebugLoad then print("[#Start] Loading ak.road.CrossingWebConnector ...") end
local StatePublisherRegistry = require("ak.core.StatePublisherRegistry")
local ServerBridge = require("ak.io.ServerBridge")
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
    ServerBridge.addAcceptedRemoteFunction("CrossingSettings.setShowRequestsOnSignal", function (param)
        CrossingSettings.setShowRequestsOnSignal(param == "true")
    end)
    ServerBridge.addAcceptedRemoteFunction("CrossingSettings.setShowSequenceOnSignal", function (param)
        CrossingSettings.setShowSequenceOnSignal(param == "true")
    end)
    ServerBridge.addAcceptedRemoteFunction("CrossingSettings.setShowSignalIdOnSignal", function (param)
        CrossingSettings.setShowSignalIdOnSignal(param == "true")
    end)
    ServerBridge.addAcceptedRemoteFunction("CrossingSettings.setShowLanesOnStructure", function (param)
        CrossingSettings.setShowLanesOnStructure(param == "true")
    end)
    ServerBridge.addAcceptedRemoteFunction("AkKreuzungSchalteAutomatisch", Crossing.switchAutomatically)
    ServerBridge.addAcceptedRemoteFunction("AkKreuzungSchalteManuell", Crossing.switchManuallyTo)
end

return CrossingWebConnector
