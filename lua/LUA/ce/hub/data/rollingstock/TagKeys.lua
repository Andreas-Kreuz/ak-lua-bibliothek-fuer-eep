if AkDebugLoad then print("[#Start] Loading ce.hub.data.rollingstock.TagKeys ...") end

-- TODO: General rule: Saving and loading data in EEP from and into tables must not be part of ce/hub, but of the respective module. ce/hub should only provide the data structures and the logic to detect changes and fire events. The modules should decide what to do with the data and how to save and load it.
---@class TagKeys
local TagKeys = {}

TagKeys.Train = { destination = "d", direction = "a", line = "l", route = "r", trainNumber = "n" }
TagKeys.RollingStock = { wagonNumber = "w", tag = "t", model = "m", to = "o", from = "f" }

return TagKeys
