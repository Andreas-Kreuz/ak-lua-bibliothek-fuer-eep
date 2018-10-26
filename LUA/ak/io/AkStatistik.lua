require "ak.io.AkCommunicator"

AkStatistik = {}
local MAX_SIGNALS = 1000
local MAX_TRACKS = 50000
local list = {}

local function outputSignals()
    list.signals = {}
    list.waitingOnSignals = {}
    for i = 1, MAX_SIGNALS do
        local val = EEPGetSignal(i)
        if val > 0 then
            local o = {}
            o.id = i
            o.position = val
            table.insert(list.signals, o)

            local count = EEPGetSignalTrainsCount(i)
            if (count > 0) then
                for position = 1, count do
                    local vehicleName = EEPGetSignalTrainName(i, position)
                    table.insert(list.waitingOnSignals, {
                        signalId = o.id,
                        waitingPosition = position,
                        vehicleName = vehicleName,
                        waitingCount = count
                    })
                end
            end
        end
    end
end

local function outputSwitches()
    list.switches = {}
    for i = 1, MAX_SIGNALS do
        local val = EEPGetSignal(i)
        if val > 0 then
            local o = {}
            o.id = i
            o.position = val
            table.insert(list.switches, o)
        end
    end
end

local function registerTracksBy(registerFunktion, trackName)
    list[trackName] = {}
    for i = 1, MAX_TRACKS do
        local exists = registerFunktion(i)
        if exists then
            local o = {}
            o.id = i
            --o.position = val
            table.insert(list[trackName], o)
        end
    end
end

local function registerTracks()
    registerTracksBy(EEPRegisterAuxiliaryTrack, "auxiliaryTracks")
    registerTracksBy(EEPRegisterControlTrack, "controlTracks")
    registerTracksBy(EEPRegisterRoadTrack, "roadTracks")
    registerTracksBy(EEPRegisterRailTrack, "railTracks")
    registerTracksBy(EEPRegisterTramTrack, "tramTracks")
end



local function outputTracksBy(besetztFunktion, trackName, fahrzeugListe)
    local vehicles = {}
    local belegte = {}
    belegte.tracks = {}

    for _, track in pairs(list[trackName]) do
        local trackId = track.id
        local exists, occupied, vehicleName = besetztFunktion(trackId, true)
        track.occupied = occupied
        track.occupiedBy = vehicleName
        if occupied then
            local key = trackName .. "_track_" .. trackId
            belegte.tracks[key] = {}
            belegte.tracks[key].trackId = trackId
            belegte.tracks[key].occupied = occupied
            belegte.tracks[key].vehicle = vehicleName

            vehicles[vehicleName] = vehicles[vehicleName] or {}
            vehicles[vehicleName].trackType = trackName
            vehicles[vehicleName].onTrack = trackId
            vehicles[vehicleName].occupiedTacks = vehicles[vehicleName].occupiedTacks or {}
            table.insert(vehicles[vehicleName].occupiedTacks, trackId)
        end
    end

    list[fahrzeugListe] = {}
    for vehicleName, vehicle in pairs(vehicles) do
        local o = {
            id = vehicleName,
            occupiedTracks = vehicle.occupiedTracks,
            trackType = vehicle.trackType,
            onTrackId = vehicle.onTrack
        }
        table.insert(list[fahrzeugListe], o)
    end
end

local function outputTracks()
    outputTracksBy(EEPIsAuxiliaryTrackReserved, "auxiliaryTracks", "auxiliaryVehicles")
    outputTracksBy(EEPIsControlTrackReserved, "controlTracks", "controlVehicles")
    outputTracksBy(EEPIsRoadTrackReserved, "roadTracks", "roadVehicles")
    outputTracksBy(EEPIsRailTrackReserved, "railTracks", "railVehicles")
    outputTracksBy(EEPIsTramTrackReserved, "tramTracks", "tramVehicles")
end




local function initialize()
    registerTracks()
end

local i = -1
local writeLater = {}
function AkStatistik.statistikAusgabe()
    if i == -1 then
        initialize();
    end

    -- Increase
    i = i + 1

    -- Do nothing
    if i % 50 == 0 then
        outputSignals()
        outputSwitches()
        outputTracks()

        for key, value in pairs(writeLater) do
            list[key] = value
        end

        AkCommunicator.send("db", json.encode(list))
        writeLater = {}
    end
end

function AkStatistik.writeLater(key, value)
    writeLater[key] = value
end
