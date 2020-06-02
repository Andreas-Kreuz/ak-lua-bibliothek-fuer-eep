if AkDebugLoad then print("Loading ak.road.Crossing ...") end

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
    if k then k:setManuelleSchaltung(nameDerSchaltung) end
end

function Crossing.schalteAutomatisch(nameDerKreuzung)
    print("schalteAutomatisch:" .. nameDerKreuzung)
    ---@type Crossing
    local k = Crossing.alleKreuzungen[nameDerKreuzung]
    if k then k:setAutomatikModus() end
end

function Crossing.getType() return "Crossing" end

function Crossing:getName() return self.name end

function Crossing:getSchaltungen() return self.schaltungen end

function Crossing:getAktuelleSchaltung() return self.aktuelleSchaltung end

function Crossing:setzeWarteZeitZurueck(nextSchaltung)
    for _, lane in pairs(self.lanes) do
        if nextSchaltung:getNormaleRichtungen()[lane] then
            lane:resetWaitCount()
        else
            lane:incrementWaitCount()
        end
    end
    self.aktuelleSchaltung = nextSchaltung
end

function Crossing:getNextSchaltung() return self.nextSchaltung end

---@return CrossingCircuit
function Crossing:calculateNextSchaltung()
    if self.manuelleSchaltung then
        self.nextSchaltung = self.manuelleSchaltung
    else
        local sortedTable = {}
        for schaltung in pairs(self.schaltungen) do table.insert(sortedTable, schaltung) end
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

function Crossing:fuegeSchaltungHinzu(schaltung) self.schaltungen[schaltung] = true end

function Crossing:setBereit(bereit) self.bereit = bereit end

function Crossing:isBereit() return self.bereit end

function Crossing:setGeschaltet(geschaltet) self.geschaltet = geschaltet end

function Crossing:isGeschaltet() return self.geschaltet end

function Crossing:getGruenZeitSekunden() return self.gruenZeit end

function Crossing:fuegeStatischeKameraHinzu(kameraName) table.insert(self.staticCams, kameraName) end

function Crossing.zaehlerZuruecksetzen()
    for _, kreuzung in pairs(AkAllKreuzungen) do
        print("[Crossing ] SETZE ZURUECK: " .. kreuzung.name)
        for schaltung in pairs(kreuzung:getSchaltungen()) do
            for richtung in pairs(schaltung:getNormaleRichtungen()) do richtung:resetVehicles() end
            for richtung in pairs(schaltung:getRichtungenMitAnforderung()) do richtung:resetVehicles() end
        end
    end
end

--- Erzeugt eine neue Kreuzung und registriert diese automatisch fuer das automatische Schalten.
-- Fuegen sie Schaltungen zu dieser Kreuzung hinzu.
-- @param name
---@return Crossing
function Crossing:new(name)
    local o = {
        name = name,
        aktuelleSchaltung = nil,
        schaltungen = {},
        lanes = {},
        pedestrianCrossings = {},
        bereit = true,
        geschaltet = true,
        gruenZeit = 15,
        staticCams = {}
    }
    self.__index = self
    setmetatable(o, self)
    Crossing.alleKreuzungen[name] = o
    AkAllKreuzungen[name] = o
    table.sort(AkAllKreuzungen, function(name1, name2) return name1 < name2 end)
    return o
end

--- Erzeugt eine Richtung, welche durch eine Ampel gesteuert wird.
---@param name string @Name der Richtung einer Kreuzung
---@param eepSaveId number, @EEPSaveSlot-Id fuer das Speichern der Richtung
---@param trafficLight TrafficLight @eine oder mehrere Ampeln
---@param directions string[] eine oder mehrere Ampeln
---@param trafficType string eine oder mehrere Ampeln
function Crossing:newLane(name, eepSaveId, trafficLight, directions, trafficType)
    local lane = Lane:new(name, eepSaveId, trafficLight, directions, trafficType)
    self.lanes[lane.name] = lane
    return lane
end

--- Erzeugt eine Richtung, welche durch eine Ampel gesteuert wird.
---@param name string @Name of the Pedestrian Crossing einer Kreuzung
function Crossing:newPedestrianCrossing(name)
    local lane = Lane:new(name, -1, {}, {}, Lane.TrafficType.PEDESTRIAN)
    self.pedestrianCrossings[lane.name] = lane
    return lane
end

--- Erzeugt eine Richtung, welche durch eine Ampel gesteuert wird.
---@param name string @Name of the Pedestrian Crossing einer Kreuzung
function Crossing:newSwitching(name)
    local switching = CrossingCircuit:new(name)
    self.schaltungen[switching] = true
    return switching
end

local aufbauHilfeErzeugt = Crossing.zeigeSignalIdsAllerSignale

function Crossing.planeSchaltungenEin()
    --- Diese Funktion sucht sich aus den Ampeln die mit der passenden Richtung
    -- raus und setzt deren Texte auf die aktuelle Schaltung
    -- @param kreuzung
    local function aktualisiereAnforderungen(kreuzung)
        for _, lane in pairs(kreuzung.lanes) do lane:checkRequests() end
    end

    --- Diese Funktion sucht sich aus den Ampeln die mit der passenden Richtung
    -- raus und setzt deren Texte auf die aktuelle Schaltung
    -- @param kreuzung
    local function showSwitching(kreuzung)
        aktualisiereAnforderungen(kreuzung)

        local kreuzungsAmpeln = {}
        local kreuzungsAmpelSchaltungen = {}

        -- sort the circuits
        local sortedCircuits = {}
        for k in pairs(kreuzung:getSchaltungen()) do table.insert(sortedCircuits, k) end
        table.sort(sortedCircuits, function(schaltung1, schaltung2) return (schaltung1.name < schaltung2.name) end)

        for _, schaltung in ipairs(sortedCircuits) do
            for _, ampel in pairs(schaltung.trafficLights) do
                -- print(schaltung.name, richtung.name, ampel.signalId, TrafficLightState.GREEN)
                kreuzungsAmpelSchaltungen[ampel.signalId] = kreuzungsAmpelSchaltungen[ampel.signalId] or {}
                kreuzungsAmpelSchaltungen[ampel.signalId][schaltung] = TrafficLightState.GREEN
                -- kreuzungsAmpelSchaltungen[tl.signalId]["lanes"] =
                --     kreuzungsAmpelSchaltungen[tl.signalId]["lanes"] or {}
                -- kreuzungsAmpelSchaltungen[tl.signalId]["lanes"][richtung] = TrafficLightState.GREEN
                kreuzungsAmpeln[ampel] = true
            end
            for _, ampel in pairs(schaltung.pedestrianLights) do
                -- print(schaltung.name, ampel.signalId, TrafficLightState.PEDESTRIAN)
                kreuzungsAmpelSchaltungen[ampel.signalId] = kreuzungsAmpelSchaltungen[ampel.signalId] or {}
                kreuzungsAmpelSchaltungen[ampel.signalId][schaltung] = TrafficLightState.PEDESTRIAN
                -- kreuzungsAmpelSchaltungen[pl.signalId]["lanes"] =
                --     kreuzungsAmpelSchaltungen[pl.signalId]["lanes"] or {}
                -- kreuzungsAmpelSchaltungen[pl.signalId]["lanes"][richtung] = TrafficLightState.PEDESTRIAN
                kreuzungsAmpeln[ampel] = true
            end
        end

        for ampel in pairs(kreuzungsAmpeln) do
            do
                local text = "<j><b>Schaltung:</b></j>"
                for _, schaltung in ipairs(sortedCircuits) do
                    local farbig = schaltung == kreuzung:getAktuelleSchaltung()
                    if kreuzungsAmpelSchaltungen[ampel.signalId][schaltung] then
                        if kreuzungsAmpelSchaltungen[ampel.signalId][schaltung] == TrafficLightState.GREEN then
                            text = text .. "<br><j>" ..
                                       (farbig and fmt.bgGreen(schaltung.name .. " (Gruen)") or
                                           (schaltung.name .. " " .. fmt.bgGreen("(Gruen)")))
                        elseif kreuzungsAmpelSchaltungen[ampel.signalId][schaltung] == TrafficLightState.PEDESTRIAN then
                            text = text .. "<br><j>" ..
                                       (farbig and fmt.bgYellow(schaltung.name .. " (FG)") or
                                           (schaltung.name .. " " .. fmt.bgYellow("(FG)")))
                        else
                            assert(false)
                        end
                    else
                        text = text .. "<br><j>" ..
                                   (farbig and fmt.bgRed(schaltung.name .. " (Rot)") or
                                       (schaltung.name .. " " .. fmt.bgRed("(Rot)")))
                    end
                end
                ampel:setCircuitInfo(text)
            end

            -- do
            --     local text = "<j><b>Richtung / Wartezeit</b></j>"
            --     for richtung in pairs(kreuzungsAmpelSchaltungen[ampel.signalId]["lanes"]) do
            --         text = text .. "<br>" .. richtung:getAnforderungsText() .. " / " .. richtung.waitCount
            --     end
            --     ampel:setLaneInfo(text)
            -- end

            ampel:refreshInfo()
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
        for _, kreuzung in pairs(AkAllKreuzungen) do showSwitching(kreuzung) end
    end

    ---------------------------
    -- Funktion switchTrafficLights
    ---------------------------
    local function switch(crossing)
        if Crossing.debug then
            print(string.format("[Crossing ] Schalte Kreuzung %s: %s", crossing:getName(),
                                crossing:isBereit() and "Ja" or "Nein"))
        end
        if crossing:isBereit() and crossing:isGeschaltet() then
            local TrafficLight = require("ak.road.TrafficLight")
            crossing:setGeschaltet(false)
            crossing:setBereit(false)
            ---@type CrossingCircuit
            local nextCircuit = crossing:calculateNextSchaltung()
            local nextName = crossing.name .. " " .. nextCircuit:getName()
            local currentCircuit = crossing:getAktuelleSchaltung()
            local currentName =
                currentCircuit and crossing.name .. " " .. currentCircuit:getName() or crossing.name ..
                    " Rot fuer alle"

            local lanesToTurnRed, lanesToTurnGreen = nextCircuit:lanesToTurnRedAndGreen(currentCircuit)
            local trafficLightsToTurnRed, trafficLightsToTurnGreen =
                nextCircuit:trafficLightsToTurnRedAndGreen(currentCircuit)
            local pedestrianLightsToTurnRed, pedestrianLightsToTurnGreen =
                nextCircuit:pedestrianLightsToTurnRedAndGreen(currentCircuit)

            if Crossing.debug then
                print("[Crossing ] Schalte " .. crossing:getName() .. " zu " .. nextCircuit:getName() .. " (" ..
                          nextCircuit:richtungenAlsTextZeile() .. ")")
            end

            local turnPedestrianRed = Task:new(function()
                TrafficLight.switchAll(pedestrianLightsToTurnRed, TrafficLightState.RED,
                                       "Schalte " .. currentName .. " auf Fussgaenger Rot")
            end, "Schalte " .. currentName .. " auf Fussgaenger Rot")
            Scheduler:scheduleTask(3, turnPedestrianRed)

            -- * Hier könnte noch die DDR-Schaltung rein (2 Sekunden grün-gelb)

            local turnTrafficLightsYellow = Task:new(function()
                TrafficLight.switchAll(trafficLightsToTurnRed, TrafficLightState.YELLOW,
                                       "Schalte " .. currentName .. " auf gelb")
                Lane.switchLanes(lanesToTurnRed, TrafficLightState.RED, "Schalte " .. currentName .. " auf gelb")
            end, "Schalte " .. currentName .. " auf gelb")
            Scheduler:scheduleTask(0, turnTrafficLightsYellow, turnPedestrianRed)

            local turnTrafficLightsRed = Task:new(function()
                TrafficLight.switchAll(trafficLightsToTurnRed, TrafficLightState.RED, currentName)
                crossing:setzeWarteZeitZurueck(nextCircuit)
            end, "Schalte " .. currentName .. " auf rot")
            Scheduler:scheduleTask(2, turnTrafficLightsRed, turnTrafficLightsYellow)

            local turnNextTrafficLightsYellow = Task:new(function()
                TrafficLight.switchAll(trafficLightsToTurnGreen, TrafficLightState.REDYELLOW,
                                       "Schalte " .. nextName .. " auf rot-gelb")
                TrafficLight.switchAll(pedestrianLightsToTurnGreen, TrafficLightState.PEDESTRIAN,
                                       "Schalte " .. nextName .. " auf rot-gelb")
            end, "Schalte " .. nextName .. " auf rot-gelb")
            Scheduler:scheduleTask(3, turnNextTrafficLightsYellow, turnTrafficLightsRed)

            local turnNextTrafficLightsGreen = Task:new(function()
                TrafficLight.switchAll(trafficLightsToTurnGreen, TrafficLightState.GREEN,
                                       "Schalte " .. nextName .. " auf gruen")
                Lane.switchLanes(lanesToTurnGreen, TrafficLightState.GREEN, "Schalte " .. nextName .. " auf gruen")
                crossing:setGeschaltet(true)
            end, "Schalte " .. nextName .. " auf gruen")
            Scheduler:scheduleTask(1, turnNextTrafficLightsGreen, turnNextTrafficLightsYellow)

            local changeToReadyStatus = Task:new(function()
                if Crossing.debug then
                    print("[Crossing ] " .. crossing.name .. ": Fahrzeuge sind gefahren, kreuzung ist dann frei.")
                end
                crossing:setBereit(true)
            end, crossing.name .. " ist nun bereit (war " .. crossing:getGruenZeitSekunden() ..
                                                     "s auf gruen geschaltet)")
            Scheduler:scheduleTask(crossing:getGruenZeitSekunden(), changeToReadyStatus, turnNextTrafficLightsGreen)
        end
    end

    for _, kreuzung in pairs(AkAllKreuzungen) do
        switch(kreuzung)
        showSwitching(kreuzung)
    end
end

return Crossing
