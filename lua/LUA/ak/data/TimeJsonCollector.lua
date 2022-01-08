if AkDebugLoad then print("[#Start] Loading ak.data.TimeJsonCollector ...") end
local EventBroker = require("ak.util.EventBroker")

TimeJsonCollector = {}
local enabled = true
local initialized = false
TimeJsonCollector.name = "ak.data.TimeJsonCollector"

function TimeJsonCollector.initialize()
    if not enabled or initialized then return end

    initialized = true
end

function TimeJsonCollector.collectData()
    if not enabled then return end

    if not initialized then TimeJsonCollector.initialize() end

    local times = {
        {
            id = "times", -- EEP-Web requires that data entries have an id or name tag
            name = "times", -- EEP-Web requires that data entries have an id or name tag
            timeComplete = EEPTime, -- seconds since midnight
            timeH = EEPTimeH,
            timeM = EEPTimeM,
            timeS = EEPTimeS
        }
    }

    -- TODO: Send event only with detected changes
    EventBroker.fireListChange("times", "id", times)

    return {
        -- ["times"] = times
    }
end

return TimeJsonCollector
