if AkDebugLoad then print("[#Start] Loading ce.hub.data.version.VersionDtoFactory ...") end

local VersionDtoFactory = {}

local ROOM = "eep-version"
local KEY_ID = "id"
local ENTRY_ID = "versionInfo"

function VersionDtoFactory.createVersionDto(eepVersion, luaVersion, singleVersion)
    local dto = {
        id = ENTRY_ID,
        name = ENTRY_ID,
        eepVersion = eepVersion,
        luaVersion = luaVersion,
        singleVersion = singleVersion
    }

    return ROOM, KEY_ID, dto[KEY_ID], dto
end

function VersionDtoFactory.createVersionDtoList(eepVersion, luaVersion, singleVersion)
    local _, _, _, dto = VersionDtoFactory.createVersionDto(eepVersion, luaVersion, singleVersion)
    return ROOM, KEY_ID, { [ENTRY_ID] = dto }
end

return VersionDtoFactory
