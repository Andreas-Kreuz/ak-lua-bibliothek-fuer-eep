if AkDebugLoad then print("[#Start] Loading ce.mods.road.data.CrossingStatePublisher ...") end
local DataChangeBus = require("ce.hub.publish.DataChangeBus")
local Crossing = require("ce.mods.road.Crossing")
local CrossingDtoFactory = require("ce.mods.road.data.CrossingDtoFactory")
local CrossingsDataCollector = require("ce.mods.road.data.CrossingsDataCollector")

---@class CrossingStatePublisher
CrossingStatePublisher = {}
local enabled = true
local initialized = false
CrossingStatePublisher.name = "ce.mods.road.data.CrossingStatePublisher"

function CrossingStatePublisher.initialize()
    if not enabled or initialized then return end
    initialized = true
end

function CrossingStatePublisher.syncState()
    if not enabled then return end
    if not initialized then CrossingStatePublisher.initialize() end

    local crossingData = CrossingsDataCollector.collectCrossings(Crossing.allCrossings)
    local moduleSettings = CrossingsDataCollector.collectModuleSettings()

    DataChangeBus.fireListChange(CrossingDtoFactory.createIntersectionDtoList(crossingData.intersections))
    DataChangeBus.fireListChange(
        CrossingDtoFactory.createIntersectionLaneDtoList(crossingData.intersectionLanes)
    )
    DataChangeBus.fireListChange(
        CrossingDtoFactory.createIntersectionSwitchingDtoList(crossingData.intersectionSwitchings)
    )
    DataChangeBus.fireListChange(
        CrossingDtoFactory.createIntersectionTrafficLightDtoList(crossingData.intersectionTrafficLights)
    )
    DataChangeBus.fireListChange(CrossingDtoFactory.createIntersectionModuleSettingDtoList(moduleSettings))

    return {}
end

return CrossingStatePublisher
