if AkDebugLoad then print("[#Start] Loading ak.data.DataWebConnector ...") end
local StatePublisherRegistry = require("ak.core.StatePublisherRegistry")
local DataWebConnector = {}

function DataWebConnector.registerStatePublishers(activeCollectors)
    local all = true
    if activeCollectors then
        if next(activeCollectors) ~= nil then -- not empty list
            all = false
        end
    end

    if all or activeCollectors["ak.data.DataSlotsStatePublisher"] then
        local dataSlotsStatePublisher = require("ak.data.DataSlotsStatePublisher")
        StatePublisherRegistry.registerStatePublishers(dataSlotsStatePublisher)
    end
    if all or activeCollectors["ak.data.SignalStatePublisher"] then
        local signalStatePublisher = require("ak.data.SignalStatePublisher")
        StatePublisherRegistry.registerStatePublishers(signalStatePublisher)
    end
    if all or activeCollectors["ak.data.SwitchStatePublisher"] then
        local switchStatePublisher = require("ak.data.SwitchStatePublisher")
        StatePublisherRegistry.registerStatePublishers(switchStatePublisher)
    end
    if all or activeCollectors["ak.data.StructureStatePublisher"] then
        local structureStatePublisher = require("ak.data.StructureStatePublisher")
        StatePublisherRegistry.registerStatePublishers(structureStatePublisher)
    end
    if all or activeCollectors["ak.data.TimeStatePublisher"] then
        local timeStatePublisher = require("ak.data.TimeStatePublisher")
        StatePublisherRegistry.registerStatePublishers(timeStatePublisher)
    end
    if all or activeCollectors["ak.data.TrainsAndTracksStatePublisher"] then
        local trainsAndTracksStatePublisher = require("ak.data.TrainsAndTracksStatePublisher")
        StatePublisherRegistry.registerStatePublishers(trainsAndTracksStatePublisher)
    end
end

return DataWebConnector
