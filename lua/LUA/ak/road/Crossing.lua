local TippTextFormatter = require("ak.core.eep.TippTextFormatter")
if AkDebugLoad then print("[#Start] Loading ak.road.Crossing ...") end

local Task = require("ak.scheduler.Task")
local Scheduler = require("ak.scheduler.Scheduler")
local CrossingSequence = require("ak.road.CrossingSequence")
local CrossingSettings = require("ak.road.CrossingSettings")
local TrafficLightState = require("ak.road.TrafficLightState")
local fmt = require("ak.core.eep.TippTextFormatter")

--------------------
-- Klasse Kreuzung
--------------------
---@type table<string,Crossing>
local allCrossings = {}
local Crossing = {}
Crossing.debug = AkStartWithDebug or false
---@type table<string,Crossing>
Crossing.allCrossings = {}

function Crossing.loadSettingsFromSlot(eepSaveId) return CrossingSettings.loadSettingsFromSlot(eepSaveId) end

function Crossing.switchManuallyTo(crossingName, sequenceName)
    if Crossing.debug then print("[#Crossing] switchManuallyTo:" .. crossingName .. "/" .. sequenceName) end
    ---@type Crossing
    local k = Crossing.allCrossings[crossingName]
    if k then k:setManualSequence(sequenceName) end
end

function Crossing.switchAutomatically(crossingName)
    if Crossing.debug then print("[#Crossing] switchAutomatically:" .. crossingName) end
    ---@type Crossing
    local k = Crossing.allCrossings[crossingName]
    if k then k:setAutomaticSequence() end
end

function Crossing.getType() return "Crossing" end

function Crossing:getName() return self.name end

function Crossing:getSequences() return self.sequences end

function Crossing:getCurrentSequence() return self.currentSequence end

function Crossing:getNextSequence() return self.nextSequence end

function Crossing:getManualSequence() return self.manualSequence end

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
            print("[#Crossing] Manuell geschaltet auf: " .. sequence.name .. " (" .. self.name .. "')")
            self:setGreenPhaseFinished(true)
        end
    end
end

function Crossing:setAutomaticSequence()
    self.manualSequence = nil
    self:setGreenPhaseFinished(true)
    print("[#Crossing] Automatikmodus aktiviert. (" .. self.name .. "')")
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

function Crossing:setTippStructure(tippStructure) self.tippStructure = tippStructure end

function Crossing:getStaticCams() return self.staticCams end

function Crossing:addStaticCam(kameraName) table.insert(self.staticCams, kameraName) end

function Crossing.resetVehicles()
    for _, crossing in pairs(allCrossings) do
        print("[#Crossing] SETZE ZURUECK: " .. crossing.name)
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
        tippStructure = nil,
        staticCams = {}
    }
    self.__index = self
    setmetatable(o, self)
    Crossing.allCrossings[name] = o
    allCrossings[name] = o
    table.sort(allCrossings, function (name1, name2) return name1 < name2 end)
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
        local msg = "[#Crossing] Schalte Kreuzung %s: %s"
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
        local msg = "[#Crossing] Schalte %s zu %s (%s)"
        print(string.format(msg, crossing:getName(), nextName, nextSequence:lanesNamesText()))
    end
    if not currentSequence then
        local reason = "Schalte initial auf rot"
        local turnRedTraffic = allTrafficLights(crossing.sequences)
        TrafficLight.switchAll(turnRedTraffic, TrafficLightState.RED, reason)
    end

    -- After the sequence is ready, the current sequence is active
    local switchedSequenceTask = Task:new(function () crossing:onSwitchedToSequence(nextSequence) end,
                                          crossing.name .. " verwendet nun Schaltung " .. nextSequence.name)

    -- Calculate all tasks for switching in the sequence
    local lastTask
    local tasks = nextSequence:tasksForSwitchingFrom(currentSequence, switchedSequenceTask)

    for _, t in ipairs(tasks) do
        Scheduler:scheduleTask(t.offset, t.task, t.precedingTask)
        lastTask = t.task
    end

    -- After the sequence is ready, the current sequence is active
    local greenPhaseReachedTask = Task:new(function ()
                                               if Crossing.debug then
                                                   local msg = "[#Crossing] %s: Kreuzung ist auf grün geschaltet."
                                                   print(string.format(msg, crossing.name))
                                               end
                                               crossing.greenPhaseReached = true
                                           end, crossing.name .. " ist nun auf grün geschaltet)")
    Scheduler:scheduleTask(0, greenPhaseReachedTask, lastTask)

    -- Schedule the finishing task
    local greenPhaseSeconds = nextSequence.greenPhaseSeconds
    local crossingFinishedTask = Task:new(function ()
                                              if Crossing.debug then
                                                  local msg =
                                                  "[#Crossing] %s: Fahrzeuge sind gefahren, kreuzung ist dann frei."
                                                  print(string.format(msg, crossing.name))
                                              end
                                              crossing:setGreenPhaseFinished(true)
                                          end,
                                          crossing.name ..
                                          " ist nun bereit zum Umschalten (war " ..
                                          greenPhaseSeconds .. "s auf grün geschaltet)")
    Scheduler:scheduleTask(greenPhaseSeconds, crossingFinishedTask, greenPhaseReachedTask)
end

--- Diese Funktion sucht sich aus den Ampeln die mit der passenden Fahrspur
-- raus und setzt deren Texte auf die aktuelle Schaltung
-- @param kreuzung
local function recalculateSignalInfo(crossing)
    for _, lane in pairs(crossing.lanes) do lane:checkRequests() end

    ---@type table<TrafficLight, TrafficLightModel>
    local trafficLights = {}

    -- sort the circuits
    local sortedSequences = {}
    for _, v in ipairs(crossing:getSequences()) do table.insert(sortedSequences, v) end
    table.sort(sortedSequences, function (s1, s2) return (s1.name < s2.name) end)

    for _, sequence in ipairs(sortedSequences) do
        for tl, type in pairs(sequence.trafficLights) do trafficLights[tl] = type end
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
        local text = {}
        for _, sequence in ipairs(sortedSequences) do
            local farbig = sequence == crossing:getCurrentSequence()
            local type = sequence.trafficLights[trafficLight]
            if not type then
                table.insert(text, "<br><j>" ..
                    (farbig and fmt.bgRed(sequence.name .. " (Rot)") or
                        (sequence.name .. " " .. fmt.bgRed("(Rot)"))))
            elseif type == CrossingSequence.Type.CAR then
                table.insert(text, "<br><j>" ..
                    (farbig and fmt.bgGreen(sequence.name .. " (Gruen)") or
                        (sequence.name .. " " .. fmt.bgGreen("(Gruen)"))))
            elseif type == CrossingSequence.Type.PEDESTRIAN then
                table.insert(text, "<br><j>" ..
                    (farbig and fmt.bgYellow(sequence.name .. " (FG)") or
                        (sequence.name .. " " .. fmt.bgYellow("(FG)"))))
            elseif type == CrossingSequence.Type.TRAM then
                table.insert(text, "<br><j>" ..
                    (farbig and fmt.bgBlue(sequence.name .. " (Tram)") or
                        (sequence.name .. " " .. fmt.bgBlue("(Tram)"))))
            else
                -- No such type allowed here
                assert(false, type)
            end
        end
        table.insert(text, "<br>")
        trafficLight:setSequenceInfo(table.concat(text, ""))
    end

    for _, trafficLight in pairs(trafficLightsToRefresh) do trafficLight:refreshInfo() end
end

---comment
---@param lane Lane
---@return string
local function getLaneRequestInfoBar(lane)
    local text = ""
    local max = 10
    if lane.tracksUsedForRequest or lane.signalUsedForRequest then
        text = text .. (lane.queue:isEmpty() and "##########" or "__________")
    else
        local requests = "X"
        local vehicles = math.min(lane.vehicleCount * lane.fahrzeugMultiplikator, max - 1)
        for _ = 1, vehicles do requests = requests .. "_" end
        if lane.phase == TrafficLightState.RED then
            text = text .. fmt.bgRed(requests)
        elseif lane.phase == TrafficLightState.YELLOW then
            text = text .. fmt.bgYellow(requests)
        else
            text = text .. fmt.bgGreen(requests)
        end

        local grey = ""
        for _ = vehicles + 1, max - 1 do grey = grey .. "_" end
        text = text .. grey
    end
    return text .. "  " .. lane.name
end

---comment
---@param self Crossing
function Crossing:updateLaneTipText()
    local crossing = self
    local text = fmt.bold(crossing.name) .. "<br>" .. "__________"
    for _, lane in pairs(self.lanes) do
        text = TippTextFormatter.appendUpTo1023(text, "<br></j>" .. getLaneRequestInfoBar(lane))
    end

    if crossing.tippStructure then
        EEPShowInfoStructure(crossing.tippStructure, CrossingSettings.showLanesOnStructure)
        EEPChangeInfoStructure(crossing.tippStructure, text)
    end
end

local aufbauHilfeErzeugt = CrossingSettings.showSignalIdOnSignal

--- Init all crossing lanes and traffic lights according to their sequences' traffic lights
--- ----
--- Speichert die Fahrspuren und Ampeln in den einzelnen Kreuzungen --> Weniger Suche danach
function Crossing.initSequences()
    for _, crossing in pairs(allCrossings) do
        local myLanes = {}
        for _, sequence in ipairs(crossing.sequences) do
            sequence:initSequence()
            local laneFound = false
            for v in pairs(sequence.lanes) do
                myLanes[v.name] = v
                laneFound = true
            end
            if not laneFound then
                print("[#Crossing] No LANE found in sequence " .. sequence.name .. " (" .. crossing.name .. ")")
            end
            assert(laneFound)
            for v in pairs(sequence.trafficLights) do crossing.trafficLights[v.signalId] = v end

            if Crossing.debug then
                local text = "[#Crossing] %s - %s: %s"
                print(string.format(text, crossing.name, sequence.name, sequence:lanesNamesText()))
            end
        end

        for _, v in pairs(myLanes) do table.insert(crossing.lanes, v) end
        table.sort(crossing.lanes, function (a, b) return a.name < b.name end)
    end
end

--- Switch all sequences according to the current crossing settings
function Crossing.switchSequences()
    if aufbauHilfeErzeugt ~= CrossingSettings.showSignalIdOnSignal then
        aufbauHilfeErzeugt = CrossingSettings.showSignalIdOnSignal
        for signalId = 1, 1000 do
            EEPShowInfoSignal(signalId, CrossingSettings.showSignalIdOnSignal)
            if CrossingSettings.showSignalIdOnSignal then
                EEPChangeInfoSignal(signalId, "<j>Signal: " .. signalId)
            end
        end
    end

    for _, crossing in pairs(allCrossings) do
        switch(crossing)
        recalculateSignalInfo(crossing)
        crossing:updateLaneTipText()
    end
end

return Crossing
