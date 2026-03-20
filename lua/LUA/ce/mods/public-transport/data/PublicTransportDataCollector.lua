if AkDebugLoad then print("[#Start] Loading ce.mods.public-transport.data.PublicTransportDataCollector ...") end
local Line = require("ce.mods.public-transport.Line")
local PublicTransportSettings = require("ce.mods.public-transport.PublicTransportSettings")

local PublicTransportDataCollector = {}

function PublicTransportDataCollector.collectModuleSettings()
    return {
        {
            category = "Tipp-Texte fuer Anzeigetafeln",
            name = "Naechste Abfahrten",
            description = "Zeige Abfahrten fuer Bus und Tram-Linien als TippText an",
            type = "boolean",
            value = PublicTransportSettings.showDepartureTippText,
            eepFunction = "PublicTransportSettings.setShowDepartureTippText"
        }
    }
end

function PublicTransportDataCollector.collectPublicTransportData()
    return {
        publicTransportStations = {},
        publicTransportLines = Line.getLines(),
        publicTransportSettings = PublicTransportDataCollector.collectModuleSettings()
    }
end

return PublicTransportDataCollector
