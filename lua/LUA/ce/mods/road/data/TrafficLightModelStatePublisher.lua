if AkDebugLoad then print("[#Start] Loading ce.mods.road.data.TrafficLightModelStatePublisher ...") end
local DataChangeBus = require("ce.hub.publish.DataChangeBus")
local TrafficLightModelDtoFactory = require("ce.mods.road.data.TrafficLightModelDtoFactory")
local TrafficLightModelsDataCollector = require("ce.mods.road.data.TrafficLightModelsDataCollector")

---@class TrafficLightModelStatePublisher
TrafficLightModelStatePublisher = {}
local enabled = true
local initialized = false
TrafficLightModelStatePublisher.name = "ce.mods.road.data.TrafficLightModelStatePublisher"

function TrafficLightModelStatePublisher.initialize()
    if not enabled or initialized then return end
    initialized = true
end

function TrafficLightModelStatePublisher.syncState()
    if not enabled then return end
    if not initialized then TrafficLightModelStatePublisher.initialize() end

    local trafficLightModels = TrafficLightModelsDataCollector.collectTrafficLightModels()
    DataChangeBus.fireListChange(TrafficLightModelDtoFactory.createSignalTypeDefinitionDtoList(trafficLightModels))

    return {}
end

return TrafficLightModelStatePublisher
