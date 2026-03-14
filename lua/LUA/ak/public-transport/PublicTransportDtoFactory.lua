if AkDebugLoad then print("[#Start] Loading ak.public-transport.PublicTransportDtoFactory ...") end

local DtoFactoryUtils = require("ak.data.DtoFactoryUtils")

local PublicTransportDtoFactory = {}

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

function PublicTransportDtoFactory.createPublicTransportStationDto(station)
    return createDto("public-transport-stations", "id", station)
end

function PublicTransportDtoFactory.createPublicTransportStationDtoList(stations)
    return createDtoList("public-transport-stations", "id", stations)
end

function PublicTransportDtoFactory.createPublicTransportLineDto(line)
    return createDto("public-transport-lines", "id", line)
end

function PublicTransportDtoFactory.createPublicTransportLineDtoList(lines)
    return createDtoList("public-transport-lines", "id", lines)
end

function PublicTransportDtoFactory.createPublicTransportModuleSettingDto(setting)
    return createDto("public-transport-module-settings", "name", setting)
end

function PublicTransportDtoFactory.createPublicTransportModuleSettingDtoList(settings)
    return createDtoList("public-transport-module-settings", "name", settings)
end

function PublicTransportDtoFactory.createPublicTransportLineNameDto(line)
    return createDto("public-transport-line-names", "id", line)
end

function PublicTransportDtoFactory.createPublicTransportLineNameDtoList(lines)
    return createDtoList("public-transport-line-names", "id", lines)
end

return PublicTransportDtoFactory
