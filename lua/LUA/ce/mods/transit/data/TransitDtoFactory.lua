if AkDebugLoad then print("[#Start] Loading ce.mods.transit.data.TransitDtoFactory ...") end

local TransitDtoFactory = {}

local function toTransitStationDto(station)
    return {
        id = station.id or station.name
    }
end

local function toTransitLineSegmentStationDto(stationInfo)
    local station = stationInfo.station or {}
    return {
        station = {
            name = station.name
        },
        timeToStation = stationInfo.timeToStation
    }
end

local function toTransitLineSegmentDto(lineSegment)
    local stations = {}
    local stationInfos = lineSegment.stationInfos or lineSegment.stations or {}
    for _, stationInfo in pairs(stationInfos) do
        table.insert(stations, toTransitLineSegmentStationDto(stationInfo))
    end
    return {
        id = lineSegment.id,
        destination = lineSegment.destination,
        routeName = lineSegment.routeName,
        lineNr = lineSegment.lineNr or (lineSegment.line and lineSegment.line.nr),
        stations = stations
    }
end

local function toTransitLineDto(line)
    local lineSegments = {}
    for _, lineSegment in pairs(line.lineSegments or {}) do
        table.insert(lineSegments, toTransitLineSegmentDto(lineSegment))
    end
    return {
        id = line.id or line.nr,
        nr = line.nr,
        trafficType = line.trafficType,
        lineSegments = lineSegments
    }
end

local function toTransitModuleSettingDto(setting)
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

function TransitDtoFactory.createTransitStationDto(station)
    return createDto("transit-stations", "id", station, toTransitStationDto)
end

function TransitDtoFactory.createTransitStationDtoList(stations)
    return createDtoList("transit-stations", "id", stations,
                         TransitDtoFactory.createTransitStationDto)
end

function TransitDtoFactory.createTransitLineDto(line)
    return createDto("transit-lines", "id", line, toTransitLineDto)
end

function TransitDtoFactory.createTransitLineDtoList(lines)
    return createDtoList("transit-lines", "id", lines, TransitDtoFactory.createTransitLineDto)
end

function TransitDtoFactory.createTransitModuleSettingDto(setting)
    return createDto("transit-module-settings", "name", setting, toTransitModuleSettingDto)
end

function TransitDtoFactory.createTransitModuleSettingDtoList(settings)
    return createDtoList("transit-module-settings", "name", settings,
                         TransitDtoFactory.createTransitModuleSettingDto)
end

function TransitDtoFactory.createTransitLineNameDto(line)
    return createDto("transit-line-names", "id", line, toTransitLineDto)
end

function TransitDtoFactory.createTransitLineNameDtoList(lines)
    return createDtoList("transit-line-names", "id", lines,
                         TransitDtoFactory.createTransitLineNameDto)
end

return TransitDtoFactory
