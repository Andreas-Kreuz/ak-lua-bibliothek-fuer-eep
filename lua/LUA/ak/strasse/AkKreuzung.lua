print("Lade ak.strasse.AkKreuzung ...")

local AkAktion = require("ak.planer.AkAktion")
local AkPlaner = require("ak.planer.AkPlaner")
local AkKreuzungsSchaltung = require("ak.strasse.AkKreuzungsSchaltung")
local AkRichtung = require("ak.strasse.AkRichtung")
local AkPhase = require("ak.strasse.AkPhase")
local fmt = require("ak.core.eep.AkTippTextFormat")

--------------------
-- Klasse Kreuzung
--------------------
local AkAllKreuzungen = {}
---@class AkKreuzung
---@field public name string @Intersection Name
---@field private aktuelleSchaltung AkKreuzungsSchaltung @Currently used switching
---@field private schaltungen AkKreuzungsSchaltung[] @All switchings of the intersection
---@field private bereit boolean @If true, the Intersection can be switched
---@field private geschaltet boolean @If true, the intersection is switched
---@field private gruenZeit number @Integer value of how long the intersection will show green light
---@field private staticCams table @List of static cams
local AkKreuzung = {}
AkKreuzung.debug = AkStartMitDebug or false
---@type table<string,AkKreuzung>
AkKreuzung.alleKreuzungen = {}
AkKreuzung.zeigeAnforderungenAlsInfo = AkStartMitDebug or false
AkKreuzung.zeigeSchaltungAlsInfo = AkStartMitDebug or false
AkKreuzung.zeigeSignalIdsAllerSignale = false

function AkKreuzung.setZeigeAnforderungenAlsInfo(value)
    assert(value == true or value == false)
    AkKreuzung.zeigeAnforderungenAlsInfo = value
end

function AkKreuzung.setZeigeSchaltungAlsInfo(value)
    assert(value == true or value == false)
    AkKreuzung.zeigeSchaltungAlsInfo = value
end

function AkKreuzung.setZeigeSignalIdsAllerSignale(value)
    assert(value == true or value == false)
    AkKreuzung.zeigeSignalIdsAllerSignale = value
end

function AkKreuzung.schalteManuell(nameDerKreuzung, nameDerSchaltung)
    print("schalteManuell:" .. nameDerKreuzung .. "/" .. nameDerSchaltung)
    ---@type AkKreuzung
    local k = AkKreuzung.alleKreuzungen[nameDerKreuzung]
    if k then
        k:setManuelleSchaltung(nameDerSchaltung)
    end
end

function AkKreuzung.schalteAutomatisch(nameDerKreuzung)
    print("schalteAutomatisch:" .. nameDerKreuzung)
    ---@type AkKreuzung
    local k = AkKreuzung.alleKreuzungen[nameDerKreuzung]
    if k then
        k:setAutomatikModus()
    end
end

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
        for richtung in pairs(schaltung:getNormaleRichtungen()) do
            assert(richtung.getTyp() == "AkRichtung", "Found: " .. richtung.getTyp())
            if nextSchaltung:getNormaleRichtungen()[richtung] then
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
    return self.nextSchaltung
end

function AkKreuzung:calculateNextSchaltung()
    if self.manuelleSchaltung then
        self.nextSchaltung = self.manuelleSchaltung
    else
        local sortedTable = {}
        for schaltung in pairs(self.schaltungen) do
            table.insert(sortedTable, schaltung)
        end
        table.sort(sortedTable, AkKreuzungsSchaltung.hoeherePrioAls)
        self.nextSchaltung = sortedTable[1]
    end
    return self.nextSchaltung
end

function AkKreuzung:setManuelleSchaltung(nameDerSchaltung)
    for schaltung in pairs(self.schaltungen) do
        if schaltung.name == nameDerSchaltung then
            self.manuelleSchaltung = schaltung
            print("Manuell geschaltet auf: " .. nameDerSchaltung .. " (" .. self.name .. "')")
            self:setBereit(true)
        end
    end
end

function AkKreuzung:setAutomatikModus()
    self.manuelleSchaltung = nil
    self:setBereit(true)
    print("Automatikmodus aktiviert. (" .. self.name .. "')")
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

function AkKreuzung:setGeschaltet(geschaltet)
    self.geschaltet = geschaltet
end

function AkKreuzung:isGeschaltet()
    return self.geschaltet
end

function AkKreuzung:getGruenZeitSekunden()
    return self.gruenZeit
end

function AkKreuzung:fuegeStatischeKameraHinzu(kameraName)
    table.insert(self.staticCams, kameraName)
end

function AkKreuzung.zaehlerZuruecksetzen()
    for _, kreuzung in ipairs(AkAllKreuzungen) do
        print("[AkKreuzung ] SETZE ZURUECK: " .. kreuzung.name)
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
---@return AkKreuzung
function AkKreuzung:neu(name)
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
    AkKreuzung.alleKreuzungen[name] = o
    return o
end

local aufbauHilfeErzeugt = AkKreuzung.zeigeSignalIdsAllerSignale

function AkKreuzung.planeSchaltungenEin()
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
                    --print(schaltung.name, richtung.name, ampel.signalId, AkPhase.GRUEN)
                    kreuzungsAmpelSchaltungen[ampel.signalId] = kreuzungsAmpelSchaltungen[ampel.signalId] or {}
                    kreuzungsAmpelSchaltungen[ampel.signalId][schaltung] = AkPhase.GRUEN
                    kreuzungsAmpelSchaltungen[ampel.signalId]["richtungen"] =
                        kreuzungsAmpelSchaltungen[ampel.signalId]["richtungen"] or {}
                    kreuzungsAmpelSchaltungen[ampel.signalId]["richtungen"][richtung] = AkPhase.GRUEN
                    kreuzungsAmpeln[ampel] = true
                end
            end
            for richtung in pairs(schaltung:getRichtungenMitAnforderung()) do
                for _, ampel in pairs(richtung.ampeln) do
                    --print(schaltung.name, ampel.signalId, AkPhase.GELB)
                    kreuzungsAmpelSchaltungen[ampel.signalId] = kreuzungsAmpelSchaltungen[ampel.signalId] or {}
                    kreuzungsAmpelSchaltungen[ampel.signalId][schaltung] = AkPhase.GELB
                    kreuzungsAmpelSchaltungen[ampel.signalId]["richtungen"] =
                        kreuzungsAmpelSchaltungen[ampel.signalId]["richtungen"] or {}
                    kreuzungsAmpelSchaltungen[ampel.signalId]["richtungen"][richtung] = AkPhase.GELB
                    kreuzungsAmpeln[ampel] = true
                end
            end
            for richtung in pairs(schaltung:getRichtungFuerFussgaenger()) do
                for _, ampel in pairs(richtung.ampeln) do
                    --print(schaltung.name, ampel.signalId, AkPhase.FG)
                    kreuzungsAmpelSchaltungen[ampel.signalId] = kreuzungsAmpelSchaltungen[ampel.signalId] or {}
                    kreuzungsAmpelSchaltungen[ampel.signalId][schaltung] = AkPhase.FG
                    kreuzungsAmpelSchaltungen[ampel.signalId]["richtungen"] =
                        kreuzungsAmpelSchaltungen[ampel.signalId]["richtungen"] or {}
                    kreuzungsAmpelSchaltungen[ampel.signalId]["richtungen"][richtung] = AkPhase.FG
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
                        if kreuzungsAmpelSchaltungen[ampel.signalId][schaltung] == AkPhase.GRUEN then
                            text =
                                text ..
                                "<br><j>" ..
                                (farbig and fmt.hintergrund_gruen(schaltung.name .. " (Gruen)") or
                                (schaltung.name .. " " .. fmt.hintergrund_gruen("(Gruen)")))
                        elseif kreuzungsAmpelSchaltungen[ampel.signalId][schaltung] == AkPhase.GELB then
                            text =
                                text ..
                                "<br><j>" ..
                                (farbig and fmt.hintergrund_blau(schaltung.name .. " (Anf)") or
                                (schaltung.name .. " " .. fmt.hintergrund_blau("(Anf)")))
                        elseif kreuzungsAmpelSchaltungen[ampel.signalId][schaltung] == AkPhase.FG then
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

    if aufbauHilfeErzeugt ~= AkKreuzung.zeigeSignalIdsAllerSignale then
        aufbauHilfeErzeugt = AkKreuzung.zeigeSignalIdsAllerSignale
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
                if AkKreuzung.debug then
                    print("[AkKreuzung ] Setze alle Richtungen fuer " .. kreuzung.name .. " auf rot")
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
                        if AkKreuzung.debug then
                            print(
                                "[AkKreuzung ] Plane neue Ampel " ..
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
                    if AkKreuzung.debug then
                        print(
                            "[AkKreuzung ] Richtung " ..
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
                    if AkKreuzung.debug then
                        print(
                            "[AkKreuzung ] Richtung " ..
                            richtungDanachGruen:getName() .. " wird fuer FG auf gruen geschaltet."
                    )
                    end
                end
            end

            if AkKreuzung.debug then
                print(
                    "[AkKreuzung ] Schalte " ..
                    kreuzung:getName() ..
                    " zu " .. nextSchaltung:getName() .. " (" .. nextSchaltung:richtungenAlsTextZeile() .. ")"
            )
            end

            local fussgaengerAufRot =
                AkAktion:neu(
                    function()
                        AkRichtung.schalteAmpeln(richtungenAufFussgaengerRot, AkPhase.ROT, currentName)
                    end,
                    "Schalte " .. currentName .. " auf Fussgaenger Rot"
            )
            AkPlaner:planeAktion(3, fussgaengerAufRot)

            local alteAmpelnAufGelb =
                AkAktion:neu(
                    function()
                        AkRichtung.schalteAmpeln(richtungenAufRot, AkPhase.GELB, currentName)
                    end,
                    "Schalte " .. currentName .. " auf gelb"
            )
            AkPlaner:planeAktion(0, alteAmpelnAufGelb, fussgaengerAufRot)

            local alteAmpelnAufRot =
                AkAktion:neu(
                    function()
                        AkRichtung.schalteAmpeln(richtungenAufRot, AkPhase.ROT, currentName)
                        kreuzung:setzeWarteZeitZurueck(nextSchaltung)
                    end,
                    "Schalte " .. currentName .. " auf rot"
            )
            AkPlaner:planeAktion(2, alteAmpelnAufRot, alteAmpelnAufGelb)

            local neueAmpelnAufRotGelb =
                AkAktion:neu(
                    function()
                        AkRichtung.schalteAmpeln(richtungenAufGruen, AkPhase.ROTGELB, nextName)
                        AkRichtung.schalteAmpeln(richtungenAufFussgaengerGruen, AkPhase.FG, nextName)
                    end,
                    "Schalte " .. nextName .. " auf rot-gelb"
            )
            AkPlaner:planeAktion(3, neueAmpelnAufRotGelb, alteAmpelnAufRot)

            local neueAmpelnAufGruen =
                AkAktion:neu(
                    function()
                        AkRichtung.schalteAmpeln(richtungenAufGruen, AkPhase.GRUEN, nextName)
                        kreuzung:setGeschaltet(true)
                    end,
                    "Schalte " .. nextName .. " auf gruen"
            )
            AkPlaner:planeAktion(1, neueAmpelnAufGruen, neueAmpelnAufRotGelb)

            local kreuzungFertigSchalten =
                AkAktion:neu(
                    function()
                        if AkKreuzung.debug then
                            print("[AkKreuzung ] " .. kreuzung.name .. ": Fahrzeuge sind gefahren, kreuzung ist dann frei.")
                        end
                        kreuzung:setBereit(true)
                    end,
                    kreuzung.name .. " ist nun bereit (war " .. kreuzung:getGruenZeitSekunden() .. "s auf gruen geschaltet)"
            )
            AkPlaner:planeAktion(kreuzung:getGruenZeitSekunden(), kreuzungFertigSchalten, neueAmpelnAufGruen)
        end
    end

    for _, kreuzung in ipairs(AkAllKreuzungen) do
        AkSchalteKreuzung(kreuzung)
        zeigeSchaltung(kreuzung)
    end
end

return AkKreuzung
