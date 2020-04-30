print "Load ak.data.TrainsAndTracksJsonCollector ..."
TrainsAndTracksJsonCollector = {}
local enabled = true
local initialized = false
TrainsAndTracksJsonCollector.name = "ak.data.TrainsAndTracksJsonCollector"

local MAX_TRACKS = 50000
local data = {}
local tracks = {}

--- Store runtime information
-- @author Frank Buchholz
function storeRunTime(group, time)
    -- collect and sum runtime date, needs rework
    if not data["runtime"] then
        data["runtime"] = {}
    end
    if not data["runtime"][group] then
        data["runtime"][group] = {
            id = group,
            count = 0,
            time = 0
        }
    end
    local runtime = data["runtime"][group]
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
-- The minimal required version is EEP 11.3 Plug-In 3 which supports some quite important functions
EEPGetSignalTrainsCount = EEPGetSignalTrainsCount or function()
        return
    end -- EEP 13.2
EEPGetSignalTrainName = EEPGetSignalTrainName or function()
        return
    end -- EEP 13.2

-- Based on this concept we can redefine the functions, e.g. to collect some statistics data
--EEPGetRollingstockItemsCount = EEPGetRollingstockItemsCount  or function () return end -- EEP 13.2 Plug-In 2
local _EEPGetRollingstockItemsCount = EEPGetRollingstockItemsCount
local function EEPGetRollingstockItemsCount(...)
    return executeAndStoreRunTime(_EEPGetRollingstockItemsCount, "EEPGetRollingstockItemsCount", ...)
end

EEPGetRollingstockItemName = EEPGetRollingstockItemName or function()
        return
    end -- EEP 13.2 Plug-In 2
EEPGetTrainLength = EEPGetTrainLength or function()
        return
    end -- EEP 15.1 Plug-In 1

EEPRollingstockGetPosition = EEPRollingstockGetPosition or function()
        return
    end -- EEP 16.1
EEPRollingstockGetLength = EEPRollingstockGetLength or function()
        return
    end -- EEP 14.2
EEPRollingstockGetMotor = EEPRollingstockGetMotor or function()
        return
    end -- EEP 14.2
EEPRollingstockGetTrack = EEPRollingstockGetTrack or function()
        return
    end -- EEP 14.2
EEPRollingstockGetModelType = EEPRollingstockGetModelType or function()
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
local _EEPGetRollingstockItemName = EEPGetRollingstockItemName
local function EEPGetRollingstockItemName(...)
    return executeAndStoreRunTime(_EEPGetRollingstockItemName, "EEPGetRollingstockItemName", ...)
end

--- Register EEP tracks.
-- The main reason for this is to be able to retrieve the names and positions of all trains and rolling stocks.
-- do it once
local function initializeTracksBy(registerFunktion, trackType)
    local trackName = trackType .. "-tracks"
    tracks[trackName] = {}
    data[trackName] = tracks[trackName]
    for id = 1, MAX_TRACKS do
        local exists = registerFunktion(id)
        if exists then
            local track = {}
            track.id = id
            --track.position = val
            tracks[trackName][tostring(track.id)] = track
        end
    end
end

local function initializeTracks()
    initializeTracksBy(EEPRegisterAuxiliaryTrack, "auxiliary")
    initializeTracksBy(EEPRegisterControlTrack, "control")
    initializeTracksBy(EEPRegisterRoadTrack, "road")
    initializeTracksBy(EEPRegisterRailTrack, "rail")
    initializeTracksBy(EEPRegisterTramTrack, "tram")
end

--- Get EEP rolling stocks and trains located on tracks.
-- do it frequently
local function updateTracksBy(besetztFunktion, trackType)
    local trackName = trackType .. "-tracks"
    local trainList = trackType .. "-trains"
    local rollingStockList = trackType .. "-rolling-stocks"
    local trainInfos = trackType .. "-train-infos-dynamic"
    local rollingStockInfos = trackType .. "-rolling-stock-infos-dynamic"

    -- Find trains on occupied tracks
    -- Limitation: only the first train on a track is found
    local trains = {}
    --local belegte = {}
    --belegte.tracks = {}
    for _, track in pairs(tracks[trackName]) do
        local trackId = track.id
        -- Limitation: only the first train on a track is found
        local _, occupied, trainName = besetztFunktion(trackId, true)

        -- track.occupied = occupied
        -- track.occupiedBy = trainName
        if occupied then
            --local key = trackName .. "_track_" .. trackId
            --belegte.tracks[key] = {}
            --belegte.tracks[key].trackId = trackId
            --belegte.tracks[key].occupied = occupied
            --belegte.tracks[key].vehicle = trainName or "?"

            if trainName then
                trains[trainName] = trains[trainName] or {}
                trains[trainName].trackType = trackName
                trains[trainName].onTrack = trackId
                trains[trainName].occupiedTacks = trains[trainName].occupiedTacks or {}
                trains[trainName].occupiedTacks[tostring(trackId)] = trackId
            end
        end
    end

    -- Add previously known trains which are not found by EEPIs..TrackReserved which happens
    -- if there are multiple trains on a track
    if data[trainInfos] then
        for _, trainsInfo in ipairs(data[trainInfos]) do
            local trainName = trainsInfo.id
            if not trains[trainName] then
                -- Does the train exists?
                local haveSpeed = EEPGetTrainSpeed(trainName) -- EEP 11.0
                if haveSpeed then
                    -- print('Train not found by EEPIs..TrackReserved: ' .. trainName)
                    trains[trainName] = {
                        trackType = trackName,
                        onTrack = trainsInfo.onTrackId,
                        occupiedTacks = trainsInfo.occupiedTacks
                    }
                end
            end
        end
    end

    -- Get and store additional information about trains and rolling stocks
    -- Possible performance improvement: Do not start from scratch but keep static information from functions like
    -- EEPRollingstockGetLength, EEPRollingstockGetMotor, EEPRollingstockGetModelType
    data[trainList] = {}
    data[trainInfos] = {}
    data[rollingStockList] = {}
    data[rollingStockInfos] = {}

    for trainName, train in pairs(trains) do
        -- Store trains
        local _, speed = EEPGetTrainSpeed(trainName) -- EEP 11.0
        local haveRoute, route = EEPGetTrainRoute(trainName) -- EEP 11.2 Plugin 2

        local rollingStockCount = EEPGetRollingstockItemsCount(trainName) -- EEP 13.2 Plug-In 2
        local hasTrainLength, trainLength = EEPGetTrainLength(trainName) -- EEP 15.1 Plug-In 1

        local currentTrain = {
            id = trainName,
            route = haveRoute and route or "",
            rollingStockCount = rollingStockCount or 0,
            length = trainLength or 0,
        }

        table.insert(data[trainList], currentTrain)
        -- data[trainList][tostring(currentTrain.id)] = currentTrain
        local trainsInfo = {
            id = trainName,
            speed = tonumber(string.format("%.4f", speed or 0)),
            onTrackId = train.onTrack,
            occupiedTacks = train.occupiedTacks
        }
        table.insert(data[trainInfos], trainsInfo)
        -- data[trainInfos][tostring(trainsInfo.id)] = trainsInfo

        -- Store rolling stocks
        if not rollingStockCount then
            return
        end

        for i = 0, (rollingStockCount - 1) do
            local rollingStockName = EEPGetRollingstockItemName(trainName, i) -- EEP 13.2 Plug-In 2
            if rollingStockName then
                local _, couplingFront = EEPRollingstockGetCouplingFront(rollingStockName) -- EEP 11.0
                local _, couplingRear = EEPRollingstockGetCouplingRear(rollingStockName) -- EEP 11.0
                -- 1 Kupplung scharf, 2 Abstoﬂen, 3 Gekuppelt
                local hasPos, PosX, PosY, PosZ = EEPRollingstockGetPosition(rollingStockName) -- EEP 16.1

                local hasLength, length = EEPRollingstockGetLength(rollingStockName) -- EEP 15
                if not hasTrainLength and hasLength then
                    currentTrain.length = currentTrain.length + length
                end

                local _, propelled = EEPRollingstockGetMotor(rollingStockName) -- EEP 14.2
                local _, trackId, trackDistance, trackDirection, trackSystem = EEPRollingstockGetTrack(rollingStockName)
                -- EEP 14.2

                local _, modelType = EEPRollingstockGetModelType(rollingStockName) -- EEP 14.2
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

                local _, tag = EEPRollingstockGetTagText(rollingStockName) -- EEP 14.2

                local currentRollingStock = {
                    name = rollingStockName,
                    trainName = trainName,
                    positionInTrain = i,
                    couplingFront = couplingFront,
                    couplingRear = couplingRear,
                    length = tonumber(string.format("%.2f", length or -1)),
                    propelled = propelled or true,
                    trackSystem = trackSystem or -1,
                    modelType = modelType or -1,
                    modelTypeText = EEPRollingstockModelTypeText[modelType] or "",
                    tag = tag or ""
                }
                if hasPos then
                    currentRollingStock.PosX = tonumber(PosX)
                    currentRollingStock.PosY = tonumber(PosY)
                    currentRollingStock.PosZ = tonumber(PosZ)
                end
                table.insert(data[rollingStockList], currentRollingStock)
                -- data[rollingStockList][currentRollingStock.name] = currentRollingStock
                local rollingStockInfo = {
                    name = rollingStockName,
                    trackId = trackId or -1,
                    trackDistance = tonumber(string.format("%.2f", trackDistance or -1)),
                    trackDirection = trackDirection or -1
                }
                table.insert(data[rollingStockInfos], rollingStockInfo)
            -- data[rollingStockInfos][tostring(rollingStockInfo.name)] = rollingStockInfo
            end
        end
        currentTrain.length = tonumber(string.format("%.2f", currentTrain.length or 0))
    end
end

local function updateTracks()
    updateTracksBy(EEPIsAuxiliaryTrackReserved, "auxiliary")
    updateTracksBy(EEPIsControlTrackReserved, "control")
    updateTracksBy(EEPIsRoadTrackReserved, "road")
    updateTracksBy(EEPIsRailTrackReserved, "rail")
    updateTracksBy(EEPIsTramTrackReserved, "tram")
end

function TrainsAndTracksJsonCollector.initialize()
    if not enabled or initialized then
        return
    end

    initializeTracks()

    initialized = true
end

function TrainsAndTracksJsonCollector.collectData()
    if not enabled then
        return
    end

    -- reset runtime data
    data["runtime"] = {}

    if not initialized then
        TrainsAndTracksJsonCollector.initialize()
    end

    updateTracks()

    return data
end

return TrainsAndTracksJsonCollector
