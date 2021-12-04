if AkDebugLoad then print("Loading ak.public-transport.StationQueueEntry ...") end
local TrainRegistry = require("ak.train.TrainRegistry")

---@class StationQueueEntry
---@field trainName string
---@field line Line
---@field destination string
---@field timeInMinutes number
---@field platform string
local StationQueueEntry = {}
function StationQueueEntry:new(trainName, timeInMinutes, platform)
    local train = TrainRegistry.forName(trainName)
    local destination = train:getDestination()
    local line = train:getLine()
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
