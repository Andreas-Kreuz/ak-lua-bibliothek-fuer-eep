local AkWebServerIo = require("ak.io.AkWebServerIo")
print("Lade ak.io.AkStatistik ...")

local AkDataSlots = require("ak.data.AkDataSlots")
local os = require("os")
local json = require("ak.io.dkjson")

local AkStatistik = {}
AkStatistik.programVersion = "0.8.2"
local MAX_SIGNALS = 1000
local MAX_TRACKS = 50000
local MAX_STRUCTURES = 50000
local data = {}

local function fillTime()
    data["time"] = { times = {
        timeComplete = EEPTime;
        timeH = EEPTimeH;
        timeM = EEPTimeM;
        timeS = EEPTimeS;
    } }
end

local function fillEEPVersion()
    data["eep-version"] = { versionInfo = {
        eepVersion = EEPVer,
        luaVersion = AkStatistik.programVersion,
        singleVersion = {
            AkStatistik = AkStatistik.programVersion,
        } },
    }
end

local function fillSaveSlots()
    data["save-slots"] = AkDataSlots.fillApiV1()
end

local function fillSignals()
    data["signals"] = {}
    data["waiting-on-signals"] = {}
    for i = 1, MAX_SIGNALS do
        local val = EEPGetSignal(i)
        if val > 0 then
            local waitingVehiclesCount = 0;
            if EEPVer >= 13.2 then
                waitingVehiclesCount = EEPGetSignalTrainsCount(i)
            end
            local o = {}
            o.id = i
            o.position = val
            o.waitingVehiclesCount = waitingVehiclesCount
            table.insert(data["signals"], o)

            if (waitingVehiclesCount > 0) then
                for position = 1, waitingVehiclesCount do
                    local vehicleName = EEPGetSignalTrainName(i, position)
                    local waiting = {
                        id = o.id .. "-" .. position,
                        signalId = o.id,
                        waitingPosition = position,
                        vehicleName = vehicleName,
                        waitingCount = waitingVehiclesCount
                    }
                    table.insert(data["waiting-on-signals"], waiting)
                end
            end
        end
    end
end

local function fillSwitches()
    data["switches"] = {}
    for i = 1, MAX_SIGNALS do
        local val = EEPGetSignal(i)
        if val > 0 then
            local o = {}
            o.id = i
            o.position = val
            table.insert(data["switches"], o)
        end
    end
end

local function registerTracksBy(registerFunktion, trackType)
    local trackName = trackType .. "-tracks"
    data[trackName] = {}
    for i = 1, MAX_TRACKS do
        local exists = registerFunktion(i)
        if exists then
            local o = {}
            o.id = i
            --o.position = val
            data[trackName][tostring(o.id)] = o
        end
    end
end

local function registerTracks()
    registerTracksBy(EEPRegisterAuxiliaryTrack, "auxiliary")
    registerTracksBy(EEPRegisterControlTrack, "control")
    registerTracksBy(EEPRegisterRoadTrack, "road")
    registerTracksBy(EEPRegisterRailTrack, "rail")
    registerTracksBy(EEPRegisterTramTrack, "tram")
end



local function fillTracksBy(besetztFunktion, trackType)
    local trackName = trackType .. '-tracks'
    local trainList = trackType .. '-trains'
    local rollingStockList = trackType .. '-rolling-stocks'
    local trainInfos = trackType .. '-train-infos-dynamic'
    local rollingStockInfos = trackType .. '-rolling-stock-infos-dynamic'

    local trains = {}
    --local belegte = {}
    --belegte.tracks = {}

    for _, track in pairs(data[trackName]) do
        local trackId = track.id
        local occupied, trainName;
        if EEPVer >= 13.2 then
            local _
            _, occupied, trainName = besetztFunktion(trackId, true)
        else
            local _
            _, occupied, trainName = besetztFunktion(trackId)
        end
        -- track.occupied = occupied
        -- track.occupiedBy = trainName
        if occupied then
            --local key = trackName .. "_track_" .. trackId
            --belegte.tracks[key] = {}
            --belegte.tracks[key].trackId = trackId
            --belegte.tracks[key].occupied = occupied
            --belegte.tracks[key].vehicle = trainName or "?"

            if trainName then
                trains[trainName] = trains[trainName] or {}
                trains[trainName].trackType = trackName
                trains[trainName].onTrack = trackId
                trains[trainName].occupiedTacks = trains[trainName].occupiedTacks or {}
                trains[trainName].occupiedTacks[tostring(trackId)] = trackId
            end
        end
    end


    data[trainList] = {}
    data[rollingStockList] = {}
    data[trainInfos] = {}
    data[rollingStockInfos] = {}
    for trainName, train in pairs(trains) do
        local haveSpeed, speed = EEPGetTrainSpeed(trainName)
        local haveRoute, route = EEPGetTrainRoute(trainName)
        local rollingStockCount = 1
        if EEPVer >= 13.2 then
            rollingStockCount = EEPGetRollingstockItemsCount(trainName)
        end

        local currentTrain = {
            id = trainName,
            route = haveRoute and route or '',
            rollingStockCount = rollingStockCount,
        }

        table.insert(data[trainList], currentTrain)
        -- data[trainList][tostring(currentTrain.id)] = currentTrain
        local trainsInfo = {
            id = trainName,
            speed = haveSpeed and speed or 0,
            onTrackId = train.onTrack,
            occupiedTacks = train.occupiedTacks,
        }
        table.insert(data[trainInfos], trainsInfo)
        -- data[trainInfos][tostring(trainsInfo.id)] = trainsInfo

        for i = 0, (rollingStockCount - 1) do
            local rollingStockName = "?"
            local couplingFront
            local couplingRear
            local _
            if EEPVer >= 13.2 then
                rollingStockName = EEPGetRollingstockItemName(trainName, i)
                _, couplingFront = EEPRollingstockGetCouplingFront(rollingStockName)
                _, couplingRear = EEPRollingstockGetCouplingRear(rollingStockName)
            else
                couplingFront = true
                couplingRear = true
            end

            local length = -1
            local propelled = true
            local trackId = -1
            local trackDistance = -1
            local trackDirection = -1
            local trackSystem = -1
            local modelType = -1
            local tag = ''

            if EEPVer >= 15 then
                _, length = EEPRollingstockGetLength(rollingStockName)
                _, propelled = EEPRollingstockGetMotor(rollingStockName)
                _, trackId, trackDistance, trackDirection, trackSystem = EEPRollingstockGetTrack(rollingStockName)
                _, modelType = EEPRollingstockGetModelType(rollingStockName)
                _, tag = EEPRollingstockGetTagText(rollingStockName)
            end

            local currentRollingStock = {
                name = rollingStockName,
                trainName = trainName,
                positionInTrain = i,
                couplingFront = couplingFront,
                couplingRear = couplingRear,
                length = length,
                propelled = propelled,
                trackSystem = trackSystem,
                modelType = modelType,
                tag = tag,
            }
            table.insert(data[rollingStockList], currentRollingStock)
            -- data[rollingStockList][currentRollingStock.name] = currentRollingStock
            local rollingStockInfo = {
                name = rollingStockName,
                trackId = trackId,
                trackDistance = trackDistance,
                trackDirection = trackDirection,
            }
            table.insert(data[rollingStockInfos], rollingStockInfo)
            -- data[rollingStockInfos][tostring(rollingStockInfo.name)] = rollingStockInfo
        end
    end
end

local function fillTracks()
    fillTracksBy(EEPIsAuxiliaryTrackReserved, "auxiliary")
    fillTracksBy(EEPIsControlTrackReserved, "control")
    fillTracksBy(EEPIsRoadTrackReserved, "road")
    fillTracksBy(EEPIsRailTrackReserved, "rail")
    fillTracksBy(EEPIsTramTrackReserved, "tram")
end

local function fillStructures()
    data["structures"] = {}
    for i = 0, MAX_STRUCTURES do
        local name = "#" .. tostring(i)
        local pos_x, pos_y, pos_z = 0, 0, 0
        local t, modelType = false, 0
        local tag = ''
        if (EEPVer >= 15) then
            local _
            _, pos_x, pos_y, pos_z = EEPStructureGetPosition(name)
            _, modelType = EEPStructureGetModelType(name)
            t, tag = EEPStructureGetTagText(name)
        end

        if (t) then
            local _, light = EEPStructureGetLight(name)
            local _, smoke = EEPStructureGetSmoke(name)
            local _, fire = EEPStructureGetFire(name)

            local o = {
                name = name,
                light = light,
                smoke = smoke,
                fire = fire,
                pos_x = pos_x,
                pos_y = pos_y,
                pos_z = pos_z,
                modelType = modelType,
                tag = tag,
            }
            table.insert(data["structures"], o)
        end
    end
end

local function fillTrainYards()
    -- TODO
end

local checksum = 0
local function fillApiV1(dataKeys)
    checksum = checksum + 1
    local dataEntries = {}
    local apiEntry
    for _, v in ipairs(dataKeys) do
        local count = 0
        for _ in pairs(data[v]) do
            count = count + 1
        end

        local o = {
            name = v,
            url = '/api/v1/' .. v,
            count = count,
            checksum = checksum,
            updated = true,
        }
        table.insert(dataEntries, o)

        if o.name == 'api-entries' then apiEntry = o end
    end

    if apiEntry then apiEntry.count = #dataEntries end

    data["api-entries"] = dataEntries
end

local function initialize()
    registerTracks()
end

local i = -1
local writeLater = {}
function AkStatistik.statistikAusgabe(modulus)
    AkWebServerIo.processNewCommands()
    if i == -1 then
        initialize();
    end

    -- Increase
    i = i + 1
    if not modulus or type(modulus) ~= "number" then
        modulus = 5
    end

    -- Do nothing
    if i % modulus == 0 then
        local t1 = os.time()
        fillTime()
        fillEEPVersion()
        fillStructures()

        fillSignals()
        fillSwitches()
        fillTracks()
        fillTrainYards()

        fillSaveSlots()

        for key, value in pairs(writeLater) do
            data[key] = value
        end

        data["api-entries"] = {}
        local topLevelEntries = {}
        for k in pairs(data) do
            table.insert(topLevelEntries, k)
        end
        table.sort(topLevelEntries)
        data.apiV1 = fillApiV1(topLevelEntries)

        AkWebServerIo.updateJsonFile(json.encode(data, {
            keyorder = topLevelEntries,
        }))
        writeLater = {}
        local t2 = os.time()
        local timeDiff = os.difftime(t2, t1)
        if timeDiff > 1 then
            print("WARNUNG: AkStatistik.statistikAusgabe schreiben dauerte " .. timeDiff
                    .. " Sekunden (nur interessant, wenn EEP nicht pausiert wurde)")
        end
    end
end

function AkStatistik.writeLater(key, value)
    writeLater[key] = value
end

return AkStatistik