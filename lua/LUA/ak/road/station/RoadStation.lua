if AkDebugLoad then
    print("Loading ak.road.station.RoadStation ...")
end

local EepTrain = require("ak.train.EepTrain")
local StationQueue = require("ak.road.station.StationQueue")
local StorageUtility = require("ak.storage.StorageUtility")

---@class RoadStation
local RoadStation = {}
RoadStation.debug = false

local function queueToText(queue)
    if (queue) then
        local trainsNames = {}
        for _, trainName in ipairs(queue.entriesByArrival) do
            table.insert(trainsNames, trainName)
        end
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

function RoadStation:stationArrivalPlanned(trainName, timeInMinutes)
    local train = EepTrain:new(trainName)
    local destination = train:getDestination()
    local line = train:getLine()
    local platform
    if self.lines
        and self.lines[line]
        and self.lines[line].destinations
        and self.lines[line].destinations[destination]
        and self.lines[line].destinations[destination].platform then
        platform = self.lines[line].destinations[destination].platform
    else
        print("[RoadStation] NO PLATFORM FOR TRAIN: " .. trainName)
        platform = "1"
    end

    if RoadStation.debug then
        print(
            string.format(
                "[RoadStation] Planning Arrival of %s in %d min on platform %s",
                trainName,
                timeInMinutes,
                platform
            )
        )
    end

    self.queue:push(trainName, timeInMinutes, platform)
    self:updateDisplays()
end

function RoadStation:stationLeft(trainName)
    self.queue:pop(trainName)
    self:updateDisplays()
end

function RoadStation:setPlatform(line, destination, platform)
    assert(line)
    assert(destination)
    assert(platform)
    line = tostring(line)
    platform = tostring(platform)

    self.lines = self.lines or {}
    self.lines[line] = self.lines[line] or {}

    self.lines[line].destinations = self.lines[line].destinations or {}
    self.lines[line].destinations[destination] = self.lines[line].destinations[destination] or {}

    self.lines[line].destinations[destination].platform = platform
end

function RoadStation:updateDisplays()
    for platform, displays in pairs(self.displays) do
        if RoadStation.debug then print("[RoadStation] update display for platform " .. platform) end
        local entries = self.queue:getTrainEntries(platform ~= "ALL" and platform or nil)
        for _, display in ipairs(displays) do
            if RoadStation.debug then
                print("[RoadStation] update display for platform " .. display.structure
                    .. " with " .. #entries .. " entries")
            end
            display.model.displayEntries(display.structure, entries)
        end
    end
end

function RoadStation:addDisplay(structure, model, platform)
    platform = platform and tostring(platform) or "1"
    assert(structure)
    assert(model)
    platform = platform and tostring(platform) or nil
    self.displays[platform or "ALL"] = self.displays[platform or "ALL"] or {}
    table.insert(self.displays[platform or "ALL"], {structure = structure, model = model})
end

--- Creates a new Bus or Tram Station
---@param name string @Name der Fahrspur einer Kreuzung
---@param eepSaveId number, @EEPSaveSlot-Id fuer das Speichern der Fahrspur
---@return RoadStation
function RoadStation:new(name, eepSaveId)
    assert(name, 'Bitte geben Sie den Namen "name" fuer diese Fahrspur an.')
    assert(type(name) == "string", "Name ist kein String")
    assert(eepSaveId, 'Bitte geben Sie den Wert "eepSaveId" fuer diese Fahrspur an.')
    assert(type(eepSaveId) == "number")
    if eepSaveId ~= -1 then
        StorageUtility.registerId(eepSaveId, "Lane " .. name)
    end
    local o = {
        name = name,
        eepSaveId = eepSaveId,
        queue = StationQueue:new(),
        displays = {}
    }

    self.__index = self
    setmetatable(o, self)
    load(o)
    save(o)
    return o
end

return RoadStation
