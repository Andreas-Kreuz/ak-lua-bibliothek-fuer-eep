insulate("ak.data.SwitchStatePublisher", function ()
    local function clearModule(name) package.loaded[name] = nil end

    local originalGetSwitch = _G.EEPGetSwitch
    local originalSwitchGetTagText = _G.EEPSwitchGetTagText

    before_each(function ()
        clearModule("ak.data.SwitchStatePublisher")
        clearModule("ak.data.SwitchDataCollector")
        clearModule("ak.data.SwitchRoomDataGenerator")
        clearModule("ak.data.DataStore")
        clearModule("ak.io.ServerEventBuffer")
        clearModule("ak.events.DataChangeBus")

        local states = {
            [8] = {
                position = 2,
                tag = "South"
            }
        }

        rawset(_G, "EEPGetSwitch", function (id)
            local entry = states[id]
            if not entry then return 0 end
            return entry.position
        end)
        rawset(_G, "EEPSwitchGetTagText", function (id)
            local entry = states[id]
            if not entry then return false, nil end
            return true, entry.tag
        end)

        _G.__switch_state_test_states = states
    end)

    after_each(function ()
        rawset(_G, "EEPGetSwitch", originalGetSwitch)
        rawset(_G, "EEPSwitchGetTagText", originalSwitchGetTagText)
        _G.__switch_state_test_states = nil
    end)

    it("fires switches with the existing wire format", function ()
        local SwitchStatePublisher = require("ak.data.SwitchStatePublisher")
        local DataStore = require("ak.data.DataStore")

        SwitchStatePublisher.initialize()
        SwitchStatePublisher.syncState()

        assert.same({
            ["8"] = {
                id = 8,
                position = 2,
                tag = "South"
            }
        }, DataStore.getRoom("switches"))
    end)
end)
