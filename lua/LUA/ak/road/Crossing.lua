if AkDebugLoad then print("Loading ak.road.Crossing ...") end

local Task = require("ak.scheduler.Task")
local Scheduler = require("ak.scheduler.Scheduler")
local CrossingSequence = require("ak.road.CrossingSequence")
local Lane = require("ak.road.Lane")
local TrafficLightState = require("ak.road.TrafficLightState")
local fmt = require("ak.core.eep.AkTippTextFormat")

--------------------
-- Klasse Kreuzung
--------------------
local AkAllKreuzungen = {}
---@class Crossing
---@field public name string @Intersection Name
---@field private aktuelleSchaltung CrossingSequence @Currently used switching
---@field private schaltungen CrossingSequence[] @All switchings of the intersection
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

---@return CrossingSequence
function Crossing:calculateNextSchaltung()
    if self.manuelleSchaltung then
        self.nextSchaltung = self.manuelleSchaltung
    else
        local sortedTable = {}
        for schaltung in pairs(self.schaltungen) do table.insert(sortedTable, schaltung) end
        table.sort(sortedTable, CrossingSequence.hoeherePrioAls)
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
function Crossing:newSequence(name)
    local switching = CrossingSequence:new(name)
    switching.crossing = self
    self.schaltungen[switching] = true
    return switching
end

local aufbauHilfeErzeugt = Crossing.zeigeSignalIdsAllerSignale

local function allTrafficLights(circuits)
    local list = {}

    for sequence in pairs(circuits) do
        assert(sequence.getType() == "CrossingSequence", type(sequence))
        for _, trafficLight in pairs(sequence.trafficLights) do list[trafficLight] = true end
        for _, trafficLight in pairs(sequence.pedestrianLights) do list[trafficLight] = true end
    end

    return list
end

---------------------------
-- Funktion switchTrafficLights
---------------------------
local function switch(crossing)
    if Crossing.debug then
        print(string.format("[Crossing ] Schalte Kreuzung %s: %s", crossing:getName(),
                            crossing:isBereit() and "Ja" or "Nein"))
    end
    if not crossing:isBereit() or not crossing:isGeschaltet() then do return true end end

    local TrafficLight = require("ak.road.TrafficLight")
    crossing:setGeschaltet(false)
    crossing:setBereit(false)
    ---@type CrossingSequence
    local nextCircuit = crossing:calculateNextSchaltung()
    local nextName = crossing.name .. " " .. nextCircuit:getName()
    local currentCircuit = crossing:getAktuelleSchaltung()
    local currentName = currentCircuit and crossing.name .. " " .. currentCircuit:getName() or crossing.name ..
                            " Rot fuer alle"

    local lanesToTurnRed, lanesToTurnGreen = nextCircuit:lanesToTurnRedAndGreen(currentCircuit)
    local trafficLightsToTurnRed, trafficLightsToTurnGreen =
        nextCircuit:trafficLightsToTurnRedAndGreen(currentCircuit)
    local pedestrianLightsToTurnRed, pedestrianLightsToTurnGreen =
        nextCircuit:pedestrianLightsToTurnRedAndGreen(currentCircuit)

    -- If there is no current sequence, we need to reset all old signals
    local lastTask = nil
    if currentCircuit then
        if Crossing.debug then
            print("[Crossing ] Schalte " .. crossing:getName() .. " zu " .. nextCircuit:getName() .. " (" ..
                      nextCircuit:richtungenAlsTextZeile() .. ")")
        end

        local reasonPed = "Schalte " .. currentName .. " auf Fussgaenger Rot"
        local turnPedestrianRed = Task:new(function()
            TrafficLight.switchAll(pedestrianLightsToTurnRed, TrafficLightState.RED, reasonPed)
        end, "Schalte " .. currentName .. " auf Fussgaenger Rot")
        Scheduler:scheduleTask(3, turnPedestrianRed)

        -- * Hier könnte noch die DDR-Schaltung rein (2 Sekunden grün-gelb)

        local reasonYellow = "Schalte " .. currentName .. " auf gelb"
        local turnTrafficLightsYellow = Task:new(function()
            TrafficLight.switchAll(trafficLightsToTurnRed, TrafficLightState.YELLOW, reasonYellow)
            Lane.switchLanes(lanesToTurnRed, TrafficLightState.RED, reasonYellow)
        end, reasonYellow)
        Scheduler:scheduleTask(0, turnTrafficLightsYellow, turnPedestrianRed)

        local reasonRed = "Schalte " .. currentName .. " auf rot"
        local turnTrafficLightsRed = Task:new(function()
            TrafficLight.switchAll(trafficLightsToTurnRed, TrafficLightState.RED, reasonRed)
        end, reasonRed)
        Scheduler:scheduleTask(2, turnTrafficLightsRed, turnTrafficLightsYellow)
        lastTask = turnTrafficLightsRed
    else
        local reason = "Schalte initial auf rot"
        trafficLightsToTurnRed = allTrafficLights(crossing.schaltungen)
        lanesToTurnRed = {}
        for laneName, lane in pairs(crossing.lanes) do
            if Crossing.debug then print("[Crossing ] " .. laneName .. " " .. reason) end
            lanesToTurnRed[lane] = true
        end
        TrafficLight.switchAll(trafficLightsToTurnRed, TrafficLightState.RED, reason)
        Lane.switchLanes(lanesToTurnRed, TrafficLightState.RED, reason)
    end

    local reasonRedYellow = "Schalte " .. nextName .. " auf rot-gelb"
    local turnNextTrafficLightsYellow = Task:new(function()
        TrafficLight.switchAll(trafficLightsToTurnGreen, TrafficLightState.REDYELLOW, reasonRedYellow)
        TrafficLight.switchAll(pedestrianLightsToTurnGreen, TrafficLightState.PEDESTRIAN, reasonRedYellow)
    end, reasonRedYellow)
    Scheduler:scheduleTask(3, turnNextTrafficLightsYellow, lastTask)

    local reasonGreen = "Schalte " .. nextName .. " auf gruen"
    local turnNextTrafficLightsGreen = Task:new(function()
        TrafficLight.switchAll(trafficLightsToTurnGreen, TrafficLightState.GREEN, reasonGreen)
        Lane.switchLanes(lanesToTurnGreen, TrafficLightState.GREEN, reasonGreen)
        crossing:setzeWarteZeitZurueck(nextCircuit)
        crossing:setGeschaltet(true)
    end, reasonGreen)
    Scheduler:scheduleTask(1, turnNextTrafficLightsGreen, turnNextTrafficLightsYellow)

    local changeToReadyStatus = Task:new(function()
        if Crossing.debug then
            print("[Crossing ] " .. crossing.name .. ": Fahrzeuge sind gefahren, kreuzung ist dann frei.")
        end
        crossing:setBereit(true)
    end, crossing.name .. " ist nun bereit (war " .. crossing:getGruenZeitSekunden() .. "s auf gruen geschaltet)")
    Scheduler:scheduleTask(crossing:getGruenZeitSekunden(), changeToReadyStatus, turnNextTrafficLightsGreen)
end


--- Diese Funktion sucht sich aus den Ampeln die mit der passenden Richtung
-- raus und setzt deren Texte auf die aktuelle Schaltung
-- @param kreuzung
local function showSwitching(crossing)
    for _, lane in pairs(crossing.lanes) do lane:checkRequests() end

    local trafficLights = {}
    local sequences = {}

    -- sort the circuits
    local sortedSequences = {}
    for k in pairs(crossing:getSchaltungen()) do table.insert(sortedSequences, k) end
    table.sort(sortedSequences, function(s1, s2) return (s1.name < s2.name) end)

    for _, sequence in ipairs(sortedSequences) do
        for _, tl in pairs(sequence.trafficLights) do
            sequences[tl.signalId] = sequences[tl.signalId] or {}
            sequences[tl.signalId][sequence] = TrafficLightState.GREEN
            trafficLights[tl] = true
        end
        for _, tl in pairs(sequence.pedestrianLights) do
            sequences[tl.signalId] = sequences[tl.signalId] or {}
            sequences[tl.signalId][sequence] = TrafficLightState.PEDESTRIAN
            trafficLights[tl] = true
        end
    end

    for _, lane in pairs(crossing.lanes) do
        local trafficLight = lane.trafficLight
        local text = "<j><b>Richtung / Wartezeit</b></j>"
        text = text .. "<br>" .. lane:getRequestInfo() .. " / " .. lane.waitCount
        trafficLight:setLaneInfo(text)
    end

    for trafficLight in pairs(trafficLights) do
        do
            local text = "<j><b>Schaltung:</b></j>"
            for _, switching in ipairs(sortedSequences) do
                local farbig = switching == crossing:getAktuelleSchaltung()
                if sequences[trafficLight.signalId][switching] then
                    if sequences[trafficLight.signalId][switching] == TrafficLightState.GREEN then
                        text = text .. "<br><j>" ..
                                   (farbig and fmt.bgGreen(switching.name .. " (Gruen)") or
                                       (switching.name .. " " .. fmt.bgGreen("(Gruen)")))
                    elseif sequences[trafficLight.signalId][switching] == TrafficLightState.PEDESTRIAN then
                        text = text .. "<br><j>" ..
                                   (farbig and fmt.bgYellow(switching.name .. " (FG)") or
                                       (switching.name .. " " .. fmt.bgYellow("(FG)")))
                    else
                        assert(false)
                    end
                else
                    text = text .. "<br><j>" ..
                               (farbig and fmt.bgRed(switching.name .. " (Rot)") or
                                   (switching.name .. " " .. fmt.bgRed("(Rot)")))
                end
            end
            trafficLight:setCircuitInfo(text)
        end

        trafficLight:refreshInfo()
    end
end

function Crossing.planeSchaltungenEin()
    --- Diese Funktion sucht sich aus den Ampeln die mit der passenden Richtung
    -- raus und setzt deren Texte auf die aktuelle Schaltung
    -- @param kreuzung

    if aufbauHilfeErzeugt ~= Crossing.zeigeSignalIdsAllerSignale then
        aufbauHilfeErzeugt = Crossing.zeigeSignalIdsAllerSignale
        for signalId = 1, 1000 do
            EEPShowInfoSignal(signalId, Crossing.zeigeSignalIdsAllerSignale)
            if Crossing.zeigeSignalIdsAllerSignale then
                EEPChangeInfoSignal(signalId, "<j>Signal: " .. signalId)
            end
        end
        -- for _, kreuzung in pairs(AkAllKreuzungen) do showSwitching(kreuzung) end
    end

    for _, kreuzung in pairs(AkAllKreuzungen) do
        switch(kreuzung)
        showSwitching(kreuzung)
    end
end

return Crossing
