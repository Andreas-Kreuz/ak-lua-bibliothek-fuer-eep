if AkDebugLoad then print("[#Start] Loading ak.data.TimeStatePublisher ...") end
local DataChangeBus = require("ak.events.DataChangeBus")
local TimeDtoFactory = require("ak.data.TimeDtoFactory")

TimeStatePublisher = {}
local enabled = true
local initialized = false
TimeStatePublisher.name = "ak.data.TimeStatePublisher"

function TimeStatePublisher.initialize()
    if not enabled or initialized then return end

    initialized = true
end

function TimeStatePublisher.syncState()
    if not enabled then return end

    if not initialized then TimeStatePublisher.initialize() end

    local times = {
        {
            id = "times",           -- EEP-Web requires that data entries have an id or name tag
            name = "times",         -- EEP-Web requires that data entries have an id or name tag
            timeComplete = EEPTime, -- seconds since midnight
            timeH = EEPTimeH,
            timeM = EEPTimeM,
            timeS = EEPTimeS
        }
    }

    -- TODO: Send event only with detected changes
    DataChangeBus.fireListChange("times", "id", TimeDtoFactory.createTimeDtoList(times))

    return {}
end

return TimeStatePublisher
