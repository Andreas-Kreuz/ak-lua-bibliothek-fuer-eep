local EventBroker = require "ak.util.EventBroker"
local RollingStock = require "ak.train.RollingStock"
local RollingStockRegistry = {}
local allRollingStock = {}

---Creates a train object for the given train name, the train must exist
---@param rollingStockName string name of the train in EEP, e.g. "#Train 1"
---@return RollingStock
function RollingStockRegistry.forName(rollingStockName)
    assert(rollingStockName, "Provide a rollingStockName")
    assert(type(rollingStockName) == "string", "Need 'rollingStockName' as string")
    if allRollingStock[rollingStockName] then
        ---@type RollingStock
        local rs = allRollingStock[rollingStockName]
        return rs
    else
        local o = RollingStock:new({rollingStockName = rollingStockName})
        allRollingStock[o.rollingStockName] = o
        RollingStockRegistry.rollingStockAppeared(o)
        return o
    end
end

---A train appeared on the map
---@param rollingStock RollingStock
function RollingStockRegistry.rollingStockAppeared(rollingStock)
    EventBroker.fire("ak.RollingStockEvent.rollingStockAppeared", rollingStock:toJsonStatic())
    EventBroker.fire("ak.RollingStockEvent.rollingStockInfoAppeared", rollingStock:toJsonDynamic())
end

---A train dissappeared from the map
---@param rollingStockName string
function RollingStockRegistry.rollingStockDisappeared(rollingStockName)
    EventBroker.fire("ak.RollingStockEvent.rollingStockDisappeared", {rollingStockName = rollingStockName})
end

return RollingStockRegistry
