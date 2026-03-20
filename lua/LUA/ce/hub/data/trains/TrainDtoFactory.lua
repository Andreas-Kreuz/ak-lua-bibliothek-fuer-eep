if AkDebugLoad then print("[#Start] Loading ce.hub.data.trains.TrainDtoFactory ...") end

local TrainDtoFactory = {}

local ROOM = "trains"
local KEY_ID = "id"

local function copyTable(values)
    local copy = {}
    for key, value in pairs(values or {}) do copy[key] = value end
    return copy
end

local function toTrainDto(train)
    return {
        id = train:getName(),
        route = train:getRoute(),
        rollingStockCount = train:getRollingStockCount(),
        length = train:getLength(),
        line = train:getLine(),
        destination = train:getDestination(),
        direction = train:getDirection(),
        trackType = train:getTrackType(),
        movesForward = train:getMovesForward(),
        speed = train:getSpeed(),
        occupiedTacks = copyTable(train:getOnTrack())
    }
end

function TrainDtoFactory.createTrainDto(train)
    local dto = toTrainDto(train)
    return ROOM, KEY_ID, dto[KEY_ID], dto
end

function TrainDtoFactory.createTrainDtoList(trains)
    local trainDtos = {}

    for trainId, train in pairs(trains) do
        local _, _, _, dto = TrainDtoFactory.createTrainDto(train)
        trainDtos[trainId] = dto
    end

    return ROOM, KEY_ID, trainDtos
end

function TrainDtoFactory.createTrainReferenceDto(trainId)
    local dto = { id = trainId }
    return ROOM, KEY_ID, trainId, dto
end

return TrainDtoFactory
