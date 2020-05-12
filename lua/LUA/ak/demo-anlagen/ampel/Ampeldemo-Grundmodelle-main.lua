--------------------------------
-- Lade Funktionen fuer Ampeln
--------------------------------
-- Planer
local TrafficLightModel = require("ak.road.TrafficLightModel")
local TrafficLight = require("ak.road.TrafficLight")
local Lane = require("ak.road.Lane")
local Crossing = require("ak.road.Crossing")
local CrossingCircuit = require("ak.road.CrossingCircuit")
TrafficLight.zeigeAnforderungen = true

------------------------------------------------
-- Damit kommt wird die Variable "Zugname" automatisch durch EEP belegt
-- http://emaps-eep.de/lua/code-schnipsel
------------------------------------------------
setmetatable(_ENV, {
    __index =
    function(_, k)
        local p = load(k);
        if p then
            local f = function(z) local s = Zugname
                Zugname = z; p()
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
function KpBetritt(richtung)
    assert(richtung, "richtung darf nicht nil sein. Richtige Lua-Funktion im Kontaktpunkt?")
    --print(richtung.name .. " betreten durch: " .. Zugname)
    richtung:betritt()
end

function KpVerlasse(richtung, signalaufrot)
    assert(richtung, "richtung darf nicht nil sein. Richtige Lua-Funktion im Kontaktpunkt?")
    --print(richtung.name .. " verlassen von: " .. Zugname)
    richtung:verlasse(signalaufrot, Zugname)
end

----------------------------------------------------------------------------------------------------------------------
-- Definiere eigene Ampel-Modelle - hier Ampel 3 aus dem Grundbestand
-- Fuer die Signalstellung siehe Auswahlbox unter "Auswahl des Signalbegriffs"
-- bei Rechtsklick auf das Signal im 2D Editor
----------------------------------------------------------------------------------------------------------------------
Grundmodell_Ampel_3 = TrafficLightModel:neu("Grundmodell Ampel 3", -- Name des Modells
    2, -- Signalstellung fuer rot   (2. Stellung)
    1, -- Signalstellung fuer gruen (1. Stellung)
    3) -- Signalstellung fuer gelb  (3. Stellung)

Grundmodell_Ampel_3_FG = TrafficLightModel:neu("Grundmodell Ampel 3 FG", -- Name des Modells
    2, -- Signalstellung fuer rot   (2. Stellung)
    2, -- Signalstellung fuer rot   (2. Stellung)
    2, -- Signalstellung fuer rot   (2. Stellung)
    2, -- Signalstellung fuer rot   (2. Stellung)
    1) -- Signalstellung fuer gruen (1. Stellung)


-- Zeige die Signal-IDs aller Ampeln an
--for i = 1, 1000 do
--    EEPShowInfoSignal(i, true)
--    EEPChangeInfoSignal(i, "Signal " .. i)
--end




-- region K2-Richtungen
----------------------------------------------------------------------------------------------------------------------
-- Definiere alle Richtungen fuer Kreuzung 1
----------------------------------------------------------------------------------------------------------------------

--      +------------------------------------------------------ Neue Richtung
--      |              +--------------------------------------- Name der Richtung
--      |              |             +------------------------- Speicher ID - um die Anzahl der Fahrzeuge
--      |              |             |                                        und die Wartezeit zu speichern
--      |              |             |      +------------------ neue Ampel für diese Richtung (
--      |              |             |      |           +------ Signal-ID dieser Ampel
--      |              |             |      |           |   +-- Modell dieser Ampel - weiss wo rot, gelb und gruen ist
k2_r1 = Lane:neu("Richtung 1", 121, { TrafficLight:neu(32, Grundmodell_Ampel_3) })
k2_r2 = Lane:neu("Richtung 2", 122, { TrafficLight:neu(31, Grundmodell_Ampel_3) })
k2_r3 = Lane:neu("Richtung 3", 123, { TrafficLight:neu(34, Grundmodell_Ampel_3) })
k2_r4 = Lane:neu("Richtung 4", 124, { TrafficLight:neu(33, Grundmodell_Ampel_3) })
k2_r5 = Lane:neu("Richtung 5", 125, { TrafficLight:neu(30, Grundmodell_Ampel_3) })

k2_r1:setRichtungen({ 'RIGHT' })
k2_r2:setRichtungen({ 'STRAIGHT' })
k2_r3:setRichtungen({ 'STRAIGHT' })
k2_r4:setRichtungen({ 'LEFT' })
k2_r5:setRichtungen({ 'LEFT', 'RIGHT' })


--region K1-Schaltungen
----------------------------------------------------------------------------------------------------------------------
-- Definiere alle Schaltungen fuer Kreuzung 2
----------------------------------------------------------------------------------------------------------------------
-- Eine Schaltung bestimmt, welche Richtungen gleichzeitig auf grün geschaltet werden dürfen, alle anderen sind rot

--- Kreuzung 2: Schaltung 1
local k2_schaltung1 = CrossingCircuit:neu("Schaltung 1")
k2_schaltung1:fuegeRichtungHinzu(k2_r1)
k2_schaltung1:fuegeRichtungHinzu(k2_r2)
k2_schaltung1:fuegeRichtungHinzu(k2_r3)

--- Kreuzung 2: Schaltung 2
local k2_schaltung2 = CrossingCircuit:neu("Schaltung 2")
k2_schaltung2:fuegeRichtungHinzu(k2_r1)
k2_schaltung2:fuegeRichtungHinzu(k2_r2)

--- Kreuzung 2: Schaltung 3
local k2_schaltung3 = CrossingCircuit:neu("Schaltung 3")
k2_schaltung3:fuegeRichtungHinzu(k2_r3)
k2_schaltung3:fuegeRichtungHinzu(k2_r4)

--- Kreuzung 2: Schaltung 4
local k2_schaltung4 = CrossingCircuit:neu("Schaltung 4")
k2_schaltung4:fuegeRichtungHinzu(k2_r5)

k2 = Crossing:neu("Kreuzung 2")
k2:fuegeSchaltungHinzu(k2_schaltung1)
k2:fuegeSchaltungHinzu(k2_schaltung2)
k2:fuegeSchaltungHinzu(k2_schaltung3)
k2:fuegeSchaltungHinzu(k2_schaltung4)
--endregion

-- region K1-Richtungen
----------------------------------------------------------------------------------------------------------------------
-- Definiere alle Richtungen fuer Kreuzung 1
----------------------------------------------------------------------------------------------------------------------

--      +------------------------------------------------------ Neue Richtung
--      |        +--------------------------------------- Name der Richtung
--      |        |             +------------------------- Speicher ID - um die Anzahl der Fahrzeuge
--      |        |             |                                        und die Wartezeit zu speichern
--      |        |             |      +------------------ neue Ampel für diese Richtung (
--      |        |             |      |           +------ Signal-ID dieser Ampel
--      |        |             |      |           |   +-- Modell dieser Ampel - weiss wo rot, gelb und gruen ist
k1_r1 = Lane:neu("Richtung 1", 101, { TrafficLight:neu(17, Grundmodell_Ampel_3) })
k1_r2 = Lane:neu("Richtung 2", 102, { TrafficLight:neu(13, Grundmodell_Ampel_3) })
k1_r3 = Lane:neu("Richtung 3", 103, { TrafficLight:neu(12, Grundmodell_Ampel_3) })
k1_r4 = Lane:neu("Richtung 4", 104, { TrafficLight:neu(11, Grundmodell_Ampel_3) })
k1_r5 = Lane:neu("Richtung 5", 105, { TrafficLight:neu(10, Grundmodell_Ampel_3) })
k1_r6 = Lane:neu("Richtung 6", 106, { TrafficLight:neu(09, Grundmodell_Ampel_3) })
k1_r7 = Lane:neu("Richtung 7", 107, { TrafficLight:neu(16, Grundmodell_Ampel_3) })
k1_r8 = Lane:neu("Richtung 8", 108, { TrafficLight:neu(15, Grundmodell_Ampel_3) })

k1_r1:setRichtungen({ 'STRAIGHT', 'RIGHT' })
k1_r2:setRichtungen({ 'LEFT' })
k1_r3:setRichtungen({ 'STRAIGHT', 'RIGHT' })
k1_r4:setRichtungen({ 'LEFT' })
k1_r5:setRichtungen({ 'STRAIGHT', 'RIGHT' })
k1_r6:setRichtungen({ 'LEFT' })
k1_r7:setRichtungen({ 'STRAIGHT', 'RIGHT' })
k1_r8:setRichtungen({ 'LEFT' })

local k1_r1_5_fg = Lane:neu("Richtung 1+5 FG", -1, {
    -- keine Speicher-ID fuer Fussgaenger notwendig (-1)
    TrafficLight:neu(40, Grundmodell_Ampel_3_FG), TrafficLight:neu(41, Grundmodell_Ampel_3_FG),
    TrafficLight:neu(36, Grundmodell_Ampel_3_FG), TrafficLight:neu(37, Grundmodell_Ampel_3_FG)
})
local k1_r3_7_fg = Lane:neu("Richtung 3+7 FG", -1, {
    -- keine Speicher-ID fuer Fussgaenger notwendig (-1)
    TrafficLight:neu(38, Grundmodell_Ampel_3_FG), TrafficLight:neu(39, Grundmodell_Ampel_3_FG),
    TrafficLight:neu(42, Grundmodell_Ampel_3_FG), TrafficLight:neu(43, Grundmodell_Ampel_3_FG)
})

k1_r1_5_fg:setTrafficType('PEDESTRIAN')
k1_r3_7_fg:setTrafficType('PEDESTRIAN')

--endregion
--region K1-Schaltungen
----------------------------------------------------------------------------------------------------------------------
-- Definiere alle Schaltungen fuer Kreuzung 1
----------------------------------------------------------------------------------------------------------------------
-- Eine Schaltung bestimmt, welche Richtungen gleichzeitig auf grün geschaltet werden dürfen, alle anderen sind rot

--- Kreuzung 1: Schaltung 1
local k1_schaltung1 = CrossingCircuit:neu("Schaltung 1")
k1_schaltung1:fuegeRichtungHinzu(k1_r1)
k1_schaltung1:fuegeRichtungHinzu(k1_r5)
k1_schaltung1:fuegeRichtungFuerFussgaengerHinzu(k1_r1_5_fg)

--- Kreuzung 1: Schaltung 2
local k1_schaltung2 = CrossingCircuit:neu("Schaltung 2")
k1_schaltung2:fuegeRichtungHinzu(k1_r2)
k1_schaltung2:fuegeRichtungHinzu(k1_r6)

--- Kreuzung 1: Schaltung 3
local k1_schaltung3 = CrossingCircuit:neu("Schaltung 3")
k1_schaltung3:fuegeRichtungHinzu(k1_r3)
k1_schaltung3:fuegeRichtungHinzu(k1_r7)
k1_schaltung3:fuegeRichtungFuerFussgaengerHinzu(k1_r3_7_fg)

--- Kreuzung 1: Schaltung 4
local k1_schaltung4 = CrossingCircuit:neu("Schaltung 4")
k1_schaltung4:fuegeRichtungHinzu(k1_r4)
k1_schaltung4:fuegeRichtungHinzu(k1_r8)

k1 = Crossing:neu("Kreuzung 1")
k1:fuegeSchaltungHinzu(k1_schaltung1)
k1:fuegeSchaltungHinzu(k1_schaltung2)
k1:fuegeSchaltungHinzu(k1_schaltung3)
k1:fuegeSchaltungHinzu(k1_schaltung4)
--endregion

local ModuleRegistry = require("ak.core.ModuleRegistry")
ModuleRegistry.registerModules(
    require("ak.core.CoreLuaModule"),
    require("ak.data.DataLuaModule"),
    require("ak.road.CrossingLuaModul")
)

function EEPMain()
    --print("Speicher: " .. collectgarbage("count"))
    ModuleRegistry.runTasks(1)
    return 1
end
