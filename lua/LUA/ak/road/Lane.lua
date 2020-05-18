print("Loading ak.road.Lane ...")

local Task = require("ak.scheduler.Task")
local Scheduler = require("ak.scheduler.Scheduler")
local StorageUtility = require("ak.storage.StorageUtility")
local TrafficLightState = require("ak.road.TrafficLightState")
local fmt = require("ak.core.eep.AkTippTextFormat")

--------------------
-- Klasse Richtung
--------------------
---@class Lane
local Lane = {}
Lane.SchaltungsTyp = {}
Lane.SchaltungsTyp.NICHT_VERWENDET = "NICHT VERWENDET"
Lane.SchaltungsTyp.ANFORDERUNG = "ANFORDERUNG"
Lane.SchaltungsTyp.NORMAL = "NORMAL"
Lane.SchaltungsTyp.FUSSGAENGER = "FUSSGAENGER"

function Lane.schalteAmpeln(lanes, phase, grund)
    assert(
        phase == TrafficLightState.GREEN or phase == TrafficLightState.REDYELLOW or phase == TrafficLightState.YELLOW or
            phase == TrafficLightState.RED or phase == TrafficLightState.PEDESTRIAN)
    for richtung in pairs(lanes) do richtung:switchTo(phase, grund) end
end

function Lane.getTyp() return "Lane" end

function Lane:getName() return self.name end

function Lane:getSchaltungsTyp() return self.schaltungsTyp end

function Lane:setSchaltungsTyp(schaltungsTyp)
    assert(schaltungsTyp)
    assert(self.schaltungsTyp == Lane.SchaltungsTyp.NICHT_VERWENDET or self.schaltungsTyp == schaltungsTyp,
           "Diese Richtung hatte schon den Schaltungstyp: '" .. self.schaltungsTyp .. "' und kann daher nicht auf '" ..
               schaltungsTyp .. "' gesetzt werden.")
    self.schaltungsTyp = schaltungsTyp
end

function Lane:pruefeAnforderungen()
    self:pruefeAnforderungenAnStrassen()
    self:pruefeAnforderungenAnSignalen()

    local text = ""
    if self.schaltungsTyp == Lane.SchaltungsTyp.NORMAL then
        text = text .. fmt.hintergrund_gruen(self.name)
    elseif self.schaltungsTyp == Lane.SchaltungsTyp.FUSSGAENGER then
        text = text .. fmt.hintergrund_gelb(self.name)
    elseif self.schaltungsTyp == Lane.SchaltungsTyp.ANFORDERUNG then
        text = text .. fmt.hintergrund_blau(self.name)
    else
        text = text .. fmt.rot(self.name)
    end

    text = text .. ": " .. (self:hasRequest() and fmt.hellgrau("BELEGT") or fmt.hellgrau("-FREI-")) .. " "
    if self.verwendeZaehlStrassen then
        text = text .. "(Strasse)"
    elseif self.verwendeZaehlAmpeln then
        text = text .. "(Ampel)"
    else
        text = text .. "(" .. self.fahrzeuge .. " gezaehlt)"
    end

    self.anforderungsText = text
    self:refreshRequests()
end

function Lane:refreshRequests() for _, ampel in pairs(self.ampeln) do ampel:refreshRequests(self) end end

function Lane:getPrio()
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

function Lane:getAnforderungsText() return self.anforderungsText or "KEINE ANFORDERUNG" end

function Lane:zaehleAnStrasseAlle(strassenId)
    self.verwendeZaehlStrassen = true
    EEPRegisterRoadTrack(strassenId)
    if not self.zaehlStrassen[strassenId] then self.zaehlStrassen[strassenId] = {} end
    return self
end

function Lane:zaehleAnStrasseBeiRoute(strassenId, route)
    self.verwendeZaehlStrassen = true
    EEPRegisterRoadTrack(strassenId)
    if not self.zaehlStrassen[strassenId] then self.zaehlStrassen[strassenId] = {} end
    self.zaehlStrassen[strassenId][route] = true
    return self
end

function Lane:pruefeAnforderungenAnStrassen()
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

function Lane:zaehleAnAmpelAlle(signalId)
    self.verwendeZaehlAmpeln = true
    assert(signalId, "Keine signalId angegeben")
    if not self.zaehlAmpeln[signalId] then self.zaehlAmpeln[signalId] = {} end
    return self
end

function Lane:zaehleAnAmpelBeiRoute(signalId, route)
    self.verwendeZaehlAmpeln = true
    if not self.zaehlAmpeln[signalId] then self.zaehlAmpeln[signalId] = {} end
    self.zaehlAmpeln[signalId][route] = true
    return self
end

function Lane:pruefeAnforderungenAnSignalen()
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

function Lane:betritt()
    self.fahrzeuge = self.fahrzeuge + 1
    self:refreshRequests()
    self:save()
end

function Lane:verlasse(signalaufrot, fahrzeugName)
    self.fahrzeuge = self.fahrzeuge - 1
    if self.fahrzeuge < 0 then self.fahrzeuge = 0 end
    self:refreshRequests()
    self:save()

    if signalaufrot and not self:hasRequest() then
        local lanes = {}
        lanes[self] = true

        Lane.schalteAmpeln(lanes, TrafficLightState.YELLOW, "Fahrzeug verlassen: " .. fahrzeugName)

        local toRed = Task:new(function()
            Lane.schalteAmpeln(lanes, TrafficLightState.RED, "Fahrzeug verlassen: " .. fahrzeugName)
        end, "Schalte " .. self.name .. " auf rot.")
        Scheduler:scheduleTask(2, toRed)
    end
end

function Lane:setzeFahrzeugeZurueck()
    self.fahrzeuge = 0
    self:refreshRequests()
    self:save()
end

function Lane:erhoeheWartezeit()
    self.warteZeit = self.warteZeit + 1
    self:save()
end

function Lane:setzeWartezeitZurueck()
    self.warteZeit = 0
    self:save()
end

function Lane:hasRequest() return self.fahrzeuge > 0 or self.anforderungAnSignal or self.anforderungAnStrasse end

function Lane:save()
    if self.eepSaveId ~= -1 then
        local data = {}
        data["f"] = tostring(self.fahrzeuge)
        data["w"] = tostring(self.warteZeit)
        data["p"] = tostring(self.phase)
        StorageUtility.saveTable(self.eepSaveId, data, "Lane " .. self.name)
    end
end

function Lane:load()
    if self.eepSaveId ~= -1 then
        local data = StorageUtility.ladeTabelle(self.eepSaveId, "Lane " .. self.name)
        self.fahrzeuge = data["f"] and tonumber(data["f"]) or 0
        self.warteZeit = data["w"] and tonumber(data["w"]) or 0
        self.phase = data["p"] or TrafficLightState.RED
        self:pruefeAnforderungen()
        self:switchTo(self.phase, "Neu geladen")
    else
        self.fahrzeuge = 0
        self.warteZeit = 0
        self.phase = TrafficLightState.RED
    end
end

function Lane:getWarteZeit() return self.warteZeit end

function Lane:getFahrzeuge() return self.fahrzeuge end

function Lane:getRichtungSaveId() return self.richtungSaveId end

function Lane:getLaneInfo() return self.laneInfo end

function Lane:setFahrzeugMultiplikator(fahrzeugMultiplikator)
    self.fahrzeugMultiplikator = fahrzeugMultiplikator
    return self
end

function Lane:switchTo(phase, grund)
    for _, ampel in pairs(self.ampeln) do ampel:switchTo(phase, grund) end
    self.phase = phase
end

function Lane:setRichtungen(...) self.directions = ... or {"LEFT", "STRAIGHT", "RIGHT"} end

function Lane:setTrafficType(trafficType)
    if trafficType ~= "TRAM" and trafficType ~= "PEDESTRIAN" and trafficType ~= "NORMAL" then
        print("No such traffic type: " .. trafficType)
    else
        self.trafficType = trafficType
    end
end

--- Erzeugt eine Richtung, welche durch eine Ampel gesteuert wird.
-- @param name Name der Richtung einer Kreuzung
-- @param eepSaveId Id fuer das Speichern der Richtung
-- @param ... eine oder mehrere Ampeln
--
function Lane:new(name, eepSaveId, ampeln, directions, trafficType)
    assert(name, 'Bitte geben Sie den Namen "name" fuer diese Richtung an.')
    assert(type(name) == "string", "Name ist kein String")
    assert(eepSaveId, 'Bitte geben Sie den Wert "eepSaveId" fuer diese Richtung an.')
    assert(type(eepSaveId) == "number")
    assert(ampeln, 'Bitte geben Sie den Wert "ampeln" fuer diese Richtung an.')
    -- assert(signalId, "Bitte geben Sie den Wert \"signalId\" fuer diese Richtung an.")
    if eepSaveId ~= -1 then StorageUtility.registriereId(eepSaveId, "Richtung " .. name) end
    local o = {
        fahrzeugMultiplikator = 1,
        name = name,
        eepSaveId = eepSaveId,
        ampeln = ampeln,
        schaltungsTyp = Lane.SchaltungsTyp.NICHT_VERWENDET,
        verwendeZaehlAmpeln = false,
        zaehlAmpeln = {},
        verwendeZaehlStrassen = false,
        zaehlStrassen = {},
        directions = directions or {"LEFT", "STRAIGHT", "RIGHT"},
        trafficType = trafficType or "NORMAL"
    }

    self.__index = self
    setmetatable(o, self)
    o:load()
    return o
end

return Lane
