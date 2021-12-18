local EventBroker = require("ak.util.EventBroker")
local Train = require("ak.train.Train")
local RollingStockRegistry = require("ak.train.RollingStockRegistry")

local TrainRegistry = {}
TrainRegistry.debug = false
---@type table<string, Train>
local allTrains = {}
---@type table<string,table<string,string>> table of trainName -> index(string) -> rollingstockname
local trainRollingStockNames = {}

---Initialize the rolling stock of a newly found train
---@param train Train
function TrainRegistry.initRollingStock(train)
    trainRollingStockNames[train.name] = {}
    local count = EEPGetRollingstockItemsCount(train.name)
    train:setRollingStockCount(count)
    for i = 0, (count - 1) do
        local rollingStockName = EEPGetRollingstockItemName(train.name, i) -- EEP 13.2 Plug-In 2
        RollingStockRegistry.forName(rollingStockName)
        trainRollingStockNames[train.name][tostring(i)] = rollingStockName
    end
end

---Get the name of a rolling stock in a train (was initialized by initRollingStock)
---@param name string name of a train
---@param index number index of the rollingStock in the train
---@return string name of the rollingStock or nil
function TrainRegistry.rollingStockNameInTrain(name, index)
    return trainRollingStockNames[name] and trainRollingStockNames[name][tostring(index)] or nil
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
        TrainRegistry.initRollingStock(train)
        return train, true
    end
end

---A train appeared on the map
---@param train Train
function TrainRegistry.trainAppeared(train)
    if TrainRegistry.debug then
        print(string.format("[TrainRegistry] train created: %s (%s)", train:getName(), train:getTrackType()))
    end
    -- is included in "TrainRegistry.fireChangeTrainsEvent()"
    -- EventBroker.fireDataAdded("trains", "id", train:toJsonStatic())
end

---A train dissappeared from the map
---@param trainName string
function TrainRegistry.trainDisappeared(trainName)
    if TrainRegistry.debug then print(string.format("[TrainRegistry] train removed: %s", trainName)) end
    allTrains[trainName] = nil
    EventBroker.fireDataRemoved("trains", "id", {id = trainName})
end

function TrainRegistry.fireChangeTrainsEvent()
    local modifiedTrains = {}
    for _, train in pairs(allTrains) do
        if train.valuesUpdated then
            modifiedTrains[train.id] = train:toJsonStatic()
            train.valuesUpdated = false
        end
    end
    EventBroker.fireListChange("trains", "id", modifiedTrains)
end

function TrainRegistry.getAllTrainNames()
    local names = {}
    for trainName in pairs(allTrains) do names[trainName] = true end
    return names
end

return TrainRegistry
