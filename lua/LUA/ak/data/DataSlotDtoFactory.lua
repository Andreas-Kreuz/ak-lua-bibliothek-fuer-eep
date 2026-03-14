if AkDebugLoad then print("[#Start] Loading ak.data.DataSlotDtoFactory ...") end

local TableUtils = require("ak.util.TableUtils")

local DataSlotDtoFactory = {}

function DataSlotDtoFactory.createDataSlotDto(slot)
    return {
        id = slot.id,
        name = slot.name,
        data = slot.data
    }
end

function DataSlotDtoFactory.createDataSlotDtoList(slots)
    local dataSlotDtos = {}

    for _, slot in pairs(slots) do table.insert(dataSlotDtos, DataSlotDtoFactory.createDataSlotDto(slot)) end

    return dataSlotDtos
end

function DataSlotDtoFactory.createFilledDataSlotDtoList(filledSlots)
    return DataSlotDtoFactory.createDataSlotDtoList(TableUtils.valuesOfDict(filledSlots))
end

function DataSlotDtoFactory.createEmptyDataSlotDtoList(emptySlots)
    return DataSlotDtoFactory.createDataSlotDtoList(TableUtils.valuesOfDict(emptySlots))
end

return DataSlotDtoFactory
