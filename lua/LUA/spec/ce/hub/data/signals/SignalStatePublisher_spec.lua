insulate("ce.hub.data.signals.SignalStatePublisher", function ()
    local function clearModule(name) package.loaded[name] = nil end

    local originalGetSignal = _G.EEPGetSignal
    local originalSignalGetTagText = _G.EEPSignalGetTagText
    local originalGetSignalTrainsCount = _G.EEPGetSignalTrainsCount
    local originalGetSignalTrainName = _G.EEPGetSignalTrainName

    before_each(function ()
        clearModule("ce.hub.data.signals.SignalStatePublisher")
        clearModule("ce.hub.data.signals.SignalDataCollector")
        clearModule("ce.hub.data.signals.SignalDtoFactory")
        clearModule("ce.hub.publish.InternalDataStore")
        clearModule("ce.databridge.ServerEventBuffer")
        clearModule("ce.hub.publish.DataChangeBus")

        local states = {
            [9] = {
                position = 2,
                tag = "North",
                waitingCount = 1,
                vehicles = { "Train X" }
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

        _G.__signal_state_test_states = states
    end)

    after_each(function ()
        rawset(_G, "EEPGetSignal", originalGetSignal)
        rawset(_G, "EEPSignalGetTagText", originalSignalGetTagText)
        rawset(_G, "EEPGetSignalTrainsCount", originalGetSignalTrainsCount)
        rawset(_G, "EEPGetSignalTrainName", originalGetSignalTrainName)
        _G.__signal_state_test_states = nil
    end)

    it("fires both rooms with the existing wire format", function ()
        local SignalStatePublisher = require("ce.hub.data.signals.SignalStatePublisher")
        local DataStore = require("ce.hub.publish.InternalDataStore")

        SignalStatePublisher.initialize()
        SignalStatePublisher.syncState()

        assert.same({
            ["9"] = {
                id = 9,
                position = 2,
                tag = "North",
                waitingVehiclesCount = 1
            }
        }, DataStore.getRoom("signals"))
        assert.same({
            ["9-1"] = {
                id = "9-1",
                signalId = 9,
                waitingPosition = 1,
                vehicleName = "Train X",
                waitingCount = 1
            }
        }, DataStore.getRoom("waiting-on-signals"))
    end)
end)
