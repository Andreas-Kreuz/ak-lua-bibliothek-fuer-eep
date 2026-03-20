if AkDebugLoad then print("[#Start] Loading ce.hub.data.slots.DataSlotDtoFactory ...") end

local TableUtils = require("ce.hub.util.TableUtils")

local DataSlotDtoFactory = {}

local KEY_ID = "id"
local FILLED_ROOM = "save-slots"
local EMPTY_ROOM = "free-slots"

local function toDataSlotDto(slot)
    return {
        id = slot.id,
        name = slot.name,
        data = slot.data
    }
end

local function createDataSlotDtoList(room, slots)
    local dataSlotDtos = {}

    for _, slot in pairs(slots) do
        local dto = toDataSlotDto(slot)
        table.insert(dataSlotDtos, dto)
    end

    return room, KEY_ID, dataSlotDtos
end

function DataSlotDtoFactory.createFilledDataSlotDto(slot)
    local dto = toDataSlotDto(slot)
    return FILLED_ROOM, KEY_ID, dto[KEY_ID], dto
end

function DataSlotDtoFactory.createFilledDataSlotDtoList(filledSlots)
    return createDataSlotDtoList(FILLED_ROOM, TableUtils.valuesOfDict(filledSlots))
end

function DataSlotDtoFactory.createEmptyDataSlotDto(slot)
    local dto = toDataSlotDto(slot)
    return EMPTY_ROOM, KEY_ID, dto[KEY_ID], dto
end

function DataSlotDtoFactory.createEmptyDataSlotDtoList(emptySlots)
    return createDataSlotDtoList(EMPTY_ROOM, TableUtils.valuesOfDict(emptySlots))
end

return DataSlotDtoFactory
