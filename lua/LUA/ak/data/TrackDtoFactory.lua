if AkDebugLoad then print("[#Start] Loading ak.data.TrackDtoFactory ...") end

local DtoFactoryUtils = require("ak.data.DtoFactoryUtils")

local TrackDtoFactory = {}

local KEY_ID = "id"

local function roomForTrackType(trackType)
    return trackType .. "-tracks"
end

function TrackDtoFactory.createTrackDto(trackType, track)
    local dto = DtoFactoryUtils.toDto(track)
    return roomForTrackType(trackType), KEY_ID, dto[KEY_ID], dto
end

function TrackDtoFactory.createTrackDtoList(trackType, tracks)
    local trackDtos = {}

    for trackId, track in pairs(tracks) do
        local _, _, _, dto = TrackDtoFactory.createTrackDto(trackType, track)
        trackDtos[trackId] = dto
    end

    return roomForTrackType(trackType), KEY_ID, trackDtos
end

return TrackDtoFactory
