if AkDebugLoad then print("[#Start] Loading ak.core.RuntimeDtoFactory ...") end

local DtoFactoryUtils = require("ak.data.DtoFactoryUtils")

local RuntimeDtoFactory = {}

local ROOM = "runtime"
local KEY_ID = "id"

function RuntimeDtoFactory.createRuntimeDto(runtimeEntry)
    local dto = DtoFactoryUtils.toDto(runtimeEntry)
    return ROOM, KEY_ID, dto[KEY_ID], dto
end

function RuntimeDtoFactory.createRuntimeDtoList(runtimeEntries)
    local runtimeDtos = {}

    for runtimeId, runtimeEntry in pairs(runtimeEntries) do
        local _, _, _, dto = RuntimeDtoFactory.createRuntimeDto(runtimeEntry)
        runtimeDtos[runtimeId] = dto
    end

    return ROOM, KEY_ID, runtimeDtos
end

return RuntimeDtoFactory
