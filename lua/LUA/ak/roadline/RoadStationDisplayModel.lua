if AkDebugLoad then print("Loading ak.roadline.RoadStationDisplayModel ...") end

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

-- DL1 Model
local Tram_Schild_DL1_initStation = function(displayStructure, stationName, platform)
    assert(type(displayStructure) == "string", "Need 'displayStructure' as string not as " .. type(displayStructure))
    assert(type(stationName) == "string", "Need 'stationName' as string")
    assert(type(platform) == "string", "Need 'platform' as string")

    EEPStructureSetTextureText(displayStructure, 21, stationName)
    EEPStructureSetTextureText(displayStructure, 24, "Steig " .. platform)
end

local Tram_Schild_DL1_displayEntries = function(displayStructure, stationQueueEntries, stationName, platform)
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
    EEPShowInfoStructure(displayStructure, true)
end

DisplayModel.Tram_Schild_DL1 = DisplayModel:new("Tram_Schild_DL1", Tram_Schild_DL1_initStation,
                                                Tram_Schild_DL1_displayEntries)

local BusHSInfo_RG3_initStation = function(displayStructure, stationName, platform)
    assert(type(displayStructure) == "string", "Need 'displayStructure' as string not as " .. type(displayStructure))
    assert(type(stationName) == "string", "Need 'stationName' as string")
    assert(type(platform) == "string", "Need 'platform' as string")
    EEPStructureSetTextureText(displayStructure, 1, stationName)
end

local BusHSInfo_RG3_displayEntries = function(displayStructure, stationQueueEntries, stationName, platform)
    assert(type(displayStructure) == "string", "Need 'displayStructure' as string not as " .. type(displayStructure))
    assert(type(stationQueueEntries) == "function",
           "Need 'stationQueueEntries' as function not as " .. type(stationQueueEntries))
    assert(type(stationName) == "string", "Need 'stationName' as string")
    assert(type(platform) == "string", "Need 'platform' as string")
end

DisplayModel.BusHSInfo_RG3 = DisplayModel:new("BusHSInfo_RG3", BusHSInfo_RG3_initStation,
                                              BusHSInfo_RG3_displayEntries)

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
    EEPStructureSetTextureText(displayStructure, 8, "")
end

local BusHSdfi_RG3_displayEntries = function(displayStructure, stationQueueEntries, stationName, platform)
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
    EEPShowInfoStructure(displayStructure, true)
end

DisplayModel.BusHSdfi_RG3 = DisplayModel:new("BusHSdfi_RG3", BusHSdfi_RG3_initStation, BusHSdfi_RG3_displayEntries)

return DisplayModel
