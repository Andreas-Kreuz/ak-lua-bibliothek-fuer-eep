local AkWebServerIo = require("ak.io.AkWebServerIo")
print("Lade ak.io.AkStatistik ...")

local AkDataSlots = require("ak.data.AkDataSlots")

local os = require("os")
local json = require("ak.io.dkjson")

local AkStatistik = {}
AkStatistik.programVersion = "0.8.3 mod"
local MAX_SIGNALS = 1000
local MAX_SWITCHES = 1000
local MAX_TRACKS = 50000
local MAX_STRUCTURES = 50000
local data = {}

local function fillTime()
-- do it frequently
	data["times"] = { {
		name = "times",					-- EEP-Web requires that data entries have an id or name tag 
		timeComplete = EEPTime,			-- seconds since midnight
		timeH = EEPTimeH,
		timeM = EEPTimeM,
		timeS = EEPTimeS,
	}}
end

local function fillEEPVersion()
-- do it once
    data["eep-version"] = { versionInfo = {				-- EEP-Web expects an named entry here 
		name = "versionInfo",							-- EEP-Web requires that data entries have an id or name tag 
		eepVersion = string.format("%.1f", EEPVer),		-- show string instead of float
		luaVersion = _VERSION,
		singleVersion = { AkStatistik = AkStatistik.programVersion, },	-- Web-EEP does not show this object value
	}}
end

local function fillSaveSlots()
    data["save-slots"] = AkDataSlots.fillApiV1()
--	data["free-slots"] = AkDataSlots.fillFreeSlotsApiV1()	-- omit free slots to save space
end

local function registerSignals()
-- do it once
    data["signals"] = {}
    for i = 1, MAX_SIGNALS do
        local val = EEPGetSignal(i)
        if val > 0 then			-- yes, this is a signal
            local signal = {}
            signal.id = i
            table.insert(data["signals"], signal)
        end
    end
end

local function fillSignals()
-- do it frequently
    data["waiting-on-signals"] = {}
    for i = 1, #data["signals"] do
		local signal = data["signals"][i]
		signal.position = EEPGetSignal(signal.id)
		local waitingVehiclesCount = 0;
		if EEPVer >= 13.2 then
			waitingVehiclesCount = EEPGetSignalTrainsCount(signal.id)
		end
		signal.waitingVehiclesCount = waitingVehiclesCount

		if (waitingVehiclesCount > 0) then
			for position = 1, waitingVehiclesCount do
				local vehicleName = ""; 
				if EEPVer >= 13.2 then
					vehicleName = EEPGetSignalTrainName(signal.id, position)
				end	
				local waiting = {
					id = signal.id .. "-" .. position,
					signalId = signal.id,
					waitingPosition = position,
					vehicleName = vehicleName,
					waitingCount = waitingVehiclesCount
				}
				table.insert(data["waiting-on-signals"], waiting)
			end
		end
    end
end

local function registerSwitches()
-- do it once
    data["switches"] = {}
    for id = 1, MAX_SWITCHES do
        local val = EEPGetSwitch(id)
        if val > 0 then			-- yes, this is a switch
            local switch = {}
            switch.id = id
            table.insert(data["switches"], switch)
        end
    end
end

local function fillSwitches()
-- do it frequently
    for i = 1, #data["switches"] do
		local switch = data["switches"][i]
        switch.position = EEPGetSwitch(switch.id)
    end
end

local function registerTracksBy(registerFunktion, trackType)
-- do it once
    local trackName = trackType .. "-tracks"
    data[trackName] = {}
    for id = 1, MAX_TRACKS do
        local exists = registerFunktion(id)
        if exists then
            local track = {}
            track.id = id
            --track.position = val
            data[trackName][tostring(track.id)] = track
        end
    end
end

local function registerTracks()
-- do it once
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
			speed = haveSpeed and speed --string.format("%.2f", speed)
						or 0,
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

            if EEPVer >= 14.2 then
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
				length = length, --string.format("%.2f", length),
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
				trackDistance = trackDistance, --string.format("%.2f", trackDistance),
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

local function registerStructures()
    data["structures"] = {}
    for i = 0, MAX_STRUCTURES do
        local name = "#" .. tostring(i)

		local hasLight, light = EEPStructureGetLight(name)
		local hasSmoke, smoke = EEPStructureGetSmoke(name)
		local hasFire, fire = EEPStructureGetFire(name)

		if hasLight or hasSmoke or hasFire then
			local structure = {}
            structure.name = name
			
			local pos_x, pos_y, pos_z = 0, 0, 0
			local modelType = 0
			local tag = ''
			local _
			if (EEPVer >= 14.2) then
				_, pos_x, pos_y, pos_z = EEPStructureGetPosition(name)
				_, modelType = EEPStructureGetModelType(name)
					-- 16 = Tracks/Track objects
					-- 17 = Tramtracks/Tramtrack objects
					-- 18 = Streets/Street objects
					-- 19 = Other/Other objects
					-- 22 = Real estate
					-- 23 = landscape elements/Fauna
					-- 24 = landscape elements/Flora
					-- 25 = landscape elements/Terra
					-- 38 = landscape elements/Instancing			
				_, tag = EEPStructureGetTagText(name)
			end
			structure.pos_x = pos_x --string.format("%.2f", pos_x)
			structure.pos_y = pos_y --string.format("%.2f", pos_y)
			structure.pos_z = pos_z --string.format("%.2f", pos_z)
			structure.modelType = modelType
			structure.tag = tag
			table.insert(data["structures"], structure)
		end
    end
end

local function fillStructures()
    for i = 1, #data["structures"] do
		local structure = data["structures"][i]

		local _, light = EEPStructureGetLight(structure.name)
		local _, smoke = EEPStructureGetSmoke(structure.name)
		local _, fire = EEPStructureGetFire(structure.name)

		structure.light = light
		structure.smoke = smoke
		structure.fire = fire
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
function AkStatistik.statistikAusgabe(modulus)
-- call this function in main loop 

 	-- default value for optional parameter
   if not modulus or type(modulus) ~= "number" then
        modulus = 5
    end

	-- initialization in first call
    if i == -1 then
        initialize();
    end
    i = i + 1

	-- process commands 
    AkWebServerIo.processNewCommands()

    -- export data regularly
    if i % modulus == 0 then
        local t0 = os.clock()	-- milliseconds precision
		
		fillTime()
		fillStructures()

		fillSignals()
		fillSwitches()
		fillTracks()
		fillTrainYards()	-- not implemented yet

		fillSaveSlots()		--let's omit Slots for now

		-- add delayed data
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
        AkWebServerIo.updateJsonFile(json.encode(data, {
            keyorder = topLevelEntries,
        }))
		
		-- clear delayed data
        writeLater = {}
		
        local t2 = os.clock()
		print("AkStatistik:" 
			.. " fill: "  .. string.format("%.2f", t1-t0) .. " sec,"
			.. " store: " .. string.format("%.2f", t2-t1) .. " sec"
			)

        local timeDiff = t2 - t0
        if timeDiff > 1 then
            print("WARNUNG: AkStatistik.statistikAusgabe schreiben dauerte " .. string.format("%.2f", timeDiff)
                    .. " Sekunden (nur interessant, wenn EEP nicht pausiert wurde)")
        end
    end
end

-- store delayed data (where is this used?)
function AkStatistik.writeLater(key, value)
    writeLater[key] = value
end

return AkStatistik