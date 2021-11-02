if AkDebugLoad then print("Loading ak.train.TagKeys ...") end

---@class TagKeys
local TagKeys = {}

TagKeys.Train = {destination = "d", direction = "a", line = "l", route = "r", trainNumber = "n"}
TagKeys.RollingStock = {wagonNumber = "w", tag = "t", model = "m", to = "o", from = "f"}

return TagKeys
