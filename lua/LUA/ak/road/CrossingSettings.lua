if AkDebugLoad then print("[#Start] Loading ak.road.CrossingSettings ...") end
local StorageUtility = require("ak.storage.StorageUtility")

local CrossingSettings = {}
CrossingSettings.showRequestsOnSignal = false
CrossingSettings.showSequenceOnSignal = false
CrossingSettings.showSignalIdOnSignal = false
CrossingSettings.showLanesOnStructure = false

function CrossingSettings.loadSettingsFromSlot(eepSaveId)
    StorageUtility.registerId(eepSaveId, "Crossing settings")
    CrossingSettings.saveSlot = eepSaveId
    local data = StorageUtility.loadTable(CrossingSettings.saveSlot, "Crossing settings")
    CrossingSettings.showRequestsOnSignal = StorageUtility.toboolean(data["reqInfo"]) or
                                            CrossingSettings.showRequestsOnSignal
    CrossingSettings.showSequenceOnSignal = StorageUtility.toboolean(data["seqInfo"]) or
                                            CrossingSettings.showSequenceOnSignal
    CrossingSettings.showSignalIdOnSignal = StorageUtility.toboolean(data["sigInfo"]) or
                                            CrossingSettings.showSignalIdOnSignal
    CrossingSettings.showLanesOnStructure = StorageUtility.toboolean(data["laneInfo"]) or
                                            CrossingSettings.showLanesOnStructure
end

function CrossingSettings.saveSettings()
    if CrossingSettings.saveSlot then
        local data = {
            reqInfo = tostring(CrossingSettings.showRequestsOnSignal),
            seqInfo = tostring(CrossingSettings.showSequenceOnSignal),
            sigInfo = tostring(CrossingSettings.showSignalIdOnSignal),
            laneInfo = tostring(CrossingSettings.showLanesOnStructure)
        }
        StorageUtility.saveTable(CrossingSettings.saveSlot, data, "Crossing settings")
    end
end

function CrossingSettings.setShowRequestsOnSignal(value)
    assert(value == true or value == false)
    CrossingSettings.showRequestsOnSignal = value
    CrossingSettings.saveSettings()
end

function CrossingSettings.setShowSequenceOnSignal(value)
    assert(value == true or value == false)
    CrossingSettings.showSequenceOnSignal = value
    CrossingSettings.saveSettings()
end

function CrossingSettings.setShowSignalIdOnSignal(value)
    assert(value == true or value == false)
    CrossingSettings.showSignalIdOnSignal = value
    CrossingSettings.saveSettings()
end

function CrossingSettings.setShowLanesOnStructure(value)
    assert(value == true or value == false)
    CrossingSettings.showLanesOnStructure = value
    CrossingSettings.saveSettings()
end

return CrossingSettings
