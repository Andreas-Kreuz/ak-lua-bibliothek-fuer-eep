print("Loading ak.data.AkDataSlots")

local AkSlotNamesParser = require("ak.data.AkSlotNamesParser")
local AkSpeicherHilfe = require("ak.speicher.AkSpeicher")
local AkDataSlots = {}

function AkDataSlots.fillApiV1()
    AkSlotNamesParser.updateSlotNames()
    local dataSlots = {}
    for i = 1, 1000 do
        local hResult, saved = EEPLoadData(i)
        if hResult then
            local slotV1 = {
                id = i,
                name = AkSlotNamesParser.getSlotName(i) or AkSpeicherHilfe.getName(i) or '?',
                data = saved,
            }
            table.insert(dataSlots, slotV1)
        end
    end
    return dataSlots
end

function AkDataSlots.fillFreeSlotsApiV1()
    AkSlotNamesParser.updateSlotNames()
    local dataSlots = {}
    for i = 1, 1000 do
        local hResult = EEPLoadData(i)
        if not hResult then
            local slotV1 = {
                id = i,
            }
            table.insert(dataSlots, slotV1)
        end
    end
    return dataSlots
end

return AkDataSlots