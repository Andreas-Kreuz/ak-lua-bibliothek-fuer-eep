-----------------------------------------------------------------------------------------------------------------------
-- Diese Skript ist eine kleine Vorlage f�r das Verwenden von Kreuzungen, WENN DU NOCH KEIN LUA IN DER ANLAGE BENUTZT
-- 1) Kopiere dieses Skript in das LUA-Verzeichnis von EEP
-- 2) Benenne die Kopie um, z.B. "anlage1.lua"
-- 3) Verwende die folgende Zeile im Lua-Editor von EEP, um Deine Kopie in EEP mit der Anlage zu laden
--    require("anlage1")
-----------------------------------------------------------------------------------------------------------------------


-- Diese Zeile l�dt die Modulverwaltung der Lua-Bibliothek
local ModuleRegistry = require("ak.core.ModuleRegistry")

-- Diese Zeilen aktivieren die folgenden Module in der Modulverwaltung
-- * Core (immer ben�tigt)
-- * Data (Export der Daten f�r EEP)
-- * Crossing (f�r die Ampelsteuerung notwendig)
ModuleRegistry.registerModules(
    require("ak.core.CoreLuaModule"),
    require("ak.data.DataLuaModule"),
    require("ak.road.CrossingLuaModul")
)

-- Die EEPMain Methode wird von EEP genutzt. Sie muss immer 1 zur�ckgeben.
function EEPMain()
    -- Die Modulverwaltung startet die Aufgaben in allen Modulen bei jedem f�nften EEPMain-Aufruf
    ModuleRegistry.runTasks(5)
    return 1
end

-- Hier kommt eine Kreuzung mit 4 Fahrspuren
--                                |    N   |        |        |
--                                | lane 1 |        |        |
--                                |        |        |        |
--                                |STRAIGHT|        |        |
--                             S1 | +RIGHT |        |        |
--                             K1 |========|========|========| K2
--                                |        |        |        |
--                    K3          |        |        |        |
--  ------------------------------+        +        |        |
--                       |  |                                |
--                       |  |                                |
--                       |  |                                |
--  ----------------------  ------+                          |
--                       |  |                                |
--  W lane 2  LEFT+RIGHT |K5|                                |
--                       |  |                                |
--  ------------------------------+        +        |        |
--                    K6,         |        |        |        |
--                    K7          |        |        |        | S2
--  In lane 2 all cars         K8=|========|========|========|-K9
--  allowed to turn               |        | LEFT   |STRAIGHT|
--  right when lane 3             |        |        |        |
--  is turning left               |        | lane 3 | lane 4 |
--  (Route: RIGHT_TURN_ROUTE)     |        |   S    |    S   |
--

local Lane = require("ak.road.Lane")
local Crossing = require("ak.road.Crossing")
-- local CrossingSequence = require("ak.road.CrossingSequence")
-- local LaneSettings = require("ak.road.LaneSettings")
local TrafficLight = require("ak.road.TrafficLight")
local TrafficLightModel = require("ak.road.TrafficLightModel")

-- Ampeln f�r den Kraftfahrverkehr (K) und Strassenbahnen (S)
local K1, K2
-- 3 Schaltungen
local sequenceA, sequenceB
-- die Kreuzung
local crossing

-- Nutze einen Speicherslot in EEP um die Einstellungen f�r Kreuzungen zu laden und zu speichern
Crossing.loadSettingsFromSlot(10)

-- Erzeuge immer erst Deine Ampeln
K1 = TrafficLight:new("K1", 23, TrafficLightModel.JS2_3er_mit_FG) -- NORTH STRAIGHT 1 (right)
K2 = TrafficLight:new("K2", 24, TrafficLightModel.JS2_3er_mit_FG) -- NORTH STRAIGHT 2 (left)

-- Erzeuge Kreuzung und Fahrspuren
crossing = Crossing:new("Dein Kreuzungsname")
lane1 = Lane:new("Lane 1 N", 1, K1, {Lane.Directions.STRAIGHT, Lane.Directions.RIGHT})
lane2 = Lane:new("Lane 2 S", 2, K2, {Lane.Directions.STRAIGHT, Lane.Directions.RIGHT})

-- Lege die Schaltungen an und f�ge Ampeln f�r Fahrzeuge, Tram und Fu�g�nger hinzu
sequenceA = crossing:newSequence("Schaltung Fahrzeuge")
sequenceA:addCarLights(K1)
sequenceA:addPedestrianLights(K2)

sequenceB = crossing:newSequence("Schaltung Fussgaenger")
sequenceB:addCarLights(K2)
sequenceB:addPedestrianLights(K1)
