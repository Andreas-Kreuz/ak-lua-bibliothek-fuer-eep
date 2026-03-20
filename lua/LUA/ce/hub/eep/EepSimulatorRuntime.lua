if AkDebugLoad then print("[#Start] Loading ce.hub.eep.EepSimulatorRuntime ...") end

local Store = require("ce.hub.eep.EepSimulatorStore")
local state = Store.state

local function createEmptyTable() return {} end

local function createTrackState()
    return { registered = true, occupiedTrainName = "" }
end

local function createTrainState()
    return {
        currentSpeed = 0,
        targetSpeed = 0,
        routeName = nil,
        rollingstockEntries = {},
        lightEnabledBySource = {},
        smokeEnabled = false,
        hornEnabled = false,
        couplingFront = 1,
        couplingRear = 1,
        hookEnabled = false,
        cameraPosition = nil,
        isOnLayout = true
    }
end

local function createTrainyardState()
    return { entries = {} }
end

local function emitGlobalCallback(globals, callbackName, ...)
    local callback = globals[callbackName]
    if type(callback) ~= "function" then return false end
    return true, callback(...)
end

local function emitIndexedCallback(globals, callbackPrefix, id, ...)
    local callback = globals[callbackPrefix .. id]
    if type(callback) ~= "function" then return false end
    return true, callback(...)
end

local function create(simulator, globals)
    local Runtime = {}
    globals = globals or _G

    local function registerTrack(trackType, trackId)
        local track = Store.ensurePath(state, { "tracks", trackType, trackId }, createTrackState)
        track.registered = true
        if trackId <= 11 then return true end
    end

    ---@param trackType string
    ---@param trackId number
    ---@param returnTrainName boolean|nil
    ---@return boolean, boolean, string|nil
    local function isTrackReserved(trackType, trackId, returnTrainName)
        local tracksByType = state.tracks[trackType] or {}
        local track = tracksByType[trackId]
        local registered = track ~= nil and track.registered == true or false
        local occupied = registered and track.occupiedTrainName ~= "" or false

        if returnTrainName then return registered, occupied, registered and track.occupiedTrainName or nil end

        return registered, occupied
    end

    ---@param trackType string
    ---@param trackId number
    ---@param trainName string
    local function setTrackOccupancy(trackType, trackId, trainName)
        local track = Store.ensurePath(state, { "tracks", trackType, trackId }, createTrackState)
        track.registered = true
        track.occupiedTrainName = trainName
    end
    local function getTrainState(trainName) return state.trains[trainName] end

    ---@param rollingStock string|table
    ---@return table
    local function normalizeRollingStockEntry(rollingStock)
        if type(rollingStock) == "table" then
            rollingStock.frontForward = rollingStock.frontForward ~= false
            rollingStock.textureTextBySurfaceNumber = rollingStock.textureTextBySurfaceNumber or
                rollingStock.textureTexts or {}
            rollingStock.textureTexts = nil
            if rollingStock.tagText == nil and rollingStock.tag ~= nil then
                rollingStock.tagText = rollingStock.tag
            end
            rollingStock.tag = nil
            if rollingStock.hookEnabled == nil then rollingStock.hookEnabled = false end
            if rollingStock.fixedLoad == nil then rollingStock.fixedLoad = false end
            if rollingStock.userCamera == nil then rollingStock.userCamera = nil end
            return rollingStock
        end

        return {
            name = rollingStock,
            frontForward = true,
            couplingFront = nil,
            couplingRear = nil,
            tagText = nil,
            textureTextBySurfaceNumber = {},
            hookEnabled = false,
            fixedLoad = false,
            userCamera = nil
        }
    end

    ---@param train table
    ---@return table[]
    local function normalizeTrainRollingStockEntries(train)
        train.rollingstockEntries = train.rollingstockEntries or train.rollingStock or {}

        for index, rollingStock in ipairs(train.rollingstockEntries) do
            train.rollingstockEntries[index] = normalizeRollingStockEntry(rollingStock)
        end

        train.rollingStock = nil
        return train.rollingstockEntries
    end
    ---@param trainName string
    ---@return table[]
    local function getTrainRollingStock(trainName)
        local train = getTrainState(trainName)
        if not train then return {} end
        return normalizeTrainRollingStockEntries(train)
    end

    ---@param rollingStockName string
    ---@return table|nil, string|nil, number|nil, table[]|nil
    local function findRollingStockEntry(rollingStockName)
        for trainName, train in pairs(state.trains) do
            local rollingStocks = normalizeTrainRollingStockEntries(train)

            for index, rollingStock in ipairs(rollingStocks) do
                if rollingStock.name == rollingStockName then return rollingStock, trainName, index, rollingStocks end
            end
        end

        return nil, nil, nil, nil
    end

    ---@param rollingStockName string
    ---@return table
    local function getOrCreateImplicitRollingStockTrain(rollingStockName)
        local trainName = "#" .. rollingStockName
        local train = Store.ensurePath(state, { "trains", trainName }, createTrainState)
        local rollingStocks = getTrainRollingStock(trainName)

        if #rollingStocks == 0 then
            train.rollingstockEntries = { normalizeRollingStockEntry(rollingStockName) }
            train.isOnLayout = true
            Runtime.callEEPSetTrainSpeed(trainName, 0)
            rollingStocks = train.rollingstockEntries
        end

        return rollingStocks[1]
    end

    ---@param rollingStockName string
    ---@return table|nil, table|nil, table[]|nil, number|nil
    local function getRollingStockTrainContext(rollingStockName)
        local rollingStock, trainName, index, rollingStocks = findRollingStockEntry(rollingStockName)
        if not rollingStock then return nil, nil, nil, nil end

        return rollingStock, getTrainState(trainName), rollingStocks, index
    end

    ---@param rollingStockName string
    ---@return table
    local function getOrCreateRollingStockEntry(rollingStockName)
        return select(1, getRollingStockTrainContext(rollingStockName)) or
            getOrCreateImplicitRollingStockTrain(rollingStockName)
    end

    ---@param rollingStockName string
    ---@return string
    local function getUniqueRollingStockName(rollingStockName)
        if not select(1, getRollingStockTrainContext(rollingStockName)) then return rollingStockName end

        local suffix = 1
        while true do
            local candidate = string.format("%s;%03d", rollingStockName, suffix)
            if not select(1, getRollingStockTrainContext(candidate)) then return candidate end
            suffix = suffix + 1
        end
    end

    ---@param oldName string
    ---@param newName string
    local function renameTrainReferences(oldName, newName)
        for _, tracksByType in pairs(state.tracks) do
            for _, track in pairs(tracksByType) do
                if track.occupiedTrainName == oldName then track.occupiedTrainName = newName end
            end
        end

        for _, queue in pairs(state.signalQueues.trainNamesBySignalId) do
            for index, queuedTrainName in ipairs(queue) do
                if queuedTrainName == oldName then queue[index] = newName end
            end
        end

        for _, trainyard in pairs(state.trainyards) do
            for _, entry in ipairs(trainyard.entries) do
                if entry.trainName == oldName then entry.trainName = newName end
            end
        end

        if state.active.trainName == oldName then state.active.trainName = newName end


        if state.camera.selectedPerspectiveCamera and state.camera.selectedPerspectiveCamera.trainName == oldName then
            state.camera.selectedPerspectiveCamera.trainName = newName
        end
    end

    ---@param oldName string
    ---@param newName string
    local function renameRollingStockReferences(oldName, newName)
        if state.active.rollingstockName == oldName then state.active.rollingstockName = newName end
    end

    ---@param rollingStock table
    ---@param train table|nil
    ---@param side string
    ---@param trainEndStatus number|nil
    ---@return number
    local function getExposedCouplingStatus(rollingStock, train, side, trainEndStatus)
        local explicitStatus = rollingStock[side == "front" and "couplingFront" or "couplingRear"]
        if explicitStatus ~= nil then return explicitStatus end
        if trainEndStatus == 3 or trainEndStatus == 2 then return trainEndStatus end
        if train and trainEndStatus == 1 then return 2 end
        return 2
    end

    ---@param rollingStockName string
    ---@param side string
    ---@return boolean, number|nil
    local function getRollingStockCoupling(rollingStockName, side)
        local rollingStock, train, rollingStocks, index = getRollingStockTrainContext(rollingStockName)
        if not rollingStock then return false, nil end

        local pointsToTrainFront =
            side == "front" and rollingStock.frontForward
            or side == "rear" and not rollingStock.frontForward
        index = index or 1

        if pointsToTrainFront then
            if index > 1 then return true, 3 end
        elseif rollingStocks ~= nil and index < #rollingStocks then
            return true, 3
        end

        if pointsToTrainFront then
            return true, getExposedCouplingStatus(rollingStock, train, side, train and train.couplingFront or nil)
        end

        return true, getExposedCouplingStatus(rollingStock, train, side, train and train.couplingRear or nil)
    end

    ---@param trainName string
    ---@param trainEnd string
    ---@return string|nil, table|nil, string|nil
    local function getTrainEndRollingStock(trainName, trainEnd)
        local rollingStocks = getTrainRollingStock(trainName)
        if not rollingStocks or #rollingStocks == 0 then return nil, nil, nil end

        local rollingStock = trainEnd == "front" and rollingStocks[1] or rollingStocks[#rollingStocks]
        local rollingStockName = rollingStock.name

        if trainEnd == "front" then
            return rollingStockName, rollingStock, rollingStock.frontForward and "front" or "rear"
        end

        return rollingStockName, rollingStock, rollingStock.frontForward and "rear" or "front"
    end

    ---@param trainName string
    ---@param trainEnd string
    ---@param couplingStatus number
    local function setTrainEndCoupling(trainName, trainEnd, couplingStatus)
        local train = Store.ensurePath(state, { "trains", trainName }, createTrainState)

        if trainEnd == "front" then
            train.couplingFront = couplingStatus
        else
            train.couplingRear = couplingStatus
        end

        local _, rollingStock, side = getTrainEndRollingStock(trainName, trainEnd)
        if not rollingStock or not side then return end

        if side == "front" then
            rollingStock.couplingFront = couplingStatus
        else
            rollingStock.couplingRear = couplingStatus
        end
    end

    ---@param trainName string
    ---@param trainEnd string
    ---@return boolean, number|nil
    local function getTrainEndCoupling(trainName, trainEnd)
        local train = getTrainState(trainName)
        if not train then return false, 0 end

        local rollingStockName, rollingStock, side = getTrainEndRollingStock(trainName, trainEnd)
        if rollingStockName and rollingStock and side then
            local explicitStatus = side == "front" and rollingStock.couplingFront or rollingStock.couplingRear
            if explicitStatus ~= nil then return getRollingStockCoupling(rollingStockName, side) end
        end

        return true, trainEnd == "front" and train.couplingFront or train.couplingRear
    end
    local function findTrainyardEntry(depotId, trainName, position)
        local trainyard = state.trainyards[depotId]
        if not trainyard then return nil, nil end

        if position ~= nil then
            local entry = trainyard.entries[position + 1]
            if entry and (
                    trainName == nil
                    or trainName == ""
                    or entry.trainName == trainName
                ) then
                return entry, position + 1
            end
            return nil, nil
        end

        if trainName ~= nil and trainName ~= "" then
            for index, entry in ipairs(trainyard.entries) do
                if entry.trainName == trainName then return entry, index end
            end
        end

        return nil, nil
    end

    function Runtime.simulateAddTrain(trainName, ...)
        local train = Store.ensurePath(state, { "trains", trainName }, createTrainState)
        local existingRollingStock = {}

        for _, rollingStock in ipairs(getTrainRollingStock(trainName)) do
            existingRollingStock[rollingStock.name] = rollingStock
        end

        train.rollingstockEntries = {}
        for _, rollingStockName in ipairs({ ... }) do
            local rollingStock = existingRollingStock[rollingStockName] or normalizeRollingStockEntry(rollingStockName)
            table.insert(train.rollingstockEntries, rollingStock)
        end

        train.isOnLayout = true
        Runtime.callEEPSetTrainSpeed(trainName, 0)
    end

    function Runtime.simulateSplitTrain(trainName, index)
        local newName = trainName .. ";001"
        local oldTrain = Store.ensurePath(state, { "trains", trainName }, createTrainState)
        local sourceRollingStock = getTrainRollingStock(trainName)
        ---@type table[]
        local oldRs = {}
        ---@type table[]
        local newRs = {}

        for i, rollingStock in pairs(sourceRollingStock) do
            table.insert(i <= index and oldRs or newRs, rollingStock)
        end

        oldTrain.rollingstockEntries = oldRs
        local newTrain = Store.ensurePath(state, { "trains", newName }, createTrainState)
        newTrain.rollingstockEntries = newRs
        newTrain.isOnLayout = true
        Runtime.callEEPSetTrainSpeed(newName, 0)

        if oldTrain.routeName ~= nil then
            newTrain.routeName = oldTrain.routeName
        end

        if simulator.debug then
            local oldNames = {}
            local newNames = {}
            for _, rollingStock in ipairs(oldRs) do table.insert(oldNames, rollingStock.name) end
            for _, rollingStock in ipairs(newRs) do table.insert(newNames, rollingStock.name) end
            print(string.format("Old Train: %s    : %s\nNew Train: %s: %s", trainName, table.concat(oldNames, ","),
                                newName,
                                table.concat(newNames, ",")))
        end
        Runtime.emitOnTrainLooseCoupling(trainName, newName, trainName)
    end

    local function stripImmoName(name) return name:gsub("(#%d*).*", "%1") end


    ---@param train table
    local function ensureTrainSpeedState(train)
        if train.currentSpeed == nil then
            train.currentSpeed = train.speed or 0
        end
        if train.targetSpeed == nil then
            train.targetSpeed = train.speed or train.currentSpeed
        end
        train.speed = nil
    end

    ---@param trainName string
    ---@return boolean
    local function isTrainQueuedOnSignal(trainName)
        for _, queue in pairs(state.signalQueues.trainNamesBySignalId) do
            for _, queuedTrainName in ipairs(queue) do
                if queuedTrainName == trainName then return true end
            end
        end
        return false
    end

    ---@param trainName string
    local function removeTrainFromAllSignals(trainName)
        for signalId, queue in pairs(state.signalQueues.trainNamesBySignalId) do
            local removed = false
            for index = #queue, 1, -1 do
                if queue[index] == trainName then
                    table.remove(queue, index)
                    removed = true
                end
            end
            if removed and #queue == 0 then
                state.signalQueues.trainNamesBySignalId[signalId] = nil
            end
        end
    end

    function Runtime.simulateQueueTrainOnSignal(signalId, trainName)
        assert(type(signalId) == "number", "Need 'signalId' as number")
        assert(type(trainName) == "string", "Need 'trainName' as string")

        state.signalQueues.trainNamesBySignalId[signalId] = state.signalQueues.trainNamesBySignalId[signalId] or {}
        table.insert(state.signalQueues.trainNamesBySignalId[signalId], trainName)
    end

    --- Loest den Callback fuer einen an einem Signal haltenden Zug aus.
    --- Der Simulator ruft dazu eine im Test per _G.EEPOnTrainStoppedOnSignal
    --- gesetzte Callback-Funktion direkt auf.
    ---@param signalId number
    ---@param trainName string
    ---@return boolean
    function Runtime.emitOnTrainStoppedOnSignal(signalId, trainName)
        assert(type(signalId) == "number", "Need 'signalId' as number")
        assert(type(trainName) == "string", "Need 'trainName' as string")

        return emitGlobalCallback(globals, "EEPOnTrainStoppedOnSignal", signalId, trainName)
    end

    function Runtime.emitMain()
        return emitGlobalCallback(globals, "EEPMain")
    end

    function Runtime.emitOnSignal(signalId, stellung)
        assert(type(signalId) == "number", "Need 'signalId' as number")
        return emitIndexedCallback(globals, "EEPOnSignal_", signalId, stellung)
    end

    function Runtime.emitOnSwitch(switchId, stellung)
        assert(type(switchId) == "number", "Need 'switchId' as number")
        return emitIndexedCallback(globals, "EEPOnSwitch_", switchId, stellung)
    end

    function Runtime.emitOnTrainCoupling(zugA, zugB, zugNeu)
        assert(type(zugA) == "string", "Need 'zugA' as string")
        assert(type(zugB) == "string", "Need 'zugB' as string")
        assert(type(zugNeu) == "string", "Need 'zugNeu' as string")
        return emitGlobalCallback(globals, "EEPOnTrainCoupling", zugA, zugB, zugNeu)
    end

    function Runtime.emitOnTrainLooseCoupling(zugA, zugB, zugAlt)
        assert(type(zugA) == "string", "Need 'zugA' as string")
        assert(type(zugB) == "string", "Need 'zugB' as string")
        assert(type(zugAlt) == "string", "Need 'zugAlt' as string")
        return emitGlobalCallback(globals, "EEPOnTrainLooseCoupling", zugA, zugB, zugAlt)
    end

    function Runtime.emitOnSaveAnl(anlagenpfad)
        assert(type(anlagenpfad) == "string", "Need 'anlagenpfad' as string")
        return emitGlobalCallback(globals, "EEPOnSaveAnl", anlagenpfad)
    end

    function Runtime.emitOnBeforeSaveAnl()
        return emitGlobalCallback(globals, "EEPOnBeforeSaveAnl")
    end

    function Runtime.emitOnTrainExitTrainyard(depotId, trainName)
        assert(type(depotId) == "number", "Need 'depotId' as number")
        assert(type(trainName) == "string", "Need 'trainName' as string")
        return emitGlobalCallback(globals, "EEPOnTrainExitTrainyard", depotId, trainName)
    end

    function Runtime.emitOnTrainEnterTrainyard(depotId, trainName)
        assert(type(depotId) == "number", "Need 'depotId' as number")
        assert(type(trainName) == "string", "Need 'trainName' as string")
        return emitGlobalCallback(globals, "EEPOnTrainEnterTrainyard", depotId, trainName)
    end

    function Runtime.simulateRemoveTrainFromSignal(signalId, trainName)
        assert(type(signalId) == "number", "Need 'signalId' as number")
        assert(type(trainName) == "string", "Need 'trainName' as string")

        state.signalQueues.trainNamesBySignalId[signalId] = state.signalQueues.trainNamesBySignalId[signalId] or {}
        for i, v in ipairs(state.signalQueues.trainNamesBySignalId[signalId]) do
            if trainName == v then
                table.remove(state.signalQueues.trainNamesBySignalId[signalId], i)
                break
            end
        end
        if #state.signalQueues.trainNamesBySignalId[signalId] == 0 then
            state.signalQueues.trainNamesBySignalId[signalId] = nil
        end
    end

    function Runtime.simulateRemoveAllTrainsFromSignal(signalId)
        assert(type(signalId) == "number", "Need 'signalId' as number")

        state.signalQueues.trainNamesBySignalId[signalId] = nil
    end

    function Runtime.simulatePlaceTrainOnRoadTrack(trackId, zugname)
        Store.ensurePath(state, { "trains", zugname }, createTrainState).isOnLayout = true
        setTrackOccupancy("road", trackId, zugname)
    end

    function Runtime.simulatePlaceTrainOnRailTrack(trackId, zugname)
        Store.ensurePath(state, { "trains", zugname }, createTrainState).isOnLayout = true
        setTrackOccupancy("rail", trackId, zugname)
    end

    function Runtime.simulateSetRollingStockOrientation(rollingStockName, frontForward)
        getOrCreateRollingStockEntry(rollingStockName).frontForward = frontForward == true
    end

    function Runtime.simulateRenameTrain(oldName, newName)
        if oldName == newName then return getTrainState(oldName) ~= nil end
        if getTrainState(oldName) == nil or getTrainState(newName) ~= nil then return false end

        state.trains[newName] = state.trains[oldName]
        state.trains[oldName] = nil
        renameTrainReferences(oldName, newName)
        return true
    end

    function Runtime.simulateRenameRollingStock(oldName, newName)
        if oldName == newName then
            return select(1, getRollingStockTrainContext(oldName)) ~= nil
        end

        local oldRollingStock = select(1, getRollingStockTrainContext(oldName))
        if oldRollingStock == nil or select(1, getRollingStockTrainContext(newName)) ~= nil then
            return false
        end

        local rollingStock = oldRollingStock
        rollingStock.name = newName
        renameRollingStockReferences(oldName, newName)
        return true
    end

    function Runtime.simulateAddRollingStock(name, trainName)
        local resolvedName = getUniqueRollingStockName(name)
        local targetTrainName = trainName or ("#" .. resolvedName)
        local trainAlreadyExists = getTrainState(targetTrainName) ~= nil
        local targetTrain = Store.ensurePath(state, { "trains", targetTrainName }, createTrainState)
        targetTrain.rollingstockEntries = targetTrain.rollingstockEntries or {}
        table.insert(targetTrain.rollingstockEntries, normalizeRollingStockEntry(resolvedName))
        targetTrain.isOnLayout = true
        if not trainAlreadyExists then Runtime.callEEPSetTrainSpeed(targetTrainName, 0) end
        return true
    end

    function Runtime.simulateAddTrainToTrainyard(depotId, trainName, position, status)
        local trainyard = Store.ensurePath(state, { "trainyards", depotId }, createTrainyardState)
        local entry = { trainName = trainName, itemStatus = status or 1 }

        if position ~= nil then
            trainyard.entries[position + 1] = entry
        else
            table.insert(trainyard.entries, entry)
        end

        Store.ensurePath(state, { "trains", trainName }, createTrainState).isOnLayout = entry.itemStatus ~= 1
    end

    function Runtime.callEEPSetSignal(signalId, signalState, invokeCallback)
        assert(signalId > 0)
        Store.ensurePath(state, { "signals", signalId }, createEmptyTable).signalState = signalState
        return 1
    end

    function Runtime.callEEPGetSignal(signalId)
        assert(signalId > 0)
        return state.signals[signalId]
            and (state.signals[signalId].signalState or state.signals[signalId].stellung)
            or 2
    end

    function Runtime.callEEPSetSwitch(switchId, switchPosition, activateEEPOnSwitch)
        Store.ensurePath(state, { "switches", switchId }, createEmptyTable).switchPosition = switchPosition
        return 1
    end

    function Runtime.callEEPGetSwitch(switchId)
        return state.switches[switchId] and
            (state.switches[switchId].switchPosition or state.switches[switchId].stellung) or 2
    end

    function Runtime.callEEPRegisterSignal(signalId) assert(type(signalId) == "number", "Need 'signalId' as number") end

    function Runtime.callEEPRegisterSwitch(switchId) assert(type(switchId) == "number", "Need 'switchId' as number") end

    ---@param totalSeconds number
    local function setSimulatorTime(totalSeconds)
        local secondsSinceMidnight = math.floor(totalSeconds % 86400)
        if secondsSinceMidnight < 0 then secondsSinceMidnight = secondsSinceMidnight + 86400 end

        EEPTime = secondsSinceMidnight
        EEPTimeH = math.floor(secondsSinceMidnight / 3600)
        EEPTimeM = math.floor((secondsSinceMidnight % 3600) / 60)
        EEPTimeS = secondsSinceMidnight % 60
    end

    function Runtime.callEEPSetTime(stunde, minute, seconds)
        if type(stunde) ~= "number" or type(minute) ~= "number" or type(seconds) ~= "number" then return false end
        if stunde % 1 ~= 0 or minute % 1 ~= 0 or seconds % 1 ~= 0 then return false end
        if stunde < 0 or stunde > 23 or minute < 0 or minute > 59 or seconds < 0 or seconds > 59 then return false end

        setSimulatorTime(stunde * 3600 + minute * 60 + seconds)
        return true
    end

    function Runtime.callEEPGetFramesPerSecond()
        return 60
    end

    function Runtime.callEEPGetCurrentFrame()
        return 15
    end

    function Runtime.callEEPGetCurrentRenderFrame()
        return 15948
    end

    function Runtime.callEEPGetTimeLapse()
        return 1
    end

    function Runtime.callEEPSetColourFilter(hue, saturation, brightness, contrast) end

    -------------------
    -- Neu ab EEP 11 --
    -------------------

    function Runtime.callEEPSetTrainSpeed(trainName, speed, useTargetSpeed)
        local train = Store.ensurePath(state, { "trains", trainName }, createTrainState)
        local setTargetSpeedOnly = useTargetSpeed == true or useTargetSpeed == 1
        ensureTrainSpeedState(train)

        if setTargetSpeedOnly then
            train.targetSpeed = speed
            if not isTrainQueuedOnSignal(trainName) then
                train.currentSpeed = speed
            end
            return
        end

        train.currentSpeed = speed
        train.targetSpeed = speed
        removeTrainFromAllSignals(trainName)
    end

    function Runtime.callEEPGetTrainSpeed(trainName, useTargetSpeed)
        local train = getTrainState(trainName)
        local readTargetSpeed = useTargetSpeed == true or useTargetSpeed == 1
        if not train then return false, 0 end
        ensureTrainSpeedState(train)
        return true, readTargetSpeed and train.targetSpeed or train.currentSpeed
    end

    function Runtime.callEEPRollingstockSetCouplingRear(rsName, kupplungsStatus)
        getOrCreateRollingStockEntry(rsName).couplingRear = kupplungsStatus
        return true
    end

    function Runtime.callEEPRollingstockGetCouplingRear(rollingstockName)
        return getRollingStockCoupling(rollingstockName, "rear")
    end

    function Runtime.callEEPRollingstockSetCouplingFront(rsName, kupplungsStatus)
        getOrCreateRollingStockEntry(rsName).couplingFront = kupplungsStatus
        return true
    end

    function Runtime.callEEPRollingstockGetCouplingFront(rollingstockName)
        return getRollingStockCoupling(rollingstockName, "front")
    end

    function Runtime.callEEPRollingstockSetSlot(rsName, slot) end

    function Runtime.callEEPRollingstockSetAxis(rollingstockName, axisName, axisPosition, useNameFilter) end

    function Runtime.callEEPRollingstockGetAxis(rollingstockName, axisName) end

    function Runtime.callEEPLoadData(slot)
        return
            ((state.persistence.valueByStorageSlot[slot]
                or state.persistence.valueByStorageSlot[slot] == false) and true or false),
            state.persistence.valueByStorageSlot[slot]
    end

    function Runtime.callEEPSaveData(storageSlot, value)
        state.persistence.valueByStorageSlot[storageSlot] = value
        return true
    end

    function Runtime.callEEPStructureSetSmoke(immoName, onoff) end

    function Runtime.callEEPStructureGetSmoke(luaName) end

    local function getOrCreateStructureState(name)
        local strippedName = stripImmoName(name)
        local structure = Store.ensurePath(state, { "structures", strippedName }, createEmptyTable)
        return structure, strippedName
    end

    function Runtime.callEEPStructureSetLight(name, onoff)
        getOrCreateStructureState(name).lightEnabled = onoff
    end

    function Runtime.callEEPStructureGetLight(luaName)
        local strippedName = stripImmoName(luaName)
        if state.structures[strippedName] then
            return true, state.structures[strippedName].lightEnabled or false
        else
            return false, false
        end
    end

    function Runtime.callEEPStructureSetFire(immoName, onoff) end

    function Runtime.callEEPStructureGetFire(luaName) end

    function Runtime.callEEPStructureAnimateAxis(immoName, achse, schritte) end

    function Runtime.callEEPStructureSetAxis(luaName, axisName, axisPosition)
        local structure = getOrCreateStructureState(luaName)
        structure.axisPositions = structure.axisPositions or {}
        structure.axisPositions[axisName] = axisPosition
    end

    function Runtime.callEEPStructureGetAxis(immoName, achse)
        local structure = state.structures[stripImmoName(immoName)]
        return true, structure and structure.axisPositions and structure.axisPositions[achse] or 0
    end

    function Runtime.callEEPStructureSetPosition(luaName, posX, posY, posZ) end

    function Runtime.callEEPStructureSetRotation(luaName, rotX, rotY, rotZ) end

    function Runtime.callEEPSetTrainRoute(trainName, routeName)
        Store.ensurePath(state, { "trains", trainName }, createTrainState).routeName = routeName
        return true
    end

    function Runtime.callEEPGetTrainRoute(trainName)
        local train = getTrainState(trainName)
        return train ~= nil, train and train.routeName or "Alle"
    end

    function Runtime.callEEPSetTrainLight(trainName, enabled, lightSource)
        local train = Store.ensurePath(state, { "trains", trainName }, createTrainState)
        train.lightEnabledBySource[lightSource or 0] = enabled == true
        return true
    end

    function Runtime.callEEPGetTrainLight(trainName, quelle)
        local train = getTrainState(trainName)
        if not train then return false, false end
        return true, train.lightEnabledBySource[quelle or 0] == true
    end

    function Runtime.callEEPSetTrainSmoke(trainName, enabled)
        Store.ensurePath(state, { "trains", trainName }, createTrainState).smokeEnabled = enabled == true
        return true
    end

    function Runtime.callEEPSetTrainHorn(trainName, onoff)
        Store.ensurePath(state, { "trains", trainName }, createTrainState).hornEnabled = onoff == true
        return true
    end

    function Runtime.callEEPSetTrainCouplingFront(trainName, couple)
        setTrainEndCoupling(trainName, "front", couple and 1 or 2)
        return true
    end

    function Runtime.callEEPGetTrainCouplingFront(trainName)
        return getTrainEndCoupling(trainName, "front")
    end

    function Runtime.callEEPSetTrainCouplingRear(trainName, kupplungOn)
        setTrainEndCoupling(trainName, "rear", kupplungOn and 1 or 2)
        return true
    end

    function Runtime.callEEPGetTrainCouplingRear(trainName)
        return getTrainEndCoupling(trainName, "rear")
    end

    function Runtime.callEEPTrainLooseCoupling(trainName, countFromFront, position)
        return true
    end

    function Runtime.callEEPSetTrainHook(trainName, enabled)
        Store.ensurePath(state, { "trains", trainName }, createTrainState).hookEnabled = enabled == true
        return true
    end

    function Runtime.callEEPSetTrainAxis(trainName, achse, stellung)
        Store.ensurePath(state, { "trains", trainName }, createTrainState)
        return true
    end

    ------------------------------
    -- Neu ab EEP 11 - Plugin 2 --
    ------------------------------

    function Runtime.callEEPRegisterRailTrack(trackId)
        return registerTrack("rail", trackId)
    end

    function Runtime.callEEPIsRailTrackReserved(trackId, returnTrainName)
        return isTrackReserved("rail", trackId, returnTrainName)
    end

    function Runtime.callEEPRegisterRoadTrack(trackId)
        return registerTrack("road", trackId)
    end

    function Runtime.callEEPIsRoadTrackReserved(trackId, returnTrainName)
        return isTrackReserved("road", trackId, returnTrainName)
    end

    function Runtime.callEEPRegisterTramTrack(tramTrackId)
        return registerTrack("tram", tramTrackId)
    end

    function Runtime.callEEPIsTramTrackReserved(tramTrackId, returnTrainName)
        return isTrackReserved("tram", tramTrackId, returnTrainName)
    end

    function Runtime.callEEPRegisterAuxiliaryTrack(auxTrackId)
        return registerTrack("auxiliary", auxTrackId)
    end

    function Runtime.callEEPIsAuxiliaryTrackReserved(auxTrackId, returnTrainName)
        return isTrackReserved("auxiliary", auxTrackId, returnTrainName)
    end

    function Runtime.callEEPRegisterControlTrack(controlTrackId)
        return registerTrack("control", controlTrackId)
    end

    function Runtime.callEEPIsControlTrackReserved(controlTrackId, returnTrainName)
        return isTrackReserved("control", controlTrackId, returnTrainName)
    end

    function Runtime.callEEPSetCamera(cameraType, cameraName) return true end

    function Runtime.callEEPSetPerspectiveCamera(cameraPosition, trainName)
        state.camera.selectedPerspectiveCamera = { cameraPosition = cameraPosition, trainName = trainName or "" }
        if trainName and trainName ~= "" then
            Store.ensurePath(state, { "trains", trainName }, createTrainState).cameraPosition = cameraPosition
        end
        return true
    end

    function Runtime.callEEPGetPerspectiveCamera(trainName)
        if trainName and trainName ~= "" then
            local train = getTrainState(trainName)
            local position = train and train.cameraPosition or nil
            return position ~= nil, position
        end

        local perspective = state.camera.selectedPerspectiveCamera
        return perspective ~= nil, perspective and perspective.cameraPosition or nil
    end

    function Runtime.callEEPGetTrainFromTrainyard(depotId, trainName, depotSlot, departureOrientation)
        local entry

        if trainName and trainName ~= "" then
            entry = select(1, findTrainyardEntry(depotId, trainName, nil))
        else
            entry = select(1, findTrainyardEntry(depotId, nil, depotSlot))
        end

        if not entry then return false end

        entry.itemStatus = 0
        Store.ensurePath(state, { "trains", entry.trainName }, createTrainState).isOnLayout = true
        Runtime.emitOnTrainExitTrainyard(depotId, entry.trainName)
        return true
    end

    function Runtime.callEEPIsTrainInTrainyard(trainName)
        for depotId, trainyard in pairs(state.trainyards) do
            for _, entry in ipairs(trainyard.entries) do
                if entry.trainName == trainName and entry.itemStatus == 1 then return true, depotId end
            end
        end

        return false, nil
    end

    function Runtime.callEEPPutTrainToTrainyard(depotId, trainName)
        local targetTrainyard = Store.ensurePath(state, { "trainyards", depotId }, createTrainyardState)
        local entry = select(1, findTrainyardEntry(depotId, trainName, nil))

        if not entry then
            for currentDepotId, trainyard in pairs(state.trainyards) do
                local index
                entry, index = findTrainyardEntry(currentDepotId, trainName, nil)
                if entry then
                    if currentDepotId ~= depotId then table.remove(trainyard.entries, index) end
                    break
                end
            end
        end

        if not entry then
            entry = { trainName = trainName, itemStatus = 1 }
            table.insert(targetTrainyard.entries, entry)
        elseif select(1, findTrainyardEntry(depotId, trainName, nil)) == nil then
            table.insert(targetTrainyard.entries, entry)
        end

        entry.itemStatus = 1
        Store.ensurePath(state, { "trains", trainName }, createTrainState).isOnLayout = false
        local onTrainEnterTrainyard = rawget(_G, "EEPOnTrainEnterTrainyard")
        if onTrainEnterTrainyard then onTrainEnterTrainyard(depotId, trainName) end
        return true
    end

    function Runtime.callEEPShowInfoStructure(luaName, visible) end

    function Runtime.callEEPChangeInfoStructure(immoName, text) end

    function Runtime.callEEPShowInfoSignal(signalId, onOff)
        assert(type(signalId) == "number",
               "Need 'signalId' as number")
    end

    function Runtime.callEEPChangeInfoSignal(signalId, text)
        assert(type(signalId) == "number",
               "Need 'signalId' as number")
    end

    function Runtime.callEEPShowInfoSwitch(switchId, onOff) end

    function Runtime.callEEPChangeInfoSwitch(switchId, text) end

    -------------------------------
    -- Neu ab EEP 13 - Plugin 2  --
    -------------------------------

    function Runtime.callEEPGetRollingstockItemsCount(trainName)
        local rollingStocks = getTrainRollingStock(trainName)
        return #rollingStocks > 0 and #rollingStocks or 0
    end

    function Runtime.callEEPGetRollingstockItemName(zugverband, Nummer)
        local rollingStocks = getTrainRollingStock(zugverband)
        if #rollingStocks == 0 then return "DUMMY" end
        local rollingStock = rollingStocks[Nummer + 1]
        return rollingStock and rollingStock.name or "DUMMY"
    end

    function Runtime.callEEPGetSignalTrainsCount(signalId)
        local queue = state.signalQueues.trainNamesBySignalId[signalId]
        return queue and #queue or 0
    end

    function Runtime.callEEPGetSignalTrainName(signalId, position)
        if state.signalQueues.trainNamesBySignalId[signalId] then
            if state.signalQueues.trainNamesBySignalId[signalId][position] then
                return state.signalQueues
                    .trainNamesBySignalId[signalId][position]
            end
        end
        return "DUMMY"
    end

    function Runtime.callEEPGetTrainyardItemsCount(depotId)
        local trainyard = state.trainyards[depotId]
        return trainyard and #trainyard.entries or 0
    end

    function Runtime.callEEPGetTrainyardItemName(depotId, position)
        local entry = select(1, findTrainyardEntry(depotId, nil, position))
        return entry and entry.trainName or ""
    end

    function Runtime.callEEPGetTrainyardItemStatus(depotId, trainName, depotSlot)
        local entry = select(1, findTrainyardEntry(depotId, trainName, depotSlot))
        return entry and entry.itemStatus or 0
    end

    -------------------------------
    -- Neu ab EEP 15  --
    -------------------------------

    function Runtime.callEEPRollingstockGetLength(rollingstockName) return true, 5 end

    function Runtime.callEEPRollingstockGetMotor(rollingStockName) return true, false end

    function Runtime.callEEPRollingstockGetTrack(rollingstockName) return true, 5, 5, 1, 1 end

    function Runtime.callEEPRollingstockGetModelType(rollingstockName) return true, 1 end

    function Runtime.callEEPStructureGetPosition(luaName)
        local underscoreIndex = string.find(luaName, "_")
        local i

        if underscoreIndex then
            i = tonumber(string.sub(luaName, 2, underscoreIndex - 1))
        else
            i = tonumber(string.sub(luaName, 2))
        end

        if (i < 5) then
            return true, 0, 0, 0
        else
            return false
        end
    end

    function Runtime.callEEPStructureGetModelType(luaName)
        local underscoreIndex = string.find(luaName, "_")
        local i

        if underscoreIndex then
            i = tonumber(string.sub(luaName, 2, underscoreIndex - 1))
        else
            i = tonumber(string.sub(luaName, 2))
        end

        if (i < 5) then
            return true, 0, 0, 0
        else
            return false
        end
    end

    function Runtime.callEEPStructureSetTagText(luaName, text)
        getOrCreateStructureState(luaName).tagText = text
        return true
    end

    function Runtime.callEEPStructureGetTagText(name)
        local structure = state.structures[stripImmoName(name)]
        return true, structure and structure.tagText or nil
    end

    function Runtime.callEEPRollingstockSetTagText(rollingstockName, text)
        getOrCreateRollingStockEntry(rollingstockName).tagText = text
        return true
    end

    function Runtime.callEEPRollingstockGetTagText(name)
        local rollingStock = select(1, getRollingStockTrainContext(name))
        return rollingStock ~= nil, rollingStock and rollingStock.tagText or nil
    end

    local function setTextureText(entry, flaeche, text)
        entry.textureTextBySurfaceNumber = entry.textureTextBySurfaceNumber or {}
        entry.textureTextBySurfaceNumber[flaeche] = text
        return true
    end

    local function getTextureText(entry, flaeche)
        if not entry or not entry.textureTextBySurfaceNumber then return false, nil end
        local textureText = entry.textureTextBySurfaceNumber[flaeche]
        local ok = textureText ~= nil
        return ok, textureText
    end
    local function setTrackTextureText(trackType, id, flaeche, text)
        return setTextureText(Store.ensurePath(state, { "tracks", trackType, id }, createTrackState), flaeche, text)
    end

    local function getTrackTextureText(trackType, id, flaeche)
        return getTextureText((state.tracks[trackType] or {})[id], flaeche)
    end

    function Runtime.callEEPSignalSetTagText(signalId, text)
        Store.ensurePath(state, { "signals", signalId }, createEmptyTable).tagText = text
        return true
    end

    function Runtime.callEEPSignalGetTagText(id) return true, state.signals[id] and state.signals[id].tagText or nil end

    function Runtime.callEEPSwitchSetTagText(switchId, text)
        Store.ensurePath(state, { "switches", switchId }, createEmptyTable).tagText = text
        return true
    end

    function Runtime.callEEPSwitchGetTagText(id)
        return true, state.switches[id] and state.switches[id].tagText or nil
    end

    function Runtime.callEEPGoodsSetTagText(luaName, text)
        Store.ensurePath(state, { "goods", luaName }, createEmptyTable).tagText = text
        return true
    end

    function Runtime.callEEPGoodsGetTagText(name)
        local goods = state.goods[name]
        return true, goods and goods.tagText or nil
    end

    function Runtime.callEEPStructureSetTextureText(luaName, surfaceNumber, text)
        return setTextureText(getOrCreateStructureState(luaName), surfaceNumber, text)
    end

    function Runtime.callEEPStructureGetTextureText(luaName, surfaceNumber)
        return getTextureText(state.structures[stripImmoName(luaName)], surfaceNumber)
    end

    function Runtime.callEEPRollingstockSetTextureText(name, flaeche, text)
        return setTextureText(getOrCreateRollingStockEntry(name), flaeche, text)
    end

    function Runtime.callEEPSignalSetTextureText(signalId, surfaceNumber, text)
        return setTextureText(Store.ensurePath(state, { "signals", signalId }, createEmptyTable), surfaceNumber, text)
    end

    function Runtime.callEEPSignalGetTextureText(id, flaeche) return getTextureText(state.signals[id], flaeche) end

    function Runtime.callEEPGoodsSetTextureText(luaName, surfaceNumber, text)
        return setTextureText(Store.ensurePath(state, { "goods", luaName }, createEmptyTable), surfaceNumber, text)
    end

    function Runtime.callEEPGoodsGetTextureText(name, flaeche) return getTextureText(state.goods[name], flaeche) end

    function Runtime.callEEPRailTrackSetTextureText(railTrackId, surfaceNumber, text)
        return setTrackTextureText("rail",
                                   railTrackId, surfaceNumber, text)
    end

    function Runtime.callEEPRailTrackGetTextureText(id, flaeche) return getTrackTextureText("rail", id, flaeche) end

    function Runtime.callEEPRoadTrackSetTextureText(roadTrackId, surfaceNumber, text)
        return setTrackTextureText("road",
                                   roadTrackId, surfaceNumber, text)
    end

    function Runtime.callEEPRoadTrackGetTextureText(id, flaeche) return getTrackTextureText("road", id, flaeche) end

    function Runtime.callEEPTramTrackSetTextureText(tramTrackId, surfaceNumber, text)
        return setTrackTextureText("tram",
                                   tramTrackId, surfaceNumber, text)
    end

    function Runtime.callEEPTramTrackGetTextureText(id, flaeche) return getTrackTextureText("tram", id, flaeche) end

    function Runtime.callEEPAuxiliaryTrackSetTextureText(auxiliaryTrackId, surfaceNumber, text)
        return setTrackTextureText("auxiliary", auxiliaryTrackId, surfaceNumber, text)
    end

    function Runtime.callEEPAuxiliaryTrackGetTextureText(id, flaeche)
        return getTrackTextureText("auxiliary", id, flaeche)
    end

    ---------------------
    -- Neu ab EEP 15.1 --
    ---------------------

    state.active.trainName = ""

    function Runtime.callEEPGetTrainActive() return state.active.trainName end

    function Runtime.callEEPSetTrainActive(trainName)
        state.active.trainName = trainName
        return true
    end

    function Runtime.callEEPGetTrainLength(trainName) return true, 50 end

    state.active.rollingstockName = ""

    function Runtime.callEEPRollingstockGetActive() return state.active.rollingstockName end

    function Runtime.callEEPRollingstockSetActive(rollingstockName)
        state.active.rollingstockName = rollingstockName
        return true
    end

    function Runtime.callEEPRollingstockGetOrientation(rollingstockName)
        local rollingStock = select(1, getRollingStockTrainContext(rollingstockName))
        if not rollingStock then return false, false end
        return true, rollingStock.frontForward == true
    end

    ---------------------
    -- Neu ab EEP 16.1 --
    ---------------------

    function Runtime.callEEPActivateCtrlDesk(ctrlDeskName) return true end

    function Runtime.callEEPRollingstockSetHorn(rollingstockName, status) return true end

    function Runtime.callEEPRollingstockSetHook(rollingstockName, enabled)
        getOrCreateRollingStockEntry(rollingstockName).hookEnabled = enabled == true
        return true
    end

    function Runtime.callEEPRollingstockGetHook(rollingstockName)
        local rollingStock = select(1, getRollingStockTrainContext(rollingstockName))
        return true, rollingStock and rollingStock.hookEnabled and 1 or 0
    end

    function Runtime.callEEPRollingstockSetHookGlue(rollingstockName, status)
        getOrCreateRollingStockEntry(rollingstockName).fixedLoad = status == true
        return true
    end

    function Runtime.callEEPRollingstockGetHookGlue(rollingstockName)
        local rollingStock = select(1, getRollingStockTrainContext(rollingstockName))
        return true, rollingStock and rollingStock.fixedLoad and 1 or 0
    end

    function Runtime.callEEPRollingstockGetMileage(rollingstockName) return true, 10 end

    function Runtime.callEEPRollingstockGetPosition(rollingstockName) return true, 100, -50, 3 end

    function Runtime.callEEPRollingstockGetTextureText(rollingstockName, surfaceNumber)
        local rollingStock = select(1, getRollingStockTrainContext(rollingstockName))
        return getTextureText(rollingStock, surfaceNumber)
    end

    function Runtime.callEEPRollingstockSetUserCamera(rollingstockName, posX, posY, posZ, rotH, rotV, setDirectlyOrArg7,
                                                      setDirectly)
        local setDirectlyValue = setDirectly ~= nil and setDirectly or setDirectlyOrArg7
        local rollingStock = getOrCreateRollingStockEntry(rollingstockName)
        rollingStock.userCamera = {
            posX = posX,
            posY = posY,
            posZ = posZ,
            rotH = rotH,
            rotV = rotV,
            setDirectly = setDirectlyValue == true or setDirectlyValue == 1
        }

        if rollingStock.userCamera.setDirectly then
            state.camera.rollingstockName = rollingstockName
            state.camera.posX = posX
            state.camera.posY = posY
            state.camera.posZ = posZ
            state.camera.rotX = 0
            state.camera.rotY = rotH
            state.camera.rotZ = rotV
            state.camera.setDirectly = true
        end

        return true
    end

    function Runtime.callEEPRollingstockGetUserCamera(rollingstockName)
        local rollingStock = select(1, getRollingStockTrainContext(rollingstockName))
        local userCamera = rollingStock and rollingStock.userCamera or nil
        if not userCamera then return false, nil, nil, nil, nil, nil end
        return true, userCamera.posX, userCamera.posY, userCamera.posZ, userCamera.rotH, userCamera.rotV
    end

    function Runtime.callEEPGetCameraPosition()
        return true, state.camera.posX or 0, state.camera.posY or 0,
            state.camera.posZ or 0
    end

    function Runtime.callEEPGetCameraRotation()
        return true, state.camera.rotX or 0, state.camera.rotY or 0,
            state.camera.rotZ or 0
    end

    function Runtime.callEEPSetCameraPosition(PosX, PosY, PosZ)
        state.camera.posX = PosX
        state.camera.posY = PosY
        state.camera.posZ = PosZ
        return true
    end

    function Runtime.callEEPSetCameraRotation(rotX, rotY, rotZ)
        state.camera.rotX = rotX
        state.camera.rotY = rotY
        state.camera.rotZ = rotZ
        return true
    end

    function Runtime.callEEPRollingstockGetSmoke(rollingstockName) return true, 0 end

    function Runtime.callEEPRollingstockSetSmoke(rollingstockName, status) return true end

    function Runtime.callEEPGoodsGetRotation(goodsName) return true, 60, 10, -20 end

    function Runtime.callEEPStructureGetRotation(immobilieName) return true, 60, 10, -20 end

    function Runtime.callEEPGetWindIntensity() return true, state.weather.wind or 10 end

    function Runtime.callEEPGetRainIntensity() return true, state.weather.rain or 10 end

    function Runtime.callEEPGetSnowIntensity() return true, state.weather.snow or 10 end

    function Runtime.callEEPGetHailIntensity() return true, state.weather.hail or 10 end

    function Runtime.callEEPGetFogIntensity() return true, state.weather.fog or 10 end

    function Runtime.callEEPGetCloudsIntensity() return true, state.weather.clouds or 10 end

    function Runtime.callEEPGetCloudIntensity() return Runtime.callEEPGetCloudsIntensity() end

    function Runtime.callEEPSetWindIntensity(intensity)
        state.weather.wind = intensity
        return true
    end

    function Runtime.callEEPSetRainIntensity(intensity)
        state.weather.rain = intensity
        return true
    end

    function Runtime.callEEPSetSnowIntensity(intensity)
        state.weather.snow = intensity
        return true
    end

    function Runtime.callEEPSetHailIntensity(intensity)
        state.weather.hail = intensity
        return true
    end

    function Runtime.callEEPSetFogIntensity(intensity)
        state.weather.fog = intensity
        return true
    end

    function Runtime.callEEPSetCloudsIntensity(intensity)
        state.weather.clouds = intensity
        return true
    end

    function Runtime.callEEPPause(value) end

    return Runtime
end

return { create = create }
