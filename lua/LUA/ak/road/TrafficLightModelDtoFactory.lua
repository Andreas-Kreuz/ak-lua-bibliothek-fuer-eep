if AkDebugLoad then print("[#Start] Loading ak.road.TrafficLightModelDtoFactory ...") end

local DtoFactoryUtils = require("ak.data.DtoFactoryUtils")

local TrafficLightModelDtoFactory = {}

local ROOM = "signal-type-definitions"
local KEY_ID = "id"

function TrafficLightModelDtoFactory.createSignalTypeDefinitionDto(definition)
    local dto = DtoFactoryUtils.toDto(definition)
    return ROOM, KEY_ID, dto[KEY_ID], dto
end

function TrafficLightModelDtoFactory.createSignalTypeDefinitionDtoList(definitions)
    local dtos = {}

    for key, definition in pairs(definitions) do
        local _, _, _, dto = TrafficLightModelDtoFactory.createSignalTypeDefinitionDto(definition)
        dtos[key] = dto
    end

    return ROOM, KEY_ID, dtos
end

return TrafficLightModelDtoFactory
