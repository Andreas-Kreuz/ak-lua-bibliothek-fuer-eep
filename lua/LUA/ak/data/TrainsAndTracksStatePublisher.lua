if AkDebugLoad then print("[#Start] Loading ak.data.TrainsAndTracksStatePublisher ...") end
local TrainDetection = require("ak.data.TrainDetection")
local TrainRegistry = require("ak.train.TrainRegistry")
local RollingStockRegistry = require("ak.train.RollingStockRegistry")

TrainsAndTracksStatePublisher = {}

local enabled = true
local initialized = false
TrainsAndTracksStatePublisher.name = "ak.data.TrainsAndTracksStatePublisher"

local data = {}

function TrainsAndTracksStatePublisher.initialize()
    if not enabled or initialized then return end
    TrainDetection.initialize()

    initialized = true
end

function TrainsAndTracksStatePublisher.collectData()
    if not enabled then return end

    if not initialized then TrainsAndTracksStatePublisher.initialize() end
    TrainDetection.update()

    TrainRegistry.fireChangeTrainsEvent()
    RollingStockRegistry.fireChangeRollingStockEvent()

    return data
end

return TrainsAndTracksStatePublisher
