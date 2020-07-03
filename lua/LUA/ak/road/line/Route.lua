if AkDebugLoad then print("Loading ak.road.line.Route ...") end

---@class Route<T>
local Route = {}
Route.debug = AkDebugLoad or false

--- Creates a new Bus or Tram Station
---@param routeName table table with entry "nr" of type string
---@return Route
function Route:new(routeName)
    assert(routeName, 'Provide routeName as string')
    assert(type(routeName) == "string", 'Provide routeName as string')
    local o = {}
    o.type = "Route"
    o.routeName = routeName
    o.stations = {}
    self.__index = self
    setmetatable(o, self)
    return o
end

---@param roadStation RoadStation a roadStation
---@param timeToStation number optional time in minutes to this station
function Route:addStation(roadStation, timeToStation)
    assert(roadStation, "Provide a station of type RoadStation")
    assert(type(roadStation) == "table", "Provide a station of type RoadStation: " .. type(roadStation))
    assert(roadStation.type == "RoadStation", "Provide a station of type RoadStation")
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

---Creates a new route with all stations in reverse order
---@param routeName string name of the reverse route
---@return Route the reverse route of the current route
function Route:newReverseRoute(routeName)
    local route = Route:new(routeName)
    for i = #self.stations, 1, -1 do
        local s = self.stations[i]
        local timeToStation = i > 1 and self.stations[i - 1].timeToStation or nil
        route:addStation(s.station, timeToStation)
    end
    return route
end

---Will inform the given stations about the train arrival in minutes and all sequential stations with the offset
---@param train Train the train which will arrive
---@param station RoadStation the first station in the route, where the train will arrive
---@param timeInMinutes number departure time of the train in minutes
function Route:prepareDepartureAt(train, station, timeInMinutes)
    assert(train, "Provide a train of type Train")
    assert(type(train) == "table", "Provide a train of type Train")
    assert(train.type == "Train", "Provide a train of type Train")
    assert(station, "Provide a station of type RoadStation")
    assert(type(station) == "table", "Provide a station of type RoadStation")
    assert(station.type == "RoadStation", "Provide a station of type RoadStation")

    timeInMinutes = timeInMinutes or 0
    local haveStation = false
    for i = #self.stations, 1, -1 do
        local s = self.stations[i].station
        if s == station then
            haveStation = true
        end
        if haveStation then
            local timeToStation = self.stations[i].timeToStation
            timeInMinutes = timeToStation and (timeInMinutes + timeToStation) or timeInMinutes
            s:trainArrivesIn(train.trainName, timeInMinutes)
        end
    end
end

return Route
