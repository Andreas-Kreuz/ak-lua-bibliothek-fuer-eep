insulate("ak.data.TimeStatePublisher", function ()
    local function clearModule(name) package.loaded[name] = nil end

    local originalEEPTime = _G.EEPTime
    local originalEEPTimeH = _G.EEPTimeH
    local originalEEPTimeM = _G.EEPTimeM
    local originalEEPTimeS = _G.EEPTimeS

    before_each(function ()
        clearModule("ak.data.TimeStatePublisher")
        clearModule("ak.data.TimeDtoFactory")
        clearModule("ak.data.DataStore")
        clearModule("ak.io.ServerEventBuffer")
        clearModule("ak.events.DataChangeBus")

        _G.EEPTime = 3723
        _G.EEPTimeH = 1
        _G.EEPTimeM = 2
        _G.EEPTimeS = 3
    end)

    after_each(function ()
        _G.EEPTime = originalEEPTime
        _G.EEPTimeH = originalEEPTimeH
        _G.EEPTimeM = originalEEPTimeM
        _G.EEPTimeS = originalEEPTimeS
    end)

    it("fires times with the existing wire format", function ()
        local TimeStatePublisher = require("ak.data.TimeStatePublisher")
        local DataStore = require("ak.data.DataStore")

        TimeStatePublisher.initialize()
        TimeStatePublisher.syncState()

        assert.same({
            times = {
                id = "times",
                name = "times",
                timeComplete = 3723,
                timeH = 1,
                timeM = 2,
                timeS = 3
            }
        }, DataStore.getRoom("times"))
    end)
end)
