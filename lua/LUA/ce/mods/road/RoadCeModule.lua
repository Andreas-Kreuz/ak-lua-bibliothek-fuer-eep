if AkDebugLoad then print("[#Start] Loading ce.mods.road.RoadCeModule ...") end
---@class RoadCeModule
RoadCeModule = {}
RoadCeModule.id = "c5a3e6d3-0f9b-4c89-a908-ed8cf8809362"
RoadCeModule.enabled = true
local initialized = false
RoadCeModule.name = "ce.mods.road.RoadCeModule"
local Intersection = require("ce.mods.road.Intersection")
local IntersectionSettings = require("ce.mods.road.IntersectionSettings")

function RoadCeModule.loadSettingsFromSlot(eepSaveId) return IntersectionSettings.loadSettingsFromSlot(eepSaveId) end

function RoadCeModule.init()
    if not RoadCeModule.enabled or initialized then return end

    local RoadBridgeConnector = require("ce.mods.road.bridge.RoadBridgeConnector")
    RoadBridgeConnector.registerStatePublishers()
    RoadBridgeConnector.registerFunctions()

    Intersection.initSequences()

    initialized = true
end

function RoadCeModule.run()
    if not RoadCeModule.enabled then return end

    Intersection.switchSequences()
end

return RoadCeModule
