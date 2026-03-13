if AkDebugLoad then print("[#Start] Loading ak.data.TimeRoomDataGenerator ...") end

local TimeRoomDataGenerator = {}

function TimeRoomDataGenerator.toRoomDataTime(timeData)
    return {
        id = timeData.id,
        name = timeData.name,
        timeComplete = timeData.timeComplete,
        timeH = timeData.timeH,
        timeM = timeData.timeM,
        timeS = timeData.timeS
    }
end

function TimeRoomDataGenerator.toRoomDataTimeList(times)
    local roomDataTimes = {}

    for i = 1, #times do
        roomDataTimes[i] = TimeRoomDataGenerator.toRoomDataTime(times[i])
    end

    return roomDataTimes
end

return TimeRoomDataGenerator
