print("Lade ak.strasse.AkRichtung ...")

local AkAktion = require("ak.planer.AkAktion")
local AkSpeicherHilfe = require("ak.speicher.AkSpeicher")
local AkPhase = require("ak.strasse.AkPhase")

--------------------
-- Klasse Richtung
--------------------
local AkRichtung = {}
AkRichtung.SchaltungsTyp = {}
AkRichtung.SchaltungsTyp.NICHT_VERWENDET = "NICHT VERWENDET"
AkRichtung.SchaltungsTyp.ANFORDERUNG = "ANFORDERUNG"
AkRichtung.SchaltungsTyp.NORMAL = "NORMAL"
AkRichtung.SchaltungsTyp.FUSSGAENGER = "FUSSGAENGER"

function AkRichtung.schalteAmpeln(ampeln, phase, grund)
    assert(phase == AkPhase.GRUEN
            or phase == AkPhase.ROTGELB
            or phase == AkPhase.GELB
            or phase == AkPhase.ROT
            or phase == AkPhase.FG)

    for richtung in pairs(ampeln) do
        richtung:schalte(phase, grund)
    end
end

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

        AkRichtung.schalteAmpeln(richtungen, AkPhase.GELB, "Fahrzeug verlassen: " .. fahrzeugName)

        local toRed = AkAktion:neu(function()
            AkRichtung.schalteAmpeln(richtungen, AkPhase.ROT, "Fahrzeug verlassen: " .. fahrzeugName)
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
function AkRichtung:neu(name, eepSaveId, ampeln, richtungen, trafficType)
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
        richtungen = richtungen or { 'LEFT', 'STRAIGHT', 'RIGHT', },
        trafficType = trafficType or 'NORMAL',
    }


    self.__index = self
    setmetatable(o, self)
    o:load()
    return o
end


return AkRichtung

