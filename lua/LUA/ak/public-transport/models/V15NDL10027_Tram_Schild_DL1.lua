local Line = require("ak.public-transport.Line")

-- V15NDL10027 - Texturierbare Zielanzeigen für Haltestellen
local Tram_Schild_DL1 = {}

Tram_Schild_DL1.name = "Tram_Schild_DL1"

-- DL1 Model
Tram_Schild_DL1.initStation = function(displayStructure, stationName, platform)
    assert(type(displayStructure) == "string", "Need 'displayStructure' as string not as " .. type(displayStructure))
    assert(type(stationName) == "string", "Need 'stationName' as string")
    assert(type(platform) == "string", "Need 'platform' as string")

    EEPStructureSetTextureText(displayStructure, 21, stationName)
    EEPStructureSetTextureText(displayStructure, 24, "Steig " .. platform)
end

Tram_Schild_DL1.displayEntries = function(displayStructure, stationQueueEntries, stationName, platform)
    assert(type(displayStructure) == "string", "Need 'displayStructure' as string not as " .. type(displayStructure))
    assert(type(stationQueueEntries) == "table",
           "Need 'stationQueueEntries' as table not as " .. type(stationQueueEntries))
    assert(type(stationName) == "string", "Need 'stationName' as string")
    assert(type(platform) == "string", "Need 'platform' as string")

    local text = {stationName, " (Steig ", platform, ")<br>"}

    table.insert(text, "Linie / Ziel / Minuten<br>")

    for i = 1, 5 do
        local offset = (i - 1) * 4
        ---@type StationQueueEntry
        local entry = stationQueueEntries[i]
        EEPStructureSetTextureText(displayStructure, offset + 1, entry and entry.line or "")
        EEPStructureSetTextureText(displayStructure, offset + 2, entry and entry.destination or "")
        EEPStructureSetTextureText(displayStructure, offset + 3,
                                   (entry and entry.timeInMinutes > 0) and tostring(entry.timeInMinutes) or "")
        EEPStructureSetTextureText(displayStructure, offset + 4, (entry and entry.timeInMinutes > 0) and "min" or "")

        table.insert(text, entry and entry.line or "")
        table.insert(text, " / ")
        table.insert(text, entry and entry.destination or "")
        table.insert(text, " / ")
        table.insert(text, (entry and entry.timeInMinutes > 0) and tostring(entry.timeInMinutes) or "")
        table.insert(text, " ")
        table.insert(text, (entry and entry.timeInMinutes > 0) and "min" or "")
        table.insert(text, "<br>")
    end

    local t = table.concat(text, "")
    EEPChangeInfoStructure(displayStructure, t)
    EEPShowInfoStructure(displayStructure, Line.showDepartureTippText)
end

return Tram_Schild_DL1
