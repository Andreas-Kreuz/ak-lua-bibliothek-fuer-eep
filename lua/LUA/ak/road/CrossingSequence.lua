if AkDebugLoad then print("Loading ak.road.CrossingSequence ...") end

local Lane = require("ak.road.Lane")
local LaneSettings = require("ak.road.LaneSettings")

------------------------------------------------------
-- Klasse Richtungsschaltung (schaltet mehrere Ampeln)
------------------------------------------------------
---@class CrossingSequence
local CrossingSequence = {}
CrossingSequence.debug = AkDebugLoad

function CrossingSequence.getType() return "CrossingSequence" end

function CrossingSequence:getName() return self.name end

function CrossingSequence:new(name)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.name = name
    o.crossing = nil
    o.prio = 0
    ---@type table<number,TrafficLight>
    o.trafficLights = {}
    ---@type table<number,TrafficLight>
    o.pedestrianLights = {}
    ---@type table<Lane,LaneSettings>
    o.lanes = {}
    o.pedestrianCrossings = {}
    return o
end

---This will calculate all trafficLights to turn red and green
---@return TrafficLight[], TrafficLight[]
function CrossingSequence:trafficLightsToTurnRedAndGreen(currentCircuit)
    local turnRed = {}
    local turnGreen = {}

    -- Calculate trafficLights to turn red and green
    if currentCircuit then
        for id, currentTrafficLight in pairs(currentCircuit.trafficLights) do
            if not self.trafficLights[id] or self.trafficLights[id].model ~= currentTrafficLight.model then
                turnRed[currentTrafficLight] = true
            end
        end
    end
    for id, newTrafficLight in pairs(self.trafficLights) do
        if not currentCircuit or not currentCircuit.trafficLights[id] or currentCircuit.trafficLights[id].model ~=
            newTrafficLight.model then turnGreen[newTrafficLight] = true end
    end

    return turnRed, turnGreen
end

---This will calculate all pedestrianLights to turn red and green
---@return TrafficLight[], TrafficLight[]
function CrossingSequence:pedestrianLightsToTurnRedAndGreen(currentCircuit)
    local turnRed = {}
    local turnGreen = {}

    -- Calculate trafficLights to turn red and green
    if currentCircuit then
        for id, currentTrafficLight in pairs(currentCircuit.pedestrianLights) do
            if not self.pedestrianLights[id] then turnRed[currentTrafficLight] = true end
        end
    end
    for id, newTrafficLight in pairs(self.pedestrianLights) do
        if not currentCircuit or not currentCircuit.trafficLights[id] then turnGreen[newTrafficLight] = true end
    end

    return turnRed, turnGreen
end

function CrossingSequence:getLanesAndPedestrianCrossings()
    local alle = {}
    for lane in pairs(self.lanes) do alle[lane] = "NORMAL" end
    for richtung in pairs(self.pedestrianCrossings) do alle[richtung] = "PEDESTRIANTS" end
    return alle
end

function CrossingSequence:getLanes() return self.lanes end

function CrossingSequence:richtungenAlsTextZeile()
    local s = ""
    for richtung in pairs(self.lanes) do s = s .. ", " .. richtung.name end
    s = s:sub(3)
    return s
end

--- Erzeugt eine Richtung, welche durch eine Ampel gesteuert wird.
---@param lane Lane @Sichtbare Ampeln
---@param directions LaneDirection[], @EEPSaveSlot-Id fuer das Speichern der Richtung
---@param routes string[] @matching routes
---@param requestType LaneRequestType @typ der Anforderung (nur bei Anforderung schalten ignoriert die
---                                      Anzahl der Rotphasen beim Umschalten)
function CrossingSequence:addLane(lane, directions, routes, requestType)
    assert(lane, "Bitte ein gueltige Richtung angeben")
    self.lanes[lane] = LaneSettings:new(lane, directions, routes, requestType)
    if self.crossing then self.crossing.lanes[lane.name] = lane end
    return self
end

function CrossingSequence:addTrafficLight(trafficLight)
    self.trafficLights[trafficLight.signalId] = trafficLight
    -- if self.crossing then
    --     self.crossing.trafficLights[trafficLight] = true
    -- end
    return self
end

function CrossingSequence:addPedestrianLight(trafficLight, secondTrafficLight)
    assert(trafficLight and trafficLight.signalId)
    self.pedestrianLights[trafficLight.signalId] = trafficLight
    if secondTrafficLight and secondTrafficLight.signalId then
        self.pedestrianLights[secondTrafficLight.signalId] = secondTrafficLight
    end
    -- if self.crossing then
    --     self.crossing.pedestrianLights[trafficLight] = true
    -- end
    return self
end

function CrossingSequence:addPedestrianCrossing(pedestrianCrossing)
    assert(pedestrianCrossing, "Bitte ein gueltige Richtung angeben")
    pedestrianCrossing:setLaneType(Lane.RequestType.FUSSGAENGER)
    self.pedestrianCrossings[pedestrianCrossing] = true
end

--- Gibt alle Richtungen nach Prioritaet zurueck, sowie deren Anzahl und deren Durchschnittspriorität
-- @return sortierteRichtungen, anzahlDerRichtungen, durchschnittsPrio
function CrossingSequence:lanesSortedByPriority()
    local sortedLanes = {}
    local laneCount = 0
    local prioritySum = 0
    for richtung in pairs(self.lanes) do
        table.insert(sortedLanes, richtung)
        laneCount = laneCount + 1
        prioritySum = prioritySum + richtung:calculatePriority()
    end
    for lane in pairs(self.pedestrianCrossings) do
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

------ Gibt alle Richtungen nach Name sortiert zurueck
-- @return sortierteRichtungen
function CrossingSequence:lanesSortedByName()
    local sortierteRichtungen = {}
    for richtung in pairs(self.lanes) do table.insert(sortierteRichtungen, richtung) end
    for richtung in pairs(self.pedestrianCrossings) do table.insert(sortierteRichtungen, richtung) end
    local sortierFunktion = function(richtung1, richtung2) return (richtung1.name < richtung2.name) end
    table.sort(sortierteRichtungen, sortierFunktion)
    return sortierteRichtungen
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

function CrossingSequence:resetWaitCount() for richtung in pairs(self.lanes) do richtung:resetWaitCount() end end

return CrossingSequence
