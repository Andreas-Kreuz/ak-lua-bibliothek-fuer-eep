if AkDebugLoad then print("Loading ak.road.CrossingSequence ...") end

local Task = require("ak.scheduler.Task")
-- local Lane = require("ak.road.Lane")
-- local LaneSettings = require("ak.road.LaneSettings")

------------------------------------------------------
-- Klasse CrossingSequence (schaltet mehrere Ampeln)
------------------------------------------------------
---@class CrossingSequence
local CrossingSequence = {}
CrossingSequence.debug = AkDebugLoad
---@class TrafficLightType
CrossingSequence.Type = {BUS = "BUS", CAR = "CAR", TRAM = "TRAM", PEDESTRIAN = "PEDESTRIAN", BICYCLE = "BICYCLE"}

function CrossingSequence.getType() return "CrossingSequence" end

function CrossingSequence:getName() return self.name end

function CrossingSequence:new(name, greenPhaseSeconds)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.name = name
    o.crossing = nil
    o.prio = 0
    ---@type table<TrafficLight,TrafficLightType>
    o.trafficLights = {}
    ---@type number Default length of a green phase in seconds
    o.greenPhaseSeconds = greenPhaseSeconds or 15
    return o
end

function CrossingSequence:initSequence()
    ---@type table<Lane,LaneSettings>
    self.lanes = {}
    for trafficLight, type in pairs(self.trafficLights) do
        if type ~= CrossingSequence.Type.PEDESTRIAN then
            for lane in pairs(trafficLight.lanes) do self.lanes[lane] = true end
        end
    end
end

---This will calculate all trafficLights to turn red and green
---@return table<TrafficLight,TrafficLightType> table<TrafficLight,TrafficLightType>
function CrossingSequence:trafficLightsToTurnRedAndGreen(oldSequence)
    local turnRed = {}
    local turnGreen = {}

    -- Calculate trafficLights to turn red and green
    if oldSequence then
        for light, oldType in pairs(oldSequence.trafficLights) do
            local newType = self.trafficLights[light]
            if not newType or newType ~= oldType or self.trafficLights[light].model ~= light.model then
                assert(light.type == "TrafficLight")
                assert(oldType)
                turnRed[light] = oldType
            end
        end
    end
    for light, newType in pairs(self.trafficLights) do
        local oldType = oldSequence and oldSequence.trafficLights[light] or nil
        if not oldType or newType ~= oldType or oldSequence.trafficLights[light].model ~= light.model then
            assert(light.type == "TrafficLight")
            assert(newType)
            turnGreen[light] = newType
        end
    end

    return turnRed, turnGreen
end

local function switchTask(tlList, tlFilter, tlState, reason)
    local TrafficLight = require("ak.road.TrafficLight")
    local toTurn = {}
    for t, type in pairs(tlList) do if type == tlFilter then toTurn[t] = true end end
    return Task:new(function() TrafficLight.switchAll(toTurn, tlState, reason) end, reason)
end

function CrossingSequence:tasksForSwitchingFrom(oldSequence)
    local TrafficLightState = require("ak.road.TrafficLightState")
    local taskList = {}

    local toRed, toGreen = self:trafficLightsToTurnRedAndGreen(oldSequence)

    local oldRedCars
    if oldSequence then
        -- Schedule the task where the old pedestrian lights get yellow
        local reasonPed = "Schalte " .. oldSequence.name .. " auf Fussgaenger Rot"
        local oldRedPedestrian = switchTask(toRed, CrossingSequence.Type.PEDESTRIAN, TrafficLightState.RED, reasonPed)
        table.insert(taskList, {offset = 0, task = oldRedPedestrian, precedingTask = nil})

        -- * Hier könnte noch die DDR-Schaltung rein (2 Sekunden grün-gelb)

        -- Schedule the task where the old traffic lights get yellow
        local reasonYelTram = "Schalte " .. oldSequence.name .. " auf gelb (Tram)"
        local oldYellowTram = switchTask(toRed, CrossingSequence.Type.TRAM, TrafficLightState.YELLOW, reasonYelTram)
        table.insert(taskList, {offset = 0, task = oldYellowTram, precedingTask = oldRedPedestrian})

        local reasonYelCar = "Schalte " .. oldSequence.name .. " auf gelb (Auto)"
        local oldYellowCars = switchTask(toRed, CrossingSequence.Type.CAR, TrafficLightState.YELLOW, reasonYelCar)
        table.insert(taskList, {offset = 0, task = oldYellowCars, precedingTask = oldRedPedestrian})

        -- Schedule the task where the old traffic lights get red (CAR)
        local reasonRedCars = "Schalte " .. oldSequence.name .. " auf rot (Auto)"
        oldRedCars = switchTask(toRed, CrossingSequence.Type.CAR, TrafficLightState.RED, reasonRedCars)
        table.insert(taskList, {offset = 2, task = oldRedCars, precedingTask = oldYellowCars})

        -- Schedule the task where the old traffic lights get red (TRAM)
        local reasonRedTram = "Schalte " .. oldSequence.name .. " auf rot (Tram)"
        local oldRedTram = switchTask(toRed, CrossingSequence.Type.TRAM, TrafficLightState.RED, reasonRedTram)
        table.insert(taskList, {offset = 2, task = oldRedTram, precedingTask = oldYellowCars})
    else
        -- Schedule the task where all traffic lights get red
        oldRedCars = Task:new(function() end, "clear crossing")
        table.insert(taskList, {offset = 4, task = oldRedCars, precedingTask = nil})
    end

    -- Schedule the task where the new traffic lights are red-yellow
    local reasonYel = "Schalte " .. self.name .. " auf rot-gelb"
    local nextYel = switchTask(toGreen, CrossingSequence.Type.CAR, TrafficLightState.REDYELLOW, reasonYel)
    table.insert(taskList, {offset = 3, task = nextYel, precedingTask = oldRedCars})

    -- Schedule the task where the new traffic lights are green (TRAM)
    local reasonGreenTram = "Schalte " .. self.name .. " auf gruen (Tram)"
    local nextGreenTram = switchTask(toGreen, CrossingSequence.Type.TRAM, TrafficLightState.GREEN, reasonGreenTram)
    table.insert(taskList, {offset = 1, task = nextGreenTram, precedingTask = nextYel})

    -- Schedule the task where the new pedestrian lights are green (PEDESTRIAN)
    local nextPed = switchTask(toGreen, CrossingSequence.Type.PEDESTRIAN, TrafficLightState.PEDESTRIAN, reasonYel)
    table.insert(taskList, {offset = 3, task = nextPed, precedingTask = oldRedCars})

    -- Schedule the task where the new traffic lights are green (CAR)
    local reasonGreenCar = "Schalte " .. self.name .. " auf gruen (Auto)"
    local nextGreenCar = switchTask(toGreen, CrossingSequence.Type.CAR, TrafficLightState.GREEN, reasonGreenCar)
    table.insert(taskList, {offset = 1, task = nextGreenCar, precedingTask = nextYel})

    return taskList
end

function CrossingSequence:getLanes() return self.lanes end

function CrossingSequence:lanesNamesText()
    local s = ""
    for lane in pairs(self.lanes) do s = s .. ", " .. lane.name end
    s = s:sub(3)
    return s
end

function CrossingSequence:addCarLights(...)
    for _, trafficLight in pairs({...}) do
        assert(trafficLight and trafficLight.signalId)
        self.trafficLights[trafficLight] = CrossingSequence.Type.CAR
    end
    return self
end

function CrossingSequence:addPedestrianLights(...)
    for _, trafficLight in pairs({...}) do
        assert(trafficLight and trafficLight.signalId)
        self.trafficLights[trafficLight] = CrossingSequence.Type.PEDESTRIAN
    end
    return self
end

function CrossingSequence:addTramLights(...)
    for _, trafficLight in pairs({...}) do
        assert(trafficLight and trafficLight.signalId)
        self.trafficLights[trafficLight] = CrossingSequence.Type.TRAM
    end
    return self
end

--- Gibt alle Fahrspuren nach Prioritaet zurueck, sowie deren Anzahl und deren Durchschnittspriorität
-- @return sortierteFahrspuren, anzahlDerFahrspuren, durchschnittsPrio
function CrossingSequence:lanesSortedByPriority()
    local sortedLanes = {}
    local laneCount = 0
    local prioritySum = 0
    for lane in pairs(self.lanes) do
        table.insert(sortedLanes, lane)
        laneCount = laneCount + 1
        prioritySum = prioritySum + lane:calculatePriority()
    end
    local averagePrio = prioritySum / laneCount
    local sortierFunktion = function(lane1, lane2)
        if lane1:calculatePriority() > lane2:calculatePriority() then
            return true
        elseif lane1:calculatePriority() < lane2:calculatePriority() then
            return false
        end
        return (lane1.name < lane2.name)
    end
    table.sort(sortedLanes, sortierFunktion)
    self.prio = averagePrio
    return sortedLanes, laneCount, averagePrio
end

------ Gibt alle Fahrspuren nach Name sortiert zurueck
-- @return sortierteFahrspuren
function CrossingSequence:lanesSortedByName()
    local sortedLanes = {}
    for lane in pairs(self.lanes) do table.insert(sortedLanes, lane) end
    local sortierFunktion = function(lane1, lane2) return (lane1.name < lane2.name) end
    table.sort(sortedLanes, sortierFunktion)
    return sortedLanes
end

--- Gibt zurueck ob schaltung1 eine hoehere Prioritaet hat, als Schaltung 2
-- @param schaltung1 erste Schaltung
-- @param schaltung2 zweite Schaltung
--
function CrossingSequence.sequencePriorityComparator(schaltung1, schaltung2)
    if schaltung1 and schaltung2 then
        local _, tableSize1, avg1 = schaltung1:lanesSortedByPriority()
        local _, tableSize2, avg2 = schaltung2:lanesSortedByPriority()

        if avg1 > avg2 then
            return true
        elseif avg1 < avg2 then
            return false
        end

        if tableSize1 > tableSize2 then
            return true
        elseif tableSize1 < tableSize2 then
            return false
        end

        return (schaltung1.name > schaltung2.name)
    end
end

function CrossingSequence:calculatePriority()
    local _, _, prio = self:lanesSortedByPriority()
    return prio
end

function CrossingSequence:resetWaitCount() for lane in pairs(self.lanes) do lane:resetWaitCount() end end

return CrossingSequence
