if AkDebugLoad then print("[#Start] Loading ce.mods.road.data.TrafficLightModelDtoFactory ...") end

local TrafficLightModelDtoFactory = {}

local ROOM = "signal-type-definitions"
local KEY_ID = "id"

local function toSignalTypeDefinitionPositionsDto(positions)
    return {
        positionRed = positions.positionRed,
        positionGreen = positions.positionGreen,
        positionYellow = positions.positionYellow,
        positionRedYellow = positions.positionRedYellow,
        positionPedestrians = positions.positionPedestrians,
        positionOff = positions.positionOff,
        positionOffBlinking = positions.positionOffBlinking
    }
end

local function toSignalTypeDefinitionDto(definition)
    return {
        id = definition.id,
        name = definition.name,
        type = definition.type,
        positions = toSignalTypeDefinitionPositionsDto(definition.positions or {})
    }
end

function TrafficLightModelDtoFactory.createSignalTypeDefinitionDto(definition)
    local dto = toSignalTypeDefinitionDto(definition)
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
