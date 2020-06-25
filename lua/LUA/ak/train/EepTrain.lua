if AkDebugLoad then print("Loading ak.trains.EepTrain ...") end

local StorageUtility = require("ak.storage.StorageUtility")

---@class EepTrain
local EepTrain = {}
EepTrain.Key = {
    destination = "d",
    direction = "a",
    line = "l",
    route = "r",
    trainNumber = "n",
}

---Create a new train with the given name
function EepTrain:new(trainName)
    assert(trainName, "Provide a name for the train")
    assert("string" == type(trainName), "Provide the destinationName as string")
    local haveTrain, trainRoute = EEPGetTrainRoute(trainName)
    assert(haveTrain, "Train " .. trainName .. " does not exist")
    local o = {
        trainName = trainName
    }
    self.__index = self
    setmetatable(o, self)
    o.values = o:load()
    o:setRoute(trainRoute)
    return o
end

---Loads a table with values from the first rollingstock of the train
function EepTrain:load()
    local rollingStockName = EEPGetRollingstockItemName(self.trainName, 0)
    return StorageUtility.loadTableRollingStock(rollingStockName)
end

---Adds or replaces all table values to ALL rolling stock of the train
function EepTrain:save(clearCurrentInfo)
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

function EepTrain:changeDestination(destination, line)
    self:setLine(line)
    self:setDestination(destination)
    self:save()
end

function EepTrain:setRoute(route)
    assert(route)
    assert("string" == type(route))
    self.values[EepTrain.Key.route] = route
    self.trainRoute = route
    EEPSetTrainRoute(self.trainName, self.trainRoute)
end

function EepTrain:getRoute() return self.trainRoute end

function EepTrain:setDirection(direction)
    assert(direction)
    assert("string" == type(direction))
    self.values[EepTrain.Key.direction] = direction
end

function EepTrain:getDirection() return self.values[EepTrain.Key.direction] end

function EepTrain:setDestination(destination)
    assert(destination)
    assert("string" == type(destination))
    self.values[EepTrain.Key.destination] = destination
end

function EepTrain:getDestination() return self.values[EepTrain.Key.destination] end

function EepTrain:setLine(line)
    assert(line)
    assert("string" == type(line) or "number" == type(line))
    line = tostring(line)
    self.values[EepTrain.Key.line] = line
end

function EepTrain:getLine() return self.values[EepTrain.Key.line] end


return EepTrain
