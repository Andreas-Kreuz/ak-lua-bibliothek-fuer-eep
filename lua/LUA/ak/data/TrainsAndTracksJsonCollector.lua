if AkDebugLoad then print("Loading ak.data.TrainsAndTracksJsonCollector ...") end
local TrainDetection = require("ak.data.TrainDetection")
local TrainRegistry = require("ak.train.TrainRegistry")
local RollingStockRegistry = require("ak.train.RollingStockRegistry")

TrainsAndTracksJsonCollector = {}

local enabled = true
local initialized = false
TrainsAndTracksJsonCollector.name = "ak.data.TrainsAndTracksJsonCollector"

local data = {}

function TrainsAndTracksJsonCollector.initialize()
    if not enabled or initialized then return end
    TrainDetection.initialize()

    initialized = true
end

function TrainsAndTracksJsonCollector.collectData()
    if not enabled then return end

    if not initialized then TrainsAndTracksJsonCollector.initialize() end
    TrainDetection.update()

    TrainRegistry.fireChangeTrainsEvent()
    RollingStockRegistry.fireChangeRollingStockEvent()

    return data
end

return TrainsAndTracksJsonCollector
