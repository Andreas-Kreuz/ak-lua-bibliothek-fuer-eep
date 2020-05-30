if AkDebugLoad then print("Loading ak.data.TrackCollector ...") end
local TrackCollector = {}
local os = require("os")

local MAX_TRACKS = 50000

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
local EEPRollingstockModelTypeText = {
    [1] = "Tenderlok",
    [2] = "Schlepptenderlok",
    [3] = "Tender",
    [4] = "Elektrolok",
    [5] = "Diesellok",
    [6] = "Triebwagen",
    [7] = "U- oder S-Bahn",
    [8] = "Strassenbahn", -- avoid German Umlaute
    [9] = "Gueterwaggon", -- avoid German Umlaute
    [10] = "Personenwaggon",
    [11] = "Luftfahrzeug",
    [12] = "Maschine",
    [13] = "Wasserfahrzeug",
    [14] = "LKW",
    [15] = "PKW"
}

local runtimeData = {}

--- Store runtime information
-- @author Frank Buchholz
function storeRunTime(group, time)
    -- collect and sum runtime date, needs rework
    if not runtimeData then
        runtimeData = {}
    end
    if not runtimeData[group] then
        runtimeData[group] = {
            id = group,
            count = 0,
            time = 0
        }
    end
    local runtime = runtimeData[group]
    runtime.count = runtime.count + 1
    runtime.time = runtime.time + time
end

--- Indirect call of EEP function (or any other function) including time measurement
-- @author Frank Buchholz
function executeAndStoreRunTime(func, group, ...)
    if not func then
        return
    end

    local t0 = os.clock()

    local result = {func(...)}

    local t1 = os.clock()
    storeRunTime(group, t1 - t0)

    return table.unpack(result)
end

--- Create dummy functions for EEP functions which are not yet available depending of the version of EEP
-- -- The minimal required version is EEP 11.3 Plug-In 3 which supports some quite important functions
-- local EEPGetSignalTrainsCount = EEPGetSignalTrainsCount or function()
--         return
--     end -- EEP 13.2

-- local EEPGetSignalTrainName = EEPGetSignalTrainName or function()
--         return
--     end -- EEP 13.2

-- Based on this concept we can redefine the functions, e.g. to collect some statistics data
--EEPGetRollingstockItemsCount = EEPGetRollingstockItemsCount  or function () return end -- EEP 13.2 Plug-In 2
local _EEPGetRollingstockItemsCount = EEPGetRollingstockItemsCount
local function EEPGetRollingstockItemsCount(...)
    return executeAndStoreRunTime(_EEPGetRollingstockItemsCount, "EEPGetRollingstockItemsCount", ...)
end

local EEPGetTrainLength = EEPGetTrainLength or function()
        return
    end -- EEP 15.1 Plug-In 1

local EEPRollingstockGetPosition = EEPRollingstockGetPosition or function()
        return
    end -- EEP 16.1
local EEPRollingstockGetLength = EEPRollingstockGetLength or function()
        return
    end -- EEP 14.2
local EEPRollingstockGetMotor = EEPRollingstockGetMotor or function()
        return
    end -- EEP 14.2
local EEPRollingstockGetTrack = EEPRollingstockGetTrack or function()
        return
    end -- EEP 14.2
local EEPRollingstockGetModelType = EEPRollingstockGetModelType or function()
        return
    end -- EEP 14.2
EEPRollingstockGetTagText = EEPRollingstockGetTagText or function()
        return
    end -- EEP 14.2

-- Redefine functions from EEP 11.0 to collect run time data
local _EEPGetTrainSpeed = EEPGetTrainSpeed
local function EEPGetTrainSpeed(...)
    return executeAndStoreRunTime(_EEPGetTrainSpeed, "EEPGetTrainSpeed", ...)
end
local _EEPGetRollingstockItemName = EEPGetRollingstockItemName or function()
        return
    end -- EEP 13.2 Plug-In 2
local function EEPGetRollingstockItemName(...)
    return executeAndStoreRunTime(_EEPGetRollingstockItemName, "EEPGetRollingstockItemName", ...)
end

function TrackCollector:updateTrains()
    runtimeData = {}
    local t0 = os.clock()

    -- Remove missing trains
    for trainName, train in pairs(self.trains) do
        local haveSpeed, speed = EEPGetTrainSpeed(trainName) -- EEP 11.0
        if haveSpeed then
            train.speed = speed
        else
            self.trains[trainName] = nil
            self.trainInfo[trainName] = nil
        end
    end

    local t1 = os.clock()
    storeRunTime(self.trackType .. "-trainTime (remove)", t1 - t0)

    -- Update the trains, if they are dirty not yet in the list
    local movedTrains = {}
    for _, track in pairs(self.tracks) do
        local trackId = track.id
        -- Limitation: only the first train on a track is found
        local _, occupied, trainName = self.reservedFunction(trackId, true)
        if occupied then
            if trainName then
                if (not self.trains[trainName] or self.dirtyTrainNames[trainName]) then
                    self:updateTrain(trainName)
                    movedTrains[trainName] = true
                else
                    if self.trains[trainName].onTrack ~= trackId then
                        movedTrains[trainName] = true
                    end
                end

                -- Update the trains
                self:updateTrainInfo(trainName, trackId)
            end
        end

    end

    local t2 = os.clock()
    storeRunTime(self.trackType .. "-trainTime", t2 - t1)

    -- Update the rollingstock, if they are dirty not yet in the list
    for rollingStockName, rollingStock in pairs(self.rollingStock) do
        -- Remove all rollingstock without a train
        if not self.trains[rollingStock.trainName] then
            self.rollingStock[rollingStockName] = nil
            self.rollingStockInfo[rollingStockName] = nil
        end

        if movedTrains[rollingStock.trainName] then
            self:updateRollingStockInfo(rollingStockName)
        end
    end

    self.dirtyTrainNames = {}

    local t3 = os.clock()
    storeRunTime(self.trackType .. "-rollingStockTime", t3 - t2)
    -- print(
    --     string.format(
    --         "Track Collector %s took " ..
    --             "\n    %.2f s remove old trains," .. "\n    %.2f s update trains"
    --             .. "\n    %.2f s update rollingstock",
    --         self.trackType,
    --         t1 - t0,
    --         t2 - t1,
    --         t3 - t2
    --     )
    -- )
end

function TrackCollector:updateTrain(trainName)
    -- Store trains
    local haveRoute, route = EEPGetTrainRoute(trainName) -- EEP 11.2 Plugin 2

    local rollingStockCount = EEPGetRollingstockItemsCount(trainName) -- EEP 13.2 Plug-In 2
    local hasTrainLength, trainLength = EEPGetTrainLength(trainName) -- EEP 15.1 Plug-In 1

    local currentTrain = {
        id = trainName,
        route = haveRoute and route or "",
        rollingStockCount = rollingStockCount or 0,
        length = trainLength or 0
    }
    self.trains[trainName] = currentTrain

    if rollingStockCount then
        for i = 0, (currentTrain.rollingStockCount - 1) do
            local rollingStockName = EEPGetRollingstockItemName(currentTrain.id, i) -- EEP 13.2 Plug-In 2
            local currentRollingStock = self:updateRollingStock(rollingStockName, currentTrain, i)
            if not hasTrainLength and trainLength then
                currentTrain.length = currentTrain.length + currentRollingStock
            end
        end
        currentTrain.length = tonumber(string.format("%.2f", currentTrain.length or 0))
    end
end

function TrackCollector:updateTrainInfo(trainName, trackId)
    local _, speed = EEPGetTrainSpeed(trainName) -- EEP 11.0
    local trainInfo = self.trainInfo[trainName] or {}
    trainInfo.id = trainName
    trainInfo.trackType = self.trackType
    trainInfo.speed = tonumber(string.format("%.4f", speed or 0))
    trainInfo.onTrack = trackId
    trainInfo.occupiedTacks = trainInfo.occupiedTacks or {}
    trainInfo.occupiedTacks[tostring(trackId)] = trackId
    if not self.trainInfo[trainName] then
        self.trainInfo[trainName] = trainInfo
    end
end

function TrackCollector:updateRollingStock(rollingStockName, currentTrain, positionInTrain)
    -- 1 Kupplung scharf, 2 Abstoﬂen, 3 Gekuppelt
    local _, couplingFront = EEPRollingstockGetCouplingFront(rollingStockName) -- EEP 11.0
    local _, couplingRear = EEPRollingstockGetCouplingRear(rollingStockName) -- EEP 11.0

    local _, length = EEPRollingstockGetLength(rollingStockName) -- EEP 15
    local _, propelled = EEPRollingstockGetMotor(rollingStockName) -- EEP 14.2
    local _, modelType = EEPRollingstockGetModelType(rollingStockName) -- EEP 14.2
    local _, tag = EEPRollingstockGetTagText(rollingStockName) -- EEP 14.2

    local currentRollingStock = {
        name = rollingStockName,
        trainName = currentTrain.id,
        positionInTrain = positionInTrain,
        couplingFront = couplingFront,
        couplingRear = couplingRear,
        length = tonumber(string.format("%.2f", length or -1)),
        propelled = propelled or true,
        modelType = modelType or -1,
        modelTypeText = EEPRollingstockModelTypeText[modelType] or "",
        tag = tag or ""
    }

    -- Save
    self.rollingStock[rollingStockName] = currentRollingStock
    return currentRollingStock
end

function TrackCollector:updateRollingStockInfo(rollingStockName)
    local _, trackId, trackDistance, trackDirection, trackSystem = EEPRollingstockGetTrack(rollingStockName)
    -- EEP 14.2
    local hasPos, PosX, PosY, PosZ = EEPRollingstockGetPosition(rollingStockName) -- EEP 16.1

    local rollingStockInfo = {
        name = rollingStockName,
        trackId = trackId or -1,
        trackDistance = tonumber(string.format("%.2f", trackDistance or -1)),
        trackDirection = trackDirection or -1,
        trackSystem = trackSystem or -1,
        posX = hasPos and tonumber(PosX) or -1,
        posY = hasPos and tonumber(PosY) or -1,
        posZ = hasPos and tonumber(PosZ) or -1
    }
    self.rollingStockInfo[rollingStockName] = rollingStockInfo
end

function TrackCollector:initialize()
    for id = 1, MAX_TRACKS do
        local exists = self.registerFunction(id)
        if exists then
            local track = {}
            track.id = id
            --track.position = val
            self.tracks[tostring(track.id)] = track
        end
    end

    self:updateTrains()
end

function TrackCollector:update()
    self:updateTrains()
end

function TrackCollector:reactOnTrainChanges()
    -- React to train changes from EEP
    local _EEPOnTrainCoupling = EEPOnTrainCoupling or function()
        end
    EEPOnTrainCoupling = function(trainA, trainB, trainNew)
        -- Mark these trains as dirty, i.e. refresh their data
        self.dirtyTrainNames[trainA] = true
        self.dirtyTrainNames[trainB] = true
        self.dirtyTrainNames[trainNew] = true
        -- Call the original function
        return _EEPOnTrainCoupling(trainA, trainB, trainNew)
    end

    local _EEPOnTrainLooseCoupling = EEPOnTrainLooseCoupling or function()
        end
    EEPOnTrainLooseCoupling = function(trainA, trainB, trainNew)
        -- Mark these trains as dirty, i.e. refresh their data
        self.dirtyTrainNames[trainA] = true
        self.dirtyTrainNames[trainB] = true
        self.dirtyTrainNames[trainNew] = true
        -- Call the original function
        return _EEPOnTrainLooseCoupling(trainA, trainB, trainNew)
    end

    local _EEPOnTrainExitTrainyard = EEPOnTrainExitTrainyard or function()
        end
    EEPOnTrainExitTrainyard = function(depotId, trainName)
        self.dirtyTrainNames[trainName] = true
        return _EEPOnTrainExitTrainyard(depotId, trainName)
    end
end

function TrackCollector:updateData()
    self:updateTrains()
    return {
        [self.trackType .. "-tracks"] = self.tracks,
        [self.trackType .. "-trains"] = self.trains,
        [self.trackType .. "-train-infos-dynamic"] = self.trainInfo,
        [self.trackType .. "-rolling-stocks"] = self.rollingStock,
        [self.trackType .. "-rolling-stock-infos-dynamic"] = self.rollingStockInfo,
        [self.trackType .. "-runtime"] = runtimeData
    }
end

function TrackCollector:new(trackType)
    assert(trackType, 'Bitte geben Sie den Namen "trackType" fuer diese Richtung an.')
    assert(registerFunction[trackType], "trackType must be one of 'auxiliary', 'control', 'road', 'rail', 'tram'")

    local o = {
        registerFunction = registerFunction[trackType],
        reservedFunction = reservedFunction[trackType],
        trackType = trackType,
        tracks = {},
        trains = {}, -- all currently known trains of this tracktype
        trainInfo = {},
        rollingStock = {},
        rollingStockInfo = {},
        dirtyTrainNames = {} -- all changes from outside will create an entry here
    }

    self.__index = self
    setmetatable(o, self)
    o:reactOnTrainChanges()
    return o
end

return TrackCollector
