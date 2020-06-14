local Crossing = require("ak.road.Crossing")
local Lane = require("ak.road.Lane")
local TrafficLight = require("ak.road.TrafficLight")
local TrafficLightModel = require("ak.road.TrafficLightModel")

-- Einfache Kreuzung mit zwei Fahrspuren und drei Ampeln
local K1 = TrafficLight:new("K1", 13, TrafficLightModel.JS2_3er_mit_FG)
local K2 = TrafficLight:new("K2", 24, TrafficLightModel.JS2_3er_ohne_FG)
local K3 = TrafficLight:new("K3", 15, TrafficLightModel.JS2_3er_mit_FG)

lane1 = Lane:new("FS1", 1, K1, { Lane.Directions.STRAIGHT, Lane.Directions.RIGHT })
lane2 = Lane:new("FS2", 2, K2, { Lane.Directions.LEFT })

local c = Crossing:new("Einfache Kreuzung")
local sequenceA = c:newSequence("Schaltung A")
sequenceA:addCarLights(K1)
local sequenceB = c:newSequence("Schaltung B")
sequenceB:addCarLights(K2, K3)


-- Modulverwaltung der Lua-Bibliothek laden
local ModuleRegistry = require("ak.core.ModuleRegistry")
ModuleRegistry.registerModules(
    require("ak.core.CoreLuaModule"),
    require("ak.data.DataLuaModule"),
    require("ak.road.CrossingLuaModul")
)

function EEPMain()
    ModuleRegistry.runTasks()
    return 1
end



-- Zähler kommen später hier

-- Noch nicht für die Verwendung vorgesehen
sequenceA.greenPhaseSeconds = 5
sequenceB.greenPhaseSeconds = 5
