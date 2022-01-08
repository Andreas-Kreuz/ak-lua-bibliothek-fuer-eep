local Platform = require("ak.public-transport.Platform")
local StationQueue = require("ak.public-transport.StationQueue")
local StorageUtility = require("ak.storage.StorageUtility")

if AkDebugLoad then print("[#Start] Loading ak.public-transport.RoadStation ...") end

---@class RoadStation
---@field type string
---@field name string
---@field displays table table of RoadStationDisplay
---@field platforms table<number,Platform> table of Platform
---@field queue StationQueue
---@field routePlatforms table<string, PlatformAssignment>
local RoadStation = {}
RoadStation.debug = false
local allStations = {}

function RoadStation.queueToText(queue)
    if (queue) then
        local trainNames = {}
        for _, trainName in ipairs(queue.entriesByArrival) do table.insert(trainNames, trainName) end
        return table.concat(trainNames, "|")
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
        data["q"] = RoadStation.queueToText(station.queue)
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

local function getDestKey(lineNr, destination) return lineNr .. "->" .. destination end

function RoadStation:trainArrivesIn(trainName, destination, lineNr, timeInMinutes)
    assert(type(trainName) == "string", "Need 'trainName' as string")
    assert(type(destination) == "string", "Need 'destination' as string")
    assert(type(lineNr) == "string", "Need 'lineNr' as string")
    assert(type(timeInMinutes) == "number", "Need 'timeInMinutes' as number")

    local destKey = getDestKey(lineNr, destination)
    local platform
    if self.routePlatforms and self.routePlatforms[destKey] and self.routePlatforms[destKey].platform then
        platform = self.routePlatforms[destKey].platform
    else
        -- if RoadStation.debug then
        print("[#RoadStation] " .. self.name .. " NO PLATFORM FOR TRAIN: " .. trainName ..
              (destKey and " (" .. destKey .. ")" or ""))
        platform = "1"
        -- end
    end

    if RoadStation.debug then
        print(string.format("[#RoadStation] %s: Planning Arrival of %s in %d min on platform %s", self.name,
                            trainName, timeInMinutes, platform))
    end

    self.queue:push(trainName, destination, lineNr, timeInMinutes, platform)
    self:updateDisplays()
end

function RoadStation:trainLeft(trainName, destination, lineNr)
    self.queue:pop(trainName, destination, lineNr)
    self:updateDisplays()
end

---Sets the platform for trains of a certain segment
---@param segment LineSegment
---@param platform number
function RoadStation:setPlatform(segment, platform)
    assert(type(segment) == "table", "Need 'segment' as table")
    assert(segment.type == "LineSegment", "Provide 'segment' as 'Route'")
    assert(type(platform) == "number", "Need 'platform' as number")

    local destKey = getDestKey(segment.line.nr, segment.destination)
    platform = tostring(platform)

    self.routePlatforms = self.routePlatforms or {}
    self.routePlatforms[destKey] = self.routePlatforms[destKey] or {}
    self.routePlatforms[destKey].platform = platform
    self:updateRoutesOnPlatform(platform)
end

function RoadStation:updateRoutesOnPlatform(platform)
    local routesOfPlatform = {}
    for r, p in pairs(self.routePlatforms or {}) do
        if p.platform == platform then table.insert(routesOfPlatform, r) end
    end
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
        if RoadStation.debug then print("[#RoadStation] update display for platform " .. platform) end
        local entries = self.queue:getTrainEntries(platform ~= "ALL" and platform or nil)
        for _, display in ipairs(displays) do
            if RoadStation.debug then
                print("[#RoadStation] " .. self.name .. " update display for platform " .. display.structure ..
                      " with " .. #entries .. " entries")
            end
            display.model.displayEntries(display.structure, entries, self.name, platform)
        end
    end
end

function RoadStation:addDisplay(structure, model, platformNr)
    platformNr = platformNr and tostring(platformNr) or "1"
    assert(type(structure) == "string", "Need 'structure' as string")
    assert(type(model) == "table", "Need 'model' as table")
    platformNr = platformNr and tostring(platformNr) or nil
    self.displays[platformNr or "ALL"] = self.displays[platformNr or "ALL"] or {}
    table.insert(self.displays[platformNr or "ALL"], {structure = structure, model = model})
    self:updateRoutesOnPlatform(platformNr)
end

---comment
---@param platformNr any
---@return Platform
function RoadStation:platform(platformNr)
    local platform = self.platforms[platformNr]
    if not platform then
        platform = Platform:new(self, platformNr)
        self.platforms[platformNr] = platform
    end
    return platform
end

--- Creates a new Bus or Tram Station
---@param name string @Name der Haltestelle
---@param eepSaveId number, @EEPSaveSlot-Id fuer das Speichern der Fahrzeuge dieser Haltestelle
---@return RoadStation
function RoadStation:new(name, eepSaveId)
    assert(name, "Bitte geben Sie den Namen \"name\" fuer diese Station an.")
    assert(type(name) == "string", "Need 'name' as string")
    assert(eepSaveId, "Bitte geben Sie den Wert \"eepSaveId\" fuer diese Station an.")
    assert(type(eepSaveId) == "number", "Need 'eepSaveId' as number")
    if eepSaveId ~= -1 then StorageUtility.registerId(eepSaveId, "Lane " .. name) end

    ---@class PlatformAssignment
    ---@field platform number
    local routePlatforms = {}

    local o = {
        type = "RoadStation",
        name = name,
        eepSaveId = eepSaveId,
        queue = StationQueue:new(),
        displays = {},
        platforms = {},
        routePlatforms = routePlatforms
    }

    self.__index = self
    setmetatable(o, self)
    load(o)
    save(o)
    allStations[name] = o
    return o
end

---Get a roadstation by creation or lookup (use this instead of RoadStation:new()!)
---@param name string
---@return RoadStation
function RoadStation.forName(name) return allStations[name] or RoadStation:new(name, -1) end

function RoadStation.showTippText() for _, station in pairs(allStations) do station:updateDisplays() end end

return RoadStation
