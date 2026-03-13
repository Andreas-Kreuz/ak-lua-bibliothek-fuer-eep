insulate("ak.data.DataSlotsRoomDataGenerator", function ()
    local function clearModule(name) package.loaded[name] = nil end

    before_each(function ()
        clearModule("ak.data.DataSlotsRoomDataGenerator")
    end)

    it("projects slots to detached room data tables", function ()
        local DataSlotsRoomDataGenerator = require("ak.data.DataSlotsRoomDataGenerator")
        local slot = { id = 4, name = "Slot 4", data = "abc" }

        local roomData = DataSlotsRoomDataGenerator.toRoomDataSlot(slot)
        slot.data = "changed"

        assert.same({ id = 4, name = "Slot 4", data = "abc" }, roomData)
    end)
end)
