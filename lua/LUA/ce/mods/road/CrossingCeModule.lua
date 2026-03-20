if AkDebugLoad then print("[#Start] Loading ce.mods.road.CrossingCeModule ...") end
---@class CrossingCeModule
CrossingCeModule = {}
CrossingCeModule.id = "c5a3e6d3-0f9b-4c89-a908-ed8cf8809362"
CrossingCeModule.enabled = true
local initialized = false
CrossingCeModule.name = "ce.mods.road.CrossingCeModule"
local Crossing = require("ce.mods.road.Crossing")

function CrossingCeModule.init()
    if not CrossingCeModule.enabled or initialized then return end

    local CrossingBridgeConnector = require("ce.mods.road.bridge.CrossingBridgeConnector")
    CrossingBridgeConnector.registerStatePublishers()
    CrossingBridgeConnector.registerFunctions()

    Crossing.initSequences()

    initialized = true
end

function CrossingCeModule.run()
    if not CrossingCeModule.enabled then return end

    Crossing.switchSequences()
end

do
    local ModuleRegistry = require("ce.hub.ModuleRegistry")
    local schedulerCeModule = require("ce.hub.mods.SchedulerCeModule")
    ModuleRegistry.registerModules(schedulerCeModule)
end

return CrossingCeModule
