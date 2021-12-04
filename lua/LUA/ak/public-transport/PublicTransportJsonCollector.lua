if AkDebugLoad then print("Loading ak.public-transport.PublicTransportJsonCollector ...") end
local EventBroker = require "ak.util.EventBroker"

---@class PublicTransportJsonCollector
PublicTransportJsonCollector = {}
local enabled = true
local initialized = false
PublicTransportJsonCollector.name = "ak.public-transport.data.PublicTransportJsonCollector"
local Line = require("ak.public-transport.Line")

local function collectModuleSettings()
    local settings = {
        {
            ["category"] = "Linien",
            ["name"] = "Abfahrten als TippText",
            ["description"] = "Zeige Abfahrten für Bus und Tram-Linien als TippText an",
            ["type"] = "boolean",
            ["value"] = Line.showDepartureTippText,
            ["eepFunction"] = "Line.showLineInfoOnStructures"
        }
    }

    -- TODO: Send event only with detected changes
    EventBroker.fireListChange("line-module-settings", "name", settings)
    return settings;
end

local function collect()
    local roadStations = {}
    local roadLines = {} -- Line.lines
    local publicTransportSettings = collectModuleSettings()

    -- TODO: Send event only with detected changes
    EventBroker.fireListChange("public-transport-stations", "id", roadStations)
    EventBroker.fireListChange("public-transport-lines", "id", roadLines)
    EventBroker.fireListChange("public-transport-module-settings", "name", publicTransportSettings)

    return {
        ["public-transport-stations"] = roadStations,
        ["public-transport-lines"] = roadLines,
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
