if AkDebugLoad then
    print("Loading ak.road.line.Line ...")
end

local Train = require("ak.train.Train")
local Route = require("ak.road.line.Route")

---@class Line<T>
local Line = {}
Line.debug = AkDebugLoad or false
local lines = {}



function Line.changeOn(station, trainRoute, newDestination, newLine, axis, axisValue)
    lines[station] = lines[station] or {}
    lines[station][trainRoute] = lines[station][trainRoute] or {}
    lines[station][trainRoute] = {
        newDestination = newDestination,
        newLine = newLine,
        axis = axis,
        axisValue = axisValue
    }
end

function Line.changeFor(trainName, station)
    local train = Train.forName(trainName)
    if Line.debug then
        print("Change destination for " .. trainName .. " at " .. station .. " (" .. train:getRoute() .. ")")
    end

    if lines[station] and lines[station][train:getRoute()] then
        local entry = lines[station][train:getRoute()]
        train:changeDestination(entry.newDestination, entry.newLine)
        if entry.axis and entry.axisValue then
            EEPSetTrainAxis(trainName, entry.axis, entry.axisValue)
        end

        if Line.debug then
            print("CHANGED DESTINATION FOR " .. train:getRoute() .. " AT STATION " .. station
                .. " TO LINE " .. entry.newLine .. " (" .. entry.newDestination .. ")")
        end
    else
        print("NO DESTINATION FOUND FOR ROUTE " .. train:getRoute() .. " AT STATION " .. station)
    end
end

---@param train Train
---@param route Route
---@param timeInMinutes number
function Line:prepareDepartureAt(trainName, route, timeInMinutes)
    local train = trainName
    if not trainName or not trainName.type or not trainName.type ~= "Train" then
        assert(trainName, "Provide a trainName of type string")
        assert(type(trainName) == "string", "Provide a trainName of type string")
        train = Train.forName(trainName)
    end
    assert(route, "Provide a route of type Route")
    assert(type(route) == "table", "Provide a route of type Route")
    assert(route.type == "Route", "Provide a route of type Route")
    route:prepareDepartureAt(train, route:getFirstStation(), timeInMinutes)

    train:changeDestination(route:getLastStation().name, self.nr)
end


--- Creates a new Bus or Tram Station
---@param o table table with entry "nr" of type string
---@return Line
function Line:new(o)
    assert(o, 'Bitte geben Sie eine tabelle o an')
    assert(type(o) == "table", "o ist kein String")
    assert(o.nr, 'Bitte geben Sie eine Liniennummer "o.nr" als String an')
    assert(type(o.nr) == "string", 'Bitte geben Sie eine Liniennummer "o.nr" als String an')
    o.type = "Line"
    o.routes = {}
    self.__index = self
    setmetatable(o, self)
    return o
end

function Line:newRoute(routeName)
    local route = Route:new(routeName)
    self.routes[routeName] = route
    return route
end

return Line
