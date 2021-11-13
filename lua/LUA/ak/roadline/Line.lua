if AkDebugLoad then print("Loading ak.roadline.Line ...") end

local TrainRegistry = require("ak.train.TrainRegistry")
local Route = require("ak.roadline.Route")

---@class Line
---@field type string
---@field routes table
---@field nr string
local Line = {}
Line.debug = AkDebugLoad or false
local lines = {}
local lineChanges = {}

function Line.addRouteChange(station, oldRoute, newRoute, newLine)
    assert(type(station) == "table", "Need 'station' as table")
    assert(station.type == "RoadStation", "Provide 'station' as 'RoadStation'")
    assert(type(oldRoute) == "table", "Need 'oldRoute' as table")
    assert(oldRoute.type == "Route", "Provide 'oldRoute' as 'Route'")
    assert(type(oldRoute) == "table", "Need 'oldRoute' as table")
    assert(oldRoute.type == "Route", "Provide 'newRoute' as 'Route'")
    assert(type(newLine) == "table", "Need 'newLine' as table")
    assert(newLine.type == "Line", "Provide 'newLine' as 'Line'")
    assert(newLine.routes[newRoute.routeName], "'newRoute' is not part of 'newLine'")
    assert(type(newLine.nr) == "string", "Need 'newLine.nr' as string")

    lineChanges[station] = lineChanges[station] or {}
    lineChanges[station][oldRoute.routeName] = lineChanges[station][oldRoute.routeName] or {}
    lineChanges[station][oldRoute.routeName] = {newRoute = newRoute, newLine = newLine}
end

function Line.changeRoute(trainName, station, departureTime)
    assert(type(trainName) == "string", "Need 'trainName' as string")
    assert(type(station) == "table", "Need 'station' as table")
    assert(station.type == "RoadStation", "Provide 'station' as 'RoadStation'")
    if departureTime then assert(type(departureTime) == "number", "Need 'departureTime' as number") end

    local train = TrainRegistry.forName(trainName)
    local oldRoute = train:getRoute()
    if Line.debug then
        print("Change destination for " .. trainName .. " at " .. station.name .. " (" .. oldRoute .. ")")
    end

    if lineChanges[station] and lineChanges[station][oldRoute] then
        local entry = lineChanges[station][oldRoute]
        assert(type(entry.newRoute) == "table", "Need 'entry.newRoute' as table")
        assert(entry.newRoute.type == "Route", "Provide 'entry.newRoute' as 'Route'")
        assert(entry.newLine.type == "Line", "Provide 'entry.newLine' as 'Line'")
        assert(type(entry.newLine.nr) == "string", "Need 'entry.newLine.nr' as string")

        train:setRoute(entry.newRoute.routeName)
        train:changeDestination(entry.newRoute:getLastStation().name, entry.newLine.nr)
        entry.newRoute:prepareDepartureAt(train, entry.newRoute:getFirstStation(), departureTime)
        if entry.axis and entry.axisValue then EEPSetTrainAxis(trainName, entry.axis, entry.axisValue) end

        if Line.debug then
            print("[Line] CHANGED DESTINATION FOR " .. oldRoute .. " AT STATION " .. station.name .. " TO LINE " ..
                  entry.newLine.nr .. " (" .. entry.newRoute:getLastStation().name .. ")")
        end
    else
        print("[Line] NO DESTINATION FOUND FOR ROUTE " .. oldRoute .. " AT STATION " .. station.name)
    end
end

---Creates a new bus or tram line
---@param o table table with entry "nr" as string
---@return Line
function Line:new(o)
    assert(type(o) == "table", "Need 'o' as table")
    assert(type(o.nr) == "string", "Need 'o.nr' as string")
    o.type = "Line"
    o.routes = {}
    self.__index = self
    setmetatable(o, self)
    lines[o.nr] = o
    return o
end

---Creates a new route on the line
---Each line can have multiple routes, e.g. each line may have two opposite directions

function Line:newRoute(routeName)
    assert(type(self) == "table", "Need to call this method with ':'")
    assert(type(routeName) == "string", "Need 'routeName' as string")
    local route = Route:new(routeName, self.nr)
    self.routes[routeName] = route
    return route
end

---
---@param trainName string
---@param station RoadStation
---@param timeInMinutes number
function Line.scheduleDeparture(trainName, station, timeInMinutes)
    assert(type(trainName) == "string", "Need 'trainName' as string")
    assert(type(station) == "table", "Need 'station' as table")
    assert(station.type == "RoadStation", "Provide 'station' as 'RoadStation'")
    assert(type(timeInMinutes) == "number", "Need 'timeInMinutes' as number")

    local train = TrainRegistry.forName(trainName)
    local lineName = train:getLine()
    local routeName = train:getRoute()
    assert(type(routeName) == "string", "Need 'routeName' as string")

    if lineName then
        local line = lines[lineName]
        if line then
            local route = line.routes[routeName]
            if route then
                route:prepareDepartureAt(train, station, timeInMinutes)
            else
                print("[Line] Could not find trains route: " .. routeName)
            end
        else
            print("[Line] Could not find trains line: " .. lineName)
        end
    else
        print("[Line] Train has no line: " .. trainName)
    end
end

---
---@param trainName string
---@param station RoadStation
function Line.trainDeparted(trainName, station)
    assert(type(trainName) == "string", "Need 'trainName' as string")
    assert(type(station) == "table", "Need 'station' as table")
    assert(station.type == "RoadStation", "Provide 'station' as 'RoadStation'")

    station:trainLeft(trainName)
    local train = TrainRegistry.forName(trainName)
    local lineName = train:getLine()
    -- assert(type(lineName) == "string", "Need 'lineName' as string")
    local routeName = train:getRoute()
    assert(type(routeName) == "string", "Need 'routeName' as string")

    if lineName then
        local line = lines[lineName]
        if line then
            local route = line.routes[routeName]
            if route then
                route:trainDeparted(train, station)
            else
                print("[Line] Could not find trains route: " .. routeName)
            end
        else
            print("[Line] Could not find trains line: " .. lineName)
        end
    else
        print("[Line] Train has no line: " .. trainName)
    end
end

return Line
