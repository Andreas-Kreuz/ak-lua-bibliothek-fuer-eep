local TableUtils = require("ak.util.TableUtils")
if AkDebugLoad then print("Loading ak.data.DataSlotsJsonCollector ...") end
local EventBroker = require("ak.util.EventBroker")

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
    local newSlot = toApiV1(id, name, data)
    if not oldSlot or oldSlot.id ~= id or oldSlot.name ~= name or oldSlot.data ~= data then lastSlots[id] = newSlot end
    return newSlot
end

function DataSlotsJsonCollector.initialize()
    initialized = true
    lastSlots = {}
end

function DataSlotsJsonCollector.collectData()
    -- nothing todo
    if not enabled then return end
    if not initialized then DataSlotsJsonCollector.initialize() end

    local filledSlots = {}
    local emptySlots = {}

    AkSlotNamesParser.updateSlotNames()
    for id = 1, 1000 do
        local hResult, data = EEPLoadData(id)
        if hResult then
            local name = AkSlotNamesParser.getSlotName(id) or StorageUtility.getName(id) or "?"
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
    EventBroker.fireListChange("save-slots", "id", TableUtils.valuesOfDict(filledSlots));
    EventBroker.fireListChange("free-slots", "id", TableUtils.valuesOfDict(emptySlots));

    return {} -- {["save-slots"] = filledSlots, ["free-slots"] = emptySlots}
end

return DataSlotsJsonCollector
