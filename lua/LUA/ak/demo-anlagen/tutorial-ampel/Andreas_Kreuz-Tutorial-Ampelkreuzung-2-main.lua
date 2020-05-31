clearlog()
local TrafficLightModel = require("ak.road.TrafficLightModel")
local TrafficLight = require("ak.road.TrafficLight")
local Lane = require("ak.road.Lane")
local Crossing = require("ak.road.Crossing")
local CrossingCircuit = require("ak.road.CrossingCircuit")

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
                Zugname = s end
            _ENV[k] = f
            return f end
        return nil
    end
})

--------------------------------------------
-- Definiere Funktionen fuer Kontaktpunkte
--------------------------------------------
function KpBetritt(richtung)
    assert(richtung, "richtung darf nicht nil sein. Richtige Lua-Funktion im Kontaktpunkt?")
    richtung:vehicleEntered(Zugname)
end

function KpVerlasse(richtung, switchToRed)
    assert(richtung, "richtung darf nicht nil sein. Richtige Lua-Funktion im Kontaktpunkt?")
    richtung:vehicleLeft(switchToRed, Zugname)
end

-------------------------------------------------------------------------------
-- Definiere die Richtungen fuer die Kreuzung
-------------------------------------------------------------------------------

--   +---------------------------------------------- Neue Richtung
--   |        +------------------------------- Name der Richtung
--   |        |     +------------------------- Speicher ID - um die Anzahl der Fahrzeuge
--   |        |     |                                        und die Wartezeit zu speichern
--   |        |     |      +------------------ neue Ampel für diese Richtung
--   |        |     |      |           +------ Signal-ID dieser Ampel
--   |        |     |      |           |   +-- Modell kann rot, gelb, gruen und FG schalten
n = Lane:new("N", 100, {
    TrafficLight:new(07, TrafficLightModel.JS2_3er_mit_FG),
    TrafficLight:new(08, TrafficLightModel.JS2_3er_mit_FG)
})

fg_n = Lane:new("FG_n", 101, {
    TrafficLight:new(07, TrafficLightModel.JS2_3er_mit_FG), -- Wird geteilt mit N
    TrafficLight:new(08, TrafficLightModel.JS2_3er_mit_FG) -- Wird geteilt mit N
})

-- Die Richtung O1 hat zwei Ampeln fuer geradeaus: 9 und 10 jeweils mit Fussgaengern
o1 = Lane:new("O1", 102, {
    TrafficLight:new(09, TrafficLightModel.JS2_3er_mit_FG),
    TrafficLight:new(10, TrafficLightModel.JS2_3er_mit_FG)
})

fg_o = Lane:new("FG_O", 103, {
    TrafficLight:new(09, TrafficLightModel.JS2_3er_mit_FG), -- Wird geteilt mit O1
    TrafficLight:new(10, TrafficLightModel.JS2_3er_mit_FG) -- Wird geteilt mit O1
})


-- Richtungen im Westen
w1 = Lane:new("W1", 104, { TrafficLight:new(12, TrafficLightModel.JS2_3er_mit_FG) })
w2 = Lane:new("W2", 105, {
    TrafficLight:new(11, TrafficLightModel.JS2_3er_mit_FG),
    TrafficLight:new(13, TrafficLightModel.JS2_3er_ohne_FG)
})
fg_w = Lane:new("FG_W", 106, {
    TrafficLight:new(11, TrafficLightModel.JS2_3er_mit_FG), -- Wird geteilt mit W1
    TrafficLight:new(12, TrafficLightModel.JS2_3er_mit_FG) -- Wird geteilt mit W2
})

-- Richtungen fuer Strassenbahnen:
os = Lane:new("OS", 107, {
    TrafficLight:new(14, TrafficLightModel.Unsichtbar_2er,
        "#29_Straba Signal Halt", --       rot   schaltet das Licht dieser Immobilie ein
        "#28_Straba Signal geradeaus", --  gruen schaltet das Licht dieser Immobilie ein
        "#27_Straba Signal anhalten", --   gelb  schaltet das Licht dieser Immobilie ein
        "#26_Straba Signal A") --    Anforderung schaltet das Licht dieser Immobilie ein
})
os:zaehleAnAmpelAlle(14) -- Erfasst Anforderungen, wenn ein Fahrzeug an Signal 14 steht

ws = Lane:new("WS", 108, {
    TrafficLight:new(15, TrafficLightModel.Unsichtbar_2er,
        "#32_Straba Signal Halt", --       rot   schaltet das Licht dieser Immobilie ein
        "#30_Straba Signal geradeaus", --  gruen schaltet das Licht dieser Immobilie ein
        "#31_Straba Signal anhalten", --   gelb  schaltet das Licht dieser Immobilie ein
        "#33_Straba Signal A") --    Anforderung schaltet das Licht dieser Immobilie ein
})
ws:zaehleAnStrasseAlle(2) -- Erfasst Anforderungen, wenn ein Fahrzeug auf Strasse 2 steht


--------------------------------------------------------------
-- Definiere die Schaltungen und die Kreuzung
--------------------------------------------------------------
-- Eine Schaltung bestimmt, welche Richtungen gleichzeitig auf
-- grün geschaltet werden dürfen, alle anderen sind rot

--- Tutorial 2: Schaltung 1
local sch1 = CrossingCircuit:new("Schaltung 1")
sch1:addLane(o1)
sch1:addLane(os)
sch1:addLane(w1)
sch1:addLane(ws)
sch1:addPedestrianCrossing(fg_n)

--- Tutorial 2: Schaltung 2
local sch2 = CrossingCircuit:new("Schaltung 2")
sch2:addLane(w2)
sch2:addPedestrianCrossing(fg_o)

--- Tutorial 2: Schaltung 3
local sch3 = CrossingCircuit:new("Schaltung 3")
sch3:addLane(n)
sch3:addPedestrianCrossing(fg_o)
sch3:addPedestrianCrossing(fg_w)

k1 = Crossing:new("Tutorial 2")
k1:fuegeSchaltungHinzu(sch1)
k1:fuegeSchaltungHinzu(sch2)
k1:fuegeSchaltungHinzu(sch3)

local ModuleRegistry = require("ak.core.ModuleRegistry")
ModuleRegistry.registerModules(
    require("ak.core.CoreLuaModule"),
    require("ak.road.CrossingLuaModul")
)

function EEPMain()
    ModuleRegistry.runTasks()
    return 1
end
