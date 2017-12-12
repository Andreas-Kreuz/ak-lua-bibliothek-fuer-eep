print("Lade AkPlaner ...")
require("ak.planer.AkPlaner")

print("Lade AkSpeicherHilfe ...")
require("ak.speicher.AkSpeicher")

print("Lade AkAusgabe ...")
require("ak.text.AkAusgabe")

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
-- @param sigIndexFgGruen Index der Signalstellung in der die Fussgaenger gruen haben und die Autos rot
-- @param sigIndexKomplettAus Index der Signalstellung in der die Ampel komplett aus ist
-- @param sigIndexGelbBlinkenAus Index der Signalstellung in der die Ampel gelb blinkt ohne den Verkehr zu beeinflussen
--
function AkAmpelModell:neu(name, sigIndexRot, sigIndexGruen, sigIndexGelb, sigIndexRotGelb, sigIndexFgGruen,
sigIndexKomplettAus, sigIndexGelbBlinkenAus)
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
        sigIndexGelbBlinkenAus = sigIndexGelbBlinkenAus,
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
    _G["EEPOnSwitch_" .. weiche_id] = function(_)
        local stellung = EEPGetSwitch(weiche_id)
        if immo1 then EEPStructureSetLight(immo1, stellung == 1) end
        if immo2 then EEPStructureSetLight(immo2, stellung == 2) end
        if immo3 then EEPStructureSetLight(immo3, stellung == 3) end
    end
    _G["EEPOnSwitch_" .. weiche_id]()
end

--endregion

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
AkAmpelModell.JS2_2er_nur_FG = AkAmpelModell:neu("Ak_Ampel_2er_nur_FG", 1, 1, 1, 1, 2)
AkAmpelModell.JS2_3er_mit_FG = AkAmpelModell:neu("Ampel_3er_XXX_mit_FG", 1, 3, 5, 2, 6)
AkAmpelModell.JS2_3er_ohne_FG = AkAmpelModell:neu("Ampel_3er_XXX_ohne_FG", 1, 3, 5, 2)

-- Unsichtbare Ampeln haben "nur" rot und gruen
AkAmpelModell.Unsichtbar_2er = AkAmpelModell:neu("Unsichtbares Signal", 2, 1, 2, 2)

--endregion
--region AkAmpelLichtImmo
local AkLichtImmoAmpel = {}
function AkLichtImmoAmpel.neuAusTabelle(tabelle)
    return AkLichtImmoAmpel:neu(
        tabelle.rotImmo,
        tabelle.gruenImmo,
        tabelle.gelbImmo,
        tabelle.anforderungImmo)
end

--- Schaltet das Licht der angegebenen Immobilien beim Schalten der Ampel auf rot, gelb, grün oder Anforderung
-- @param rotImmo Immo deren Licht eingeschaltet wird, wenn die Ampel rot oder rot-gelb ist
-- @param gruenImmo Immo deren Licht eingeschaltet wird, wenn die Ampel grün ist
-- @param gelbImmo Immo deren Licht eingeschaltet wird, wenn die Ampel gelb oder rot-gelb ist
-- @param anforderungImmo Immo deren Licht eingeschaltet wird, wenn die Ampel eine Anforderung erkennt
--
function AkLichtImmoAmpel:neu(rotImmo, gruenImmo, gelbImmo, anforderungImmo)
    assert(rotImmo)
    assert(type(rotImmo) == "string")
    assert(EEPStructureGetLight(gruenImmo))
    assert(gruenImmo)
    assert(type(gruenImmo) == "string")
    assert(EEPStructureGetLight(gruenImmo))
    if gelbImmo then
        assert(type(gelbImmo) == "string")
        assert(EEPStructureGetLight(gelbImmo))
    end
    if anforderungImmo then
        assert(type(anforderungImmo) == "string")
        assert(EEPStructureGetLight(anforderungImmo))
    end
    local o = {
        rotImmo = rotImmo,
        gruenImmo = gruenImmo,
        gelbImmo = gelbImmo or rotImmo,
        anforderungImmo = anforderungImmo,
    }
    self.__index = self
    o = setmetatable(o, self)
    return o
end

local AkAchsenImmoAmpel = {}
function AkAchsenImmoAmpel.neuAusTabelle(tabelle)
    return AkAchsenImmoAmpel:neu(
        tabelle.immoName,
        tabelle.achse,
        tabelle.grundStellung,
        tabelle.stellungRot,
        tabelle.stellungGruen,
        tabelle.stellungGelb,
        tabelle.stellungRotGelb,
        tabelle.stellungFG)
end

--- Ändert die Achsstellung der angegebenen Immobilien beim Schalten der Ampel auf rot, gelb, grün oder Fußgänger
-- @param immoName Name der Immobilie, deren Achse gesteuert werden soll
-- @param achsName Name der Achse in der Immobilie, die gesteuert werden soll
-- @param grundStellung Grundstellung der Achse (wird eingestellt, wenn eine Stellung nicht angegeben wurde
-- @param stellungRot Achsstellung bei rot
-- @param stellungGruen Achsstellung bei grün
-- @param stellungGelb Achsstellung bei gelb
-- @param stellungFG Achsstellung bei FG
--
function AkAchsenImmoAmpel:neu(immoName, achse, grundStellung, stellungRot, stellungGruen,
   stellungGelb, stellungRotGelb, stellungFG)
    assert(immoName)
    assert(type(immoName) == "string")
    assert(achse)
    assert(type(achse) == "string")
    assert(EEPStructureGetAxis(immoName, achse))
    assert(type(grundStellung) == "number")
    if stellungRot then assert(type(stellungRot) == "number") end
    if stellungGruen then assert(type(stellungGruen) == "number") end
    if stellungGelb then assert(type(stellungGelb) == "number") end
    if stellungRotGelb then assert(type(stellungRotGelb) == "number") end
    if stellungFG then assert(type(stellungFG) == "number") end
    local o = {
    immoName = immoName,
        achse = achse,
        grundStellung = grundStellung,
        stellungRot = stellungRot,
        stellungGruen = stellungGruen,
        stellungGelb = stellungGelb or stellungRot,
        stellungFG = stellungFG,
        stellungRotGelb = stellungRotGelb
    }
    self.__index = self
    o = setmetatable(o, self)
    return o
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
        phase = AkPhase.ROT,
        anforderung = false,
        debug = false,
        richtungsInfo = "",
        schaltungsInfo = "",
        aufbauInfo = "" .. tostring(signalId),
        richtungen = {},
        lichtImmos = {},
        achsenImmos = {},
    }
    self.__index = self
    o = setmetatable(o, self)

    if rotImmo or gruenImmo or gelbImmo or anforderungImmo then
        o:fuegeLichtImmoHinzu(rotImmo, gruenImmo, gelbImmo, anforderungImmo)
    end
    return o
end

--- Schaltet das Licht der angegebenen Immobilien beim Schalten der Ampel auf rot, gelb, grün oder Anforderung
-- @param rotImmo Name der Immobilie, deren Licht eingeschaltet wird, wenn die Ampel rot oder rot-gelb ist
-- @param gruenImmo Name der Immobilie,  deren Licht eingeschaltet wird, wenn die Ampel grün ist
-- @param gelbImmo Name der Immobilie,  deren Licht eingeschaltet wird, wenn die Ampel gelb oder rot-gelb ist
-- @param anforderungImmo Name der Immobilie,  deren Licht eingeschaltet wird, wenn die Ampel eine Anforderung erkennt
--
function AkAmpel:fuegeLichtImmoHinzu(rotImmo, gruenImmo, gelbImmo, anforderungImmo)
    local lichtAmpel = AkLichtImmoAmpel:neu(rotImmo, gruenImmo, gelbImmo, anforderungImmo)
    self.lichtImmos[lichtAmpel] = true
    return self
end

--- Ändert die Achsstellung der angegebenen Immobilien beim Schalten der Ampel auf rot, gelb, grün oder Fußgänger
-- @param immoName Name der Immobilie, deren Achse gesteuert werden soll
-- @param achsName Name der Achse in der Immobilie, die gesteuert werden soll
-- @param grundStellung Grundstellung der Achse (wird eingestellt, wenn eine Stellung nicht angegeben wurde
-- @param stellungRot Achsstellung bei rot
-- @param stellungGruen Achsstellung bei grün
-- @param stellungGelb Achsstellung bei gelb
-- @param stellungFG Achsstellung bei FG
--
function AkAmpel:fuegeAchsenImmoHinzu(immoName, achsName, grundStellung,
stellungRot, stellungGruen, stellungGelb, stellungFG)
    local achsAmpel = AkAchsenImmoAmpel:neu(immoName, achsName, grundStellung,
        stellungRot, stellungGruen, stellungGelb, stellungFG)
    self.achsenImmos[achsAmpel] = true
    return self
end

--- Aktualisiert den Text für die aktuellen Schaltung dieser Ampel
-- @param schaltungsInfo TippText für die Schaltung
--
function AkAmpel:setzeSchaltungsInfo(schaltungsInfo)
    self.schaltungsInfo = schaltungsInfo
end

--- Aktualsisiert den Text für die Richtungen dieser Ampel
-- @param richtungsInfo TippText für die Richtung
--
function AkAmpel:setzeRichtungsInfo(richtungsInfo)
    self.richtungsInfo = richtungsInfo
end

--- Stellt die vorher gesetzten Tipp-Texte dar.
--
function AkAmpel:aktualisiereInfo()
    local infoFuerAnforderung = AkKreuzung.zeigeAnforderungenAlsInfo
    local infoFuerAktuelleSchaltung = AkKreuzung.zeigeSchaltungAlsInfo
    local zeigeInfo = infoFuerAnforderung or infoFuerAktuelleSchaltung

    EEPShowInfoSignal(self.signalId, zeigeInfo)
    if zeigeInfo then
        local infoText = "<j><b>Ampel ID: " .. fmt.hintergrund_grau(self.signalId) .. "</b></j>"

        if AkKreuzung.zeigeSchaltungAlsInfo then
            if infoText:len() > 0 then infoText = infoText .. "<br>___________________________<br>" end
            infoText = infoText .. self.schaltungsInfo
        end

        if infoFuerAktuelleSchaltung and self.phase and self.grund then
            if infoText:len() > 0 then infoText = infoText .. "<br><br>" end
            infoText = infoText .. " " .. self.phase .. " (" .. self.grund .. ")"
        end

        if infoFuerAnforderung then
            if infoText:len() > 0 then infoText = infoText .. "<br>___________________________<br>" end
            infoText = infoText .. self.richtungsInfo
        end
        assert(infoText:len() < 1023)
        EEPChangeInfoSignal(self.signalId, infoText)
    end
end

---
-- @param signalId ID der Ampel auf der Anlage (Eine Ampel von diesem Typ sollte auf der Anlage sein)
-- @param phase AkPhase.xxx
-- @param grund z.B. Name der Schaltung
--
function AkAmpel:schalte(phase, grund)
    assert(phase)
    self.phase = phase
    local immoLichtDbg = self:schalteImmoLicht()
    local immoAchseDbg = self:schalteImmoAchsen()

    local sigIndex = self.ampelTyp:signalIndexFuer(self.phase)
    if (self.debug or AkAmpel.debug) then
        print(string.format("[AkAmpel    ] Schalte Ampel %04d auf %s (%01d)",
            self.signalId, self.phase, sigIndex) .. immoLichtDbg .. immoAchseDbg .. " - " .. grund)
    end
    self:schalteSignal(sigIndex)
end

function AkAmpel:schalteImmoLicht()
    local immoDbg = ""
    for lichtAmpel in pairs(self.lichtImmos) do
        if lichtAmpel.rotImmo then
            immoDbg = immoDbg .. string.format(", Licht in %s: %s", lichtAmpel.rotImmo,
                (self.phase == AkPhase.ROT or self.phase == AkPhase.ROTGELB) and "an" or "aus")
            EEPStructureSetLight(lichtAmpel.rotImmo, self.phase == AkPhase.ROT or self.phase == AkPhase.ROTGELB)
        end
        if lichtAmpel.gelbImmo then
            immoDbg = immoDbg .. string.format(", Licht in %s: %s", lichtAmpel.gelbImmo,
                (self.phase == AkPhase.GELB or self.phase == AkPhase.ROTGELB) and "an" or "aus")
            EEPStructureSetLight(lichtAmpel.gelbImmo, self.phase == AkPhase.GELB or self.phase == AkPhase.ROTGELB)
        end
        if lichtAmpel.gruenImmo then
            immoDbg = immoDbg .. string.format(", Licht in %s: %s", lichtAmpel.gruenImmo,
                (self.phase == AkPhase.GRUEN) and "an" or "aus")
            EEPStructureSetLight(lichtAmpel.gruenImmo, self.phase == AkPhase.GRUEN)
        end
    end
    return immoDbg
end

function AkAmpel:schalteImmoAchsen()
    local immoDbg = ""
    for achsenAmpel in pairs(self.achsenImmos) do
        local achsStellung = achsenAmpel.grundStellung

        if achsenAmpel.stellungRotGelb and
                self.phase == AkPhase.ROTGELB then
            achsStellung = achsenAmpel.stellungRotGelb
        elseif achsenAmpel.stellungGelb and
                (self.phase == AkPhase.GELB or self.phase == AkPhase.ROTGELB) then
            achsStellung = achsenAmpel.stellungGelb
        elseif achsenAmpel.stellungRot and
                self.phase == AkPhase.ROT then
            achsStellung = achsenAmpel.stellungRot
        elseif achsenAmpel.stellungGruen and self.phase == AkPhase.GRUEN then
            achsStellung = achsenAmpel.stellungGruen
        elseif achsenAmpel.stellungFG and self.phase == AkPhase.FG then
            achsStellung = achsenAmpel.stellungFG
        end

        immoDbg = immoDbg .. string.format(", Achse %s in %s auf: %d",
        achsenAmpel.achse, achsenAmpel.immoName, achsStellung)
        EEPStructureSetAxis(achsenAmpel.immoName, achsenAmpel.achse, achsStellung)
    end
    return immoDbg
end

function AkAmpel:schalteSignal(sigIndex)
    EEPSetSignal(self.signalId, sigIndex)
end

--- Setzt die Anforderung fuer eine Ampel (damit sie weiß, ob eine Anforderung vorliegt)
-- @param anforderung - true oder false
-- @param richtung - AkRichtung, für welche die Anforderung vorliegt
function AkAmpel:aktualisiereAnforderung(richtung)
    local immoDbg = ""
    self.richtungen[richtung] = true
    local anforderung = richtung:anforderungVorhanden()
    if self.anforderungImmo then
        immoDbg = immoDbg .. string.format(", Licht in %s: %s", self.anforderungImmo, (anforderung) and "an" or "aus")
        EEPStructureSetLight(self.anforderungImmo, anforderung)
    end
    if (self.debug or AkAmpel.debug) and immoDbg ~= "" then
        print(string.format("[AkAmpel    ] Schalte Ampel %04d", self.signalId) .. immoDbg)
    end
    self:aktualisiereInfo()
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
    assert(richtung, "Bitte ein gueltige Richtung angeben")
    richtung:setSchaltungsTyp(AkRichtung.SchaltungsTyp.NORMAL)
    self.richtungen[richtung] = true
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

------ Gibt alle Richtungen nach Name sortiert zurueck
-- @return sortierteRichtungen
function AkKreuzungsSchaltung:nachNameSortierteRichtungen()
    local sortierteRichtungen = {}
    for richtung in pairs(self.richtungen) do
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
AkRichtung.SchaltungsTyp = {}
AkRichtung.SchaltungsTyp.NICHT_VERWENDET = "NICHT VERWENDET"
AkRichtung.SchaltungsTyp.ANFORDERUNG = "ANFORDERUNG"
AkRichtung.SchaltungsTyp.NORMAL = "NORMAL"
AkRichtung.SchaltungsTyp.FUSSGAENGER = "FUSSGAENGER"

function AkRichtung.getTyp()
    return "AkRichtung"
end

function AkRichtung:getName()
    return self.name
end

function AkRichtung:getSchaltungsTyp()
    return self.schaltungsTyp
end

function AkRichtung:setSchaltungsTyp(schaltungsTyp)
    assert(schaltungsTyp)
    assert(self.schaltungsTyp == AkRichtung.SchaltungsTyp.NICHT_VERWENDET or
            self.schaltungsTyp == schaltungsTyp,
        "Diese Richtung hatte schon den Schaltungstyp: '" .. self.schaltungsTyp
                .. "' und kann daher nicht auf '" .. schaltungsTyp .. "' gesetzt werden.")

    self.schaltungsTyp = schaltungsTyp
end

function AkRichtung:pruefeAnforderungen()
    self:pruefeAnforderungenAnStrassen()
    self:pruefeAnforderungenAnSignalen()

    local text = ""
    if self.schaltungsTyp == AkRichtung.SchaltungsTyp.NORMAL then
        text = text .. fmt.hintergrund_gruen(self.name)
    elseif self.schaltungsTyp == AkRichtung.SchaltungsTyp.FUSSGAENGER then
        text = text .. fmt.hintergrund_gelb(self.name)
    elseif self.schaltungsTyp == AkRichtung.SchaltungsTyp.ANFORDERUNG then
        text = text .. fmt.hintergrund_blau(self.name)
    else
        text = text .. fmt.rot(self.name)
    end

    text = text .. ": "
            .. (self:anforderungVorhanden()
            and fmt.hellgrau("BELEGT")
            or fmt.hellgrau("-FREI-"))
            .. " "
    if self.verwendeZaehlStrassen then
        text = text .. "(Strasse)"
    elseif self.verwendeZaehlAmpeln then
        text = text .. "(Ampel)"
    else
        text = text .. "(" .. self.fahrzeuge .. " gezaehlt)"
    end

    self.anforderungsText = text
    self:aktualisiereAnforderung()
end

function AkRichtung:aktualisiereAnforderung()
    for _, ampel in pairs(self.ampeln) do
        ampel:aktualisiereAnforderung(self)
    end
end

function AkRichtung:getPrio()
    local verwendeZaehlStrassen = self:pruefeAnforderungenAnStrassen()
    if verwendeZaehlStrassen then
        local prio = (self.anforderungAnStrasse and 1 or 0) * 3 * self.fahrzeugMultiplikator
        return self.warteZeit > prio and self.warteZeit or prio
    end

    local verwendeZaehlAmpeln = self:pruefeAnforderungenAnSignalen()
    if verwendeZaehlAmpeln then
        local prio = (self.anforderungAnSignal and 1 or 0) * 3 * self.fahrzeugMultiplikator
        return self.warteZeit > prio and self.warteZeit or prio
    end

    local prio = self.fahrzeuge * 3 * self.fahrzeugMultiplikator
    return self.warteZeit > prio and self.warteZeit or prio
end

function AkRichtung:getAnforderungsText()
    return self.anforderungsText or "KEINE ANFORDERUNG"
end


function AkRichtung:zaehleAnStrasseAlle(strassenId)
    self.verwendeZaehlStrassen = true
    EEPRegisterRoadTrack(strassenId)
    if not self.zaehlStrassen[strassenId] then
        self.zaehlStrassen[strassenId] = {}
    end
    return self
end

function AkRichtung:zaehleAnStrasseBeiRoute(strassenId, route)
    self.verwendeZaehlStrassen = true
    EEPRegisterRoadTrack(strassenId)
    if not self.zaehlStrassen[strassenId] then
        self.zaehlStrassen[strassenId] = {}
    end
    self.zaehlStrassen[strassenId][route] = true
    return self
end

function AkRichtung:pruefeAnforderungenAnStrassen()
    local anforderungGefunden = false
    for strassenId, routen in pairs(self.zaehlStrassen) do

        local ok, wartend, zugName = EEPIsRoadTrackReserved(strassenId, true)
        assert(ok)

        if wartend then
            assert(zugName, "Kein Zug auf Strasse: " .. strassenId)
            local found, zugRoute = EEPGetTrainRoute(zugName)
            assert(found, "Zug nicht gefunden in EEPGetTrainRoute: " .. zugName)

            local zugGefunden = false
            local filterNachRoute = false
            for erlaubteRoute in pairs(routen) do
                filterNachRoute = true
                if erlaubteRoute == zugRoute then
                    zugGefunden = true
                    break
                end
            end

            anforderungGefunden = not filterNachRoute or zugGefunden
            break
        end
    end
    self.anforderungAnStrasse = anforderungGefunden
end

function AkRichtung:zaehleAnAmpelAlle(signalId)
    self.verwendeZaehlAmpeln = true
    assert(signalId, "Keine signalId angegeben")
    if not self.zaehlAmpeln[signalId] then
        self.zaehlAmpeln[signalId] = {}
    end
    return self
end

function AkRichtung:zaehleAnAmpelBeiRoute(signalId, route)
    self.verwendeZaehlAmpeln = true
    if not self.zaehlAmpeln[signalId] then
        self.zaehlAmpeln[signalId] = {}
    end
    self.zaehlAmpeln[signalId][route] = true
    return self
end

function AkRichtung:pruefeAnforderungenAnSignalen()
    local anforderungGefunden = false
    for signalId, routen in pairs(self.zaehlAmpeln) do

        local wartend = EEPGetSignalTrainsCount(signalId)

        if wartend > 0 then
            local zugName = EEPGetSignalTrainName(signalId, 1)
            assert(zugName, "Kein Zug an Signal: " .. signalId)
            local found, zugRoute = EEPGetTrainRoute(zugName)
            assert(found, "Zug nicht gefunden in EEPGetTrainRoute: " .. zugName)

            local zugGefunden = false
            local filterNachRoute = false
            for erlaubteRoute in pairs(routen) do
                filterNachRoute = true
                if erlaubteRoute == zugRoute then
                    zugGefunden = true
                    break
                end
            end

            anforderungGefunden = not filterNachRoute or zugGefunden
            break
        end
    end
    self.anforderungAnSignal = anforderungGefunden
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
            or self.anforderungAnSignal
            or self.anforderungAnStrasse
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
        self:pruefeAnforderungen()
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
function AkRichtung:neu(name, eepSaveId, ampeln)
    assert(name, "Bitte geben Sie den Namen \"name\" fuer diese Richtung an.")
    assert(type(name) == "string", "Name ist kein String")
    assert(eepSaveId, "Bitte geben Sie den Wert \"eepSaveId\" fuer diese Richtung an.")
    assert(type(eepSaveId) == "number")
    assert(ampeln, "Bitte geben Sie den Wert \"ampeln\" fuer diese Richtung an.")
    --assert(signalId, "Bitte geben Sie den Wert \"signalId\" fuer diese Richtung an.")

    if eepSaveId ~= -1 then AkSpeicherHilfe.registriereId(eepSaveId, name) end
    local o = {
        fahrzeugMultiplikator = 1,
        name = name,
        eepSaveId = eepSaveId,
        ampeln = ampeln,
        schaltungsTyp = AkRichtung.SchaltungsTyp.NICHT_VERWENDET;
        verwendeZaehlAmpeln = false,
        zaehlAmpeln = {},
        verwendeZaehlStrassen = false,
        zaehlStrassen = {},
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
AkKreuzung.zeigeAnforderungenAlsInfo = AkStartMitDebug or false
AkKreuzung.zeigeSchaltungAlsInfo = AkStartMitDebug or false
AkKreuzung.zeigeSignalIdsAllerSignale = false

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
    for _, kreuzung in ipairs(AkAllKreuzungen) do
        print("[AkKreuzung ] SETZE ZURUECK: " .. kreuzung.name)
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

local aufbauHilfeErzeugt = false
--endregion
--region AkSchaltungStart

function AkKreuzung.planeSchaltungenEin()


    --- Diese Funktion sucht sich aus den Ampeln die mit der passenden Richtung
    -- raus und setzt deren Texte auf die aktuelle Schaltung
    -- @param kreuzung
    local function aktualisiereAnforderungen(kreuzung)
        local alleRichtungen = {}
        for schaltung in pairs(kreuzung:getSchaltungen()) do
            for richtung in pairs(schaltung:getRichtungen()) do
                alleRichtungen[richtung] = true
            end
            for richtung in pairs(schaltung:getRichtungenMitAnforderung()) do
                alleRichtungen[richtung] = true
            end
            for richtung in pairs(schaltung:getRichtungFuerFussgaenger()) do
                alleRichtungen[richtung] = true
            end
        end

        for richtung in pairs(alleRichtungen) do
            richtung:pruefeAnforderungen()
        end
    end


    --- Diese Funktion sucht sich aus den Ampeln die mit der passenden Richtung
    -- raus und setzt deren Texte auf die aktuelle Schaltung
    -- @param kreuzung
    local function zeigeSchaltung(kreuzung)
        aktualisiereAnforderungen(kreuzung)

        local kreuzungsAmpeln = {}
        local kreuzungsAmpelSchaltungen = {}

        local tnames = {}
        for k in pairs(kreuzung:getSchaltungen()) do table.insert(tnames, k) end

        -- sort the keys
        table.sort(tnames, function(schaltung1, schaltung2) return (schaltung1.name < schaltung2.name) end)

        for _, schaltung in ipairs(tnames) do
            for richtung in pairs(schaltung:getRichtungen()) do
                for _, ampel in pairs(richtung.ampeln) do
                    --print(schaltung.name, richtung.name, ampel.signalId, AkPhase.GRUEN)
                    kreuzungsAmpelSchaltungen[ampel.signalId] = kreuzungsAmpelSchaltungen[ampel.signalId] or {}
                    kreuzungsAmpelSchaltungen[ampel.signalId][schaltung] = AkPhase.GRUEN
                    kreuzungsAmpelSchaltungen[ampel.signalId]["richtungen"]
                    = kreuzungsAmpelSchaltungen[ampel.signalId]["richtungen"] or {}
                    kreuzungsAmpelSchaltungen[ampel.signalId]["richtungen"][richtung] = AkPhase.GRUEN
                    kreuzungsAmpeln[ampel] = true
                end
            end
            for richtung in pairs(schaltung:getRichtungenMitAnforderung()) do
                for _, ampel in pairs(richtung.ampeln) do
                    --print(schaltung.name, ampel.signalId, AkPhase.GELB)
                    kreuzungsAmpelSchaltungen[ampel.signalId] = kreuzungsAmpelSchaltungen[ampel.signalId] or {}
                    kreuzungsAmpelSchaltungen[ampel.signalId][schaltung] = AkPhase.GELB
                    kreuzungsAmpelSchaltungen[ampel.signalId]["richtungen"]
                    = kreuzungsAmpelSchaltungen[ampel.signalId]["richtungen"] or {}
                    kreuzungsAmpelSchaltungen[ampel.signalId]["richtungen"][richtung] = AkPhase.GELB
                    kreuzungsAmpeln[ampel] = true
                end
            end
            for richtung in pairs(schaltung:getRichtungFuerFussgaenger()) do
                for _, ampel in pairs(richtung.ampeln) do
                    --print(schaltung.name, ampel.signalId, AkPhase.FG)
                    kreuzungsAmpelSchaltungen[ampel.signalId] = kreuzungsAmpelSchaltungen[ampel.signalId] or {}
                    kreuzungsAmpelSchaltungen[ampel.signalId][schaltung] = AkPhase.FG
                    kreuzungsAmpelSchaltungen[ampel.signalId]["richtungen"]
                    = kreuzungsAmpelSchaltungen[ampel.signalId]["richtungen"] or {}
                    kreuzungsAmpelSchaltungen[ampel.signalId]["richtungen"][richtung] = AkPhase.FG
                    kreuzungsAmpeln[ampel] = true
                end
            end
        end

        for ampel in pairs(kreuzungsAmpeln) do
            local sortierteNamen = {}
            for k in pairs(kreuzung:getSchaltungen()) do table.insert(sortierteNamen, k) end
            table.sort(sortierteNamen, function(schaltung1, schaltung2) return (schaltung1.name < schaltung2.name) end)

            do
                local text = "<j><b>Schaltung:</b></j>"
                for _, schaltung in ipairs(sortierteNamen) do
                    local farbig = schaltung == kreuzung:getAktuelleSchaltung()
                    if kreuzungsAmpelSchaltungen[ampel.signalId][schaltung] then
                        if kreuzungsAmpelSchaltungen[ampel.signalId][schaltung] == AkPhase.GRUEN then
                            text = text .. "<br><j>" .. (farbig and fmt.hintergrund_gruen(schaltung.name .. " (Gruen)")
                                    or (schaltung.name .. " " .. fmt.hintergrund_gruen("(Gruen)")))
                        elseif kreuzungsAmpelSchaltungen[ampel.signalId][schaltung] == AkPhase.GELB then
                            text = text .. "<br><j>" .. (farbig and fmt.hintergrund_blau(schaltung.name .. " (Anf)")
                                    or (schaltung.name .. " " .. fmt.hintergrund_blau("(Anf)")))
                        elseif kreuzungsAmpelSchaltungen[ampel.signalId][schaltung] == AkPhase.FG then
                            text = text .. "<br><j>" .. (farbig and fmt.hintergrund_gelb(schaltung.name .. " (FG)")
                                    or (schaltung.name .. " " .. fmt.hintergrund_gelb("(FG)")))
                        else
                            assert(false)
                        end
                    else
                        text = text .. "<br><j>" .. (farbig and fmt.hintergrund_rot(schaltung.name .. " (Rot)")
                                or (schaltung.name .. " " .. fmt.hintergrund_rot("(Rot)")))
                    end
                end
                ampel:setzeSchaltungsInfo(text)
            end

            do
                local text = "<j><b>Richtung / Wartezeit</b></j>"
                for richtung in pairs(kreuzungsAmpelSchaltungen[ampel.signalId]["richtungen"]) do
                    text = text
                            .. "<br>"
                            .. richtung:getAnforderungsText() .. " / " .. richtung.warteZeit
                end
                ampel:setzeRichtungsInfo(text)
            end

            ampel:aktualisiereInfo()
        end
    end

    if not aufbauHilfeErzeugt then
        aufbauHilfeErzeugt = true
        for signalId = 1, 1000 do
            EEPShowInfoSignal(signalId, AkKreuzung.zeigeSignalIdsAllerSignale)
            if AkKreuzung.zeigeSignalIdsAllerSignale then
                EEPChangeInfoSignal(signalId, "<j>Signal: " .. signalId)
            end
        end
        for _, kreuzung in ipairs(AkAllKreuzungen) do
            zeigeSchaltung(kreuzung)
        end
    end


    ---------------------------
    -- Funktion schalteAmpeln
    ---------------------------
    local function AkSchalteKreuzung(kreuzung)
        --if AkKreuzung.debug then print(string.format("[AkKreuzung ] Schalte Kreuzung %s: %s",
        -- kreuzung:getName(), kreuzung:isBereit() and "Ja" or "Nein")) end
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
                if AkKreuzung.debug then
                    print("[AkKreuzung ] Setze alle Richtungen fuer " .. kreuzung.name .. " auf rot")
                end
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
                    if AkKreuzung.debug then print("[AkKreuzung ] Richtung " .. richtungDanachGruen:getName()
                            .. " wird fuer Autos auf gruen geschaltet.")
                    end
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
                    if AkKreuzung.debug then print("[AkKreuzung ] Richtung " .. richtungDanachGruen:getName()
                            .. " wird fuer FG auf gruen geschaltet.")
                    end
                end
            end

            if AkKreuzung.debug then print("[AkKreuzung ] Schalte " .. kreuzung:getName() .. " zu "
                    .. nextSchaltung:getName() .. " (" .. nextSchaltung:richtungenAlsTextZeile() .. ")")
            end
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
                if AkKreuzung.debug then print("[AkKreuzung ] " .. kreuzung.name
                        .. ": Fahrzeuge sind gefahren, kreuzung ist dann frei.")
                end
                kreuzung:setBereit(true)
            end, kreuzung.name .. " ist nun bereit (war " .. kreuzung:getGruenZeitSekunden()
                    .. "s auf gruen geschaltet)")
            AkPlaner:planeAktion(kreuzung:getGruenZeitSekunden(), kreuzungFertigschalten, neueAmpelnAufGruen)
        end
    end

    for _, kreuzung in ipairs(AkAllKreuzungen) do
        AkSchalteKreuzung(kreuzung)
        zeigeSchaltung(kreuzung)
    end
end

--endregion
