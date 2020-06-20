clearlog()
local TrafficLightModel = require("ak.road.TrafficLightModel")
local TrafficLight = require("ak.road.TrafficLight")
local Lane = require("ak.road.Lane")
local Crossing = require("ak.road.Crossing")
-- local CrossingSequence = require("ak.road.CrossingSequence")

Crossing.debug = true

------------------------------------------------
-- Damit kommt wird die Variable "Zugname" automatisch durch EEP belegt
-- http://emaps-eep.de/lua/code-schnipsel
------------------------------------------------
setmetatable(_ENV, {
    __index = function(_, k)
        local p = load(k)
        if p then
            local f = function(z)
                local s = Zugname
                Zugname = z
                p()
                Zugname = s
            end
            _ENV[k] = f
            return f
        end
        return nil
    end
})

--------------------------------------------
-- Definiere Funktionen fuer Kontaktpunkte
--------------------------------------------
function enterLane(lane)
    assert(lane, "lane darf nicht nil sein. Richtige Lua-Funktion im Kontaktpunkt?")
    lane:vehicleEntered(Zugname)
end

function leaveLane(lane)
    assert(lane, "lane darf nicht nil sein. Richtige Lua-Funktion im Kontaktpunkt?")
    lane:vehicleLeft(Zugname)
end

-------------------------------------------------------------------------------
-- Definiere die Fahrspuren fuer die Kreuzung
-------------------------------------------------------------------------------

--    +---------------------------- Variablenname der Ampel
--    |    +----------------------- Legt eine neue Ampel an
--    |    |                +------ Signal-ID dieser Ampel
--    |    |                |   +-- Modell dieser Ampel - weiss wo rot, gelb und gruen / Fussgaenger ist
local K1 = TrafficLight:new("K1/F1", 16, TrafficLightModel.JS2_3er_mit_FG)
-- Ampel K1 ist gleichzeitig eine Fußgängerampel
local K8 = TrafficLight:new("K8", 17, TrafficLightModel.JS2_2er_OFF_YELLOW_GREEN) -- Ampel K8 ist nur für Rechtsabbieger
local L1 = TrafficLight:new("L1", 07, TrafficLightModel.Unsichtbar_2er)
local K2 = TrafficLight:new("K2/F2", 08, TrafficLightModel.JS2_3er_mit_FG)
local K3 = TrafficLight:new("K3/F3", 09, TrafficLightModel.JS2_3er_mit_FG)
local K4 = TrafficLight:new("K4/F4", 10, TrafficLightModel.JS2_3er_mit_FG)
local K5 = TrafficLight:new("K5/F5", 12, TrafficLightModel.JS2_3er_mit_FG)
local K6 = TrafficLight:new("K6", 13, TrafficLightModel.JS2_3er_ohne_FG) -- dies ist keine Fußgängerampel
local K7 = TrafficLight:new("K7/F6", 11, TrafficLightModel.JS2_3er_mit_FG)

-- Ampeln für die Straßenbahn nutzen die Lichtfunktion der einzelnen Immobilien
local S1 = TrafficLight:new("S1", 14, TrafficLightModel.Unsichtbar_2er,
                            "#29_Straba Signal Halt", -- rot
                            "#28_Straba Signal geradeaus", --  gruen
                            "#27_Straba Signal anhalten", --   gelb
                            "#26_Straba Signal A") --    Anforderung
local S2 = TrafficLight:new("S2", 15, TrafficLightModel.Unsichtbar_2er,
                            "#32_Straba Signal Halt", --       rot
                            "#30_Straba Signal geradeaus", --  gruen
                            "#31_Straba Signal anhalten", --   gelb
                            "#33_Straba Signal A") --    Anforderung

local F1 = K1 -- Die Fussgängerampel F1 ist die selbe, wie Ampel K1, zeigt aber später "Fußgänger grün"
local F2 = K2
local F3 = K3
local F4 = K4
local F5 = K5
local F6 = K7

--   +-----------------------------------------Neue Fahrspur
--   |        +------------------------------- Name der Fahrspur
--   |        |   +------------------------- Speicher ID - um die Anzahl der Fahrzeuge
--   |        |   |                                        und die Wartezeit zu speichern
--   |        |   |    +------------------ neue Ampel für diese Fahrspur
--   |        |   |    |           +------ Signal-ID dieser Ampel
--   |        |   |    |           |   +-- Modell kann rot, gelb, gruen und FG schalten
-- Die Fahrspur N wird durch die Fahrspur-Ampel L1 (Signal ID 07) gesteuert
-- K1 und K2 müssen später gleichzeitig leuchten (Signal ID 08, 15)
n = Lane:new("N", 100, L1)
K1:applyToLane(n)
K8:applyToLane(n, "Rechtsabbieger")

-- Die Fahrspur O1 wird durch die Fahrspur-Ampel K2 (Signal 09) gesteuert
-- K4 muss später gleichzeitig leuchten (Signal ID 10)
o1 = Lane:new("O1", 102, K3)

-- Fahrspuren im Westen
-- Die Fahrspur W1 wird durch die Fahrspur-Ampel K5 (Signal 12) gesteuert
w1 = Lane:new("W1", 104, K5)

-- Die Fahrspur W2 wird durch die Fahrspur-Ampel K6 (Signal 13) gesteuert
-- K7 muss später gleichzeitig leuchten (Signal ID 11)
w2 = Lane:new("W2", 105, K6)

-- Fahrspuren fuer Strassenbahnen:
os = Lane:new("OS", 107, S1)
os:showRequestsOn(S1)
os:useSignalForQueue() -- Erfasst Anforderungen, wenn ein Fahrzeug an Signal 14 steht

ws = Lane:new("WS", 108, S2)
ws:showRequestsOn(S2)
ws:useTrackForQueue(2) -- Erfasst Anforderungen, wenn ein Fahrzeug auf Strasse 2 steht

--------------------------------------------------------------
-- Definiere die Schaltungen und die Kreuzung
--------------------------------------------------------------
-- Eine Schaltung bestimmt, welche Fahrspuren gleichzeitig auf
-- grün geschaltet werden dürfen, alle anderen sind rot

k1 = Crossing:new("Tutorial 2")

--- Tutorial 2: Schaltung 1
local sch1 = k1:newSequence("Schaltung 1")
sch1:addCarLights(K3)
sch1:addCarLights(K4)
sch1:addTramLights(S1)
sch1:addCarLights(K5)
sch1:addTramLights(S2)
sch1:addPedestrianLights(F1, F2)

--- Tutorial 2: Schaltung 2
local sch2 = k1:newSequence("Schaltung 2")
sch2:addCarLights(K6)
sch2:addCarLights(K7)
sch2:addCarLights(K8)
sch2:addPedestrianLights(F3, F4)

--- Tutorial 2: Schaltung 3
local sch3 = k1:newSequence("Schaltung 3")
sch3:addCarLights(K1)
sch3:addCarLights(K2)
sch3:addPedestrianLights(F3, F4)
sch3:addPedestrianLights(F5, F6)

-- Die Kreuzung soll die Schaltungen einfach nur in Ihrer Reihenfolge schalten
k1:setSwitchInStrictOrder(true)

local ModuleRegistry = require("ak.core.ModuleRegistry")
ModuleRegistry.registerModules(
    require("ak.core.CoreLuaModule"),
    require("ak.road.CrossingLuaModul")
)

function EEPMain()
    ModuleRegistry.runTasks()
    return 1
end
