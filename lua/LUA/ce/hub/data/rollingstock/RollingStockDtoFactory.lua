if AkDebugLoad then print("[#Start] Loading ce.hub.data.rollingstock.RollingStockDtoFactory ...") end

local RollingStockDtoFactory = {}

local ROOM = "rolling-stocks"
local KEY_ID = "id"

local function toRollingStockDto(rollingStock)
    return {
        id = rollingStock.rollingStockName,
        name = rollingStock.rollingStockName,
        trainName = rollingStock:getTrainName(),
        positionInTrain = rollingStock:getPositionInTrain(),
        couplingFront = rollingStock:getCouplingFront(),
        couplingRear = rollingStock:getCouplingRear(),
        length = rollingStock:getLength(),
        propelled = rollingStock:getPropelled(),
        modelType = rollingStock:getModelType(),
        modelTypeText = rollingStock:getModelTypeText(),
        tag = rollingStock:getTag(),
        nr = rollingStock:getWagonNr(),
        trackId = rollingStock:getTrackId(),
        trackDistance = rollingStock:getTrackDistance(),
        trackDirection = rollingStock:getTrackDirection(),
        trackSystem = rollingStock:getTrackSystem(),
        trackType = rollingStock:getTrackType(),
        posX = rollingStock:getX(),
        posY = rollingStock:getY(),
        posZ = rollingStock:getZ(),
        mileage = rollingStock:getMileage()
    }
end

function RollingStockDtoFactory.createRollingStockDto(rollingStock)
    local dto = toRollingStockDto(rollingStock)
    return ROOM, KEY_ID, dto[KEY_ID], dto
end

function RollingStockDtoFactory.createRollingStockDtoList(rollingStocks)
    local rollingStockDtos = {}

    for rollingStockId, rollingStock in pairs(rollingStocks) do
        local _, _, _, dto = RollingStockDtoFactory.createRollingStockDto(rollingStock)
        rollingStockDtos[rollingStockId] = dto
    end

    return ROOM, KEY_ID, rollingStockDtos
end

function RollingStockDtoFactory.createRollingStockReferenceDto(rollingStockId)
    local dto = { id = rollingStockId }
    return ROOM, KEY_ID, rollingStockId, dto
end

return RollingStockDtoFactory
