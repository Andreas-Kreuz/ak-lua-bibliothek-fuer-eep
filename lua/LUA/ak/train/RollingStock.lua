if AkDebugLoad then print("Loading ak.train.RollingStock ...") end
local RollingStockModels = require("ak.train.RollingStockModels")
local StorageUtility = require("ak.storage.StorageUtility")
local TagKeys = require("ak.train.TagKeys")
local EventBroker = require "ak.util.EventBroker"
local json = require "ak.io.json"

---@class RollingStock
---@field values table
---@field rollingStockName string
---@field model RollingStockModel
local RollingStock = {}

function RollingStock:new(o)
    assert(o.rollingStockName, "Provide a rollingStockName")
    assert(type(o.rollingStockName) == "string", "Need 'o.rollingStockName' as string")
    self.__index = self
    setmetatable(o, self)
    o.values = {}
    o.model = RollingStockModels.modelFor(o.rollingStockName)
    return o
end

---Adds or replaces a value in the rolling stock
---@param key string
---@param value string
function RollingStock:setValue(key, value)
    assert(type(self) == "table", "Need to call this method with ':'")
    assert(type(key) == "string", "Need 'key' as string")
    assert(type(value) == "string", "Need 'value' as string")
    self.values[key] = value
end

---Get the current value for key
---@param key string
---@return string value
function RollingStock:getValue(key)
    assert(type(self) == "table", "Need to call this method with ':'")
    assert(type(key) == "string", "Need 'key' as string")
    return self.values[key]
end

function RollingStock:save(clearCurrentInfo)
    local t = clearCurrentInfo and {} or self.values
    StorageUtility.saveTableRollingStock(self.rollingStockName, t)
end

function RollingStock:setLine(line)
    self:setValue(TagKeys.Train.line, line)
    self.model:setLine(self.rollingStockName, line)
end

function RollingStock:setDestination(destination)
    self:setValue(TagKeys.Train.destination, destination)
    self.model:setDestination(self.rollingStockName, destination)
end

function RollingStock:setStations(stations) self.model:setStations(self.rollingStockName, stations) end

function RollingStock:setWagonNr(nr)
    local oldNr = self:getValue(TagKeys.RollingStock.wagonNumber)
    self:setValue(TagKeys.RollingStock.wagonNumber, nr)
    self.model:setWagonNr(self.rollingStockName, nr)
    if oldNr ~= nr then
        EventBroker.fire("ak.train.RollingStock.nrChanged",
                         json.encode({rollingStockName = self.rollingStockName, nr = nr}))
    end
end

function RollingStock:openDoors() self.model:openDoors(self.rollingStockName) end

function RollingStock:closeDoors() self.model:closeDoors(self.rollingStockName) end

return RollingStock
