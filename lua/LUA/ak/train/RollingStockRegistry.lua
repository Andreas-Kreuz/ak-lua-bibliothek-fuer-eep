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
    EventBroker.fireDataChange("RollingStock Appeared", EventBroker.change.dataUpdated, "rolling-stocks", "id",
                               rollingStock:toJsonStatic())
    EventBroker.fireDataChange("RollingStockInfo Appeared", EventBroker.change.dataUpdated, "rollingStockInfo", "id",
                               rollingStock:toJsonDynamic())
end

---A train dissappeared from the map
---@param rollingStockName string
function RollingStockRegistry.rollingStockDisappeared(rollingStockName)
    local trackSystem = allRollingStock[rollingStockName].trackSystem;

    EventBroker.fireDataChange("RollingStock Disappeared", EventBroker.change.dataUpdated, "rolling-stocks", "id",
                               {id = rollingStockName})
    EventBroker.fireDataChange("RollingStockInfo Disappeared", EventBroker.change.dataUpdated, "rollingStockInfo",
                               "id", {id = rollingStockName})
end

return RollingStockRegistry
