if AkDebugLoad then print("[#Start] Loading ce.hub.data.runtime.RuntimeStatePublisher ...") end
local DataChangeBus = require("ce.hub.publish.DataChangeBus")
local RuntimeDataCollector = require("ce.hub.data.runtime.RuntimeDataCollector")
local RuntimeDtoFactory = require("ce.hub.data.runtime.RuntimeDtoFactory")

RuntimeStatePublisher = {}
local enabled = true
local initialized = false
RuntimeStatePublisher.name = "ce.hub.data.runtime.RuntimeStatePublisher"

function RuntimeStatePublisher.initialize()
    if not enabled or initialized then return end

    initialized = true
end

function RuntimeStatePublisher.syncState()
    if not enabled then return end
    if not initialized then RuntimeStatePublisher.initialize() end

    local runtimeEntries = RuntimeDataCollector.collectRuntimeEntries()
    if not runtimeEntries then return {} end

    DataChangeBus.fireListChange(RuntimeDtoFactory.createRuntimeDtoList(runtimeEntries))
    return {}
end

return RuntimeStatePublisher
