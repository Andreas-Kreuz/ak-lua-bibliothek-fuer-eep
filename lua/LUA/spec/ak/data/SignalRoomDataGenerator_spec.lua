insulate("ak.data.SignalRoomDataGenerator", function ()
    local function clearModule(name) package.loaded[name] = nil end

    before_each(function ()
        clearModule("ak.data.SignalRoomDataGenerator")
    end)

    it("projects signals and waiting entries to detached room data tables", function ()
        local SignalRoomDataGenerator = require("ak.data.SignalRoomDataGenerator")
        local signal = { id = 7, position = 1, tag = "Stop", waitingVehiclesCount = 3 }
        local waiting = { id = "7-1", signalId = 7, waitingPosition = 1, vehicleName = "Bus 1", waitingCount = 3 }

        local roomDataSignal = SignalRoomDataGenerator.toRoomDataSignal(signal)
        local roomDataWaiting = SignalRoomDataGenerator.toRoomDataWaitingOnSignal(waiting)

        signal.tag = "Changed"
        waiting.vehicleName = "Changed"

        assert.same({ id = 7, position = 1, tag = "Stop", waitingVehiclesCount = 3 }, roomDataSignal)
        assert.same({ id = "7-1", signalId = 7, waitingPosition = 1, vehicleName = "Bus 1", waitingCount = 3 },
                    roomDataWaiting)
    end)
end)
