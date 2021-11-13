local EventBroker = require "ak.util.EventBroker"
local TableUtils = require "ak.util.TableUtils"
if AkDebugLoad then print("Loading ak.train.Train ...") end

local RollingStockRegistry = require("ak.train.RollingStockRegistry")
local RollingStockModels = require("ak.train.RollingStockModels")
local StorageUtility = require("ak.storage.StorageUtility")
local TagKeys = require("ak.train.TagKeys")
local EepFunctionWrapper = require("ak.core.eep.EepFunctionWrapper")
local EEPGetTrainLength = EepFunctionWrapper.EEPGetTrainLength

---@class Train
---@field name string
---@field type string
---@field values table of all entries stored in the train
---@field route string
---@field rollingStockCount number number of cars
---@field speed number
---@field length number
---@field trackType string
---@field onTrack number
---@field occupiedTracks table
local Train = {}

---Create a new train with the given object
---@param o Train must contain a string o.name
function Train:new(o)
    assert(type(self) == "table", "Need to call this method with ':'")
    assert(o, "Provide a train object")
    assert(type(o) == "table", "Need 'o' as table")
    assert(o.name, "Provide a name for the train")
    assert(type(o.name) == "string", "Need 'o.name' as string")
    local haveTrain, trainRoute = EEPGetTrainRoute(o.name)
    local rollingStockCount = EEPGetRollingstockItemsCount(o.name)
    local _, length = EEPGetTrainLength(o.name)
    local _, speed = EEPGetTrainSpeed(o.name)
    assert(haveTrain, o.name)
    self.__index = self
    setmetatable(o, self)
    o.type = "Train"
    o.values = o:load()
    o.route = trainRoute
    o.rollingStockCount = rollingStockCount
    o.length = tonumber(string.format("%.2f", length or 0))
    o.speed = speed
    o.trackType = nil
    o.onTracks = {}
    o.occupiedTracks = {}
    return o
end

---Loads a table with values from the first rollingstock of the train
function Train:load()
    assert(type(self) == "table", "Need to call this method with ':'")
    local rollingStockName = EEPGetRollingstockItemName(self.name, 0)
    return StorageUtility.loadTableRollingStock(rollingStockName)
end

---Adds or replaces all table values to ALL rolling stock of the train
function Train:save(clearCurrentInfo)
    assert(type(self) == "table", "Need to call this method with ':'")
    local carCount = EEPGetRollingstockItemsCount(self.name)
    for i = 0, carCount - 1 do
        local rollingStockName = EEPGetRollingstockItemName(self.name, i)
        RollingStockRegistry.forName(rollingStockName):save(clearCurrentInfo)
    end
end

--- Gets the trains name
---@return string trains name
function Train:getName()
    assert(type(self) == "table", "Need to call this method with ':'")
    return self.name
end

--- Gets the length of the train in meters
---@return number length of the train in meters
function Train:getLength()
    assert(type(self) == "table", "Need to call this method with ':'")
    return self.length
end

---Adds or replaces a value to ALL rolling stock of the train
---@param key string
---@param value string
function Train:setValue(key, value)
    assert(type(self) == "table", "Need to call this method with ':'")
    assert(type(key) == "string", "Need 'key' as string")
    assert(type(value) == "string", "Need 'value' as string")
    self.values[key] = value
    local carCount = EEPGetRollingstockItemsCount(self.name)
    for i = 0, carCount - 1 do
        local rollingStockName = EEPGetRollingstockItemName(self.name, i)
        local rs = RollingStockRegistry.forName(rollingStockName)
        rs:setValue(key, value)
    end
end

---Get the current value for key
---@param key string
---@return string value
function Train:getValue(key)
    assert(type(self) == "table", "Need to call this method with ':'")
    assert(type(key) == "string", "Need 'key' as string")
    return self.values[key]
end

function Train:changeDestination(destination, line)
    assert(type(self) == "table", "Need 'self' as table")
    assert(type(destination) == "string", "Need 'destination' as string")
    assert(type(line) == "string", "Need 'line' as string")

    self:setLine(line)
    self:setDestination(destination)

    local carCount = EEPGetRollingstockItemsCount(self.name)
    for i = 0, carCount - 1 do
        local rollingStockName = EEPGetRollingstockItemName(self.name, i)
        local model = RollingStockModels.modelFor(rollingStockName)
        model:setLine(rollingStockName, line)
        model:setDestination(rollingStockName, destination)
    end
end

--- Changes the trains route
---@param route string Route like set in EEP
function Train:setRoute(route)
    assert(type(self) == "table", "Need to call this method with ':'")
    assert(type(route) == "string", "Need 'route' as string")
    local oldRoute = self.route
    self.route = route
    EEPSetTrainRoute(self.name, self.route)
    if oldRoute ~= route then
        EventBroker.fireDataChange("Train Route Changed", EventBroker.change.dataUpdated, "trains", "id",
                                   {id = self.name, route = route})
    end
end

--- Gets the trains route like used in EEP
---@return string route name like in EEP
function Train:getRoute()
    assert(type(self) == "table", "Need to call this method with ':'")
    return self.route
end

--- Updates the trains rolling stock count
---@param count integer number of cars
function Train:setRollingStockCount(count)
    assert(type(self) == "table", "Need to call this method with ':'")
    assert(type(count) == "number", "Need 'count' as number")
    local oldCount = count
    self.rollingStockCount = count
    if oldCount ~= count then
        EventBroker.fireDataChange("Train RollingStock count Changed", EventBroker.change.dataUpdated, "trains", "id",
                                   {id = self.name, rollingStockCount = count})
    end
end

--- Gets the trains route like used in EEP
---@return string integer number of cars
function Train:getRollingStockCount()
    assert(type(self) == "table", "Need to call this method with ':'")
    return self.rollingStockCount
end

--- Updates the trains speed in km/h
---@param speed number train speed in km/h
function Train:setSpeed(speed)
    assert(type(self) == "table", "Need to call this method with ':'")
    assert(type(speed) == "number", "Need 'speed' as number")
    speed = tonumber(string.format("%1.1f", speed))
    local oldSpeed = self.speed
    self.speed = speed
    if oldSpeed ~= speed then
        EventBroker.fireDataChange("Train Speed Changed", EventBroker.change.dataUpdated, "trainInfo", "id",
                                   {id = self.name, speed = speed})
    end
end

--- Gets the trains speed in km/h
---@return number train speed in km/h
function Train:getSpeed()
    assert(type(self) == "table", "Need to call this method with ':'")
    return self.speed
end

--- Updates the trains speed in km/h
---@param onTracks number train speed in km/h
function Train:setOnTrack(onTracks)
    assert(type(self) == "table", "Need to call this method with ':'")
    assert(type(onTracks) == "table", "Need 'onTracks' as table")
    local oldOnTracks = self.onTracks
    self.onTracks = onTracks
    if not TableUtils.sameDictEntries(oldOnTracks, onTracks) then
        EventBroker.fireDataChange("Train occupiedTracks Changed", EventBroker.change.dataUpdated, "trainInfo", "id",
                                   {id = self.name, occupiedTacks = onTracks})
    end
end

--- Gets the trains speed in km/h
---@return number train speed in km/h
function Train:getOnTrack()
    assert(type(self) == "table", "Need to call this method with ':'")
    return self.onTracks
end

function Train:setTrackType(trackType)
    assert(type(self) == "table", "Need to call this method with ':'")
    assert(type(trackType) == "string", "Need 'direction' as string")
    local oldTrackType = self.trackType
    self.trackType = trackType
    if oldTrackType ~= trackType then
        EventBroker.fireDataChange("Train Track Type Changed", EventBroker.change.dataUpdated, "trainInfo", "id",
                                   {id = self.name, trackType = trackType})
    end
end

function Train:getTrackType() return self.trackType end

function Train:setDirection(direction)
    assert(type(self) == "table", "Need to call this method with ':'")
    assert(type(direction) == "string", "Need 'direction' as string")
    local oldDirection = self:getDirection()
    self:setValue(TagKeys.Train.direction, direction)
    if oldDirection ~= direction then
        EventBroker.fireDataChange("Train Direction Changed", EventBroker.change.dataUpdated, "trains", "id",
                                   {id = self.name, direction = direction})
    end
end

function Train:getDirection() return self:getValue(TagKeys.Train.direction) end

function Train:setDestination(destination)
    assert(type(destination) == "string", "Need 'destination' as string")
    local oldDestination = destination
    self:setValue(TagKeys.Train.destination, destination)
    if oldDestination ~= destination then
        EventBroker.fireDataChange("Train Destination Changed", EventBroker.change.dataUpdated, "trains", "id",
                                   {id = self.name, destination = destination})
    end
end

function Train:getDestination()
    assert(type(self) == "table", "Need to call this method with ':'")
    return self:getValue(TagKeys.Train.destination)
end

function Train:setLine(line)
    assert(type(self) == "table", "Need to call this method with ':'")
    assert("string" == type(line) or "number" == type(line), "Provide 'line' as 'string' or 'number'")
    line = tostring(line)
    local oldLine = self:getLine()
    self:setValue(TagKeys.Train.line, line)
    if oldLine ~= line then
        EventBroker.fireDataChange("Train Line Changed", EventBroker.change.dataUpdated, "trains", "id",
                                   {id = self.name, line = line})
    end
end

function Train:getLine()
    assert(type(self) == "table", "Need to call this method with ':'")
    return self:getValue(TagKeys.Train.line)
end

function Train:toJsonStatic()
    return {
        id = self:getName(),
        route = self:getRoute(),
        rollingStockCount = self:getRollingStockCount(),
        length = self:getLength(),
        line = self:getLine(),
        destination = self:getDestination(),
        direction = self:getDirection()
    }
end

function Train:toJsonDynamic()
    return {
        id = self:getName(),
        trackType = self:getTrackType(),
        speed = self:getSpeed(),
        occupiedTacks = self:getOnTrack()
    }
end

return Train
