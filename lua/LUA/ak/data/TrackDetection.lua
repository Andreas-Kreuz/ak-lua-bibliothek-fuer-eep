if AkDebugLoad then print("Loading ak.data.TrackCollector ...") end

local EventBroker = require("ak.util.EventBroker")
local RuntimeRegistry = require("ak.util.RuntimeRegistry")
---@class TrackDetection
---@field tracks table<number, Track>
---@field trackType string
---@field reservedFunction function
---@field registerFunction function
local TrackDetection = {}

local MAX_TRACKS = 50000

local registerFunctions = {
    auxiliary = EEPRegisterAuxiliaryTrack,
    control = EEPRegisterControlTrack,
    road = EEPRegisterRoadTrack,
    rail = EEPRegisterRailTrack,
    tram = EEPRegisterTramTrack
}
local reservedFunctions = {
    auxiliary = EEPIsAuxiliaryTrackReserved,
    control = EEPIsControlTrackReserved,
    road = EEPIsRoadTrackReserved,
    rail = EEPIsRailTrackReserved,
    tram = EEPIsTramTrackReserved
}

---store runtime
---@param identifier string
---@param time number
function TrackDetection:storeRunTime(identifier, time)
    RuntimeRegistry.storeRunTime("TrackCollector.ALL." .. identifier, time)
    RuntimeRegistry.storeRunTime("TrackCollector." .. self.trackType .. "." .. identifier, time)
end

---This will create a dictionary of train names to their location on the tracks
---@return table<string,table<string,number>>
function TrackDetection:findTrainsOnTrack()
    ---@type table<string,table<string,number>>
    local trainsOnTrack = {}

    -- Fill the list of tracks for each train by looking in every track
    for _, track in pairs(self.tracks) do
        local trackId = track.id
        -- Limitation: only the first train on a track is found
        local _, occupied, trainName = self.reservedFunction(trackId, true)
        if occupied and trainName then
            trainsOnTrack[trainName] = trainsOnTrack[trainName] or {}
            trainsOnTrack[trainName][tostring(trackId)] = trackId
        end
    end

    return trainsOnTrack
end

function TrackDetection:initialize()
    for id = 1, MAX_TRACKS do
        local exists = self.registerFunction(id)
        if exists then
            ---@class Track
            ---@field id number
            local track = {}
            track.id = id
            -- track.position = val
            self.tracks[tostring(track.id)] = track
        end
    end

    -- TODO: Send event only with detected changes
    EventBroker.fireListChange(self.trackType .. "-" .. "tracks", "id", self.tracks)
    self:updateData()
end

function TrackDetection:updateData()
    local _ = self
    return {
        -- [self.trackType .. "-tracks"] = self.tracks,
    }
end

function TrackDetection:new(trackType)
    assert(trackType, "Bitte geben Sie den Namen \"trackType\" an.")
    assert(registerFunctions[trackType], "trackType must be one of 'auxiliary', 'control', 'road', 'rail', 'tram'")
    assert(reservedFunctions[trackType], "trackType must be one of 'auxiliary', 'control', 'road', 'rail', 'tram'")

    local o = {
        registerFunction = registerFunctions[trackType],
        reservedFunction = reservedFunctions[trackType],
        trackType = trackType,
        tracks = {}
    }

    self.__index = self
    setmetatable(o, self)
    return o
end

return TrackDetection
