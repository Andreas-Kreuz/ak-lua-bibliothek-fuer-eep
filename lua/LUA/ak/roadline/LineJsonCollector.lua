if AkDebugLoad then print("Loading ak.road.LineJsonCollector ...") end
local EventBroker = require "ak.util.EventBroker"

---@class LineJsonCollector
LineJsonCollector = {}
local enabled = true
local initialized = false
LineJsonCollector.name = "ak.data.LineJsonCollector"
local Line = require("ak.roadline.Line")

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
    local roadStationSettings = collectModuleSettings()

    -- TODO: Send event only with detected changes
    EventBroker.fireListChange("roadstation-stations", "id", roadStations)
    EventBroker.fireListChange("roadstation-lines", "id", roadLines)
    EventBroker.fireListChange("roadstation-module-settings", "name", roadStationSettings)

    return {
        ["roadstation-stations"] = roadStations,
        ["roadstation-lines"] = roadLines,
        ["roadstation-module-settings"] = roadStationSettings
    }
end

function LineJsonCollector.initialize()
    if not enabled or initialized then return end

    initialized = true
end

function LineJsonCollector.collectData()
    if not enabled then return end

    if not initialized then LineJsonCollector.initialize() end

    collect()
    return {
        -- collected data is currently ignored.
    }
end

return LineJsonCollector
