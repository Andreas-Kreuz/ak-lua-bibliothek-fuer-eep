if AkDebugLoad then print("[#Start] Loading ce.hub.data.runtime.RuntimeDtoFactory ...") end

local RuntimeDtoFactory = {}

local ROOM = "runtime"
local KEY_ID = "id"

local function toRuntimeDto(runtimeEntry)
    return {
        id = runtimeEntry.id,
        count = runtimeEntry.count,
        time = runtimeEntry.time,
        lastTime = runtimeEntry.lastTime
    }
end

function RuntimeDtoFactory.createRuntimeDto(runtimeEntry)
    local dto = toRuntimeDto(runtimeEntry)
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
