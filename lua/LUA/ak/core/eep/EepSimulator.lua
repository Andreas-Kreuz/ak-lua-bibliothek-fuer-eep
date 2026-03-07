if AkDebugLoad then print("[#Start] Loading ak.core.eep.EepSimulator ...") end

------------------
-- EEP Functions
------------------

--- Versionsnummer von EEP.
EEPVer = 16.3

-- Der Inhalt des EEP-EreignisFensters wird geloescht
function clearlog()
    -- print("Clear ...")
end

local EepSimulator = {}
EepSimulator.debug = false
---@type table<number,number>
local signalsTrainCount = {}
---@type table<string>
local signalsTrainNames = {}
---@type table<string, table>
local state = {
    tracks = {
        rail = {},
        road = {},
        tram = {},
        auxiliary = {},
        control = {}
    },
    trains = {},
    trainyards = {},
    structures = {},
    signals = {},
    switches = {},
    goods = {},
    camera = {
        perspectiveByTrain = {},
        userRollingstock = {}
    }
}
local activeTrain
local activeRollingstock
local hook
local hookGlue

---@param trackType string
---@param trackId number
---@return table
local function ensureTrackState(trackType, trackId)
    state.tracks[trackType] = state.tracks[trackType] or {}
    state.tracks[trackType][trackId] = state.tracks[trackType][trackId] or { registered = true, trainName = "" }
    return state.tracks[trackType][trackId]
end

---@param trackType string
---@param trackId number
---@return boolean|nil
local function registerTrack(trackType, trackId)
    local track = ensureTrackState(trackType, trackId)
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
    local occupied = registered and track.trainName ~= "" or false

    if returnTrainName then return registered, occupied, registered and track.trainName or nil end

    return registered, occupied
end

---@param trackType string
---@param trackId number
---@param trainName string
local function setTrackOccupancy(trackType, trackId, trainName)
    local track = ensureTrackState(trackType, trackId)
    track.registered = true
    track.trainName = trainName
end

---@param trainName string
---@return table
local function ensureTrainState(trainName)
    state.trains[trainName] = state.trains[trainName] or {
        speed = 0,
        route = nil,
        rollingStock = {},
        lights = {},
        smoke = false,
        horn = false,
        couplingFront = 1,
        couplingRear = 1,
        hook = false,
        onLayout = true
    }
    return state.trains[trainName]
end

---@param trainName string
---@return table|nil
local function getTrainState(trainName) return state.trains[trainName] end

---@param rollingStock string|table
---@return table
local function normalizeRollingStockEntry(rollingStock)
    if type(rollingStock) == "table" then
        rollingStock.frontForward = rollingStock.frontForward ~= false
        rollingStock.textureTexts = rollingStock.textureTexts or {}
        return rollingStock
    end

    return {
        name = rollingStock,
        frontForward = true,
        couplingFront = nil,
        couplingRear = nil,
        tag = nil,
        textureTexts = {}
    }
end

---@param train table
---@return table[]
local function normalizeTrainRollingStockEntries(train)
    train.rollingStock = train.rollingStock or {}

    for index, rollingStock in ipairs(train.rollingStock) do
        train.rollingStock[index] = normalizeRollingStockEntry(rollingStock)
    end

    return train.rollingStock
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
local function ensureImplicitRollingStockTrain(rollingStockName)
    local trainName = "#" .. rollingStockName
    local train = ensureTrainState(trainName)
    local rollingStocks = getTrainRollingStock(trainName)

    if #rollingStocks == 0 then
        train.rollingStock = { normalizeRollingStockEntry(rollingStockName) }
        train.onLayout = true
        EEPSetTrainSpeed(trainName, 0)
        rollingStocks = train.rollingStock
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
    return select(1, getRollingStockTrainContext(rollingStockName)) or ensureImplicitRollingStockTrain(rollingStockName)
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
            if track.trainName == oldName then track.trainName = newName end
        end
    end

    for _, queue in pairs(signalsTrainNames) do
        for index, queuedTrainName in ipairs(queue) do
            if queuedTrainName == oldName then queue[index] = newName end
        end
    end

    for _, trainyard in pairs(state.trainyards) do
        for _, entry in ipairs(trainyard.entries) do
            if entry.name == oldName then entry.name = newName end
        end
    end

    if activeTrain == oldName then activeTrain = newName end

    if state.camera.perspectiveByTrain[oldName] ~= nil then
        state.camera.perspectiveByTrain[newName] = state.camera.perspectiveByTrain[oldName]
        state.camera.perspectiveByTrain[oldName] = nil
    end

    if state.camera.perspective and state.camera.perspective.trainName == oldName then
        state.camera.perspective.trainName = newName
    end
end

---@param oldName string
---@param newName string
local function renameRollingStockReferences(oldName, newName)
    if activeRollingstock == oldName then activeRollingstock = newName end

    if hook[oldName] ~= nil then
        hook[newName] = hook[oldName]
        hook[oldName] = nil
    end

    if hookGlue[oldName] ~= nil then
        hookGlue[newName] = hookGlue[oldName]
        hookGlue[oldName] = nil
    end

    if state.camera.userRollingstock[oldName] ~= nil then
        state.camera.userRollingstock[newName] = state.camera.userRollingstock[oldName]
        state.camera.userRollingstock[oldName] = nil
    end
end

---@param rollingStock table
---@param train table|nil
---@param side string
---@param trainEndStatus number|nil
---@return number
local function getExposedCouplingStatus(rollingStock, train, side, trainEndStatus)
    local explicitStatus = rollingStock[side == 'front' and 'couplingFront' or 'couplingRear']
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
        side == 'front' and rollingStock.frontForward
        or side == 'rear' and not rollingStock.frontForward
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

    local rollingStock = trainEnd == 'front' and rollingStocks[1] or rollingStocks[#rollingStocks]
    local rollingStockName = rollingStock.name

    if trainEnd == 'front' then
        return rollingStockName, rollingStock, rollingStock.frontForward and 'front' or 'rear'
    end

    return rollingStockName, rollingStock, rollingStock.frontForward and 'rear' or 'front'
end

---@param trainName string
---@param trainEnd string
---@param couplingStatus number
local function setTrainEndCoupling(trainName, trainEnd, couplingStatus)
    local train = ensureTrainState(trainName)

    if trainEnd == 'front' then
        train.couplingFront = couplingStatus
    else
        train.couplingRear = couplingStatus
    end

    local _, rollingStock, side = getTrainEndRollingStock(trainName, trainEnd)
    if not rollingStock or not side then return end

    if side == 'front' then
        rollingStock.couplingFront = couplingStatus
    else
        rollingStock.couplingRear = couplingStatus
    end
end

---@param trainName string
---@param trainEnd string
---@return boolean, number
local function getTrainEndCoupling(trainName, trainEnd)
    local train = getTrainState(trainName)
    if not train then return false, 0 end

    local rollingStockName, rollingStock, side = getTrainEndRollingStock(trainName, trainEnd)
    if rollingStockName and rollingStock and side then
        local explicitStatus = side == 'front' and rollingStock.couplingFront or rollingStock.couplingRear
        if explicitStatus ~= nil then return getRollingStockCoupling(rollingStockName, side) end
    end

    return true, trainEnd == 'front' and train.couplingFront or train.couplingRear
end

---@param depotId number
---@return table
local function ensureTrainyardState(depotId)
    state.trainyards[depotId] = state.trainyards[depotId] or { entries = {} }
    return state.trainyards[depotId]
end

---@param depotId number
---@param trainName string|nil
---@param position number|nil
---@return table|nil, number|nil
local function findTrainyardEntry(depotId, trainName, position)
    local trainyard = state.trainyards[depotId]
    if not trainyard then return nil, nil end

    if position ~= nil then
        local entry = trainyard.entries[position + 1]
        if entry and (
            trainName == nil
            or trainName == ""
            or entry.name == trainName
        ) then
            return entry, position + 1
        end
        return nil, nil
    end

    if trainName ~= nil and trainName ~= "" then
        for index, entry in ipairs(trainyard.entries) do
            if entry.name == trainName then return entry, index end
        end
    end

    return nil, nil
end

---Add a train and its rollingStock
---@param trainName string Name of the train
---param ... string Name of the rollingstock
function EepSimulator.addTrain(trainName, ...)
    local train = ensureTrainState(trainName)
    local existingRollingStock = {}

    for _, rollingStock in ipairs(getTrainRollingStock(trainName)) do
        existingRollingStock[rollingStock.name] = rollingStock
    end

    train.rollingStock = {}
    for _, rollingStockName in ipairs({ ... }) do
        local rollingStock = existingRollingStock[rollingStockName] or normalizeRollingStockEntry(rollingStockName)
        table.insert(train.rollingStock, rollingStock)
    end

    train.onLayout = true
    EEPSetTrainSpeed(trainName, 0)
end

function EepSimulator.splitTrain(trainName, index)
    local newName = trainName .. ";001"
    local oldTrain = ensureTrainState(trainName)
    local sourceRollingStock = getTrainRollingStock(trainName)
    ---@type table[]
    local oldRs = {}
    ---@type table[]
    local newRs = {}

    for i, rollingStock in pairs(sourceRollingStock) do
        table.insert(i <= index and oldRs or newRs, rollingStock)
    end

    oldTrain.rollingStock = oldRs
    local newTrain = ensureTrainState(newName)
    newTrain.rollingStock = newRs
    newTrain.onLayout = true
    EEPSetTrainSpeed(newName, 0)

    if oldTrain.route ~= nil then
        newTrain.route = oldTrain.route
    end

    if EepSimulator.debug then
        local oldNames = {}
        local newNames = {}
        for _, rollingStock in ipairs(oldRs) do table.insert(oldNames, rollingStock.name) end
        for _, rollingStock in ipairs(newRs) do table.insert(newNames, rollingStock.name) end
        print(string.format("Old Train: %s    : %s\nNew Train: %s: %s", trainName, table.concat(oldNames, ","), newName,
                            table.concat(newNames, ",")))
    end
    if (EEPOnTrainLooseCoupling) then EEPOnTrainLooseCoupling(trainName, newName, trainName) end
end

local function stripImmoName(name) return name:gsub("(#%d*).*", "%1") end

local function updateTrainListSize(signalId)
    local count = 0
    for _, _ in pairs(signalsTrainNames[signalId]) do count = count + 1 end
    signalsTrainCount[signalId] = count
end

--- This will add a train to the signals queue
---@param signalId number
---@param trainName string
function EepSimulator.queueTrainOnSignal(signalId, trainName)
    assert(type(signalId) == "number", "Need 'signalId' as number")
    assert(type(trainName) == "string", "Need 'trainName' as string")

    signalsTrainNames[signalId] = signalsTrainNames[signalId] or {}
    table.insert(signalsTrainNames[signalId], trainName)
    updateTrainListSize(signalId)
end

--- This will remove a train from the signals queue
---@param signalId number
---@param trainName string
function EepSimulator.removeTrainFromSignal(signalId, trainName)
    assert(type(signalId) == "number", "Need 'signalId' as number")
    assert(type(trainName) == "string", "Need 'trainName' as string")

    signalsTrainNames[signalId] = signalsTrainNames[signalId] or {}
    for i, v in ipairs(signalsTrainNames[signalId]) do
        if trainName == v then
            table.remove(signalsTrainNames[signalId], i)
            break
        end
    end
    updateTrainListSize(signalId)
end

--- This will remove all trains from the signals queue
---@param signalId number
function EepSimulator.removeAllTrainFromSignal(signalId)
    assert(type(signalId) == "number", "Need 'signalId' as number")

    signalsTrainNames[signalId] = {}
    updateTrainListSize(signalId)
end

function EepSimulator.setzeZugAufStrasse(trackId, zugname)
    ensureTrainState(zugname).onLayout = true
    setTrackOccupancy("road", trackId, zugname)
end

function EepSimulator.setzeZugAufGleis(trackId, zugname)
    ensureTrainState(zugname).onLayout = true
    setTrackOccupancy("rail", trackId, zugname)
end

---@param rollingStockName string
---@param frontForward boolean
function EepSimulator.setRollingStockOrientation(rollingStockName, frontForward)
    getOrCreateRollingStockEntry(rollingStockName).frontForward = frontForward == true
end

---@param oldName string
---@param newName string
---@return boolean
function EepSimulator.simulateRenameTrain(oldName, newName)
    if oldName == newName then return getTrainState(oldName) ~= nil end
    if getTrainState(oldName) == nil or getTrainState(newName) ~= nil then return false end

    state.trains[newName] = state.trains[oldName]
    state.trains[oldName] = nil
    renameTrainReferences(oldName, newName)
    return true
end

---@param oldName string
---@param newName string
---@return boolean
function EepSimulator.simulateRenameRollingStock(oldName, newName)
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

---@param name string
---@param trainName string|nil
---@return boolean
function EepSimulator.simulateAddRollingStock(name, trainName)
    local resolvedName = getUniqueRollingStockName(name)
    local targetTrainName = trainName or ("#" .. resolvedName)
    local trainAlreadyExists = getTrainState(targetTrainName) ~= nil
    local targetTrain = ensureTrainState(targetTrainName)
    targetTrain.rollingStock = targetTrain.rollingStock or {}
    table.insert(targetTrain.rollingStock, normalizeRollingStockEntry(resolvedName))
    targetTrain.onLayout = true
    if not trainAlreadyExists then EEPSetTrainSpeed(targetTrainName, 0) end
    return true
end

---@param depotId number
---@param trainName string
---@param position number|nil
---@param status number|nil
function EepSimulator.addTrainToTrainyard(depotId, trainName, position, status)
    local trainyard = ensureTrainyardState(depotId)
    local entry = { name = trainName, status = status or 1 }

    if position ~= nil then
        trainyard.entries[position + 1] = entry
    else
        table.insert(trainyard.entries, entry)
    end

    ensureTrainState(trainName).onLayout = entry.status ~= 1
end

local signale = state.signals
local switches = state.switches

--- Setzt das Signal signalId auf die Stellung signalStellung.
-- Der Parameter informiereEepOnSignal sollte den Wert 1 haben
-- @param signalId Id des Signals
-- @param signalStellung Stellung des Signals
-- @param informiereEepOnSignal (optional) Wenn = 1 dann aktiviere Funktion EEPOnSignal_x()
-- @return ok 1 wenn das Signal und die gewuenschte Signalstellung existieren
-- oder 0, wenn eins von beidem nicht existiert.
local function ensureSignalState(signalId)
    signale[signalId] = signale[signalId] or {}
    return signale[signalId]
end

local function ensureSwitchState(switchId)
    switches[switchId] = switches[switchId] or {}
    return switches[switchId]
end

function EEPSetSignal(signalId, signalStellung, informiereEepOnSignal)
    assert(signalId > 0)
    ensureSignalState(signalId).stellung = signalStellung
    return 1
end

--- Liefert die aktuelle Stellung des Signal x
-- @param signalId Id des Signals
-- @return Stellung des Signals, Wenn das abgefragte Signal nicht existiert, ist der Rueckgabewert 0.
function EEPGetSignal(signalId)
    assert(signalId > 0)
    return signale[signalId] and signale[signalId].stellung or 2
end

--- Setzt die Weiche x auf die Stellung y. Der Wert activateEEPOnSwitch sollte den Wert 1 haben.
-- @param switchId Id der Weiche
-- @param switchPosition Stellung der Weiche
-- @param activateEEPOnSwitch (optional) Wenn = 1 dann aktiviere Funktion EEPOnSignal_x()
-- @return ok 1 wenn die Weiche und die gewuenschte Weichenstellung existieren
-- oder 0, wenn eins von beidem nicht existiert.
function EEPSetSwitch(switchId, switchPosition, activateEEPOnSwitch)
    ensureSwitchState(switchId).stellung = switchPosition
    return 1
end

--- Liefert die aktuelle Stellung der Weiche x
function EEPGetSwitch(switchId) return switches[switchId] and switches[switchId].stellung or 2 end

--- Das Signal x wird intern registriert
function EEPRegisterSignal(signalId) assert(type(signalId) == "number", "Need 'signalId' as number") end

--- Die Weiche x wird intern registriert
function EEPRegisterSwitch(switchId) assert(type(switchId) == "number", "Need 'switchId' as number") end

EEPTime = 0
EEPTimeH = 0
EEPTimeM = 0
EEPTimeS = 0

-------------------
-- Neu ab EEP 11 --
-------------------
local eepdata = {}
local structureAxis = {}

--- Geschwindigkeit aendern
-- @param trainName Name des Zuges
-- @param speed Geschwindigkeit
function EEPSetTrainSpeed(trainName, speed)
    ensureTrainState(trainName).speed = speed
end

--- Geschwindigkeit lesen
---@param trainName string Name des Zuges
---@return boolean Ist der Zug vorhanden
---@return number Geschwindigkeit
function EEPGetTrainSpeed(trainName)
    local train = getTrainState(trainName)
    return train ~= nil, train and train.speed or 0
end

--- Setzen der Kupplung (hinten)
-- @param rsName Name des Rollmaterial,
-- @param kupplungsStatus 1-Kupplung aktiv, 2-Kupplung inaktiv, 3-Wagen angekoppelt(nurGet),
-- z.B.: EEPRollingstockSetCouplingRear("DB 212309", 2)
function EEPRollingstockSetCouplingRear(rsName, kupplungsStatus)
    getOrCreateRollingStockEntry(rsName).couplingRear = kupplungsStatus
    return true
end

--- Abfragen der Kupplung (hinten)
-- @param rsName Name des Rollmaterial,
-- @param kupplungsStatus 1-Kupplung aktiv, 2-Kupplung inaktiv, 3-Wagen angekoppelt(nurGet),
function EEPRollingstockGetCouplingRear(rsName)
    return getRollingStockCoupling(rsName, 'rear')
end

--- Setzen der Kupplung (vorn)
-- @param rsName Name des Rollmaterial,
-- @param kupplungsStatus 1-Kupplung aktiv, 2-Kupplung inaktiv, 3-Wagen angekoppelt(nurGet),
-- z.B.: EEPRollingstockSetCouplingFront("DB212 309", 2)
function EEPRollingstockSetCouplingFront(rsName, kupplungsStatus)
    getOrCreateRollingStockEntry(rsName).couplingFront = kupplungsStatus
    return true
end

--- Abfragen der Kupplung (vorn)
-- @param rsName Name des Rollmaterial,
-- @param kupplungsStatus 1-Kupplung aktiv, 2-Kupplung inaktiv, 3-Wagen angekoppelt(nurGet),
function EEPRollingstockGetCouplingFront(rsName)
    return getRollingStockCoupling(rsName, 'front')
end

--------------------------------------------------------------------------
-- Siehe hierzu auch Handbuch EEP 11(Achsgruppen) Setzen einer Achsgruppe,
-- z.B.: EEPRollingstockSetSlot("Loadingkran2Greifer", 1)
-- @param rsName Name des Rollmaterials als String
-- @param slot Slot mit der Achsstellung
--------------------------------------------------------------------------
function EEPRollingstockSetSlot(rsName, slot) end

--------------------------------------------------------------------------
--- Setzen einer Achse am Rollmaterial
-- z.B.: EEPRollingstockSetAxis("Bekohlungskranbruecke 1", "Drehung links", 50)
-- @param rsName Name des Rollmaterials als String
-- @param achse Name der Achse
-- @param stellung 0 - 100 - Achsstellung
--------------------------------------------------------------------------
function EEPRollingstockSetAxis(rsName, achse, stellung) end

--- Gibt die Stellung der Achse am Rollmaterial zurueck
-- z.B.: EEPRollingstockSetAxis("Bekohlungskranbr?cke 1", "Drehung links", 50)
-- @param rsName Name des Rollmaterials als String
-- @param achse Name der Achse
function EEPRollingstockGetAxis(rsName, achse) end

--- Laedt Daten aus Slot.
--- Laut EEP-Handbuch kann Rueckgabewert 2 ein Boolean, eine Zahl, ein String oder nil sein.
-- @param slot Slot 1 bis 1000
-- @return true (wenn gefunden), Boolean|Zahl|String|nil
function EEPLoadData(slot) return ((eepdata[slot] or eepdata[slot] == false) and true or false), eepdata[slot] end

--- Speichert Daten in Slot.
--- Laut EEP-Handbuch akzeptiert EEPSaveData Boolean, Zahl, String oder nil.
--- Falls ein String gespeichert wird, darf er dabei hoechstens 999 Zeichen lang sein.
-- @param slot Slot 1 bis 1000
-- @param data Boolean|Zahl|String|nil
function EEPSaveData(slot, data)
    eepdata[slot] = data
    return true
end

------------------------------
-- Neu ab EEP 11 - Plugin 1 --
------------------------------
--- Rauch einschalten
-- @param immoName Name der Immobilie als String.
-- @param onoff true oder false
function EEPStructureSetSmoke(immoName, onoff) end

--- Rauch abfreagen
-- @param immoName Name der Immobilie als String.
function EEPStructureGetSmoke(immoName) end

local function ensureStructureState(name)
    local strippedName = stripImmoName(name)
    state.structures[strippedName] = state.structures[strippedName] or {}
    return state.structures[strippedName], strippedName
end

--- Licht einschalten
-- @param immoName Name der Immobilie als String.
-- @param onoff true oder false
function EEPStructureSetLight(name, onoff)
    ensureStructureState(name).light = onoff
end

--- Licht abfragen
-- @param immoName Name der Immobilie als String.
function EEPStructureGetLight(name)
    local strippedName = stripImmoName(name)
    if state.structures[strippedName] then
        return true, state.structures[strippedName].light or false
    else
        return false, false
    end
end

--- Feuer einschalten
-- @param immoName Name der Immobilie als String.
-- @param onoff true oder false
function EEPStructureSetFire(immoName, onoff) end

--- Feuer abfragen
-- @param immoName Name der Immobilie als String.
function EEPStructureGetFire(immoName) end

--- Setzen einer Achse einer Immobilie.
-- @param immoName Name der Immobilie als String.
-- @param achse Name der Achse
-- @param schritte 1000 bzw. -1000: endlos, 0: Stopp, sonst Schritte
function EEPStructureAnimateAxis(immoName, achse, schritte) end

--- Setzen einer Achse einer Immobilie
-- @param immoName Name der Immobilie als String.
-- @param achse Name der Achse
-- @param stellung position der Achse
function EEPStructureSetAxis(immoName, achse, stellung)
    if not structureAxis[immoName] then structureAxis[immoName] = {} end
    structureAxis[immoName][achse] = stellung
end

--- Gibt die Stellung der Achse am Rollmaterial zurueck.
-- z.B.: EEPRollingstockSetAxis("Bekohlungskranbruecke 1", "Drehung links", 50)
-- @param immoName Name der Immobilie als String.
-- @param achse Name der Achse
function EEPStructureGetAxis(immoName, achse)
    return true, structureAxis[immoName] and structureAxis[immoName][achse] or 0
end

--- Setzen der Position einer Immobilie
-- @param immoName Name der Immobilie als String.
-- @param posX x-Position
-- @param posY y-Position
-- @param posZ z-Position
function EEPStructureSetPosition(immoName, posX, posY, posZ) end

--- Setzen der Rotation einer Immobilie
-- @param immoName Name der Immobilie als String.
-- @param rotX x-Position
-- @param rotY y-Position
-- @param rotZ z-Position
function EEPStructureSetRotation(immoName, rotX, rotY, rotZ) end

------------------------------
-- Neu ab EEP 11 - Plugin 2 --
------------------------------
--- Route aendern
---@param trainName string Name des Zuges
---@param route string Name der Route
function EEPSetTrainRoute(trainName, route)
    ensureTrainState(trainName).route = route
    return true
end

--- Route abfragen - return ok und Name der Route
---@param trainName string Name des Zuges
---@return boolean, string
function EEPGetTrainRoute(trainName)
    local train = getTrainState(trainName)
    return train ~= nil, train and train.route or "Alle"
end

--- Licht ein oder ausschalten
-- @param trainName Name des Zuges
-- @param onoff true: ein, false: aus
function EEPSetTrainLight(trainName, onoff, quelle)
    local train = ensureTrainState(trainName)
    train.lights[quelle or 0] = onoff == true
    return true
end

function EEPGetTrainLight(trainName, quelle)
    local train = getTrainState(trainName)
    if not train then return false, false end
    return true, train.lights[quelle or 0] == true
end

--- Rauch ein oder ausschalten
-- @param trainName Name des Zuges
-- @param onoff true: ein, false: aus
function EEPSetTrainSmoke(trainName, onoff)
    ensureTrainState(trainName).smoke = onoff == true
    return true
end

--- Hupen
-- @param trainName Name des Zuges
-- @param onoff true: signal starten, false: signal beenden
function EEPSetTrainHorn(trainName, onoff)
    ensureTrainState(trainName).horn = onoff == true
    return true
end

--- Kupplung vorn setzen
-- @param trainName Name des Zuges
-- @param kupplungOn true: kuppeln, false: abstoﬂen
function EEPSetTrainCouplingFront(trainName, kupplungOn)
    setTrainEndCoupling(trainName, 'front', kupplungOn and 1 or 2)
    return true
end

function EEPGetTrainCouplingFront(trainName)
    return getTrainEndCoupling(trainName, 'front')
end

--- Kupplung hinten setzen
-- @param trainName Name des Zuges
-- @param kupplungOn true: kuppeln, false: abstoﬂen
function EEPSetTrainCouplingRear(trainName, kupplungOn)
    setTrainEndCoupling(trainName, 'rear', kupplungOn and 1 or 2)
    return true
end

function EEPGetTrainCouplingRear(trainName)
    return getTrainEndCoupling(trainName, 'rear')
end

--- Zugverband an bestimmter Stelle trennen
-- @param trainName Name des Zuges
-- @param countFromFront true: von vorne zaehlen, false: von hinten zaehlen
-- @param position Stelle, die getrennt wird
function EEPTrainLooseCoupling(trainName, countFromFront, position)
    return true
end

--- Setzen des Gueterhakens an allen Wagen eines Zuges
-- @param trainName Name des Zuges als String
-- @param hookOn true: Haken fuer alle an
function EEPSetTrainHook(trainName, gueteran)
    ensureTrainState(trainName).hook = gueteran == true
    return true
end

--- Setzen einer Achse an allen Wagen eines Zuges
-- @param trainName Name des Zuges als String
-- @param achse Name der Achse
-- @param stellung 0 - 100 - Achsstellung
function EEPSetTrainAxis(trainName, achse, stellung)
    ensureTrainState(trainName)
    return true
end

------------------------------
-- Neu ab EEP 11 - Plugin 2 --
------------------------------

--- Registriert ein Gleis fuer die Besetztabfrage.
-- @param trackId Id des Gleises
function EEPRegisterRailTrack(trackId)
    return registerTrack("rail", trackId)
end

--- Fragt ab, ob ein Gleis besetzt ist.
-- @param trackId Id des Gleises
-- @param returnTrainName wenn true, wird als dritter Wert der Zugname
-- zurueckgegeben
-- @return Erster Wert: true, wenn Gleis existiert und registriert,
-- zweiter Wert: true, wenn besetzt,
-- dritter Wert: Name des Zuges auf dem Gleis
function EEPIsRailTrackReserved(trackId, returnTrainName)
    return isTrackReserved("rail", trackId, returnTrainName)
end

--- Registriert ein Gleis fuer die Besetztabfrage.
---@param trackId number Id des Gleises
function EEPRegisterRoadTrack(trackId)
    return registerTrack("road", trackId)
end

--- Fragt ab, ob ein Gleis besetzt ist.
---@param trackId number Id des Gleises
---@param returnTrainName boolean wenn true, wird als dritter Wert der Zugname
-- @return boolean, boolean, string
-- Erster Wert: true, wenn Gleis existiert und registriert,
-- zweiter Wert: true, wenn besetzt,
-- dritter Wert: Name des Zuges auf dem Gleis
function EEPIsRoadTrackReserved(trackId, returnTrainName)
    return isTrackReserved("road", trackId, returnTrainName)
end

--- Registriert ein Gleis fuer die Besetztabfrage.
-- @param tramTrackId Id des Gleises
function EEPRegisterTramTrack(tramTrackId)
    return registerTrack("tram", tramTrackId)
end

--- Fragt ab, ob ein Gleis besetzt ist.
-- @param tramTrackId Id des Gleises
-- @param returnTrainName wenn true, wird als dritter Wert der Zugname
-- @return Erster Wert: true, wenn Gleis existiert und registriert,
-- zweiter Wert: true, wenn besetzt,
-- dritter Wert: Name des Zuges auf dem Gleis
function EEPIsTramTrackReserved(tramTrackId, returnTrainName)
    return isTrackReserved("tram", tramTrackId, returnTrainName)
end

--- Registriert ein Gleis fuer die Besetztabfrage.
-- @param auxTrackId Id des Gleises
function EEPRegisterAuxiliaryTrack(auxTrackId)
    return registerTrack("auxiliary", auxTrackId)
end

--- Fragt ab, ob ein Gleis besetzt ist.
-- @param auxTrackId Id des Gleises
-- @param returnTrainName wenn true, wird als dritter Wert der Zugname
-- @return Erster Wert: true, wenn Gleis existiert und registriert,
-- zweiter Wert: true, wenn besetzt,
-- dritter Wert: Name des Zuges auf dem Gleis
function EEPIsAuxiliaryTrackReserved(auxTrackId, returnTrainName)
    return isTrackReserved("auxiliary", auxTrackId, returnTrainName)
end

--- Registriert ein Gleis fuer die Besetztabfrage.
-- @param controlTrackId Id des Gleises
function EEPRegisterControlTrack(controlTrackId)
    return registerTrack("control", controlTrackId)
end

--- Fragt ab, ob ein Gleis besetzt ist.
-- @param controlTrackId Id des Gleises
-- @return Erster Wert: true, wenn Gleis existiert und registriert,
-- zweiter Wert: true, wenn besetzt
function EEPIsControlTrackReserved(controlTrackId, returnTrainName)
    return isTrackReserved("control", controlTrackId, returnTrainName)
end

--- Waehlen einer Kamera
-- @param camType 0: statisch, 1: dynamisch, 2: mobile Kamera
-- @param camName Name der Kamera
-- @return true, wenn die Kamera existiert
function EEPSetCamera(camType, camName) return true end

--- Waehlen einer Kameraperspektive
-- @param camPosition Tasten 1 - 9 fuer die Kameraposition
-- @param trainName Name des Zuges
-- @return true, wenn die Kamera existiert
function EEPSetPerspectiveCamera(camPosition, trainName)
    state.camera.perspective = { position = camPosition, trainName = trainName or "" }
    if trainName and trainName ~= "" then state.camera.perspectiveByTrain[trainName] = camPosition end
    return true
end

function EEPGetPerspectiveCamera(trainName)
    if trainName and trainName ~= "" then
        local position = state.camera.perspectiveByTrain[trainName]
        return position ~= nil, position
    end

    local perspective = state.camera.perspective
    return perspective ~= nil, perspective and perspective.position or nil
end

--- Zug aus Depot starten
-- @param depotId Id des Depots (Eigenschaftenfenster)
-- @param trainName Name des Zuges
-- @param trainNumber Wenn kein Zugname angegeben ist, dann die Nummer des Zugs im Depot
-- @return true, wenn der Zug existiert
function EEPGetTrainFromTrainyard(depotId, trainName, trainNumber)
    local entry

    if trainName and trainName ~= "" then
        entry = select(1, findTrainyardEntry(depotId, trainName, nil))
    else
        entry = select(1, findTrainyardEntry(depotId, nil, trainNumber))
    end

    if not entry then return false end

    entry.status = 0
    ensureTrainState(entry.name).onLayout = true
    if EEPOnTrainExitTrainyard then EEPOnTrainExitTrainyard(depotId, entry.name) end
    return true
end

function EEPIsTrainInTrainyard(trainName)
    for depotId, trainyard in pairs(state.trainyards) do
        for _, entry in ipairs(trainyard.entries) do
            if entry.name == trainName and entry.status == 1 then return true, depotId end
        end
    end

    return false, nil
end

function EEPPutTrainToTrainyard(depotId, trainName)
    local targetTrainyard = ensureTrainyardState(depotId)
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
        entry = { name = trainName, status = 1 }
        table.insert(targetTrainyard.entries, entry)
    elseif select(1, findTrainyardEntry(depotId, trainName, nil)) == nil then
        table.insert(targetTrainyard.entries, entry)
    end

    entry.status = 1
    ensureTrainState(trainName).onLayout = false
    local onTrainEnterTrainyard = rawget(_G, "EEPOnTrainEnterTrainyard")
    if onTrainEnterTrainyard then onTrainEnterTrainyard(depotId, trainName) end
    return true
end

-------------------------------
-- Neu ab EEP 13             --
-------------------------------
--- Zeigen / Verstecken des Tipp-Textes einer Immobilie
-- @param immoName Name der Immobilie als String.
-- @param onOff true: einschalten
function EEPShowInfoStructure(immoName, onOff) end

--- Setzen des Tipp-Textes einer Immobilie
-- @param immoName Name der Immobilie als String.
-- @param text Text fuer die Anzeige
function EEPChangeInfoStructure(immoName, text) end

--- Zeigen / Verstecken des Tipp-Textes einer Immobilie
-- @param switchId Name der Immobilie als String.
-- @param onOff true: einschalten
function EEPShowInfoSignal(signalId, onOff) assert(type(signalId) == "number", "Need 'signalId' as number") end

--- Setzen des Tipp-Textes einer Immobilie
-- @param switchId Name der Immobilie als String.
-- @param text Text fuer die Anzeige
function EEPChangeInfoSignal(signalId, text) assert(type(signalId) == "number", "Need 'signalId' as number") end

--- Zeigen / Verstecken des Tipp-Textes einer Weiche
-- @param switchId Name der Weiche als String.
-- @param onOff true: einschalten
function EEPShowInfoSwitch(switchId, onOff) end

--- Setzen des Tipp-Textes einer Weiche
-- @param switchId Name der Weiche als String.
-- @param text Text fuer die Anzeige
function EEPChangeInfoSwitch(switchId, text) end

-------------------------------
-- Neu ab EEP 13 - Plugin 2  --
-------------------------------

--- Anzahl der Fahrzeuge im Zugverband Name
-- @param zugverband Names des Zugverbandes
--
function EEPGetRollingstockItemsCount(zugverband)
    local rollingStocks = getTrainRollingStock(zugverband)
    return #rollingStocks > 0 and #rollingStocks or 0
end

--- Name des Rollis Nummer im Zugverband Name
-- @param zugverband Name des Zugverbandes
-- @param Nummer
--
function EEPGetRollingstockItemName(zugverband, Nummer)
    local rollingStocks = getTrainRollingStock(zugverband)
    if #rollingStocks == 0 then return "DUMMY" end
    local rollingStock = rollingStocks[Nummer + 1]
    return rollingStock and rollingStock.name or "DUMMY"
end

--- Anzahl der Zuege, welche vom Signal Signal_ID gehalten werden
-- @param signalId ID des Signals
--
function EEPGetSignalTrainsCount(signalId) return signalsTrainCount[signalId] or 0 end

--- Name des Zuges Zahl, der vom Signal Signal_ID gehalten wird
-- @param signalId ID des Signals
-- @param position Position des Zuges am Signal
--
function EEPGetSignalTrainName(signalId, position)
    if signalsTrainNames[signalId] then
        if signalsTrainNames[signalId][position] then return signalsTrainNames[signalId][position] end
    end
    return "DUMMY"
end

--- Anzahl der Zuege, welche im Depot ZugdepotId gelistet sind
-- @param depotId ID des Zugdepots
-- @return count Anzahl der Fahrzeugverbaende
function EEPGetTrainyardItemsCount(depotId)
    local trainyard = state.trainyards[depotId]
    return trainyard and #trainyard.entries or 0
end

--- Name des Zuges am DepotPlatz im Depot depotId
-- @param depotId ID des Zugdepots
-- @param position Position (Zahl) des Zugverbandes im Depot
-- @return trainName Name des Fahrzeugverbands
function EEPGetTrainyardItemName(depotId, position)
    local entry = select(1, findTrainyardEntry(depotId, nil, position))
    return entry and entry.name or ""
end

--- Status (wartet/auf Anlage) des Zuges Name am Platz im depotId
-- @param depotId ID des Zugdepots
-- @param zugverband Name des Zugverbandes
-- @param position Position (Zahl) des Zugverbandes im Depot
-- @return status Status des Fahrzeugverbands: 0 = in Fahrt , 1 = warten
function EEPGetTrainyardItemStatus(depotId, zugverband, position)
    local entry = select(1, findTrainyardEntry(depotId, zugverband, position))
    return entry and entry.status or 0
end

-------------------------------
-- Neu ab EEP 15  --
-------------------------------

--- Argument ist der Name des Fahrzeugs.
-- Rueckgabewert 1 ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
-- Rueckgabewert 2 ist die Laenge des Fahrzeugs von Kupplung zu Kupplung in Metern.
function EEPRollingstockGetLength(rollingStockName) return true, 5 end

--- Argument ist der Name des Fahrzeugs.
-- Rueckgabewert 1 ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
-- Rueckgabewert 2 ist true, wenn das angegebene Fahrzeug einen Antrieb besitzt, sonst false.
function EEPRollingstockGetMotor(rollingStockName) return true, false end

--- Argument ist der Name des Fahrzeugs.
-- Rueckgabewert 1 ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
-- Rueckgabewert 2 ist die ID des Gleisstuecks, auf dem sich das Fahrzeug befindet.
-- Rueckgabewert 3 ist der Abstand (in Metern) zum Anfang des Gleisstuecks, auf dem sich das
-- Fahrzeug befindet.
-- Rueckgabewert 4 ist die Ausrichtung relativ zur Fahrtrichtung des Gleisstuecks, auf dem sich das
-- Fahrzeug befindet. 1 = in Fahrtrichtung, 0 = entgegen der Fahrtrichtung
-- Rueckgabewert 5 ist die Nummer des Gleissystems, auf dem das Fahrzeug unterwegs ist.
-- 1 = Bahngleise
-- 2 = Straﬂen
-- 3 = Tramgleise
-- 4 = sonstige Splines/Wasserwege
function EEPRollingstockGetTrack(rollingStockName) return true, 5, 5, 1, 1 end

--- Argument ist der Fahrzeugname.
-- Rueckgabewert 1 ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
-- Rueckgabewert 2 ist die Kategorie, welche der Konstrukteur im Modell eingetragen hat:
-- 1 = Tenderlok
-- 2 = Schlepptenderlok
-- 3 = Tender
-- 4 = Elektrolok
-- 5 = Diesellok
-- 6 = Triebwagen
-- 7 = U- oder S-Bahn
-- 8 = Strassenbahn
-- 9 = Gueterwaggons
-- 10 = Personenwaggons
-- 11 = Luftfahrzeuge
-- 12 = Maschinen (z.B. Kraene)
-- 13 = Wasserfahrzeuge
-- 14 = LKW
-- 15 = PKW
function EEPRollingstockGetModelType(rollingStockName) return true, 1 end

--- Argument ist der Lua-Name der Immobilie oder des LS-Elements.
-- Es genuegt die Nummer mit vorangestelltem #-Zeichen.
-- @return
-- Rueckgabewert 1 ist true, wenn die Ausfuehrung erfolgreich war, ansonsten false.
-- Rueckgabewert 2 ist die X-Position des Objekts.
-- Rueckgabewert 3 ist die Y-Position des Objekts.
-- Rueckgabewert 4 ist die Z-Position des Objekts.
function EEPStructureGetPosition(name)
    local underscoreIndex = string.find(name, "_")
    local i

    if underscoreIndex then
        i = tonumber(string.sub(name, 2, underscoreIndex - 1))
    else
        i = tonumber(string.sub(name, 2))
    end

    if (i < 5) then
        return true, 0, 0, 0
    else
        return false
    end
end

--- Argument ist der Lua-Name der Immobilie oder des LS-Elements.
-- Es genuegt die Nummer mit vorangestelltem #-Zeichen.
-- @return
-- Rueckgabewert 1 ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
-- Rueckgabewert 2 ist die Kategorie, welche der Konstrukteur im Modell eingetragen hat:
-- 16 = Gleise/Gleisobjekte
-- 17 = Schiene/Gleisobjekte
-- 18 = Strassen/Gleisobjekte
-- 19 = Sonstiges/Gleisobjekte
-- 22 = Immobilien
-- 23 = Landschaftselemente/Fauna
function EEPStructureGetModelType(name)
    local underscoreIndex = string.find(name, "_")
    local i

    if underscoreIndex then
        i = tonumber(string.sub(name, 2, underscoreIndex - 1))
    else
        i = tonumber(string.sub(name, 2))
    end

    if (i < 5) then
        return true, 0, 0, 0
    else
        return false
    end
end

--- Aendert den Tag-Text einer Immobilie. Jede Immobilie kann jetzt einen individuellen String von
--- maximal 1024 Zeichen Laenge mitfuehren. Diese Strings werden mit der Anlage gespeichert und
--- geladen.
--- Bemerkungen * Argument 1 ist der Lua-Name der Immobilie oder des LS-Elements.
--- Es genuegt die Nummer mit vorangestelltem #-Zeichen.
--- * Argument 2 ist der gewuenschte Text.
--- * Rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false
function EEPStructureSetTagText(name, tag)
    ensureStructureState(name).tag = tag
    return true
end

--- Liest den Tag-Text einer Immobilie aus. Mittels Tag-Texten kˆnnen Immobilien als permanente
--- Speicher fuer relevante Informationen genutzt werden.
--- Bemerkungen
--- * Argument 1 ist der Lua-Name der Immobilie oder des LS-Elements.
--- Es genuegt die Nummer mit vorangestelltem #-Zeichen.
--- * Rueckgabewert 1 ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
--- * Rueckgabewert 2 ist der Tag-Text, welcher der Immobilie mitgegeben wurde
function EEPStructureGetTagText(name)
    local structure = state.structures[stripImmoName(name)]
    return true, structure and structure.tag or nil
end

--- Aendert den Tag-Text eines Fahrzeugs. Jedes Fahrzeug kann jetzt einen eigenen String von
--- maximal 1024 Zeichen Laenge mitfuehren. Diese Strings werden mit der Anlage gespeichert und
--- geladen. Da die Texte individuell jedem Fahrzeug zugeordnet sind, gehen sie im Gegensatz zu
--- Routen nicht durch Rangiermanˆver etc. verloren.
--- Bemerkungen
--- * Argument 1 ist der Name des Fahrzeugs.
--- * Argument 2 ist der gewuenschte Text als String mit maximal 1024 Zeichen.
--- * Rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPRollingstockSetTagText(name, tag)
    getOrCreateRollingStockEntry(name).tag = tag
    return true
end

--- Liest den Tag-Text eines Fahrzeugs aus. Mittels Tag-Texten kˆnnen Fahrzeuge jetzt kategorisiert
--- werden. Beispielsweise kann man dort Waggontypen speichern oder Bestimmungsorte.
--- Bemerkungen
--- * Argument 1 ist der Name des Fahrzeugs.
--- * Rueckgabewert 1 ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
--- * Rueckgabewert 2 ist der Tag-Text als String mit maximal 1024 Zeichen, welcher dem Waggon
---   mitgegeben wurde.
function EEPRollingstockGetTagText(name)
    local rollingStock = select(1, getRollingStockTrainContext(name))
    return rollingStock ~= nil, rollingStock and rollingStock.tag or nil
end

local function setTextureText(entry, flaeche, text)
    entry.textureTexts = entry.textureTexts or {}
    entry.textureTexts[flaeche] = text
    return true
end

local function getTextureText(entry, flaeche)
    if not entry or not entry.textureTexts then return false, nil end
    local textureText = entry.textureTexts[flaeche]
    local ok = textureText ~= nil
    return ok, textureText
end

local function ensureGoodsState(goodsName)
    state.goods[goodsName] = state.goods[goodsName] or {}
    return state.goods[goodsName]
end

local function setTrackTextureText(trackType, id, flaeche, text)
    return setTextureText(ensureTrackState(trackType, id), flaeche, text)
end

local function getTrackTextureText(trackType, id, flaeche)
    return getTextureText((state.tracks[trackType] or {})[id], flaeche)
end

function EEPSignalSetTagText(id, tag)
    ensureSignalState(id).tag = tag
    return true
end

function EEPSignalGetTagText(id) return true, signale[id] and signale[id].tag or nil end

function EEPSwitchSetTagText(id, tag)
    ensureSwitchState(id).tag = tag
    return true
end

function EEPSwitchGetTagText(id) return true, switches[id] and switches[id].tag or nil end

function EEPGoodsSetTagText(name, tag)
    ensureGoodsState(name).tag = tag
    return true
end

function EEPGoodsGetTagText(name)
    local goods = state.goods[name]
    return true, goods and goods.tag or nil
end

function EEPStructureSetTextureText(name, flaeche, text)
    return setTextureText(ensureStructureState(name), flaeche, text)
end

function EEPStructureGetTextureText(name, flaeche)
    return getTextureText(state.structures[stripImmoName(name)], flaeche)
end

function EEPRollingstockSetTextureText(name, flaeche, text)
    return setTextureText(getOrCreateRollingStockEntry(name), flaeche, text)
end

function EEPSignalSetTextureText(id, flaeche, text)
    return setTextureText(ensureSignalState(id), flaeche, text)
end

function EEPSignalGetTextureText(id, flaeche) return getTextureText(signale[id], flaeche) end

function EEPGoodsSetTextureText(name, flaeche, text)
    return setTextureText(ensureGoodsState(name), flaeche, text)
end

function EEPGoodsGetTextureText(name, flaeche) return getTextureText(state.goods[name], flaeche) end

function EEPRailTrackSetTextureText(id, flaeche, text) return setTrackTextureText("rail", id, flaeche, text) end

function EEPRailTrackGetTextureText(id, flaeche) return getTrackTextureText("rail", id, flaeche) end

function EEPRoadTrackSetTextureText(id, flaeche, text) return setTrackTextureText("road", id, flaeche, text) end

function EEPRoadTrackGetTextureText(id, flaeche) return getTrackTextureText("road", id, flaeche) end

function EEPTramTrackSetTextureText(id, flaeche, text) return setTrackTextureText("tram", id, flaeche, text) end

function EEPTramTrackGetTextureText(id, flaeche) return getTrackTextureText("tram", id, flaeche) end

function EEPAuxiliaryTrackSetTextureText(id, flaeche, text)
    return setTrackTextureText("auxiliary", id, flaeche, text)
end

function EEPAuxiliaryTrackGetTextureText(id, flaeche) return getTrackTextureText("auxiliary", id, flaeche) end

---------------------
-- Neu ab EEP 15.1 --
---------------------

activeTrain = ""

--- Ermittelt, welcher Zug derzeit im Steuerdialog ausgewaehlt ist. (EEP 15.1)
-- Befindet sich der Steuerdialog im manuellen Modus, dann wird der Name des Zuges zurueckgegeben,
-- welcher das ausgewaehlte Fahrzeug enthaelt
-- @return trainName Name des Zuges
function EEPGetTrainActive() return activeTrain end

--- Waehlt den angegebenen Zug im Steuerdialog aus. (EEP 15.1)
-- Stellt den Steuerdialog auf Automatik-Modus um.
-- @param trainName Name des Zuges
-- @return ok Rueckgabewert ist true wenn die Aktion erfolgreich war, sonst false
function EEPSetTrainActive(trainName)
    activeTrain = trainName
    return true
end

--- Ermittelt die Gesamtlaenge des angegebenen Zuges. (EEP 15.1)
---@param trainName string Name des Zuges
---@return boolean ok Rueckgabewert ist true wenn der angesprochene Zug existiert, sonst false
---@return integer length Laenge des Zuges in Meter
function EEPGetTrainLength(trainName) return true, 50 end

activeRollingstock = ""

--- Ermittelt, welches Fahrzeug derzeit im Steuerdialog ausgewaehlt ist. (EEP 15.1)
-- Befindet sich der Steuerdialog im Automatikmodus, dann wird ein leerer String zurueckgegeben.
-- @return rollingstockName Name des Rollmaterials
function EEPRollingstockGetActive() return activeRollingstock end

--- Waehlt das angegebene Fahrzeug im Steuerdialog aus. (EEP 15.1)
-- Stellt den Steuerdialog auf manuellen Modus um.
-- @param rollingstockName Name des Rollmaterials
-- @return ok Rueckgabewert ist true wenn die Aktion erfolgreich war, sonst false
function EEPRollingstockSetActive(rollingstockName)
    activeRollingstock = rollingstockName
    return true
end

--- Ermittelt, welche relative Ausrichtung das angegebene Fahrzeug im Zugverband hat. (EEP 15.1)
-- @param rollingstockName Name des Rollmaterials
-- @return ok Rueckgabewert ist true wenn der angesprochene Zug existiert, sonst false
-- @return orientation Ausrichtung des Rollmaterials, true, wenn das Fahrzeug vorwaerts ausgerichtet ist, sonst false
function EEPRollingstockGetOrientation(rollingstockName)
    local rollingStock = select(1, getRollingStockTrainContext(rollingstockName))
    if not rollingStock then return false, nil end
    return true, rollingStock.frontForward == true
end

---------------------
-- Neu ab EEP 16.1 --
---------------------

--- Ruft das Stellpult im Radarfenster auf. (EEP 16.1)
-- @param GBSname
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPActivateCtrlDesk(GBSname) return true end

--- Laesst bei einem bestimmten Rollmaterial den Warnton (Pfeife, Hupe) ertˆnen. (EEP 16.1)
-- @param rollingstockName Name des Rollmaterials
-- @param status true = an, false = aus
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPRollingstockSetHorn(rollingstockName, status) return true end

hook = {}

--- Schaltet bei einem bestimmten Rollmaterial den Haken an oder aus. (EEP 16.1)
-- @param rollingstockName Name des Rollmaterials
-- @param status true = an, false = aus
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPRollingstockSetHook(rollingstockName, status)
    hook[rollingstockName] = status
    return true
end

--- Ermittelt, ob der Haken eines bestimmten Rollmaterials an oder ausgeschaltet ist (EEP 16.1)
-- @param rollingstockName Name des Rollmaterials
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return status Haken aus = 0, an = 1, in Betrieb = 3
function EEPRollingstockGetHook(rollingstockName) return true, hook[rollingstockName] and 1 or 0 end

hookGlue = {}

--- Beeinflusst das Verhalten von Guetern an einem Kranhaken eines Rollmaterials. (EEP 16.1)
-- @param rollingstockName Name des Rollmaterials
-- @param status true = an, false = aus
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPRollingstockSetHookGlue(rollingstockName, status)
    hookGlue[rollingstockName] = status
    return true
end

--- Ermittelt das Verhalten von Guetern am Kranhaken eines Rollmaterials  (EEP 16.1)
-- @param rollingstockName Name des Rollmaterials
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return status Gueterhaken aus = 0, an = 1, in Betrieb = 3
function EEPRollingstockGetHookGlue(rollingstockName)
    return true, hookGlue[rollingstockName] and 1 or 0
end

--- Ermittelt die zurueckgelegte Strecke des Rollmaterials (EEP 16.1)
-- @param rollingstockName Name des Rollmaterials
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return mileage  Die in Metern zurueckgelegte Strecke des Rollmaterials seit dem Einsetzen in EEP
function EEPRollingstockGetMileage(rollingstockName) return true, 10 end

--- Ermittelt die Position des Rollmaterials im EEP-Koordinatensystem. (EEP 16.1)
-- @param rollingstockName Name des Rollmaterials
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return PosX
-- @return PosY
-- @return PosZ
function EEPRollingstockGetPosition(rollingstockName) return true, 100, -50, 3 end

-- Liest den Text einer beschreibbaren Fl‰che eines Rollmaterials aus (EEP 16.3)
-- @param rollingstockName Name des Rollmaterials
-- @param flaeche Nummer der Fl‰che, welche den Text enthaelt.
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return textureText
function EEPRollingstockGetTextureText(rollingstockName, fleache)
    local rollingStock = select(1, getRollingStockTrainContext(rollingstockName))
    return getTextureText(rollingStock, fleache)
end

local camera = state.camera

--- Definiert die Position der Benutzer-definierten Mitfahrkamera in Relation zum Fahrzeug (EEP 16.1)
-- Aufruf ueber Taste 9
-- @param rollingstockName Name des Rollmaterials
-- @param PosX Kameraposition
-- @param PosY Kameraposition
-- @param PosZ Kameraposition
-- @param RotX Kameraausrichtung (Drehung)
-- @param RotY Kameraausrichtung (Drehung)
-- @param RotZ Kameraausrichtung (Drehung)
-- @param setDirectly boolean Soll die Kamera sofort gesetzt werden
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPRollingstockSetUserCamera(rollingstockName, PosX, PosY, PosZ, RotH, RotV, arg7, arg8)
    local setDirectly = arg8 ~= nil and arg8 or arg7
    camera.userRollingstock[rollingstockName] = {
        PosX = PosX,
        PosY = PosY,
        PosZ = PosZ,
        RotH = RotH,
        RotV = RotV,
        setDirectly = setDirectly == true or setDirectly == 1
    }

    if camera.userRollingstock[rollingstockName].setDirectly then
        camera.rollingstockName = rollingstockName
        camera.PosX = PosX
        camera.PosY = PosY
        camera.PosZ = PosZ
        camera.RotX = 0
        camera.RotY = RotH
        camera.RotZ = RotV
        camera.setDirectly = true
    end

    return true
end

function EEPRollingstockGetUserCamera(rollingstockName)
    local userCamera = camera.userRollingstock[rollingstockName]
    if not userCamera then return false, nil, nil, nil, nil, nil end
    return true, userCamera.PosX, userCamera.PosY, userCamera.PosZ, userCamera.RotH, userCamera.RotV
end

--- Ermittelt die aktuelle Position der Kamera (EEP 16.1)
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return PosX Kameraposition
-- @return PosY Kameraposition
-- @return PosZ Kameraposition
function EEPGetCameraPosition() return true, camera.PosX or 0, camera.PosY or 0, camera.PosZ or 0 end

--- Ermittelt die aktuelle Ausrichtung der Kamera (EEP 16.1)
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return RotX Kameraausrichtung (Drehung)
-- @return RotY Kameraausrichtung (Drehung)
-- @return RotZ Kameraausrichtung (Drehung)
function EEPGetCameraRotation() return true, camera.RotX or 0, camera.RotY or 0, camera.RotZ or 0 end

--- Definiert die Kameraposition (EEP 16.1)
-- @param PosX Kameraposition
-- @param PosY Kameraposition
-- @param PosZ Kameraposition
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPSetCameraPosition(PosX, PosY, PosZ)
    camera.PosX = PosX
    camera.PosY = PosY
    camera.PosZ = PosZ
    return true
end

--- Definiert die Kameraausrichtung (EEP 16.1)
-- @param RotX Kameraausrichtung (Drehung)
-- @param RotY Kameraausrichtung (Drehung)
-- @param RotZ Kameraausrichtung (Drehung)
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPSetCameraRotation(RotX, RotY, RotZ)
    camera.RotX = RotX
    camera.RotY = RotY
    camera.RotZ = RotZ
    return true
end

--- Ermittelt, ob der Rauch des benannten Rollmaterials, an- oder ausgeschaltet ist. (EEP 16.1)
-- @param rollingstockName Name des Rollmaterials
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return status Rauch aus = 0, an = 1
function EEPRollingstockGetSmoke(rollingstockName) return true, 0 end

--- Schaltet den Rauch des bennanten Rollmaterials an oder aus. (EEP 16.1)
-- @param rollingstockName Name des Rollmaterials
-- @param status Rauch an = true oder aus = false
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPRollingstockSetSmoke(rollingstockName, status) return true end

--- Ermittelt die Ausrichtung des Ladegutes. (EEP 16.1)
-- @param goodsName Name des Ladeguts
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return RotX Ausrichtung (Drehung)
-- @return RotY Ausrichtung (Drehung)
-- @return RotZ Ausrichtung (Drehung)
function EEPGoodsGetRotation(goodsName) return true, 60, 10, -20 end

--- Ermittelt die Ausrichtung der Immobilie/des Landschaftselementes. (EEP 16.1)
-- 0 @param immobilieName Name der Immobilie/des Landschaftselementes.
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return RotX Ausrichtung (Drehung)
-- @return RotY Ausrichtung (Drehung)
-- @return RotZ Ausrichtung (Drehung)
function EEPStructureGetRotation(immobilieName) return true, 60, 10, -20 end

local WindIntensity, RainIntensity, SnowIntensity, HailIntensity, FogIntensity, CloudIntensity

--- Ermittelt die Windstaerke. (EEP 16.1)
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return intensity Windstaerke in Prozent (%)
function EEPGetWindIntensity() return true, WindIntensity or 10 end

--- Ermittelt die Niederschlagintensitaet. (EEP 16.1)
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return intensity Niederschlagintensitaet in Prozent (%)
function EEPGetRainIntensity() return true, RainIntensity or 10 end

--- Ermittelt die Schneeintensitaet (EEP 16.1)
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return intensity Schneeintensitaet in Prozent (%)
function EEPGetSnowIntensity() return true, SnowIntensity or 10 end

--- Ermittelt die Hagelintensitaet (EEP 16.1)
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return intensity Hagelintensitaet in Prozent (%)
function EEPGetHailIntensity() return true, HailIntensity or 10 end

--- Ermittelt die Nebelintensitaet (EEP 16.1)
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return intensity Nebelintensitaet in Prozent (%)
function EEPGetFogIntensity() return true, FogIntensity or 10 end

--- Ermittelt der Wolkenanteil (EEP 16.1)
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return intensity Wolkenanteil in Prozent (%)
function EEPGetCloudsIntensity() return true, CloudIntensity or 10 end

-- Rueckwaertskompatibel: alter Name.
function EEPGetCloudIntensity() return EEPGetCloudsIntensity() end

--- Definiert die Windstaerke (EEP 16.1)
-- @param Windstaerke
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPSetWindIntensity(intensity)
    WindIntensity = intensity
    return true
end

--- Veraendert die Niederschlagintensitaet (EEP 16.1)
-- @param Niederschlagintensitaet
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPSetRainIntensity(intensity)
    RainIntensity = intensity
    return true
end

--- Veraendert die Schneeintensitaet (EEP 16.1)
-- @param Schneeintensitaet
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPSetSnowIntensity(intensity)
    SnowIntensity = intensity
    return true
end

--- Veraendert die Hagelintensitaet (EEP 16.1)
-- @param Hagelintensitaet
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPSetHailIntensity(intensity)
    HailIntensity = intensity
    return true
end

--- Veraendert die Nebelintensitaet (EEP 16.1)
-- @param Nebelintensitaet
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPSetFogIntensity(intensity)
    FogIntensity = intensity
    return true
end

--- Veraendert den Wolkenanteil (EEP 16.1)
-- @param Wolkenanteil
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPSetCloudsIntensity(intensity)
    CloudIntensity = intensity
    return true
end

--- EEP ruft selbstaendig diese Funktion auf, wenn die Anlage gespeichert wird. (EEP 16.1)
-- Im Skript definiert man die zugehoerige Funktion und legt so fest, was beim Speichern der Anlage zu tun ist.
-- @param path Speicherpfad der Anlage einschlieﬂlich Dateiname
function EEPOnSaveAnl(path) end

function EEPPause(value) end

return EepSimulator
