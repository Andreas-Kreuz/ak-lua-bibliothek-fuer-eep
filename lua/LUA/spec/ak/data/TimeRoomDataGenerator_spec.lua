insulate("ak.data.TimeRoomDataGenerator", function ()
    local function clearModule(name) package.loaded[name] = nil end

    before_each(function ()
        clearModule("ak.data.TimeRoomDataGenerator")
    end)

    it("projects times to detached room data tables", function ()
        local TimeRoomDataGenerator = require("ak.data.TimeRoomDataGenerator")
        local timeData = {
            id = "times",
            name = "times",
            timeComplete = 3723,
            timeH = 1,
            timeM = 2,
            timeS = 3
        }

        local roomData = TimeRoomDataGenerator.toRoomDataTime(timeData)
        timeData.timeS = 9

        assert.same({
            id = "times",
            name = "times",
            timeComplete = 3723,
            timeH = 1,
            timeM = 2,
            timeS = 3
        }, roomData)
    end)
end)
