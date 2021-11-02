-----------------------------------------------------------------------------------------------------------------------
-- Diese Skript ist eine kleine Vorlage für das Verwenden von Kreuzungen, WENN DU NOCH KEIN LUA IN DER ANLAGE BENUTZT
-- 1) Kopiere dieses Skript in das LUA-Verzeichnis von EEP
-- 2) Benenne die Kopie um, z.B. "anlage1.lua"
-- 3) Verwende die folgende Zeile im Lua-Editor von EEP, um Deine Kopie in EEP mit der Anlage zu laden
--    require("anlage1")
-----------------------------------------------------------------------------------------------------------------------
-- Diese Zeile lädt die Modulverwaltung der Lua-Bibliothek
local ModuleRegistry = require("ak.core.ModuleRegistry")

-- Diese Zeilen aktivieren die folgenden Module in der Modulverwaltung
-- * Core (immer benötigt)
-- * Data (Export der Daten für EEP)
-- * Crossing (für die Ampelsteuerung notwendig)
ModuleRegistry.registerModules(require("ak.core.CoreLuaModule"), require("ak.data.DataLuaModule"),
                               require("ak.road.CrossingLuaModul"))

-- Die EEPMain Methode wird von EEP genutzt. Sie muss immer 1 zurückgeben.
function EEPMain()
    -- Die Modulverwaltung startet die Aufgaben in allen Modulen bei jedem fünften EEPMain-Aufruf
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
local TrafficLight = require("ak.road.TrafficLight")
local TrafficLightModel = require("ak.road.TrafficLightModel")

-- Fahrspur-Ampeln (L) regeln den Verkehr der Fahrspur
local L1, L2, L3, L4
-- Ampeln für den Kraftfahrverkehr (K) und Strassenbahnen (S)
local K1, K2, K3, K5, K6, K7, K8, K9, S1, S2
-- 3 Schaltungen
local sequenceA, sequenceB, sequenceC
-- die Kreuzung
local crossing

-- Nutze einen Speicherslot in EEP um die Einstellungen für Kreuzungen zu laden und zu speichern
Crossing.loadSettingsFromSlot(10)

-- Erzeuge immer erst Deine Ampeln
L1 = TrafficLight:new("L1", 11, TrafficLightModel.Unsichtbar_2er) -- Signal for Lane 1
L2 = TrafficLight:new("L2", 12, TrafficLightModel.Unsichtbar_2er) -- Signal for Lane 2
L3 = TrafficLight:new("L3", 13, TrafficLightModel.Unsichtbar_2er) -- Signal for Lane 3
L4 = TrafficLight:new("L4", 14, TrafficLightModel.Unsichtbar_2er) -- Signal for Lane 4
K1 = TrafficLight:new("K1", 23, TrafficLightModel.JS2_3er_mit_FG) -- NORTH STRAIGHT 1 (right)
K2 = TrafficLight:new("K2", 24, TrafficLightModel.JS2_3er_mit_FG) -- NORTH STRAIGHT 2 (left)
K3 = TrafficLight:new("K3", 25, TrafficLightModel.JS2_3er_mit_FG) -- EAST STRAIGHT (left)
K5 = TrafficLight:new("K5", 27, TrafficLightModel.JS2_3er_ohne_FG) -- EAST STRAIGHT (above lane)
K6 = TrafficLight:new("K6", 28, TrafficLightModel.JS2_3er_mit_FG) -- EAST STRAIGHT (right)
K7 = TrafficLight:new("K7", 29, TrafficLightModel.JS2_2er_OFF_YELLOW_GREEN) -- EAST RIGHT ADDITIONAL (right)
K8 = TrafficLight:new("K8", 30, TrafficLightModel.JS2_3er_mit_FG) -- SOUTH LEFT (left)
K9 = TrafficLight:new("K9", 31, TrafficLightModel.JS2_3er_mit_FG) -- SOUTH STRAIGHT (right)

-- Straßenbahn-Ampeln mit Immobilien OHNE echtes Signal
S1 = TrafficLight:new("S1", -1, TrafficLightModel.NONE, "#5528_Straba Signal Halt", "#5531_Straba Signal geradeaus",
                      "#5529_Straba Signal anhalten", "#5530_Straba Signal A")
S2 = TrafficLight:new("S2", -1, TrafficLightModel.NONE, "#5435_Straba Signal Halt", "#5521_Straba Signal geradeaus",
                      "#5520_Straba Signal anhalten", "#5518_Straba Signal A")

-- Erzeuge Kreuzung und Fahrspuren
crossing = Crossing:new("Dein Kreuzungsname")
lane1 = Lane:new("Lane 1 N", 1, L1, {Lane.Directions.STRAIGHT, Lane.Directions.RIGHT})
lane2 = Lane:new("Lane 2 E", 2, L2, {Lane.Directions.LEFT, Lane.Directions.RIGHT})
lane3 = Lane:new("Lane 3 S", 3, L3, {Lane.Directions.LEFT})
lane4 = Lane:new("Lane 4 S", 4, L4, {Lane.Directions.STRAIGHT})

-- Lege fest, welche Ampeln für eine Kreuzung gelten
K1:applyToLane(lane1)
K6:applyToLane(lane2)
K7:applyToLane(lane2, "Rechtsabbieger")
K8:applyToLane(lane3)
K9:applyToLane(lane4)

-- Lege die Schaltungen an und füge Ampeln für Fahrzeuge, Tram und Fußgänger hinzu
sequenceA = crossing:newSequence("Sequence A - North South")
sequenceA:addCarLights(K1)
sequenceA:addCarLights(K2)
sequenceA:addTramLights(S1)
sequenceA:addCarLights(K9)
sequenceA:addTramLights(S2)
sequenceA:addPedestrianLights(K3)
sequenceA:addPedestrianLights(K6)

sequenceB = crossing:newSequence("Sequence B - South + East Right")
sequenceB:addCarLights(K7)
sequenceB:addCarLights(K8)
sequenceB:addCarLights(K9)

sequenceC = crossing:newSequence("Sequence C - East only")
sequenceC:addCarLights(K3)
sequenceC:addCarLights(K5)
sequenceC:addCarLights(K6)
sequenceC:addPedestrianLights(K1)
sequenceC:addPedestrianLights(K2)
sequenceC:addPedestrianLights(K8)
sequenceC:addPedestrianLights(K9)
