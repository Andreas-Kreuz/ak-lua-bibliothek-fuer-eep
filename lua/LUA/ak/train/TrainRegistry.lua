local EventBroker = require "ak.util.EventBroker"
local json = require "ak.io.json"
local Train = require "ak.train.Train"
local TrainRegistry = {}
local allTrains = {}

---Creates a train object for the given train name, the train must exist
---@param name string name of the train in EEP, e.g. "#Train 1"
---@return Train
function TrainRegistry.forName(name)
    assert(name, "Provide a name for the train")
    assert(type(name) == "string", "Need 'trainName' as string")
    if allTrains[name] then
        return allTrains[name]
    else
        local o = Train:new({name = name})
        allTrains[o.name] = o
        TrainRegistry.trainAppeared(o)
        return o
    end
end

---A train appeared on the map
---@param train Train
function TrainRegistry.trainAppeared(train) EventBroker.fire("ak.TrainEvent.trainAppeared", json.encode(train)) end

---A train dissappeared from the map
---@param trainName string
function TrainRegistry.trainDisappeared(trainName)
    allTrains[trainName] = nil
    EventBroker.fire("ak.TrainEvent.trainDisappeared", json.encode({trainName = trainName}))
end

return TrainRegistry
