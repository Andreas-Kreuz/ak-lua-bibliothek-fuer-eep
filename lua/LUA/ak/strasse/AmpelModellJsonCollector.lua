print("Lade ak.strasse.AmpelModellJsonCollector")
AmpelModellJsonCollector = {}
local enabled = true
local initialized = false
AmpelModellJsonCollector.name = "ak.data.AmpelModellJsonCollector"
local AkAmpelModell = require("ak.strasse.AkAmpelModell")

function AmpelModellJsonCollector.initialize()
    if not enabled or initialized then
        return
    end

    initialized = true
end

function AmpelModellJsonCollector.collectData()
    if not enabled then
        return
    end

    if not initialized then
        AmpelModellJsonCollector.initialize()
    end

    local trafficLightModels = {}
    for _, ampelModel in pairs(AkAmpelModell.alleAmpelModelle) do
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

return AmpelModellJsonCollector