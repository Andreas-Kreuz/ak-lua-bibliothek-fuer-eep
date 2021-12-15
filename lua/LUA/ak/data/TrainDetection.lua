local TrainRegistry = require("ak.train.TrainRegistry")
local RuntimeRegistry = require("ak.util.RuntimeRegistry")
local TrackDetection = require("ak.data.TrackDetection")
local RollingStockRegistry = require("ak.train.RollingStockRegistry")

local TrainDetection = {}

-- trackCollectors will dectect trains by using their RegisteredFunctions
local trackTypes = {"auxiliary", "control", "road", "rail", "tram"}
local trackCollectors = {}
do for _, trackType in ipairs(trackTypes) do trackCollectors[trackType] = TrackDetection:new(trackType) end end

---@type table<string, boolean>
local movedTrainNames = {}
---@type table<string, boolean>
local dirtyTrainNames = {}

---This will register callbacks to get informed, e.g. if a train has been coupled or lost coupling
function TrainDetection.registerForTrainDetection()
    -- React to train changes from EEP
    local _EEPOnTrainCoupling = EEPOnTrainCoupling or function() -- EEP 14 Plug-In 1
    end
    EEPOnTrainCoupling = function(trainA, trainB, trainNew)
        -- Mark these trains as dirty, i.e. refresh their data
        dirtyTrainNames[trainA] = true
        dirtyTrainNames[trainB] = true
        dirtyTrainNames[trainNew] = true
        -- Call the original function
        return _EEPOnTrainCoupling(trainA, trainB, trainNew)
    end

    local _EEPOnTrainLooseCoupling = EEPOnTrainLooseCoupling or function() -- EEP 14 Plug-In 1
    end
    EEPOnTrainLooseCoupling = function(trainA, trainB, trainOld)
        -- Mark these trains as dirty, i.e. refresh their data
        dirtyTrainNames[trainA] = true
        dirtyTrainNames[trainB] = true
        dirtyTrainNames[trainOld] = true
        -- Call the original function
        return _EEPOnTrainLooseCoupling(trainA, trainB, trainOld)
    end

    local _EEPOnTrainExitTrainyard = EEPOnTrainExitTrainyard or function() -- EEP 14 Plug-In 1
    end
    EEPOnTrainExitTrainyard = function(depotId, trainName)
        movedTrainNames[trainName] = true
        return _EEPOnTrainExitTrainyard(depotId, trainName)
    end
end

---Update all the given trains by their name
---@param allKnownTrains table<string, TrainUpdateInfo>
function TrainDetection.refreshTrainInfos(allKnownTrains)
    assert(type(allKnownTrains) == "table", "Need allKnownTrains as table")

    for trainName, info in pairs(allKnownTrains) do
        local train = TrainRegistry.forName(trainName)
        if info.dirty or info.moved then
            local start1 = os.clock()
            train:setSpeed(info.speed);
            train:setOnTrack(info.tracks)
            train:setTrackType(info.trackType)
            RuntimeRegistry.storeRunTime("updateTrain-dynamic+static", os.clock() - start1)

            local start2 = os.clock()
            -- set rollingStockData
            for positionInTrain = 0, train:getRollingStockCount() - 1, 1 do
                local rs = RollingStockRegistry.forName(TrainRegistry.rollingStockNameInTrain(train.name,
                                                                                              positionInTrain))
                if info.dirty then
                    rs:setPositionInTrain(positionInTrain)
                    rs:setTrainName(train.name)
                    rs:setTrackType(train.trackType)
                end
                if info.dirty or info.moved then
                    local _, trackId, trackDistance, trackDirection, trackSystem = EEPRollingstockGetTrack(
                                                                                   rs.rollingStockName) -- EEP 14.2

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
                end
            end
            RuntimeRegistry.storeRunTime("updateRollingStock", os.clock() - start2)
        else
            RuntimeRegistry.storeRunTime("updateTrain-skipped", 0)
        end
    end
end

---Combine all information about given detected trains
---@param detected table<string, boolean> map of trainName -> boolean
---@param dirtyTrains table<string, boolean> map of trainName -> boolean
---@param movedTrains table<string, boolean> map of trainName -> boolean
---@param trainTracks table<string,table<string,table<string,number>>> map of trackType -> trainName -> trackId -> nr
---@return table<string, TrainUpdateInfo>
function TrainDetection.trainInfosForAllTrains(detected, dirtyTrains, movedTrains, trainTracks)
    assert(type(detected) == "table", "Need detected as table")
    assert(type(dirtyTrains) == "table", "Need dirtyTrains as table")
    assert(type(movedTrains) == "table", "Need movedTrains as table")
    assert(type(trainTracks) == "table", "Need trainTracks as table")

    ---@type table<string, TrainUpdateInfo>
    local currentTrainInfos = {}
    local _ = trainTracks
    -- Check train speed and add train to moved or dirty list
    for trainName in pairs(detected) do
        local trainOnMap, speed = EEPGetTrainSpeed(trainName) -- EEP 11.0
        local train, created = TrainRegistry.forName(trainName)
        local moved = train:getSpeed() ~= 0 or speed ~= 0 or (movedTrains[trainName] and true or false)
        local dirty = created or (dirtyTrains[trainName] and true or false) or train:getRollingStockCount() ~=
                      EEPGetRollingstockItemsCount(trainName)
        if trainOnMap then
            ---@class TrainUpdateInfo
            ---@field name string
            ---@field trackType string
            ---@field tracks table<string,number>
            ---@field speed number
            ---@field dirty number
            ---@field created number
            ---@field moved number
            local info = {name = trainName, speed = speed, created = created, dirty = dirty, moved = moved}
            currentTrainInfos[trainName] = info

            if not created and info.dirty then TrainRegistry.initRollingStock(train) end
        else
            TrainRegistry.trainDisappeared(trainName)
            -- removedTrains[trainName] = true
        end
    end

    -- Add tracktype and tracks to knownTrains
    for trackType, tt in pairs(trainTracks) do
        for trainName, tracks in pairs(tt) do
            local info = currentTrainInfos[trainName]
            if info then
                info.tracks = tracks
                info.trackType = trackType
            end
        end
    end

    return currentTrainInfos
end

---Called once for initialization
function TrainDetection.initialize()
    TrainDetection.registerForTrainDetection()
    for _, trackDetection in pairs(trackCollectors) do trackDetection:initialize() end
end

---Called after initialization and in each data detection cycle
function TrainDetection.update()
    local time = os.clock()
    ---@type table<string, boolean>
    local dirty = dirtyTrainNames
    local moved = movedTrainNames
    local detected = {}
    local trainTracks = {}
    for trainName in pairs(dirty) do detected[trainName] = true end
    for trainName in pairs(moved) do detected[trainName] = true end
    for trackType, trackDetection in pairs(trackCollectors) do
        local trainsOnTracks = trackDetection:findTrainsOnTrack()
        for trainName in pairs(trainsOnTracks) do detected[trainName] = true end
        trainTracks[trackType] = trainsOnTracks
    end
    RuntimeRegistry.storeRunTime("TrainDetection.findTrainsOnTrack", os.clock() - time)

    -- Gather all information for the detected train names
    time = os.clock()
    local allKnownTrains = TrainDetection.trainInfosForAllTrains(detected, dirty, moved, trainTracks);
    RuntimeRegistry.storeRunTime("TrainDetection.trainInfosForAllTrains", os.clock() - time)

    -- Update all known trains by their information
    time = os.clock()
    TrainDetection.refreshTrainInfos(allKnownTrains);
    RuntimeRegistry.storeRunTime("TrainDetection.updateKnownTrains", os.clock() - time)

    -- Wipe all moved and dirty trains before for the next update
    dirtyTrainNames = {}
    movedTrainNames = {}
end

return TrainDetection