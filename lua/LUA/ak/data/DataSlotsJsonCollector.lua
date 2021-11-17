if AkDebugLoad then print("Loading ak.data.DataSlotsJsonCollector ...") end
local EventBroker = require "ak.util.EventBroker"

local DataSlotsJsonCollector = {}
DataSlotsJsonCollector.name = "ak.data.DataSlotsJsonCollector"
local enabled = true
local initialized = false
local AkSlotNamesParser = require("ak.data.AkSlotNamesParser")
local StorageUtility = require("ak.storage.StorageUtility")
local lastSlots = {}

local function toApiV1(id, name, data)
    local slotV1 = {id = id, name = name, data = data}
    return slotV1
end

local function updateSlot(id, name, data)
    local oldSlot = lastSlots.id
    if not oldSlot or oldSlot.id ~= id or oldSlot.name ~= name or oldSlot.data ~= data then
        -- local newSlot = toApiV1(id, name, data)
        -- if newSlot.data then
        --     EventBroker.fireDataChange(EventBroker.eventType.dataChanged, "save-slots", "id", newSlot)
        --     if oldSlot and not oldSlot.data then
        --         EventBroker.fireDataChange(EventBroker.eventType.dataRemoved, "free-slots", "id", {id = id})
        --     end
        -- else
        --     EventBroker.fireDataChange(EventBroker.eventType.dataChanged, "free-slots", "id", newSlot)
        --     if oldSlot and oldSlot.data then
        --         EventBroker.fireDataChange(EventBroker.eventType.dataRemoved, "save-slots", "id", {id = id})
        --     end
        -- end

        lastSlots.id = newSlot
    end
end

function DataSlotsJsonCollector.initialize()
    initialized = true
    lastSlots = {}
end

function DataSlotsJsonCollector.collectData()
    -- nothing todo
    if not enabled then return end
    if not initialized then DataSlotsJsonCollector.initialize() end

    AkSlotNamesParser.updateSlotNames()
    for id = 1, 1000 do
        local hResult, data = EEPLoadData(id)
        if hResult then
            local name = AkSlotNamesParser.getSlotName(id) or StorageUtility.getName(id) or "?"
            updateSlot(id, name, data)
        else
            updateSlot(id)
        end
    end

    return {} -- {["save-slots"] = filledSlots, ["free-slots"] = emptySlots}
end

return DataSlotsJsonCollector
