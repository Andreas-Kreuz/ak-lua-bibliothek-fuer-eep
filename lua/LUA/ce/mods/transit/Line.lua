local LineSegment = require("ce.mods.transit.LineSegment")
local TrainRegistry = require("ce.hub.data.trains.TrainRegistry")
if AkDebugLoad then print("[#Start] Loading ce.mods.transit.Line ...") end

local Line = {}
Line.debug = AkDebugLoad or false
---@type table<string, Line>
local lines = {}

function Line.forName(name)
    local LineRegistry = require("ce.mods.transit.LineRegistry")
    local line, _ = LineRegistry.forId(name)
    return line
end

function Line:new(o)
    assert(type(o) == "table", "Need 'o' as table")
    assert(type(o.nr) == "string", "Need 'o.nr' as string")
    assert(type(o.trafficType) == "nil" or o.trafficType == "TRAM" or o.trafficType == "BUS",
           "Need 'o.trafficType' as 'BUS' or 'TRAM'")
    o.id = o.nr
    o.type = "Line"
    o.trafficType = o.trafficType or "TRAM"
    o.lineSegments = {}
    self.__index = self
    setmetatable(o, self)
    lines[o.nr] = o
    return o
end

function Line:addSection(routeName, destination)
    assert(type(self) == "table" and self.type == "Line", "Call this method with ':'")
    assert(type(routeName) == "string", "Need 'routeName' as string")
    assert(type(destination) == "string", "Need 'destination' as string")
    local lineSegment = LineSegment:new(routeName, self, destination)
    self.lineSegments[routeName] = lineSegment
    return lineSegment
end

local function checkLine(train)
    if train then
        local lineName = train:getLine()
        local routeName = train:getRoute()
        if not lineName then
            for _, line in pairs(lines) do
                for _, segment in pairs(line.lineSegments) do
                    if segment.routeName == routeName then
                        train:changeDestination(segment.destination, line.nr)
                    end
                end
            end
        end
    end
end

function Line.scheduleDeparture(trainName, station, timeInMinutes)
    assert(type(trainName) == "string", "Need 'trainName' as string")
    assert(type(station) == "table", "Need 'station' as table")
    assert(station.type == "RoadStation", "Provide 'station' as 'RoadStation'")
    assert(type(timeInMinutes) == "number", "Need 'timeInMinutes' as number")

    local train = TrainRegistry.forName(trainName)
    local lineName = train:getLine()
    local routeName = train:getRoute()
    checkLine(train)
    assert(type(routeName) == "string", "Need 'routeName' as string")

    if lineName then
        local line = lines[lineName]
        if line then
            local lineSegment = line.lineSegments[routeName]
            if lineSegment then
                lineSegment:prepareDepartureAt(train, station, timeInMinutes)
            else
                print("[#Line] Could not find lineSegment for route: " .. routeName)
            end
        else
            print("[#Line] Could not find trains line: " .. lineName)
        end
    else
        print("[#Line] Train has no line: " .. trainName)
    end
end

function Line.trainDeparted(trainName, station)
    assert(type(trainName) == "string", "Need 'trainName' as string")
    assert(type(station) == "table", "Need 'station' as table")
    assert(station.type == "RoadStation", "Provide 'station' as 'RoadStation'")

    local train = TrainRegistry.forName(trainName)
    local lineName = train:getLine()
    local routeName = train:getRoute()
    checkLine(train)
    assert(type(routeName) == "string", "Need 'routeName' as string")

    if lineName then
        station:trainLeft(trainName, train:getDestination(), lineName)
        local line = lines[lineName]
        if line then
            local lineSegment = line.lineSegments[routeName]
            if lineSegment then
                lineSegment:trainDeparted(train, station)
            else
                print("[#Line] Could not find lineSegment for route: " .. routeName)
            end
        else
            print("[#Line] Could not find trains line: " .. lineName)
        end
    else
        print("[#Line] Train has no line: " .. trainName)
    end
end

function Line:toJsonStatic()
    local lineSegments = {}
    for _, segment in pairs(self.lineSegments) do table.insert(lineSegments, segment:toJsonStatic()) end
    return { id = self.id, nr = self.nr, trafficType = self.trafficType, lineSegments = lineSegments }
end

function Line.getLines()
    local ret = {}
    for _, line in pairs(lines) do table.insert(ret, line:toJsonStatic()) end
    return ret
end

return Line
