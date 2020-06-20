--------------------------------
-- Lade Funktionen fuer Ampeln
--------------------------------
-- Planer
local TrafficLightModel = require("ak.road.TrafficLightModel")
local TrafficLight = require("ak.road.TrafficLight")
local Lane = require("ak.road.Lane")
local Crossing = require("ak.road.Crossing")
Crossing.loadSettingsFromSlot(100)
TrafficLight.zeigeAnforderungen = true

------------------------------------------------
-- Damit kommt wird die Variable "Zugname" automatisch durch EEP belegt
-- http://emaps-eep.de/lua/code-schnipsel
------------------------------------------------
setmetatable(_ENV, {
    __index = function(_, k)
        local p = load(k);
        if p then
            local f = function(z)
                local s = Zugname
                Zugname = z;
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
    -- print(lane.name .. " betreten durch: " .. Zugname)
    lane:vehicleEntered(Zugname)
end

function leaveLane(lane)
    assert(lane, "lane darf nicht nil sein. Richtige Lua-Funktion im Kontaktpunkt?")
    -- print(lane.name .. " verlassen von: " .. Zugname)
    lane:vehicleLeft(Zugname)
end

----------------------------------------------------------------------------------------------------------------------
-- Definiere eigene Ampel-Modelle - hier Ampel 3 aus dem Grundbestand
-- Fuer die Signalstellung siehe Auswahlbox unter "Auswahl des Signalbegriffs"
-- bei Rechtsklick auf das Signal im 2D Editor
----------------------------------------------------------------------------------------------------------------------
Grundmodell_Ampel_3 = TrafficLightModel:new("Grundmodell Ampel 3", -- Name des Modells
2, -- Signalstellung fuer rot   (2. Stellung)
1, -- Signalstellung fuer gruen (1. Stellung)
3) -- Signalstellung fuer gelb  (3. Stellung)

Grundmodell_Ampel_3_FG = TrafficLightModel:new("Grundmodell Ampel 3 FG", -- Name des Modells
2, -- Signalstellung fuer rot   (2. Stellung)
2, -- Signalstellung fuer rot   (2. Stellung)
2, -- Signalstellung fuer rot   (2. Stellung)
2, -- Signalstellung fuer rot   (2. Stellung)
1) -- Signalstellung fuer gruen (1. Stellung)

-- Zeige die Signal-IDs aller Ampeln an
-- for i = 1, 1000 do
--    EEPShowInfoSignal(i, true)
--    EEPChangeInfoSignal(i, "Signal " .. i)
-- end

-- region K2-Fahrspuren
do
    --    +---------------------------- Variablenname der Ampel
    --    |    +----------------------- Legt eine neue Ampel an
    --    |    |                +------ Signal-ID dieser Ampel
    --    |    |                |   +-- Modell dieser Ampel - weiss wo rot, gelb und gruen ist
    local K1 = TrafficLight:new("K1", 32, Grundmodell_Ampel_3)
    local K2 = TrafficLight:new("K2", 31, Grundmodell_Ampel_3)
    local K3 = TrafficLight:new("K3", 34, Grundmodell_Ampel_3)
    local K4 = TrafficLight:new("K4", 33, Grundmodell_Ampel_3)
    local K5 = TrafficLight:new("K5", 30, Grundmodell_Ampel_3)
    -------------------------------------------------------------------------------------------------------------------
    -- Definiere alle Fahrspuren fuer Kreuzung 1
    -------------------------------------------------------------------------------------------------------------------

    --        +------------------------------------------------------ Neue Fahrspur
    --        |              +--------------------------------------- Name der Fahrspur
    --        |              |            +------------------------- Speicher ID - um die Anzahl der Fahrzeuge
    --        |              |            |                                        und die Wartezeit zu speichern
    --        |              |            |    +-------------------- Ampel (Variablenname von oben)
    c2Lane1 = Lane:new("Fahrspur 1 - K2", 121, K1, {'RIGHT'})
    c2Lane2 = Lane:new("Fahrspur 2 - K2", 122, K2, {'STRAIGHT'})
    c2Lane3 = Lane:new("Fahrspur 3 - K2", 123, K3, {'STRAIGHT'})
    c2Lane4 = Lane:new("Fahrspur 4 - K2", 124, K4, {'LEFT'})
    c2Lane5 = Lane:new("Fahrspur 5 - K2", 125, K5, {'LEFT', 'RIGHT'})

    -- region K1-Schaltungen
    -------------------------------------------------------------------------------------------------------------------
    -- Definiere alle Schaltungen fuer Kreuzung 2
    -------------------------------------------------------------------------------------------------------------------
    -- Eine Schaltung bestimmt, welche Fahrspuren gleichzeitig auf grün geschaltet werden dürfen, alle anderen sind rot

    c2 = Crossing:new("Kreuzung 2")

    --- Kreuzung 2: Schaltung 1
    local c2Sequence1 = c2:newSequence("Schaltung 1")
    c2Sequence1:addCarLights(K1)
    c2Sequence1:addCarLights(K2)
    c2Sequence1:addCarLights(K3)

    --- Kreuzung 2: Schaltung 2
    local c2Sequence2 = c2:newSequence("Schaltung 2")
    c2Sequence2:addCarLights(K1)
    c2Sequence2:addCarLights(K2)

    --- Kreuzung 2: Schaltung 3
    local c2Sequence3 = c2:newSequence("Schaltung 3")
    c2Sequence3:addCarLights(K3)
    c2Sequence3:addCarLights(K4)

    --- Kreuzung 2: Schaltung 4
    local c2Sequence4 = c2:newSequence("Schaltung 4")
    c2Sequence4:addCarLights(K5)

    c2:addStaticCam("Kreuzung 2")
end
-- endregion

-- region K1-Fahrspuren
do
    --    +---------------------------- Variablenname der Ampel
    --    |    +----------------------- Legt eine neue Ampel an
    --    |    |                +------ Signal-ID dieser Ampel
    --    |    |                |   +-- Modell dieser Ampel - weiss wo rot, gelb und gruen ist
    local K1 = TrafficLight:new("K1", 17, Grundmodell_Ampel_3)
    local K2 = TrafficLight:new("K2", 13, Grundmodell_Ampel_3)
    local K3 = TrafficLight:new("K3", 12, Grundmodell_Ampel_3)
    local K4 = TrafficLight:new("K4", 11, Grundmodell_Ampel_3)
    local K5 = TrafficLight:new("K5", 10, Grundmodell_Ampel_3)
    local K6 = TrafficLight:new("K6", 09, Grundmodell_Ampel_3)
    local K7 = TrafficLight:new("K7", 16, Grundmodell_Ampel_3)
    local K8 = TrafficLight:new("K8", 15, Grundmodell_Ampel_3)
    -------------------------------------------------------------------------------------------------------------------
    -- Definiere alle Fahrspuren fuer Kreuzung 1
    -------------------------------------------------------------------------------------------------------------------

    --        +----------------------------------------------------- Neue Fahrspur
    --        |        +-------------------------------------------- Name der Fahrspur
    --        |        |                  +------------------------- Speicher ID - um die Anzahl der Fahrzeuge
    --        |        |                  |                                        und die Wartezeit zu speichern
    --        |        |                  |    +-------------------- Ampel (Variablenname von oben)
    c1Lane1 = Lane:new("Fahrspur 1 - K1", 101, K1, {'STRAIGHT', 'RIGHT'})
    c1Lane2 = Lane:new("Fahrspur 2 - K1", 102, K2, {'LEFT'})
    c1Lane3 = Lane:new("Fahrspur 3 - K1", 103, K3, {'STRAIGHT', 'RIGHT'})
    c1Lane4 = Lane:new("Fahrspur 4 - K1", 104, K4, {'LEFT'})
    c1Lane5 = Lane:new("Fahrspur 5 - K1", 105, K5, {'STRAIGHT', 'RIGHT'})
    c1Lane6 = Lane:new("Fahrspur 6 - K1", 106, K6, {'LEFT'})
    c1Lane7 = Lane:new("Fahrspur 7 - K1", 107, K7, {'STRAIGHT', 'RIGHT'})
    c1Lane8 = Lane:new("Fahrspur 8 - K1", 108, K8, {'LEFT'})

    local F1 = TrafficLight:new("F1", 40, Grundmodell_Ampel_3_FG)
    local F2 = TrafficLight:new("F2", 41, Grundmodell_Ampel_3_FG)
    local F3 = TrafficLight:new("F3", 36, Grundmodell_Ampel_3_FG)
    local F4 = TrafficLight:new("F4", 37, Grundmodell_Ampel_3_FG)
    local F5 = TrafficLight:new("F5", 38, Grundmodell_Ampel_3_FG)
    local F6 = TrafficLight:new("F6", 39, Grundmodell_Ampel_3_FG)
    local F7 = TrafficLight:new("F7", 42, Grundmodell_Ampel_3_FG)
    local F8 = TrafficLight:new("F8", 43, Grundmodell_Ampel_3_FG)

    -- endregion
    -- region K1-Schaltungen
    -------------------------------------------------------------------------------------------------------------------
    -- Definiere alle Schaltungen fuer Kreuzung 1
    -------------------------------------------------------------------------------------------------------------------
    -- Eine Schaltung bestimmt, welche Fahrspuren gleichzeitig auf grün geschaltet werden dürfen, alle anderen sind rot

    c1 = Crossing:new("Kreuzung 1")

    --- Kreuzung 1: Schaltung 1
    local c1Sequence1 = c1:newSequence("Schaltung 1")
    c1Sequence1:addCarLights(K1)
    c1Sequence1:addCarLights(K5)
    c1Sequence1:addPedestrianLights(F1, F2)
    c1Sequence1:addPedestrianLights(F3, F4)

    --- Kreuzung 1: Schaltung 2
    local c1Sequence2 = c1:newSequence("Schaltung 2")
    c1Sequence2:addCarLights(K2)
    c1Sequence2:addCarLights(K6)

    --- Kreuzung 1: Schaltung 3
    local c1Sequence3 = c1:newSequence("Schaltung 3")
    c1Sequence3:addCarLights(K3)
    c1Sequence3:addCarLights(K7)
    c1Sequence1:addPedestrianLights(F5, F6)
    c1Sequence1:addPedestrianLights(F7, F8)

    --- Kreuzung 1: Schaltung 4
    local c1Sequence4 = c1:newSequence("Schaltung 4")
    c1Sequence4:addCarLights(K4)
    c1Sequence4:addCarLights(K8)

    c1:addStaticCam("Kreuzung 1")
end
-- endregion

local ModuleRegistry = require("ak.core.ModuleRegistry")
ModuleRegistry.registerModules(require("ak.core.CoreLuaModule"), require("ak.data.DataLuaModule"),
                               require("ak.road.CrossingLuaModul"))

function EEPMain()
    -- print("Speicher: " .. collectgarbage("count"))
    ModuleRegistry.runTasks(1)
    return 1
end
