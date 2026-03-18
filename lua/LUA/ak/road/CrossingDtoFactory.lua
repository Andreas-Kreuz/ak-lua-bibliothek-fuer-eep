if AkDebugLoad then print("[#Start] Loading ak.road.CrossingDtoFactory ...") end

local CrossingDtoFactory = {}

local function copyTable(values)
    local copy = {}
    for key, value in pairs(values or {}) do copy[key] = value end
    return copy
end

local function toIntersectionDto(intersection)
    return {
        id = intersection.id,
        name = intersection.name,
        currentSwitching = intersection.currentSwitching,
        manualSwitching = intersection.manualSwitching,
        nextSwitching = intersection.nextSwitching,
        ready = intersection.ready,
        timeForGreen = intersection.timeForGreen,
        staticCams = copyTable(intersection.staticCams)
    }
end

local function toIntersectionLaneDto(lane)
    return {
        id = lane.id,
        intersectionId = lane.intersectionId,
        name = lane.name,
        phase = lane.phase,
        vehicleMultiplier = lane.vehicleMultiplier,
        eepSaveId = lane.eepSaveId,
        type = lane.type,
        countType = lane.countType,
        waitingTrains = copyTable(lane.waitingTrains),
        waitingForGreenCyclesCount = lane.waitingForGreenCyclesCount,
        directions = copyTable(lane.directions),
        switchings = copyTable(lane.switchings),
        tracks = copyTable(lane.tracks)
    }
end

local function toIntersectionSwitchingDto(switching)
    return {
        id = switching.id,
        intersectionId = switching.intersectionId,
        name = switching.name,
        prio = switching.prio
    }
end

local function toIntersectionTrafficLightStructureDto(lightStructure)
    return {
        structureRed = lightStructure.structureRed,
        structureGreen = lightStructure.structureGreen,
        structureYellow = lightStructure.structureYellow,
        structureRequest = lightStructure.structureRequest
    }
end

local function toIntersectionTrafficLightAxisStructureDto(axisStructure)
    return {
        structureName = axisStructure.structureName,
        axisName = axisStructure.axisName,
        positionDefault = axisStructure.positionDefault,
        positionRed = axisStructure.positionRed,
        positionGreen = axisStructure.positionGreen,
        positionYellow = axisStructure.positionYellow,
        positionPedestrian = axisStructure.positionPedestrian,
        positionRedYellow = axisStructure.positionRedYellow
    }
end

local function toIntersectionTrafficLightDto(trafficLight)
    local lightStructures = {}
    for key, lightStructure in pairs(trafficLight.lightStructures or {}) do
        lightStructures[key] = toIntersectionTrafficLightStructureDto(lightStructure)
    end

    local axisStructures = {}
    for key, axisStructure in pairs(trafficLight.axisStructures or {}) do
        axisStructures[key] = toIntersectionTrafficLightAxisStructureDto(axisStructure)
    end

    return {
        id = trafficLight.id,
        signalId = trafficLight.signalId,
        modelId = trafficLight.modelId,
        currentPhase = trafficLight.currentPhase,
        intersectionId = trafficLight.intersectionId,
        lightStructures = lightStructures,
        axisStructures = axisStructures
    }
end

local function toIntersectionModuleSettingDto(setting)
    return {
        category = setting.category,
        name = setting.name,
        description = setting.description,
        type = setting.type,
        value = setting.value,
        eepFunction = setting.eepFunction
    }
end

local function createDto(room, keyId, value, toDto)
    local dto = toDto(value)
    return room, keyId, dto[keyId], dto
end

local function createDtoList(room, keyId, values, createSingleDto)
    local dtos = {}

    for key, value in pairs(values) do
        local _, _, _, dto = createSingleDto(value)
        dtos[key] = dto
    end

    return room, keyId, dtos
end

function CrossingDtoFactory.createIntersectionDto(intersection)
    return createDto("intersections", "id", intersection, toIntersectionDto)
end

function CrossingDtoFactory.createIntersectionDtoList(intersections)
    return createDtoList("intersections", "id", intersections, CrossingDtoFactory.createIntersectionDto)
end

function CrossingDtoFactory.createIntersectionLaneDto(lane)
    return createDto("intersection-lanes", "id", lane, toIntersectionLaneDto)
end

function CrossingDtoFactory.createIntersectionLaneDtoList(lanes)
    return createDtoList("intersection-lanes", "id", lanes, CrossingDtoFactory.createIntersectionLaneDto)
end

function CrossingDtoFactory.createIntersectionSwitchingDto(switching)
    return createDto("intersection-switchings", "id", switching, toIntersectionSwitchingDto)
end

function CrossingDtoFactory.createIntersectionSwitchingDtoList(switchings)
    return createDtoList("intersection-switchings", "id", switchings, CrossingDtoFactory.createIntersectionSwitchingDto)
end

function CrossingDtoFactory.createIntersectionTrafficLightDto(trafficLight)
    return createDto("intersection-traffic-lights", "id", trafficLight, toIntersectionTrafficLightDto)
end

function CrossingDtoFactory.createIntersectionTrafficLightDtoList(trafficLights)
    return createDtoList("intersection-traffic-lights", "id", trafficLights,
                         CrossingDtoFactory.createIntersectionTrafficLightDto)
end

function CrossingDtoFactory.createIntersectionModuleSettingDto(setting)
    return createDto("intersection-module-settings", "name", setting, toIntersectionModuleSettingDto)
end

function CrossingDtoFactory.createIntersectionModuleSettingDtoList(settings)
    return createDtoList("intersection-module-settings", "name", settings,
                         CrossingDtoFactory.createIntersectionModuleSettingDto)
end

return CrossingDtoFactory
