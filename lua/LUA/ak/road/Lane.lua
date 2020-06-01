if AkDebugLoad then print("Loading ak.road.Lane ...") end

local Queue = require("ak.util.Queue")
local Task = require("ak.scheduler.Task")
local Scheduler = require("ak.scheduler.Scheduler")
local StorageUtility = require("ak.storage.StorageUtility")
local TrafficLightState = require("ak.road.TrafficLightState")
local fmt = require("ak.core.eep.AkTippTextFormat")

-- Lane starts here
---@class Lane
local Lane = {}
Lane.debug = false

---If trainname is provided, this function will add the train to the lane's queue
---@param lane Lane the current lane, where the correction will take place
---@param trainName string Name of the train
local function addTrainToQueue(lane, trainName)
    assert(not trainName:find(","), "ERROR: TRAIN NAMES MUST NOT CONTAIN ',' - Please fix: " .. trainName)
    assert(not trainName:find("|"), "ERROR: TRAIN NAMES MUST NOT CONTAIN '|' - Please fix: " .. trainName)

    if trainName and not lane.signalUsedForRequest then
        lane.queue:push(trainName)

        -- Remember the "first good vehicle"
        lane.firstGoodTrain = lane.firstGoodTrain or trainName

        -- Fix queue length
        if lane.vehicleCount ~= lane.queue:size() then
            print(string.format("AUTOCORRECT %s: New vehicle count from queue length: %d; Current count: %d",
                                lane.name, lane.queue:size(), lane.vehicleCount))
            lane.vehicleCount = lane.queue:size()
        end
    end
end

---If trainname is provided, this function will remove the trains from the lane's queue
---@param lane Lane the current lane, where the correction will take place
---@param trainName string Name of the train
local function popTrainFromQueue(lane, trainName)
    if trainName and not lane.signalUsedForRequest then
        if trainName == lane.firstGoodTrain then lane.firstGoodTrain = nil end

        local numberOfPops = lane.queue:size()
        for i, trainFromQueue in pairs(lane.queue:elements()) do
            if trainFromQueue == trainName then
                numberOfPops = i
                break
            end

            if trainFromQueue == lane.firstGoodTrain then
                numberOfPops = i - 1
                break
            end
        end

        -- Remove train and fix queue
        if numberOfPops > 1 and Lane.debug then
            print(string.format("AUTOCORRECT %s: Have to remove %d trains to get to %s", lane.name, numberOfPops,
                                trainName))
        end
        for _ = 1, numberOfPops, 1 do
            local trainFromQueue = lane.queue:pop()
            if Lane.debug and trainFromQueue ~= trainName then
                print(string.format("AUTOCORRECT %s: Removed additional train %s", lane.name, trainFromQueue))
            end
        end

        -- Fix queue length
        if lane.vehicleCount ~= lane.queue:size() then
            if Lane.debug and numberOfPops == 1 then
                print(string.format("AUTOCORRECT %s: New vehicle count from queue length: %d; Current count: %d",
                                    lane.name, lane.queue:size(), lane.vehicleCount))
            end
            lane.vehicleCount = lane.queue:size()
        end
    end
end
local function queueToText(queue) return table.concat(queue:elements(), "|") end

local function queueFromText(pipeSeparatedText, count)
    local queue = Queue:new()
    if pipeSeparatedText then
        for trainName in string.gmatch(pipeSeparatedText, "[^|]+") do
            -- print(trainName)
            queue:push(trainName)
        end
    else
        -- For compatibility with old versions, we fill with generic names
        for i = 1, count, 1 do queue:push("train " .. i) end
    end
    return queue
end

local function save(lane)
    if lane.eepSaveId ~= -1 then
        local data = {}
        data["f"] = tostring(lane.vehicleCount)
        data["w"] = tostring(lane.waitCount)
        data["p"] = tostring(lane.phase)
        data["q"] = queueToText(lane.queue)
        StorageUtility.saveTable(lane.eepSaveId, data, "Lane " .. lane.name)
    end
end

local function load(lane)
    if lane.eepSaveId ~= -1 then
        local data = StorageUtility.loadTable(lane.eepSaveId, "Lane " .. lane.name)
        lane.vehicleCount = data["f"] and tonumber(data["f"]) or 0
        lane.waitCount = data["w"] and tonumber(data["w"]) or 0
        lane.phase = data["p"] or TrafficLightState.RED
        lane.queue = queueFromText(data["q"], lane.vehicleCount)
        lane:checkRequests()
        lane:switchTo(lane.phase, "Neu geladen")
    else
        lane.vehicleCount = 0
        lane.waitCount = 0
        lane.phase = TrafficLightState.RED
        lane.queue = Queue:new()
    end
end

--------------------
-- Klasse Richtung
--------------------
---@class LaneRequestType
Lane.SchaltungsTyp = {
    NICHT_VERWENDET = "NICHT VERWENDET",
    ANFORDERUNG = "ANFORDERUNG",
    NORMAL = "NORMAL",
    FUSSGAENGER = "FUSSGAENGER"
}
---@class LaneDirection
Lane.Directions = {
    LEFT = "LEFT",
    HALF_LEFT = "HALF-LEFT",
    STRAIGHT = "STRAIGHT",
    HALF_RIGHT = "HALF-RIGHT",
    RIGHT = "RIGHT"
}
---@class LaneType
Lane.Type = {CAR = "CAR", TRAM = "TRAM", PEDESTRIAN = "PEDESTRIAN", BICYCLE = "BICYCLE"}

function Lane.switchTrafficLights(lanes, phase, grund)
    assert(phase == TrafficLightState.GREEN or phase == TrafficLightState.REDYELLOW or phase ==
               TrafficLightState.YELLOW or phase == TrafficLightState.RED or phase == TrafficLightState.PEDESTRIAN)
    for richtung in pairs(lanes) do richtung:switchTo(phase, grund) end
end

function Lane.switchLanes(lanes, phase, grund)
    assert(phase == TrafficLightState.GREEN or phase == TrafficLightState.REDYELLOW or phase ==
               TrafficLightState.YELLOW or phase == TrafficLightState.RED or phase == TrafficLightState.PEDESTRIAN)
    for lane in pairs(lanes) do
        if Lane.debug then
            print(string.format("[Lane] Switching traffic light %d to %s (%s - %s)", lane.trafficLight.signalId,
                                phase, lane.name, grund))
        end
        lane:switchTo(phase, grund)
    end
end

function Lane.getType() return "Lane" end

function Lane:getName() return self.name end

function Lane:getLaneType() return self.schaltungsTyp end

function Lane:setLaneType(schaltungsTyp)
    assert(schaltungsTyp)
    assert(self.schaltungsTyp == Lane.SchaltungsTyp.NICHT_VERWENDET or self.schaltungsTyp == schaltungsTyp,
           "Diese Richtung hatte schon den Schaltungstyp: '" .. self.schaltungsTyp .. "' und kann daher nicht auf '" ..
               schaltungsTyp .. "' gesetzt werden.")
    self.schaltungsTyp = schaltungsTyp
end

function Lane:getVehicleCount(routes)
    local count = 0
    if #routes == 0 then
        count = self.vehicleCount
    else
        for i, vehicleName in pairs(self.queue:elements()) do
            local trainRoute = EEPGetTrainRoute(vehicleName)
            local routeMatches = false
            for _, route in pairs(routes) do
                if route == trainRoute then
                    routeMatches = true
                    break
                end
            end

            if not routeMatches then
                count = i
                break
            end
        end
    end
    return count
end

-- FIXME MOVE TO SWITCHING
function Lane:checkRequests()
    self:checkRoadRequests()
    self:checkSignalRequests()

    local text = ""
    if self.schaltungsTyp == Lane.SchaltungsTyp.NORMAL then
        text = text .. fmt.bgGreen(self.name)
    elseif self.schaltungsTyp == Lane.SchaltungsTyp.FUSSGAENGER then
        text = text .. fmt.bgYellow(self.name)
    elseif self.schaltungsTyp == Lane.SchaltungsTyp.ANFORDERUNG then
        text = text .. fmt.bgBlue(self.name)
    else
        text = text .. fmt.red(self.name)
    end

    text = text .. ": " .. (self:hasRequest() and fmt.lightGray("BELEGT") or fmt.lightGray("-FREI-")) .. " "
    if self.tracksUsedForRequest then
        text = text .. "(Strasse)"
    elseif self.signalUsedForRequest then
        text = text .. "(Ampel)"
    else
        text = text .. "(" .. self.vehicleCount .. " gezaehlt)"
    end

    self.anforderungsText = text
    self:refreshRequests()
end

-- FIXME MOVE TO SWITCHING
function Lane:refreshRequests() self.trafficLight:refreshRequests(self) end

-- FIXME MOVE TO SWITCHING
function Lane:calculatePriority()
    local tracksUsedForRequest = self:checkRoadRequests()
    if tracksUsedForRequest then
        local prio = (self.hasRequestOnRoad and 1 or 0) * 3 * self.fahrzeugMultiplikator
        return self.waitCount > prio and self.waitCount or prio
    end

    local signalUsedForRequest = self:checkSignalRequests()
    if signalUsedForRequest then
        local prio = (self.hasRequestOnSignal and 1 or 0) * 3 * self.fahrzeugMultiplikator
        return self.waitCount > prio and self.waitCount or prio
    end

    local prio = self.vehicleCount * 3 * self.fahrzeugMultiplikator
    return self.waitCount > prio and self.waitCount or prio
end

-- FIXME MOVE TO SWITCHING
function Lane:getAnforderungsText() return self.anforderungsText or "KEINE ANFORDERUNG" end

---@param roadId number Road Track ID
function Lane:zaehleAnStrasseAlle(roadId)
    self.tracksUsedForRequest = true
    EEPRegisterRoadTrack(roadId)
    if not self.tracksForRequests[roadId] then self.tracksForRequests[roadId] = {} end
    return self
end

function Lane:zaehleAnStrasseBeiRoute(strassenId, route)
    self.tracksUsedForRequest = true
    EEPRegisterRoadTrack(strassenId)
    if not self.tracksForRequests[strassenId] then self.tracksForRequests[strassenId] = {} end
    self.tracksForRequests[strassenId][route] = true
    return self
end

function Lane:checkRoadRequests()
    local anforderungGefunden = false
    for strassenId, routen in pairs(self.tracksForRequests) do
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
    self.hasRequestOnRoad = anforderungGefunden
end

---Zähle alle Fahrzeuge am Signal
---Count on the lane's traffic signal
function Lane:zaehleAnAmpelAlle()
    self.signalUsedForRequest = true
    return self
end

---Zähle die Fahrzeuge einer bestimmten Route am Signal
---Count trains of a certain route on the lane's traffic signal
---@param route string single route name
function Lane:zaehleAnAmpelBeiRoute(route)
    self.signalUsedForRequest = true
    self.routesToCount[route] = true
    return self
end

function Lane:checkSignalRequests()
    local requestFound = false
    if self.signalUsedForRequest then
        local wartend = EEPGetSignalTrainsCount(self.trafficLight.signalId)

        if wartend > 0 then
            local trainName = EEPGetSignalTrainName(self.trafficLight.signalId, 1)
            assert(trainName, "Kein Zug an Signal: " .. self.trafficLight.signalId)
            local found, trainRoute = EEPGetTrainRoute(trainName)
            assert(found, "Zug nicht gefunden in EEPGetTrainRoute: " .. trainName)

            local haveRoutes = false
            local trainFound = false
            if self.routesToCount then
                for matchingRoute in pairs(self.routesToCount) do
                    haveRoutes = true
                    if matchingRoute == trainRoute then
                        trainFound = true
                        break
                    end
                end
            end

            requestFound = not haveRoutes or trainFound
        end
    end
    self.hasRequestOnSignal = requestFound
end

--- Das Fahrzeug "vehicle" hat die Fahrspur betreten --> Rufe diese Funktion vom Kontaktpunkt aus auf
--- The vehicle entered this lane -> call this in a contact point
---@param trainName string name of the vehicle, i.e. train name in EEP
function Lane:vehicleEntered(trainName)
    self.vehicleCount = self.vehicleCount + 1
    addTrainToQueue(self, trainName)
    self:refreshRequests()
    save(self)
end

--- Das Fahrzeug "vehicle" hat die Fahrspur verlassen --> Rufe diese Funktion vom Kontaktpunkt aus auf
--- The vehicle left this lane -> call this in a contact point
---@param swithToRed boolean indicates, if this lane shall switch to red immediately FIXME --> Shall be in Lane
---@param trainName string name of the vehicle, i.e. train name in EEP
function Lane:vehicleLeft(swithToRed, trainName)
    self.vehicleCount = self.vehicleCount > 0 and self.vehicleCount - 1 or 0
    popTrainFromQueue(self, trainName)
    self:refreshRequests()
    save(self)

    if swithToRed and not self:hasRequest() then
        local lanes = {}
        lanes[self] = true

        Lane.switchTrafficLights(lanes, TrafficLightState.YELLOW, "Vehicle left: " .. trainName)

        local toRed = Task:new(function()
            Lane.switchTrafficLights(lanes, TrafficLightState.RED, "Vehicle left: " .. trainName)
        end, "Schalte " .. self.name .. " auf rot.")
        Scheduler:scheduleTask(2, toRed)
    end
end

function Lane:resetVehicles()
    while not self.queue:isEmpty() do self.queue:pop() end
    self.vehicleCount = 0
    self:refreshRequests()
    save(self)
end

function Lane:incrementWaitCount()
    self.waitCount = self.waitCount + 1
    save(self)
end

function Lane:resetWaitCount()
    self.waitCount = 0
    save(self)
end

-- FIXME REPLACE BY QUEUE
function Lane:hasRequest() return self.vehicleCount > 0 or self.hasRequestOnSignal or self.hasRequestOnRoad end

function Lane:getWaitCount() return self.waitCount end

function Lane:getVehicleCount() return self.vehicleCount end

function Lane:setFahrzeugMultiplikator(fahrzeugMultiplikator)
    self.fahrzeugMultiplikator = fahrzeugMultiplikator
    return self
end

function Lane:switchTo(phase, grund)
    self.trafficLight:switchTo(phase, grund)
    self.phase = phase
end

function Lane:setDirections(...)
    for _, direction in pairs(...) do
        if not Lane.Type[direction] then print("No such direction: " .. direction) end
    end

    self.directions = ... or {"LEFT", "STRAIGHT", "RIGHT"}
end

function Lane:setTrafficType(trafficType)
    if not Lane.Type[trafficType] then
        print("No such traffic type: " .. trafficType)
    else
        self.trafficType = trafficType
    end
end

--- Erzeugt eine Richtung, welche durch eine Ampel gesteuert wird.
---@param name string @Name der Richtung einer Kreuzung
---@param eepSaveId number, @EEPSaveSlot-Id fuer das Speichern der Richtung
---@param trafficLight TrafficLight @genau eine Ampeln
---@param directions string[] eine oder mehrere Ampeln
---@param trafficType string eine oder mehrere Ampeln
---@return Lane
function Lane:new(name, eepSaveId, trafficLight, directions, trafficType)
    assert(name, 'Bitte geben Sie den Namen "name" fuer diese Richtung an.')
    assert(type(name) == "string", "Name ist kein String")
    assert(eepSaveId, 'Bitte geben Sie den Wert "eepSaveId" fuer diese Richtung an.')
    assert(type(eepSaveId) == "number")
    assert(trafficLight, 'Specify a single "trafficLight" for this lane (the one, where the traffic is queued).')
    assert(trafficLight.type == "TrafficLight",
           'Specify a single "trafficLight" for this lane (the one, where the traffic is queued).')
    -- assert(signalId, "Bitte geben Sie den Wert \"signalId\" fuer diese Richtung an.")
    if eepSaveId ~= -1 then StorageUtility.registerId(eepSaveId, "Lane " .. name) end
    local o = {
        name = name,
        eepSaveId = eepSaveId,
        trafficLight = trafficLight,
        schaltungsTyp = Lane.SchaltungsTyp.NICHT_VERWENDET,
        routesToCount = {},
        signalUsedForRequest = false,
        tracksUsedForRequest = false,
        tracksForRequests = {},
        directions = directions or {"LEFT", "STRAIGHT", "RIGHT"},
        switchings = {},
        trafficType = trafficType or "NORMAL",
        fahrzeugMultiplikator = 1,
        activeLaneSettings = nil
    }

    self.__index = self
    setmetatable(o, self)
    load(o)
    return o
end

return Lane
