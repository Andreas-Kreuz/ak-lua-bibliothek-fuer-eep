insulate("ak.data.SwitchRoomDataGenerator", function ()
    local function clearModule(name) package.loaded[name] = nil end

    before_each(function ()
        clearModule("ak.data.SwitchRoomDataGenerator")
    end)

    it("projects switches to detached room data tables", function ()
        local SwitchRoomDataGenerator = require("ak.data.SwitchRoomDataGenerator")
        local switch = { id = 11, position = 1, tag = "Main" }

        local roomData = SwitchRoomDataGenerator.toRoomDataSwitch(switch)
        switch.tag = "Changed"

        assert.same({ id = 11, position = 1, tag = "Main" }, roomData)
    end)
end)
