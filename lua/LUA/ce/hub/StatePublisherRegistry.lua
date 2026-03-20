if AkDebugLoad then print("[#Start] Loading ce.hub.StatePublisherRegistry ...") end

local StatePublisherRegistry = {}
local registeredStatePublishers = {}
local statePublisherNames = {}

local function removeStatePublisherName(name)
    for i, currentName in ipairs(statePublisherNames) do
        if currentName == name then
            table.remove(statePublisherNames, i)
            return
        end
    end
end

local function assertValidStatePublisher(statePublisher)
    assert(statePublisher.name and type(statePublisher.name) == "string",
           "The name of the statePublisher must be defined and is has to be a string")
    assert(statePublisher.initialize and type(statePublisher.initialize) == "function",
           string.format("statePublisher %s must have a function initialize()", statePublisher.name))
    assert(statePublisher.syncState and type(statePublisher.syncState) == "function",
           string.format("statePublisher %s must have a function syncState()", statePublisher.name))
end

function StatePublisherRegistry.registerStatePublishers(...)
    for _, statePublisher in ipairs({ ... }) do
        assertValidStatePublisher(statePublisher)
        if not registeredStatePublishers[statePublisher.name] then
            table.insert(statePublisherNames, statePublisher.name)
        end
        registeredStatePublishers[statePublisher.name] = statePublisher
    end

    return registeredStatePublishers
end

function StatePublisherRegistry.unregisterStatePublishers(...)
    for _, statePublisher in ipairs({ ... }) do
        assert(statePublisher.name and type(statePublisher.name) == "string",
               "The name of the statePublisher must be defined and is has to be a string")
        registeredStatePublishers[statePublisher.name] = nil
        removeStatePublisherName(statePublisher.name)
    end
end

function StatePublisherRegistry.getStatePublishers()
    local copy = {}
    for _, statePublisherName in ipairs(statePublisherNames) do
        table.insert(copy, registeredStatePublishers[statePublisherName])
    end
    return copy
end

return StatePublisherRegistry
