if AkDebugLoad then print("[#Start] Loading ak.data.StructureStatePublisher ...") end
local DataChangeBus = require("ak.events.DataChangeBus")
local StructureDataCollector = require("ak.data.StructureDataCollector")
local StructureRoomDataGenerator = require("ak.data.StructureRoomDataGenerator")
StructureStatePublisher = {}
local enabled = true
local initialized = false
StructureStatePublisher.name = "ak.data.StructureStatePublisher"

local structures = {}

function StructureStatePublisher.initialize()
    if not enabled or initialized then return end

    structures = StructureDataCollector.collectInitialStructures()
    DataChangeBus.fireListChange("structures", "id", StructureRoomDataGenerator.toRoomDataStructureList(structures))

    initialized = true
end

function StructureStatePublisher.syncState()
    if not enabled then return end

    if not initialized then StructureStatePublisher.initialize() end

    local dirtyStructures = StructureDataCollector.refreshDirtyStructures(structures)

    if #dirtyStructures > 0 then
        DataChangeBus.fireListChange("structures", "id",
                                     StructureRoomDataGenerator.toRoomDataStructureList(dirtyStructures))
    end

    return {}
end

return StructureStatePublisher
