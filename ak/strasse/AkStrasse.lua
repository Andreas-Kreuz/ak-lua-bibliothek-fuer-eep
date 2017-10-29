print("Lade AkScheduler ...")
require 'ak.planer.AkPlaner'
print("Lade AkStorage ...")
require 'ak.speicher.AkSpeicher'

AkTrafficLightsFunctions = {}

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
-- @param sigIndexRot Index des roten Signals
-- @param sigIndexGruen Index des gruenen Signals
-- @param sigIndexGelb Index des gelben Signals
-- @param sigIndexRotGelb Index des gruen-gelben Signal (oder rot)
--
function AkAmpelModell:neu(name, sigIndexRot, sigIndexGruen, sigIndexGelb, sigIndexRotGelb, sigIndexFgGruen)
    local o = {}
    assert(name)
    assert(sigIndexRot)
    assert(sigIndexGruen)
    o.name = name
    o.sigIndexRot = sigIndexRot
    o.sigIndexGruen = sigIndexGruen
    o.sigIndexGelb = sigIndexGelb or sigIndexRot
    o.sigIndexRotGelb = sigIndexRotGelb or sigIndexRot
    o.sigIndexFgGruen = sigIndexFgGruen
    setmetatable(o, self)
    self.__index = self
    return o
end

function AkAmpelModell:print()
    print(self.name)
end

function AkAmpelModell:getSignalIndex(phase)
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
-- Ampel mit einer festen signal_id und einem festen Ampeltyp
-- Optional kann die Ampel bei Immobilien Licht ein- und ausschalten (Straba - Ampelsatz)
------------------------------------------------------------------------------------------
AkAmpel = {}
AkAmpel.debug = AkDebugInit or false
---
-- @param signal_id ID der Ampel auf der Anlage (Eine Ampel von diesem Typ sollte auf der Anlage sein
-- @param ampel_typ Typ der Ampel (AkAmpelModell)
-- @param rotImmo Immobilie fuer Signalbild gelb (Licht an / aus)
-- @param gruenImmo Immobilie fuer Signalbild gelb (Licht an / aus)
-- @param gelbImmo Immobilie fuer Signalbild gelb (Licht an / aus)
-- @param activeImmo Immobilie fuer Signalbild "A" (Licht an / aus)
--
function AkAmpel:new(signal_id, ampel_typ, rotImmo, gruenImmo, gelbImmo, activeImmo)
    EEPShowInfoSignal(signal_id, false)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    assert(signal_id)
    assert(ampel_typ)
    o.signal_id = signal_id
    o.ampel_typ = ampel_typ
    o.rotImmo = rotImmo
    o.gruenImmo = gruenImmo
    o.gelbImmo = gelbImmo or rotImmo
    o.activeImmo = activeImmo
    o.phase = AkPhase.ROT
    o.anforderung = false
    o.debug = false
    return o
end

---
-- @param signal_id ID der Ampel auf der Anlage (Eine Ampel von diesem Typ sollte auf der Anlage sein)
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

    local sigIndex = self.ampel_typ:getSignalIndex(phase)
    if (self.debug or AkAmpel.debug) then print(string.format("[AkAmpel    ] Schalte Ampel %04d auf %s (%01d)", self.signal_id, phase, sigIndex) .. immoDbg) end
    EEPSetSignal(self.signal_id, sigIndex)
    EEPShowInfoSignal(self.signal_id, (AkKreuzung.showAnforderungenAlsInfo and self.anforderung) or (AkKreuzung.showSchaltungAlsInfo and self.phase ~= AkPhase.ROT))
    if (AkKreuzung.showSchaltungAlsInfo and self.phase ~= AkPhase.ROT) then
        EEPChangeInfoSignal(self.signal_id, phase .. " (" .. grund .. ")")
    end
end

function AkAmpel:setAnforderung(anforderung, richtung, anzahl)
    local immoDbg = ""
    self.anforderung = anforderung
    if self.activeImmo then
        immoDbg = immoDbg .. string.format(", Licht in %s: %s", self.activeImmo, (anforderung) and "an" or "aus")
        EEPStructureSetLight(self.activeImmo, anforderung)
    end
    if (self.debug or AkAmpel.debug) and immoDbg ~= "" then print(string.format("[AkAmpel    ] Schalte Ampel %04d", self.signal_id) .. immoDbg) end
    EEPShowInfoSignal(self.signal_id, (AkKreuzung.showAnforderungenAlsInfo and self.anforderung) or (AkKreuzung.showSchaltungAlsInfo and self.phase ~= AkPhase.ROT))
    if (AkKreuzung.showAnforderungenAlsInfo and self.anforderung) then
        EEPChangeInfoSignal(self.signal_id, richtung.name .. " - Anzahl FZ: " .. tostring(anzahl) .. " (Warte: " .. tostring(richtung.warteZeit) .. ")")
    end
end

function AkAmpel:print()
    print(string.format("[AkAmpel    ] Ampel %04d: %s (%s)", self.signal_id, self.phase, self.ampel_typ.name))
end

--endregion
--region AkKreuzungsSchaltung
------------------------------------------------------
-- Klasse Richtungsschaltung (schaltet mehrere Ampeln)
------------------------------------------------------
AkKreuzungsSchaltung = {}

function AkKreuzungsSchaltung.getType()
    return "AkKreuzungsSchaltung"
end

function AkKreuzungsSchaltung:getName()
    return self.name
end

function AkKreuzungsSchaltung:new(name)
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

function AkKreuzungsSchaltung:richtungenTextEineZeile()
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


function AkKreuzungsSchaltung:addRichtung(richtung)
    self.richtungen[richtung] = true
end

function AkKreuzungsSchaltung:addRichtungMitAnforderung(richtung)
    self.richtungenMitAnforderung[richtung] = true
end

function AkKreuzungsSchaltung:addRichtungFuerFussgaenger(richtung)
    self.richtungenFuerFussgaenger[richtung] = true
end

function AkKreuzungsSchaltung:getSortedRichtungen()
    local sortedRichtungen = {}
    local tableSize = 0
    local count = 0
    for richtung in pairs(self.richtungen) do
        table.insert(sortedRichtungen, richtung)
        tableSize = tableSize + 1
        count = count + richtung:getPrio()
    end
    for richtung in pairs(self.richtungenFuerFussgaenger) do
        table.insert(sortedRichtungen, richtung)
        tableSize = tableSize + 1
        count = count + richtung:getPrio()
    end
    local avg = count / tableSize
    local sortf = function(richtung1, richtung2)
        if richtung1:getPrio() > richtung2:getPrio() then return true
        elseif richtung1:getPrio() < richtung2:getPrio() then return false
        end
        return (richtung1.name < richtung2.name)
    end
    table.sort(sortedRichtungen, sortf)
    return sortedRichtungen, tableSize, avg
end

function AkKreuzungsSchaltung.hoeherePrioAls(schaltung1, schaltung2)
    if schaltung1 and schaltung2 then
        local sortedRichtungen1, tableSize1, avg1 = schaltung1:getSortedRichtungen()
        local sortedRichtungen2, tableSize2, avg2 = schaltung2:getSortedRichtungen()

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
    local _, __, prio = self:getSortedRichtungen()
    return prio
end

function AkKreuzungsSchaltung:resetWarteZeit()
    for richtung in pairs(self.richtungen) do
        richtung:resetWarteZeit()
    end
end

--endregion
--region AkRichtung
--------------------
-- Klasse Richtung
--------------------
AkRichtung = { fahrzeugMultiplikator = 1 }

function AkRichtung.getType()
    return "AkRichtung"
end

function AkRichtung:getName()
    return self.name
end

function AkRichtung:aktualisiereAnforderung()
    for _, ampel in pairs(self.ampeln) do
        ampel:setAnforderung(self.fahrzeuge > 0, self, self.fahrzeuge)
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

        local toRed = AkAction.new(function()
            AkSchalteAmpeln(richtungen, AkPhase.ROT, "Fahrzeug verlassen: " .. fahrzeugName)
        end, "Schalte " .. self.name .. " auf rot.")
        AkScheduler:addAction(2, toRed)
    end
end

function AkRichtung:resetFahrzeuge()
    self.fahrzeuge = 0
    self:aktualisiereAnforderung()
    self:save()
end

function AkRichtung:increaseWarteZeit()
    self.warteZeit = self.warteZeit + 1
    self:save()
end

function AkRichtung:resetWarteZeit()
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
        AkStorage.storeTable(self.eepSaveId, data, "AkRichtung " .. self.name)
    end
end

function AkRichtung:load()
    if self.eepSaveId ~= -1 then
        local data = AkStorage.loadTable(self.eepSaveId, "AkRichtung " .. self.name)
        self.fahrzeuge = data["f"] and tonumber(data["f"]) or 0
        self.warteZeit = data["w"] and tonumber(data["w"]) or 0
        self.phase = data["p"] or AkPhase.ROT
        for _, ampel in pairs(self.ampeln) do
            ampel:setAnforderung(self.fahrzeuge > 0, self, self.fahrzeuge)
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
function AkRichtung:new(name, eepSaveId, ...)
    assert(name, "Bitte geben Sie den Namen \"name\" fuer diese Richtung an.")
    assert(type(name) == "string")
    assert(eepSaveId, "Bitte geben Sie den Wert \"eepSaveId\" fuer diese Richtung an.")
    assert(type(eepSaveId) == "number")
    assert(..., "Bitte geben Sie den Wert \"ampeln\" fuer diese Richtung an.")
    --assert(signalId, "Bitte geben Sie den Wert \"signalId\" fuer diese Richtung an.")
    if eepSaveId ~= -1 then AkStorage.register(eepSaveId, name) end

    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.name = name
    o.eepSaveId = eepSaveId
    o.ampeln = ...
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
AkKreuzung.debug = AkDebugInit or false
AkKreuzung.showAnforderungenAlsInfo = AkDebugInit or false
AkKreuzung.showSchaltungAlsInfo = AkDebugInit or false

function AkKreuzung.getType()
    return "AkKreuzung"
end

function AkKreuzung:getName()
    return self.name
end

function AkKreuzung:getSchaltungen()
    return self.schaltungen
end

function AkKreuzung:getCurrentSchaltung()
    return self.currentSchaltung
end

function AkKreuzung:resetWarteZeit(nextSchaltung)
    local increaseRichtungen = {}
    for schaltung in pairs(self.schaltungen) do
        assert(schaltung.getType() == "AkKreuzungsSchaltung", "Found: " .. schaltung:getType())
        for richtung in pairs(schaltung:getRichtungen()) do
            assert(richtung.getType() == "AkRichtung", "Found: " .. richtung:getType())
            if nextSchaltung:getRichtungen()[richtung] then
                richtung:resetWarteZeit()
            else
                increaseRichtungen[richtung] = true
            end
        end
    end

    for richtung in pairs(increaseRichtungen) do
        assert(richtung.getType() == "AkRichtung", "Found: " .. richtung:getType())
        richtung:increaseWarteZeit()
    end
    self.currentSchaltung = nextSchaltung
end

function AkKreuzung:getNextSchaltung()
    local sortedTable = {}
    for schaltung in pairs(self.schaltungen) do
        table.insert(sortedTable, schaltung)
    end
    table.sort(sortedTable, AkKreuzungsSchaltung.hoeherePrioAls)
    return sortedTable[1]
end

function AkKreuzung:addSchaltung(schaltung)
    self.schaltungen[schaltung] = true
end

function AkKreuzung:setReady(ready)
    self.ready = ready
end

function AkKreuzung:isReady()
    return self.ready
end

function AkKreuzung:getGruenZeitSekunden()
    return self.gruenZeit
end

function AkKreuzung.zaehlerZuruecksetzen()
    for i, kreuzung in ipairs(AkAllKreuzungen) do
        print("[AkKreuzung ] RESET " .. kreuzung.name)
        for schaltung in pairs(kreuzung:getSchaltungen()) do
            for richtung in pairs(schaltung:getRichtungen()) do
                richtung:resetFahrzeuge()
            end
            for richtung in pairs(schaltung:getRichtungenMitAnforderung()) do
                richtung:resetFahrzeuge()
            end
        end
    end
end


function AkKreuzung:new(name)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.name = name
    o.currentSchaltung = nil
    o.schaltungen = {}
    o.ready = true
    o.gruenZeit = 15
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
        --if AkKreuzung.debug then print(string.format("[AkKreuzung ] Schalte Kreuzung %s: %s", kreuzung:getName(), kreuzung:isReady() and "Ja" or "Nein")) end
        if kreuzung:isReady() then
            kreuzung:setReady(false)
            local nextSchaltung = kreuzung:getNextSchaltung()
            local nextName = kreuzung.name .. " " .. nextSchaltung:getName()
            local currentSchaltung = kreuzung:getCurrentSchaltung()
            local currentName = currentSchaltung
                    and kreuzung.name .. " " .. currentSchaltung:getName()
                    or kreuzung.name .. " Rot fuer alle"
            local richtungenAufRot = {}
            local richtungenAufGruen = {}
            local richtungenAufFussgaengerRot = {}
            local richtungenAufFussgaengerGruen = {}
            local richtungenAktuellGruen = {}
            local richtungenAktuellFussgaengerGruen = {}

            -- aktuelle Richtungen für alle Schaltungen auf rot schalten:
            if currentSchaltung then
                for richtung in pairs(currentSchaltung:getRichtungen()) do
                    richtungenAktuellGruen[richtung] = true
                    richtungenAufRot[richtung] = true
                end
                for richtung in pairs(currentSchaltung.richtungenFuerFussgaenger) do
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

            if AkKreuzung.debug then print("[AkKreuzung ] Schalte " .. kreuzung:getName() .. " zu " .. nextSchaltung:getName() .. " (" .. nextSchaltung:richtungenTextEineZeile() .. ")") end
            kreuzung:resetWarteZeit(nextSchaltung)


            local fussgaengerAufRot = AkAction.new(function()
                AkSchalteAmpeln(richtungenAufFussgaengerRot, AkPhase.ROT, currentName)
            end, "Schalte " .. currentName .. " auf Fussgaenger Rot")
            AkScheduler:addAction(3, fussgaengerAufRot)

            local alteAmpelnAufGelb = AkAction.new(function()
                AkSchalteAmpeln(richtungenAufRot, AkPhase.GELB, currentName)
            end, "Schalte " .. currentName .. " auf gelb")
            AkScheduler:addAction(0, alteAmpelnAufGelb, fussgaengerAufRot)

            local alteAmpelnAufRot = AkAction.new(function()
                AkSchalteAmpeln(richtungenAufRot, AkPhase.ROT, currentName)
            end, "Schalte " .. currentName .. " auf rot")
            AkScheduler:addAction(2, alteAmpelnAufRot, alteAmpelnAufGelb)

            local neueAmpelnAufRotGelb = AkAction.new(function()
                AkSchalteAmpeln(richtungenAufGruen, AkPhase.ROTGELB, nextName)
                AkSchalteAmpeln(richtungenAufFussgaengerGruen, AkPhase.FG, nextName)
            end, "Schalte " .. nextName .. " auf rot-gelb")
            AkScheduler:addAction(3, neueAmpelnAufRotGelb, alteAmpelnAufRot)

            local neueAmpelnAufGruen = AkAction.new(function()
                AkSchalteAmpeln(richtungenAufGruen, AkPhase.GRUEN, nextName)
            end, "Schalte " .. nextName .. " auf gruen")
            AkScheduler:addAction(1, neueAmpelnAufGruen, neueAmpelnAufRotGelb)

            local kreuzungFertigschalten = AkAction.new(function()
                if AkKreuzung.debug then print("[AkKreuzung ] " .. kreuzung.name .. ": Fahrzeuge sind gefahren, kreuzung ist dann frei.") end
                kreuzung:setReady(true)
            end, kreuzung.name .. " ist nun bereit (war " .. kreuzung:getGruenZeitSekunden() .. "s auf gruen geschaltet)")
            AkScheduler:addAction(kreuzung:getGruenZeitSekunden(), kreuzungFertigschalten, neueAmpelnAufGruen)
        end
    end

    for i, kreuzung in ipairs(AkAllKreuzungen) do
        AkSchalteKreuzung(kreuzung)
    end
end

--endregion


