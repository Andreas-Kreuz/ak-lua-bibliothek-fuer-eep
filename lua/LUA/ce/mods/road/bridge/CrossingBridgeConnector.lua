if AkDebugLoad then print("[#Start] Loading ce.mods.road.bridge.CrossingBridgeConnector ...") end
local StatePublisherRegistry = require("ce.hub.StatePublisherRegistry")
local ServerExchangeCoordinator = require("ce.databridge.ServerExchangeCoordinator")
local Crossing = require("ce.mods.road.Crossing")
local CrossingSettings = require("ce.mods.road.CrossingSettings")

---@class CrossingBridgeConnector
local CrossingBridgeConnector = {}

function CrossingBridgeConnector.registerStatePublishers()
    local trafficLightModelStatePublisher = require("ce.mods.road.data.TrafficLightModelStatePublisher")
    local crossingStatePublisher = require("ce.mods.road.data.CrossingStatePublisher")
    StatePublisherRegistry.registerStatePublishers(trafficLightModelStatePublisher, crossingStatePublisher)
end

function CrossingBridgeConnector.registerFunctions()
    ServerExchangeCoordinator.registerAllowedCommand("CrossingSettings.setShowRequestsOnSignal", function(param)
        CrossingSettings.setShowRequestsOnSignal(param == "true")
    end)
    ServerExchangeCoordinator.registerAllowedCommand("CrossingSettings.setShowSequenceOnSignal", function(param)
        CrossingSettings.setShowSequenceOnSignal(param == "true")
    end)
    ServerExchangeCoordinator.registerAllowedCommand("CrossingSettings.setShowSignalIdOnSignal", function(param)
        CrossingSettings.setShowSignalIdOnSignal(param == "true")
    end)
    ServerExchangeCoordinator.registerAllowedCommand("CrossingSettings.setShowLanesOnStructure", function(param)
        CrossingSettings.setShowLanesOnStructure(param == "true")
    end)
    ServerExchangeCoordinator.registerAllowedCommand("AkKreuzungSchalteAutomatisch", Crossing.switchAutomatically)
    ServerExchangeCoordinator.registerAllowedCommand("AkKreuzungSchalteManuell", Crossing.switchManuallyTo)
end

return CrossingBridgeConnector
