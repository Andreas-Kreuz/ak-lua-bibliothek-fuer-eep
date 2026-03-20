if AkDebugLoad then print("[#Start] Loading ce.hub.data.time.TimeDtoFactory ...") end

local TimeDtoFactory = {}

local ROOM = "times"
local KEY_ID = "id"

local function toTimeDto(timeData)
    return {
        id = timeData.id,
        name = timeData.name,
        timeComplete = timeData.timeComplete,
        timeH = timeData.timeH,
        timeM = timeData.timeM,
        timeS = timeData.timeS
    }
end

function TimeDtoFactory.createTimeDto(timeData)
    local dto = toTimeDto(timeData)
    return ROOM, KEY_ID, dto[KEY_ID], dto
end

function TimeDtoFactory.createTimeDtoList(times)
    local timeDtos = {}

    for i = 1, #times do
        local _, _, _, dto = TimeDtoFactory.createTimeDto(times[i])
        timeDtos[i] = dto
    end

    return ROOM, KEY_ID, timeDtos
end

return TimeDtoFactory
