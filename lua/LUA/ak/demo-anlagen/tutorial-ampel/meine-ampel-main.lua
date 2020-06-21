clearlog()
print("ak.demo-anlagen.tutorial-ampel.meine-ampel-main")
local TrafficLightModel = require("ak.road.TrafficLightModel")
local TrafficLight = require("ak.road.TrafficLight")
local Lane = require("ak.road.Lane")
local Crossing = require("ak.road.Crossing")
local CrossingSequence = require("ak.road.CrossingSequence")

-- Hier kommt der Code
Crossing.showSignalIdOnSignal = false
Crossing.showSequenceOnSignal = false

local K1 = TrafficLight:new("K1", 12, TrafficLightModel.JS2_3er_mit_FG)
local K2 = TrafficLight:new("K2", 17, TrafficLightModel.JS2_3er_ohne_FG)
local K3 = TrafficLight:new("K3", 9, TrafficLightModel.JS2_3er_mit_FG)
local K4 = TrafficLight:new("K4", 14, TrafficLightModel.JS2_3er_mit_FG)
local K5 = TrafficLight:new("K5", 16, TrafficLightModel.JS2_3er_mit_FG)
local K6 = TrafficLight:new("K6", 18, TrafficLightModel.JS2_3er_ohne_FG)
local K7 = TrafficLight:new("K7", 11, TrafficLightModel.JS2_3er_mit_FG)
local K8 = TrafficLight:new("K8", 10, TrafficLightModel.JS2_3er_mit_FG)
local K9 = TrafficLight:new("K9", 19, TrafficLightModel.JS2_3er_ohne_FG)
local K10 = TrafficLight:new("K10", 13, TrafficLightModel.JS2_3er_mit_FG)
local K11 = TrafficLight:new("K11", 15, TrafficLightModel.JS2_3er_mit_FG)
local K12 = TrafficLight:new("K12", 24, TrafficLightModel.JS2_3er_ohne_FG)

local F1 = K1 -- K1 wird später auch als Fussgaenger-Ampel F1 verwendet
local F2 = K3 -- K3 wird später auch als Fussgaenger-Ampel F2 verwendet
local F3 = TrafficLight:new("F3", 20, TrafficLightModel.JS2_2er_nur_FG)
local F4 = TrafficLight:new("F4", 21, TrafficLightModel.JS2_2er_nur_FG)
local F5 = K4
local F6 = K5
local F7 = K7
local F8 = K8
local F9 = TrafficLight:new("F9", 22, TrafficLightModel.JS2_2er_nur_FG)
local F10 = TrafficLight:new("F10", 23, TrafficLightModel.JS2_2er_nur_FG)
local F11 = K10
local F12 = K11
-------------------------------------------------------------------------------
-- Definiere die Fahrspuren fuer die Kreuzung
-------------------------------------------------------------------------------

--   +---------------------------------------------- Neue Fahrspur
--   |        +------------------------------- Name der Fahrspur
--   |        |     +------------------------- Speicher ID - um die Anzahl der Fahrzeuge
--   |        |     |                                        und die Wartezeit zu speichern
--   |        |     |      +------------------ Fahrspur-Ampel - da wartet der Verkehr
--   |        |     |      |           +------ Signal-ID dieser Ampel
--   |        |     |      |           |   +-- Modell kann rot, gelb, gruen und FG schalten
n1 = Lane:new("N1", 100, K1, {'STRAIGHT', 'RIGHT'})
n2 = Lane:new("N2", 101, K3, {'LEFT'}) -- zusätzlich in der Schaltung K2

-- Fahrspuren im Osten
o1 = Lane:new("O1", 104, K4, {'STRAIGHT', 'RIGHT'})
o2 = Lane:new("O2", 105, K6, {'LEFT'}) -- zusätlich in der Schaltung K5

-- Fahrspuren im Sueden
s1 = Lane:new("S1", 107, K7, {'STRAIGHT', 'RIGHT'})
s2 = Lane:new("S2", 108, K8, {"LEFT"}) -- zusätlich in der Schaltung K9

-- Fahrspuren im Westen
w1 = Lane:new("W1", 111, K10, {'STRAIGHT', 'RIGHT'})
w2 = Lane:new("W2", 112, K12, {'LEFT'}) -- Zusätzlich in der Schaltung K11

--------------------------------------------------------------
-- Definiere die Schaltungen und die Kreuzung
--------------------------------------------------------------
-- Eine Schaltung bestimmt, welche Fahrspuren gleichzeitig auf
-- grün geschaltet werden dürfen, alle anderen sind rot

--- Tutorial 1: Schaltung 1
local sch1 = CrossingSequence:new("Schaltung 1")
sch1:addCarLights(K1)
sch1:addCarLights(K7)
sch1:addPedestrianLights(F5, F6)
sch1:addPedestrianLights(F11, F12)

--- Tutorial 1: Schaltung 2
local sch2 = CrossingSequence:new("Schaltung 2")
sch2:addCarLights(K2, K3)
sch2:addCarLights(K8, K9)
sch2:addPedestrianLights(F3, F4)
sch2:addPedestrianLights(F5, F6)
sch2:addPedestrianLights(F11, F12)
sch2:addPedestrianLights(F9, F10)

--- Tutorial 1: Schaltung 3
local sch3 = CrossingSequence:new("Schaltung 3")
sch3:addCarLights(K4)
sch3:addCarLights(K10)
sch3:addPedestrianLights(F1, F2)
sch3:addPedestrianLights(F3, F4)
sch3:addPedestrianLights(F7, F8)
sch3:addPedestrianLights(F9, F10)

--- Tutorial 1: Schaltung 4
local sch4 = CrossingSequence:new("Schaltung 4")
sch4:addCarLights(K5, K6)
sch4:addCarLights(K11, K12)
sch4:addPedestrianLights(F1, F2)
sch4:addPedestrianLights(F7, F8)

-- --- Tutorial 1: Schaltung 5
-- local sch5 = CrossingSequence:new("Schaltung 5")
-- sch5:addCarLights(K1)
-- sch5:addCarLights(K2, K3)
-- sch5:addPedestrianLights(F11, F12)
--
-- --- Tutorial 1: Schaltung 6
-- local sch6 = CrossingSequence:new("Schaltung 6")
-- sch6:addCarLights(K4)
-- sch6:addCarLights(K5, K6)
-- sch6:addPedestrianLights(F1, F2)
-- sch6:addPedestrianLights(F3, F4)
-- sch6:addPedestrianLights(F7, F8)
--
-- --- Tutorial 1: Schaltung 7
-- local sch7 = CrossingSequence:new("Schaltung 7")
-- sch7:addCarLights(K7)
-- sch7:addCarLights(K8, K9)
-- sch7:addPedestrianLights(F5, F6)
--
-- --- Tutorial 1: Schaltung 6
-- local sch8 = CrossingSequence:new("Schaltung 8")
-- sch8:addCarLights(K4)
-- sch8:addCarLights(K5, K6)
-- sch8:addPedestrianLights(F1, F2)
-- sch8:addPedestrianLights(F7, F8)
-- sch8:addPedestrianLights(F9, F10)

k1 = Crossing:new("Tutorial 1")
k1:addSequence(sch1)
k1:addSequence(sch2)
k1:addSequence(sch3)
k1:addSequence(sch4)
-- k1:addSequence(sch5)
-- k1:addSequence(sch6)
-- k1:addSequence(sch7)
-- k1:addSequence(sch8)


k1:addStaticCam("Richtung Norden")
k1:addStaticCam("Richtung Ost")
k1:addStaticCam("Übersicht")

local ModuleRegistry = require("ak.core.ModuleRegistry")
ModuleRegistry.registerModules(require("ak.core.CoreLuaModule"), require("ak.road.CrossingLuaModul"))

function EEPMain()
    ModuleRegistry.runTasks()
    return 1
end
