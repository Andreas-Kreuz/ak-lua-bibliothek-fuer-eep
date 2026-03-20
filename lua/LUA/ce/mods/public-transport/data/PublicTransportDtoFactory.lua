if AkDebugLoad then print("[#Start] Loading ce.mods.public-transport.data.PublicTransportDtoFactory ...") end

local PublicTransportDtoFactory = {}

local function toPublicTransportStationDto(station)
    return {
        id = station.id or station.name
    }
end

local function toPublicTransportLineSegmentStationDto(stationInfo)
    local station = stationInfo.station or {}
    return {
        station = {
            name = station.name
        },
        timeToStation = stationInfo.timeToStation
    }
end

local function toPublicTransportLineSegmentDto(lineSegment)
    local stations = {}
    local stationInfos = lineSegment.stationInfos or lineSegment.stations or {}
    for _, stationInfo in pairs(stationInfos) do
        table.insert(stations, toPublicTransportLineSegmentStationDto(stationInfo))
    end
    return {
        id = lineSegment.id,
        destination = lineSegment.destination,
        routeName = lineSegment.routeName,
        lineNr = lineSegment.lineNr or (lineSegment.line and lineSegment.line.nr),
        stations = stations
    }
end

local function toPublicTransportLineDto(line)
    local lineSegments = {}
    for _, lineSegment in pairs(line.lineSegments or {}) do
        table.insert(lineSegments, toPublicTransportLineSegmentDto(lineSegment))
    end
    return {
        id = line.id or line.nr,
        nr = line.nr,
        trafficType = line.trafficType,
        lineSegments = lineSegments
    }
end

local function toPublicTransportModuleSettingDto(setting)
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

function PublicTransportDtoFactory.createPublicTransportStationDto(station)
    return createDto("public-transport-stations", "id", station, toPublicTransportStationDto)
end

function PublicTransportDtoFactory.createPublicTransportStationDtoList(stations)
    return createDtoList("public-transport-stations", "id", stations,
                         PublicTransportDtoFactory.createPublicTransportStationDto)
end

function PublicTransportDtoFactory.createPublicTransportLineDto(line)
    return createDto("public-transport-lines", "id", line, toPublicTransportLineDto)
end

function PublicTransportDtoFactory.createPublicTransportLineDtoList(lines)
    return createDtoList("public-transport-lines", "id", lines, PublicTransportDtoFactory.createPublicTransportLineDto)
end

function PublicTransportDtoFactory.createPublicTransportModuleSettingDto(setting)
    return createDto("public-transport-module-settings", "name", setting, toPublicTransportModuleSettingDto)
end

function PublicTransportDtoFactory.createPublicTransportModuleSettingDtoList(settings)
    return createDtoList("public-transport-module-settings", "name", settings,
                         PublicTransportDtoFactory.createPublicTransportModuleSettingDto)
end

function PublicTransportDtoFactory.createPublicTransportLineNameDto(line)
    return createDto("public-transport-line-names", "id", line, toPublicTransportLineDto)
end

function PublicTransportDtoFactory.createPublicTransportLineNameDtoList(lines)
    return createDtoList("public-transport-line-names", "id", lines,
                         PublicTransportDtoFactory.createPublicTransportLineNameDto)
end

return PublicTransportDtoFactory
