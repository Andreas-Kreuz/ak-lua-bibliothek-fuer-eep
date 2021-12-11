-- V15NRG35002 - Buswartehaeuser in Dioramaqualitaet mit DFI
local BusHSInfo_RG3 = {}

BusHSInfo_RG3.name = "BusHSInfo_RG3"

BusHSInfo_RG3.initStation = function(displayStructure, stationName, platform)
    assert(type(displayStructure) == "string", "Need 'displayStructure' as string not as " .. type(displayStructure))
    assert(type(stationName) == "string", "Need 'stationName' as string")
    assert(type(platform) == "string", "Need 'platform' as string")
    EEPStructureSetTextureText(displayStructure, 1, stationName)
    -- EEPStructureSetTextureText(displayStructure, 2, stationName)
    -- EEPStructureSetTextureText(displayStructure, 3, stationName)
    EEPStructureSetTextureText(displayStructure, 4, "Steig " .. platform)
end

BusHSInfo_RG3.displayEntries = function(displayStructure, stationQueueEntries, stationName, platform)
    assert(type(displayStructure) == "string", "Need 'displayStructure' as string not as " .. type(displayStructure))
    assert(type(stationQueueEntries) == "table",
           "Need 'stationQueueEntries' as table not as " .. type(stationQueueEntries))
    assert(type(stationName) == "string", "Need 'stationName' as string")
    assert(type(platform) == "string", "Need 'platform' as string")
end

return BusHSInfo_RG3
