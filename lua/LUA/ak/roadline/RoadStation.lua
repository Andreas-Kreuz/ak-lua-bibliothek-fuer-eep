if AkDebugLoad then print("Loading ak.roadline.RoadStation ...") end

local TrainRegistry = require "ak.train.TrainRegistry"
local StationQueue = require("ak.roadline.StationQueue")
local StorageUtility = require("ak.storage.StorageUtility")

---@class RoadStation
---@field type string
---@field name string
---@field displays table table of RoadStationDisplay
---@field queue StationQueue
---@field routes Route
local RoadStation = {}
RoadStation.debug = false
local allStations = {}

local function queueToText(queue)
    if (queue) then
        local trainsNames = {}
        for _, trainName in ipairs(queue.entriesByArrival) do table.insert(trainsNames, trainName) end
        return table.concat({}, "|")
    else
        return ""
    end
end

local function queueFromText(pipeSeparatedText)
    local queue = StationQueue:new()
    for element in string.gmatch(pipeSeparatedText, "[^|]+") do
        -- print(element)
        queue:push(element, 0)
    end
    return queue
end

local function save(station)
    if station.eepSaveId ~= -1 then
        local data = {}
        data["q"] = queueToText(station.queue)
        StorageUtility.saveTable(station.eepSaveId, data, "Station " .. station.name)
    end
end

local function load(station)
    if station.eepSaveId ~= -1 then
        local data = StorageUtility.loadTable(station.eepSaveId, "Station " .. station.name)
        station.queue = queueFromText(data["q"] or "")
    else
        station.queue = StationQueue:new()
    end
end

function RoadStation:trainArrivesIn(trainName, timeInMinutes)
    assert(type(trainName) == "string", "Need 'trainName' as string")
    assert(type(timeInMinutes) == "number", "Need 'timeInMinutes' as number")

    local train = TrainRegistry.forName(trainName)
    local routeName = train:getRoute()
    assert(type(routeName) == "string", "Need 'routeName' as string")

    local platform
    if self.routes and self.routes[routeName] and self.routes[routeName].platform then
        platform = self.routes[routeName].platform
    else
        -- if RoadStation.debug then
        print("[RoadStation] " .. self.name .. " NO PLATFORM FOR TRAIN: " .. trainName ..
              (routeName and " (" .. routeName .. ")" or ""))
        platform = "1"
        -- end
    end

    if RoadStation.debug then
        print(string.format("[RoadStation] %s: Planning Arrival of %s in %d min on platform %s", self.name, trainName,
                            timeInMinutes, platform))
    end

    self.queue:push(trainName, timeInMinutes, platform)
    self:updateDisplays()
end

function RoadStation:trainLeft(trainName)
    self.queue:pop(trainName)
    self:updateDisplays()
end

function RoadStation:setPlatform(route, platform)
    assert(type(route) == "table", "Need 'route' as table")
    assert(route.type == "Route", "Provide 'route' as 'Route'")
    assert(type(platform) == "number", "Need 'platform' as number")

    local routeName = route.routeName
    platform = tostring(platform)

    self.routes = self.routes or {}
    self.routes[routeName] = self.routes[routeName] or {}
    self.routes[routeName].platform = platform
    self:updateRoutesOnPlatform(platform)
end

function RoadStation:updateRoutesOnPlatform(platform)
    local routesOfPlatform = {}
    for r, p in pairs(self.routes or {}) do if p.platform == platform then table.insert(routesOfPlatform, r) end end
    table.sort(routesOfPlatform, function(a, b) return a < b end)

    for p, displays in pairs(self.displays or {}) do
        if platform == p or platform == "ALL" then
            for _, display in ipairs(displays) do
                display.model.initStation(display.structure, self.name, platform, routesOfPlatform)
            end
        end
    end
end

function RoadStation:updateDisplays()
    for platform, displays in pairs(self.displays) do
        if RoadStation.debug then print("[RoadStation] update display for platform " .. platform) end
        local entries = self.queue:getTrainEntries(platform ~= "ALL" and platform or nil)
        for _, display in ipairs(displays) do
            if RoadStation.debug then
                print("[RoadStation] update display for platform " .. display.structure .. " with " .. #entries ..
                      " entries")
            end
            display.model.displayEntries(display.structure, entries, self.name, platform)
        end
    end
end

function RoadStation:addDisplay(structure, model, platform)
    platform = platform and tostring(platform) or "1"
    assert(type(structure) == "string", "Need 'structure' as string")
    assert(type(model) == "table", "Need 'model' as table")
    platform = platform and tostring(platform) or nil
    self.displays[platform or "ALL"] = self.displays[platform or "ALL"] or {}
    table.insert(self.displays[platform or "ALL"], {structure = structure, model = model})
    self:updateRoutesOnPlatform(platform)
end

--- Creates a new Bus or Tram Station
---@param name string @Name der Haltestelle
---@param eepSaveId number, @EEPSaveSlot-Id fuer das Speichern der Fahrzeuge dieser Haltestelle
---@return RoadStation
function RoadStation:new(name, eepSaveId)
    assert(name, "Bitte geben Sie den Namen \"name\" fuer diese Fahrspur an.")
    assert(type(name) == "string", "Need 'name' as string")
    assert(eepSaveId, "Bitte geben Sie den Wert \"eepSaveId\" fuer diese Fahrspur an.")
    assert(type(eepSaveId) == "number", "Need 'eepSaveId' as number")
    if eepSaveId ~= -1 then StorageUtility.registerId(eepSaveId, "Lane " .. name) end
    local o = {type = "RoadStation", name = name, eepSaveId = eepSaveId, queue = StationQueue:new(), displays = {}}

    self.__index = self
    setmetatable(o, self)
    load(o)
    save(o)
    allStations[name] = o
    return o
end

function RoadStation.stationByName(stationName) return allStations[stationName] end

return RoadStation
