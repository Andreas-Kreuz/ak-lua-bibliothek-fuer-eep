local StorageUtility = require("ce.hub.util.StorageUtility")
local RoadStation = require("ce.mods.transit.RoadStation")
if AkDebugLoad then print("[#Start] Loading ce.mods.transit.TransitSettings ...") end

local TransitSettings = {}
TransitSettings.showDepartureTippText = false
TransitSettings.saveSlot = nil

function TransitSettings.loadSettingsFromSlot(eepSaveId)
    StorageUtility.registerId(eepSaveId, "Transit settings")
    TransitSettings.saveSlot = eepSaveId
    local data = StorageUtility.loadTable(TransitSettings.saveSlot, "Transit settings")
    TransitSettings.showDepartureTippText = StorageUtility.toboolean(data["depInfo"]) or false
end

function TransitSettings.saveSettings()
    if TransitSettings.saveSlot then
        local data = { ["depInfo"] = tostring(TransitSettings.showDepartureTippText) }
        StorageUtility.saveTable(TransitSettings.saveSlot, data, "Transit settings")
    end
end

function TransitSettings.setShowDepartureTippText(value)
    assert(value == true or value == false)
    TransitSettings.showDepartureTippText = value
    TransitSettings.saveSettings()
    RoadStation.showTippText()
end

return TransitSettings
