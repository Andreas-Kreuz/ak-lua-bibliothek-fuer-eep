---@meta

---@class Track
---@field id number

---@class TrackDetection
---@field tracks table<string, Track>
---@field trackType string
---@field reservedFunction function
---@field registerFunction function
---@field storeRunTime fun(self: TrackDetection, identifier: string, time: number):nil
---@field findTrainsOnTrack fun(self: TrackDetection):table<string, table<string, number>>
---@field initialize fun(self: TrackDetection):nil
---@field updateData fun(self: TrackDetection):table
---@field new fun(self: TrackDetection, trackType: string):TrackDetection
