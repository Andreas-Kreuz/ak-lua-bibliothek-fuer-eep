print"Lade ak.data.SwitchPublisher ..."
SwitchPublisher = {}
local AkStatistik = require("ak.io.AkStatistik")
local enabled = true
local initialized = false
SwitchPublisher.name = "ak.data.SwitchPublisher"


local MAX_SWITCHES = 1000
local switches = {}

function SwitchPublisher.initialize()
    if not enabled or initialized then
        return
    end

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

function SwitchPublisher.updateData()
    if not enabled then
        return
    end

    if not initialized then
        SwitchPublisher.initialize()
    end

    for i = 1, #switches do
        local switch = switches[i]
        switch.position = EEPGetSwitch(switch.id)
    end

    AkStatistik.writeLater("switches", switches)
end

return SwitchPublisher
