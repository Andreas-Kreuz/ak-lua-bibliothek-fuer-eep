require "ak.io.AkCommunicator"
require "os"


AkStatistik = {}
local MAX_SIGNALS = 1000
local MAX_TRACKS = 50000
local MAX_STRUCTURES = 50000
local list = {}

local function fillTime()
    list.time = {
        time = EEPTime,
        timeH = EEPTimeH,
        timeM = EEPTimeM,
        timeS = EEPTimeS,
    }
end

local function fillEEPVersion()
    list.eepVersion = {
        EEPVer
    }
end

local function fillSignals()
    list.signals = {}
    list.waitingOnSignals = {}
    for i = 1, MAX_SIGNALS do
        local val = EEPGetSignal(i)
        if val > 0 then
            local waitingVehiclesCount = EEPGetSignalTrainsCount(i)
            local o = {}
            o.id = i
            o.position = val
            o.waitingVehiclesCount = waitingVehiclesCount
            table.insert(list.signals, o)

            if (waitingVehiclesCount > 0) then
                for position = 1, waitingVehiclesCount do
                    local vehicleName = EEPGetSignalTrainName(i, position)
                    table.insert(list.waitingOnSignals, {
                        signalId = o.id,
                        waitingPosition = position,
                        vehicleName = vehicleName,
                        waitingCount = waitingVehiclesCount
                    })
                end
            end
        end
    end
end

local function fillSwitches()
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



local function fillTracksBy(besetztFunktion, trackName, trainList, rollingStockList)
    local trains = {}
    local belegte = {}
    belegte.tracks = {}

    for _, track in pairs(list[trackName]) do
        local trackId = track.id
        local exists, occupied, trainName = besetztFunktion(trackId, true)
        track.occupied = occupied
        track.occupiedBy = trainName
        if occupied then
            local key = trackName .. "_track_" .. trackId
            belegte.tracks[key] = {}
            belegte.tracks[key].trackId = trackId
            belegte.tracks[key].occupied = occupied
            belegte.tracks[key].vehicle = trainName

            trains[trainName] = trains[trainName] or {}
            trains[trainName].trackType = trackName
            trains[trainName].onTrack = trackId
            trains[trainName].occupiedTacks = trains[trainName].occupiedTacks or {}
            table.insert(trains[trainName].occupiedTacks, trackId)
        end
    end

    list[trainList] = {}
    list[rollingStockList] = {}
    for trainName, train in pairs(trains) do
        haveSpeed, speed = EEPGetTrainSpeed(trainName)
        haveRoute, route = EEPGetTrainRoute(trainName)
        rollingStockCount = EEPGetRollingstockItemsCount(trainName)

        local o = {
            id = trainName,
            occupiedTracks = train.occupiedTracks,
            trackType = train.trackType,
            onTrackId = train.onTrack,
            speed = haveSpeed and speed or 0,
            route = haveRoute and route or '',
            rollingStockCount = rollingStockCount,
        }
        table.insert(list[trainList], o)

        for i = 0, (rollingStockCount - 1) do
            local rollingStockName = EEPGetRollingstockItemName(trainName, i)
            t, couplingFront = EEPRollingstockGetCouplingFront(rollingStockName)
            t, couplingRear = EEPRollingstockGetCouplingRear(rollingStockName)
            if EEPVer < 15 then
                length = -1
                propelled = true
                trackId = -1
                trackDistance = -1
                trackDirection = -1
                trackSystem = -1
                modelType = -1
            else
                t, length = EEPRollingstockGetLength(rollingStockName)
                t, propelled = EEPRollingstockGetMotor(rollingStockName)
                t, trackId, trackDistance, trackDirection, trackSystem = EEPRollingstockGetTrack(rollingStockName)
                t, modelType = EEPRollingstockGetModelType(rollingStockName)
            end

            local o = {
                name = rollingStockName,
                trainName = trainName,
                positionInTrain = i,
                couplingFront = couplingFront,
                couplingRear = couplingRear,
                length = length,
                propelled = propelled,
                trackId = trackId,
                trackDistance = trackDistance,
                trackDirection = trackDirection,
                trackSystem = trackSystem,
                modelType = modelType,
            }
            table.insert(list[rollingStockList], o)
        end
    end
end

local function fillTracks()
    fillTracksBy(EEPIsAuxiliaryTrackReserved, "auxiliaryTracks", "auxiliaryTrain", "auxiliaryRollingStock")
    fillTracksBy(EEPIsControlTrackReserved, "controlTracks", "controlTrain", "controlRollingStock")
    fillTracksBy(EEPIsRoadTrackReserved, "roadTracks", "roadTrain", "roadRollingStock")
    fillTracksBy(EEPIsRailTrackReserved, "railTracks", "railTrain", "railRollingStock")
    fillTracksBy(EEPIsTramTrackReserved, "tramTracks", "tramTrain", "tramRollingStock")
end

local function fillStructures()
    list.structures = {}
    for i = 0, MAX_STRUCTURES do
        local name = "#" .. tostring(i)
        local t = true
        local t, pos_x, pos_y, pos_z = false, 0, 0, 0
        local t, modelType = false, 0
        if (EEPVer >= 15) then
            t, pos_x, pos_y, pos_z = EEPStructureGetPosition(name)
            t, modelType = EEPStructureGetModelType(name)
        end

        if (t) then
            local t, light = EEPStructureGetLight(name)
            local t, smoke = EEPStructureGetSmoke(name)
            local t, fire = EEPStructureGetFire(name)



            local o = {
                name = name,
                light = light,
                smoke = smoke,
                fire = fire,
                pos_x = pos_x,
                pos_y = pos_y,
                pos_z = pos_z,
                modelType = modelType,
            }
            table.insert(list.structures, o)
        end
    end
end

local function fillTrainYards()
    -- TODO
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
    if i % 5 == 0 then
        local t1 = os.time()
        fillTime()
        fillEEPVersion()
        fillStructures()

        fillSignals()
        fillSwitches()
        fillTracks()
        fillTrainYards()

        for key, value in pairs(writeLater) do
            list[key] = value
        end

        AkCommunicator.send("db", json.encode(list))
        writeLater = {}
        local t2 = os.time()
        print(os.difftime(t2,t1))
    end
end

function AkStatistik.writeLater(key, value)
    writeLater[key] = value
end
