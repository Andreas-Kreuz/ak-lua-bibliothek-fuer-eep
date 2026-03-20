if AkDebugLoad then print("[#Start] Loading ce.hub.data.trains.TrainsAndTracksStatePublisher ...") end
local TrainDetection = require("ce.hub.data.trains.TrainDetection")
local TrainRegistry = require("ce.hub.data.trains.TrainRegistry")
local RollingStockRegistry = require("ce.hub.data.rollingstock.RollingStockRegistry")

TrainsAndTracksStatePublisher = {}

local enabled = true
local initialized = false
TrainsAndTracksStatePublisher.name = "ce.hub.data.trains.TrainsAndTracksStatePublisher"

local data = {}

function TrainsAndTracksStatePublisher.initialize()
    if not enabled or initialized then return end
    TrainDetection.initialize()

    initialized = true
end

function TrainsAndTracksStatePublisher.syncState()
    if not enabled then return end

    if not initialized then TrainsAndTracksStatePublisher.initialize() end
    TrainDetection.update()

    TrainRegistry.fireChangeTrainsEvent()
    RollingStockRegistry.fireChangeRollingStockEvent()

    return data
end

return TrainsAndTracksStatePublisher
