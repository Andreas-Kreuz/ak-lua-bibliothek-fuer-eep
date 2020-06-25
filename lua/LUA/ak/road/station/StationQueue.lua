if AkDebugLoad then
    print("Loading ak.road.station.StationQueue ...")
end

local StationQueueEntry = require("ak.road.station.StationQueueEntry")

---@class StationQueue<T>
local StationQueue = {}
function StationQueue:new()
    local o = {entries = {}, entriesByArrival = {}}
    self.__index = self
    setmetatable(o, self)
    return o
end

function StationQueue:push(trainName, timeInMinutes, platform)
    assert(trainName)
    assert(timeInMinutes)
    platform = platform and tostring(platform) or "1"

    -- Remove train from arrival list
    local newEntriesByArrival = {}
    for _, value in ipairs(self.entriesByArrival) do
        if value ~= trainName then
            table.insert(newEntriesByArrival, value)
        end
    end
    self.entriesByArrival = newEntriesByArrival

    self.entries[trainName] = StationQueueEntry:new(trainName, timeInMinutes, platform)

    -- Add train to arrival list
    local insertIndex = 1
    for i, train in ipairs(self.entriesByArrival) do
        insertIndex = i + 1
        if self.entries[train] and self.entries[train].timeInMinutes > timeInMinutes then
            insertIndex = i
            break
        end
    end
    table.insert(self.entriesByArrival, insertIndex, trainName)
end

function StationQueue:pop(trainName)
    local entry = self.entries[trainName]
    self.entries[trainName] = nil
    for i, value in ipairs(self.entriesByArrival) do
        if value == trainName then
            table.remove(self.entriesByArrival, i)
        end
    end

    return entry
end

local function filterBy(stationInfo, platform)
    local filteredTrainList = {}
    for _, train in ipairs(stationInfo.entriesByArrival) do
        if tostring(stationInfo.entries[train].platform) == tostring(platform) then
            table.insert(filteredTrainList, train)
        end
    end
    return filteredTrainList
end

function StationQueue:getTrainEntries(platform)
    local filteredTrainList = platform and filterBy(self, platform) or self.entriesByArrival
    local list = {}
    for _, trainName in ipairs(filteredTrainList) do
        table.insert(list, self.entries[trainName])
    end
    return list
end

return StationQueue
