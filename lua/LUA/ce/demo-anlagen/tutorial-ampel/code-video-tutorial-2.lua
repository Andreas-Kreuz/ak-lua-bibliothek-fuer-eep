local Intersection = require("ce.mods.road.Intersection")
local Lane = require("ce.mods.road.Lane")
local TrafficLight = require("ce.mods.road.TrafficLight")
local TrafficLightModel = require("ce.mods.road.TrafficLightModel")

-- Einfache Kreuzung mit zwei Fahrspuren und drei Ampeln
local K1 = TrafficLight:new("K1", 13, TrafficLightModel.JS2_3er_mit_FG)
local K2 = TrafficLight:new("K2", 24, TrafficLightModel.JS2_3er_ohne_FG)
local K3 = TrafficLight:new("K3", 15, TrafficLightModel.JS2_3er_mit_FG)
local K4 = TrafficLight:new("K4", 12, TrafficLightModel.JS2_3er_mit_FG)
local K5 = TrafficLight:new("K5", 17, TrafficLightModel.JS2_3er_ohne_FG)
local K6 = TrafficLight:new("K6", 09, TrafficLightModel.JS2_3er_mit_FG)
local F1 = TrafficLight:new("F1", 20, TrafficLightModel.JS2_2er_nur_FG)
local F2 = TrafficLight:new("F2", 21, TrafficLightModel.JS2_2er_nur_FG)

lane1 = Lane:new("FS1", 1, K1, { Lane.Directions.STRAIGHT, Lane.Directions.RIGHT })
lane2 = Lane:new("FS2", 2, K2, { Lane.Directions.LEFT })
lane3 = Lane:new("FS3", 3, K5, { Lane.Directions.STRAIGHT, Lane.Directions.RIGHT })
lane4 = Lane:new("FS4", 4, K6, { Lane.Directions.LEFT })

local c = Intersection:new("Einfache Kreuzung", 5)
local sequenceA = c:newSequence("Schaltung A")
sequenceA:addCarLights(K1)
sequenceA:addPedestrianLights(K4, K6, F1, F2)
local sequenceB = c:newSequence("Schaltung B")
sequenceB:addCarLights(K2, K3)
sequenceB:addPedestrianLights(K4, K6)
local sequenceC = c:newSequence("Schaltung C")
sequenceC:addCarLights(K4, K5, K6)
sequenceC:addPedestrianLights(K1, K3)


-- Modulverwaltung der Lua-Bibliothek laden
local ControlExtension = require("ce.ControlExtension")
ControlExtension.addModules(
    require("ce.mods.road.RoadCeModule")
)

function EEPMain()
    ControlExtension.runTasks()
    return 1
end
