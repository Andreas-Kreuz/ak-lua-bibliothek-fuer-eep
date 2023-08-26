if AkDebugLoad then print("[#Start] Loading ak.public-transport.LineSegment ...") end

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
---@param routeName string with the EEP-Route Name
---@param line Line Line object
---@param destination string Name of the destination stop
---@return LineSegment
function LineSegment:new(routeName, line, destination)
    assert(type(self) == "table", "Call this method with ':'")
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
---@param timeToStation? number optional time in minutes to this station
function LineSegment:addStop(platform, timeToStation)
    assert(type(self) == "table" and self.type == "LineSegment", "Call this method with ':'")
    assert(type(platform) == "table", "Need 'platform' as table")
    assert(platform.type == "Platform", "Provide 'platform' as 'Platform'")
    if timeToStation then assert(type(timeToStation) == "number", "Need 'timeToStation' as number") end

    platform.roadStation:setPlatform(self, platform.platformNumber)

    self.stationInfos[#self.stationInfos + 1] = {station = platform.roadStation, timeToStation = timeToStation or 0}
end

---Optionally you can add subsequent line events. - If no line segment is added, the line will start from the beginning
---@param newLineSegment LineSegment
---@param timeInMinutes number
function LineSegment:setNextSection(newLineSegment, timeInMinutes)
    assert(type(self) == "table" and self.type == "LineSegment", "Call this method with ':'")
    self.nextLineSegmentInfo = {followingSegment = newLineSegment, timeInMinutes = timeInMinutes}
end

function LineSegment:getAllSegments()
    assert(type(self) == "table" and self.type == "LineSegment", "Call this method with ':'")
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

---comment
---@param routeName string
---@param nextStation? RoadStation use this to schedule the departure at the next station
---@param currentStation? RoadStation use this after train departed at the current station
---@return TimeToStationEntry[]
function LineSegment:nextStationList(routeName, nextStation, currentStation)
    assert(type(self) == "table" and self.type == "LineSegment", "Call this method with ':'")
    assert(type(routeName) == "string", "Provide 'routeName' as 'string'")
    assert((currentStation ~= nil and nextStation == nil) or (currentStation == nil and nextStation ~= nil))
    assert(nextStation == nil or type(nextStation) == "table" and nextStation.type == "RoadStation",
           "Provide 'nextStation' as 'RoadStation'")
    assert(currentStation == nil or type(currentStation) == "table" and currentStation.type == "RoadStation",
           "Provide 'currentStation' as 'RoadStation'")

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
            ---@field station RoadStation
            ---@field destination string
            ---@field lineNr string
            ---@field timeToStation number
            ---@field totalTime number
            local info = {}
            info.destination = segment.destination
            info.lineNr = segment.line.nr
            info.station = station
            info.timeToStation = s.timeToStation or 2

            -- Resets the index to 1 if the nextStation is found
            if routeName == segment.routeName and station == nextStation then pos = 1 end
            table.insert(allStationInfos, pos, info)
            if routeName == segment.routeName and station == currentStation then pos = 0 end
        end
    end

    local total = 0
    for index, info in ipairs(allStationInfos) do
        if currentStation or index > 1 then total = total + info.timeToStation end
        info.totalTime = total
        if LineSegment.debug then
            print("[#LineSegment] " .. info.lineNr .. "->" .. info.destination .. " " .. info.station.name .. " (" ..
                  info.totalTime .. ") " .. info.timeToStation)
        end
    end

    return allStationInfos
end

---@return RoadStation|nil
function LineSegment:getLastStation()
    if #self.stationInfos > 0 then return self.stationInfos[#self.stationInfos].station end
end

---@return RoadStation|nil
function LineSegment:getFirstStation() if #self.stationInfos > 0 then return self.stationInfos[1].station end end

---Will inform the given stations about the train arrival in minutes and all sequential stations with the offset
---@param train Train the train which will arrive
---@param nextStation RoadStation the first station in the route, where the train will arrive
---@param timeInMinutes number departure time of the train in minutes
function LineSegment:prepareDepartureAt(train, nextStation, timeInMinutes)
    assert(type(self) == "table" and self.type == "LineSegment", "Call this method with ':'")
    assert(type(train) == "table", "Need 'train' as table")
    assert(train.type == "Train", "Provide 'train' as 'Train'")
    assert(type(nextStation) == "table", "Need 'nextStation' as table")
    assert(nextStation.type == "RoadStation", "Provide 'station' as 'RoadStation'")
    if timeInMinutes then assert(type(timeInMinutes) == "number", "Need 'timeInMinutes' as number") end

    timeInMinutes = timeInMinutes or 0
    local infoList = self:nextStationList(train:getRoute(), nextStation, nil)
    for _, info in ipairs(infoList) do
        local station = info.station
        station:trainArrivesIn(train.name, info.destination, info.lineNr, timeInMinutes + info.totalTime)
    end
end

---Will inform the given stations about the train arrival in minutes and all sequential stations with the offset
---@param train Train the train which will arrive
---@param currentStation RoadStation the first station in the route, where the train will arrive
function LineSegment:trainDeparted(train, currentStation)
    assert(type(self) == "table" and self.type == "LineSegment", "Call this method with ':'")
    assert(type(train) == "table", "Need 'train' as table")
    assert(train.type == "Train", "Provide 'train' as 'Train'")
    assert(type(currentStation) == "table", "Need 'currentStation' as table")
    assert(currentStation.type == "RoadStation", "Provide 'currentStation' as 'RoadStation'")

    local oldDestination = train:getDestination()
    local oldLine = train:getLine()
    local infoList = self:nextStationList(train:getRoute(), nil, currentStation)

    if currentStation == self:getLastStation() and train:getRoute() == self.routeName and self.nextLineSegmentInfo then
        local nextSegment = self.nextLineSegmentInfo.followingSegment
        train:setRoute(nextSegment.routeName)
        train:changeDestination(nextSegment.destination, nextSegment.line.nr)
    end

    for _, info in ipairs(infoList) do
        local station = info.station
        if station == currentStation then currentStation:trainLeft(train.name, oldDestination, oldLine) end
        station:trainArrivesIn(train.name, info.destination, info.lineNr, info.totalTime)
    end
end

function LineSegment:toJsonStatic()
    local stations = {}
    for _, s in ipairs(self.stationInfos) do
        ---@type RoadStation
        local station = s.station
        local timeToStation = s.timeToStation
        table.insert(stations, {station = {name = station.name}, timeToStation = timeToStation})
    end
    return {
        id = self.id,
        destination = self.destination,
        routeName = self.routeName,
        lineNr = self.line.nr,
        stations = stations
    }
end

return LineSegment
