if AkDebugLoad then print("[#Start] Loading ce.hub.data.time.TimeStatePublisher ...") end
local DataChangeBus = require("ce.hub.publish.DataChangeBus")
local TimeDtoFactory = require("ce.hub.data.time.TimeDtoFactory")

TimeStatePublisher = {}
local enabled = true
local initialized = false
TimeStatePublisher.name = "ce.hub.data.time.TimeStatePublisher"

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
    DataChangeBus.fireListChange(TimeDtoFactory.createTimeDtoList(times))

    return {}
end

return TimeStatePublisher
