if AkDebugLoad then print("Loading ak.road.Crossing ...") end

local Task = require("ak.scheduler.Task")
local Scheduler = require("ak.scheduler.Scheduler")
local StorageUtility = require("ak.storage.StorageUtility")
local CrossingSequence = require("ak.road.CrossingSequence")
local TrafficLightState = require("ak.road.TrafficLightState")
local fmt = require("ak.core.eep.TippTextFormatter")

--------------------
-- Klasse Kreuzung
--------------------
local allCrossings = {}
---@class Crossing
---@field public name string @Intersection Name
---@field private currentSequence CrossingSequence @Currently used sequence
---@field private sequences CrossingSequence[] @All sequences of the intersection
---@field private greenPhaseFinished boolean @If true, the Intersection can be switched
---@field private greenPhaseSeconds number @Integer value of how long the intersection will show green light
---@field private staticCams table @List of static cams
local Crossing = {}
Crossing.debug = AkStartWithDebug or false
---@type table<string,Crossing>
Crossing.allCrossings = {}
Crossing.showRequestsOnSignal = AkStartWithDebug or false
Crossing.showSequenceOnSignal = AkStartWithDebug or false
Crossing.showSignalIdOnSignal = false

function Crossing.loadSettingsFromSlot(eepSaveId)
    StorageUtility.registerId(eepSaveId, "Crossing settings")
    Crossing.saveSlot = eepSaveId
    local data = StorageUtility.loadTable(Crossing.saveSlot, "Crossing settings")
    Crossing.showRequestsOnSignal = StorageUtility.toboolean(data["reqInfo"]) or Crossing.showRequestsOnSignal
    Crossing.showSequenceOnSignal = StorageUtility.toboolean(data["seqInfo"]) or Crossing.showSequenceOnSignal
    Crossing.showSignalIdOnSignal = StorageUtility.toboolean(data["sigInfo"]) or Crossing.showSignalIdOnSignal
end

function Crossing.saveSettings()
    if Crossing.saveSlot then
        local data = {
            reqInfo = tostring(Crossing.showRequestsOnSignal),
            seqInfo = tostring(Crossing.showSequenceOnSignal),
            sigInfo = tostring(Crossing.showSignalIdOnSignal)
        }
        StorageUtility.saveTable(Crossing.saveSlot, data, "Crossing settings")
    end
end

function Crossing.setShowRequestsOnSignal(value)
    assert(value == true or value == false)
    Crossing.showRequestsOnSignal = value
    Crossing.saveSettings()
end

function Crossing.setShowSequenceOnSignal(value)
    assert(value == true or value == false)
    Crossing.showSequenceOnSignal = value
    Crossing.saveSettings()
end

function Crossing.setShowSignalIdOnSignal(value)
    assert(value == true or value == false)
    Crossing.showSignalIdOnSignal = value
    Crossing.saveSettings()
end

function Crossing.switchManuallyTo(crossingName, sequenceName)
    print("switchManuallyTo:" .. crossingName .. "/" .. sequenceName)
    ---@type Crossing
    local k = Crossing.allCrossings[crossingName]
    if k then k:setManualSequence(sequenceName) end
end

function Crossing.switchAutomatically(crossingName)
    print("switchAutomatically:" .. crossingName)
    ---@type Crossing
    local k = Crossing.allCrossings[crossingName]
    if k then k:setAutomaticSequence() end
end

function Crossing.getType() return "Crossing" end

function Crossing:getName() return self.name end

function Crossing:getSequences() return self.sequences end

function Crossing:getCurrentSequence() return self.currentSequence end

function Crossing:onSwitchedToSequence(currentSequence)
    for _, lane in pairs(self.lanes) do
        if currentSequence:getLanes()[lane] then
            lane:resetWaitCount()
        else
            lane:incrementWaitCount()
        end
    end
    self.currentSequence = currentSequence
end

---@return CrossingSequence
function Crossing:calculateNextSequence()
    local nextSequence
    if self.manualSequence then
        nextSequence = self.manualSequence
    elseif self.switchInStrictOrder == true then
        local nextIndex = 1
        for i, sequence in ipairs(self.sequences) do
            if self.currentSequence == sequence then nextIndex = i == #self.sequences and 1 or i + 1 end
        end
        nextSequence = self.sequences[nextIndex]
    else
        local sortedTable = {}
        for _, sequence in ipairs(self.sequences) do table.insert(sortedTable, sequence) end
        table.sort(sortedTable, CrossingSequence.sequencePriorityComparator)
        nextSequence = sortedTable[1]

    end
    return nextSequence
end

function Crossing:setManualSequence(sequenceName)
    for _, sequence in ipairs(self.sequences) do
        if sequence.name == sequenceName then
            self.manualSequence = sequence
            print("Manuell geschaltet auf: " .. sequence .. " (" .. self.name .. "')")
            self:setGreenPhaseFinished(true)
        end
    end
end

function Crossing:setAutomaticSequence()
    self.manualSequence = nil
    self:setGreenPhaseFinished(true)
    print("Automatikmodus aktiviert. (" .. self.name .. "')")
end

function Crossing:setSwitchInStrictOrder(value)
    assert(value == true or value == false, "Use Crossing:setSwitchInStrictOrder(true|false)")
    self.switchInStrictOrder = value
end

function Crossing:getGreenPhaseSeconds() return self.greenPhaseSeconds end

function Crossing:setGreenPhaseFinished(greenPhaseFinished) self.greenPhaseFinished = greenPhaseFinished end

function Crossing:isGreenPhaseFinished() return self.greenPhaseFinished end

function Crossing:setGreenPhaseReached(greenPhaseReached) self.greenPhaseReached = greenPhaseReached end

function Crossing:isGreenPhaseReached() return self.greenPhaseReached end

function Crossing:addStaticCam(kameraName) table.insert(self.staticCams, kameraName) end

function Crossing.resetVehicles()
    for _, crossing in pairs(allCrossings) do
        print("[Crossing ] SETZE ZURUECK: " .. crossing.name)
        if crossing.lanes then for _, lane in pairs(crossing.lanes) do lane:resetVehicles() end end
    end
end

--- Erzeugt eine neue Kreuzung und registriert diese automatisch fuer das automatische Schalten.
-- Fuegen sie Schaltungen zu dieser Kreuzung hinzu.
-- @param name string name of the crossing
-- @param greenPhaseSeconds nubmer number of seconds for a default green phase
---@return Crossing
function Crossing:new(name, greenPhaseSeconds)
    local o = {
        name = name,
        currentSequence = nil,
        sequences = {},
        lanes = {},
        trafficLights = {},
        greenPhaseReached = true,
        greenPhaseFinished = true,
        greenPhaseSeconds = greenPhaseSeconds or 15,
        switchInStrictOrder = false,
        staticCams = {}
    }
    self.__index = self
    setmetatable(o, self)
    Crossing.allCrossings[name] = o
    allCrossings[name] = o
    table.sort(allCrossings, function(name1, name2) return name1 < name2 end)
    return o
end

--- Erzeugt eine Fahrspur, welche durch eine Ampel gesteuert wird.
---@param name string @Name of the Pedestrian Crossing einer Kreuzung
function Crossing:newSequence(name, greenPhaseSeconds)
    local sequence = CrossingSequence:new(name, greenPhaseSeconds or self.greenPhaseSeconds)
    self:addSequence(sequence)
    return sequence
end

function Crossing:addSequence(sequence)
    sequence.crossing = self
    table.insert(self.sequences, sequence)
    return sequence
end

local function allTrafficLights(sequences)
    local list = {}

    for _, sequence in ipairs(sequences) do
        assert(sequence.getType() == "CrossingSequence", type(sequence))
        for trafficLight, type in pairs(sequence.trafficLights) do list[trafficLight] = type end
    end

    return list
end

---------------------------
-- Funktion switchTrafficLights
---------------------------
local function switch(crossing)
    local TrafficLight = require("ak.road.TrafficLight")

    if Crossing.debug then
        local msg = "[Crossing ] Schalte Kreuzung %s: %s"
        print(string.format(msg, crossing:getName(), crossing:isGreenPhaseFinished() and "Ja" or "Nein"))
    end

    if not crossing:isGreenPhaseFinished() or not crossing.greenPhaseReached then do return true end end

    -- Start switching
    crossing.greenPhaseReached = false
    crossing:setGreenPhaseFinished(false)

    ---@type CrossingSequence
    local nextSequence = crossing:calculateNextSequence()
    local currentSequence = crossing:getCurrentSequence()
    crossing.nextSequence = nextSequence

    local nextName = crossing.name .. " " .. nextSequence:getName()

    if Crossing.debug then
        local msg = "[Crossing ] Schalte %s zu %s (%s)"
        print(string.format(msg, crossing:getName(), nextName, nextSequence:lanesNamesText()))
    end
    if not currentSequence then
        local reason = "Schalte initial auf rot"
        local turnRedTraffic = allTrafficLights(crossing.sequences)
        TrafficLight.switchAll(turnRedTraffic, TrafficLightState.RED, reason)
    end

    -- Calculate all tasks for switching in the sequence
    local lastTask
    local tasks = nextSequence:tasksForSwitchingFrom(currentSequence)

    for _, t in ipairs(tasks) do
        Scheduler:scheduleTask(t.offset, t.task, t.precedingTask)
        lastTask = t.task
    end

    -- After the sequence is ready, the current sequence is active
    local greenPhaseReachedTask = Task:new(function()
        if Crossing.debug then
            local msg = "[Crossing ] %s: Kreuzung ist auf grün geschaltet."
            print(string.format(msg, crossing.name))
        end
        crossing:onSwitchedToSequence(nextSequence)
        crossing.greenPhaseReached = true
    end, crossing.name .. " ist nun auf grün geschaltet)")
    Scheduler:scheduleTask(0, greenPhaseReachedTask, lastTask)

    -- Schedule the finishing task
    local greenPhaseSeconds = nextSequence.greenPhaseSeconds
    local crossingFinishedTask = Task:new(function()
        if Crossing.debug then
            local msg = "[Crossing ] %s: Fahrzeuge sind gefahren, kreuzung ist dann frei."
            print(string.format(msg, crossing.name))
        end
        crossing:setGreenPhaseFinished(true)
    end, crossing.name .. " ist nun bereit zum Umschalten (war " .. greenPhaseSeconds .. "s auf grün geschaltet)")
    Scheduler:scheduleTask(greenPhaseSeconds, crossingFinishedTask, greenPhaseReachedTask)
end

--- Diese Funktion sucht sich aus den Ampeln die mit der passenden Fahrspur
-- raus und setzt deren Texte auf die aktuelle Schaltung
-- @param kreuzung
local function recalculateSignalInfo(crossing)
    for _, lane in pairs(crossing.lanes) do lane:checkRequests() end

    local trafficLights = {}
    local tlSequences = {}

    -- sort the circuits
    local sortedSequences = {}
    for _, v in ipairs(crossing:getSequences()) do table.insert(sortedSequences, v) end
    table.sort(sortedSequences, function(s1, s2) return (s1.name < s2.name) end)

    for _, sequence in ipairs(sortedSequences) do
        for tl, type in pairs(sequence.trafficLights) do
            tlSequences[tl.signalId] = tlSequences[tl.signalId] or {}
            tlSequences[tl.signalId][sequence] = type
            trafficLights[tl] = type
        end
    end

    local trafficLightsToRefresh = {}
    for _, lane in pairs(crossing.lanes) do
        local trafficLight = lane.trafficLight
        trafficLightsToRefresh[trafficLight.signalId] = trafficLight
        local text = "<br></j>" .. lane:getRequestInfo() .. " / " .. lane.waitCount
        trafficLight:setLaneInfo(text)
    end

    for trafficLight in pairs(trafficLights) do
        trafficLightsToRefresh[trafficLight.signalId] = trafficLight
        local text = ""
        for _, sequence in ipairs(sortedSequences) do
            local farbig = sequence == crossing:getCurrentSequence()
            local type = sequence.trafficLights[trafficLight]
            if not type then
                text = text .. "<br><j>" ..
                           (farbig and fmt.bgRed(sequence.name .. " (Rot)") or
                               (sequence.name .. " " .. fmt.bgRed("(Rot)")))
            elseif type == CrossingSequence.Type.CAR then
                text = text .. "<br><j>" ..
                           (farbig and fmt.bgGreen(sequence.name .. " (Gruen)") or
                               (sequence.name .. " " .. fmt.bgGreen("(Gruen)")))
            elseif type == CrossingSequence.Type.PEDESTRIAN then
                text = text .. "<br><j>" ..
                           (farbig and fmt.bgYellow(sequence.name .. " (FG)") or
                               (sequence.name .. " " .. fmt.bgYellow("(FG)")))
            elseif type == CrossingSequence.Type.TRAM then
                text = text .. "<br><j>" ..
                           (farbig and fmt.bgBlue(sequence.name .. " (Tram)") or
                               (sequence.name .. " " .. fmt.bgBlue("(Tram)")))
            else
                assert(false, "No such type: " .. type)
            end
        end
        trafficLight:setSequenceInfo(text)
    end

    for _, trafficLight in pairs(trafficLightsToRefresh) do trafficLight:refreshInfo() end
end

local aufbauHilfeErzeugt = Crossing.showSignalIdOnSignal

--- Init all crossing lanes and traffic lights according to their sequences' traffic lights
--- ----
--- Speichert die Fahrspuren und Ampeln in den einzelnen Kreuzungen --> Weniger Suche danach
function Crossing.initSequences()
    for _, crossing in pairs(allCrossings) do
        for _, sequence in ipairs(crossing.sequences) do
            sequence:initSequence()
            local laneFound = false
            for v in pairs(sequence.lanes) do
                crossing.lanes[v.name] = v
                laneFound = true
            end
            assert(laneFound, "No LANE found in sequence " .. sequence.name .. " (" .. crossing.name .. ")")
            for v in pairs(sequence.trafficLights) do crossing.trafficLights[v.signalId] = v end

            if Crossing.debug then
                local text = "[Crossing ] %s - %s: %s"
                print(string.format(text, crossing.name, sequence.name, sequence:lanesNamesText()))
            end
        end
    end
end

--- Switch all sequences according to the current crossing settings
function Crossing.switchSequences()
    if aufbauHilfeErzeugt ~= Crossing.showSignalIdOnSignal then
        aufbauHilfeErzeugt = Crossing.showSignalIdOnSignal
        for signalId = 1, 1000 do
            EEPShowInfoSignal(signalId, Crossing.showSignalIdOnSignal)
            if Crossing.showSignalIdOnSignal then EEPChangeInfoSignal(signalId, "<j>Signal: " .. signalId) end
        end
    end

    for _, crossing in pairs(allCrossings) do
        switch(crossing)
        recalculateSignalInfo(crossing)
    end
end

return Crossing
