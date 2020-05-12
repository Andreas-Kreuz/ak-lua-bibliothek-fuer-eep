print("Loading ak.road.TrafficLightModelJsonCollector ...")
TrafficLightModelJsonCollector = {}
local enabled = true
local initialized = false
TrafficLightModelJsonCollector.name = "ak.data.TrafficLightModelJsonCollector"
local TrafficLightModel = require("ak.road.TrafficLightModel")

function TrafficLightModelJsonCollector.initialize()
    if not enabled or initialized then
        return
    end

    initialized = true
end

function TrafficLightModelJsonCollector.collectData()
    if not enabled then
        return
    end

    if not initialized then
        TrafficLightModelJsonCollector.initialize()
    end

    local trafficLightModels = {}
    for _, ampelModel in pairs(TrafficLightModel.allModels) do
        local o = {
            id = ampelModel.name,
            name = ampelModel.name,
            type = "road",
            positions = {
                positionRed = ampelModel.sigIndexRot,
                positionGreen = ampelModel.sigIndexGruen,
                positionYellow = ampelModel.sigIndexGelb,
                positionRedYellow = ampelModel.sigIndexRotGelb,
                positionPedestrians = ampelModel.sigIndexFgGruen,
                positionOff = ampelModel.sigIndexKomplettAus,
                positionOffBlinking = ampelModel.sigIndexGelbBlinkenAus
            }
        }
        table.insert(trafficLightModels, o)
    end

    return {["signal-type-definitions"] = trafficLightModels}
end

return TrafficLightModelJsonCollector
