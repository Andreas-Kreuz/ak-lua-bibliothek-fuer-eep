insulate("ce.hub.data.switches.SwitchStatePublisher", function ()
    local function clearModule(name) package.loaded[name] = nil end

    local originalGetSwitch = _G.EEPGetSwitch
    local originalSwitchGetTagText = _G.EEPSwitchGetTagText

    before_each(function ()
        clearModule("ce.hub.data.switches.SwitchStatePublisher")
        clearModule("ce.hub.data.switches.SwitchDataCollector")
        clearModule("ce.hub.data.switches.SwitchDtoFactory")
        clearModule("ce.hub.publish.InternalDataStore")
        clearModule("ce.databridge.ServerEventBuffer")
        clearModule("ce.hub.publish.DataChangeBus")

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
        local SwitchStatePublisher = require("ce.hub.data.switches.SwitchStatePublisher")
        local DataStore = require("ce.hub.publish.InternalDataStore")

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
