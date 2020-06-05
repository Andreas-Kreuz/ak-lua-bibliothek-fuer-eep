if AkDebugLoad then print("Loading ak.road.CrossingSequence ...") end

local Lane = require("ak.road.Lane")
local LaneSettings = require("ak.road.LaneSettings")
local TableUtils = require("ak.util.TableUtils")

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

---This will calculate all lanes
---@return Lane[], Lane[]
function CrossingSequence:lanesToTurnRedAndGreen(currentCircuit)
    if CrossingSequence.debug then
        print(string.format("[CrossingSequence] lanes from %s to %s", currentCircuit and currentCircuit.name or "NONE",
                            self.name))
    end

    local lanesToTurnRed = {}
    local lanesToTurnGreen = {}

    -- Calculate lanes to turn red and green
    if currentCircuit then
        for lane, currentLaneSettings in pairs(currentCircuit.lanes) do
            if not self.lanes[lane] or
                not TableUtils.sameArrayEntries(self.lanes[lane].directions, currentLaneSettings.directions) then
                if CrossingSequence.debug then
                    print(string.format("[CrossingSequence] turn red: %s", lane.name))
                end
                lanesToTurnRed[lane] = true
            end
        end
    end
    for lane, newLaneSettings in pairs(self.lanes) do
        if not currentCircuit or not currentCircuit.lanes[lane] or
            not TableUtils.sameArrayEntries(currentCircuit.lanes[lane].directions, newLaneSettings.directions) then
            if CrossingSequence.debug then
                print(string.format("[CrossingSequence] turn green: %s", lane.name))
            end
            lanesToTurnGreen[lane] = true
        end
    end
    return lanesToTurnRed, lanesToTurnGreen
end

---This will calculate all trafficLights to turn red and green
---@return TrafficLight[], TrafficLight[]
function CrossingSequence:trafficLightsToTurnRedAndGreen(currentCircuit)
    local trafficLightsToTurnRed = {}
    local trafficLightsToTurnGreen = {}

    -- Calculate trafficLights to turn red and green
    if currentCircuit then
        for id, currentTrafficLight in pairs(currentCircuit.trafficLights) do
            if not self.trafficLights[id] or self.trafficLights[id].model ~= currentTrafficLight.model then
                trafficLightsToTurnRed[currentTrafficLight] = true
            end
        end
    end
    for id, newTrafficLight in pairs(self.trafficLights) do
        if not currentCircuit or not currentCircuit.trafficLights[id] or currentCircuit.trafficLights[id].model ~=
            newTrafficLight.model then trafficLightsToTurnGreen[newTrafficLight] = true end
    end

    return trafficLightsToTurnRed, trafficLightsToTurnGreen
end

---This will calculate all pedestrianLights to turn red and green
---@return TrafficLight[], TrafficLight[]
function CrossingSequence:pedestrianLightsToTurnRedAndGreen(currentCircuit)
    local pedestrianLightsToTurnRed = {}
    local pedestrianLightsToTurnGreen = {}

    -- Calculate trafficLights to turn red and green
    if currentCircuit then
        for id, currentTrafficLight in pairs(currentCircuit.pedestrianLights) do
            if not self.pedestrianLights[id] then pedestrianLightsToTurnRed[currentTrafficLight] = true end
        end
    end
    for id, newTrafficLight in pairs(self.pedestrianLights) do
        if not currentCircuit or not currentCircuit.trafficLights[id] then
            pedestrianLightsToTurnGreen[newTrafficLight] = true
        end
    end

    return pedestrianLightsToTurnRed, pedestrianLightsToTurnGreen
end

function CrossingSequence:getAlleRichtungen()
    local alle = {}
    for lane in pairs(self.lanes) do alle[lane] = "NORMAL" end
    for richtung in pairs(self.pedestrianCrossings) do alle[richtung] = "PEDESTRIANTS" end
    return alle
end

function CrossingSequence:getNormaleRichtungen() return self.lanes end

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
---@param switchingType LaneRequestType @typ der Anforderung (nur bei Anforderung schalten ignoriert die
---                                      Anzahl der Rotphasen beim Umschalten)
function CrossingSequence:addLane(lane, directions, routes, switchingType)
    assert(lane, "Bitte ein gueltige Richtung angeben")
    self.lanes[lane] = LaneSettings:new(lane, directions, routes, switchingType)
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

function CrossingSequence:addPedestrianCrossing(richtung)
    assert(richtung, "Bitte ein gueltige Richtung angeben")
    richtung:setLaneType(Lane.SchaltungsTyp.FUSSGAENGER)
    self.pedestrianCrossings[richtung] = true
end

function CrossingSequence:getRichtungFuerFussgaenger() return self.pedestrianCrossings end

--- Gibt alle Richtungen nach Prioritaet zurueck, sowie deren Anzahl und deren Durchschnittspriorität
-- @return sortierteRichtungen, anzahlDerRichtungen, durchschnittsPrio
function CrossingSequence:nachPrioSortierteRichtungen()
    local sortierteRichtungen = {}
    local anzahlDerRichtungen = 0
    local gesamtPrio = 0
    for richtung in pairs(self.lanes) do
        table.insert(sortierteRichtungen, richtung)
        anzahlDerRichtungen = anzahlDerRichtungen + 1
        gesamtPrio = gesamtPrio + richtung:calculatePriority()
    end
    for richtung in pairs(self.pedestrianCrossings) do
        table.insert(sortierteRichtungen, richtung)
        anzahlDerRichtungen = anzahlDerRichtungen + 1
        gesamtPrio = gesamtPrio + richtung:calculatePriority()
    end
    local durchschnittsPrio = gesamtPrio / anzahlDerRichtungen
    local sortierFunktion = function(richtung1, richtung2)
        if richtung1:calculatePriority() > richtung2:calculatePriority() then
            return true
        elseif richtung1:calculatePriority() < richtung2:calculatePriority() then
            return false
        end
        return (richtung1.name < richtung2.name)
    end
    table.sort(sortierteRichtungen, sortierFunktion)
    self.prio = durchschnittsPrio
    return sortierteRichtungen, anzahlDerRichtungen, durchschnittsPrio
end

------ Gibt alle Richtungen nach Name sortiert zurueck
-- @return sortierteRichtungen
function CrossingSequence:nachNameSortierteRichtungen()
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
function CrossingSequence.hoeherePrioAls(schaltung1, schaltung2)
    if schaltung1 and schaltung2 then
        local _, tableSize1, avg1 = schaltung1:nachPrioSortierteRichtungen()
        local _, tableSize2, avg2 = schaltung2:nachPrioSortierteRichtungen()

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
    local _, _, prio = self:nachPrioSortierteRichtungen()
    return prio
end

function CrossingSequence:resetWaitCount() for richtung in pairs(self.lanes) do richtung:resetWaitCount() end end

return CrossingSequence
