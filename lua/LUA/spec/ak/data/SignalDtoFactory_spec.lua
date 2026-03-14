insulate("ak.data.SignalDtoFactory", function ()
    local function clearModule(name) package.loaded[name] = nil end

    before_each(function ()
        clearModule("ak.data.SignalDtoFactory")
    end)

    it("projects signals and waiting entries to detached DTO tables", function ()
        local SignalDtoFactory = require("ak.data.SignalDtoFactory")
        local signal = { id = 7, position = 1, tag = "Stop", waitingVehiclesCount = 3 }
        local waiting = { id = "7-1", signalId = 7, waitingPosition = 1, vehicleName = "Bus 1", waitingCount = 3 }

        local signalDto = SignalDtoFactory.createSignalDto(signal)
        local waitingDto = SignalDtoFactory.createWaitingOnSignalDto(waiting)

        signal.tag = "Changed"
        waiting.vehicleName = "Changed"

        assert.same({ id = 7, position = 1, tag = "Stop", waitingVehiclesCount = 3 }, signalDto)
        assert.same({ id = "7-1", signalId = 7, waitingPosition = 1, vehicleName = "Bus 1", waitingCount = 3 },
                    waitingDto)
    end)
end)
