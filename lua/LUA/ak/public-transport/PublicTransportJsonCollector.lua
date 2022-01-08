if AkDebugLoad then print("[#Start] Loading ak.public-transport.PublicTransportJsonCollector ...") end
local LineRegistry = require("ak.public-transport.LineRegistry")
local EventBroker = require("ak.util.EventBroker")

---@class PublicTransportJsonCollector
PublicTransportJsonCollector = {}
local enabled = true
local initialized = false
PublicTransportJsonCollector.name = "ak.public-transport.data.PublicTransportJsonCollector"
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
    EventBroker.fireListChange("public-transport-module-settings", "name", settings)
    return settings;
end

local function collect()
    local publicTransportStations = {}
    local publicTransportLines = {} -- Line.lines
    local publicTransportSettings = collectModuleSettings()

    -- TODO: Send event only with detected changes
    -- EventBroker.fireListChange("public-transport-stations", "id", publicTransportStations)
    -- EventBroker.fireListChange("public-transport-lines", "id", publicTransportLines)
    EventBroker.fireListChange("public-transport-module-settings", "name", publicTransportSettings)
    LineRegistry.fireChangeLinesEvent()

    return {
        ["public-transport-stations"] = publicTransportStations,
        ["public-transport-lines"] = publicTransportLines,
        ["public-transport-module-settings"] = publicTransportSettings
    }
end

function PublicTransportJsonCollector.initialize()
    if not enabled or initialized then return end

    initialized = true
end

function PublicTransportJsonCollector.collectData()
    if not enabled then return end

    if not initialized then PublicTransportJsonCollector.initialize() end

    collect()
    return {
        -- collected data is currently ignored.
    }
end

return PublicTransportJsonCollector
