local LineSegment = require("ak.public-transport.LineSegment")
local RoadStation = require("ak.public-transport.RoadStation")
local StorageUtility = require("ak.storage.StorageUtility")
local TrainRegistry = require("ak.train.TrainRegistry")
if AkDebugLoad then print("Loading ak.public-transport.Line ...") end

---@class Line
---@field type string
---@field lineSegments table<string, LineSegment>
---@field id string
---@field nr string
local Line = {}
Line.debug = AkDebugLoad or false
---@type table<string, Line>
local lines = {}
Line.showDepartureTippText = false

function Line.loadSettingsFromSlot(eepSaveId)
    StorageUtility.registerId(eepSaveId, "Line settings")
    Line.saveSlot = eepSaveId
    local data = StorageUtility.loadTable(Line.saveSlot, "Line settings")
    Line.showDepartureTippText = StorageUtility.toboolean(data["depInfo"]) or false
end

function Line.saveSettings()
    if Line.saveSlot then
        local data = {["depInfo"] = tostring(Line.showDepartureTippText)}
        StorageUtility.saveTable(Line.saveSlot, data, "Line settings")
    end
end

function Line.setShowDepartureTippText(value)
    assert(value == true or value == false)
    Line.showDepartureTippText = value
    Line.saveSettings()
    RoadStation.showTippText()
end

---Get or create a new bus or tram line
---@param name string name of the line, like "A" or "68"
---@return Line
function Line.forName(name)
    local LineRegistry = require("ak.public-transport.LineRegistry")
    return LineRegistry.forId(name)
end

---Creates a new bus or tram line
---@param o table table with entry "nr" as string
---@return Line
function Line:new(o)
    assert(type(o) == "table", "Need 'o' as table")
    assert(type(o.nr) == "string", "Need 'o.nr' as string")
    o.id = o.nr
    o.type = "Line"
    o.lineSegments = {}
    self.__index = self
    setmetatable(o, self)
    lines[o.nr] = o
    return o
end

---Adds a new line segment with its own destination
---@param routeName string name of the route in EEP. This route is used on route changes
---@param destination string name of the destination station, this will be set in the train
---@return LineSegment
function Line:addSection(routeName, destination)
    assert(type(self) == "table" and self.type == "Line", "Call this method with ':'")
    assert(type(routeName) == "string", "Need 'routeName' as string")
    assert(type(destination) == "string", "Need 'destination' as string")
    local lineSegment = LineSegment:new(routeName, self, destination);
    self.lineSegments[routeName] = lineSegment
    return lineSegment
end

---Change the train line according to the trains route, if no line is set in the train
---@param train Train
local function checkLine(train)
    if train then
        local lineName = train:getLine()
        local routeName = train:getRoute()
        if not lineName then
            for _, line in pairs(lines) do
                for _, segment in pairs(line.lineSegments) do
                    if segment.routeName == routeName then
                        train:changeDestination(segment.destination, line.nr)
                    end
                end
            end
        end
    end
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
    checkLine(train)
    assert(type(routeName) == "string", "Need 'routeName' as string")

    if lineName then
        local line = lines[lineName]
        if line then
            ---@type LineSegment
            local lineSegment = line.lineSegments[routeName]
            if lineSegment then
                lineSegment:prepareDepartureAt(train, station, timeInMinutes)
            else
                print("[Line] Could not find lineSegment for route: " .. routeName)
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

    local train = TrainRegistry.forName(trainName)
    local lineName = train:getLine()
    local routeName = train:getRoute()
    checkLine(train)
    assert(type(routeName) == "string", "Need 'routeName' as string")

    if lineName then
        station:trainLeft(trainName, train:getDestination(), lineName)
        local line = lines[lineName]
        if line then
            local lineSegment = line.lineSegments[routeName]
            if lineSegment then
                ---@type LineSegment
                lineSegment:trainDeparted(train, station)
            else
                print("[Line] Could not find lineSegment for route: " .. routeName)
            end
        else
            print("[Line] Could not find trains line: " .. lineName)
        end
    else
        print("[Line] Train has no line: " .. trainName)
    end
end

function Line:toJsonStatic() return {id = self.id, nr = self.nr, lineSegments = self.lineSegments} end

return Line
