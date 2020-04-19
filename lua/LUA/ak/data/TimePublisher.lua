print"Lade ak.data.TimePublisher ..."
TimePublisher = {}
local AkStatistik = require("ak.io.AkStatistik")
local enabled = true
local initialized = false
TimePublisher.name = "ak.data.TimePublisher"

function TimePublisher.initialize()
    if not enabled or initialized then
        return
    end

    initialized = true
end

function TimePublisher.updateData()
    if not enabled then
        return
    end

    if not initialized then
        TimePublisher.initialize()
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

    AkStatistik.writeLater("times", value)
end

return TimePublisher
