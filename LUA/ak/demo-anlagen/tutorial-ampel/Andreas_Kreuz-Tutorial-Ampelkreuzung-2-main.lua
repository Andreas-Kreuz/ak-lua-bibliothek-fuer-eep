clearlog()
require("ak.strasse.AkStrasse")



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
n = AkRichtung:neu("N", 100, {
    AkAmpel:neu(07, AkAmpelModell.JS2_3er_mit_FG),
    AkAmpel:neu(08, AkAmpelModell.JS2_3er_mit_FG)
})

fg_n = AkRichtung:neu("FG_n", 101, {
    AkAmpel:neu(07, AkAmpelModell.JS2_3er_mit_FG), -- Wird geteilt mit N
    AkAmpel:neu(08, AkAmpelModell.JS2_3er_mit_FG) -- Wird geteilt mit N
})

-- Die Richtung O1 hat zwei Ampeln fuer geradeaus: 9 und 10 jeweils mit Fussgaengern
o1 = AkRichtung:neu("O1", 102, {
    AkAmpel:neu(09, AkAmpelModell.JS2_3er_mit_FG),
    AkAmpel:neu(10, AkAmpelModell.JS2_3er_mit_FG)
})

fg_o = AkRichtung:neu("FG_O", 103, {
    AkAmpel:neu(09, AkAmpelModell.JS2_3er_mit_FG), -- Wird geteilt mit O1
    AkAmpel:neu(10, AkAmpelModell.JS2_3er_mit_FG) -- Wird geteilt mit O1
})


-- Richtungen im Westen
w1 = AkRichtung:neu("W1", 104, { AkAmpel:neu(12, AkAmpelModell.JS2_3er_mit_FG) })
w2 = AkRichtung:neu("W2", 105, {
    AkAmpel:neu(11, AkAmpelModell.JS2_3er_mit_FG),
    AkAmpel:neu(13, AkAmpelModell.JS2_3er_ohne_FG)
})
fg_w = AkRichtung:neu("FG_W", 106, {
    AkAmpel:neu(11, AkAmpelModell.JS2_3er_mit_FG), -- Wird geteilt mit W1
    AkAmpel:neu(12, AkAmpelModell.JS2_3er_mit_FG) -- Wird geteilt mit W2
})

-- Richtungen fuer Strassenbahnen:
os = AkRichtung:neu("OS", 107, {
    AkAmpel:neu(14, AkAmpelModell.Unsichtbar_2er,
        "#29_Straba Signal Halt", --       rot   schaltet das Licht dieser Immobilie ein
        "#28_Straba Signal geradeaus", --  gruen schaltet das Licht dieser Immobilie ein
        "#27_Straba Signal anhalten", --   gelb  schaltet das Licht dieser Immobilie ein
        "#26_Straba Signal A") --    Anforderung schaltet das Licht dieser Immobilie ein
}):zaehleAnSignalAlle(14) -- Erfasst Anforderungen, wenn ein Fahrzeug am Signal steht

ws = AkRichtung:neu("WS", 108, {
    AkAmpel:neu(15, AkAmpelModell.Unsichtbar_2er,
        "#32_Straba Signal Halt", --       rot   schaltet das Licht dieser Immobilie ein
        "#30_Straba Signal geradeaus", --  gruen schaltet das Licht dieser Immobilie ein
        "#31_Straba Signal anhalten", --   gelb  schaltet das Licht dieser Immobilie ein
        "#33_Straba Signal A") --    Anforderung schaltet das Licht dieser Immobilie ein
}):zaehleAnSignalAlle(15) -- Erfasst Anforderungen, wenn ein Fahrzeug am Signal steht


--------------------------------------------------------------
-- Definiere die Schaltungen und die Kreuzung
--------------------------------------------------------------
-- Eine Schaltung bestimmt, welche Richtungen gleichzeitig auf
-- grün geschaltet werden dürfen, alle anderen sind rot

--- Tutorial 2: Schaltung 1
local sch1 = AkKreuzungsSchaltung:neu("Schaltung 1")
sch1:fuegeRichtungHinzu(o1)
sch1:fuegeRichtungHinzu(os)
sch1:fuegeRichtungHinzu(w1)
sch1:fuegeRichtungHinzu(ws)
sch1:fuegeRichtungFuerFussgaengerHinzu(fg_n)

--- Tutorial 2: Schaltung 2
local sch2 = AkKreuzungsSchaltung:neu("Schaltung 2")
sch2:fuegeRichtungHinzu(w2)
sch2:fuegeRichtungFuerFussgaengerHinzu(fg_o)

--- Tutorial 2: Schaltung 3
local sch3 = AkKreuzungsSchaltung:neu("Schaltung 3")
sch3:fuegeRichtungHinzu(n)
sch3:fuegeRichtungFuerFussgaengerHinzu(fg_o)
sch3:fuegeRichtungFuerFussgaengerHinzu(fg_w)

k1 = AkKreuzung:neu("Tutorial 2")
k1:fuegeSchaltungHinzu(sch1)
k1:fuegeSchaltungHinzu(sch2)
k1:fuegeSchaltungHinzu(sch3)


function EEPMain()
    AkKreuzung:planeSchaltungenEin()
    AkPlaner:fuehreGeplanteAktionenAus()
    return 1
end
