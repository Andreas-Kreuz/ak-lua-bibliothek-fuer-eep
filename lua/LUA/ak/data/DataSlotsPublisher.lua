print("Lade ak.data.DataSlotsPublisher ...")

local DataSlotsPublisher = {}
local enabled = true
local initialized = false
local AkSlotNamesParser = require("ak.data.AkSlotNamesParser")
local AkSpeicherHilfe = require("ak.speicher.AkSpeicher")
local AkStatistik = require("ak.io.AkStatistik")
DataSlotsPublisher.name = "ak.data.DataSlotsPublisher"


function DataSlotsPublisher.initialize()
    initialized = true
end

function DataSlotsPublisher.updateData()
    -- nothing todo
    if not enabled then return end
    if not initialized then DataSlotsPublisher.initialize() end

    AkSlotNamesParser.updateSlotNames()
    local filledSlots = {}
    local emptySlots = {}
    for i = 1, 1000 do
        local hResult, saved = EEPLoadData(i)
        if hResult then
            local slotV1 = {
                id = i,
                name = AkSlotNamesParser.getSlotName(i) or AkSpeicherHilfe.getName(i) or '?',
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

    AkStatistik.writeLater("save-slots", filledSlots)
    AkStatistik.writeLater("free-slots", emptySlots) -- you may want to omit free slots to save space
end

return DataSlotsPublisher