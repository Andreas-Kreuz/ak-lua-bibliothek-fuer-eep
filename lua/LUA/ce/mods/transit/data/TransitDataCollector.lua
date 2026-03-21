if AkDebugLoad then print("[#Start] Loading ce.mods.transit.data.TransitDataCollector ...") end
local Line = require("ce.mods.transit.Line")
local TransitSettings = require("ce.mods.transit.TransitSettings")

local TransitDataCollector = {}

function TransitDataCollector.collectModuleSettings()
    return {
        {
            category = "Tipp-Texte fuer Anzeigetafeln",
            name = "Naechste Abfahrten",
            description = "Zeige Abfahrten fuer Bus und Tram-Linien als TippText an",
            type = "boolean",
            value = TransitSettings.showDepartureTippText,
            eepFunction = "TransitSettings.setShowDepartureTippText"
        }
    }
end

function TransitDataCollector.collectTransitData()
    return {
        publicTransportStations = {},
        publicTransportLines = Line.getLines(),
        publicTransportSettings = TransitDataCollector.collectModuleSettings()
    }
end

return TransitDataCollector
