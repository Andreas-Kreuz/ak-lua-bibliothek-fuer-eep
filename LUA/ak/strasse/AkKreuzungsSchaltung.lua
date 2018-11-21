print("Lade ak.strasse.AkKreuzungsSchaltung ...")

local AkRichtung = require("ak.strasse.AkRichtung")

------------------------------------------------------
-- Klasse Richtungsschaltung (schaltet mehrere Ampeln)
------------------------------------------------------
local AkKreuzungsSchaltung = {}

function AkKreuzungsSchaltung.getTyp()
    return "AkKreuzungsSchaltung"
end

function AkKreuzungsSchaltung:getName()
    return self.name
end

function AkKreuzungsSchaltung:neu(name)
    local o = {}
    setmetatable(o, self)
    self.__index = self;
    o.name = name
    o.richtungenNormal = {}
    o.richtungenMitAnforderung = {}
    o.richtungenFuerFussgaenger = {}
    return o
end

function AkKreuzungsSchaltung:getAlleRichtungen()
    local alle = {}
    for richtung in pairs(self.richtungenNormal) do
        alle[richtung] = "NORMAL"
    end
    for richtung in pairs(self.richtungenMitAnforderung) do
        alle[richtung] = "REQUEST"
    end
    for richtung in pairs(self.richtungenFuerFussgaenger) do
        alle[richtung] = "PEDESTRIANTS"
    end
    return alle
end

function AkKreuzungsSchaltung:getNormaleRichtungen()
    return self.richtungenNormal
end

function AkKreuzungsSchaltung:richtungenAlsTextZeile()
    local s = ""
    for richtung in pairs(self.richtungenNormal) do
        s = s .. ", " .. richtung.name
    end
    for richtung in pairs(self.richtungenMitAnforderung) do
        s = s .. ", " .. richtung.name
    end
    s = s:sub(3)
    return s
end

function AkKreuzungsSchaltung:getRichtungenMitAnforderung()
    return self.richtungenMitAnforderung
end


function AkKreuzungsSchaltung:fuegeRichtungHinzu(richtung)
    assert(richtung, "Bitte ein gueltige Richtung angeben")
    richtung:setSchaltungsTyp(AkRichtung.SchaltungsTyp.NORMAL)
    self.richtungenNormal[richtung] = true
end

function AkKreuzungsSchaltung:addRichtungMitAnforderung(richtung)
    assert(richtung, "Bitte ein gueltige Richtung angeben")
    richtung:setSchaltungsTyp(AkRichtung.SchaltungsTyp.ANFORDERUNG)
    self.richtungenMitAnforderung[richtung] = true
end

function AkKreuzungsSchaltung:fuegeRichtungFuerFussgaengerHinzu(richtung)
    assert(richtung, "Bitte ein gueltige Richtung angeben")
    richtung:setSchaltungsTyp(AkRichtung.SchaltungsTyp.FUSSGAENGER)
    self.richtungenFuerFussgaenger[richtung] = true
end

function AkKreuzungsSchaltung:getRichtungFuerFussgaenger()
    return self.richtungenFuerFussgaenger
end

--- Gibt alle Richtungen nach Prioritaet zurueck, sowie deren Anzahl und deren Durchschnittspriorität
-- @return sortierteRichtungen, anzahlDerRichtungen, durchschnittsPrio
function AkKreuzungsSchaltung:nachPrioSortierteRichtungen()
    local sortierteRichtungen = {}
    local anzahlDerRichtungen = 0
    local gesamtPrio = 0
    for richtung in pairs(self.richtungenNormal) do
        table.insert(sortierteRichtungen, richtung)
        anzahlDerRichtungen = anzahlDerRichtungen + 1
        gesamtPrio = gesamtPrio + richtung:getPrio()
    end
    for richtung in pairs(self.richtungenFuerFussgaenger) do
        table.insert(sortierteRichtungen, richtung)
        anzahlDerRichtungen = anzahlDerRichtungen + 1
        gesamtPrio = gesamtPrio + richtung:getPrio()
    end
    local durchschnittsPrio = gesamtPrio / anzahlDerRichtungen
    local sortierFunktion = function(richtung1, richtung2)
        if richtung1:getPrio() > richtung2:getPrio() then return true
        elseif richtung1:getPrio() < richtung2:getPrio() then return false
        end
        return (richtung1.name < richtung2.name)
    end
    table.sort(sortierteRichtungen, sortierFunktion)
    return sortierteRichtungen, anzahlDerRichtungen, durchschnittsPrio
end

------ Gibt alle Richtungen nach Name sortiert zurueck
-- @return sortierteRichtungen
function AkKreuzungsSchaltung:nachNameSortierteRichtungen()
    local sortierteRichtungen = {}
    for richtung in pairs(self.richtungenNormal) do
        table.insert(sortierteRichtungen, richtung)
    end
    for richtung in pairs(self.richtungenMitAnforderung) do
        table.insert(sortierteRichtungen, richtung)
    end
    for richtung in pairs(self.richtungenFuerFussgaenger) do
        table.insert(sortierteRichtungen, richtung)
    end
    local sortierFunktion = function(richtung1, richtung2)
        return (richtung1.name < richtung2.name)
    end
    table.sort(sortierteRichtungen, sortierFunktion)
    return sortierteRichtungen
end

--- Gibt zurueck ob schaltung1 eine hoehere Prioritaet hat, als Schaltung 2
-- @param schaltung1 erste Schaltung
-- @param schaltung2 zweite Schaltung
--
function AkKreuzungsSchaltung.hoeherePrioAls(schaltung1, schaltung2)
    if schaltung1 and schaltung2 then
        local _, tableSize1, avg1 = schaltung1:nachPrioSortierteRichtungen()
        local _, tableSize2, avg2 = schaltung2:nachPrioSortierteRichtungen()

        if avg1 > avg2 then return true
        elseif avg1 < avg2 then return false
        end

        if tableSize1 > tableSize2 then return true
        elseif tableSize1 < tableSize2 then return false
        end

        return (schaltung1.name > schaltung2.name)
    end
end

function AkKreuzungsSchaltung:getPrio()
    local _, _, prio = self:nachPrioSortierteRichtungen()
    return prio
end

function AkKreuzungsSchaltung:setzeWartezeitZurueck()
    for richtung in pairs(self.richtungenNormal) do
        richtung:setzeWartezeitZurueck()
    end
end


return AkKreuzungsSchaltung

