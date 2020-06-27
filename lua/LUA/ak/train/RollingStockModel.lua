if AkDebugLoad then print("Loading ak.train.RollingStockModel ...") end

---@class RollingStockModel
local RollingStockModel = {}

function RollingStockModel:new(o)
    o = o or {}
    self.__index = self
    setmetatable(o, self)
    return o
end

function RollingStockModel:setLine(rollingStockName, line)
    assert(self)
    assert(line)
    assert(rollingStockName)
    -- Overwrite me
end

function RollingStockModel:setDestination(rollingStockName, destination)
    assert(self)
    assert(destination)
    assert(rollingStockName)
    -- Overwrite me
end

function RollingStockModel:setStations(rollingStockName, stations)
    assert(self)
    assert(stations)
    assert(rollingStockName)
    -- Overwrite me
end

function RollingStockModel:openDoors(rollingStockName)
    assert(self)
    assert(rollingStockName)
    -- Overwrite me
end

function RollingStockModel:closeDoors(rollingStockName)
    assert(self)
    assert(rollingStockName)
    -- Overwrite me
end

return RollingStockModel
