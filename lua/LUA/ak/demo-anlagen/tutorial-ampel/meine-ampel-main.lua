clearlog()
local TrafficLightModel = require("ak.road.TrafficLightModel")
local TrafficLight = require("ak.road.TrafficLight")
local Lane = require("ak.road.Lane")
local Crossing = require("ak.road.Crossing")
local CrossingCircuit = require("ak.road.CrossingCircuit")

-- Hier kommt der Code
Crossing.zeigeSignalIdsAllerSignale = false
Crossing.zeigeSchaltungAlsInfo = false


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
n1 = Lane:neu("N1", 100, { TrafficLight:neu(12, TrafficLightModel.JS2_3er_mit_FG) })
n1:setRichtungen({ 'STRAIGHT', 'RIGHT' })

-- Die Richtung N2 hat zwei Ampeln fuer's Linksabbiegen, 9 mit Fussgaengerampel und 17 ohne
n2 = Lane:neu("N2", 101, {
    TrafficLight:neu(9, TrafficLightModel.JS2_3er_mit_FG),
    TrafficLight:neu(17, TrafficLightModel.JS2_3er_ohne_FG)
})
n2:setRichtungen({ 'LEFT' })

-- Die Richtungen für Fussgaenger haben auch je zwei Ampeln
fg_n1 = Lane:neu("FG_N1", 102, {
    TrafficLight:neu(9, TrafficLightModel.JS2_3er_mit_FG), -- Wird geteilt mit N2
    TrafficLight:neu(12, TrafficLightModel.JS2_3er_mit_FG) -- Wird geteilt mit N1
})
fg_n2 = Lane:neu("FG_N2", 103, {
    TrafficLight:neu(20, TrafficLightModel.JS2_2er_nur_FG),
    TrafficLight:neu(21, TrafficLightModel.JS2_2er_nur_FG),
})
fg_n1:setTrafficType('PEDESTRIAN')
fg_n2:setTrafficType('PEDESTRIAN')

-- Richtungen im Osten
o1 = Lane:neu("O1", 104, { TrafficLight:neu(14, TrafficLightModel.JS2_3er_mit_FG) })
o2 = Lane:neu("O2", 105, {
    TrafficLight:neu(16, TrafficLightModel.JS2_3er_mit_FG),
    TrafficLight:neu(18, TrafficLightModel.JS2_3er_ohne_FG)
})
o1:setRichtungen({ 'STRAIGHT', 'RIGHT' })
o2:setRichtungen({ 'LEFT' })
fg_o = Lane:neu("FG_O", 106, {
    TrafficLight:neu(14, TrafficLightModel.JS2_3er_mit_FG), -- Wird geteilt mit O1
    TrafficLight:neu(16, TrafficLightModel.JS2_3er_mit_FG) -- Wird geteilt mit O2
})
fg_o:setTrafficType('PEDESTRIAN')

-- Richtungen im Sueden
s1 = Lane:neu("S1", 107, { TrafficLight:neu(11, TrafficLightModel.JS2_3er_mit_FG) })
s2 = Lane:neu("S2", 108, {
    TrafficLight:neu(10, TrafficLightModel.JS2_3er_mit_FG),
    TrafficLight:neu(19, TrafficLightModel.JS2_3er_ohne_FG)
})
s1:setRichtungen({ 'STRAIGHT', 'RIGHT' })
s2:setRichtungen({ 'LEFT' })

fg_s1 = Lane:neu("FG_S1", 109, {
    TrafficLight:neu(10, TrafficLightModel.JS2_3er_mit_FG), -- Wird geteilt mit S2
    TrafficLight:neu(11, TrafficLightModel.JS2_3er_mit_FG) -- Wird geteilt mit S1
})
fg_s2 = Lane:neu("FG_S2", 110, {
    TrafficLight:neu(22, TrafficLightModel.JS2_2er_nur_FG),
    TrafficLight:neu(23, TrafficLightModel.JS2_2er_nur_FG),
})
fg_s1:setTrafficType('PEDESTRIAN')
fg_s2:setTrafficType('PEDESTRIAN')


-- Richtungen im Westen
w1 = Lane:neu("W1", 111, { TrafficLight:neu(13, TrafficLightModel.JS2_3er_mit_FG) })
w2 = Lane:neu("W2", 112, {
    TrafficLight:neu(15, TrafficLightModel.JS2_3er_mit_FG),
    TrafficLight:neu(24, TrafficLightModel.JS2_3er_ohne_FG)
})
w1:setRichtungen({ 'STRAIGHT', 'RIGHT' })
w2:setRichtungen({ 'LEFT' })
fg_w = Lane:neu("FG_W", 113, {
    TrafficLight:neu(13, TrafficLightModel.JS2_3er_mit_FG), -- Wird geteilt mit O1
    TrafficLight:neu(15, TrafficLightModel.JS2_3er_mit_FG) -- Wird geteilt mit O2
})
fg_w:setTrafficType('PEDESTRIAN')


--------------------------------------------------------------
-- Definiere die Schaltungen und die Kreuzung
--------------------------------------------------------------
-- Eine Schaltung bestimmt, welche Richtungen gleichzeitig auf
-- grün geschaltet werden dürfen, alle anderen sind rot

--- Tutorial 1: Schaltung 1
local sch1 = CrossingCircuit:neu("Schaltung 1")
sch1:fuegeRichtungHinzu(n1)
sch1:fuegeRichtungHinzu(s1)
sch1:fuegeRichtungFuerFussgaengerHinzu(fg_o)
sch1:fuegeRichtungFuerFussgaengerHinzu(fg_w)

--- Tutorial 1: Schaltung 2
local sch2 = CrossingCircuit:neu("Schaltung 2")
sch2:fuegeRichtungHinzu(n2)
sch2:fuegeRichtungHinzu(s2)
sch2:fuegeRichtungFuerFussgaengerHinzu(fg_n2)
sch2:fuegeRichtungFuerFussgaengerHinzu(fg_o)
sch2:fuegeRichtungFuerFussgaengerHinzu(fg_w)
sch2:fuegeRichtungFuerFussgaengerHinzu(fg_s2)

--- Tutorial 1: Schaltung 3
local sch3 = CrossingCircuit:neu("Schaltung 3")
sch3:fuegeRichtungHinzu(o1)
sch3:fuegeRichtungHinzu(w1)
sch3:fuegeRichtungFuerFussgaengerHinzu(fg_n1)
sch3:fuegeRichtungFuerFussgaengerHinzu(fg_n2)
sch3:fuegeRichtungFuerFussgaengerHinzu(fg_s1)
sch3:fuegeRichtungFuerFussgaengerHinzu(fg_s2)

--- Tutorial 1: Schaltung 4
local sch4 = CrossingCircuit:neu("Schaltung 4")
sch4:fuegeRichtungHinzu(o2)
sch4:fuegeRichtungHinzu(w2)
sch4:fuegeRichtungFuerFussgaengerHinzu(fg_n1)
sch4:fuegeRichtungFuerFussgaengerHinzu(fg_s1)

-- --- Tutorial 1: Schaltung 5
-- local sch5 = CrossingCircuit:neu("Schaltung 5")
-- sch5:fuegeRichtungHinzu(n1)
-- sch5:fuegeRichtungHinzu(n2)
-- sch5:fuegeRichtungFuerFussgaengerHinzu(fg_w)
--
-- --- Tutorial 1: Schaltung 6
-- local sch6 = CrossingCircuit:neu("Schaltung 6")
-- sch6:fuegeRichtungHinzu(o1)
-- sch6:fuegeRichtungHinzu(o2)
-- sch6:fuegeRichtungFuerFussgaengerHinzu(fg_n1)
-- sch6:fuegeRichtungFuerFussgaengerHinzu(fg_n2)
-- sch6:fuegeRichtungFuerFussgaengerHinzu(fg_s1)
--
-- --- Tutorial 1: Schaltung 7
-- local sch7 = CrossingCircuit:neu("Schaltung 7")
-- sch7:fuegeRichtungHinzu(s1)
-- sch7:fuegeRichtungHinzu(s2)
-- sch7:fuegeRichtungFuerFussgaengerHinzu(fg_o)
--
-- --- Tutorial 1: Schaltung 6
-- local sch8 = CrossingCircuit:neu("Schaltung 8")
-- sch8:fuegeRichtungHinzu(o1)
-- sch8:fuegeRichtungHinzu(o2)
-- sch8:fuegeRichtungFuerFussgaengerHinzu(fg_n1)
-- sch8:fuegeRichtungFuerFussgaengerHinzu(fg_s1)
-- sch8:fuegeRichtungFuerFussgaengerHinzu(fg_s2)


k1 = Crossing:neu("Tutorial 1")
k1:fuegeSchaltungHinzu(sch1)
k1:fuegeSchaltungHinzu(sch2)
k1:fuegeSchaltungHinzu(sch3)
k1:fuegeSchaltungHinzu(sch4)
-- k1:fuegeSchaltungHinzu(sch5)
-- k1:fuegeSchaltungHinzu(sch6)
-- k1:fuegeSchaltungHinzu(sch7)
-- k1:fuegeSchaltungHinzu(sch8)

local ModuleRegistry = require("ak.core.ModuleRegistry")
ModuleRegistry.registerModules(
    require("ak.core.CoreLuaModule"),
    require("ak.road.CrossingLuaModul")
)

function EEPMain()
    ModuleRegistry.runTasks()
    return 1
end
