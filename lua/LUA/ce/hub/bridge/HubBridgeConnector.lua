if AkDebugLoad then print("[#Start] Loading ce.hub.bridge.HubBridgeConnector ...") end
local HubBridgeConnector = {}
local StatePublisherRegistry = require("ce.hub.StatePublisherRegistry")
local activeCollectors = {}

function HubBridgeConnector.setActiveCollectors(list)
    local lookup = {}
    for _, v in pairs(list) do lookup[v] = true end
    activeCollectors = lookup
end

function HubBridgeConnector.registerStatePublishers()
    -- Core publishers
    local ModuleRegistry = require("ce.hub.ModuleRegistry")
    local ModulesDataCollector = require("ce.hub.data.modules.ModulesDataCollector")
    local ModulesStatePublisher = require("ce.hub.data.modules.ModulesStatePublisher")
    local RuntimeStatePublisher = require("ce.hub.data.runtime.RuntimeStatePublisher")
    local VersionStatePublisher = require("ce.hub.data.version.VersionStatePublisher")
    ModulesDataCollector.setRegisteredCeModules(ModuleRegistry.getRegisteredCeModules())
    StatePublisherRegistry.registerStatePublishers(ModulesStatePublisher, VersionStatePublisher, RuntimeStatePublisher)

    -- Data publishers
    local all = next(activeCollectors) == nil
    if all or activeCollectors["ce.hub.data.slots.DataSlotsStatePublisher"] then
        StatePublisherRegistry.registerStatePublishers(require("ce.hub.data.slots.DataSlotsStatePublisher"))
    end
    if all or activeCollectors["ce.hub.data.signals.SignalStatePublisher"] then
        StatePublisherRegistry.registerStatePublishers(require("ce.hub.data.signals.SignalStatePublisher"))
    end
    if all or activeCollectors["ce.hub.data.switches.SwitchStatePublisher"] then
        StatePublisherRegistry.registerStatePublishers(require("ce.hub.data.switches.SwitchStatePublisher"))
    end
    if all or activeCollectors["ce.hub.data.structures.StructureStatePublisher"] then
        StatePublisherRegistry.registerStatePublishers(require("ce.hub.data.structures.StructureStatePublisher"))
    end
    if all or activeCollectors["ce.hub.data.time.TimeStatePublisher"] then
        StatePublisherRegistry.registerStatePublishers(require("ce.hub.data.time.TimeStatePublisher"))
    end
    if all or activeCollectors["ce.hub.data.trains.TrainsAndTracksStatePublisher"] then
        StatePublisherRegistry.registerStatePublishers(require("ce.hub.data.trains.TrainsAndTracksStatePublisher"))
    end
end

return HubBridgeConnector
