if AkDebugLoad then print("[#Start] Loading ce.mods.road.bridge.RoadBridgeConnector ...") end
local StatePublisherRegistry = require("ce.hub.StatePublisherRegistry")
local ServerExchangeCoordinator = require("ce.databridge.ServerExchangeCoordinator")
local Intersection = require("ce.mods.road.Intersection")
local IntersectionSettings = require("ce.mods.road.IntersectionSettings")

---@class RoadBridgeConnector
local RoadBridgeConnector = {}

function RoadBridgeConnector.registerStatePublishers()
    local trafficLightModelStatePublisher = require("ce.mods.road.data.TrafficLightModelStatePublisher")
    local roadStatePublisher = require("ce.mods.road.data.RoadStatePublisher")
    StatePublisherRegistry.registerStatePublishers(trafficLightModelStatePublisher, roadStatePublisher)
end

function RoadBridgeConnector.registerFunctions()
    ServerExchangeCoordinator.registerAllowedCommand("IntersectionSettings.setShowRequestsOnSignal", function(param)
        IntersectionSettings.setShowRequestsOnSignal(param == "true")
    end)
    ServerExchangeCoordinator.registerAllowedCommand("IntersectionSettings.setShowSequenceOnSignal", function(param)
        IntersectionSettings.setShowSequenceOnSignal(param == "true")
    end)
    ServerExchangeCoordinator.registerAllowedCommand("IntersectionSettings.setShowSignalIdOnSignal", function(param)
        IntersectionSettings.setShowSignalIdOnSignal(param == "true")
    end)
    ServerExchangeCoordinator.registerAllowedCommand("IntersectionSettings.setShowLanesOnStructure", function(param)
        IntersectionSettings.setShowLanesOnStructure(param == "true")
    end)
    ServerExchangeCoordinator.registerAllowedCommand("AkKreuzungSchalteAutomatisch", Intersection.switchAutomatically)
    ServerExchangeCoordinator.registerAllowedCommand("AkKreuzungSchalteManuell", Intersection.switchManuallyTo)
end

return RoadBridgeConnector
