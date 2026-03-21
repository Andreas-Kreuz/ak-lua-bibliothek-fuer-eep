local TippTextFormatter = require("ce.hub.eep.TippTextFormatter")
if AkDebugLoad then print("[#Start] Loading ce.mods.road.Intersection ...") end

local Task = require("ce.hub.scheduler.Task")
local Scheduler = require("ce.hub.scheduler.Scheduler")
local IntersectionSequence = require("ce.mods.road.IntersectionSequence")
local IntersectionSettings = require("ce.mods.road.IntersectionSettings")
local TrafficLightState = require("ce.mods.road.TrafficLightState")
local fmt = require("ce.hub.eep.TippTextFormatter")

--------------------
-- Klasse Kreuzung
--------------------
---@type table<string,Intersection>
local allIntersections = {}
local Intersection = {}
Intersection.debug = AkStartWithDebug or false
---@type table<string,Intersection>
Intersection.allIntersections = {}

function Intersection.switchManuallyTo(crossingName, sequenceName)
    if Intersection.debug then print("[#Intersection] switchManuallyTo:" .. crossingName .. "/" .. sequenceName) end
    ---@type Intersection
    local k = Intersection.allIntersections[crossingName]
    if k then k:setManualSequence(sequenceName) end
end

function Intersection.switchAutomatically(crossingName)
    if Intersection.debug then print("[#Intersection] switchAutomatically:" .. crossingName) end
    ---@type Intersection
    local k = Intersection.allIntersections[crossingName]
    if k then k:setAutomaticSequence() end
end

function Intersection.getType() return "Intersection" end

function Intersection:getName() return self.name end

function Intersection:getSequences() return self.sequences end

function Intersection:getCurrentSequence() return self.currentSequence end

function Intersection:getNextSequence() return self.nextSequence end

function Intersection:getManualSequence() return self.manualSequence end

function Intersection:onSwitchedToSequence(currentSequence)
    for _, lane in pairs(self.lanes) do
        if currentSequence:getLanes()[lane] then
            lane:resetWaitCount()
        else
            lane:incrementWaitCount()
        end
    end
    self.currentSequence = currentSequence
end

---@return IntersectionSequence
function Intersection:calculateNextSequence()
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
        table.sort(sortedTable, IntersectionSequence.sequencePriorityComparator)
        nextSequence = sortedTable[1]
    end
    return nextSequence
end

function Intersection:setManualSequence(sequenceName)
    for _, sequence in ipairs(self.sequences) do
        if sequence.name == sequenceName then
            self.manualSequence = sequence
            print("[#Intersection] Manuell geschaltet auf: " .. sequence.name .. " (" .. self.name .. "')")
            self:setGreenPhaseFinished(true)
        end
    end
end

function Intersection:setAutomaticSequence()
    self.manualSequence = nil
    self:setGreenPhaseFinished(true)
    print("[#Intersection] Automatikmodus aktiviert. (" .. self.name .. "')")
end

function Intersection:setSwitchInStrictOrder(value)
    assert(value == true or value == false, "Use Intersection:setSwitchInStrictOrder(true|false)")
    self.switchInStrictOrder = value
end

function Intersection:getGreenPhaseSeconds() return self.greenPhaseSeconds end

function Intersection:setGreenPhaseFinished(greenPhaseFinished) self.greenPhaseFinished = greenPhaseFinished end

function Intersection:isGreenPhaseFinished() return self.greenPhaseFinished end

function Intersection:setGreenPhaseReached(greenPhaseReached) self.greenPhaseReached = greenPhaseReached end

function Intersection:isGreenPhaseReached() return self.greenPhaseReached end

function Intersection:setTippStructure(tippStructure) self.tippStructure = tippStructure end

function Intersection:getStaticCams() return self.staticCams end

function Intersection:addStaticCam(kameraName) table.insert(self.staticCams, kameraName) end

function Intersection.resetVehicles()
    for _, crossing in pairs(allIntersections) do
        print("[#Intersection] SETZE ZURUECK: " .. crossing.name)
        if crossing.lanes then for _, lane in pairs(crossing.lanes) do lane:resetVehicles() end end
    end
end

--- Erzeugt eine neue Kreuzung und registriert diese automatisch fuer das automatische Schalten.
-- Fuegen sie Schaltungen zu dieser Kreuzung hinzu.
-- @param name string name of the crossing
-- @param greenPhaseSeconds nubmer number of seconds for a default green phase
---@return Intersection
function Intersection:new(name, greenPhaseSeconds)
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
    Intersection.allIntersections[name] = o
    allIntersections[name] = o
    table.sort(allIntersections, function (name1, name2) return name1 < name2 end)
    return o
end

--- Erzeugt eine Fahrspur, welche durch eine Ampel gesteuert wird.
---@param name string @Name of the Pedestrian Intersection einer Kreuzung
function Intersection:newSequence(name, greenPhaseSeconds)
    local sequence = IntersectionSequence:new(name, greenPhaseSeconds or self.greenPhaseSeconds)
    self:addSequence(sequence)
    return sequence
end

function Intersection:addSequence(sequence)
    sequence.crossing = self
    table.insert(self.sequences, sequence)
    return sequence
end

local function allTrafficLights(sequences)
    local list = {}

    for _, sequence in ipairs(sequences) do
        assert(sequence.getType() == "IntersectionSequence", type(sequence))
        for trafficLight, type in pairs(sequence.trafficLights) do list[trafficLight] = type end
    end

    return list
end

---------------------------
-- Funktion switchTrafficLights
---------------------------
local function switch(crossing)
    local TrafficLight = require("ce.mods.road.TrafficLight")

    if Intersection.debug then
        local msg = "[#Intersection] Schalte Kreuzung %s: %s"
        print(string.format(msg, crossing:getName(), crossing:isGreenPhaseFinished() and "Ja" or "Nein"))
    end

    if not crossing:isGreenPhaseFinished() or not crossing.greenPhaseReached then do return true end end

    -- Start switching
    crossing.greenPhaseReached = false
    crossing:setGreenPhaseFinished(false)

    ---@type IntersectionSequence
    local nextSequence = crossing:calculateNextSequence()
    local currentSequence = crossing:getCurrentSequence()
    crossing.nextSequence = nextSequence

    local nextName = crossing.name .. " " .. nextSequence:getName()

    if Intersection.debug then
        local msg = "[#Intersection] Schalte %s zu %s (%s)"
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
                                               if Intersection.debug then
                                                   local msg = "[#Intersection] %s: Kreuzung ist auf grün geschaltet."
                                                   print(string.format(msg, crossing.name))
                                               end
                                               crossing.greenPhaseReached = true
                                           end, crossing.name .. " ist nun auf grün geschaltet)")
    Scheduler:scheduleTask(0, greenPhaseReachedTask, lastTask)

    -- Schedule the finishing task
    local greenPhaseSeconds = nextSequence.greenPhaseSeconds
    local crossingFinishedTask = Task:new(function ()
                                              if Intersection.debug then
                                                  local msg =
                                                  "[#Intersection] %s: Fahrzeuge sind gefahren, kreuzung ist dann frei."
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
            elseif type == IntersectionSequence.Type.CAR then
                table.insert(text, "<br><j>" ..
                    (farbig and fmt.bgGreen(sequence.name .. " (Gruen)") or
                        (sequence.name .. " " .. fmt.bgGreen("(Gruen)"))))
            elseif type == IntersectionSequence.Type.PEDESTRIAN then
                table.insert(text, "<br><j>" ..
                    (farbig and fmt.bgYellow(sequence.name .. " (FG)") or
                        (sequence.name .. " " .. fmt.bgYellow("(FG)"))))
            elseif type == IntersectionSequence.Type.TRAM then
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
---@param self Intersection
function Intersection:updateLaneTipText()
    local crossing = self
    local text = fmt.bold(crossing.name) .. "<br>" .. "__________"
    for _, lane in pairs(self.lanes) do
        text = TippTextFormatter.appendUpTo1023(text, "<br></j>" .. getLaneRequestInfoBar(lane))
    end

    if crossing.tippStructure then
        EEPShowInfoStructure(crossing.tippStructure, IntersectionSettings.showLanesOnStructure)
        EEPChangeInfoStructure(crossing.tippStructure, text)
    end
end

local setupHelpCreated = IntersectionSettings.showSignalIdOnSignal

--- Init all crossing lanes and traffic lights according to their sequences' traffic lights
--- ----
--- Speichert die Fahrspuren und Ampeln in den einzelnen Kreuzungen --> Weniger Suche danach
function Intersection.initSequences()
    for _, crossing in pairs(allIntersections) do
        local myLanes = {}
        for _, sequence in ipairs(crossing.sequences) do
            sequence:initSequence()
            local laneFound = false
            for v in pairs(sequence.lanes) do
                myLanes[v.name] = v
                laneFound = true
            end
            if not laneFound then
                print("[#Intersection] No LANE found in sequence " .. sequence.name .. " (" .. crossing.name .. ")")
            end
            assert(laneFound)
            for v in pairs(sequence.trafficLights) do crossing.trafficLights[v.signalId] = v end

            if Intersection.debug then
                local text = "[#Intersection] %s - %s: %s"
                print(string.format(text, crossing.name, sequence.name, sequence:lanesNamesText()))
            end
        end

        for _, v in pairs(myLanes) do table.insert(crossing.lanes, v) end
        table.sort(crossing.lanes, function (a, b) return a.name < b.name end)
    end
end

--- Switch all sequences according to the current crossing settings
function Intersection.switchSequences()
    if setupHelpCreated ~= IntersectionSettings.showSignalIdOnSignal then
        setupHelpCreated = IntersectionSettings.showSignalIdOnSignal
        for signalId = 1, 1000 do
            EEPShowInfoSignal(signalId, IntersectionSettings.showSignalIdOnSignal)
            if IntersectionSettings.showSignalIdOnSignal then
                EEPChangeInfoSignal(signalId, "<j>Signal: " .. signalId)
            end
        end
    end

    for _, crossing in pairs(allIntersections) do
        switch(crossing)
        recalculateSignalInfo(crossing)
        crossing:updateLaneTipText()
    end
end

return Intersection
