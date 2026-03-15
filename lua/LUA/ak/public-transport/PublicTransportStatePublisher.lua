if AkDebugLoad then print("[#Start] Loading ak.public-transport.PublicTransportStatePublisher ...") end
local LineRegistry = require("ak.public-transport.LineRegistry")
local DataChangeBus = require("ak.events.DataChangeBus")
local PublicTransportDtoFactory = require("ak.public-transport.PublicTransportDtoFactory")

---@class PublicTransportStatePublisher
PublicTransportStatePublisher = {}
local enabled = true
local initialized = false
PublicTransportStatePublisher.name = "ak.public-transport.data.PublicTransportStatePublisher"
local Line = require("ak.public-transport.Line")

local function collectModuleSettings()
    local settings = {
        {
            ["category"] = "Tipp-Texte für Anzeigetafeln",
            ["name"] = "Nächste Abfahrten",
            ["description"] = "Zeige Abfahrten für Bus und Tram-Linien als TippText an",
            ["type"] = "boolean",
            ["value"] = Line.showDepartureTippText,
            ["eepFunction"] = "Line.setShowDepartureTippText"
        }
    }

    -- TODO: Send event only with detected changes
    DataChangeBus.fireListChange(PublicTransportDtoFactory.createPublicTransportModuleSettingDtoList(settings))
    return settings;
end

local function collect()
    local publicTransportStations = {}
    local publicTransportLines = Line.getLines()
    local publicTransportSettings = collectModuleSettings()

    -- TODO: Send event only with detected changes
    DataChangeBus.fireListChange(PublicTransportDtoFactory.createPublicTransportStationDtoList(publicTransportStations))
    DataChangeBus.fireListChange(PublicTransportDtoFactory.createPublicTransportLineDtoList(publicTransportLines))
    DataChangeBus.fireListChange(
        PublicTransportDtoFactory.createPublicTransportModuleSettingDtoList(publicTransportSettings))
    LineRegistry.fireChangeLinesEvent()

    return {
        ["public-transport-stations"] = publicTransportStations,
        ["public-transport-lines"] = publicTransportLines,
        ["public-transport-module-settings"] = publicTransportSettings
    }
end

function PublicTransportStatePublisher.initialize()
    if not enabled or initialized then return end

    initialized = true
end

function PublicTransportStatePublisher.syncState()
    if not enabled then return end

    if not initialized then PublicTransportStatePublisher.initialize() end

    collect()
    return {
        -- collected data is currently ignored.
    }
end

return PublicTransportStatePublisher
