print("Loading ak.data.DataSlotsJsonCollector ...")

local DataSlotsJsonCollector = {}
local enabled = true
local initialized = false
local AkSlotNamesParser = require("ak.data.AkSlotNamesParser")
local StorageUtility = require("ak.storage.StorageUtility")
DataSlotsJsonCollector.name = "ak.data.DataSlotsJsonCollector"


function DataSlotsJsonCollector.initialize()
    initialized = true
end

function DataSlotsJsonCollector.collectData()
    -- nothing todo
    if not enabled then return end
    if not initialized then DataSlotsJsonCollector.initialize() end

    AkSlotNamesParser.updateSlotNames()
    local filledSlots = {}
    local emptySlots = {}
    for i = 1, 1000 do
        local hResult, saved = EEPLoadData(i)
        if hResult then
            local slotV1 = {
                id = i,
                name = AkSlotNamesParser.getSlotName(i) or StorageUtility.getName(i) or '?',
                data = saved,
            }
            table.insert(filledSlots, slotV1)
        else
            local slotV1 = {
                id = i,
            }
            table.insert(emptySlots, slotV1)
        end
    end

    return {
        ["save-slots"] = filledSlots,
        ["free-slots"] = emptySlots,
    }
end

return DataSlotsJsonCollector
