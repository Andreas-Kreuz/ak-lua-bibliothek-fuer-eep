if AkDebugLoad then
    print("Loading ak.road.station.RoadStationDisplayModel ...")
end

------------------------------------------------------------------------------------------
-- Klasse DisplayModel
-- Weiss, welche Signalstellung fuer rot, gelb und gruen geschaltet werden muessen.
------------------------------------------------------------------------------------------
---@class DisplayModel
local DisplayModel = {}
DisplayModel.allModels = {}

---
-- @param name Name of the model
-- @param displayEntries function to display a list of stationQueueEntries
function DisplayModel:new(name, initStation, displayEntries)
    assert(name)
    assert(displayEntries)
    local o = {
        name = name,
        initStation = initStation,
        displayEntries = displayEntries
    }
    self.__index = self
    local x = setmetatable(o, self)
    table.insert(DisplayModel.allModels, o)
    return x
end

function DisplayModel:print()
    print(self.name)
end

function DisplayModel:print(displayStructure, stationQueueEntries)
    self.displayEntries(displayStructure, stationQueueEntries)
end

---------------------
-- Known Models
---------------------

-- DL1 Model
DisplayModel.Tram_Schild_DL1 =
    DisplayModel:new(
    "Tram_Schild_DL1",
    function(displayStructure, stationName, platform)
        assert(displayStructure)
        assert(stationName)
        assert(platform)
    end,
    function(displayStructure, stationQueueEntries, stationName, platform)
        local text = { stationName, " (Steig ", platform , ")<br>"}

        table.insert(text, "Linie / Ziel / Minuten<br>")

        for i = 1, 5 do
            local offset = (i - 1) * 4
            ---@type StationQueueEntry
            local entry = stationQueueEntries[i]
            EEPStructureSetTextureText(displayStructure, offset + 1, entry and entry.line or "")
            EEPStructureSetTextureText(displayStructure, offset + 2, entry and entry.destination or "")
            EEPStructureSetTextureText(displayStructure, offset + 3,
            (entry and entry.timeInMinutes > 0) and tostring(entry.timeInMinutes) or "")
            EEPStructureSetTextureText(displayStructure, offset + 4,
            (entry and entry.timeInMinutes > 0) and "min" or "")

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
)

DisplayModel.BusHSdfi_RG3 =
    DisplayModel:new(
    "BusHSdfi_RG3",
    function(displayStructure, stationName, platform)
        assert(displayStructure)
        assert(stationName)
        assert(platform)
        EEPStructureSetTextureText(displayStructure, 1, "")
        EEPStructureSetTextureText(displayStructure, 2, "")
        EEPStructureSetTextureText(displayStructure, 3, "")
        EEPStructureSetTextureText(displayStructure, 4, "")
        EEPStructureSetTextureText(displayStructure, 5, "")
        EEPStructureSetTextureText(displayStructure, 6, "")
        EEPStructureSetTextureText(displayStructure, 7, "")
        EEPStructureSetTextureText(displayStructure, 8, "")
    end,
    function(displayStructure, stationQueueEntries, stationName, platform)
        local text = { stationName, " (Steig ", platform , ")<br>"}

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
)

return DisplayModel
