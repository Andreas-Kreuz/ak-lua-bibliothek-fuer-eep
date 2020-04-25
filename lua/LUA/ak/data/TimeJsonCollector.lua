print "Lade ak.data.TimeJsonCollector ..."
TimeJsonCollector = {}
local enabled = true
local initialized = false
TimeJsonCollector.name = "ak.data.TimeJsonCollector"

function TimeJsonCollector.initialize()
    if not enabled or initialized then
        return
    end

    initialized = true
end

function TimeJsonCollector.collectData()
    if not enabled then
        return
    end

    if not initialized then
        TimeJsonCollector.initialize()
    end

    local value = {
        {
            name = "times", -- EEP-Web requires that data entries have an id or name tag
            timeComplete = EEPTime, -- seconds since midnight
            timeH = EEPTimeH,
            timeM = EEPTimeM,
            timeS = EEPTimeS
        }
    }

    return {["times"] = value}
end

return TimeJsonCollector
