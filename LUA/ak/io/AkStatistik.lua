--- Export EEP data / read and execute commands.
-- LuaDoc: http://keplerproject.github.io/luadoc/manual.html
--
--[[ Usage:
--Load library
local AkStatistik = require("ak.io.AkStatistik")

-- Clean log file after loading the library
clearlog()

-- Show version
print('AkStatistik Version ' .. AkStatistik.programVersion)

-- Allow to update the json file without checking if the Web Server is ready
AkStatistik.checkServerStatus     = false

-- Choose data (default = true)
AkStatistik.fillSaveSlots        = false
AkStatistik.fillSignals            = false
AkStatistik.fillSwitches        = false
AkStatistik.fillTracks            = false
AkStatistik.fillTrains            = true    -- trains and rolling stocks
AkStatistik.fillStructures        = false
AkStatistik.fillTrainYards        = false

local repeatCycles = 1
function EEPMain()
  --AkStatistik.writeLater(key, value) -- add additional data to output file
  AkStatistik.statistikAusgabe(repeatCycles) -- optional parameter
  return 1
end
--]]
-- @author Andreas Kreuz
-- @release 0.8.4
local AkWebServerIo = require("ak.io.AkWebServerIo")
print("Lade ak.io.AkStatistik ...")

local AkDataSlots = require("ak.data.AkDataSlots")

local os = require("os")
local json = require("ak.io.dkjson")

local AkStatistik = {}
AkStatistik.programVersion = "0.8.4"

-- checkServerStatus:
-- false: Update json file without checking if the EEP-Web Server is ready
-- true: Check status of EEP-Web Server before updating the json file
AkStatistik.checkServerStatus = true
-- Default settings to choose which data should be exported via the json file
AkStatistik.fillSaveSlots = true
AkStatistik.fillSignals = true
AkStatistik.fillSwitches = true
AkStatistik.fillTracks = true
AkStatistik.fillTrains = true -- trains and rolling stocks
AkStatistik.fillStructures = true
AkStatistik.fillTrainYards = true

local MAX_SIGNALS = 1000
local MAX_SWITCHES = 1000
local MAX_TRACKS = 50000
local MAX_STRUCTURES = 50000
local data = {}
local tracks = {}

--- Create dummy functions for EEP functions which are not yet available depending of the version of EEP
-- The minimal required version is EEP 11.3 Plug-In 3 which supports some quite important functions
EEPGetSignalTrainsCount = EEPGetSignalTrainsCount or function()
        return
    end -- EEP 13.2
EEPGetSignalTrainName = EEPGetSignalTrainName or function()
        return
    end -- EEP 13.2

-- Based on this concept we can redefine the functions, e.g. to collect some statistics data
--EEPGetRollingstockItemsCount = EEPGetRollingstockItemsCount  or function () return end -- EEP 13.2 Plug-In 2
local _EEPGetRollingstockItemsCount = EEPGetRollingstockItemsCount
local function _EEPGetRollingstockItemsCount(...)
    if not _EEPGetRollingstockItemsCount then
        return
    end

    local t0 = os.clock()

    local result = {_EEPGetRollingstockItemsCount(...)}

    local t1 = os.clock()
    local runTime = data["times"][1].EEPGetRollingstockItemsCount or {n = 0, t = 0}
    runTime.n = runTime.n + 1
    runTime.t = runTime.t + t1 - t0

    return table.unpack(result)
end

EEPGetRollingstockItemName = EEPGetRollingstockItemName or function()
        return
    end -- EEP 13.2 Plug-In 2
EEPGetTrainLength = EEPGetTrainLength or function()
        return
    end -- EEP 15.1 Plug-In 1

EEPRollingstockGetPosition = EEPRollingstockGetPosition or function()
        return
    end -- EEP 16.1
EEPRollingstockGetLength = EEPRollingstockGetLength or function()
        return
    end -- EEP 14.2
EEPRollingstockGetMotor = EEPRollingstockGetMotor or function()
        return
    end -- EEP 14.2
EEPRollingstockGetTrack = EEPRollingstockGetTrack or function()
        return
    end -- EEP 14.2
EEPRollingstockGetModelType = EEPRollingstockGetModelType or function()
        return
    end -- EEP 14.2
EEPRollingstockGetTagText = EEPRollingstockGetTagText or function()
        return
    end -- EEP 14.2

EEPStructureGetPosition = EEPStructureGetPosition or function()
        return
    end -- EEP 14.2
EEPStructureGetModelType = EEPStructureGetModelType or function()
        return
    end -- EEP 14.2
EEPStructureGetTagText = EEPStructureGetTagText or function()
        return
    end -- EEP 14.2

--- Get EEP time and store it.
-- do it frequently
local function fillTime()
    data["times"] = {
        {
            name = "times", -- EEP-Web requires that data entries have an id or name tag
            timeComplete = EEPTime, -- seconds since midnight
            timeH = EEPTimeH,
            timeM = EEPTimeM,
            timeS = EEPTimeS
        }
    }
end

--- Get EEP version and store it.
-- do it once
local function fillEEPVersion()
    data["eep-version"] = {
        versionInfo = {
            -- EEP-Web expects a named entry here
            name = "versionInfo", -- EEP-Web requires that data entries have an id or name tag
            eepVersion = string.format("%.1f", EEPVer), -- show string instead of float
            luaVersion = _VERSION,
            singleVersion = {AkStatistik = AkStatistik.programVersion} -- Web-EEP does not show this object value
        }
    }
end

--- Get EEP slots and store them.
-- do it frequently
local function fillSaveSlots()
    if not AkStatistik.fillSaveSlots then
        return
    end

    data["save-slots"] = AkDataSlots.fillApiV1()
    data["free-slots"] = AkDataSlots.fillFreeSlotsApiV1() -- you may want to omit free slots to save space
end

--- Register EEP signals.
-- do it once
local function registerSignals()
    if not AkStatistik.fillSignals then
        return
    end

    data["signals"] = {}
    for i = 1, MAX_SIGNALS do
        local val = EEPGetSignal(i)
        if val > 0 then -- yes, this is a signal
            local signal = {}
            signal.id = i
            table.insert(data["signals"], signal)
        end
    end
end

--- Get EEP signals and store them.
-- do it frequently
local function fillSignals()
    if not AkStatistik.fillSignals then
        return
    end

    data["waiting-on-signals"] = {}
    for i = 1, #data["signals"] do
        local signal = data["signals"][i]
        signal.position = EEPGetSignal(signal.id)
        local waitingVehiclesCount = EEPGetSignalTrainsCount(signal.id) -- EEP 13.2
        signal.waitingVehiclesCount = waitingVehiclesCount or 0

        if waitingVehiclesCount then
            for position = 1, waitingVehiclesCount do
                local vehicleName = EEPGetSignalTrainName(signal.id, position) -- EEP 13.2
                local waiting = {
                    id = signal.id .. "-" .. position,
                    signalId = signal.id,
                    waitingPosition = position,
                    vehicleName = vehicleName or "",
                    waitingCount = waitingVehiclesCount
                }
                table.insert(data["waiting-on-signals"], waiting)
            end
        end
    end
end

--- Register EEP switches.
-- do it once
local function registerSwitches()
    if not AkStatistik.fillSwitches then
        return
    end

    data["switches"] = {}
    for id = 1, MAX_SWITCHES do
        local val = EEPGetSwitch(id)
        if val > 0 then -- yes, this is a switch
            local switch = {}
            switch.id = id
            table.insert(data["switches"], switch)
        end
    end
end

--- Get EEP switches and store them.
-- do it frequently
local function fillSwitches()
    if not AkStatistik.fillSwitches then
        return
    end

    for i = 1, #data["switches"] do
        local switch = data["switches"][i]
        switch.position = EEPGetSwitch(switch.id)
    end
end

--- Register EEP tracks.
-- The main reason for this is to be able to retrieve the names and positions of all trains and rolling stocks.
-- do it once
local function registerTracksBy(registerFunktion, trackType)
    local trackName = trackType .. "-tracks"
    tracks[trackName] = {}
    if (AkStatistik.fillTracks) then
        data[trackName] = tracks[trackName]
    end
    for id = 1, MAX_TRACKS do
        local exists = registerFunktion(id)
        if exists then
            local track = {}
            track.id = id
            --track.position = val
            tracks[trackName][tostring(track.id)] = track
        end
    end
end

local function registerTracks()
    if not (AkStatistik.fillTracks or AkStatistik.fillTrains) then
        return
    end

    -- do it once
    registerTracksBy(EEPRegisterAuxiliaryTrack, "auxiliary")
    registerTracksBy(EEPRegisterControlTrack, "control")
    registerTracksBy(EEPRegisterRoadTrack, "road")
    registerTracksBy(EEPRegisterRailTrack, "rail")
    registerTracksBy(EEPRegisterTramTrack, "tram")
end

--- Get EEP rolling stocks and trains located on tracks.
-- do it frequently
local function fillTracksBy(besetztFunktion, trackType)
    local trackName = trackType .. "-tracks"
    local trainList = trackType .. "-trains"
    local rollingStockList = trackType .. "-rolling-stocks"
    local trainInfos = trackType .. "-train-infos-dynamic"
    local rollingStockInfos = trackType .. "-rolling-stock-infos-dynamic"

    -- Find trains on occupied tracks
    -- Limitation: only the first train on a track is found
    local trains = {}
    --local belegte = {}
    --belegte.tracks = {}
    for _, track in pairs(tracks[trackName]) do
        local trackId = track.id
        -- Limitation: only the first train on a track is found
        local _, occupied, trainName = besetztFunktion(trackId, true)

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

    -- Add previously known trains which are not found by EEPIs..TrackReserved which happens
    -- if there are multiple trains on a track
    if data[trainInfos] then
        for _, trainsInfo in ipairs(data[trainInfos]) do
            local trainName = trainsInfo.id
            if not trains[trainName] then
                -- Does the train exists?
                local haveSpeed = EEPGetTrainSpeed(trainName) -- EEP 11.0
                if haveSpeed then
                    -- print('Train not found by EEPIs..TrackReserved: ' .. trainName)
                    trains[trainName] = {
                        trackType = trackName,
                        onTrack = trainsInfo.onTrackId,
                        occupiedTacks = trainsInfo.occupiedTacks
                    }
                end
            end
        end
    end

    -- Get and store additional information about trains and rolling stocks
    -- Possible performance improvement: Do not start from scratch but keep static information from functions like
    -- EEPRollingstockGetLength, EEPRollingstockGetMotor, EEPRollingstockGetModelType
    data[trainList] = {}
    data[trainInfos] = {}
    data[rollingStockList] = {}
    data[rollingStockInfos] = {}

    for trainName, train in pairs(trains) do
        -- Store trains
        local haveSpeed, speed = EEPGetTrainSpeed(trainName) -- EEP 11.0
        local haveRoute, route = EEPGetTrainRoute(trainName) -- EEP 11.2 Plugin 2

        local rollingStockCount = EEPGetRollingstockItemsCount(trainName) -- EEP 13.2 Plug-In 2
        local hasTrainLength, trainLength = EEPGetTrainLength(trainName) -- EEP 15.1 Plug-In 1

        local currentTrain = {
            id = trainName,
            route = haveRoute and route or "",
            rollingStockCount = rollingStockCount or 0,
            length = trainLength or 0
        }

        table.insert(data[trainList], currentTrain)
        -- data[trainList][tostring(currentTrain.id)] = currentTrain
        local trainsInfo = {
            id = trainName,
            speed = haveSpeed and speed or --string.format("%.2f", speed)
                0,
            onTrackId = train.onTrack,
            occupiedTacks = train.occupiedTacks
        }
        table.insert(data[trainInfos], trainsInfo)
        -- data[trainInfos][tostring(trainsInfo.id)] = trainsInfo

        -- Store rolling stocks
        if not rollingStockCount then
            return
        end

        for i = 0, (rollingStockCount - 1) do
            local rollingStockName = EEPGetRollingstockItemName(trainName, i) -- EEP 13.2 Plug-In 2
            if rollingStockName then
                local _, couplingFront = EEPRollingstockGetCouplingFront(rollingStockName) -- EEP 11.0
                local _, couplingRear = EEPRollingstockGetCouplingRear(rollingStockName) -- EEP 11.0
                -- 1 Kupplung scharf, 2 Abstoßen, 3 Gekuppelt
                local hasPos, PosX, PosY, PosZ = EEPRollingstockGetPosition(rollingStockName) -- EEP 16.1

                local hasLength, length = EEPRollingstockGetLength(rollingStockName) -- EEP 15
                if not hasTrainLength and hasLength then
                    currentTrain.length = currentTrain.length + length
                end

                local _, propelled = EEPRollingstockGetMotor(rollingStockName) -- EEP 14.2
                local _, trackId, trackDistance, trackDirection, trackSystem = EEPRollingstockGetTrack(rollingStockName)
                -- EEP 14.2

                local _, modelType = EEPRollingstockGetModelType(rollingStockName) -- EEP 14.2
                local EEPRollingstockModelTypeText = {
                    -- not used yet
                    ["1"] = "Tenderlok",
                    ["2"] = "Schlepptenderlok",
                    ["3"] = "Tender",
                    ["4"] = "Elektrolok",
                    ["5"] = "Diesellok",
                    ["6"] = "Triebwagen",
                    ["7"] = "U- oder S-Bahn",
                    ["8"] = "Straßenbahn",
                    ["9"] = "Güterwaggon",
                    ["10"] = "Personenwaggon",
                    ["11"] = "Luftfahrzeug",
                    ["12"] = "Maschine",
                    ["13"] = "Wasserfahrzeug",
                    ["14"] = "LKW",
                    ["15"] = "PKW"
                }

                local _, tag = EEPRollingstockGetTagText(rollingStockName) -- EEP 14.2

                local currentRollingStock = {
                    name = rollingStockName,
                    trainName = trainName,
                    positionInTrain = i,
                    couplingFront = couplingFront,
                    couplingRear = couplingRear,
                    length = length or -1, --string.format("%.2f", length),
                    propelled = propelled or true,
                    trackSystem = trackSystem or -1,
                    modelType = modelType or -1,
                    tag = tag or ""
                }
                if hasPos then
                    currentRollingStock.PosX = PosX
                    currentRollingStock.PosY = PosY
                    currentRollingStock.PosZ = PosZ
                end
                table.insert(data[rollingStockList], currentRollingStock)
                -- data[rollingStockList][currentRollingStock.name] = currentRollingStock
                local rollingStockInfo = {
                    name = rollingStockName,
                    trackId = trackId or -1,
                    trackDistance = trackDistance or -1, --string.format("%.2f", trackDistance),
                    trackDirection = trackDirection or -1
                }
                table.insert(data[rollingStockInfos], rollingStockInfo)
            -- data[rollingStockInfos][tostring(rollingStockInfo.name)] = rollingStockInfo
            end
        end
    end
end

local function fillTracks()
    if not (AkStatistik.fillTracks or AkStatistik.fillTrains) then
        return
    end

    fillTracksBy(EEPIsAuxiliaryTrackReserved, "auxiliary")
    fillTracksBy(EEPIsControlTrackReserved, "control")
    fillTracksBy(EEPIsRoadTrackReserved, "road")
    fillTracksBy(EEPIsRailTrackReserved, "rail")
    fillTracksBy(EEPIsTramTrackReserved, "tram")
end

--- Register EEP structures and get static data about them.
-- Filter them for structures which offer light, smore or fire actions.
-- do it once
local function registerStructures()
    if not AkStatistik.fillStructures then
        return
    end

    data["structures"] = {}
    for i = 0, MAX_STRUCTURES do
        local name = "#" .. tostring(i)

        local hasLight = EEPStructureGetLight(name) -- EEP 11.1 Plug-In 1
        local hasSmoke = EEPStructureGetSmoke(name) -- EEP 11.1 Plug-In 1
        local hasFire = EEPStructureGetFire(name) -- EEP 11.1 Plug-In 1

        if hasLight or hasSmoke or hasFire then
            local structure = {}
            structure.name = name

            local _, pos_x, pos_y, pos_z = EEPStructureGetPosition(name)
            local _, modelType = EEPStructureGetModelType(name)
            local EEPStructureModelTypeText = {
                -- not used yet
                ["16"] = "Gleis/Gleisobjekt",
                ["17"] = "Schiene/Gleisobjekt",
                ["18"] = "Straße/Gleisobjekt",
                ["19"] = "Sonstiges/Gleisobjekt",
                ["22"] = "Immobilie",
                ["23"] = "Landschaftselement/Fauna",
                ["24"] = "Landschaftselement/Flora",
                ["25"] = "Landschaftselement/Terra",
                ["38"] = "Landschaftselement/Instancing"
            }
            local _, tag = EEPStructureGetTagText(name)

            structure.pos_x = pos_x or 0 --string.format("%.2f", pos_x)
            structure.pos_y = pos_y or 0 --string.format("%.2f", pos_y)
            structure.pos_z = pos_z or 0 --string.format("%.2f", pos_z)
            structure.modelType = modelType or 0
            structure.tag = tag or ""
            table.insert(data["structures"], structure)
        end
    end
end

--- Get status of EEP structures.
-- do it frequently
local function fillStructures()
    if not AkStatistik.fillStructures then
        return
    end

    for i = 1, #data["structures"] do
        local structure = data["structures"][i]

        local _, light = EEPStructureGetLight(structure.name) -- EEP 11.1 Plug-In 1
        local _, smoke = EEPStructureGetSmoke(structure.name) -- EEP 11.1 Plug-In 1
        local _, fire = EEPStructureGetFire(structure.name) -- EEP 11.1 Plug-In 1

        structure.light = light
        structure.smoke = smoke
        structure.fire = fire
    end
end

local function fillTrainYards()
    if not AkStatistik.fillTrainYards then
        return
    end

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
            url = "/api/v1/" .. v,
            count = count,
            checksum = checksum,
            updated = true
        }
        table.insert(dataEntries, o)

        if o.name == "api-entries" then
            apiEntry = o
        end
    end

    if apiEntry then
        apiEntry.count = #dataEntries
    end

    data["api-entries"] = dataEntries
end

--- Initialize data.
-- do it once
local function initialize()
    print("AkStatistik: init")

    -- prepare data once
    registerSignals()
    registerSwitches()
    registerTracks()
    registerStructures()

    -- export data once
    fillEEPVersion()
end

local i = -1
local writeLater = {}
--- Main function of this module.
-- Call this function in main loop of EEP.
-- do it frequently
-- @param modulus Repetion frequency (1: every 200 ms, 5: every second, ...)
function AkStatistik.statistikAusgabe(modulus)
    -- default value for optional parameter
    if not modulus or type(modulus) ~= "number" then
        modulus = 5
    end

    -- initialization in first call
    if i == -1 then
        initialize()
    end
    i = i + 1

    -- process commands
    AkWebServerIo.processNewCommands()

    -- export data regularly
    if i % modulus == 0 and (not AkStatistik.checkServerStatus or AkWebServerIo.checkWebServer()) then
        local t0 = os.clock() -- milliseconds precision

        fillTime()
        fillStructures()

        fillSignals()
        fillSwitches()
        fillTracks() -- tracks, trains, and rolling stocks
        fillTrainYards() -- not implemented yet

        fillSaveSlots()

        -- add additional data
        for key, value in pairs(writeLater) do
            data[key] = value
        end

        -- add statistical data
        data["api-entries"] = {}
        local topLevelEntries = {}
        for k in pairs(data) do
            table.insert(topLevelEntries, k)
        end
        table.sort(topLevelEntries)
        data.apiV1 = fillApiV1(topLevelEntries)

        local t1 = os.clock()

        -- export data
        AkWebServerIo.updateJsonFile(
            json.encode(
                data,
                {
                    keyorder = topLevelEntries
                }
            )
        )

        -- clear additional data
        writeLater = {}

        local t2 = os.clock()

        local timeDiff = t2 - t0
        if timeDiff > 1 then
            print(
                "AkStatistik:" ..
                    " fill: " ..
                        string.format("%.2f", t1 - t0) ..
                            " sec," .. " store: " .. string.format("%.2f", t2 - t1) .. " sec"
            )
            print(
                "WARNUNG: AkStatistik.statistikAusgabe schreiben dauerte " ..
                    string.format("%.2f", timeDiff) .. " Sekunden (nur interessant, wenn EEP nicht pausiert wurde)"
            )
        end
    end
end

--- Store additional data in json file.
-- Call this function in your Lua script to store additional data in the json file.
-- @param key Key.
-- @param value Data.
function AkStatistik.writeLater(key, value)
    writeLater[key] = value
end

return AkStatistik
