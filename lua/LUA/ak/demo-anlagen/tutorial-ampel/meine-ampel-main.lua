clearlog()
local TrafficLightModel = require("ak.road.TrafficLightModel")
local TrafficLight = require("ak.road.TrafficLight")
local Lane = require("ak.road.Lane")
local Crossing = require("ak.road.Crossing")
local CrossingSequence = require("ak.road.CrossingSequence")

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
n1 = Lane:new("N1", 100, { TrafficLight:new(12, TrafficLightModel.JS2_3er_mit_FG) })
n1:setDirections({ 'STRAIGHT', 'RIGHT' })

-- Die Richtung N2 hat zwei Ampeln fuer's Linksabbiegen, 9 mit Fussgaengerampel und 17 ohne
n2 = Lane:new("N2", 101, {
    TrafficLight:new(9, TrafficLightModel.JS2_3er_mit_FG),
    TrafficLight:new(17, TrafficLightModel.JS2_3er_ohne_FG)
})
n2:setDirections({ 'LEFT' })

-- Die Richtungen fÃ¼r Fussgaenger haben auch je zwei Ampeln
fg_n1 = Lane:new("FG_N1", 102, {
    TrafficLight:new(9, TrafficLightModel.JS2_3er_mit_FG), -- Wird geteilt mit N2
    TrafficLight:new(12, TrafficLightModel.JS2_3er_mit_FG) -- Wird geteilt mit N1
})
fg_n2 = Lane:new("FG_N2", 103, {
    TrafficLight:new(20, TrafficLightModel.JS2_2er_nur_FG),
    TrafficLight:new(21, TrafficLightModel.JS2_2er_nur_FG),
})
fg_n1:setTrafficType('PEDESTRIAN')
fg_n2:setTrafficType('PEDESTRIAN')

-- Richtungen im Osten
o1 = Lane:new("O1", 104, { TrafficLight:new(14, TrafficLightModel.JS2_3er_mit_FG) })
o2 = Lane:new("O2", 105, {
    TrafficLight:new(16, TrafficLightModel.JS2_3er_mit_FG),
    TrafficLight:new(18, TrafficLightModel.JS2_3er_ohne_FG)
})
o1:setDirections({ 'STRAIGHT', 'RIGHT' })
o2:setDirections({ 'LEFT' })
fg_o = Lane:new("FG_O", 106, {
    TrafficLight:new(14, TrafficLightModel.JS2_3er_mit_FG), -- Wird geteilt mit O1
    TrafficLight:new(16, TrafficLightModel.JS2_3er_mit_FG) -- Wird geteilt mit O2
})
fg_o:setTrafficType('PEDESTRIAN')

-- Richtungen im Sueden
s1 = Lane:new("S1", 107, { TrafficLight:new(11, TrafficLightModel.JS2_3er_mit_FG) })
s2 = Lane:new("S2", 108, {
    TrafficLight:new(10, TrafficLightModel.JS2_3er_mit_FG),
    TrafficLight:new(19, TrafficLightModel.JS2_3er_ohne_FG)
})
s1:setDirections({ 'STRAIGHT', 'RIGHT' })
s2:setDirections({ 'LEFT' })

fg_s1 = Lane:new("FG_S1", 109, {
    TrafficLight:new(10, TrafficLightModel.JS2_3er_mit_FG), -- Wird geteilt mit S2
    TrafficLight:new(11, TrafficLightModel.JS2_3er_mit_FG) -- Wird geteilt mit S1
})
fg_s2 = Lane:new("FG_S2", 110, {
    TrafficLight:new(22, TrafficLightModel.JS2_2er_nur_FG),
    TrafficLight:new(23, TrafficLightModel.JS2_2er_nur_FG),
})
fg_s1:setTrafficType('PEDESTRIAN')
fg_s2:setTrafficType('PEDESTRIAN')


-- Richtungen im Westen
w1 = Lane:new("W1", 111, { TrafficLight:new(13, TrafficLightModel.JS2_3er_mit_FG) })
w2 = Lane:new("W2", 112, {
    TrafficLight:new(15, TrafficLightModel.JS2_3er_mit_FG),
    TrafficLight:new(24, TrafficLightModel.JS2_3er_ohne_FG)
})
w1:setDirections({ 'STRAIGHT', 'RIGHT' })
w2:setDirections({ 'LEFT' })
fg_w = Lane:new("FG_W", 113, {
    TrafficLight:new(13, TrafficLightModel.JS2_3er_mit_FG), -- Wird geteilt mit O1
    TrafficLight:new(15, TrafficLightModel.JS2_3er_mit_FG) -- Wird geteilt mit O2
})
fg_w:setTrafficType('PEDESTRIAN')


--------------------------------------------------------------
-- Definiere die Schaltungen und die Kreuzung
--------------------------------------------------------------
-- Eine Schaltung bestimmt, welche Richtungen gleichzeitig auf
-- grün geschaltet werden dürfen, alle anderen sind rot

--- Tutorial 1: Schaltung 1
local sch1 = CrossingSequence:new("Schaltung 1")
sch1:addLane(n1)
sch1:addLane(s1)
sch1:addPedestrianCrossing(fg_o)
sch1:addPedestrianCrossing(fg_w)

--- Tutorial 1: Schaltung 2
local sch2 = CrossingSequence:new("Schaltung 2")
sch2:addLane(n2)
sch2:addLane(s2)
sch2:addPedestrianCrossing(fg_n2)
sch2:addPedestrianCrossing(fg_o)
sch2:addPedestrianCrossing(fg_w)
sch2:addPedestrianCrossing(fg_s2)

--- Tutorial 1: Schaltung 3
local sch3 = CrossingSequence:new("Schaltung 3")
sch3:addLane(o1)
sch3:addLane(w1)
sch3:addPedestrianCrossing(fg_n1)
sch3:addPedestrianCrossing(fg_n2)
sch3:addPedestrianCrossing(fg_s1)
sch3:addPedestrianCrossing(fg_s2)

--- Tutorial 1: Schaltung 4
local sch4 = CrossingSequence:new("Schaltung 4")
sch4:addLane(o2)
sch4:addLane(w2)
sch4:addPedestrianCrossing(fg_n1)
sch4:addPedestrianCrossing(fg_s1)

-- --- Tutorial 1: Schaltung 5
-- local sch5 = CrossingSequence:new("Schaltung 5")
-- sch5:addLane(n1)
-- sch5:addLane(n2)
-- sch5:addPedestrianCrossing(fg_w)
--
-- --- Tutorial 1: Schaltung 6
-- local sch6 = CrossingSequence:new("Schaltung 6")
-- sch6:addLane(o1)
-- sch6:addLane(o2)
-- sch6:addPedestrianCrossing(fg_n1)
-- sch6:addPedestrianCrossing(fg_n2)
-- sch6:addPedestrianCrossing(fg_s1)
--
-- --- Tutorial 1: Schaltung 7
-- local sch7 = CrossingSequence:new("Schaltung 7")
-- sch7:addLane(s1)
-- sch7:addLane(s2)
-- sch7:addPedestrianCrossing(fg_o)
--
-- --- Tutorial 1: Schaltung 6
-- local sch8 = CrossingSequence:new("Schaltung 8")
-- sch8:addLane(o1)
-- sch8:addLane(o2)
-- sch8:addPedestrianCrossing(fg_n1)
-- sch8:addPedestrianCrossing(fg_s1)
-- sch8:addPedestrianCrossing(fg_s2)


k1 = Crossing:new("Tutorial 1")
k1:addSequence(sch1)
k1:addSequence(sch2)
k1:addSequence(sch3)
k1:addSequence(sch4)
-- k1:addSequence(sch5)
-- k1:addSequence(sch6)
-- k1:addSequence(sch7)
-- k1:addSequence(sch8)

local ModuleRegistry = require("ak.core.ModuleRegistry")
ModuleRegistry.registerModules(
    require("ak.core.CoreLuaModule"),
    require("ak.road.CrossingLuaModul")
)

function EEPMain()
    ModuleRegistry.runTasks()
    return 1
end
