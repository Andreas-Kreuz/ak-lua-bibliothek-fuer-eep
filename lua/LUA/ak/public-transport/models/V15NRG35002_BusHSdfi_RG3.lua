-- V15NRG35002 - Buswartehaeuser in Dioramaqualitaet mit DFI
local Line = require("ak.public-transport.Line")

local BusHSdfi_RG3 = {}

BusHSdfi_RG3.name = "BusHSdfi_RG3"

BusHSdfi_RG3.initStation = function(displayStructure, stationName, platform)
    assert(type(displayStructure) == "string", "Need 'displayStructure' as string not as " .. type(displayStructure))
    assert(type(stationName) == "string", "Need 'stationName' as string")
    assert(type(platform) == "string", "Need 'platform' as string")
    EEPStructureSetTextureText(displayStructure, 1, "")
    EEPStructureSetTextureText(displayStructure, 2, "")
    EEPStructureSetTextureText(displayStructure, 3, "")
    EEPStructureSetTextureText(displayStructure, 4, "")
    EEPStructureSetTextureText(displayStructure, 5, "")
    EEPStructureSetTextureText(displayStructure, 6, "")
    EEPStructureSetTextureText(displayStructure, 7, "")
end

BusHSdfi_RG3.displayEntries = function(displayStructure, stationQueueEntries, stationName, platform)
    assert(type(displayStructure) == "string", "Need 'displayStructure' as string not as " .. type(displayStructure))
    assert(type(stationQueueEntries) == "table",
           "Need 'stationQueueEntries' as table not as " .. type(stationQueueEntries))
    assert(type(stationName) == "string", "Need 'stationName' as string")
    assert(type(platform) == "string", "Need 'platform' as string")

    local text = {stationName, " (Steig ", platform, ")<br>"}

    table.insert(text, "Linie / Ziel / Minuten<br>")

    -- Set the first entry
    local entry = stationQueueEntries[1]
    EEPStructureSetTextureText(displayStructure, 1, entry and (entry.line .. " " .. entry.destination) or "")
    EEPStructureSetTextureText(displayStructure, 3,
                               (entry and entry.timeInMinutes > 0) and tostring(entry.timeInMinutes) or "")
    EEPStructureSetTextureText(displayStructure, 7, (entry and entry.timeInMinutes > 0) and "min" or "")

    -- Set the second entry
    entry = stationQueueEntries[2]
    EEPStructureSetTextureText(displayStructure, 2, entry and (entry.line .. " " .. entry.destination) or "")
    EEPStructureSetTextureText(displayStructure, 4,
                               (entry and entry.timeInMinutes > 0) and tostring(entry.timeInMinutes) or "")
    EEPStructureSetTextureText(displayStructure, 8, (entry and entry.timeInMinutes > 0) and "min" or "")

    for i = 1, 2 do
        entry = stationQueueEntries[i]
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

return BusHSdfi_RG3
