if AkDebugLoad then print("[#Start] Loading ak.road.CrossingWebConnector ...") end
local StatePublisherRegistry = require("ak.core.StatePublisherRegistry")
local ServerExchangeCoordinator = require("ak.io.ServerExchangeCoordinator")
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
    ServerExchangeCoordinator.registerAllowedCommand("CrossingSettings.setShowRequestsOnSignal", function (param)
        CrossingSettings.setShowRequestsOnSignal(param == "true")
    end)
    ServerExchangeCoordinator.registerAllowedCommand("CrossingSettings.setShowSequenceOnSignal", function (param)
        CrossingSettings.setShowSequenceOnSignal(param == "true")
    end)
    ServerExchangeCoordinator.registerAllowedCommand("CrossingSettings.setShowSignalIdOnSignal", function (param)
        CrossingSettings.setShowSignalIdOnSignal(param == "true")
    end)
    ServerExchangeCoordinator.registerAllowedCommand("CrossingSettings.setShowLanesOnStructure", function (param)
        CrossingSettings.setShowLanesOnStructure(param == "true")
    end)
    ServerExchangeCoordinator.registerAllowedCommand("AkKreuzungSchalteAutomatisch", Crossing.switchAutomatically)
    ServerExchangeCoordinator.registerAllowedCommand("AkKreuzungSchalteManuell", Crossing.switchManuallyTo)
end

return CrossingWebConnector
