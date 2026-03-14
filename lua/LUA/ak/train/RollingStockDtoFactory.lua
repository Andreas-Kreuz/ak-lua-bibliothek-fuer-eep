if AkDebugLoad then print("[#Start] Loading ak.train.RollingStockDtoFactory ...") end

local DtoFactoryUtils = require("ak.data.DtoFactoryUtils")

local RollingStockDtoFactory = {}

local ROOM = "rolling-stocks"
local KEY_ID = "id"

function RollingStockDtoFactory.createRollingStockDto(rollingStock)
    local dto = DtoFactoryUtils.toDto(rollingStock)
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
