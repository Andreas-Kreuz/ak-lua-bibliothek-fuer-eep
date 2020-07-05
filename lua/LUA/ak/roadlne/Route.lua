if AkDebugLoad then print("Loading ak.roadline.Route ...") end

---@class Route<T>
local Route = {}
Route.debug = AkDebugLoad or false

--- Creates a new Bus or Tram Station
---@param routeName table table with entry "nr" of type string
---@return Route
function Route:new(routeName, lineNr)
    assert(type(routeName) == "string", "Provide 'routeName' as 'string' was ".. type(routeName))
    local o = {}
    o.type = "Route"
    o.lineNr = lineNr
    o.routeName = routeName
    o.stations = {}
    self.__index = self
    setmetatable(o, self)
    return o
end

---@param roadStation RoadStation a roadStation
---@param platform number Platform of the station where this route will depart
---@param timeToStation number optional time in minutes to this station
function Route:addStation(roadStation, platform, timeToStation)
    assert(type(roadStation) == "table", "Provide 'station' as 'RoadStation: '" .. type(roadStation))
    assert(roadStation.type == "RoadStation", "Provide 'station' as 'RoadStation'")
    assert(type(platform) == "number", "Provide 'platform' as 'number: '" .. type(roadStation))
    if timeToStation then
        assert(type(timeToStation) == "number", "Provide 'timeToStation' as 'number: '" .. type(timeToStation))
    end

    roadStation:setPlatform(self, platform)

    self.stations[#self.stations + 1] = {
        station = roadStation,
        timeToStation = timeToStation,
    }
end

---@return RoadStation
function Route:getLastStation()
    if #self.stations > 0 then
        return self.stations[#self.stations].station
    end
end

---@return RoadStation
function Route:getFirstStation()
    if #self.stations > 0 then
        return self.stations[1].station
    end
end

---Will inform the given stations about the train arrival in minutes and all sequential stations with the offset
---@param train Train the train which will arrive
---@param station RoadStation the first station in the route, where the train will arrive
---@param timeInMinutes number departure time of the train in minutes
function Route:prepareDepartureAt(train, station, timeInMinutes)
    assert(type(train) == "table", "Provide 'train' as 'table' was ".. type(train))
    assert(train.type == "Train", "Provide 'train' as 'Train'")
    assert(type(station) == "table", "Provide 'station' as 'table' was ".. type(station))
    assert(station.type == "RoadStation", "Provide 'station' as 'RoadStation'")
    if timeInMinutes then
        assert(type(timeInMinutes) == "number", "Provide 'timeToStation' as 'number: '" .. type(timeInMinutes))
    end

    timeInMinutes = timeInMinutes or 0
    local haveStation = false
    for i = 1, #self.stations do
        local s = self.stations[i].station
        if s == station then
            haveStation = true
        end
        if haveStation then
            local timeToStation = s == station and 0 or self.stations[i].timeToStation
            timeInMinutes = timeToStation and (timeInMinutes + timeToStation) or timeInMinutes
            s:trainArrivesIn(train.trainName, timeInMinutes)
        end
    end
end

---Will inform the given stations about the train arrival in minutes and all sequential stations with the offset
---@param train Train the train which will arrive
---@param station RoadStation the first station in the route, where the train will arrive
function Route:trainDeparted(train, station)
    assert(type(train) == "table", "Provide 'train' as 'table' was ".. type(train))
    assert(train.type == "Train", "Provide 'train' as 'Train'")
    assert(type(station) == "table", "Provide 'station' as 'table' was ".. type(station))
    assert(station.type == "RoadStation", "Provide 'station' as 'RoadStation'")

    local timeInMinutes = 0
    local haveStation = false
    for i = 1, #self.stations do
        local s = self.stations[i].station
        if haveStation then
            local timeToStation = self.stations[i].timeToStation
            timeInMinutes = timeToStation and (timeInMinutes + timeToStation) or timeInMinutes
            s:trainArrivesIn(train.trainName, timeInMinutes)
        end
        if s == station then
            station:trainLeft(train.trainName)
            haveStation = true
        end
    end
end

return Route
