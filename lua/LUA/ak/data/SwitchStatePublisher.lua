if AkDebugLoad then print("[#Start] Loading ak.data.SwitchStatePublisher ...") end
local DataChangeBus = require("ak.events.DataChangeBus")
require("ak.core.eep.EepFunctionWrapper")
SwitchStatePublisher = {}
local enabled = true
local initialized = false
SwitchStatePublisher.name = "ak.data.SwitchStatePublisher"

local MAX_SWITCHES = 1000
local switches = {}

function SwitchStatePublisher.initialize()
    if not enabled or initialized then return end

    for id = 1, MAX_SWITCHES do
        local val = EEPGetSwitch(id)
        if val > 0 then -- yes, this is a switch
            local switch = {}
            switch.id = id
            table.insert(switches, switch)
        end
    end

    initialized = true
end

function SwitchStatePublisher.syncState()
    if not enabled then return end

    if not initialized then SwitchStatePublisher.initialize() end

    for i = 1, #switches do
        local switch = switches[i]
        switch.position = EEPGetSwitch(switch.id)
        local _, tag = EEPSwitchGetTagText(switch.id)
        switch.tag = tag or ""
    end

    -- TODO: Send event only with detected changes
    DataChangeBus.fireListChange("switches", "id", switches)

    return {
        -- ["switches"] = switches
    }
end

return SwitchStatePublisher
