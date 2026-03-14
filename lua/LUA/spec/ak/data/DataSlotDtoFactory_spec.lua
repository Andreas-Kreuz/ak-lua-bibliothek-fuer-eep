insulate("ak.data.DataSlotDtoFactory", function ()
    local function clearModule(name) package.loaded[name] = nil end

    before_each(function ()
        clearModule("ak.data.DataSlotDtoFactory")
    end)

    it("projects slots to detached DTO tables", function ()
        local DataSlotDtoFactory = require("ak.data.DataSlotDtoFactory")
        local slot = { id = 4, name = "Slot 4", data = "abc" }

        local dataSlotDto = DataSlotDtoFactory.createDataSlotDto(slot)
        slot.data = "changed"

        assert.same({ id = 4, name = "Slot 4", data = "abc" }, dataSlotDto)
    end)
end)
