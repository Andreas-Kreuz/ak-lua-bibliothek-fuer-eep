--------------------------------
-- Lade Funktionen fuer Ampeln
--------------------------------
-- Planer
local TrafficLightModel = require("ak.road.TrafficLightModel")
local TrafficLight = require("ak.road.TrafficLight")
local Lane = require("ak.road.Lane")
local Crossing = require("ak.road.Crossing")
local CrossingSequence = require("ak.road.CrossingSequence")
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
    local K1 = TrafficLight:new(32, Grundmodell_Ampel_3)
    local K2 = TrafficLight:new(31, Grundmodell_Ampel_3)
    local K3 = TrafficLight:new(34, Grundmodell_Ampel_3)
    local K4 = TrafficLight:new(33, Grundmodell_Ampel_3)
    local K5 = TrafficLight:new(30, Grundmodell_Ampel_3)

    ----------------------------------------------------------------------------------------------------------------------
    -- Definiere alle Fahrspuren fuer Kreuzung 1
    ----------------------------------------------------------------------------------------------------------------------

    --        +------------------------------------------------------ Neue Fahrspur
    --        |              +--------------------------------------- Name der Fahrspur
    --        |              |            +------------------------- Speicher ID - um die Anzahl der Fahrzeuge
    --        |              |            |                                        und die Wartezeit zu speichern
    --        |              |            |    +-------------------- Ampel (Variablenname von oben)
    c2Lane1 = Lane:new("Fahrspur 1 - K2", 121, K1)
    c2Lane2 = Lane:new("Fahrspur 2 - K2", 122, K2)
    c2Lane3 = Lane:new("Fahrspur 3 - K2", 123, K3)
    c2Lane4 = Lane:new("Fahrspur 4 - K2", 124, K4)
    c2Lane5 = Lane:new("Fahrspur 5 - K2", 125, K5)

    c2Lane1:setDirections({'RIGHT'})
    c2Lane2:setDirections({'STRAIGHT'})
    c2Lane3:setDirections({'STRAIGHT'})
    c2Lane4:setDirections({'LEFT'})
    c2Lane5:setDirections({'LEFT', 'RIGHT'})

    -- region K1-Schaltungen
    ----------------------------------------------------------------------------------------------------------------------
    -- Definiere alle Schaltungen fuer Kreuzung 2
    ----------------------------------------------------------------------------------------------------------------------
    -- Eine Schaltung bestimmt, welche Fahrspuren gleichzeitig auf grün geschaltet werden dürfen, alle anderen sind rot

    c2 = Crossing:new("Kreuzung 2")

    --- Kreuzung 2: Schaltung 1
    local c2Sequence1 = c2:newSequence("Schaltung 1")
    c2Sequence1:addLane(c2Lane1)
    c2Sequence1:addTrafficLight(K1)
    c2Sequence1:addLane(c2Lane2)
    c2Sequence1:addTrafficLight(K2)
    c2Sequence1:addLane(c2Lane3)
    c2Sequence1:addTrafficLight(K3)

    --- Kreuzung 2: Schaltung 2
    local c2Sequence2 = c2:newSequence("Schaltung 2")
    c2Sequence2:addLane(c2Lane1)
    c2Sequence2:addTrafficLight(K1)
    c2Sequence2:addLane(c2Lane2)
    c2Sequence2:addTrafficLight(K2)

    --- Kreuzung 2: Schaltung 3
    local c2Sequence3 = c2:newSequence("Schaltung 3")
    c2Sequence3:addLane(c2Lane3)
    c2Sequence3:addTrafficLight(K3)
    c2Sequence3:addLane(c2Lane4)
    c2Sequence3:addTrafficLight(K4)

    --- Kreuzung 2: Schaltung 4
    local c2Sequence4 = c2:newSequence("Schaltung 4")
    c2Sequence4:addLane(c2Lane5)
    c2Sequence4:addTrafficLight(K5)
end
-- endregion

-- region K1-Fahrspuren
do
    --    +---------------------------- Variablenname der Ampel
    --    |    +----------------------- Legt eine neue Ampel an
    --    |    |                +------ Signal-ID dieser Ampel
    --    |    |                |   +-- Modell dieser Ampel - weiss wo rot, gelb und gruen ist
    local K1 = TrafficLight:new(17, Grundmodell_Ampel_3)
    local K2 = TrafficLight:new(13, Grundmodell_Ampel_3)
    local K3 = TrafficLight:new(12, Grundmodell_Ampel_3)
    local K4 = TrafficLight:new(11, Grundmodell_Ampel_3)
    local K5 = TrafficLight:new(10, Grundmodell_Ampel_3)
    local K6 = TrafficLight:new(09, Grundmodell_Ampel_3)
    local K7 = TrafficLight:new(16, Grundmodell_Ampel_3)
    local K8 = TrafficLight:new(15, Grundmodell_Ampel_3)
    ----------------------------------------------------------------------------------------------------------------------
    -- Definiere alle Fahrspuren fuer Kreuzung 1
    ----------------------------------------------------------------------------------------------------------------------

    --        +----------------------------------------------------- Neue Fahrspur
    --        |        +-------------------------------------------- Name der Fahrspur
    --        |        |                  +------------------------- Speicher ID - um die Anzahl der Fahrzeuge
    --        |        |                  |                                        und die Wartezeit zu speichern
    --        |        |                  |    +-------------------- Ampel (Variablenname von oben)
    c1Lane1 = Lane:new("Fahrspur 1 - K1", 101, K1)
    c1Lane2 = Lane:new("Fahrspur 2 - K1", 102, K2)
    c1Lane3 = Lane:new("Fahrspur 3 - K1", 103, K3)
    c1Lane4 = Lane:new("Fahrspur 4 - K1", 104, K4)
    c1Lane5 = Lane:new("Fahrspur 5 - K1", 105, K5)
    c1Lane6 = Lane:new("Fahrspur 6 - K1", 106, K6)
    c1Lane7 = Lane:new("Fahrspur 7 - K1", 107, K7)
    c1Lane8 = Lane:new("Fahrspur 8 - K1", 108, K8)

    c1Lane1:setDirections({'STRAIGHT', 'RIGHT'})
    c1Lane2:setDirections({'LEFT'})
    c1Lane3:setDirections({'STRAIGHT', 'RIGHT'})
    c1Lane4:setDirections({'LEFT'})
    c1Lane5:setDirections({'STRAIGHT', 'RIGHT'})
    c1Lane6:setDirections({'LEFT'})
    c1Lane7:setDirections({'STRAIGHT', 'RIGHT'})
    c1Lane8:setDirections({'LEFT'})

    local F1 = TrafficLight:new(40, Grundmodell_Ampel_3_FG)
    local F2 = TrafficLight:new(41, Grundmodell_Ampel_3_FG)
    local F3 = TrafficLight:new(36, Grundmodell_Ampel_3_FG)
    local F4 = TrafficLight:new(37, Grundmodell_Ampel_3_FG)
    local F5 = TrafficLight:new(38, Grundmodell_Ampel_3_FG)
    local F6 = TrafficLight:new(39, Grundmodell_Ampel_3_FG)
    local F7 = TrafficLight:new(42, Grundmodell_Ampel_3_FG)
    local F8 = TrafficLight:new(43, Grundmodell_Ampel_3_FG)

    -- endregion
    -- region K1-Schaltungen
    ----------------------------------------------------------------------------------------------------------------------
    -- Definiere alle Schaltungen fuer Kreuzung 1
    ----------------------------------------------------------------------------------------------------------------------
    -- Eine Schaltung bestimmt, welche Fahrspuren gleichzeitig auf grün geschaltet werden dürfen, alle anderen sind rot


    c1 = Crossing:new("Kreuzung 1")

    --- Kreuzung 1: Schaltung 1
    local c1Sequence1 = c1:newSequence("Schaltung 1")
    c1Sequence1:addLane(c1Lane1)
    c1Sequence1:addTrafficLight(K1)
    c1Sequence1:addLane(c1Lane5)
    c1Sequence1:addTrafficLight(K5)
    c1Sequence1:addPedestrianLight(F1, F2)
    c1Sequence1:addPedestrianLight(F3, F4)

    --- Kreuzung 1: Schaltung 2
    local c1Sequence2 = c1:newSequence("Schaltung 2")
    c1Sequence2:addLane(c1Lane2)
    c1Sequence2:addTrafficLight(K2)
    c1Sequence2:addLane(c1Lane6)
    c1Sequence2:addTrafficLight(K6)

    --- Kreuzung 1: Schaltung 3
    local c1Sequence3 = c1:newSequence("Schaltung 3")
    c1Sequence3:addLane(c1Lane3)
    c1Sequence3:addTrafficLight(K3)
    c1Sequence3:addLane(c1Lane7)
    c1Sequence3:addTrafficLight(K7)
    c1Sequence1:addPedestrianLight(F5, F6)
    c1Sequence1:addPedestrianLight(F7, F8)

    --- Kreuzung 1: Schaltung 4
    local c1Sequence4 = c1:newSequence("Schaltung 4")
    c1Sequence4:addLane(c1Lane4)
    c1Sequence4:addTrafficLight(K4)
    c1Sequence4:addLane(c1Lane8)
    c1Sequence4:addTrafficLight(K8)
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
