if AkDebugLoad then print("[#Start] Loading ak.public-transport.StationQueue ...") end

local StationQueueEntry = require("ak.public-transport.StationQueueEntry")

---@class StationQueue
---@field type string
---@field entries table<string, StationQueueEntry>
---@field entriesByArrival StationQueueEntry[]
local StationQueue = {}
function StationQueue:new()
    assert(type(self) == "table", "Call this method with ':'")
    local o = {entries = {}, entriesByArrival = {}}
    o.type = "StationQueue"
    self.__index = self
    setmetatable(o, self)
    return o
end

function StationQueue:push(trainName, destination, line, timeInMinutes, platform)
    assert(type(self) == "table" and self.type == "StationQueue", "Call this method with ':'")
    assert(type(trainName) == "string", "Need 'trainName' as string")
    assert(type(destination) == "string", "Need 'destination' as string")
    assert(type(line) == "string", "Need 'line' as string")
    assert(type(timeInMinutes) == "number", "Need 'timeInMinutes' as number")
    platform = platform and tostring(platform) or "1"

    local newEntry = StationQueueEntry:new(trainName, destination, line, timeInMinutes, platform)
    local key = newEntry:getKey()

    -- Remove train from arrival list
    local newEntriesByArrival = {}
    for _, oldKey in ipairs(self.entriesByArrival) do
        if oldKey ~= key then table.insert(newEntriesByArrival, oldKey) end
    end
    self.entriesByArrival = newEntriesByArrival

    self.entries[key] = newEntry

    -- Add train to arrival list
    local insertIndex = 1
    for i, k in ipairs(self.entriesByArrival) do
        insertIndex = i + 1
        if self.entries[k] and self.entries[k].timeInMinutes > timeInMinutes then
            insertIndex = i
            break
        end
    end
    table.insert(self.entriesByArrival, insertIndex, key)
end

---comment
---@param trainName string
---@param destination string
---@param line string
---@return table
function StationQueue:pop(trainName, destination, line)
    assert(type(self) == "table" and self.type == "StationQueue", "Call this method with ':'")
    assert(type(destination) == "string", "Need 'destination' as string")
    assert(type(line) == "string", "Need 'line' as string")
    local key = StationQueueEntry.keyFor(trainName, destination, line)
    local entry = self.entries[key]
    self.entries[key] = nil
    for i, value in ipairs(self.entriesByArrival) do
        if value == key then table.remove(self.entriesByArrival, i) end
    end

    return entry
end

local function filterBy(stationInfo, platform)
    local filteredTrainList = {}
    for _, key in ipairs(stationInfo.entriesByArrival) do
        if tostring(stationInfo.entries[key].platform) == tostring(platform) then
            table.insert(filteredTrainList, key)
        end
    end
    return filteredTrainList
end

function StationQueue:getTrainEntries(platform)
    assert(type(self) == "table" and self.type == "StationQueue", "Call this method with ':'")
    local filteredTrainList = platform and filterBy(self, platform) or self.entriesByArrival
    local list = {}
    for _, key in ipairs(filteredTrainList) do table.insert(list, self.entries[key]) end
    return list
end

return StationQueue
