local StorageUtility = require("ce.hub.util.StorageUtility")
local RoadStation = require("ce.mods.public-transport.RoadStation")
if AkDebugLoad then print("[#Start] Loading ce.mods.public-transport.PublicTransportSettings ...") end

local PublicTransportSettings = {}
PublicTransportSettings.showDepartureTippText = false
PublicTransportSettings.saveSlot = nil

function PublicTransportSettings.loadSettingsFromSlot(eepSaveId)
    StorageUtility.registerId(eepSaveId, "PublicTransport settings")
    PublicTransportSettings.saveSlot = eepSaveId
    local data = StorageUtility.loadTable(PublicTransportSettings.saveSlot, "PublicTransport settings")
    PublicTransportSettings.showDepartureTippText = StorageUtility.toboolean(data["depInfo"]) or false
end

function PublicTransportSettings.saveSettings()
    if PublicTransportSettings.saveSlot then
        local data = { ["depInfo"] = tostring(PublicTransportSettings.showDepartureTippText) }
        StorageUtility.saveTable(PublicTransportSettings.saveSlot, data, "PublicTransport settings")
    end
end

function PublicTransportSettings.setShowDepartureTippText(value)
    assert(value == true or value == false)
    PublicTransportSettings.showDepartureTippText = value
    PublicTransportSettings.saveSettings()
    RoadStation.showTippText()
end

return PublicTransportSettings
