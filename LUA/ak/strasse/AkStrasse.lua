print("Lade AkPlaner ...")
require 'ak.planer.AkPlaner'
print("Lade AkSpeicherHilfe ...")
require 'ak.speicher.AkSpeicher'

--region AkPhase + AkSchaltung
AkPhase = {}
AkPhase.ROT = "Rot"
AkPhase.ROTGELB = "Rot-Gelb"
AkPhase.GELB = "Gelb"
AkPhase.GRUEN = "Gruen"
AkPhase.FG = "Fussg"


local function AkSchalteAmpeln(ampeln, phase, grund)
    assert(phase == AkPhase.GRUEN
            or phase == AkPhase.ROTGELB
            or phase == AkPhase.GELB
            or phase == AkPhase.ROT
            or phase == AkPhase.FG)

    for richtung in pairs(ampeln) do
        richtung:schalte(phase, grund)
    end
end

--endregion
--region AkAmpelModell
------------------------------------------------------------------------------------------
-- Klasse AkAmpelModell
-- Weiss, welche Signalstellung fuer rot, gelb und gruen geschaltet werden muessen.
------------------------------------------------------------------------------------------
AkAmpelModell = {}

---
-- @param name Name des Ampeltyps
-- @param sigIndexRot Index der Signalstellung des roten Signals
-- @param sigIndexGruen Index der Signalstellung des gruenen Signals
-- @param sigIndexGelb Index der Signalstellung des gelben Signals
-- @param sigIndexRotGelb Index der Signalstellung des rot-gelben Signal (oder rot)
-- @param sigIndexFgGruen Indes der Signalstellung in der die Fussgaenger gruen haben und die Autos rot
--
function AkAmpelModell:neu(name, sigIndexRot, sigIndexGruen, sigIndexGelb, sigIndexRotGelb, sigIndexFgGruen)
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
    }
    self.__index = self
    return setmetatable(o, self)
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
Ak_Strab_Sig_09_LG_gerade = AkAmpelModell:neu("Strab_Sig_LG --> gerade", 1, 2, 4, 4)
Ak_Strab_Sig_09_LG_links = AkAmpelModell:neu("Strab_Sig_LG --> links", 1, 3, 4, 4)
Ak_Strab_Sig_06_R = AkAmpelModell:neu("Strab_Sig_R", 1, 2, 3, 3)
Ak_Strab_Sig_05_gerade = AkAmpelModell:neu("Strab_Sig_R", 1, 2, 3, 3)
Ak_Ampel_NP1_mit_FG = AkAmpelModell:neu("Ampel_NP1_mit_FG", 2, 4, 5, 3, 1)
Ak_Ampel_NP1_ohne_FG = AkAmpelModell:neu("Ampel_NP1_ohne_FG", 1, 3, 4, 2)
Ak_Ampel_2er_FG = AkAmpelModell:neu("Ak_Ampel_2er_nur_FG", 1, 1, 1, 1, 2)
Ak_Ampel_3er_XXX = AkAmpelModell:neu("Ampel_3er_XXX_ohne_FG", 1, 3, 5, 2)
Ak_Ampel_3er_XXX_FG = AkAmpelModell:neu("Ampel_3er_XXX_mit_FG", 1, 3, 5, 2, 6)
Ak_Ampel_Unsichtbar = AkAmpelModell:neu("Unsichtbares Signal", 2, 1, 2, 2)
--endregion
--region AkStrabWeiche
AkStrabWeiche = {}
--- Registriert eine neue Strassenbahnweiche und schaltet das Licht der angegeben Immobilien anhand der Weichenstellung
-- @param weiche_id ID der Weiche
-- @param immo1 Immobilie, deren Licht bei Weichenstellung 1 leuchten soll
-- @param immo2 Immobilie, deren Licht bei Weichenstellung 2 leuchten soll
-- @param immo3 Immobilie, deren Licht bei Weichenstellung 3 leuchten soll
--
function AkStrabWeiche.new(weiche_id, immo1, immo2, immo3)
    EEPRegisterSwitch(weiche_id)
    _G["EEPOnSwitch_" .. weiche_id] = function(x)
        local stellung = EEPGetSwitch(weiche_id)
        if immo1 then EEPStructureSetLight(immo1, stellung == 1) end
        if immo2 then EEPStructureSetLight(immo2, stellung == 2) end
        if immo3 then EEPStructureSetLight(immo3, stellung == 3) end
    end
    _G["EEPOnSwitch_" .. weiche_id]()
end

--endregion
--region AkAmpel
------------------------------------------------------------------------------------------
-- Klasse AkAmpel
-- Ampel mit einer festen signalId und einem festen Ampeltyp
-- Optional kann die Ampel bei Immobilien Licht ein- und ausschalten (Straba - Ampelsatz)
------------------------------------------------------------------------------------------
AkAmpel = {}
AkAmpel.debug = AkStartMitDebug or false
---
-- @param signalId ID der Ampel auf der Anlage (Eine Ampel von diesem Typ sollte auf der Anlage sein
-- @param ampelTyp Typ der Ampel (AkAmpelModell)
-- @param rotImmo Immobilie fuer Signalbild gelb (Licht an / aus)
-- @param gruenImmo Immobilie fuer Signalbild gelb (Licht an / aus)
-- @param gelbImmo Immobilie fuer Signalbild gelb (Licht an / aus)
-- @param anforderungImmo Immobilie fuer Signalbild "A" (Licht an / aus)
--
function AkAmpel:neu(signalId, ampelTyp, rotImmo, gruenImmo, gelbImmo, anforderungImmo)
    assert(signalId)
    assert(ampelTyp)
    EEPShowInfoSignal(signalId, false)
    local o = {
        signalId = signalId,
        ampelTyp = ampelTyp,
        rotImmo = rotImmo,
        gruenImmo = gruenImmo,
        gelbImmo = gelbImmo or rotImmo,
        anforderungImmo = anforderungImmo,
        phase = AkPhase.ROT,
        anforderung = false,
        debug = false,
    }
    self.__index = self
    return setmetatable(o, self)
end

---
-- @param signalId ID der Ampel auf der Anlage (Eine Ampel von diesem Typ sollte auf der Anlage sein)
-- @param phase AkPhase.xxx
-- @param grund z.B. Name der Schaltung
--
function AkAmpel:schalte(phase, grund)
    assert(phase)
    self.phase = phase
    local immoDbg = ""
    if self.rotImmo then
        immoDbg = immoDbg .. string.format(", Licht in %s: %s", self.rotImmo,
            (phase == AkPhase.ROT or phase == AkPhase.ROTGELB) and "an" or "aus")
        EEPStructureSetLight(self.rotImmo, phase == AkPhase.ROT or phase == AkPhase.ROTGELB)
    end
    if self.gelbImmo then
        immoDbg = immoDbg .. string.format(", Licht in %s: %s", self.gelbImmo,
            (phase == AkPhase.GELB or phase == AkPhase.ROTGELB) and "an" or "aus")
        EEPStructureSetLight(self.gelbImmo, phase == AkPhase.GELB or phase == AkPhase.ROTGELB)
    end
    if self.gruenImmo then
        immoDbg = immoDbg .. string.format(", Licht in %s: %s", self.gruenImmo,
            (phase == AkPhase.GRUEN) and "an" or "aus")
        EEPStructureSetLight(self.gruenImmo, phase == AkPhase.GRUEN)
    end

    local sigIndex = self.ampelTyp:signalIndexFuer(phase)
    if (self.debug or AkAmpel.debug) then print(string.format("[AkAmpel    ] Schalte Ampel %04d auf %s (%01d)", self.signalId, phase, sigIndex) .. immoDbg) end
    EEPSetSignal(self.signalId, sigIndex)
    EEPShowInfoSignal(self.signalId, (AkKreuzung.showAnforderungenAlsInfo and self.anforderung) or (AkKreuzung.showSchaltungAlsInfo and self.phase ~= AkPhase.ROT))
    if (AkKreuzung.showSchaltungAlsInfo and self.phase ~= AkPhase.ROT) then
        EEPChangeInfoSignal(self.signalId, phase .. " (" .. grund .. ")")
    end
end

function AkAmpel:setzeAnforderung(anforderung, richtung, anzahl)
    local immoDbg = ""
    self.anforderung = anforderung
    if self.anforderungImmo then
        immoDbg = immoDbg .. string.format(", Licht in %s: %s", self.anforderungImmo, (anforderung) and "an" or "aus")
        EEPStructureSetLight(self.anforderungImmo, anforderung)
    end
    if (self.debug or AkAmpel.debug) and immoDbg ~= "" then print(string.format("[AkAmpel    ] Schalte Ampel %04d", self.signalId) .. immoDbg) end
    EEPShowInfoSignal(self.signalId, (AkKreuzung.showAnforderungenAlsInfo and self.anforderung) or (AkKreuzung.showSchaltungAlsInfo and self.phase ~= AkPhase.ROT))
    if (AkKreuzung.showAnforderungenAlsInfo and self.anforderung) then
        EEPChangeInfoSignal(self.signalId, richtung.name .. " - Anzahl FZ: " .. tostring(anzahl) .. " (Warte: " .. tostring(richtung.warteZeit) .. ")")
    end
end

function AkAmpel:print()
    print(string.format("[AkAmpel    ] Ampel %04d: %s (%s)", self.signalId, self.phase, self.ampelTyp.name))
end

--endregion
--region AkKreuzungsSchaltung
------------------------------------------------------
-- Klasse Richtungsschaltung (schaltet mehrere Ampeln)
------------------------------------------------------
AkKreuzungsSchaltung = {}

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
    o.richtungen = {}
    o.richtungenMitAnforderung = {}
    o.richtungenFuerFussgaenger = {}
    return o
end

function AkKreuzungsSchaltung:getRichtungen()
    return self.richtungen
end

function AkKreuzungsSchaltung:richtungenAlsTextZeile()
    local s = ""
    for richtung in pairs(self.richtungen) do
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
    self.richtungen[richtung] = true
end

function AkKreuzungsSchaltung:addRichtungMitAnforderung(richtung)
    self.richtungenMitAnforderung[richtung] = true
end

function AkKreuzungsSchaltung:fuegeRichtungFuerFussgaengerHinzu(richtung)
    self.richtungenFuerFussgaenger[richtung] = true
end

--- Gibt alle Richtungen nach Prioritaet zurueck, sowie deren Anzahl und deren Durchschnittspriorität
-- @return sortierteRichtungen, anzahlDerRichtungen, durchschnittsPrio
function AkKreuzungsSchaltung:nachPrioSortierteRichtungen()
    local sortierteRichtungen = {}
    local anzahlDerRichtungen = 0
    local gesamtPrio = 0
    for richtung in pairs(self.richtungen) do
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

--- Gibt zurueck ob schaltung1 eine hoehere Prioritaet hat, als Schaltung 2
-- @param schaltung1 erste Schaltung
-- @param schaltung2 zweite Schaltung
--
function AkKreuzungsSchaltung.hoeherePrioAls(schaltung1, schaltung2)
    if schaltung1 and schaltung2 then
        local sortedRichtungen1, tableSize1, avg1 = schaltung1:nachPrioSortierteRichtungen()
        local sortedRichtungen2, tableSize2, avg2 = schaltung2:nachPrioSortierteRichtungen()

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
    local _, __, prio = self:nachPrioSortierteRichtungen()
    return prio
end

function AkKreuzungsSchaltung:setzeWartezeitZurueck()
    for richtung in pairs(self.richtungen) do
        richtung:setzeWartezeitZurueck()
    end
end

--endregion
--region AkRichtung
--------------------
-- Klasse Richtung
--------------------
AkRichtung = {}

function AkRichtung.getTyp()
    return "AkRichtung"
end

function AkRichtung:getName()
    return self.name
end

function AkRichtung:aktualisiereAnforderung()
    for _, ampel in pairs(self.ampeln) do
        ampel:setzeAnforderung(self.fahrzeuge > 0, self, self.fahrzeuge)
    end
end

function AkRichtung:betritt()
    self.fahrzeuge = self.fahrzeuge + 1
    self:aktualisiereAnforderung()
    self:save()
end

function AkRichtung:verlasse(signalaufrot, fahrzeugName)
    self.fahrzeuge = self.fahrzeuge - 1
    if self.fahrzeuge < 0 then
        self.fahrzeuge = 0
    end
    self:aktualisiereAnforderung()
    self:save()

    if signalaufrot and not self:anforderungVorhanden() then
        local richtungen = {}
        richtungen[self] = true

        AkSchalteAmpeln(richtungen, AkPhase.GELB, "Fahrzeug verlassen: " .. fahrzeugName)

        local toRed = AkAktion:neu(function()
            AkSchalteAmpeln(richtungen, AkPhase.ROT, "Fahrzeug verlassen: " .. fahrzeugName)
        end, "Schalte " .. self.name .. " auf rot.")
        AkPlaner:planeAktion(2, toRed)
    end
end

function AkRichtung:setzeFahrzeugeZurueck()
    self.fahrzeuge = 0
    self:aktualisiereAnforderung()
    self:save()
end

function AkRichtung:erhoeheWartezeit()
    self.warteZeit = self.warteZeit + 1
    self:save()
end

function AkRichtung:setzeWartezeitZurueck()
    self.warteZeit = 0
    self:save()
end

function AkRichtung:anforderungVorhanden()
    return self.fahrzeuge > 0
end

function AkRichtung:save()
    if self.eepSaveId ~= -1 then
        local data = {}
        data["f"] = tostring(self.fahrzeuge)
        data["w"] = tostring(self.warteZeit)
        data["p"] = tostring(self.phase)
        AkSpeicherHilfe.speichereTabelle(self.eepSaveId, data, "AkRichtung " .. self.name)
    end
end

function AkRichtung:load()
    if self.eepSaveId ~= -1 then
        local data = AkSpeicherHilfe.ladeTabelle(self.eepSaveId, "AkRichtung " .. self.name)
        self.fahrzeuge = data["f"] and tonumber(data["f"]) or 0
        self.warteZeit = data["w"] and tonumber(data["w"]) or 0
        self.phase = data["p"] or AkPhase.ROT
        for _, ampel in pairs(self.ampeln) do
            ampel:setzeAnforderung(self.fahrzeuge > 0, self, self.fahrzeuge)
        end
        self:schalte(self.phase, "Neu geladen")
    else
        self.fahrzeuge = 0
        self.warteZeit = 0
        self.phase = AkPhase.ROT
    end
end


function AkRichtung:getWarteZeit()
    return self.warteZeit
end

function AkRichtung:getFahrzeuge()
    return self.fahrzeuge
end

function AkRichtung:getRichtungSaveId()
    return self.richtungSaveId
end

function AkRichtung:getRichtungsInfo()
    return self.richtungsInfo
end

function AkRichtung:getPrio()
    local prio = self.fahrzeuge * 3 * self.fahrzeugMultiplikator
    return self.warteZeit > prio and self.warteZeit or prio
end

function AkRichtung:setFahrzeugMultiplikator(fahrzeugMultiplikator)
    self.fahrzeugMultiplikator = fahrzeugMultiplikator
    return self
end

function AkRichtung:schalte(phase, grund)
    for _, ampel in pairs(self.ampeln) do
        ampel:schalte(phase, grund)
    end
    self.phase = phase
end

--- Erzeugt eine Richtung, welche durch eine Ampel gesteuert wird.
-- @param name Name der Richtung einer Kreuzung
-- @param eepSaveId Id fuer das Speichern der Richtung
-- @param ... eine oder mehrere Ampeln
--
function AkRichtung:neu(name, eepSaveId, ...)
    assert(name, "Bitte geben Sie den Namen \"name\" fuer diese Richtung an.")
    assert(type(name) == "string")
    assert(eepSaveId, "Bitte geben Sie den Wert \"eepSaveId\" fuer diese Richtung an.")
    assert(type(eepSaveId) == "number")
    assert(..., "Bitte geben Sie den Wert \"ampeln\" fuer diese Richtung an.")
    --assert(signalId, "Bitte geben Sie den Wert \"signalId\" fuer diese Richtung an.")

    if eepSaveId ~= -1 then AkSpeicherHilfe.registriereId(eepSaveId, name) end
    local o = {
        fahrzeugMultiplikator = 1,
        name = name,
        eepSaveId = eepSaveId,
        ampeln = ...,
    }
    self.__index = self
    setmetatable(o, self)
    o:load()
    return o
end

--endregion
--region AkKreuzung
local AkAllKreuzungen = {}

--------------------
-- Klasse Kreuzung
--------------------
AkKreuzung = {}
AkKreuzung.debug = AkStartMitDebug or false
AkKreuzung.showAnforderungenAlsInfo = AkStartMitDebug or false
AkKreuzung.showSchaltungAlsInfo = AkStartMitDebug or false

function AkKreuzung.getTyp()
    return "AkKreuzung"
end

function AkKreuzung:getName()
    return self.name
end

function AkKreuzung:getSchaltungen()
    return self.schaltungen
end

function AkKreuzung:getAktuelleSchaltung()
    return self.aktuelleSchaltung
end

function AkKreuzung:setzeWarteZeitZurueck(nextSchaltung)
    local increaseRichtungen = {}
    for schaltung in pairs(self.schaltungen) do
        assert(schaltung.getTyp() == "AkKreuzungsSchaltung", "Found: " .. schaltung.getTyp())
        for richtung in pairs(schaltung:getRichtungen()) do
            assert(richtung.getTyp() == "AkRichtung", "Found: " .. richtung.getTyp())
            if nextSchaltung:getRichtungen()[richtung] then
                richtung:setzeWartezeitZurueck()
            else
                increaseRichtungen[richtung] = true
            end
        end
    end

    for richtung in pairs(increaseRichtungen) do
        assert(richtung.getTyp() == "AkRichtung", "Found: " .. richtung.getTyp())
        richtung:erhoeheWartezeit()
    end
    self.aktuelleSchaltung = nextSchaltung
end

function AkKreuzung:getNextSchaltung()
    local sortedTable = {}
    for schaltung in pairs(self.schaltungen) do
        table.insert(sortedTable, schaltung)
    end
    table.sort(sortedTable, AkKreuzungsSchaltung.hoeherePrioAls)
    return sortedTable[1]
end

function AkKreuzung:fuegeSchaltungHinzu(schaltung)
    self.schaltungen[schaltung] = true
end

function AkKreuzung:setBereit(bereit)
    self.bereit = bereit
end

function AkKreuzung:isBereit()
    return self.bereit
end

function AkKreuzung:getGruenZeitSekunden()
    return self.gruenZeit
end

function AkKreuzung.zaehlerZuruecksetzen()
    for i, kreuzung in ipairs(AkAllKreuzungen) do
        print("[AkKreuzung ] RESET " .. kreuzung.name)
        for schaltung in pairs(kreuzung:getSchaltungen()) do
            for richtung in pairs(schaltung:getRichtungen()) do
                richtung:setzeFahrzeugeZurueck()
            end
            for richtung in pairs(schaltung:getRichtungenMitAnforderung()) do
                richtung:setzeFahrzeugeZurueck()
            end
        end
    end
end

--- Erzeugt eine neue Kreuzung und registriert diese automatisch fuer das automatische Schalten.
-- Fuegen sie Schaltungen zu dieser Kreuzung hinzu.
-- @param name
--
function AkKreuzung:neu(name)
    local o = {
        name = name,
        aktuelleSchaltung = nil,
        schaltungen = {},
        bereit = true,
        gruenZeit = 15,
    }
    self.__index = self
    setmetatable(o, self)
    table.insert(AkAllKreuzungen, o)
    return o
end

--endregion
--region AkSchaltungStart
function AkSchaltungStart()
    ---------------------------
    -- Funktion schalteAmpeln
    ---------------------------
    local function AkSchalteKreuzung(kreuzung)
        --if AkKreuzung.debug then print(string.format("[AkKreuzung ] Schalte Kreuzung %s: %s", kreuzung:getName(), kreuzung:isBereit() and "Ja" or "Nein")) end
        if kreuzung:isBereit() then
            kreuzung:setBereit(false)
            local nextSchaltung = kreuzung:getNextSchaltung()
            local nextName = kreuzung.name .. " " .. nextSchaltung:getName()
            local aktuelleSchaltung = kreuzung:getAktuelleSchaltung()
            local currentName = aktuelleSchaltung
                    and kreuzung.name .. " " .. aktuelleSchaltung:getName()
                    or kreuzung.name .. " Rot fuer alle"
            local richtungenAufRot = {}
            local richtungenAufGruen = {}
            local richtungenAufFussgaengerRot = {}
            local richtungenAufFussgaengerGruen = {}
            local richtungenAktuellGruen = {}
            local richtungenAktuellFussgaengerGruen = {}

            -- aktuelle Richtungen für alle Schaltungen auf rot schalten:
            if aktuelleSchaltung then
                for richtung in pairs(aktuelleSchaltung:getRichtungen()) do
                    richtungenAktuellGruen[richtung] = true
                    richtungenAufRot[richtung] = true
                end
                for richtung in pairs(aktuelleSchaltung.richtungenFuerFussgaenger) do
                    richtungenAktuellFussgaengerGruen[richtung] = true
                    richtungenAufFussgaengerRot[richtung] = true
                end
            else
                -- Wenn es keine aktuellen Richtung gibt, müssen alle auf rot gesetzt werden:
                if AkKreuzung.debug then print("[AkKreuzung ] Setze alle Richtungen fuer " .. kreuzung.name .. " auf rot") end
                for schaltung in pairs(kreuzung:getSchaltungen()) do
                    for richtung in pairs(schaltung:getRichtungen()) do
                        richtungenAufRot[richtung] = true
                        richtungenAufFussgaengerRot[richtung] = true
                    end
                    for richtung in pairs(schaltung:getRichtungenMitAnforderung()) do
                        richtungenAufRot[richtung] = true
                        richtungenAufFussgaengerRot[richtung] = true
                    end
                end
            end

            -- RichtungenMitAnforderung werden nur geschaltet, wenn eine Anforderung vorliegt.
            for richtungDanachGruen in pairs(nextSchaltung:getRichtungenMitAnforderung()) do
                if richtungenAktuellGruen[richtungDanachGruen] then
                    richtungenAufRot[richtungDanachGruen] = nil
                else
                    if richtungDanachGruen:anforderungVorhanden() then
                        if AkKreuzung.debug then
                            print("[AkKreuzung ] Plane neue Ampel " .. richtungDanachGruen.eepSaveId
                                    .. " auf Gruen: " .. richtungDanachGruen:getName())
                        end
                        richtungenAufGruen[richtungDanachGruen] = true
                    end
                end
            end

            -- "Normale" Richtungen werden immer geschaltet
            for richtungDanachGruen in pairs(nextSchaltung:getRichtungen()) do
                if richtungenAktuellGruen[richtungDanachGruen] then
                    -- Ampel nicht auf rot schalten, da sie in der naechsten Schaltung enthalten ist
                    richtungenAufRot[richtungDanachGruen] = nil
                else
                    if AkKreuzung.debug then print("[AkKreuzung ] Richtung " .. richtungDanachGruen:getName() .. " wird fuer Autos auf gruen geschaltet.") end
                    richtungenAufGruen[richtungDanachGruen] = true
                end
            end

            -- Fussgaenger auf gruen schalten
            for richtungDanachGruen in pairs(nextSchaltung.richtungenFuerFussgaenger) do
                if richtungenAktuellFussgaengerGruen[richtungDanachGruen] then
                    -- Ampel nicht auf rot schalten, da sie in der naechsten Schaltung enthalten ist
                    richtungenAufFussgaengerRot[richtungDanachGruen] = nil
                else
                    richtungenAufFussgaengerGruen[richtungDanachGruen] = true
                    if AkKreuzung.debug then print("[AkKreuzung ] Richtung " .. richtungDanachGruen:getName() .. " wird fuer FG auf gruen geschaltet.") end
                end
            end

            if AkKreuzung.debug then print("[AkKreuzung ] Schalte " .. kreuzung:getName() .. " zu " .. nextSchaltung:getName() .. " (" .. nextSchaltung:richtungenAlsTextZeile() .. ")") end
            kreuzung:setzeWarteZeitZurueck(nextSchaltung)


            local fussgaengerAufRot = AkAktion:neu(function()
                AkSchalteAmpeln(richtungenAufFussgaengerRot, AkPhase.ROT, currentName)
            end, "Schalte " .. currentName .. " auf Fussgaenger Rot")
            AkPlaner:planeAktion(3, fussgaengerAufRot)

            local alteAmpelnAufGelb = AkAktion:neu(function()
                AkSchalteAmpeln(richtungenAufRot, AkPhase.GELB, currentName)
            end, "Schalte " .. currentName .. " auf gelb")
            AkPlaner:planeAktion(0, alteAmpelnAufGelb, fussgaengerAufRot)

            local alteAmpelnAufRot = AkAktion:neu(function()
                AkSchalteAmpeln(richtungenAufRot, AkPhase.ROT, currentName)
            end, "Schalte " .. currentName .. " auf rot")
            AkPlaner:planeAktion(2, alteAmpelnAufRot, alteAmpelnAufGelb)

            local neueAmpelnAufRotGelb = AkAktion:neu(function()
                AkSchalteAmpeln(richtungenAufGruen, AkPhase.ROTGELB, nextName)
                AkSchalteAmpeln(richtungenAufFussgaengerGruen, AkPhase.FG, nextName)
            end, "Schalte " .. nextName .. " auf rot-gelb")
            AkPlaner:planeAktion(3, neueAmpelnAufRotGelb, alteAmpelnAufRot)

            local neueAmpelnAufGruen = AkAktion:neu(function()
                AkSchalteAmpeln(richtungenAufGruen, AkPhase.GRUEN, nextName)
            end, "Schalte " .. nextName .. " auf gruen")
            AkPlaner:planeAktion(1, neueAmpelnAufGruen, neueAmpelnAufRotGelb)

            local kreuzungFertigschalten = AkAktion:neu(function()
                if AkKreuzung.debug then print("[AkKreuzung ] " .. kreuzung.name .. ": Fahrzeuge sind gefahren, kreuzung ist dann frei.") end
                kreuzung:setBereit(true)
            end, kreuzung.name .. " ist nun bereit (war " .. kreuzung:getGruenZeitSekunden() .. "s auf gruen geschaltet)")
            AkPlaner:planeAktion(kreuzung:getGruenZeitSekunden(), kreuzungFertigschalten, neueAmpelnAufGruen)
        end
    end

    for i, kreuzung in ipairs(AkAllKreuzungen) do
        AkSchalteKreuzung(kreuzung)
    end
end

--endregion
