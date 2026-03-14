if AkDebugLoad then print("[#Start] Loading ak.road.CrossingDtoFactory ...") end

local DtoFactoryUtils = require("ak.data.DtoFactoryUtils")

local CrossingDtoFactory = {}

local function createDto(room, keyId, value)
    local dto = DtoFactoryUtils.toDto(value)
    return room, keyId, dto[keyId], dto
end

local function createDtoList(room, keyId, values)
    local dtos = {}

    for key, value in pairs(values) do
        local _, _, _, dto = createDto(room, keyId, value)
        dtos[key] = dto
    end

    return room, keyId, dtos
end

function CrossingDtoFactory.createIntersectionDto(intersection)
    return createDto("intersections", "id", intersection)
end

function CrossingDtoFactory.createIntersectionDtoList(intersections)
    return createDtoList("intersections", "id", intersections)
end

function CrossingDtoFactory.createIntersectionLaneDto(lane)
    return createDto("intersection-lanes", "id", lane)
end

function CrossingDtoFactory.createIntersectionLaneDtoList(lanes)
    return createDtoList("intersection-lanes", "id", lanes)
end

function CrossingDtoFactory.createIntersectionSwitchingDto(switching)
    return createDto("intersection-switchings", "id", switching)
end

function CrossingDtoFactory.createIntersectionSwitchingDtoList(switchings)
    return createDtoList("intersection-switchings", "id", switchings)
end

function CrossingDtoFactory.createIntersectionTrafficLightDto(trafficLight)
    return createDto("intersection-traffic-lights", "id", trafficLight)
end

function CrossingDtoFactory.createIntersectionTrafficLightDtoList(trafficLights)
    return createDtoList("intersection-traffic-lights", "id", trafficLights)
end

function CrossingDtoFactory.createIntersectionModuleSettingDto(setting)
    return createDto("intersection-module-settings", "name", setting)
end

function CrossingDtoFactory.createIntersectionModuleSettingDtoList(settings)
    return createDtoList("intersection-module-settings", "name", settings)
end

return CrossingDtoFactory
