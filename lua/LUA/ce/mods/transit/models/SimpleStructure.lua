local TransitSettings = require("ce.mods.transit.TransitSettings")
local RoadStationTippHelper = require("ce.hub.util.RoadStationTippHelper")

-- Simple Structure - works with any model
local SimpleStructure = {}

SimpleStructure.name = "SimpleStructure"

SimpleStructure.initStation = function (displayStructure, stationName, platform)
    assert(type(displayStructure) == "string", "Need 'displayStructure' as string not as " .. type(displayStructure))
    assert(type(stationName) == "string", "Need 'stationName' as string")
    assert(type(platform) == "string", "Need 'platform' as string")

    -- EEPStructureSetTextureText(displayStructure, 21, stationName)
    -- EEPStructureSetTextureText(displayStructure, 24, "Steig " .. platform)
end

SimpleStructure.displayEntries = function (displayStructure, stationQueueEntries, stationName, platform)
    assert(type(displayStructure) == "string", "Need 'displayStructure' as string not as " .. type(displayStructure))
    assert(type(stationQueueEntries) == "table",
           "Need 'stationQueueEntries' as table not as " .. type(stationQueueEntries))
    assert(type(stationName) == "string", "Need 'stationName' as string")
    assert(type(platform) == "string", "Need 'platform' as string")

    local text = { RoadStationTippHelper.getTitle(stationName, platform) }
    for i = 1, 5 do
        ---@type StationQueueEntry
        local entry = stationQueueEntries[i]
        table.insert(text, RoadStationTippHelper.getEntry(entry))
    end

    local t = table.concat(text, "")
    EEPChangeInfoStructure(displayStructure, t)
    EEPShowInfoStructure(displayStructure, TransitSettings.showDepartureTippText)
end

return SimpleStructure
