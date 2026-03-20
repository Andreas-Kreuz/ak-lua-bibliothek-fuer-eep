insulate("ce.hub.data.switches.SwitchDataCollector", function ()
    local function clearModule(name) package.loaded[name] = nil end

    local originalGetSwitch = _G.EEPGetSwitch
    local originalSwitchGetTagText = _G.EEPSwitchGetTagText

    before_each(function ()
        clearModule("ce.hub.data.switches.SwitchDataCollector")

        local states = {
            [4] = {
                position = 2,
                tag = "West"
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

        _G.__switch_test_states = states
    end)

    after_each(function ()
        rawset(_G, "EEPGetSwitch", originalGetSwitch)
        rawset(_G, "EEPSwitchGetTagText", originalSwitchGetTagText)
        _G.__switch_test_states = nil
    end)

    it("collects initial switches by id and refreshes their fields", function ()
        local SwitchDataCollector = require("ce.hub.data.switches.SwitchDataCollector")

        local switches = SwitchDataCollector.collectInitialSwitches()
        SwitchDataCollector.refreshSwitches(switches)

        assert.same(1, #switches)
        assert.same({
            id = 4,
            position = 2,
            tag = "West"
        }, switches[1])
    end)
end)
