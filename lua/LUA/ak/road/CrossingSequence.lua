if AkDebugLoad then print("Loading ak.road.CrossingSequence ...") end

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

-- function CrossingSequence:tasksForSwitchingFrom(currentCircuit)
--     local taskList = {}
--     table.insert(taskList, {offset = 0, after = nil, task = nil})
--     return taskList
-- end

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
