print("Lade ak.strasse.AkAmpelModell ...")

local AkPhase = require("ak.strasse.AkPhase")
------------------------------------------------------------------------------------------
-- Klasse AkAmpelModell
-- Weiss, welche Signalstellung fuer rot, gelb und gruen geschaltet werden muessen.
------------------------------------------------------------------------------------------
local AkAmpelModell = {}
AkAmpelModell.alleAmpelModelle = {}

---
-- @param name Name des Ampeltyps
-- @param sigIndexRot Index der Signalstellung des roten Signals
-- @param sigIndexGruen Index der Signalstellung des gruenen Signals
-- @param sigIndexGelb Index der Signalstellung des gelben Signals
-- @param sigIndexRotGelb Index der Signalstellung des rot-gelben Signal (oder rot)
-- @param sigIndexFgGruen Index der Signalstellung in der die Fussgaenger gruen haben und die Autos rot
-- @param sigIndexKomplettAus Index der Signalstellung in der die Ampel komplett aus ist
-- @param sigIndexGelbBlinkenAus Index der Signalstellung in der die Ampel gelb blinkt ohne den Verkehr zu beeinflussen
--
function AkAmpelModell:neu(
    name,
    sigIndexRot,
    sigIndexGruen,
    sigIndexGelb,
    sigIndexRotGelb,
    sigIndexFgGruen,
    sigIndexKomplettAus,
    sigIndexGelbBlinkenAus)
    assert(name)
    assert(sigIndexRot)
    assert(sigIndexGruen)
    local o = {
        name = name,
        sigIndexRot = sigIndexRot,
        sigIndexGruen = sigIndexGruen,
        sigIndexGelb = sigIndexGelb or sigIndexRot,
        sigIndexRotGelb = sigIndexRotGelb or sigIndexRot,
        sigIndexFgGruen = sigIndexFgGruen,
        sigIndexKomplettAus = sigIndexKomplettAus,
        sigIndexGelbBlinkenAus = sigIndexGelbBlinkenAus
    }
    self.__index = self
    local x = setmetatable(o, self)
    table.insert(AkAmpelModell.alleAmpelModelle, o)
    return x
end

function AkAmpelModell:print()
    print(self.name)
end

function AkAmpelModell:signalIndexFuer(phase)
    assert(phase)
    if phase == AkPhase.GELB then
        return self.sigIndexGelb
    elseif phase == AkPhase.ROT then
        return self.sigIndexRot
    elseif phase == AkPhase.ROTGELB then
        return self.sigIndexRotGelb
    elseif phase == AkPhase.GRUEN then
        return self.sigIndexGruen
    elseif phase == AkPhase.FG then
        return self.sigIndexFgGruen
    end
end

---------------------
-- Ampeln und Signale
---------------------

-- Fuer die Strassenbahnsignale von MA1 - http://www.eep.euma.de/downloads/V80MA1F003.zip
-- 4er Signal, Stellung 2 als grün, z.B. Strab_Sig_09_LG auf gerade schalten
-- 4er Signal, Stellung 3 als grün, z.B. Strab_Sig_09_LG auf links schalten
-- 3er Signal, Stellung 3 als grün, z.B. Ak_Strab_Sig_05_gerade oder
--                                       Ak_Strab_Sig_05_gerade schalten
AkAmpelModell.MA1_STRAB_4er_2_gruen = AkAmpelModell:neu("MA1_STRAB_4er_2_gruen", 1, 2, 4, 4)
AkAmpelModell.MA1_STRAB_4er_3_gruen = AkAmpelModell:neu("MA1_STRAB_4er_3_gruen", 1, 3, 4, 4)
AkAmpelModell.MA1_STRAB_3er_2_gruen = AkAmpelModell:neu("MA1_STRAB_3er_2_gruen", 1, 2, 3, 3)

-- Fuer die Ampeln von NP1 - http://eepshopping.de - Ampelset 1 und Ampelset 2
AkAmpelModell.NP1_3er_mit_FG = AkAmpelModell:neu("Ampel_NP1_mit_FG", 2, 4, 5, 3, 1)
AkAmpelModell.NP1_3er_ohne_FG = AkAmpelModell:neu("Ampel_NP1_ohne_FG", 1, 3, 4, 2)

-- Fuer die Ampeln von JS2 - http://eepshopping.de - Ampel-Baukasten (V80NJS20039)
-- Diese Signale sind teilweise mit und ohne Fussgaenger
AkAmpelModell.JS2_2er_nur_FG = AkAmpelModell:neu("Ak_Ampel_2er_nur_FG", 1, 1, 1, 1, 2, 3, 3)
AkAmpelModell.JS2_3er_mit_FG = AkAmpelModell:neu("Ampel_3er_XXX_mit_FG", 1, 3, 5, 2, 6, 7, 8)
AkAmpelModell.JS2_3er_ohne_FG = AkAmpelModell:neu("Ampel_3er_XXX_ohne_FG", 1, 3, 5, 2, 1, 6, 7)

-- Unsichtbare Ampeln haben "nur" rot und gruen
AkAmpelModell.Unsichtbar_2er = AkAmpelModell:neu("Unsichtbares Signal", 2, 1, 2, 2, 2, 1, 1)

return AkAmpelModell
