-- V15NRG35023 - DFI digitale Fahrgastinformation für 6 Linien
BusHS_Tram_Info_6_RG3 = {}

BusHS_Tram_Info_6_RG3.name = "BusHS_Tram_Info_6_RG3"

BusHS_Tram_Info_6_RG3.initStation = function(displayStructure, stationName, platform, routeNames)
    assert(type(displayStructure) == "string", "Need 'displayStructure' as string not as " .. type(displayStructure))
    assert(type(stationName) == "string", "Need 'stationName' as string")
    assert(type(platform) == "string", "Need 'platform' as string")
    EEPStructureSetTextureText(displayStructure, 1, stationName)
    if (routeNames) then
        for i = 1, 5 do
            local route = routeNames[i]
            local index = i + 1
            EEPStructureSetTextureText(displayStructure, index, route or "")
        end
    end
    EEPStructureSetTextureText(displayStructure, 7, "Steig " .. platform)
end

BusHS_Tram_Info_6_RG3.displayEntries = function(displayStructure, stationQueueEntries, stationName, platform)
    assert(type(displayStructure) == "string", "Need 'displayStructure' as string not as " .. type(displayStructure))
    assert(type(stationQueueEntries) == "table",
           "Need 'stationQueueEntries' as table not as " .. type(stationQueueEntries))
    assert(type(stationName) == "string", "Need 'stationName' as string")
    assert(type(platform) == "string", "Need 'platform' as string")
end

return BusHS_Tram_Info_6_RG3
