if AkDebugLoad then print("[#Start] Loading ce.hub.data.switches.SwitchStatePublisher ...") end
local DataChangeBus = require("ce.hub.publish.DataChangeBus")
local SwitchDataCollector = require("ce.hub.data.switches.SwitchDataCollector")
local SwitchDtoFactory = require("ce.hub.data.switches.SwitchDtoFactory")
require("ce.hub.eep.EepFunctionWrapper")
SwitchStatePublisher = {}
local enabled = true
local initialized = false
SwitchStatePublisher.name = "ce.hub.data.switches.SwitchStatePublisher"

local switches = {}

function SwitchStatePublisher.initialize()
    if not enabled or initialized then return end

    switches = SwitchDataCollector.collectInitialSwitches()

    initialized = true
end

function SwitchStatePublisher.syncState()
    if not enabled then return end

    if not initialized then SwitchStatePublisher.initialize() end

    SwitchDataCollector.refreshSwitches(switches)

    -- TODO: Send event only with detected changes
    DataChangeBus.fireListChange(SwitchDtoFactory.createSwitchDtoList(switches))

    return {
        -- ["switches"] = switches
    }
end

return SwitchStatePublisher
