if AkDebugLoad then print("Loading ak.train.RollingStock ...") end
local RollingStockModels = require("ak.train.RollingStockModels")

---@class RollingStock
local RollingStock = {}

function RollingStock.forName(rollingStockName)
    assert(rollingStockName, "Provide a rollingStockName")
    assert("string" == type(rollingStockName), "Provide the rollingStockName as string")
    return RollingStock:new({ rollingStockName = rollingStockName })
end

function RollingStock:new(o)
    assert(o.rollingStockName, "Provide a rollingStockName")
    assert("string" == type(o.rollingStockName), "Provide the rollingStockName as string")
    self.__index = self
    setmetatable(o, self)
    o.model = RollingStockModels.modelFor(o.rollingStockName)
    return o
end

function RollingStock:setLine(line) self.model:setLine(self.name, line) end
function RollingStock:setDestination(destination) self.model:setDestination(self.name, destination) end
function RollingStock:setStations(stations) self.model:setStations(self.name, stations) end
function RollingStock:setWagonNr(nr) self.model:setWagonNr(self.name, nr) end
function RollingStock:openDoors() self.model:openDoors(self.name) end
function RollingStock:closeDoors() self.model:closeDoors(self.name) end

return RollingStock
