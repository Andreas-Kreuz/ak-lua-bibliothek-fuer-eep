if AkDebugLoad then print("Loading ak.road.TrafficLightModelJsonCollector ...") end
local EventBroker = require("ak.util.EventBroker")

---@class TrafficLightModelJsonCollector
TrafficLightModelJsonCollector = {}
local enabled = true
local initialized = false
TrafficLightModelJsonCollector.name = "ak.data.TrafficLightModelJsonCollector"
local TrafficLightModel = require("ak.road.TrafficLightModel")

function TrafficLightModelJsonCollector.initialize()
    if not enabled or initialized then return end

    initialized = true
end

function TrafficLightModelJsonCollector.collectData()
    if not enabled then return end

    if not initialized then TrafficLightModelJsonCollector.initialize() end

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

    EventBroker.fireListChange("signal-type-definitions", "id", trafficLightModels)

    return {
        -- ["signal-type-definitions"] = trafficLightModels
    }

end

return TrafficLightModelJsonCollector
