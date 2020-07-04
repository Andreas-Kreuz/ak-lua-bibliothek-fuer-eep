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
    assert(type(self) == "table", "Provide 'self' as 'table' was ".. type(self))
    assert(type(rollingStockName) == "string", "Provide 'rollingStockName' as 'string' was ".. type(rollingStockName))
    assert(type(line) == "string", "Provide 'line' as 'string' was ".. type(line))
    -- Overwrite me
end

function RollingStockModel:setDestination(rollingStockName, destination)
    assert(type(self) == "table", "Provide 'self' as 'table' was ".. type(self))
    assert(type(rollingStockName) == "string", "Provide 'rollingStockName' as 'string' was ".. type(rollingStockName))
    assert(type(destination) == "string", "Provide 'destination' as 'string' was ".. type(destination))
    -- Overwrite me
end

function RollingStockModel:setStations(rollingStockName, stations)
    assert(type(self) == "table", "Provide 'self' as 'table' was ".. type(self))
    assert(type(rollingStockName) == "string", "Provide 'rollingStockName' as 'string' was ".. type(rollingStockName))
    assert(type(stations) == "string", "Provide 'stations' as 'string' was ".. type(stations))
    -- Overwrite me
end

function RollingStockModel:openDoors(rollingStockName)
    assert(type(self) == "table", "Provide 'self' as 'table' was ".. type(self))
    assert(type(rollingStockName) == "string", "Provide 'rollingStockName' as 'string' was ".. type(rollingStockName))
    -- Overwrite me
end

function RollingStockModel:closeDoors(rollingStockName)
    assert(type(self) == "table", "Provide 'self' as 'table' was ".. type(self))
    assert(type(rollingStockName) == "string", "Provide 'rollingStockName' as 'string' was ".. type(rollingStockName))
    -- Overwrite me
end

return RollingStockModel
