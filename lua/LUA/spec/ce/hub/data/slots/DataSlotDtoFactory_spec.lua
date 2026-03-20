insulate("ce.hub.data.slots.DataSlotDtoFactory", function ()
    local function clearModule(name) package.loaded[name] = nil end

    before_each(function ()
        clearModule("ce.hub.data.slots.DataSlotDtoFactory")
    end)

    it("projects slots to detached DTO tables with room metadata", function ()
        local DataSlotDtoFactory = require("ce.hub.data.slots.DataSlotDtoFactory")
        local slot = { id = 4, name = "Slot 4", data = "abc" }

        local filledRoom, filledKeyId, filledKey, filledDto = DataSlotDtoFactory.createFilledDataSlotDto(slot)
        local listRoom, listKeyId, filledDtos = DataSlotDtoFactory.createFilledDataSlotDtoList({ slot })
        local emptyRoom, emptyKeyId, emptyKey, emptyDto = DataSlotDtoFactory.createEmptyDataSlotDto(slot)
        slot.data = "changed"

        assert.equals("save-slots", filledRoom)
        assert.equals("id", filledKeyId)
        assert.equals(4, filledKey)
        assert.same({ id = 4, name = "Slot 4", data = "abc" }, filledDto)
        assert.equals("save-slots", listRoom)
        assert.equals("id", listKeyId)
        assert.same({ { id = 4, name = "Slot 4", data = "abc" } }, filledDtos)
        assert.equals("free-slots", emptyRoom)
        assert.equals("id", emptyKeyId)
        assert.equals(4, emptyKey)
        assert.same({ id = 4, name = "Slot 4", data = "abc" }, emptyDto)
    end)
end)
