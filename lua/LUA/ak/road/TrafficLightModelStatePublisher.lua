if AkDebugLoad then print("[#Start] Loading ak.road.TrafficLightModelStatePublisher ...") end
local DataChangeBus = require("ak.events.DataChangeBus")

---@class TrafficLightModelStatePublisher
TrafficLightModelStatePublisher = {}
local enabled = true
local initialized = false
TrafficLightModelStatePublisher.name = "ak.data.TrafficLightModelStatePublisher"
local TrafficLightModel = require("ak.road.TrafficLightModel")

function TrafficLightModelStatePublisher.initialize()
    if not enabled or initialized then return end

    initialized = true
end

function TrafficLightModelStatePublisher.syncState()
    if not enabled then return end

    if not initialized then TrafficLightModelStatePublisher.initialize() end

    local trafficLightModels = {}
    for _, ampelModel in pairs(TrafficLightModel.allModels) do
        local o = {
            id = ampelModel.name,
            name = ampelModel.name,
            type = "road",
            positions = {
                positionRed = ampelModel.signalIndexRed,
                positionGreen = ampelModel.signalIndexGreen,
                positionYellow = ampelModel.signalIndexYellow,
                positionRedYellow = ampelModel.signalIndexRedYellow,
                positionPedestrians = ampelModel.signalIndexPedestrian,
                positionOff = ampelModel.signalIndexSwitchOff,
                positionOffBlinking = ampelModel.signalIndexBlinkYellow
            }
        }
        table.insert(trafficLightModels, o)
    end

    DataChangeBus.fireListChange("signal-type-definitions", "id", trafficLightModels)

    return {
        -- ["signal-type-definitions"] = trafficLightModels
    }
end

return TrafficLightModelStatePublisher
