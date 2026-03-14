if AkDebugLoad then print("[#Start] Loading ak.data.TimeDtoFactory ...") end

local TimeDtoFactory = {}

function TimeDtoFactory.createTimeDto(timeData)
    return {
        id = timeData.id,
        name = timeData.name,
        timeComplete = timeData.timeComplete,
        timeH = timeData.timeH,
        timeM = timeData.timeM,
        timeS = timeData.timeS
    }
end

function TimeDtoFactory.createTimeDtoList(times)
    local timeDtos = {}

    for i = 1, #times do
        timeDtos[i] = TimeDtoFactory.createTimeDto(times[i])
    end

    return timeDtos
end

return TimeDtoFactory
