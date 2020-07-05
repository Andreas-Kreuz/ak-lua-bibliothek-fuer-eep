if AkDebugLoad then
    print("Loading ak.roadline.Line ...")
end

local Train = require("ak.train.Train")
local Route = require("ak.roadline.Route")

---@class Line<T>
local Line = {}
Line.debug = AkDebugLoad or false
local lines = {}
local lineChanges = {}

function Line.addRouteChange(station, oldRoute, newRoute, newLine)
    assert(type(station) == "table", "Provide 'station' as 'table' was ".. type(station))
    assert(station.type == "RoadStation", "Provide 'station' as 'RoadStation'")
    assert(type(oldRoute) == "table", "Provide 'oldRoute' as 'table' was ".. type(oldRoute))
    assert(oldRoute.type == "Route", "Provide 'oldRoute' as 'Route'")
    assert(type(oldRoute) == "table", "Provide 'oldRoute' as 'table' was ".. type(oldRoute))
    assert(oldRoute.type == "Route", "Provide 'newRoute' as 'Route'")
    assert(type(newLine) == "table", "Provide 'newLine' as 'table' was ".. type(newLine))
    assert(newLine.type == "Line", "Provide 'newLine' as 'Line'")
    assert(newLine.routes[newRoute.routeName], "'newRoute' is not part of 'newLine'")
    assert(type(newLine.nr) == "string", "Provide 'newLine.nr' as 'number' was ".. type(newLine.nr))

    lineChanges[station] = lineChanges[station] or {}
    lineChanges[station][oldRoute.routeName] = lineChanges[station][oldRoute.routeName] or {}
    lineChanges[station][oldRoute.routeName] = {
        newRoute = newRoute,
        newLine = newLine,
    }
end

function Line.changeRoute(trainName, station, departureTime)
    assert(type(trainName) == "string", "Provide 'trainName' as 'string' was ".. type(trainName))
    assert(type(station) == "table", "Provide 'station' as 'table' was ".. type(station))
    assert(station.type == "RoadStation", "Provide 'station' as 'RoadStation'")
    if departureTime then
        assert(type(departureTime) == "number", "Provide 'departureTime' as 'number: '" .. type(departureTime))
    end

    local train = Train.forName(trainName)
    local oldRoute = train:getRoute()
    if Line.debug then
        print("Change destination for " .. trainName .. " at " .. station .. " (" .. oldRoute .. ")")
    end

    if lineChanges[station] and lineChanges[station][oldRoute] then
        local entry = lineChanges[station][oldRoute]
        assert(type(entry.newRoute) == "table", "Provide 'entry.newRoute' as 'table' was ".. type(entry.newRoute))
        assert(entry.newRoute.type == "Route", "Provide 'entry.newRoute' as 'Route'")
        assert(entry.newLine.type == "Line", "Provide 'entry.newLine' as 'Line'")
        assert(type(entry.newLine.nr) == "string", "Provide 'newLine.nr' as 'number' was ".. type(entry.newLine.nr))

        train:setRoute(entry.newRoute.routeName)
        train:changeDestination(entry.newRoute:getLastStation().name, entry.newLine.nr)
        entry.newRoute:prepareDepartureAt(train, entry.newRoute:getFirstStation(), departureTime)
        if entry.axis and entry.axisValue then
            EEPSetTrainAxis(trainName, entry.axis, entry.axisValue)
        end

        if Line.debug then
            print("[Line] CHANGED DESTINATION FOR " .. oldRoute .. " AT STATION " .. station.name
                .. " TO LINE " .. entry.newLine.lineName .. " (" .. entry.newRoute:getLastStation().name .. ")")
        end
    else
        print("[Line] NO DESTINATION FOUND FOR ROUTE " .. oldRoute .. " AT STATION " .. station.name)
    end
end

---Creates a new bus or tram line
---@param o table table with entry "nr" as string
---@return Line
function Line:new(o)
    assert(type(o) == "table", "Provide 'o' as 'table' was ".. type(o))
    assert(type(o.nr) == "string", "Provide 'o.nr' as 'string' was ".. type(o.nr))
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
    assert(type(routeName) == "string", "routeName must be of type 'string' was " .. type(routeName))
    local route = Route:new(routeName, self.nr)
    self.routes[routeName] = route
    return route
end

---
---@param trainName string
---@param station RoadStation
---@param timeInMinutes number
function Line.scheduleDeparture(trainName, station, timeInMinutes)
    assert(type(trainName) == "string", "Provide 'trainName' as 'string' was ".. type(trainName))
    assert(type(station) == "table", "Provide 'station' as 'table' was ".. type(station))
    assert(station.type == "RoadStation", "Provide 'station' as 'RoadStation'")
    assert(type(timeInMinutes) == "number", "Provide 'timeInMinutes' as 'number' was ".. type(timeInMinutes))

    local train = Train.forName(trainName)
    local lineName = train:getLine()
    local routeName = train:getRoute()
    assert(type(routeName) == "string", "routeName must be of type 'string' was " .. type(routeName))

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
    assert(type(trainName) == "string", "Provide 'trainName' as 'string' was ".. type(trainName))
    assert(type(station) == "table", "Provide 'station' as 'table' was ".. type(station))
    assert(station.type == "RoadStation", "Provide 'station' as 'RoadStation'")

    station:trainLeft(trainName)
    local train = Train.forName(trainName)
    local lineName = train:getLine()
    -- assert(type(lineName) == "string", "lineName must be of type 'string' was " .. type(lineName))
    local routeName = train:getRoute()
    assert(type(routeName) == "string", "routeName must be of type 'string' was " .. type(routeName))

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
