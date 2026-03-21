if AkDebugLoad then print("[#Start] Loading ce.mods.road.RoadCeModule ...") end
---@class RoadCeModule
RoadCeModule = {}
RoadCeModule.id = "c5a3e6d3-0f9b-4c89-a908-ed8cf8809362"
RoadCeModule.enabled = true
local initialized = false
RoadCeModule.name = "ce.mods.road.RoadCeModule"
local Crossing = require("ce.mods.road.Crossing")

function RoadCeModule.init()
    if not RoadCeModule.enabled or initialized then return end

    local CrossingBridgeConnector = require("ce.mods.road.bridge.CrossingBridgeConnector")
    CrossingBridgeConnector.registerStatePublishers()
    CrossingBridgeConnector.registerFunctions()

    Crossing.initSequences()

    initialized = true
end

function RoadCeModule.run()
    if not RoadCeModule.enabled then return end

    Crossing.switchSequences()
end

do
    local ModuleRegistry = require("ce.hub.ModuleRegistry")
    local schedulerCeModule = require("ce.hub.mods.SchedulerCeModule")
    ModuleRegistry.registerModules(schedulerCeModule)
end

return RoadCeModule
