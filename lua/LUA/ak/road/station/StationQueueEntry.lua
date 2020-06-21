if AkDebugLoad then print("Loading ak.road.station.StationQueueEntry ...") end

---@class StationQueueEntry<T>
local StationQueueEntry = {}
function StationQueueEntry:new(trainName, timeInMinutes, platform)
    local _, line = EEPGetTrainRoute(trainName)
    line = string.sub(line, -2)
    local _, destination = EEPGetTrainRoute(trainName)
    local o = {
        trainName = trainName,
        line = line,
        destination = destination,
        timeInMinutes = timeInMinutes,
        platform = tostring(platform) or "1"
    }
    self.__index = self
    setmetatable(o, self)
    return o
end

return StationQueueEntry
