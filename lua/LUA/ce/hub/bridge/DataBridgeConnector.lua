if AkDebugLoad then print("[#Start] Loading ce.hub.bridge.DataBridgeConnector ...") end
local StatePublisherRegistry = require("ce.hub.StatePublisherRegistry")
local DataBridgeConnector = {}

function DataBridgeConnector.registerStatePublishers(activeCollectors)
    local all = true
    if activeCollectors then
        if next(activeCollectors) ~= nil then -- not empty list
            all = false
        end
    end

    if all or activeCollectors["ce.hub.data.slots.DataSlotsStatePublisher"] then
        local dataSlotsStatePublisher = require("ce.hub.data.slots.DataSlotsStatePublisher")
        StatePublisherRegistry.registerStatePublishers(dataSlotsStatePublisher)
    end
    if all or activeCollectors["ce.hub.data.signals.SignalStatePublisher"] then
        local signalStatePublisher = require("ce.hub.data.signals.SignalStatePublisher")
        StatePublisherRegistry.registerStatePublishers(signalStatePublisher)
    end
    if all or activeCollectors["ce.hub.data.switches.SwitchStatePublisher"] then
        local switchStatePublisher = require("ce.hub.data.switches.SwitchStatePublisher")
        StatePublisherRegistry.registerStatePublishers(switchStatePublisher)
    end
    if all or activeCollectors["ce.hub.data.structures.StructureStatePublisher"] then
        local structureStatePublisher = require("ce.hub.data.structures.StructureStatePublisher")
        StatePublisherRegistry.registerStatePublishers(structureStatePublisher)
    end
    if all or activeCollectors["ce.hub.data.time.TimeStatePublisher"] then
        local timeStatePublisher = require("ce.hub.data.time.TimeStatePublisher")
        StatePublisherRegistry.registerStatePublishers(timeStatePublisher)
    end
    if all or activeCollectors["ce.hub.data.trains.TrainsAndTracksStatePublisher"] then
        local trainsAndTracksStatePublisher = require("ce.hub.data.trains.TrainsAndTracksStatePublisher")
        StatePublisherRegistry.registerStatePublishers(trainsAndTracksStatePublisher)
    end
end

return DataBridgeConnector
