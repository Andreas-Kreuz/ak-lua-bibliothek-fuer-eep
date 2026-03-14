if AkDebugLoad then print("[#Start] Loading ak.data.SwitchStatePublisher ...") end
local DataChangeBus = require("ak.events.DataChangeBus")
local SwitchDataCollector = require("ak.data.SwitchDataCollector")
local SwitchDtoFactory = require("ak.data.SwitchDtoFactory")
require("ak.core.eep.EepFunctionWrapper")
SwitchStatePublisher = {}
local enabled = true
local initialized = false
SwitchStatePublisher.name = "ak.data.SwitchStatePublisher"

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
    DataChangeBus.fireListChange("switches", "id", SwitchDtoFactory.createSwitchDtoList(switches))

    return {
        -- ["switches"] = switches
    }
end

return SwitchStatePublisher
