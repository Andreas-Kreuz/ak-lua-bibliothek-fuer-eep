local Line = require("ak.public-transport.Line")

-- Simple Structure - works with any model
local SimpleStructure = {}

SimpleStructure.name = "SimpleStructure"

SimpleStructure.initStation = function(displayStructure, stationName, platform)
    assert(type(displayStructure) == "string", "Need 'displayStructure' as string not as " .. type(displayStructure))
    assert(type(stationName) == "string", "Need 'stationName' as string")
    assert(type(platform) == "string", "Need 'platform' as string")

    -- EEPStructureSetTextureText(displayStructure, 21, stationName)
    -- EEPStructureSetTextureText(displayStructure, 24, "Steig " .. platform)
end

SimpleStructure.displayEntries = function(displayStructure, stationQueueEntries, stationName, platform)
    assert(type(displayStructure) == "string", "Need 'displayStructure' as string not as " .. type(displayStructure))
    assert(type(stationQueueEntries) == "table",
           "Need 'stationQueueEntries' as table not as " .. type(stationQueueEntries))
    assert(type(stationName) == "string", "Need 'stationName' as string")
    assert(type(platform) == "string", "Need 'platform' as string")

    local text = {stationName, " (Steig ", platform, ")<br>"}
    table.insert(text, "Linie / Ziel / Minuten<br>")

    for i = 1, 5 do
        ---@type StationQueueEntry
        local entry = stationQueueEntries[i]
        table.insert(text, entry and entry.line or "")
        table.insert(text, " / ")
        table.insert(text, entry and entry.destination or "")
        table.insert(text, " / ")
        table.insert(text, (entry and entry.timeInMinutes > 0) and tostring(entry.timeInMinutes) or "")
        table.insert(text, " ")
        table.insert(text, (entry and entry.timeInMinutes > 0) and "min" or "")
        table.insert(text, "<br>")
    end

    text = table.concat(text, "")
    EEPChangeInfoStructure(displayStructure, text)
    EEPShowInfoStructure(displayStructure, Line.showDepartureTippText)
end

return SimpleStructure
