if AkDebugLoad then print("[#Start] Loading ce.hub.data.slots.DataSlotsStatePublisher ...") end
local DataChangeBus = require("ce.hub.publish.DataChangeBus")
local DataSlotDtoFactory = require("ce.hub.data.slots.DataSlotDtoFactory")

local DataSlotsStatePublisher = {}
DataSlotsStatePublisher.name = "ce.hub.data.slots.DataSlotsStatePublisher"
local enabled = true
local initialized = false
local DataSlotNameResolver = require("ce.hub.data.slots.DataSlotNameResolver")
local StorageUtility = require("ce.hub.util.StorageUtility")
local lastSlots = {}

local function updateSlot(id, name, data)
    local oldSlot = lastSlots.id
    local newSlot = { id = id, name = name, data = data }
    if not oldSlot or oldSlot.id ~= id or oldSlot.name ~= name or oldSlot.data ~= data then lastSlots[id] = newSlot end
    return newSlot
end

function DataSlotsStatePublisher.initialize()
    initialized = true
    lastSlots = {}
end

function DataSlotsStatePublisher.syncState()
    -- nothing todo
    if not enabled then return end
    if not initialized then DataSlotsStatePublisher.initialize() end

    local filledSlots = {}
    local emptySlots = {}

    DataSlotNameResolver.updateSlotNames()
    for id = 1, 1000 do
        local hResult, data = EEPLoadData(id)
        if hResult then
            local name = DataSlotNameResolver.getSlotName(id) or StorageUtility.getName(id) or "?"
            local slot = updateSlot(id, name, data)
            filledSlots[id] = slot
            emptySlots[id] = nil
        else
            local slot = updateSlot(id)
            filledSlots[id] = nil
            emptySlots[id] = slot
        end
    end

    -- TODO Update on changes only
    DataChangeBus.fireListChange(DataSlotDtoFactory.createFilledDataSlotDtoList(filledSlots));
    DataChangeBus.fireListChange(DataSlotDtoFactory.createEmptyDataSlotDtoList(emptySlots));

    return {}
end

return DataSlotsStatePublisher
