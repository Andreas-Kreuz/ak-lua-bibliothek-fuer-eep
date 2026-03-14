if AkDebugLoad then print("[#Start] Loading ak.data.StructureStatePublisher ...") end
local DataChangeBus = require("ak.events.DataChangeBus")
local StructureDataCollector = require("ak.data.StructureDataCollector")
local StructureDtoFactory = require("ak.data.StructureDtoFactory")
StructureStatePublisher = {}
local enabled = true
local initialized = false
StructureStatePublisher.name = "ak.data.StructureStatePublisher"

local structures = {}

function StructureStatePublisher.initialize()
    if not enabled or initialized then return end

    structures = StructureDataCollector.collectInitialStructures()
    DataChangeBus.fireListChange(StructureDtoFactory.createStructureDtoList(structures))

    initialized = true
end

function StructureStatePublisher.syncState()
    if not enabled then return end

    if not initialized then StructureStatePublisher.initialize() end

    local dirtyStructures = StructureDataCollector.refreshDirtyStructures(structures)

    if #dirtyStructures > 0 then
        DataChangeBus.fireListChange(StructureDtoFactory.createStructureDtoList(dirtyStructures))
    end

    return {}
end

return StructureStatePublisher
