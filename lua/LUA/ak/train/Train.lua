if AkDebugLoad then print("Loading ak.train.Train ...") end

local RollingStock = require("ak.train.RollingStock")
local RollingStockModels = require("ak.train.RollingStockModels")
local StorageUtility = require("ak.storage.StorageUtility")
local TagKeys = require("ak.train.TagKeys")

---@class Train
---@field type string
---@field trainName string
---@field values table of all entries stored in the train
local Train = {}
local allTrains = {}

---Creates a train object for the given train name, the train must exist
---@param trainName string name of the train in EEP, e.g. "#Train 1"
function Train.forName(trainName)
    assert(trainName, "Provide a name for the train")
    assert(type(trainName) == "string", "Need 'trainName' as string")
    if allTrains[trainName] then
        return allTrains[trainName]
    else
        return Train:new({trainName = trainName})
    end
end

---Create a new train with the given object
---@param o table must contain a string o.trainName
function Train:new(o)
    assert(type(self) == "table", "Need to call this method with ':'")
    assert(o, "Provide a train object")
    assert(type(o) == "table", "Need 'o' as table")
    assert(o.trainName, "Provide a name for the train")
    assert(type(o.trainName) == "string", "Need 'o.trainName' as string")
    local haveTrain, trainRoute = EEPGetTrainRoute(o.trainName)
    assert(haveTrain, o.trainName)
    self.__index = self
    setmetatable(o, self)
    o.type = "Train"
    o.values = o:load()
    o:setRoute(trainRoute)
    allTrains[o.trainName] = o
    return o
end

---Loads a table with values from the first rollingstock of the train
function Train:load()
    assert(type(self) == "table", "Need to call this method with ':'")
    local rollingStockName = EEPGetRollingstockItemName(self.trainName, 0)
    return StorageUtility.loadTableRollingStock(rollingStockName)
end

---Adds or replaces all table values to ALL rolling stock of the train
function Train:save(clearCurrentInfo)
    assert(type(self) == "table", "Need to call this method with ':'")
    local carCount = EEPGetRollingstockItemsCount(self.trainName)
    for i = 0, carCount - 1 do
        local rollingStockName = EEPGetRollingstockItemName(self.trainName, i)
        RollingStock.forName(rollingStockName):save(clearCurrentInfo)
    end
end

---Adds or replaces a value to ALL rolling stock of the train
---@param key string
---@param value string
function Train:setValue(key, value)
    assert(type(self) == "table", "Need to call this method with ':'")
    assert(type(key) == "string", "Need 'key' as string")
    assert(type(value) == "string", "Need 'value' as string")
    self.values[key] = value
    local carCount = EEPGetRollingstockItemsCount(self.trainName)
    for i = 0, carCount - 1 do
        local rollingStockName = EEPGetRollingstockItemName(self.trainName, i)
        RollingStock.forName(rollingStockName):setValue(key, value)
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
    self:save()

    local carCount = EEPGetRollingstockItemsCount(self.trainName)
    for i = 0, carCount - 1 do
        local rollingStockName = EEPGetRollingstockItemName(self.trainName, i)
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
    self.trainRoute = route
    EEPSetTrainRoute(self.trainName, self.trainRoute)
end

--- Gets the trains route like used in EEP
---@return string route name like in EEP
function Train:getRoute()
    assert(type(self) == "table", "Need to call this method with ':'")
    return self.trainRoute
end

function Train:setDirection(direction)
    assert(type(self) == "table", "Need to call this method with ':'")
    assert(type(direction) == "string", "Need 'direction' as string")
    self:setValue(TagKeys.Train.direction, direction)
end

function Train:getDirection() return self:getValue(TagKeys.Train.direction) end

function Train:setDestination(destination)
    assert(type(destination) == "string", "Need 'destination' as string")
    self:setValue(TagKeys.Train.destination, destination)
end

function Train:getDestination()
    assert(type(self) == "table", "Need to call this method with ':'")
    return self:getValue(TagKeys.Train.destination)
end

function Train:setLine(line)
    assert(type(self) == "table", "Need to call this method with ':'")
    assert("string" == type(line) or "number" == type(line), "Provide 'line' as 'string' or 'number'")
    line = tostring(line)
    self:setValue(TagKeys.Train.line, line)
end

function Train:getLine()
    assert(type(self) == "table", "Need to call this method with ':'")
    return self:getValue(TagKeys.Train.line)
end

return Train
