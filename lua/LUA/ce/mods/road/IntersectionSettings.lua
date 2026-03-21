if AkDebugLoad then print("[#Start] Loading ce.mods.road.IntersectionSettings ...") end
local StorageUtility = require("ce.hub.util.StorageUtility")

local IntersectionSettings = {}
IntersectionSettings.showRequestsOnSignal = false
IntersectionSettings.showSequenceOnSignal = false
IntersectionSettings.showSignalIdOnSignal = false
IntersectionSettings.showLanesOnStructure = false

function IntersectionSettings.loadSettingsFromSlot(eepSaveId)
    StorageUtility.registerId(eepSaveId, "Intersection settings")
    IntersectionSettings.saveSlot = eepSaveId
    local data = StorageUtility.loadTable(IntersectionSettings.saveSlot, "Intersection settings")
    IntersectionSettings.showRequestsOnSignal = StorageUtility.toboolean(data["reqInfo"]) or
        IntersectionSettings.showRequestsOnSignal
    IntersectionSettings.showSequenceOnSignal = StorageUtility.toboolean(data["seqInfo"]) or
        IntersectionSettings.showSequenceOnSignal
    IntersectionSettings.showSignalIdOnSignal = StorageUtility.toboolean(data["sigInfo"]) or
        IntersectionSettings.showSignalIdOnSignal
    IntersectionSettings.showLanesOnStructure = StorageUtility.toboolean(data["laneInfo"]) or
        IntersectionSettings.showLanesOnStructure
end

function IntersectionSettings.saveSettings()
    if IntersectionSettings.saveSlot then
        local data = {
            reqInfo = tostring(IntersectionSettings.showRequestsOnSignal),
            seqInfo = tostring(IntersectionSettings.showSequenceOnSignal),
            sigInfo = tostring(IntersectionSettings.showSignalIdOnSignal),
            laneInfo = tostring(IntersectionSettings.showLanesOnStructure)
        }
        StorageUtility.saveTable(IntersectionSettings.saveSlot, data, "Intersection settings")
    end
end

function IntersectionSettings.setShowRequestsOnSignal(value)
    assert(value == true or value == false)
    IntersectionSettings.showRequestsOnSignal = value
    IntersectionSettings.saveSettings()
end

function IntersectionSettings.setShowSequenceOnSignal(value)
    assert(value == true or value == false)
    IntersectionSettings.showSequenceOnSignal = value
    IntersectionSettings.saveSettings()
end

function IntersectionSettings.setShowSignalIdOnSignal(value)
    assert(value == true or value == false)
    IntersectionSettings.showSignalIdOnSignal = value
    IntersectionSettings.saveSettings()
end

function IntersectionSettings.setShowLanesOnStructure(value)
    assert(value == true or value == false)
    IntersectionSettings.showLanesOnStructure = value
    IntersectionSettings.saveSettings()
end

return IntersectionSettings
