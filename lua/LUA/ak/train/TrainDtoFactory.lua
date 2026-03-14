if AkDebugLoad then print("[#Start] Loading ak.train.TrainDtoFactory ...") end

local DtoFactoryUtils = require("ak.data.DtoFactoryUtils")

local TrainDtoFactory = {}

local ROOM = "trains"
local KEY_ID = "id"

function TrainDtoFactory.createTrainDto(train)
    local dto = DtoFactoryUtils.toDto(train)
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
