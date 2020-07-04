if AkDebugLoad then print("Loading ak.train.Train ...") end

local StorageUtility = require("ak.storage.StorageUtility")

---@class Train
local Train = {}
Train.Key = {
    destination = "d",
    direction = "a",
    line = "l",
    route = "r",
    trainNumber = "n",
}
local allTrains = {}

---Creates a train object for the given train name, the train must exist
---@param trainName string name of the train in EEP, e.g. "#Train 1"
function Train.forName(trainName)
    assert(trainName, "Provide a name for the train")
    assert("string" == type(trainName), "Provide the trainName as string")
    if allTrains[trainName] then
        return allTrains[trainName]
    else
        return Train:new({ trainName = trainName })
    end
end

---Create a new train with the given object
---@param o table must contain a string o.trainName
function Train:new(o)
    assert(o, "Provide a train object")
    assert("table" == type(o), "Provide the train object as table")
    assert(o.trainName, "Provide a name for the train")
    assert("string" == type(o.trainName), "Provide the trainName as string")
    local haveTrain, trainRoute = EEPGetTrainRoute(o.trainName)
    assert(haveTrain, "Train " .. o.trainName .. " does not exist")
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
    local rollingStockName = EEPGetRollingstockItemName(self.trainName, 0)
    return StorageUtility.loadTableRollingStock(rollingStockName)
end

---Adds or replaces all table values to ALL rolling stock of the train
function Train:save(clearCurrentInfo)
    local carCount = EEPGetRollingstockItemsCount(self.trainName)
    for i = 0, carCount - 1 do
        local rollingStockName = EEPGetRollingstockItemName(self.trainName, i)
        local t = clearCurrentInfo and {} or self.values
        for k, v in pairs(t) do
            t[k] = v
        end
        StorageUtility.saveTableRollingStock(rollingStockName, t)
    end
end

function Train:changeDestination(destination, line)
    self:setLine(line)
    self:setDestination(destination)
    self:save()
end

--- Changes the trains route
---@param route string Route like set in EEP
function Train:setRoute(route)
    assert(type(route) == "string", "Provide 'route' as 'string' was ".. type(string))
    self.values[Train.Key.route] = route
    self.trainRoute = route
    EEPSetTrainRoute(self.trainName, self.trainRoute)
end

--- Gets the trains route like used in EEP
---@return string route name like in EEP
function Train:getRoute() return self.trainRoute end

function Train:setDirection(direction)
    assert(type(direction) == "string", "Provide 'direction' as 'string' was ".. type(string))
    self.values[Train.Key.direction] = direction
end

function Train:getDirection() return self.values[Train.Key.direction] end

function Train:setDestination(destination)
    assert(type(destination) == "string", "Provide 'destination' as 'string' was ".. type(string))
    self.values[Train.Key.destination] = destination
end

function Train:getDestination() return self.values[Train.Key.destination] end

function Train:setLine(line)
    assert("string" == type(line) or "number" == type(line), "Provide 'line' as 'string' or 'number'")
    line = tostring(line)
    self.values[Train.Key.line] = line
end

function Train:getLine() return self.values[Train.Key.line] end

return Train
