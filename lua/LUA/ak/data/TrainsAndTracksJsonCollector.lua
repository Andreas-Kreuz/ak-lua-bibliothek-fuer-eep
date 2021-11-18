if AkDebugLoad then print("Loading ak.data.TrainsAndTracksJsonCollector ...") end
local TrainRegistry = require "ak.train.TrainRegistry"
local RollingStockRegistry = require "ak.train.RollingStockRegistry"

TrainsAndTracksJsonCollector = {}
local TrackCollector = require("ak.data.TrackCollector")

local enabled = true
local initialized = false
TrainsAndTracksJsonCollector.name = "ak.data.TrainsAndTracksJsonCollector"

local data = {}

local trackTypes = {"auxiliary", "control", "road", "rail", "tram"}
local trackCollectors = {}
do for _, trackType in ipairs(trackTypes) do trackCollectors[trackType] = TrackCollector:new(trackType) end end

local function initializeTracks() for _, trackType in ipairs(trackTypes) do trackCollectors[trackType]:initialize() end end

local function updateTracks()
    for _, trackType in ipairs(trackTypes) do
        local trainCollectorData = trackCollectors[trackType]:updateData()
        for key, value in pairs(trainCollectorData) do
            local newList = {}
            for _, o in pairs(value) do table.insert(newList, o) end
            data[key] = newList
        end
    end
end

function TrainsAndTracksJsonCollector.initialize()
    if not enabled or initialized then return end

    initializeTracks()

    initialized = true
end

function TrainsAndTracksJsonCollector.collectData()
    if not enabled then return end

    -- reset runtime data
    if not initialized then TrainsAndTracksJsonCollector.initialize() end

    updateTracks()

    TrainRegistry.fireChangeTrainsEvent()
    RollingStockRegistry.fireChangeRollingStockEvent()

    return data
end

return TrainsAndTracksJsonCollector
