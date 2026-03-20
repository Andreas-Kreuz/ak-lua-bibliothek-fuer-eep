insulate("ce.hub.data.time.TimeDtoFactory", function ()
    local function clearModule(name) package.loaded[name] = nil end

    before_each(function ()
        clearModule("ce.hub.data.time.TimeDtoFactory")
    end)

    it("projects times to detached DTO tables", function ()
        local TimeDtoFactory = require("ce.hub.data.time.TimeDtoFactory")
        local timeData = {
            id = "times",
            name = "times",
            timeComplete = 3723,
            timeH = 1,
            timeM = 2,
            timeS = 3
        }

        local room, keyId, key, timeDto = TimeDtoFactory.createTimeDto(timeData)
        local listRoom, listKeyId, timeDtos = TimeDtoFactory.createTimeDtoList({ timeData })
        timeData.timeS = 9

        assert.equals("times", room)
        assert.equals("id", keyId)
        assert.equals("times", key)
        assert.same({
            id = "times",
            name = "times",
            timeComplete = 3723,
            timeH = 1,
            timeM = 2,
            timeS = 3
        }, timeDto)
        assert.equals("times", listRoom)
        assert.equals("id", listKeyId)
        assert.same({ {
            id = "times",
            name = "times",
            timeComplete = 3723,
            timeH = 1,
            timeM = 2,
            timeS = 3
        } }, timeDtos)
    end)
end)
