local DataChangeBus = require("ce.hub.publish.DataChangeBus")
local RollingStock = require("ce.hub.data.rollingstock.RollingStock")
local RollingStockDtoFactory = require("ce.hub.data.rollingstock.RollingStockDtoFactory")
local RollingStockRegistry = {}
---@type table<string,RollingStock>
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
        ---@diagnostic disable-next-line: missing-fields
        local o = RollingStock:new({ rollingStockName = rollingStockName })
        allRollingStock[o.rollingStockName] = o
        RollingStockRegistry.rollingStockAppeared(o)
        return o
    end
end

---A train appeared on the map
function RollingStockRegistry.rollingStockAppeared(_)
    -- is included in "TrainRegistry.fireChangeTrainsEvent()"
    -- DataChangeBus.fireDataChanged("rolling-stocks", "id", rollingStock:toJsonStatic())
end

---A train dissappeared from the map
---@param rollingStockName string
function RollingStockRegistry.rollingStockDisappeared(rollingStockName)
    allRollingStock[rollingStockName] = nil
    DataChangeBus.fireDataRemoved(RollingStockDtoFactory.createRollingStockReferenceDto(rollingStockName))
end

function RollingStockRegistry.fireChangeRollingStockEvent()
    local modifiedRollingStock = {}
    for _, rs in pairs(allRollingStock) do
        if rs.valuesUpdated then
            modifiedRollingStock[rs.id] = rs
            rs.valuesUpdated = false
        end
    end
    DataChangeBus.fireListChange(RollingStockDtoFactory.createRollingStockDtoList(modifiedRollingStock))
end

return RollingStockRegistry

