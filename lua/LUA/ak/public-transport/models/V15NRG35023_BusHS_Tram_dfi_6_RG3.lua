local Line = require("ak.public-transport.Line")

-- V15NRG35023 - DFI digitale Fahrgastinformation für 6 Linien
BusHS_Tram_dfi_6_RG3 = {}

BusHS_Tram_dfi_6_RG3.name = "BusHS_Tram_dfi_6_RG3"

BusHS_Tram_dfi_6_RG3.initStation = function(displayStructure, stationName, platform)
    assert(type(displayStructure) == "string", "Need 'displayStructure' as string not as " .. type(displayStructure))
    assert(type(stationName) == "string", "Need 'stationName' as string")
    assert(type(platform) == "string", "Need 'platform' as string")
    for i = 1, 20 do EEPStructureSetTextureText(displayStructure, i, "") end
end

BusHS_Tram_dfi_6_RG3.displayEntries = function(displayStructure, stationQueueEntries, stationName, platform)
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

    -- Set the second entry
    entry = stationQueueEntries[3]
    EEPStructureSetTextureText(displayStructure, 9, entry and (entry.line .. " " .. entry.destination) or "")
    EEPStructureSetTextureText(displayStructure, 13,
                               (entry and entry.timeInMinutes > 0) and tostring(entry.timeInMinutes) or "")
    EEPStructureSetTextureText(displayStructure, 17, (entry and entry.timeInMinutes > 0) and "min" or "")

    -- Set the second entry
    entry = stationQueueEntries[4]
    EEPStructureSetTextureText(displayStructure, 10, entry and (entry.line .. " " .. entry.destination) or "")
    EEPStructureSetTextureText(displayStructure, 14,
                               (entry and entry.timeInMinutes > 0) and tostring(entry.timeInMinutes) or "")
    EEPStructureSetTextureText(displayStructure, 18, (entry and entry.timeInMinutes > 0) and "min" or "")

    -- Set the second entry
    entry = stationQueueEntries[5]
    EEPStructureSetTextureText(displayStructure, 11, entry and (entry.line .. " " .. entry.destination) or "")
    EEPStructureSetTextureText(displayStructure, 15,
                               (entry and entry.timeInMinutes > 0) and tostring(entry.timeInMinutes) or "")
    EEPStructureSetTextureText(displayStructure, 19, (entry and entry.timeInMinutes > 0) and "min" or "")

    -- Set the second entry
    entry = stationQueueEntries[6]
    EEPStructureSetTextureText(displayStructure, 12, entry and (entry.line .. " " .. entry.destination) or "")
    EEPStructureSetTextureText(displayStructure, 16,
                               (entry and entry.timeInMinutes > 0) and tostring(entry.timeInMinutes) or "")
    EEPStructureSetTextureText(displayStructure, 20, (entry and entry.timeInMinutes > 0) and "min" or "")

    for i = 1, 6 do
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

return BusHS_Tram_dfi_6_RG3
