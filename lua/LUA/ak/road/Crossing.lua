print("Loading ak.road.Crossing ...")

local Task = require("ak.scheduler.Task")
local Scheduler = require("ak.scheduler.Scheduler")
local CrossingCircuit = require("ak.road.CrossingCircuit")
local Lane = require("ak.road.Lane")
local TrafficLightState = require("ak.road.TrafficLightState")
local fmt = require("ak.core.eep.AkTippTextFormat")

--------------------
-- Klasse Kreuzung
--------------------
local AkAllKreuzungen = {}
---@class Crossing
---@field public name string @Intersection Name
---@field private aktuelleSchaltung CrossingCircuit @Currently used switching
---@field private schaltungen CrossingCircuit[] @All switchings of the intersection
---@field private bereit boolean @If true, the Intersection can be switched
---@field private geschaltet boolean @If true, the intersection is switched
---@field private gruenZeit number @Integer value of how long the intersection will show green light
---@field private staticCams table @List of static cams
local Crossing = {}
Crossing.debug = AkStartMitDebug or false
---@type table<string,Crossing>
Crossing.alleKreuzungen = {}
Crossing.zeigeAnforderungenAlsInfo = AkStartMitDebug or false
Crossing.zeigeSchaltungAlsInfo = AkStartMitDebug or false
Crossing.zeigeSignalIdsAllerSignale = false

function Crossing.setZeigeAnforderungenAlsInfo(value)
    assert(value == true or value == false)
    Crossing.zeigeAnforderungenAlsInfo = value
end

function Crossing.setZeigeSchaltungAlsInfo(value)
    assert(value == true or value == false)
    Crossing.zeigeSchaltungAlsInfo = value
end

function Crossing.setZeigeSignalIdsAllerSignale(value)
    assert(value == true or value == false)
    Crossing.zeigeSignalIdsAllerSignale = value
end

function Crossing.schalteManuell(nameDerKreuzung, nameDerSchaltung)
    print("schalteManuell:" .. nameDerKreuzung .. "/" .. nameDerSchaltung)
    ---@type Crossing
    local k = Crossing.alleKreuzungen[nameDerKreuzung]
    if k then
        k:setManuelleSchaltung(nameDerSchaltung)
    end
end

function Crossing.schalteAutomatisch(nameDerKreuzung)
    print("schalteAutomatisch:" .. nameDerKreuzung)
    ---@type Crossing
    local k = Crossing.alleKreuzungen[nameDerKreuzung]
    if k then
        k:setAutomatikModus()
    end
end

function Crossing.getTyp()
    return "Crossing"
end

function Crossing:getName()
    return self.name
end

function Crossing:getSchaltungen()
    return self.schaltungen
end

function Crossing:getAktuelleSchaltung()
    return self.aktuelleSchaltung
end

function Crossing:setzeWarteZeitZurueck(nextSchaltung)
    local increaseRichtungen = {}
    for schaltung in pairs(self.schaltungen) do
        assert(schaltung.getTyp() == "CrossingCircuit", "Found: " .. schaltung.getTyp())
        for richtung in pairs(schaltung:getNormaleRichtungen()) do
            assert(richtung.getTyp() == "Lane", "Found: " .. richtung.getTyp())
            if nextSchaltung:getNormaleRichtungen()[richtung] then
                richtung:setzeWartezeitZurueck()
            else
                increaseRichtungen[richtung] = true
            end
        end
    end

    for richtung in pairs(increaseRichtungen) do
        assert(richtung.getTyp() == "Lane", "Found: " .. richtung.getTyp())
        richtung:erhoeheWartezeit()
    end
    self.aktuelleSchaltung = nextSchaltung
end

function Crossing:getNextSchaltung()
    return self.nextSchaltung
end

function Crossing:calculateNextSchaltung()
    if self.manuelleSchaltung then
        self.nextSchaltung = self.manuelleSchaltung
    else
        local sortedTable = {}
        for schaltung in pairs(self.schaltungen) do
            table.insert(sortedTable, schaltung)
        end
        table.sort(sortedTable, CrossingCircuit.hoeherePrioAls)
        self.nextSchaltung = sortedTable[1]
    end
    return self.nextSchaltung
end

function Crossing:setManuelleSchaltung(nameDerSchaltung)
    for schaltung in pairs(self.schaltungen) do
        if schaltung.name == nameDerSchaltung then
            self.manuelleSchaltung = schaltung
            print("Manuell geschaltet auf: " .. nameDerSchaltung .. " (" .. self.name .. "')")
            self:setBereit(true)
        end
    end
end

function Crossing:setAutomatikModus()
    self.manuelleSchaltung = nil
    self:setBereit(true)
    print("Automatikmodus aktiviert. (" .. self.name .. "')")
end

function Crossing:fuegeSchaltungHinzu(schaltung)
    self.schaltungen[schaltung] = true
end

function Crossing:setBereit(bereit)
    self.bereit = bereit
end

function Crossing:isBereit()
    return self.bereit
end

function Crossing:setGeschaltet(geschaltet)
    self.geschaltet = geschaltet
end

function Crossing:isGeschaltet()
    return self.geschaltet
end

function Crossing:getGruenZeitSekunden()
    return self.gruenZeit
end

function Crossing:fuegeStatischeKameraHinzu(kameraName)
    table.insert(self.staticCams, kameraName)
end

function Crossing.zaehlerZuruecksetzen()
    for _, kreuzung in ipairs(AkAllKreuzungen) do
        print("[Crossing ] SETZE ZURUECK: " .. kreuzung.name)
        for schaltung in pairs(kreuzung:getSchaltungen()) do
            for richtung in pairs(schaltung:getNormaleRichtungen()) do
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
---@return Crossing
function Crossing:neu(name)
    local o = {
        name = name,
        aktuelleSchaltung = nil,
        schaltungen = {},
        bereit = true,
        geschaltet = true,
        gruenZeit = 15,
        staticCams = {}
    }
    self.__index = self
    setmetatable(o, self)
    table.insert(AkAllKreuzungen, o)
    table.sort(
        AkAllKreuzungen,
        function(int1, int2)
            return int1.name < int2.name
        end
    )
    Crossing.alleKreuzungen[name] = o
    return o
end

local aufbauHilfeErzeugt = Crossing.zeigeSignalIdsAllerSignale

function Crossing.planeSchaltungenEin()
    --- Diese Funktion sucht sich aus den Ampeln die mit der passenden Richtung
    -- raus und setzt deren Texte auf die aktuelle Schaltung
    -- @param kreuzung
    local function aktualisiereAnforderungen(kreuzung)
        local alleRichtungen = {}
        for schaltung in pairs(kreuzung:getSchaltungen()) do
            for richtung in pairs(schaltung:getNormaleRichtungen()) do
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
        for k in pairs(kreuzung:getSchaltungen()) do
            table.insert(tnames, k)
        end

        -- sort the keys
        table.sort(
            tnames,
            function(schaltung1, schaltung2)
                return (schaltung1.name < schaltung2.name)
            end
        )
        for _, schaltung in ipairs(tnames) do
            for richtung in pairs(schaltung:getNormaleRichtungen()) do
                for _, ampel in pairs(richtung.ampeln) do
                    --print(schaltung.name, richtung.name, ampel.signalId, TrafficLightState.GRUEN)
                    kreuzungsAmpelSchaltungen[ampel.signalId] = kreuzungsAmpelSchaltungen[ampel.signalId] or {}
                    kreuzungsAmpelSchaltungen[ampel.signalId][schaltung] = TrafficLightState.GRUEN
                    kreuzungsAmpelSchaltungen[ampel.signalId]["richtungen"] =
                        kreuzungsAmpelSchaltungen[ampel.signalId]["richtungen"] or {}
                    kreuzungsAmpelSchaltungen[ampel.signalId]["richtungen"][richtung] = TrafficLightState.GRUEN
                    kreuzungsAmpeln[ampel] = true
                end
            end
            for richtung in pairs(schaltung:getRichtungenMitAnforderung()) do
                for _, ampel in pairs(richtung.ampeln) do
                    --print(schaltung.name, ampel.signalId, TrafficLightState.GELB)
                    kreuzungsAmpelSchaltungen[ampel.signalId] = kreuzungsAmpelSchaltungen[ampel.signalId] or {}
                    kreuzungsAmpelSchaltungen[ampel.signalId][schaltung] = TrafficLightState.GELB
                    kreuzungsAmpelSchaltungen[ampel.signalId]["richtungen"] =
                        kreuzungsAmpelSchaltungen[ampel.signalId]["richtungen"] or {}
                    kreuzungsAmpelSchaltungen[ampel.signalId]["richtungen"][richtung] = TrafficLightState.GELB
                    kreuzungsAmpeln[ampel] = true
                end
            end
            for richtung in pairs(schaltung:getRichtungFuerFussgaenger()) do
                for _, ampel in pairs(richtung.ampeln) do
                    --print(schaltung.name, ampel.signalId, TrafficLightState.FG)
                    kreuzungsAmpelSchaltungen[ampel.signalId] = kreuzungsAmpelSchaltungen[ampel.signalId] or {}
                    kreuzungsAmpelSchaltungen[ampel.signalId][schaltung] = TrafficLightState.FG
                    kreuzungsAmpelSchaltungen[ampel.signalId]["richtungen"] =
                        kreuzungsAmpelSchaltungen[ampel.signalId]["richtungen"] or {}
                    kreuzungsAmpelSchaltungen[ampel.signalId]["richtungen"][richtung] = TrafficLightState.FG
                    kreuzungsAmpeln[ampel] = true
                end
            end
        end

        for ampel in pairs(kreuzungsAmpeln) do
            local sortierteNamen = {}
            for k in pairs(kreuzung:getSchaltungen()) do
                table.insert(sortierteNamen, k)
            end
            table.sort(
                sortierteNamen,
                function(schaltung1, schaltung2)
                    return (schaltung1.name < schaltung2.name)
                end
            )
            do
                local text = "<j><b>Schaltung:</b></j>"
                for _, schaltung in ipairs(sortierteNamen) do
                    local farbig = schaltung == kreuzung:getAktuelleSchaltung()
                    if kreuzungsAmpelSchaltungen[ampel.signalId][schaltung] then
                        if kreuzungsAmpelSchaltungen[ampel.signalId][schaltung] == TrafficLightState.GRUEN then
                            text =
                                text ..
                                "<br><j>" ..
                                (farbig and fmt.hintergrund_gruen(schaltung.name .. " (Gruen)") or
                                (schaltung.name .. " " .. fmt.hintergrund_gruen("(Gruen)")))
                        elseif kreuzungsAmpelSchaltungen[ampel.signalId][schaltung] == TrafficLightState.GELB then
                            text =
                                text ..
                                "<br><j>" ..
                                (farbig and fmt.hintergrund_blau(schaltung.name .. " (Anf)") or
                                (schaltung.name .. " " .. fmt.hintergrund_blau("(Anf)")))
                        elseif kreuzungsAmpelSchaltungen[ampel.signalId][schaltung] == TrafficLightState.FG then
                            text =
                                text ..
                                "<br><j>" ..
                                (farbig and fmt.hintergrund_gelb(schaltung.name .. " (FG)") or
                                (schaltung.name .. " " .. fmt.hintergrund_gelb("(FG)")))
                        else
                            assert(false)
                        end
                    else
                        text =
                            text ..
                            "<br><j>" ..
                            (farbig and fmt.hintergrund_rot(schaltung.name .. " (Rot)") or
                            (schaltung.name .. " " .. fmt.hintergrund_rot("(Rot)")))
                    end
                end
                ampel:setzeSchaltungsInfo(text)
            end

            do
                local text = "<j><b>Richtung / Wartezeit</b></j>"
                for richtung in pairs(kreuzungsAmpelSchaltungen[ampel.signalId]["richtungen"]) do
                    text = text .. "<br>" .. richtung:getAnforderungsText() .. " / " .. richtung.warteZeit
                end
                ampel:setzeRichtungsInfo(text)
            end

            ampel:aktualisiereInfo()
        end
    end

    if aufbauHilfeErzeugt ~= Crossing.zeigeSignalIdsAllerSignale then
        aufbauHilfeErzeugt = Crossing.zeigeSignalIdsAllerSignale
        for signalId = 1, 1000 do
            EEPShowInfoSignal(signalId, Crossing.zeigeSignalIdsAllerSignale)
            if Crossing.zeigeSignalIdsAllerSignale then
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
        --if Crossing.debug then print(string.format("[Crossing ] Schalte Kreuzung %s: %s",
        -- kreuzung:getName(), kreuzung:isBereit() and "Ja" or "Nein")) end
        if kreuzung:isBereit() and kreuzung:isGeschaltet() then
            kreuzung:setGeschaltet(false)
            kreuzung:setBereit(false)
            local nextSchaltung = kreuzung:calculateNextSchaltung()
            local nextName = kreuzung.name .. " " .. nextSchaltung:getName()
            local aktuelleSchaltung = kreuzung:getAktuelleSchaltung()
            local currentName =
                aktuelleSchaltung and kreuzung.name .. " " .. aktuelleSchaltung:getName() or
                kreuzung.name .. " Rot fuer alle"
            local richtungenAufRot = {}
            local richtungenAufGruen = {}
            local richtungenAufFussgaengerRot = {}
            local richtungenAufFussgaengerGruen = {}
            local richtungenAktuellGruen = {}
            local richtungenAktuellFussgaengerGruen = {}

            -- aktuelle Richtungen fùr alle Schaltungen auf rot schalten:
            if aktuelleSchaltung then
                for richtung in pairs(aktuelleSchaltung:getNormaleRichtungen()) do
                    richtungenAktuellGruen[richtung] = true
                    richtungenAufRot[richtung] = true
                end
                for richtung in pairs(aktuelleSchaltung.richtungenFuerFussgaenger) do
                    richtungenAktuellFussgaengerGruen[richtung] = true
                    richtungenAufFussgaengerRot[richtung] = true
                end
            else
                -- Wenn es keine aktuellen Richtung gibt, mùssen alle auf rot gesetzt werden:
                if Crossing.debug then
                    print("[Crossing ] Setze alle Richtungen fuer " .. kreuzung.name .. " auf rot")
                end
                for schaltung in pairs(kreuzung:getSchaltungen()) do
                    for richtung in pairs(schaltung:getNormaleRichtungen()) do
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
                        if Crossing.debug then
                            print(
                                "[Crossing ] Plane neue Ampel " ..
                                richtungDanachGruen.eepSaveId .. " auf Gruen: " .. richtungDanachGruen:getName()
                        )
                        end
                        richtungenAufGruen[richtungDanachGruen] = true
                    end
                end
            end

            -- "Normale" Richtungen werden immer geschaltet
            for richtungDanachGruen in pairs(nextSchaltung:getNormaleRichtungen()) do
                if richtungenAktuellGruen[richtungDanachGruen] then
                    -- Ampel nicht auf rot schalten, da sie in der naechsten Schaltung enthalten ist
                    richtungenAufRot[richtungDanachGruen] = nil
                else
                    if Crossing.debug then
                        print(
                            "[Crossing ] Richtung " ..
                            richtungDanachGruen:getName() .. " wird fuer Autos auf gruen geschaltet."
                    )
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
                    if Crossing.debug then
                        print(
                            "[Crossing ] Richtung " ..
                            richtungDanachGruen:getName() .. " wird fuer FG auf gruen geschaltet."
                    )
                    end
                end
            end

            if Crossing.debug then
                print(
                    "[Crossing ] Schalte " ..
                    kreuzung:getName() ..
                    " zu " .. nextSchaltung:getName() .. " (" .. nextSchaltung:richtungenAlsTextZeile() .. ")"
            )
            end

            local fussgaengerAufRot =
                Task:neu(
                    function()
                        Lane.schalteAmpeln(richtungenAufFussgaengerRot, TrafficLightState.ROT, currentName)
                    end,
                    "Schalte " .. currentName .. " auf Fussgaenger Rot"
            )
            Scheduler:scheduleTask(3, fussgaengerAufRot)

            local alteAmpelnAufGelb =
                Task:neu(
                    function()
                        Lane.schalteAmpeln(richtungenAufRot, TrafficLightState.GELB, currentName)
                    end,
                    "Schalte " .. currentName .. " auf gelb"
            )
            Scheduler:scheduleTask(0, alteAmpelnAufGelb, fussgaengerAufRot)

            local alteAmpelnAufRot =
                Task:neu(
                    function()
                        Lane.schalteAmpeln(richtungenAufRot, TrafficLightState.ROT, currentName)
                        kreuzung:setzeWarteZeitZurueck(nextSchaltung)
                    end,
                    "Schalte " .. currentName .. " auf rot"
            )
            Scheduler:scheduleTask(2, alteAmpelnAufRot, alteAmpelnAufGelb)

            local neueAmpelnAufRotGelb =
                Task:neu(
                    function()
                        Lane.schalteAmpeln(richtungenAufGruen, TrafficLightState.ROTGELB, nextName)
                        Lane.schalteAmpeln(richtungenAufFussgaengerGruen, TrafficLightState.FG, nextName)
                    end,
                    "Schalte " .. nextName .. " auf rot-gelb"
            )
            Scheduler:scheduleTask(3, neueAmpelnAufRotGelb, alteAmpelnAufRot)

            local neueAmpelnAufGruen =
                Task:neu(
                    function()
                        Lane.schalteAmpeln(richtungenAufGruen, TrafficLightState.GRUEN, nextName)
                        kreuzung:setGeschaltet(true)
                    end,
                    "Schalte " .. nextName .. " auf gruen"
            )
            Scheduler:scheduleTask(1, neueAmpelnAufGruen, neueAmpelnAufRotGelb)

            local kreuzungFertigSchalten =
                Task:neu(
                    function()
                        if Crossing.debug then
                            print("[Crossing ] " .. kreuzung.name
                                .. ": Fahrzeuge sind gefahren, kreuzung ist dann frei.")
                        end
                        kreuzung:setBereit(true)
                    end,
                    kreuzung.name .. " ist nun bereit (war "
                    .. kreuzung:getGruenZeitSekunden() .. "s auf gruen geschaltet)"
            )
            Scheduler:scheduleTask(kreuzung:getGruenZeitSekunden(), kreuzungFertigSchalten, neueAmpelnAufGruen)
        end
    end

    for _, kreuzung in ipairs(AkAllKreuzungen) do
        AkSchalteKreuzung(kreuzung)
        zeigeSchaltung(kreuzung)
    end
end

return Crossing
