insulate("ak.data.TimeDtoFactory", function ()
    local function clearModule(name) package.loaded[name] = nil end

    before_each(function ()
        clearModule("ak.data.TimeDtoFactory")
    end)

    it("projects times to detached DTO tables", function ()
        local TimeDtoFactory = require("ak.data.TimeDtoFactory")
        local timeData = {
            id = "times",
            name = "times",
            timeComplete = 3723,
            timeH = 1,
            timeM = 2,
            timeS = 3
        }

        local timeDto = TimeDtoFactory.createTimeDto(timeData)
        timeData.timeS = 9

        assert.same({
            id = "times",
            name = "times",
            timeComplete = 3723,
            timeH = 1,
            timeM = 2,
            timeS = 3
        }, timeDto)
    end)
end)
