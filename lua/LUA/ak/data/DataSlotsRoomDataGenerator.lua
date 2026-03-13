if AkDebugLoad then print("[#Start] Loading ak.data.DataSlotsRoomDataGenerator ...") end

local TableUtils = require("ak.util.TableUtils")

local DataSlotsRoomDataGenerator = {}

function DataSlotsRoomDataGenerator.toRoomDataSlot(slot)
    return {
        id = slot.id,
        name = slot.name,
        data = slot.data
    }
end

function DataSlotsRoomDataGenerator.toRoomDataSlotList(slots)
    local roomDataSlots = {}

    for _, slot in pairs(slots) do table.insert(roomDataSlots, DataSlotsRoomDataGenerator.toRoomDataSlot(slot)) end

    return roomDataSlots
end

function DataSlotsRoomDataGenerator.toRoomDataFilledSlotList(filledSlots)
    return DataSlotsRoomDataGenerator.toRoomDataSlotList(TableUtils.valuesOfDict(filledSlots))
end

function DataSlotsRoomDataGenerator.toRoomDataEmptySlotList(emptySlots)
    return DataSlotsRoomDataGenerator.toRoomDataSlotList(TableUtils.valuesOfDict(emptySlots))
end

return DataSlotsRoomDataGenerator
