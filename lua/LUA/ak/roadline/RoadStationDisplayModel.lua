if AkDebugLoad then print("Loading ak.roadline.RoadStationDisplayModel ...") end

local Line = require "ak.roadline.Line"

------------------------------------------------------------------------------------------
-- Klasse DisplayModel
-- Weiss, welche Signalstellung fuer rot, gelb und gruen geschaltet werden muessen.
------------------------------------------------------------------------------------------
---@class DisplayModel
---@field name string
---@field initStation function function to initialize the station
---@field displayEntries function function to display the station entries
local DisplayModel = {}
DisplayModel.allModels = {}

---
-- @param name Name of the model
-- @param displayEntries function to display a list of stationQueueEntries
function DisplayModel:new(name, initStation, displayEntries)
    assert(type(name) == "string", "Need 'name' as string")
    assert(type(initStation) == "function", "Need 'initStation' as function")
    assert(type(displayEntries) == "function", "Need 'displayEntries' as function")
    local o = {name = name, initStation = initStation, displayEntries = displayEntries}
    self.__index = self
    local x = setmetatable(o, self)
    table.insert(DisplayModel.allModels, o)
    return x
end

function DisplayModel:printName() print(self.name) end

function DisplayModel:print(displayStructure, stationQueueEntries)
    self.displayEntries(displayStructure, stationQueueEntries)
end

---------------------
-- Known Models
---------------------

local SimpleStructure_initStation = function(displayStructure, stationName, platform)
    assert(type(displayStructure) == "string", "Need 'displayStructure' as string not as " .. type(displayStructure))
    assert(type(stationName) == "string", "Need 'stationName' as string")
    assert(type(platform) == "string", "Need 'platform' as string")

    -- EEPStructureSetTextureText(displayStructure, 21, stationName)
    -- EEPStructureSetTextureText(displayStructure, 24, "Steig " .. platform)
end
local SimpleStructure_displayEntries = function(displayStructure, stationQueueEntries, stationName, platform)
    assert(type(displayStructure) == "string", "Need 'displayStructure' as string not as " .. type(displayStructure))
    assert(type(stationQueueEntries) == "table",
           "Need 'stationQueueEntries' as table not as " .. type(stationQueueEntries))
    assert(type(stationName) == "string", "Need 'stationName' as string")
    assert(type(platform) == "string", "Need 'platform' as string")

    local text = {stationName, " (Steig ", platform, ")<br>"}
    table.insert(text, "Linie / Ziel / Minuten<br>")

    for i = 1, 5 do
        ---@type StationQueueEntry
        local entry = stationQueueEntries[i]
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

DisplayModel.SimpleStructure = DisplayModel:new("SimpleStructure", SimpleStructure_initStation,
                                                SimpleStructure_displayEntries)

-- DL1 Model
local Tram_Schild_DL1_initStation = function(displayStructure, stationName, platform)
    assert(type(displayStructure) == "string", "Need 'displayStructure' as string not as " .. type(displayStructure))
    assert(type(stationName) == "string", "Need 'stationName' as string")
    assert(type(platform) == "string", "Need 'platform' as string")

    EEPStructureSetTextureText(displayStructure, 21, stationName)
    EEPStructureSetTextureText(displayStructure, 24, "Steig " .. platform)
end

local Tram_Schild_DL1_displayEntries = function(displayStructure, stationQueueEntries, stationName, platform)
    assert(type(displayStructure) == "string", "Need 'displayStructure' as string not as " .. type(displayStructure))
    assert(type(stationQueueEntries) == "table",
           "Need 'stationQueueEntries' as table not as " .. type(stationQueueEntries))
    assert(type(stationName) == "string", "Need 'stationName' as string")
    assert(type(platform) == "string", "Need 'platform' as string")

    local text = {stationName, " (Steig ", platform, ")<br>"}

    table.insert(text, "Linie / Ziel / Minuten<br>")

    for i = 1, 5 do
        local offset = (i - 1) * 4
        ---@type StationQueueEntry
        local entry = stationQueueEntries[i]
        EEPStructureSetTextureText(displayStructure, offset + 1, entry and entry.line or "")
        EEPStructureSetTextureText(displayStructure, offset + 2, entry and entry.destination or "")
        EEPStructureSetTextureText(displayStructure, offset + 3,
                                   (entry and entry.timeInMinutes > 0) and tostring(entry.timeInMinutes) or "")
        EEPStructureSetTextureText(displayStructure, offset + 4, (entry and entry.timeInMinutes > 0) and "min" or "")

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

DisplayModel.Tram_Schild_DL1 = DisplayModel:new("Tram_Schild_DL1", Tram_Schild_DL1_initStation,
                                                Tram_Schild_DL1_displayEntries)

local BusHSInfo_RG3_initStation = function(displayStructure, stationName, platform)
    assert(type(displayStructure) == "string", "Need 'displayStructure' as string not as " .. type(displayStructure))
    assert(type(stationName) == "string", "Need 'stationName' as string")
    assert(type(platform) == "string", "Need 'platform' as string")
    EEPStructureSetTextureText(displayStructure, 1, stationName)
    -- EEPStructureSetTextureText(displayStructure, 2, stationName)
    -- EEPStructureSetTextureText(displayStructure, 3, stationName)
    EEPStructureSetTextureText(displayStructure, 4, "Steig " .. platform)
end

local BusHSInfo_RG3_displayEntries = function(displayStructure, stationQueueEntries, stationName, platform)
    assert(type(displayStructure) == "string", "Need 'displayStructure' as string not as " .. type(displayStructure))
    assert(type(stationQueueEntries) == "table",
           "Need 'stationQueueEntries' as table not as " .. type(stationQueueEntries))
    assert(type(stationName) == "string", "Need 'stationName' as string")
    assert(type(platform) == "string", "Need 'platform' as string")
end

DisplayModel.BusHSInfo_RG3 =
DisplayModel:new("BusHSInfo_RG3", BusHSInfo_RG3_initStation, BusHSInfo_RG3_displayEntries)

local BusHSdfi_RG3_initStation = function(displayStructure, stationName, platform)
    assert(type(displayStructure) == "string", "Need 'displayStructure' as string not as " .. type(displayStructure))
    assert(type(stationName) == "string", "Need 'stationName' as string")
    assert(type(platform) == "string", "Need 'platform' as string")
    EEPStructureSetTextureText(displayStructure, 1, "")
    EEPStructureSetTextureText(displayStructure, 2, "")
    EEPStructureSetTextureText(displayStructure, 3, "")
    EEPStructureSetTextureText(displayStructure, 4, "")
    EEPStructureSetTextureText(displayStructure, 5, "")
    EEPStructureSetTextureText(displayStructure, 6, "")
    EEPStructureSetTextureText(displayStructure, 7, "")
end

local BusHSdfi_RG3_displayEntries = function(displayStructure, stationQueueEntries, stationName, platform)
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

    for i = 1, 2 do
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

DisplayModel.BusHSdfi_RG3 = DisplayModel:new("BusHSdfi_RG3", BusHSdfi_RG3_initStation, BusHSdfi_RG3_displayEntries)

--------------------------------------------------------------------------------------------------------------------
-- V15NRG35023
--------------------------------------------------------------------------------------------------------------------
local BusHS_Tram_Info_6_RG3_initStation = function(displayStructure, stationName, platform, routeNames)
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

local BusHS_Tram_Info_6_RG3_displayEntries = function(displayStructure, stationQueueEntries, stationName, platform)
    assert(type(displayStructure) == "string", "Need 'displayStructure' as string not as " .. type(displayStructure))
    assert(type(stationQueueEntries) == "table",
           "Need 'stationQueueEntries' as table not as " .. type(stationQueueEntries))
    assert(type(stationName) == "string", "Need 'stationName' as string")
    assert(type(platform) == "string", "Need 'platform' as string")
end

DisplayModel.BusHS_Tram_Info_6_RG3 = DisplayModel:new("BusHS_Tram_Info_6_RG3", BusHS_Tram_Info_6_RG3_initStation,
                                                      BusHS_Tram_Info_6_RG3_displayEntries)

local BusHS_Tram_dfi_6_RG3_initStation = function(displayStructure, stationName, platform)
    assert(type(displayStructure) == "string", "Need 'displayStructure' as string not as " .. type(displayStructure))
    assert(type(stationName) == "string", "Need 'stationName' as string")
    assert(type(platform) == "string", "Need 'platform' as string")
    for i = 1, 20 do EEPStructureSetTextureText(displayStructure, i, "") end
end

local BusHS_Tram_dfi_6_RG3_displayEntries = function(displayStructure, stationQueueEntries, stationName, platform)
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

DisplayModel.BusHS_Tram_dfi_6_RG3 = DisplayModel:new("BusHS_Tram_dfi_6_RG3", BusHS_Tram_dfi_6_RG3_initStation,
                                                     BusHS_Tram_dfi_6_RG3_displayEntries)

return DisplayModel
