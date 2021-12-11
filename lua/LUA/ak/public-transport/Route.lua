if AkDebugLoad then print("Loading ak.public-transport.Route ...") end

---@class Route
---@field id string = the routeName
---@field type string
---@field lineNr string
---@field routeName string
---@field stations table
local Route = {}
Route.debug = AkDebugLoad or false

--- Creates a new Bus or Tram Station
---@param routeName table table with entry "nr" of type string
---@return Route
function Route:new(routeName, lineNr)
    assert(type(routeName) == "string", "Need 'routeName' as string")
    local o = {}
    o.id = routeName
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
    assert(type(self) == "table", "Need to call this method with ':'")
    assert(type(roadStation) == "table", "Need 'roadStation' as table")
    assert(roadStation.type == "RoadStation", "Provide 'station' as 'RoadStation'")
    assert(type(platform) == "number", "Need 'platform' as number")
    if timeToStation then assert(type(timeToStation) == "number", "Need 'timeToStation' as number") end

    roadStation:setPlatform(self, platform)

    self.stations[#self.stations + 1] = {station = roadStation, timeToStation = timeToStation}
end

---@return RoadStation
function Route:getLastStation() if #self.stations > 0 then return self.stations[#self.stations].station end end

---@return RoadStation
function Route:getFirstStation() if #self.stations > 0 then return self.stations[1].station end end

---Will inform the given stations about the train arrival in minutes and all sequential stations with the offset
---@param train Train the train which will arrive
---@param station RoadStation the first station in the route, where the train will arrive
---@param timeInMinutes number departure time of the train in minutes
function Route:prepareDepartureAt(train, station, timeInMinutes)
    assert(type(self) == "table", "Need to call this method with ':'")
    assert(type(train) == "table", "Need 'train' as table")
    assert(train.type == "Train", "Provide 'train' as 'Train'")
    assert(type(station) == "table", "Need 'station' as table")
    assert(station.type == "RoadStation", "Provide 'station' as 'RoadStation'")
    if timeInMinutes then assert(type(timeInMinutes) == "number", "Need 'timeInMinutes' as number") end

    timeInMinutes = timeInMinutes or 0
    local haveStation = false
    for i = 1, #self.stations do
        local s = self.stations[i].station
        if s == station then haveStation = true end
        if haveStation then
            local timeToStation = s == station and 0 or self.stations[i].timeToStation
            timeInMinutes = timeToStation and (timeInMinutes + timeToStation) or timeInMinutes
            s:trainArrivesIn(train.name, timeInMinutes)
        end
    end
end

---Will inform the given stations about the train arrival in minutes and all sequential stations with the offset
---@param train Train the train which will arrive
---@param station RoadStation the first station in the route, where the train will arrive
function Route:trainDeparted(train, station)
    assert(type(self) == "table", "Need to call this method with ':'")
    assert(type(train) == "table", "Need 'train' as table")
    assert(train.type == "Train", "Provide 'train' as 'Train'")
    assert(type(station) == "table", "Need 'station' as table")
    assert(station.type == "RoadStation", "Provide 'station' as 'RoadStation'")

    local timeInMinutes = 0
    local haveStation = false
    for i = 1, #self.stations do
        local s = self.stations[i].station
        if haveStation then
            local timeToStation = self.stations[i].timeToStation
            timeInMinutes = timeToStation and (timeInMinutes + timeToStation) or timeInMinutes
            s:trainArrivesIn(train.name, timeInMinutes)
        end
        if s == station then
            station:trainLeft(train.name)
            haveStation = true
        end
    end
end

function Route:toJsonStatic()
    return {id = self.id, stations = self.stations, routeName = self.routeName, lineNr = self.lineNr}
end

return Route
