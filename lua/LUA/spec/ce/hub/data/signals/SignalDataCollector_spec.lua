insulate("ce.hub.data.signals.SignalDataCollector", function ()
    local function clearModule(name) package.loaded[name] = nil end

    local originalGetSignal = _G.EEPGetSignal
    local originalSignalGetTagText = _G.EEPSignalGetTagText
    local originalGetSignalTrainsCount = _G.EEPGetSignalTrainsCount
    local originalGetSignalTrainName = _G.EEPGetSignalTrainName

    before_each(function ()
        clearModule("ce.hub.data.signals.SignalDataCollector")

        local states = {
            [5] = {
                position = 2,
                tag = "Entry",
                waitingCount = 2,
                vehicles = { "Train A", "Train B" }
            }
        }

        rawset(_G, "EEPGetSignal", function (id)
            local entry = states[id]
            if not entry then return 0 end
            return entry.position
        end)
        rawset(_G, "EEPSignalGetTagText", function (id)
            local entry = states[id]
            if not entry then return false, nil end
            return true, entry.tag
        end)
        rawset(_G, "EEPGetSignalTrainsCount", function (id)
            local entry = states[id]
            if not entry then return nil end
            return entry.waitingCount
        end)
        rawset(_G, "EEPGetSignalTrainName", function (id, position)
            local entry = states[id]
            if not entry then return nil end
            return entry.vehicles[position]
        end)

        _G.__signal_test_states = states
    end)

    after_each(function ()
        rawset(_G, "EEPGetSignal", originalGetSignal)
        rawset(_G, "EEPSignalGetTagText", originalSignalGetTagText)
        rawset(_G, "EEPGetSignalTrainsCount", originalGetSignalTrainsCount)
        rawset(_G, "EEPGetSignalTrainName", originalGetSignalTrainName)
        _G.__signal_test_states = nil
    end)

    it("collects initial signals by id", function ()
        local SignalDataCollector = require("ce.hub.data.signals.SignalDataCollector")

        local signals = SignalDataCollector.collectInitialSignals()

        assert.same(1, #signals)
        assert.same({ id = 5 }, signals[1])
    end)

    it("refreshes signal fields and derives waiting vehicles", function ()
        local SignalDataCollector = require("ce.hub.data.signals.SignalDataCollector")

        local signals = SignalDataCollector.collectInitialSignals()
        SignalDataCollector.refreshSignals(signals)
        local waitingOnSignals = SignalDataCollector.collectWaitingOnSignals(signals)

        assert.same({
            id = 5,
            position = 2,
            tag = "Entry",
            waitingVehiclesCount = 2
        }, signals[1])
        assert.same({
            {
                id = "5-1",
                signalId = 5,
                waitingPosition = 1,
                vehicleName = "Train A",
                waitingCount = 2
            },
            {
                id = "5-2",
                signalId = 5,
                waitingPosition = 2,
                vehicleName = "Train B",
                waitingCount = 2
            }
        }, waitingOnSignals)
    end)
end)
