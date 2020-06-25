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
function DisplayModel:new(name, displayEntries)
    assert(name)
    assert(displayEntries)
    local o = {
        name = name,
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

-- DL1 Mdoe
DisplayModel.Tram_Schild_DL1 =
    DisplayModel:new(
    "Tram_Schild_DL1",
    function(displayStructure, stationQueueEntries)
        local text = {}

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

return DisplayModel
