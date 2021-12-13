if AkDebugLoad then print("Loading ak.public-transport.LineSegment ...") end

---@class LineSegment
---@field id string = the routeName
---@field type string
---@field line Line
---@field destination string
---@field routeName string
---@field stationInfos StationInfo[]
---@field nextLineSegmentInfo SegmentInfo
local LineSegment = {}
LineSegment.debug = AkDebugLoad or false

--- Creates a new Bus or Tram Station
---@param routeName table table with entry "nr" of type string
---@return LineSegment
function LineSegment:new(routeName, line, destination)
    assert(type(self) == "table", "Need 'self' as table")
    assert(type(routeName) == "string", "Need 'routeName' as string")
    assert(type(line) == "table" and line.type == "Line", "Need 'line' as Line")
    assert(type(destination) == "string", "Need 'destination' as string")
    local o = {}
    o.type = "LineSegment"
    o.id = routeName
    o.routeName = routeName
    o.destination = destination
    o.line = line
    ---@class StationInfo
    ---@field station RoadStation
    ---@field timeToStation number
    o.stationInfos = {}
    ---@class SegmentInfo
    ---@field followingSegment LineSegment
    ---@field timeInMinutes number
    o.nextLineSegmentInfo = nil
    self.__index = self
    setmetatable(o, self)
    return o
end

---Adds a stop to this line. All stops must be given in the correct order
---@param platform Platform Platform of the station where this route will depart
---@param timeToStation number optional time in minutes to this station
function LineSegment:addStop(platform, timeToStation)
    assert(type(self) == "table", "Need to call this method with ':'")
    assert(type(platform) == "table", "Need 'platform' as table")
    assert(platform.type == "Platform", "Provide 'platform' as 'Platform'")
    if timeToStation then assert(type(timeToStation) == "number", "Need 'timeToStation' as number") end

    platform.roadStation:setPlatform(self, platform.platformNumber)

    self.stationInfos[#self.stationInfos + 1] = {station = platform.roadStation, timeToStation = timeToStation}
end

---Optionally you can add subsequent line events. - If no line segment is added, the line will start from the beginning
---@param newLineSegment LineSegment
---@param timeInMinutes number
function LineSegment:setNextSection(newLineSegment, timeInMinutes)
    assert(type(self) == "table", "Need to call this method with ':'")
    self.nextLineSegmentInfo = {followingSegment = newLineSegment, timeInMinutes = timeInMinutes}
end

function LineSegment:getAllSegments()
    assert(type(self) == "table", "Need to call this method with ':'")
    local viewed = {}
    local segments = {}

    local segment = self
    local timeInMinutes = 2

    -- for each segment look, if we find
    while not viewed[segment] do
        viewed[segment] = true
        table.insert(segments, {segment = segment, timeInMinutes = timeInMinutes})

        local segmentInfo = segment.nextLineSegmentInfo or {followingSegment = segment, timeInMinutes = 2}
        segment = segmentInfo.followingSegment
        timeInMinutes = segmentInfo.timeInMinutes
    end

    segments[1].timeInMinutes = timeInMinutes
    return segments
end

function LineSegment:stationsListAfterStation(routeName, nextStation)
    assert(type(self) == "table", "Need to call this method with ':'")
    assert(type(routeName) == "string", "Provide 'routeName' as 'string'")
    assert(type(nextStation) == "table" and nextStation.type == "RoadStation",
           "Provide 'nextStation' as 'RoadStation'")

    ---@type TimeToStationEntry[]
    local allStationInfos = {}
    local allSegmentInfos = self:getAllSegments()
    local pos = 0
    for _, segmentInfo in ipairs(allSegmentInfos) do
        ---@type LineSegment
        local segment = segmentInfo.segment;
        for _, s in ipairs(segment.stationInfos) do
            ---@type RoadStation
            local station = s.station
            pos = pos + 1

            ---@class TimeToStationEntry
            ---@field routeName string
            ---@field station RoadStation
            ---@field timeToStation number
            ---@field totalTime number
            local info = {}
            info.routeName = segment.routeName
            info.station = station
            info.timeToStation = s.timeToStation

            -- Resets the index to 1 if the nextStation is found
            if routeName == segment.routeName and station == nextStation then pos = 1 end
            table.insert(allStationInfos, pos, info)
        end
    end

    local total = 0
    for index, info in ipairs(allStationInfos) do
        if index > 1 then total = total + info.timeToStation end
        info.totalTime = total
    end

    return allStationInfos
end

---@return RoadStation
function LineSegment:getLastStation()
    if #self.stationInfos > 0 then return self.stationInfos[#self.stationInfos].station end
end

---@return RoadStation
function LineSegment:getFirstStation() if #self.stationInfos > 0 then return self.stationInfos[1].station end end

---Will inform the given stations about the train arrival in minutes and all sequential stations with the offset
---@param train Train the train which will arrive
---@param station RoadStation the first station in the route, where the train will arrive
---@param timeInMinutes number departure time of the train in minutes
function LineSegment:prepareDepartureAt(train, station, timeInMinutes)
    assert(type(self) == "table", "Need to call this method with ':'")
    assert(type(train) == "table", "Need 'train' as table")
    assert(train.type == "Train", "Provide 'train' as 'Train'")
    assert(type(station) == "table", "Need 'station' as table")
    assert(station.type == "RoadStation", "Provide 'station' as 'RoadStation'")
    if timeInMinutes then assert(type(timeInMinutes) == "number", "Need 'timeInMinutes' as number") end

    timeInMinutes = timeInMinutes or 0
    local haveStation = false
    for i = 1, #self.stationInfos do
        local s = self.stationInfos[i].station
        if s == station then haveStation = true end
        if haveStation then
            local timeToStation = s == station and 0 or self.stationInfos[i].timeToStation
            timeInMinutes = timeToStation and (timeInMinutes + timeToStation) or timeInMinutes
            s:trainArrivesIn(train.name, timeInMinutes)
        end
    end
end

---Will inform the given stations about the train arrival in minutes and all sequential stations with the offset
---@param train Train the train which will arrive
---@param station RoadStation the first station in the route, where the train will arrive
function LineSegment:trainDeparted(train, station)
    assert(type(self) == "table", "Need to call this method with ':'")
    assert(type(train) == "table", "Need 'train' as table")
    assert(train.type == "Train", "Provide 'train' as 'Train'")
    assert(type(station) == "table", "Need 'station' as table")
    assert(station.type == "RoadStation", "Provide 'station' as 'RoadStation'")

    local timeInMinutes = 0
    local haveStation = false
    for i = 1, #self.stationInfos do
        local s = self.stationInfos[i].station
        if haveStation then
            local timeToStation = self.stationInfos[i].timeToStation
            timeInMinutes = timeToStation and (timeInMinutes + timeToStation) or timeInMinutes
            s:trainArrivesIn(train.name, timeInMinutes)
        end
        if s == station then
            station:trainLeft(train.name)
            haveStation = true
        end
    end

    if station == self:getLastStation() and train:getRoute() == self.routeName and self.nextLineSegmentInfo then
        local nextSegment = self.nextLineSegmentInfo.followingSegment
        train:setRoute(nextSegment.routeName)
        train:changeDestination(nextSegment.destination, nextSegment.line.nr)
    end
end

function LineSegment:toJsonStatic()
    return {id = self.id, stations = self.stationInfos, routeName = self.routeName, lineNr = self.line.nr}
end

return LineSegment
