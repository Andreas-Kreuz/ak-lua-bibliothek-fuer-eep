print("Lade ak.road.TrafficLight ...")

local Crossing = require("ak.road.Crossing")
local AxisStructureTrafficLight = require("ak.road.AxisStructureTrafficLight")
local LightStructureTrafficLight = require("ak.road.LightStructureTrafficLight")
local TrafficLightState = require("ak.road.TrafficLightState")
local fmt = require("ak.core.eep.AkTippTextFormat")

------------------------------------------------------------------------------------------
-- Klasse TrafficLight
-- Ampel mit einer festen signalId und einem festen Ampeltyp
-- Optional kann die Ampel bei Immobilien Licht ein- und ausschalten (Straba - Ampelsatz)
------------------------------------------------------------------------------------------
local TrafficLight = {}
TrafficLight.debug = AkStartMitDebug or false
local registeredSignals = {}

---
-- @param signalId ID der Ampel auf der Anlage (Eine Ampel von diesem Typ sollte auf der Anlage sein
-- @param ampelTyp Typ der Ampel (TrafficLightModel)
-- @param rotImmo Immobilie fuer Signalbild gelb (Licht an / aus)
-- @param gruenImmo Immobilie fuer Signalbild gelb (Licht an / aus)
-- @param gelbImmo Immobilie fuer Signalbild gelb (Licht an / aus)
-- @param anforderungImmo Immobilie fuer Signalbild "A" (Licht an / aus)
--
function TrafficLight:neu(signalId, ampelTyp, rotImmo, gruenImmo, gelbImmo, anforderungImmo)
    assert(signalId, "Specify a signalId")
    assert(ampelTyp, "Specify a ampelTyp")
    local error = string.format("Signal ID already used: %s - %s", signalId, ampelTyp.name)
    assert(
        not registeredSignals[tostring(signalId)] or registeredSignals[tostring(signalId)].ampelTyp == ampelTyp,
        error
    )
    EEPShowInfoSignal(signalId, false)
    local o = {
        signalId = signalId,
        ampelTyp = ampelTyp,
        phase = TrafficLightState.ROT,
        anforderung = false,
        debug = false,
        richtungsInfo = "",
        schaltungsInfo = "",
        aufbauInfo = "" .. tostring(signalId),
        richtungen = {},
        lichtImmos = {},
        achsenImmos = {}
    }
    self.__index = self
    o = setmetatable(o, self)

    if rotImmo or gruenImmo or gelbImmo or anforderungImmo then
        o:fuegeLichtImmoHinzu(rotImmo, gruenImmo, gelbImmo, anforderungImmo)
    end

    registeredSignals[tostring(signalId)] = o
    return o
end

--- Schaltet das Licht der angegebenen Immobilien beim Schalten der Ampel auf rot, gelb, grün oder Anforderung
-- @param rotImmo Name der Immobilie, deren Licht eingeschaltet wird, wenn die Ampel rot oder rot-gelb ist
-- @param gruenImmo Name der Immobilie,  deren Licht eingeschaltet wird, wenn die Ampel grün ist
-- @param gelbImmo Name der Immobilie,  deren Licht eingeschaltet wird, wenn die Ampel gelb oder rot-gelb ist
-- @param anforderungImmo Name der Immobilie,  deren Licht eingeschaltet wird, wenn die Ampel eine Anforderung erkennt
--
function TrafficLight:fuegeLichtImmoHinzu(rotImmo, gruenImmo, gelbImmo, anforderungImmo)
    local lichtAmpel = LightStructureTrafficLight:neu(rotImmo, gruenImmo, gelbImmo, anforderungImmo)
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
function TrafficLight:fuegeAchsenImmoHinzu(
    immoName,
    achsName,
    grundStellung,
    stellungRot,
    stellungGruen,
    stellungGelb,
    stellungFG)
    local achsAmpel =
        AxisStructureTrafficLight:neu(immoName, achsName, grundStellung, stellungRot, stellungGruen, stellungGelb, stellungFG)
    self.achsenImmos[achsAmpel] = true
    return self
end

--- Aktualisiert den Text für die aktuellen Schaltung dieser Ampel
-- @param schaltungsInfo TippText für die Schaltung
--
function TrafficLight:setzeSchaltungsInfo(schaltungsInfo)
    self.schaltungsInfo = schaltungsInfo
end

--- Aktualsisiert den Text für die Richtungen dieser Ampel
-- @param richtungsInfo TippText für die Richtung
--
function TrafficLight:setzeRichtungsInfo(richtungsInfo)
    self.richtungsInfo = richtungsInfo
end

--- Stellt die vorher gesetzten Tipp-Texte dar.
--
function TrafficLight:aktualisiereInfo()
    local showRequests = Crossing.zeigeAnforderungenAlsInfo
    local showSwitching = Crossing.zeigeSchaltungAlsInfo
    local showAllSignals = Crossing.zeigeSignalIdsAllerSignale
    local zeigeInfo = showRequests or showSwitching or showAllSignals

    EEPShowInfoSignal(self.signalId, zeigeInfo)
    if zeigeInfo then
        local infoText = "<j><b>Ampel ID: " .. fmt.hintergrund_grau(self.signalId) .. "</b></j>"
        infoText = infoText .. "<br>" .. self.ampelTyp.name

        if Crossing.zeigeSchaltungAlsInfo then
            if infoText:len() > 0 then
                infoText = infoText .. "<br>___________________________<br>"
            end
            infoText = infoText .. self.schaltungsInfo
        end

        if showSwitching and self.phase and self.grund then
            if infoText:len() > 0 then
                infoText = infoText .. "<br><br>"
            end
            infoText = infoText .. " " .. self.phase .. " (" .. self.grund .. ")"
        end

        if showRequests then
            if infoText:len() > 0 then
                infoText = infoText .. "<br>___________________________<br>"
            end
            infoText = infoText .. self.richtungsInfo
        end
        assert(infoText:len() < 1023)
        EEPChangeInfoSignal(self.signalId, infoText)
    end
end

---
-- @param signalId ID der Ampel auf der Anlage (Eine Ampel von diesem Typ sollte auf der Anlage sein)
-- @param phase TrafficLightState.xxx
-- @param grund z.B. Name der Schaltung
--
function TrafficLight:schalte(phase, grund)
    assert(phase)
    self.phase = phase
    local immoLichtDbg = self:schalteImmoLicht()
    local immoAchseDbg = self:schalteImmoAchsen()

    local sigIndex = self.ampelTyp:signalIndexFuer(self.phase)
    if (self.debug or TrafficLight.debug) then
        print(
            string.format("[TrafficLight    ] Schalte Ampel %04d auf %s (%01d)", self.signalId, self.phase, sigIndex) ..
                immoLichtDbg .. immoAchseDbg .. " - " .. grund
        )
    end
    self:schalteSignal(sigIndex)
end

function TrafficLight:schalteImmoLicht()
    local immoDbg = ""
    for lichtAmpel in pairs(self.lichtImmos) do
        if lichtAmpel.rotImmo then
            immoDbg =
                immoDbg ..
                string.format(
                    ", Licht in %s: %s",
                    lichtAmpel.rotImmo,
                    (self.phase == TrafficLightState.ROT or self.phase == TrafficLightState.ROTGELB) and "an" or "aus"
                )
            EEPStructureSetLight(lichtAmpel.rotImmo, self.phase == TrafficLightState.ROT or self.phase == TrafficLightState.ROTGELB)
        end
        if lichtAmpel.gelbImmo then
            immoDbg =
                immoDbg ..
                string.format(
                    ", Licht in %s: %s",
                    lichtAmpel.gelbImmo,
                    (self.phase == TrafficLightState.GELB or self.phase == TrafficLightState.ROTGELB) and "an" or "aus"
                )
            EEPStructureSetLight(lichtAmpel.gelbImmo, self.phase == TrafficLightState.GELB or self.phase == TrafficLightState.ROTGELB)
        end
        if lichtAmpel.gruenImmo then
            immoDbg =
                immoDbg ..
                string.format(
                    ", Licht in %s: %s",
                    lichtAmpel.gruenImmo,
                    (self.phase == TrafficLightState.GRUEN) and "an" or "aus"
                )
            EEPStructureSetLight(lichtAmpel.gruenImmo, self.phase == TrafficLightState.GRUEN)
        end
    end
    return immoDbg
end

function TrafficLight:schalteImmoAchsen()
    local immoDbg = ""
    for achsenAmpel in pairs(self.achsenImmos) do
        local achsStellung = achsenAmpel.grundStellung

        if achsenAmpel.stellungRotGelb and self.phase == TrafficLightState.ROTGELB then
            achsStellung = achsenAmpel.stellungRotGelb
        elseif achsenAmpel.stellungGelb and (self.phase == TrafficLightState.GELB or self.phase == TrafficLightState.ROTGELB) then
            achsStellung = achsenAmpel.stellungGelb
        elseif achsenAmpel.stellungRot and self.phase == TrafficLightState.ROT then
            achsStellung = achsenAmpel.stellungRot
        elseif achsenAmpel.stellungGruen and self.phase == TrafficLightState.GRUEN then
            achsStellung = achsenAmpel.stellungGruen
        elseif achsenAmpel.stellungFG and self.phase == TrafficLightState.FG then
            achsStellung = achsenAmpel.stellungFG
        end

        immoDbg =
            immoDbg .. string.format(", Achse %s in %s auf: %d", achsenAmpel.achse, achsenAmpel.immoName, achsStellung)
        EEPStructureSetAxis(achsenAmpel.immoName, achsenAmpel.achse, achsStellung)
    end
    return immoDbg
end

function TrafficLight:schalteSignal(sigIndex)
    EEPSetSignal(self.signalId, sigIndex, 1)
end

--- Setzt die Anforderung fuer eine Ampel (damit sie weiß, ob eine Anforderung vorliegt)
-- @param anforderung - true oder false
-- @param richtung - Lane, für welche die Anforderung vorliegt
function TrafficLight:aktualisiereAnforderung(richtung)
    local immoDbg = ""
    self.richtungen[richtung] = true
    local anforderung = richtung:anforderungVorhanden()

    for lichtAmpel in pairs(self.lichtImmos) do
        if lichtAmpel.anforderungImmo then
            immoDbg =
                immoDbg ..
                string.format(", Licht in %s: %s", lichtAmpel.anforderungImmo, (anforderung) and "an" or "aus")
            EEPStructureSetLight(lichtAmpel.anforderungImmo, anforderung)
        end
    end

    if (self.debug or TrafficLight.debug) and immoDbg ~= "" then
        print(string.format("[TrafficLight    ] Schalte Ampel %04d", self.signalId) .. immoDbg)
    end
    self:aktualisiereInfo()
end

function TrafficLight:print()
    print(string.format("[TrafficLight    ] Ampel %04d: %s (%s)", self.signalId, self.phase, self.ampelTyp.name))
end

return TrafficLight
