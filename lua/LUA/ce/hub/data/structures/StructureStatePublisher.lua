if AkDebugLoad then print("[#Start] Loading ce.hub.data.structures.StructureStatePublisher ...") end
local DataChangeBus = require("ce.hub.publish.DataChangeBus")
local StructureDataCollector = require("ce.hub.data.structures.StructureDataCollector")
local StructureDtoFactory = require("ce.hub.data.structures.StructureDtoFactory")
StructureStatePublisher = {}
local enabled = true
local initialized = false
StructureStatePublisher.name = "ce.hub.data.structures.StructureStatePublisher"

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
