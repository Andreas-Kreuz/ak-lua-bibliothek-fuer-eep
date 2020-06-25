if AkDebugLoad then
    print("Loading ak.road.station.Destinations ...")
end

local EepTrain = require("ak.train.EepTrain")

---@class Destinations<T>
local Destinations = {}
Destinations.debug = AkDebugLoad or false
local destinations = {}

function Destinations.changeOn(station, trainRoute, newDestination, newLine, axis, axisValue)
    destinations[station] = destinations[station] or {}
    destinations[station][trainRoute] = destinations[station][trainRoute] or {}
    destinations[station][trainRoute] = {
        newDestination = newDestination,
        newLine = newLine,
        axis = axis,
        axisValue = axisValue
    }
end

function Destinations.changeFor(trainName, station)
    local train = EepTrain:new(trainName)
    if Destinations.debug then
        print("Change destination for " .. trainName .. " at " .. station .. " (" .. train:getRoute() .. ")")
    end

    if destinations[station] and destinations[station][train:getRoute()] then
        local entry = destinations[station][train:getRoute()]
        train:changeDestination(entry.newDestination, entry.newLine)
        if entry.axis and entry.axisValue then
            EEPSetTrainAxis(trainName, entry.axis, entry.axisValue)
        end

        if Destinations.debug then
            print("CHANGED DESTINATION FOR " .. train:getRoute() .. " AT STATION " .. station
                .. " TO LINE " .. entry.newLine .. " (" .. entry.newDestination .. ")")
        end
    else
        print("NO DESTINATION FOUND FOR ROUTE " .. train:getRoute() .. " AT STATION " .. station)
    end
end

return Destinations
