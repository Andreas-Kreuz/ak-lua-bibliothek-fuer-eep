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
    assert(type(self) == "table", "Need 'self' as table")
    assert(type(rollingStockName) == "string", "Need 'rollingStockName' as string")
    assert(type(line) == "string", "Need 'line' as string")
    -- Overwrite me
end

function RollingStockModel:setDestination(rollingStockName, destination)
    assert(type(self) == "table", "Need 'self' as table")
    assert(type(rollingStockName) == "string", "Need 'rollingStockName' as string")
    assert(type(destination) == "string", "Need 'destination' as string")
    -- Overwrite me
end

function RollingStockModel:setStations(rollingStockName, stations)
    assert(type(self) == "table", "Need 'self' as table")
    assert(type(rollingStockName) == "string", "Need 'rollingStockName' as string")
    assert(type(stations) == "string", "Need 'stations' as string")
    -- Overwrite me
end

function RollingStockModel:setWagonNr(rollingStockName, wagonNumber)
    assert(type(self) == "table", "Need 'self' as table")
    assert(type(rollingStockName) == "string", "Need 'rollingStockName' as string")
    assert(type(wagonNumber) == "string", "Need 'wagonNumber' as string")
    -- Overwrite me
end

function RollingStockModel:openDoors(rollingStockName)
    assert(type(self) == "table", "Need 'self' as table")
    assert(type(rollingStockName) == "string", "Need 'rollingStockName' as string")
    -- Overwrite me
end

function RollingStockModel:closeDoors(rollingStockName)
    assert(type(self) == "table", "Need 'self' as table")
    assert(type(rollingStockName) == "string", "Need 'rollingStockName' as string")
    -- Overwrite me
end

return RollingStockModel
