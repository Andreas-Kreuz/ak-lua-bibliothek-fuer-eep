if AkDebugLoad then print("[#Start] Loading ak.public-transport.StationQueueEntry ...") end

---@class StationQueueEntry
---@field trainName string
---@field line Line
---@field destination string
---@field timeInMinutes number
---@field platform string
local StationQueueEntry = {}
function StationQueueEntry:new(trainName, destination, line, timeInMinutes, platform)
    assert(type(self) == "table", "Call this method with ':'")
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

function StationQueueEntry.keyFor(trainName, destination, line)
    assert(type(trainName) == "string", "Need 'trainName' as string")
    assert(type(destination) == "string", "Need 'destination' as string")
    assert(type(line) == "string", "Need 'line' as string")
    return line .. "&" .. destination .. "&" .. trainName
end
function StationQueueEntry:getKey()
    assert(type(self) == "table", "Need 'trainName' as string")
    return StationQueueEntry.keyFor(self.trainName, self.destination, self.line)
end

return StationQueueEntry
