if AkDebugLoad then print("Loading ak.roadline.StationQueueEntry ...") end
local Train = require("ak.train.Train")

---@class StationQueueEntry
---@field trainName string
---@field line Line
---@field destination string
---@field timeInMinutes number
---@field platform string
local StationQueueEntry = {}
function StationQueueEntry:new(trainName, timeInMinutes, platform)
    local train = Train.forName(trainName)
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
