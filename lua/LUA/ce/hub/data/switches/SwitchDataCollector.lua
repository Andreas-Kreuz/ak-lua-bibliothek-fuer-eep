if AkDebugLoad then print("[#Start] Loading ce.hub.data.switches.SwitchDataCollector ...") end

local SwitchDataCollector = {}

local MAX_SWITCHES = 1000

local EEPGetSwitch = _G.EEPGetSwitch or function () end
local EEPSwitchGetTagText = _G.EEPSwitchGetTagText or function () end

function SwitchDataCollector.collectInitialSwitches()
    local switches = {}

    for id = 1, MAX_SWITCHES do
        local val = EEPGetSwitch(id)
        if val > 0 then table.insert(switches, { id = id }) end
    end

    return switches
end

function SwitchDataCollector.refreshSwitches(switches)
    for i = 1, #switches do
        local switch = switches[i]
        switch.position = EEPGetSwitch(switch.id)
        local _, tag = EEPSwitchGetTagText(switch.id)
        switch.tag = tag or ""
    end
end

return SwitchDataCollector
