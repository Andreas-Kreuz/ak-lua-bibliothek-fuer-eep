clearlog()
local AkPlaner = require("ak.planer.AkPlaner")
local AkAmpelModell = require("ak.strasse.AkAmpelModell")
local AkAmpel = require("ak.strasse.AkAmpel")
local AkRichtung = require("ak.strasse.AkRichtung")
local AkKreuzung = require("ak.strasse.AkKreuzung")
local AkKreuzungsSchaltung = require("ak.strasse.AkKreuzungsSchaltung")
local AkStatistik = require("ak.io.AkStatistik")

-- Hier kommt der Code
AkKreuzung.zeigeSignalIdsAllerSignale = false
AkKreuzung.zeigeSchaltungAlsInfo = false


-------------------------------------------------------------------------------
-- Definiere die Richtungen fuer die Kreuzung
-------------------------------------------------------------------------------

--   +---------------------------------------------- Neue Richtung
--   |              +------------------------------- Name der Richtung
--   |              |     +------------------------- Speicher ID - um die Anzahl der Fahrzeuge
--   |              |     |                                        und die Wartezeit zu speichern
--   |              |     |      +------------------ neue Ampel für diese Richtung
--   |              |     |      |           +------ Signal-ID dieser Ampel
--   |              |     |      |           |   +-- Modell kann rot, gelb, gruen und FG schalten
n1 = AkRichtung:neu("N1", 100, { AkAmpel:neu(12, AkAmpelModell.JS2_3er_mit_FG) })
n1:setRichtungen({ 'STRAIGHT', 'RIGHT' })

-- Die Richtung N2 hat zwei Ampeln fuer's Linksabbiegen, 9 mit Fussgaengerampel und 17 ohne
n2 = AkRichtung:neu("N2", 101, {
    AkAmpel:neu(9, AkAmpelModell.JS2_3er_mit_FG),
    AkAmpel:neu(17, AkAmpelModell.JS2_3er_ohne_FG)
})
n2:setRichtungen({ 'LEFT' })

-- Die Richtungen für Fussgaenger haben auch je zwei Ampeln
fg_n1 = AkRichtung:neu("FG_N1", 102, {
    AkAmpel:neu(9, AkAmpelModell.JS2_3er_mit_FG), -- Wird geteilt mit N2
    AkAmpel:neu(12, AkAmpelModell.JS2_3er_mit_FG) -- Wird geteilt mit N1
})
fg_n2 = AkRichtung:neu("FG_N2", 103, {
    AkAmpel:neu(20, AkAmpelModell.JS2_2er_nur_FG),
    AkAmpel:neu(21, AkAmpelModell.JS2_2er_nur_FG),
})
fg_n1:setTrafficType('PEDESTRIAN')
fg_n2:setTrafficType('PEDESTRIAN')

-- Richtungen im Osten
o1 = AkRichtung:neu("O1", 104, { AkAmpel:neu(14, AkAmpelModell.JS2_3er_mit_FG) })
o2 = AkRichtung:neu("O2", 105, {
    AkAmpel:neu(16, AkAmpelModell.JS2_3er_mit_FG),
    AkAmpel:neu(18, AkAmpelModell.JS2_3er_ohne_FG)
})
o1:setRichtungen({ 'STRAIGHT', 'RIGHT' })
o2:setRichtungen({ 'LEFT' })
fg_o = AkRichtung:neu("FG_O", 106, {
    AkAmpel:neu(14, AkAmpelModell.JS2_3er_mit_FG), -- Wird geteilt mit O1
    AkAmpel:neu(16, AkAmpelModell.JS2_3er_mit_FG) -- Wird geteilt mit O2
})
fg_o:setTrafficType('PEDESTRIAN')

-- Richtungen im Sueden
s1 = AkRichtung:neu("S1", 107, { AkAmpel:neu(11, AkAmpelModell.JS2_3er_mit_FG) })
s2 = AkRichtung:neu("S2", 108, {
    AkAmpel:neu(10, AkAmpelModell.JS2_3er_mit_FG),
    AkAmpel:neu(19, AkAmpelModell.JS2_3er_ohne_FG)
})
s1:setRichtungen({ 'STRAIGHT', 'RIGHT' })
s2:setRichtungen({ 'LEFT' })

fg_s1 = AkRichtung:neu("FG_S1", 109, {
    AkAmpel:neu(10, AkAmpelModell.JS2_3er_mit_FG), -- Wird geteilt mit S2
    AkAmpel:neu(11, AkAmpelModell.JS2_3er_mit_FG) -- Wird geteilt mit S1
})
fg_s2 = AkRichtung:neu("FG_S2", 110, {
    AkAmpel:neu(22, AkAmpelModell.JS2_2er_nur_FG),
    AkAmpel:neu(23, AkAmpelModell.JS2_2er_nur_FG),
})
fg_s1:setTrafficType('PEDESTRIAN')
fg_s2:setTrafficType('PEDESTRIAN')


-- Richtungen im Westen
w1 = AkRichtung:neu("W1", 111, { AkAmpel:neu(13, AkAmpelModell.JS2_3er_mit_FG) })
w2 = AkRichtung:neu("W2", 112, {
    AkAmpel:neu(15, AkAmpelModell.JS2_3er_mit_FG),
    AkAmpel:neu(24, AkAmpelModell.JS2_3er_ohne_FG)
})
w1:setRichtungen({ 'STRAIGHT', 'RIGHT' })
w2:setRichtungen({ 'LEFT' })
fg_w = AkRichtung:neu("FG_W", 113, {
    AkAmpel:neu(13, AkAmpelModell.JS2_3er_mit_FG), -- Wird geteilt mit O1
    AkAmpel:neu(15, AkAmpelModell.JS2_3er_mit_FG) -- Wird geteilt mit O2
})
fg_w:setTrafficType('PEDESTRIAN')


--------------------------------------------------------------
-- Definiere die Schaltungen und die Kreuzung
--------------------------------------------------------------
-- Eine Schaltung bestimmt, welche Richtungen gleichzeitig auf
-- grün geschaltet werden dürfen, alle anderen sind rot

--- Tutorial 1: Schaltung 1
local sch1 = AkKreuzungsSchaltung:neu("Schaltung 1")
sch1:fuegeRichtungHinzu(n1)
sch1:fuegeRichtungHinzu(s1)
sch1:fuegeRichtungFuerFussgaengerHinzu(fg_o)
sch1:fuegeRichtungFuerFussgaengerHinzu(fg_w)

--- Tutorial 1: Schaltung 2
local sch2 = AkKreuzungsSchaltung:neu("Schaltung 2")
sch2:fuegeRichtungHinzu(n2)
sch2:fuegeRichtungHinzu(s2)
sch2:fuegeRichtungFuerFussgaengerHinzu(fg_n2)
sch2:fuegeRichtungFuerFussgaengerHinzu(fg_o)
sch2:fuegeRichtungFuerFussgaengerHinzu(fg_w)
sch2:fuegeRichtungFuerFussgaengerHinzu(fg_s2)

--- Tutorial 1: Schaltung 3
local sch3 = AkKreuzungsSchaltung:neu("Schaltung 3")
sch3:fuegeRichtungHinzu(o1)
sch3:fuegeRichtungHinzu(w1)
sch3:fuegeRichtungFuerFussgaengerHinzu(fg_n1)
sch3:fuegeRichtungFuerFussgaengerHinzu(fg_n2)
sch3:fuegeRichtungFuerFussgaengerHinzu(fg_s1)
sch3:fuegeRichtungFuerFussgaengerHinzu(fg_s2)

--- Tutorial 1: Schaltung 4
local sch4 = AkKreuzungsSchaltung:neu("Schaltung 4")
sch4:fuegeRichtungHinzu(o2)
sch4:fuegeRichtungHinzu(w2)
sch4:fuegeRichtungFuerFussgaengerHinzu(fg_n1)
sch4:fuegeRichtungFuerFussgaengerHinzu(fg_s1)

-- --- Tutorial 1: Schaltung 5
-- local sch5 = AkKreuzungsSchaltung:neu("Schaltung 5")
-- sch5:fuegeRichtungHinzu(n1)
-- sch5:fuegeRichtungHinzu(n2)
-- sch5:fuegeRichtungFuerFussgaengerHinzu(fg_w)
--
-- --- Tutorial 1: Schaltung 6
-- local sch6 = AkKreuzungsSchaltung:neu("Schaltung 6")
-- sch6:fuegeRichtungHinzu(o1)
-- sch6:fuegeRichtungHinzu(o2)
-- sch6:fuegeRichtungFuerFussgaengerHinzu(fg_n1)
-- sch6:fuegeRichtungFuerFussgaengerHinzu(fg_n2)
-- sch6:fuegeRichtungFuerFussgaengerHinzu(fg_s1)
--
-- --- Tutorial 1: Schaltung 7
-- local sch7 = AkKreuzungsSchaltung:neu("Schaltung 7")
-- sch7:fuegeRichtungHinzu(s1)
-- sch7:fuegeRichtungHinzu(s2)
-- sch7:fuegeRichtungFuerFussgaengerHinzu(fg_o)
--
-- --- Tutorial 1: Schaltung 6
-- local sch8 = AkKreuzungsSchaltung:neu("Schaltung 8")
-- sch8:fuegeRichtungHinzu(o1)
-- sch8:fuegeRichtungHinzu(o2)
-- sch8:fuegeRichtungFuerFussgaengerHinzu(fg_n1)
-- sch8:fuegeRichtungFuerFussgaengerHinzu(fg_s1)
-- sch8:fuegeRichtungFuerFussgaengerHinzu(fg_s2)


k1 = AkKreuzung:neu("Tutorial 1")
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
    require("ak.strasse.KreuzungLuaModul")
)

function EEPMain()
    ModuleRegistry.runTasks()
    return 1
end
