if AkDebugLoad then print("Loading ak.data.TrackCollector ...") end

local TableUtils = require("ak.util.TableUtils")
local EventBroker = require("ak.util.EventBroker")
local TrainRegistry = require("ak.train.TrainRegistry")
local RollingStockRegistry = require("ak.train.RollingStockRegistry")
local RuntimeRegistry = require("ak.util.RuntimeRegistry")
local TrackCollector = {}
local os = require("os")

local MAX_TRACKS = 50000

---@class Track
---@field id number

local registerFunction = {
    auxiliary = EEPRegisterAuxiliaryTrack,
    control = EEPRegisterControlTrack,
    road = EEPRegisterRoadTrack,
    rail = EEPRegisterRailTrack,
    tram = EEPRegisterTramTrack
}
local reservedFunction = {
    auxiliary = EEPIsAuxiliaryTrackReserved,
    control = EEPIsControlTrackReserved,
    road = EEPIsRoadTrackReserved,
    rail = EEPIsRailTrackReserved,
    tram = EEPIsTramTrackReserved
}

local runtimeData = {}

--- Store runtime information
-- @author Frank Buchholz
function storeRunTime(group, time)
    -- collect and sum runtime date, needs rework
    if not runtimeData then runtimeData = {} end
    if not runtimeData[group] then runtimeData[group] = {id = group, count = 0, time = 0} end
    local runtime = runtimeData[group]
    runtime.count = runtime.count + 1
    runtime.time = runtime.time + time * 1000
end

--- Indirect call of EEP function (or any other function) including time measurement
-- @author Frank Buchholz
function executeAndStoreRunTime(func, group, ...)
    if not func then return end

    local t0 = os.clock()

    local result = {func(...)}

    local t1 = os.clock()
    storeRunTime(group, t1 - t0)

    return table.unpack(result)
end

local _EEPGetRollingstockItemsCount = EEPGetRollingstockItemsCount
local function EEPGetRollingstockItemsCount(...)
    return executeAndStoreRunTime(_EEPGetRollingstockItemsCount, "EEPGetRollingstockItemsCount", ...)
end

-- Ermittelt die Gesamtl�nge des angegebenen Zuges.
local EEPGetTrainLength = EEPGetTrainLength or function() end -- EEP 15.1 Plug-In 1

-- Ermittelt, welches Fahrzeug derzeit im Steuerdialog ausgew�hlt ist.
local EEPRollingstockGetActive = EEPRollingstockGetActive or function() -- (not used yet)
end -- EEP 15.1 Plug-In 1

-- Ermittelt, welcher Zug derzeit im Steuerdialog ausgew�hlt ist.
local EEPGetTrainActive = EEPGetTrainActive or function() -- (not used yet)
end -- EEP 15.1 Plug-In 1

-- Ermittelt, welche relative Ausrichtung das angegebene Fahrzeug im Zugverband hat.
local EEPRollingstockGetOrientation = EEPRollingstockGetOrientation or function() -- (not used yet)
end -- EEP 15.1 Plug-In 1

local EEPRollingstockGetLength = EEPRollingstockGetLength or function() end -- EEP 14.2

local EEPRollingstockGetMotor = EEPRollingstockGetMotor or function() end -- EEP 14.2

local EEPRollingstockGetTrack = EEPRollingstockGetTrack or function() end -- EEP 14.2

local EEPRollingstockGetModelType = EEPRollingstockGetModelType or function() end -- EEP 14.2

local EEPRollingstockGetTagText = EEPRollingstockGetTagText or function() end -- EEP 14.2

--- Ermittelt, ob der Haken eines bestimmten Rollmaterials an oder ausgeschaltet ist.
-- OK, Status = EEPRollingstockGetHook("#Kranwagen")
-- Haken aus = 0, an = 1, in Betrieb = 3
local EEPRollingstockGetHook = EEPRollingstockGetHook or function() -- (not used yet)
end -- EEP 16.1

--- Ermittelt das Verhalten von G�tern am Kranhaken eines Rollmaterials
--  OK, Status = EEPRollingstockGetHookGlue("#Kranwagen")
-- G�terhaken aus = 0, an = 1, in Benutzung = 3
local EEPRollingstockGetHookGlue = EEPRollingstockGetHookGlue or function() -- (not used yet)
end -- EEP 16.1

--- Ermittelt, ob der Rauch des benannten Rollmaterials, an- oder ausgeschaltet ist.
-- OK, Status = EEPRollingstockGetSmoke("#Fahrzeug")
-- aus = 0, angeschaltet = 1
local EEPRollingstockGetSmoke = EEPRollingstockGetSmoke or function() -- (not used yet)
end -- EEP 16.1

--- Ermittelt die Ausrichtung des Ladegutes in Grad (°)
-- OK, RotX, RotY, RotZ = EEPGoodsGetRotation("#Container")
local EEPGoodsGetRotation = EEPGoodsGetRotation or function() -- (not used yet)
end -- EEP 16.1

-- To be used in another modules:

--- Ermittelt die aktuelle Position der Kamera
-- OK, PosX, PosY, PosZ = EEPGetCameraPosition()
local EEPGetCameraPosition = EEPGetCameraPosition or function() -- (not used yet)
end -- EEP 16.1

--- Ermittelt die aktuelle Ausrichtung einer Kamera.
-- OK, RotX, RotY, RotZ = EEPGetCameraRotation()
local EEPGetCameraRotation = EEPGetCameraRotation or function() -- (not used yet)
end -- EEP 16.1

--- Ermittelt die Windst�rke in Prozent (%)
--  OK, WindIntensity = EEPGetWindIntensity()
local EEPGetWindIntensity = EEPGetWindIntensity or function() -- (not used yet)
end -- EEP 16.1

--- Ermittelt die Niederschlagintensit�t in Prozent (%)
--  OK, RainIntensity = EEPGetRainIntensity()
local EEPGetRainIntensity = EEPGetRainIntensity or function() -- (not used yet)
end -- EEP 16.1

--- Ermittelt die Schneeintensit� in Prozent (%)
--  OK, SnowIntensity = EEPGetSnowIntensity()
local EEPGetSnowIntensity = EEPGetSnowIntensity or function() -- (not used yet)
end -- EEP 16.1

--- Ermittelt die Hagelintensit�t in Prozent (%)
-- OK, HailIntensity = EEPGetHailIntensity()
local EEPGetHailIntensity = EEPGetHailIntensity or function() -- (not used yet)
end -- EEP 16.1

--- Ermittelt die Nebelintensit�t in Prozent (%)
-- OK, FogIntensity = EEPGetFogIntensity()
local EEPGetFogIntensity = EEPGetFogIntensity or function() -- (not used yet)
end -- EEP 16.1

--- Ermittelt der Wolkenanteil in Prozent (%)
-- OK, CloudIntensity = EEPGetCloudIntensity()
local EEPGetCloudIntensity = EEPGetCloudIntensity or function() -- (not used yet)
end -- EEP 16.1

-- Redefine functions from EEP 11.0 to collect run time data
local _EEPGetTrainSpeed = EEPGetTrainSpeed
local function EEPGetTrainSpeed(...) return executeAndStoreRunTime(_EEPGetTrainSpeed, "EEPGetTrainSpeed", ...) end
local _EEPGetRollingstockItemName = EEPGetRollingstockItemName or function() end -- EEP 13.2 Plug-In 2
local function EEPGetRollingstockItemName(...)
    return executeAndStoreRunTime(_EEPGetRollingstockItemName, "EEPGetRollingstockItemName", ...)
end

---This will create a dictionary of train names to their location on the tracks
---@param lastTrains table<string,boolean> train names of the last run
---@param tracks table<number,Track> of tracks of the current type, i.e. all roads, rails, ...
---@param detectFunction function the function to check if the track is reserved, e.g. EEPIsRoadTrackReserved
---@return table<string,table<string,number>>
function prepareTrainsOnTrack(lastTrains, tracks, detectFunction)
    ---@type table<string,table<string,number>>
    local trainsOnTrack = {}

    -- Create empty list of tracks for each known train
    for trainName in pairs(lastTrains) do trainsOnTrack[trainName] = {} end

    -- Fill the list of tracks for each train by looking in every track
    for _, track in pairs(tracks) do
        local trackId = track.id
        -- Limitation: only the first train on a track is found
        local _, occupied, trainName = detectFunction(trackId, true)
        if occupied and trainName then
            trainsOnTrack[trainName] = trainsOnTrack[trainName] or {}
            trainsOnTrack[trainName][tostring(trackId)] = trackId
        end
    end

    return trainsOnTrack
end

---Go through the list of all trains and update them
---@param trainsOnTrack table<string,table<string,number>> train names and their tracks
---@return table<string,boolean> list of train names
function TrackCollector:checkTrains(trainsOnTrack)
    local lastTrains = {}
    local removedTrains = {}

    for trainName, trackIds in pairs(trainsOnTrack) do
        local trainOnMap, speed = EEPGetTrainSpeed(trainName) -- EEP 11.0
        if trainOnMap then
            self:updateTrain(trainName, trackIds, speed)
            lastTrains[trainName] = true
        else
            TrainRegistry.trainDisappeared(trainName)
            removedTrains[trainName] = true
        end
    end

    return lastTrains, removedTrains
end

function TrackCollector:removeMissingTrains(missingTrains)
    for trainName in pairs(missingTrains) do
        self.trains[trainName] = nil
        self.trainInfo[trainName] = nil
    end
end

---Go through the list of all trains and update them
---@param knownTrains table<string,table<string,number>> train names and their tracks
---@return table<string,boolean> list of train names
function TrackCollector:checkRollingStock(knownTrains)
    local lastRollingStock = {}
    local removedRollingStock = {}

    for trainName in pairs(knownTrains) do
        local train = TrainRegistry.forName(trainName)
        local count = train:getRollingStockCount()
        for i = 0, count - 1, 1 do
            local rollingStockName = EEPGetRollingstockItemName(train.name, i) -- EEP 13.2 Plug-In 2
            lastRollingStock[rollingStockName] = true
            local rs = RollingStockRegistry.forName(rollingStockName)
            self:updateRollingStock(rs, train, i)
        end
    end

    for name in pairs(self.lastRollingStock) do
        if not lastRollingStock[name] then removedRollingStock[name] = true end
    end

    return lastRollingStock, removedRollingStock
end

function TrackCollector:removeMissingRollingStock(missingRollingStock)
    for rollingStockName in pairs(missingRollingStock) do
        self.rollingStock[rollingStockName] = nil
        self.rollingStockInfo[rollingStockName] = nil
    end
end

function TrackCollector:findAndUpdateTrainsOnTracks()
    -- NOTE: This method will take dirty trains into account and delete them afterwards
    runtimeData = {}

    local tx = os.clock()
    local trainsOnTrack = prepareTrainsOnTrack(self.lastTrains or {}, self.tracks, self.reservedFunction)
    local foundTrains, removedTrains = self:checkTrains(trainsOnTrack)
    self:removeMissingTrains(removedTrains)
    self.lastTrains = foundTrains

    local t2 = os.clock()
    storeRunTime(self.trackType .. "-trainTime", t2 - tx)
    RuntimeRegistry.storeRunTime("TrackCollector." .. self.trackType .. ".updateTrain", t2 - tx)
    RuntimeRegistry.storeRunTime("TrackCollector.ALL.updateTrain", t2 - tx)

    local foundRollingStock, removedRollingStock = self:checkRollingStock(foundTrains)
    self:removeMissingRollingStock(removedRollingStock)
    self.lastRollingStock = foundRollingStock

    local t3 = os.clock()
    storeRunTime(self.trackType .. "-rollingStockTime", t3 - t2)
    RuntimeRegistry.storeRunTime("TrackCollector." .. self.trackType .. ".updateRollingStock", t3 - t2)
    RuntimeRegistry.storeRunTime("TrackCollector.ALL.updateRollingStock", t3 - t2)
    RuntimeRegistry.storeRunTime("TrackCollector." .. self.trackType .. ".OVERALL", t3 - tx)
    RuntimeRegistry.storeRunTime("TrackCollector.ALL.OVERALL", t3 - tx)

    self.dirtyTrainNames = {}
end

function TrackCollector:updateTrain(trainName, trackIds, speed)
    local tx = os.clock()
    local train, created = TrainRegistry.forName(trainName)
    RuntimeRegistry.storeRunTime("TrainRegistry.forName", os.clock() - tx)
    if created or train:getSpeed() ~= 0 or speed ~= 0 or self.dirtyTrainNames[trainName] then
        local start1 = os.clock()
        self.dirtyTrainNames[trainName] = true
        train:setSpeed(speed);
        train:setOnTrack(trackIds)
        train:setTrackType(self.trackType)
        RuntimeRegistry.storeRunTime("TrackCollector.updateTrain", os.clock() - start1)
    else
        RuntimeRegistry.storeRunTime("TrackCollector.updateTrainSkipped", 0)
    end

    self.trains[trainName] = train:toJsonStatic()
    self.trainInfo[trainName] = train:toJsonDynamic()
end

---Update the rolling stock
---@param rs RollingStock
---@param currentTrain Train
---@param positionInTrain integer
function TrackCollector:updateRollingStock(rs, currentTrain, positionInTrain)
    if self.dirtyTrainNames[currentTrain] or rs:getPositionInTrain() == -1 then
        local start1 = os.clock()

        rs:setPositionInTrain(positionInTrain)
        rs:setTrainName(currentTrain.name)
        rs:setTrackType(currentTrain.trackType)

        RuntimeRegistry.storeRunTime("TrackCollector.updateRollingStock", os.clock() - start1)

        local start2 = os.clock()
        local _, trackId, trackDistance, trackDirection, trackSystem = EEPRollingstockGetTrack(rs.rollingStockName)
        -- EEP 14.2

        local rollingStockMoved = trackId ~= rs:getTrackId() or trackDistance ~= rs:getTrackDistance()
        rs:setTrack(trackId, trackDistance, trackDirection, trackSystem)

        if rollingStockMoved then
            local hasPos, PosX, PosY, PosZ = EEPRollingstockGetPosition(rs.rollingStockName) -- EEP 16.1
            local hasMileage, mileage = EEPRollingstockGetMileage(rs.rollingStockName) -- EEP 16.1

            if hasPos then
                rs:setPosition(hasPos and tonumber(PosX) or -1, hasPos and tonumber(PosY) or -1,
                               hasPos and tonumber(PosZ) or -1)
            end
            if hasMileage then rs:setMileage(mileage) end
        end
        RuntimeRegistry.storeRunTime("TrackCollector.updateRollingStockInfo", os.clock() - start2)
    else
        RuntimeRegistry.storeRunTime("TrackCollector.updateRollingStockSkipped", 0)
    end

    self.rollingStock[rs.rollingStockName] = rs:toJsonStatic()
    self.rollingStockInfo[rs.rollingStockName] = rs:toJsonDynamic()
end

function TrackCollector:initialize()
    for id = 1, MAX_TRACKS do
        local exists = self.registerFunction(id)
        if exists then
            local track = {}
            track.id = id
            -- track.position = val
            self.tracks[tostring(track.id)] = track
        end
    end

    -- TODO: Send event only with detected changes
    EventBroker.fireListChange(self.trackType .. "-" .. "tracks", "id", self.tracks)

    self:findAndUpdateTrainsOnTracks()
end

function TrackCollector:update() self:findAndUpdateTrainsOnTracks() end

function TrackCollector:reactOnTrainChanges()
    -- React to train changes from EEP
    local _EEPOnTrainCoupling = EEPOnTrainCoupling or function() -- EEP 14 Plug-In 1
    end
    EEPOnTrainCoupling = function(trainA, trainB, trainNew)
        -- Mark these trains as dirty, i.e. refresh their data
        self.dirtyTrainNames[trainA] = true
        self.dirtyTrainNames[trainB] = true
        self.dirtyTrainNames[trainNew] = true
        -- Call the original function
        return _EEPOnTrainCoupling(trainA, trainB, trainNew)
    end

    local _EEPOnTrainLooseCoupling = EEPOnTrainLooseCoupling or function() -- EEP 14 Plug-In 1
    end
    EEPOnTrainLooseCoupling = function(trainA, trainB, trainNew)
        -- Mark these trains as dirty, i.e. refresh their data
        self.dirtyTrainNames[trainA] = true
        self.dirtyTrainNames[trainB] = true
        self.dirtyTrainNames[trainNew] = true
        -- Call the original function
        return _EEPOnTrainLooseCoupling(trainA, trainB, trainNew)
    end

    local _EEPOnTrainExitTrainyard = EEPOnTrainExitTrainyard or function() -- EEP 14 Plug-In 1
    end
    EEPOnTrainExitTrainyard = function(depotId, trainName)
        self.dirtyTrainNames[trainName] = true
        return _EEPOnTrainExitTrainyard(depotId, trainName)
    end
end

function TrackCollector:updateData()
    self:findAndUpdateTrainsOnTracks()

    return {
        -- [self.trackType .. "-tracks"] = self.tracks,
        -- [self.trackType .. "-trains"] = self.trains,
        -- [self.trackType .. "-train-infos-dynamic"] = self.trainInfo,
        -- [self.trackType .. "-rolling-stocks"] = self.rollingStock,
        -- [self.trackType .. "-rolling-stock-infos-dynamic"] = self.rollingStockInfo,
        -- [self.trackType .. "-runtime"] = runtimeData
    }
end

function TrackCollector:new(trackType)
    assert(trackType, "Bitte geben Sie den Namen \"trackType\" an.")
    assert(registerFunction[trackType], "trackType must be one of 'auxiliary', 'control', 'road', 'rail', 'tram'")

    local o = {
        registerFunction = registerFunction[trackType],
        reservedFunction = reservedFunction[trackType],
        trackType = trackType,
        tracks = {},
        trains = {}, -- all currently known trains of this tracktype
        cachedTrains = {},
        trainInfo = {},
        rollingStock = {},
        rollingStockInfo = {},
        dirtyTrainNames = {}, -- all changes from outside will create an entry here
        lastRollingStock = {}
    }

    self.__index = self
    setmetatable(o, self)
    o:reactOnTrainChanges()
    return o
end

return TrackCollector
