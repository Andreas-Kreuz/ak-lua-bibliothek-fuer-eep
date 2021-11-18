local EventBroker = require "ak.util.EventBroker"
local Train = require "ak.train.Train"
local RollingStockRegistry = require "ak.train.RollingStockRegistry"
local TrainRegistry = {}
local allTrains = {}

---Initialize the rolling stock of a newly found train
---@param train Train
local function initRollingStock(train)
    local count = train:getRollingStockCount()
    for i = 0, (count - 1) do
        local rollingStockName = EEPGetRollingstockItemName(train.name, i) -- EEP 13.2 Plug-In 2
        RollingStockRegistry.forName(rollingStockName)
    end
end

---Creates a train object for the given train name, the train must exist
---@param name string name of the train in EEP, e.g. "#Train 1"
---@return Train,boolean returns the train and the status if the train was newly created
function TrainRegistry.forName(name)
    assert(name, "Provide a name for the train")
    assert(type(name) == "string", "Need 'trainName' as string")
    if allTrains[name] then
        return allTrains[name], false
    else
        -- Initialize the train
        local train = Train:new({name = name})
        allTrains[train.name] = train
        initRollingStock(train)
        return train, true
    end
end

---A train appeared on the map
function TrainRegistry.trainAppeared(_)
    -- is included in "TrainRegistry.fireChangeTrainsEvent()"
    -- EventBroker.fireDataAdded("trains", "id", train:toJsonStatic())
    -- EventBroker.fireDataAdded("train-infos", "id", train:toJsonDynamic())
end

---A train dissappeared from the map
---@param trainName string
function TrainRegistry.trainDisappeared(trainName)
    allTrains[trainName] = nil
    EventBroker.fireDataRemoved("trains", "id", {id = trainName})
    EventBroker.fireDataRemoved("train-infos", "id", {id = trainName})
end

function TrainRegistry.fireChangeTrainsEvent()
    local modifiedTrains = {}
    for _, train in pairs(allTrains) do
        if train.valuesUpdated then
            modifiedTrains[train.id] = train
            train.valuesUpdated = false
        end
    end
    EventBroker.fireListChange("trains", "id", modifiedTrains)
end

return TrainRegistry
