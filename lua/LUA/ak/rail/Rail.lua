if AkDebugLoad then print("Loading ak.rail.Rail ...") end
local StorageUtility = require("ak.storage.StorageUtility")
local fmt = require("ak.core.eep.AkTippTextFormat")

dbg = {
    anforderung = true,
    bahnhof = false,
    error = true,
    fs_pruefung = true,
    fs_schaltung = true,
    signal_aenderung = false,
    weiche_aenderung = false,
    ampel = false,
    types = false,
}

function pdbg(level, msg)
    if (level) then print(msg) end
end

local allRoutes = {}
local allSignals = {}
local allSwitches = {}
local allStations = {}
local ROUTE_REQUESTS = {}
local ROUTE_CROSSINGS_SECURE_TIME = {}


local function registerFahrstrasse(route)
    assert(not allRoutes[route])
    for otherRoute, _ in pairs(allRoutes) do
        --        if route.block1 == otherRoute.block1
        --                or route.block1 == otherRoute.block2
        --                or route.block2 == otherRoute.block1
        --                or route.block2 == otherRoute.block2 then
        --            route.conflicts[otherRoute] = true
        --            otherRoute.conflicts[route] = true
        --        end

        for _, fsSignal in ipairs(route.signals) do
            for _, otherFsSignal in ipairs(otherRoute.signals) do
                if (fsSignal.signalId == otherFsSignal.signalId) then
                    route.conflicts[otherRoute] = true
                    otherRoute.conflicts[route] = true
                end
            end
        end
        for _, fsSwitch in ipairs(route.switches) do
            for _, otherFsSwitch in ipairs(otherRoute.switches) do
                if (fsSwitch.switchId == otherFsSwitch.switchId) then
                    route.conflicts[otherRoute] = true
                    otherRoute.conflicts[route] = true
                end
            end
        end
    end
    allRoutes[route] = true
end

local function registerSignal(signalId)
    if not allSignals[signalId] then
        allSignals[signalId] = true
        _G["EEPOnSignal_" .. signalId] = function(x)
            pdbg(dbg.signal_aenderung, "****** Signalstellung (" .. signalId .. ") geaendert auf: " .. x)
            EEPChangeInfoSignal(signalId, "Signal: " .. signalId .. "\nStellung: " .. x)
            EEPShowInfoSignal(signalId, true)
        end
        pdbg(dbg.debug, "Registered: " .. "EEPOnSignal_" .. signalId)
        EEPRegisterSignal(signalId)
    end
end

local function registerSwitch(switchId)
    if not allSwitches[switchId] then
        allSwitches[switchId] = true
        _G["EEPOnSwitch_" .. switchId] = function(x)
            pdbg(dbg.weiche_aenderung, "****** Weichenstellung (" .. switchId .. ") geaendert auf: " .. x)
            EEPChangeInfoSwitch(switchId, "Weiche: " .. switchId .. "\nStellung: " .. x)
            EEPShowInfoSwitch(switchId, true)
        end
        pdbg(dbg.debug, "Registered: " .. "EEPOnSwitch_" .. switchId)
        EEPRegisterSwitch(switchId)
    end
end

--- Signalstellungen fuer eine Fahrstrasse
--
AkFsSignal = {}
AkFsSignal.__index = AkFsSignal

--- Neue Signalstellung anlegen
-- @param switchId EEP signal ID
-- @param positionForRoute Stellung fuer das Signal, wenn die Fahrstrasse freigeschaltet werden soll
-- @param defaultPosition Stellung fuer das Signal, wenn die Fahrstrasse aufgeloest werden soll
--
function AkFsSignal.new(signalId, positionForRoute, defaultPosition)
    assert(type(signalId) == "number")
    assert(type(positionForRoute) == "number")
    assert(type(defaultPosition) == "number")
    registerSignal(signalId)

    local self = setmetatable({}, AkFsSignal)
    self.signalId = signalId
    self.positionForRoute = positionForRoute
    self.defaultPosition = defaultPosition
    return self
end

function AkFsSignal:setRoutePosition(trainName, route)
    pdbg(dbg.signal_aenderung, " - Stelle Signal: " .. self.signalId .. " auf " .. self.positionForRoute)
    EEPSetSignal(self.signalId, self.positionForRoute)
    EEPShowInfoSignal(self.signalId, dbg.fs_schaltung)
    EEPChangeInfoSignal(self.signalId, "<c>: " .. route.name .. " :\n"
            .. "<c>GESCHALTET AUF " .. self.positionForRoute .. " (ROUTE) fuer\n"
            .. "<c>--------------------------------------------\n"
            .. "<j>" .. trainName .. " ")
end

function AkFsSignal:setDefaultPosition(trainName, route)
    pdbg(dbg.signal_aenderung, " - Stelle Signal: " .. self.signalId .. " auf " .. self.defaultPosition)
    EEPSetSignal(self.signalId, self.defaultPosition)
    EEPShowInfoSignal(self.signalId, false)
    EEPChangeInfoSignal(self.signalId, "<c>: " .. route.name .. " :\n"
            .. "<c>GESCHALTET AUF " .. self.defaultPosition .. " (DEFAULT) fuer\n"
            .. "<c>--------------------------------------------\n"
            .. "<j>" .. trainName .. " ")
end


--- Weichenstellungen fuer eine Fahrstrasse
--
AkFsSwitch = {}
AkFsSwitch.__index = AkFsSwitch

--- Neue Weichenstellung anlegen
-- @param switchId EEP Weichen-ID
-- @param positionForRoute Stellung fuer die Weiche, wenn die Fahrstrasse freigeschaltet werden soll
-- @param standardPosition Stellung fuer die Weiche, wenn die Fahrstrasse aufgeloest werden soll
--
function AkFsSwitch.new(switchId, routeStand, defaultStand)
    assert(type(switchId) == "number")
    assert(type(routeStand) == "number")
    assert(type(defaultStand) == "number")
    registerSwitch(switchId)

    local self = setmetatable({}, AkFsSwitch)
    self.switchId = switchId
    self.positionForRoute = routeStand
    self.defaultStand = defaultStand
    return self
end

function AkFsSwitch:setRouteStand(trainName, route)
    assert(trainName)
    assert(route)
    pdbg(dbg.weiche_aenderung, " - Stelle Weiche: " .. self.switchId .. " auf " .. self.positionForRoute)
    EEPSetSwitch(self.switchId, self.positionForRoute)
    EEPShowInfoSwitch(self.switchId, dbg.fs_schaltung)
    EEPChangeInfoSwitch(self.switchId, "<c>: " .. route.name .. " :\n"
            .. "<c>GESCHALTET AUF " .. self.positionForRoute .. " (ROUTE) FueR\n"
            .. "<c>--------------------------------------------\n"
            .. "<j>" .. trainName .. " ")
end

function AkFsSwitch:setDefaultStand(trainName, route)
    pdbg(dbg.weiche_aenderung, " - Stelle Weiche: " .. self.switchId .. " auf " .. self.defaultStand)
    EEPSetSwitch(self.switchId, self.defaultStand)
    EEPShowInfoSwitch(self.switchId, false)
    EEPChangeInfoSwitch(self.switchId, "<c>: " .. route.name .. " :\n"
            .. "<c>GESCHALTET AUF " .. self.defaultStand .. " (DEFAULT) FueR\n"
            .. "<c>--------------------------------------------\n"
            .. "<j>" .. trainName .. " ")
end

--- Schranken fuer Bahnuebergang
--
AkCrossing = {}
AkCrossing.__index = AkCrossing

--- Neuen Bahnuebergang
-- @param signalId1 EEP Weichen-ID
-- @param signalId2 EEP Weichen-ID
-- @param positionForRoute Stellung fuer die Weiche, wenn die Fahrstrasse freigeschaltet werden soll
-- @param standardPosition Stellung fuer die Weiche, wenn die Fahrstrasse aufgeloest werden soll
-- @param requiredClosingTime Zeit, die die Schranken zum Schliessen brauchen
--
function AkCrossing.new(signalId1, signalId2, stellungFahrstrasse, stellungStandard, requiredClosingTime)
    assert(type(signalId1) == "number")
    assert(type(signalId2) == "number")
    assert(type(stellungFahrstrasse) == "number")
    assert(type(stellungStandard) == "number")
    assert(type(requiredClosingTime) == "number")
    registerSignal(signalId1)
    registerSignal(signalId2)

    local self = setmetatable({}, AkCrossing)
    self.signalId1 = signalId1
    self.signalId2 = signalId2
    self.positionForRoute = stellungFahrstrasse
    self.defaultPosition = stellungStandard
    self.requiredClosingTime = requiredClosingTime
    self.currentClosingTime = -1
    self.routen = {}
    return self
end

function AkCrossing:closeForRoute(trainName, route)
    assert(trainName)
    assert(route)
    local alreadyBlocked = false
    for fs, _ in pairs(self.routen) do
        alreadyBlocked = true
        print("Bahnuebergang bereits blockiert durch: " .. fs.name)
    end
    self.routen[route] = true

    if not alreadyBlocked then
        pdbg(dbg.signal_aenderung, " - Stelle Schranke: " .. self.signalId1 .. " auf " .. self.positionForRoute)
        pdbg(dbg.signal_aenderung, " - Stelle Schranke: " .. self.signalId2 .. " auf " .. self.positionForRoute)
        EEPSetSignal(self.signalId1, self.positionForRoute)
        EEPSetSignal(self.signalId2, self.positionForRoute)
        EEPShowInfoSignal(self.signalId1, dbg.fs_schaltung)
        EEPShowInfoSignal(self.signalId2, dbg.fs_schaltung)
        local info = "<c>: " .. route.name .. " :\n"
                .. "<c>GESCHALTET AUF " .. self.positionForRoute .. " FueR\n"
                .. "<c>--------------------------------------------\n"
                .. "<j>" .. trainName .. " "
        EEPChangeInfoSignal(self.signalId1, info)
        EEPChangeInfoSignal(self.signalId2, info)
        self.currentClosingTime = EEPTime + self.requiredClosingTime
    end

    return self.currentClosingTime
end

function AkCrossing:openForRoute(trainName, route)
    assert(trainName)
    assert(route)
    self.routen[route] = nil

    local stillBlocked = false
    for fs, _ in pairs(self.routen) do
        stillBlocked = true
        print("Bahnuebergang noch blockiert durch: " .. fs.name)
    end

    if not stillBlocked then
        pdbg(dbg.signal_aenderung, " - Stelle Schranke: " .. self.signalId1 .. " auf " .. self.defaultPosition)
        pdbg(dbg.signal_aenderung, " - Stelle Schranke: " .. self.signalId2 .. " auf " .. self.defaultPosition)
        EEPSetSignal(self.signalId1, self.defaultPosition)
        EEPSetSignal(self.signalId2, self.defaultPosition)
        EEPShowInfoSignal(self.signalId1, false)
        EEPShowInfoSignal(self.signalId2, false)
        local info = "<c>: " .. route.name .. " :\n"
                .. "<c>GESCHALTET AUF " .. self.defaultPosition .. " FueR\n"
                .. "<c>--------------------------------------------\n"
                .. "<j>" .. trainName .. " "
        EEPChangeInfoSignal(self.signalId1, info)
        EEPChangeInfoSignal(self.signalId2, info)
        self.currentClosingTime = -1
    end
    return 0
end


--- Ein Block (Gleisabschnitt), in dem sich nur ein Zug aufhalten kann.
--- Der Block "weiss", welcher Zug sich in ihm befindet und in welche Richtung er will.
--- -------------------------------------------------------------------
--- A block (piece of track), where only one train can be at a time.
--- The block "knows" about its train and the trains direction
AkBlock = {}
AkBlock.__index = AkBlock

--- Erzeugt einen neuen Block.
--- --------------------------
--- Creates a new block.
-- @param name Name des Blocks
-- @param eepSaveId Id, unter der die Belegung des Blocks gespeichert wird
function AkBlock.new(name, eepSaveId)
    assert(type(name) == "string")
    assert(type(eepSaveId) == "number")
    StorageUtility.registerId(eepSaveId, name)
    local self = setmetatable({}, AkBlock)
    self.name = name
    self.eepSaveId = eepSaveId
    self.routes = {}
    self.stopMarkers = {}
    self:load()
    return self
end

--- Fuegt dem Block eine neue Route in eine Richtung hinzu
--- --------------------------------------------------------
--- Adds a new route for a direction of this block
function AkBlock:addRoute(route, direction)
    assert(route)
    assert(direction and type(direction) == "string")
    local routesForDirection = self.routes[direction] or {}
    table.insert(routesForDirection, route)
    self.routes[direction] = routesForDirection
end

function AkBlock:getRoutesToCurrentTrainDirection()
    if not self.trainDirection then
        print("ERROR: Train in Block \"" .. self.name .. "\" has no direction set in \"enterReservedBlock()\"\n"
                .. debug.traceback())
        return {}
    end
    return self.routes[self.trainDirection]
end

function AkBlock:findFreeRoute()
    if not self.taken then
        print("ERROR: Block \"" .. self.name .. "\" war nicht belegt!" .. "\n" .. debug.traceback())
    end
    for _, route in ipairs(self:getRoutesToCurrentTrainDirection()) do
        assert(route.block1 == self)
        assert(route.block2 ~= self)

        if route:canBeUsed() then return route end
    end
    return nil
end

function AkBlock:hasRoutes()
    return nil ~= next(self.routes)
end

function AkBlock:reset()
    self.taken = false
    self.trainDirection = nil
    self.trainName = nil
    self:save()
end

function AkBlock:save()
    local data = {}
    data["n"] = self.name
    data["b"] = tostring(self.taken)
    data["r"] = self.trainDirection and tostring(self.trainDirection) or nil
    data["z"] = self.trainName and tostring(self.trainName) or nil
    StorageUtility.saveTable(self.eepSaveId, data, "Block " .. self.name)
end

function AkBlock:load()
    local data = StorageUtility.loadTable(self.eepSaveId, "Block " .. self.name)
    self.taken = StorageUtility.toboolean(data["b"])
    self.trainDirection = data["r"] and data["r"] or nil
    self.trainName = data["z"] and data["z"] or nil

    assert(type(self.taken) == "boolean")
    assert(not self.trainName or type(self.trainName) == "string")
    assert(not self.trainDirection or type(self.trainDirection) == "string")

    if (self.trainDirection and self.trainName) then
        ROUTE_REQUESTS[self] = EEPTime
    end
end

function AkBlock:reserve(trainName)
    assert(trainName)
    if (self.taken) then
        print("ERROR: Block \"" .. self.name .. "\" already locked by "
                .. (self.trainName and self.trainName or "UNKNOWN TRAIN") .. "\n" .. debug.traceback())
    end
    self.taken = true
    self.trainName = trainName
    self:save()
end

function AkBlock:enterReservedBlock(trainName, trainDirection)
    assert(trainName)
    assert(trainDirection)
    if trainName ~= self.trainName then
        print("ERROR: Block " .. self.name
                .. " reserved for .: " .. (self.trainName and self.trainName or "UNKNOWN TRAIN")
                .. " but entered by: " .. (trainName and trainName or "UNKNOWN TRAIN") .. "\n" .. debug.traceback())
    end
    if not self.taken then
        print("ERROR: Block \"" .. self.name .. "\" was not reserved!" .. "\n" .. debug.traceback())
    end
    self.taken = true
    self.trainName = trainName
    self.trainDirection = trainDirection

    local offset = 0 -- 2 Minuten Aufenthalt fuer Personenzuege an Gleisen
    if string.match(trainName, "ersonen") and string.match(self.name, "Gleis") then
        offset = 2 * 60
    end
    ROUTE_REQUESTS[self] = EEPTime + offset
    self:save()
end

function AkBlock:reservationDone()
    pdbg(dbg.fs_pruefung, "Entferne Anforderung fuer Block \"" .. self.name .. "\" (" .. self.eepSaveId .. ")")
    ROUTE_REQUESTS[self] = nil
    self:save()
end

function AkBlock:leaveBlock(trainName)
    assert(trainName)
    if self.trainName ~= trainName then
        print("ERROR: Block \"" .. self.name .. "\" left by wrong train:"
                .. " \n...... expected to leave: " .. (self.trainName and self.trainName or "UNBEKANNT")
                .. " \n...... left the block:    " .. trainName
                .. "\n" .. debug.traceback())
    end
    self.taken = false
    self.trainName = nil
    self.trainDirection = nil
    self:save()
end

function AkBlock:addStopMarker(akSignal)
    self.stopMarkers[akSignal] = true
end

function AkBlock:getAllStopMarkers()
    return self.stopMarkers
end

function AkBlock:print()
    print(self.name .. ": "
            .. (self.taken and ("belegt von " .. self.trainName) or ("frei")))
end

function AkBlock:formattedText()
    local text = self.name .. ": "
    if self.taken then
        text = text .. fmt.bold("BELEGT") .. " " .. fmt.italic(self.trainName and self.trainName or "UNBEKANNT")
    else
        text = text .. fmt.bold("frei")
    end
    return text
end


--- Einstellungen fuer Routen
AkRoute = {}
AkRoute.__index = AkRoute
AkRoute.conflicts = {}

--- Creates a new route, which is used to transfer a train from one block, to another.
--
function AkRoute.new(eepSaveId, direction, block1, block2, signals, switches, crossings)
    assert(type(eepSaveId) == "number")
    assert(type(direction) == "string")
    assert(type(block1) == "table")
    assert(type(block2) == "table")
    assert(type(signals) == "table")
    assert(type(switches) == "table")
    if (crossings) then assert(type(crossings) == "table") end
    StorageUtility.registerId(eepSaveId, block1.name .. " -> " .. direction .. " -> " .. block2.name)

    local self = setmetatable({}, AkRoute)
    self.eepSaveId = eepSaveId
    self.name = block1.name .. " -> " .. block2.name
    self.block1 = block1
    self.block2 = block2
    self.signals = signals
    self.switches = switches
    self.crossings = crossings
    self.conflicts = {}
    self.shortTrainStopMarkers = {}
    registerFahrstrasse(self)

    self.block1:addRoute(self, direction)

    self:load()

    return self
end

function AkRoute:addShortTrainStopMarker(akSignal, eepRoutePrefix)
    assert(akSignal)
    assert(type(eepRoutePrefix) == "string")
    self.shortTrainStopMarkers[eepRoutePrefix] = akSignal
    self.block2:addStopMarker(akSignal)
end

function AkRoute:stopMarkerFor(trainName)
    local b, route = EEPGetTrainRoute(trainName)
    if b then
        for prefix, akSignal in pairs(self.shortTrainStopMarkers) do
            --print("Pruefe " .. prefix .. " gegen " .. string.sub(route, 1, string.len(prefix)))
            if prefix == string.sub(route, 1, string.len(prefix)) then
                return akSignal
            end
        end
    end
    return nil
end

function AkRoute:block1StopMarkers()
    local stopMarkers = {}
    for marker in pairs(self.block1:getAllStopMarkers()) do table.insert(stopMarkers, marker) end
    return stopMarkers
end

function AkRoute:allStopMarkers()
    local stopMarkers = {}
    for marker in pairs(self.block1:getAllStopMarkers()) do table.insert(stopMarkers, marker) end
    for marker in pairs(self.block2:getAllStopMarkers()) do table.insert(stopMarkers, marker) end
    return stopMarkers
end

--- Gibt true zurueck, wenn die andere Fahrstrasse ueberlappt
-- @param otherRoute
-- @return true wenn die andere Fahrstrasse einen Konflikt mit der aktuellen hat
function AkRoute:conflictsWith(otherRoute)
    return self.conflicts[otherRoute] and true or false
end

--- Schreibt die Konflikte der anderen Fahrstrassen
function AkRoute:printConflicts()
    print("Konflikte fuer: " .. self.name)
    for otherRoute, _ in pairs(self.conflicts) do
        print(" - " .. otherRoute.name .. " - " .. (otherRoute.taken and "belegt" or "frei"))
    end
end

function AkRoute:canBeUsed()
    if self.taken then return false end

    for otherRoute, _ in pairs(self.conflicts) do
        if otherRoute.taken then return false end
    end

    if self.block2.taken then return false end

    return true
end

function AkRoute:reserveRoute(trainName)
    assert(trainName)
    assert(type(trainName) == "string")
    pdbg(dbg.fs_schaltung, "Reserviere Fahrstrasse \"" .. self.name .. "\" fuer " .. trainName)
    self.taken = true
    self.trainName = trainName
    local maxClosingTime = EEPTime
    if self.crossings then
        pdbg(dbg.fs_schaltung, "Sichere Bahnuebergaenge in Fahrstrasse \"" .. self.name .. "\" fuer " .. trainName)
        for _, akCrossing in ipairs(self.crossings) do
            local closingTime = akCrossing:closeForRoute(trainName, self)
            maxClosingTime = closingTime > maxClosingTime and closingTime or maxClosingTime
        end
    end

    self.securedTime = maxClosingTime
    ROUTE_CROSSINGS_SECURE_TIME[self] = self.securedTime

    self.block1:reservationDone()
    self:save()
end

function AkRoute:setSecured()
    self.securedTime = -1
    ROUTE_CROSSINGS_SECURE_TIME[self] = nil
end

function AkRoute:lockRoute(trainName)
    assert(trainName)
    if self.trainName ~= trainName then
        print("ERROR: Switching route \"" .. self.name .. "\""
                .. "\n reserved for ...: " .. (self.trainName or "UNKNOWN TRAIN")
                .. "\n but switched for: " .. (trainName or "UNKNOWN TRAIN")
                .. "\n" .. debug.traceback())
    end
    if self.block2.taken then
        print("ERROR: Switching route \"" .. self.name .. "\""
                .. "\n Block " .. self.block2.name .. " already locked."
                .. "\n" .. debug.traceback())
    end

    self.block2:reserve(trainName)
    pdbg(dbg.fs_schaltung, "Schalte Fahrstrasse: \"" .. self.name .. "\" fuer " .. trainName)
    pdbg(dbg.fs_schaltung, "1) Setze Haltetafeln zurueck:")
    for _, akSwitch in ipairs(self.switches) do
        akSwitch:setRouteStand(trainName, self)
    end

    pdbg(dbg.fs_schaltung, "2) Setze Haltetafeln auf Fahrt:")
    for _, akSignal in ipairs(self:allStopMarkers()) do
        akSignal:setRoutePosition(trainName, self)
    end

    pdbg(dbg.fs_schaltung, "3) Schalte Haltetafel fuer " .. trainName)
    local stopMarker = self:stopMarkerFor(trainName)
    if stopMarker then
        stopMarker:setDefaultPosition(trainName, self)
    end
    self:save()

    pdbg(dbg.fs_schaltung, "4) Schalte Signale:")
    for _, akSignal in ipairs(self.signals) do
        akSignal:setRoutePosition(trainName, self)
    end
end

--- Entsperrt die Fahrstrasse und schaltet die Signale und Weichen in die Standardstellung
-- @param trainName Name des Zuges
--
function AkRoute:unlockRoute(trainName)
    pdbg(dbg.fs_schaltung, "Gebe Fahrstrasse: \"" .. self.name .. "\" nach Verlassen von " .. trainName .. " frei.")
    if self.trainName ~= trainName then
        print("ERROR: Route \"" .. self.name .. "\" unlocking by unexpected train"
                .. "\n reserved for: " .. (self.trainName and self.trainName or "UNKNOWN TRAIN")
                .. "\n unlocked by : " .. (trainName and trainName or "UNKNOWN TRAIN")
                .. "\n" .. debug.traceback())
    end

    local maxOpeningTime = 0
    if (self.crossings) then
        for _, akCrossing in ipairs(self.crossings) do
            local openingTime = akCrossing:openForRoute(trainName, self)
            maxOpeningTime = (openingTime > maxOpeningTime) and openingTime or maxOpeningTime
        end
    end

    for _, akSwitch in ipairs(self.switches) do
        akSwitch:setDefaultStand(trainName, self)
    end

    for _, akSignal in ipairs(self.signals) do
        akSignal:setDefaultPosition(trainName, self)
    end

    for _, akSignal in ipairs(self:block1StopMarkers()) do
        akSignal:setDefaultPosition(trainName, self)
    end
    self.taken = false
    self.trainName = nil
    self.securedTime = -1
    self:save()
end

--- Hard reset, if nothing else works
--
function AkRoute:reset()
    self.taken = false
    self.trainName = nil
    self.securedTime = -1
    for _, akSwitch in ipairs(self.switches) do
        akSwitch:setDefaultStand("RESET", self)
    end
    for _, akSignal in ipairs(self.signals) do
        akSignal:setDefaultPosition("RESET", self)
    end
    self:save()
end

function AkRoute:save()
    local data = {}
    data["n"] = self.name
    data["b"] = tostring(self.taken)
    data["z"] = tostring(self.trainName)
    data["t"] = tostring(self.securedTime)
    StorageUtility.saveTable(self.eepSaveId, data, "FS " .. self.name)
end

function AkRoute:load()
    local data = StorageUtility.loadTable(self.eepSaveId, "FS " .. self.name)
    self.taken = StorageUtility.toboolean(data["b"])
    self.trainName = data["z"] and data["z"] or nil
    self.securedTime = data["t"] and tonumber(data["t"]) or -1

    assert(type(self.taken) == "boolean")
    assert(not self.trainName or type(self.trainName) == "string")

    ROUTE_CROSSINGS_SECURE_TIME[self] = self.securedTime > -1 and self.securedTime or nil
end

function AkRoute:formattedText()
    local text = self.name .. ": "
    if self.taken then
        text = text .. fmt.bold("BELEGT") .. " " .. fmt.italic(self.trainName and self.trainName or "UNBEKANNT")
    else
        text = text .. fmt.bold("frei")
    end
    return text
end


AkStation = {}
AkStation.__index = AkStation

--- Create a new station with a name.
-- A station has some tracks, which should be added by the addBlock() method
-- @param name
--
function AkStation.new(name)
    assert(type(name) == "string")
    local self = setmetatable({}, AkStation)
    self.name = name
    self.tracks = {}
    self.infoStructures = {}
    allStations[self] = true
    return self
end

--- This will add a block to that station, which means a track
-- @param block - must be of Type AkBlock
--
function AkStation:addBlock(block)
    table.insert(self.tracks, block)
end

function AkStation:print()
    print(self.name)
    for _, block in ipairs(self.tracks) do
        block:print();
    end
end

--- Hinzufuegen einer Immobilie, fuer die der Bahnhof im Tooltip angezeigt werden soll
-- @param structure Name of the structure
-- @param alwaysVisible if true, the tooltip will always be visible
--
function AkStation:addInfoStructure(structure, alwaysVisible)
    assert(structure)
    assert(type(structure) == "string")
    assert(type(self.infoStructures) == "table")
    self.alwaysVisible = alwaysVisible
    self.infoStructures[structure] = alwaysVisible or false
end

--- Entfernen einer Immobilie, fuer die der Bahnhof im Tooltip angezeigt werden soll
-- @param structure Name of the structure
--
function AkStation:removeInfoStructure(structure)
    assert(structure)
    assert(type(structure) == "string")
    self.infoStructures[structure] = nil
end

function AkStation:showInfo()
    local formattedText = "<c>" .. fmt.bold(self.name) .. "\n---------------------------------------"
    for _, route in ipairs(self.tracks) do
        formattedText = formattedText .. "\n<j>" .. "- " .. route:formattedText() .. "</j><br>";
    end
    for s in pairs(self.infoStructures) do
        --EEPChangeInfoStructure(s, "BERECHNE TEXT ...")
        EEPShowInfoStructure(s, self.alwaysVisible or dbg.fs_schaltung)
        EEPChangeInfoStructure(s, formattedText)
    end
end


AkSignalTower = {}
AkSignalTower.__index = AkSignalTower

--- Create a new station with a name.
-- A station has some tracks, which should be added by the addBlock() method
-- @param name
--
function AkSignalTower.new(name)
    assert(type(name) == "string")
    local self = setmetatable({}, AkSignalTower)
    self.name = name
    self.tracks = {}
    self.infoStructures = {}
    allStations[self] = true
    return self
end

--- This will add a block to that station, which means a track
-- @param block - must be of Type AkBlock
--
function AkSignalTower:addBlock(route)
    table.insert(self.tracks, route)
end

function AkSignalTower:print()
    print(self.name)
    for _, block in ipairs(self.tracks) do
        block:print();
    end
end

--- Hinzufuegen einer Immobilie, fuer die der Bahnhof im Tooltip angezeigt werden soll
-- @param structure Name of the structure
-- @param alwaysVisible if true, the tooltip will always be visible
--
function AkSignalTower:addInfoStructure(structure, alwaysVisible)
    assert(structure)
    assert(type(structure) == "string")
    assert(type(self.infoStructures) == "table")
    self.infoStructures[structure] = alwaysVisible or false
end

--- Entfernen einer Immobilie, fuer die der Bahnhof im Tooltip angezeigt werden soll
-- @param structure Name of the structure
--
function AkSignalTower:removeInfoStructure(structure)
    assert(structure)
    assert(type(structure) == "string")
    self.infoStructures[structure] = nil
end

function AkSignalTower:showInfo()
    local formattedText = "<c>" .. fmt.bold(self.name) .. "\n---------------------------------------"
    for _, block in ipairs(self.tracks) do
        formattedText = formattedText .. "\n<j>" .. "- " .. block:formattedText() .. "</j><br>";
    end
    for s in pairs(self.infoStructures) do
        --EEPChangeInfoStructure(s, "BERECHNE TEXT ...")
        EEPShowInfoStructure(s, self.alwaysVisible or dbg.fs_schaltung)
        EEPChangeInfoStructure(s, formattedText)
    end
end



AkTrainControl = {}
AkTrainControl.__index = AkTrainControl
local ROUTE_CALCULATION_TIMEOUT_SECONDS = 5
local lastRouteCalculation = -1

function AkTrainControl.requestRoute(trainName, block, trainDirection)
    pdbg(dbg.fs_schaltung, "Reserving Block " .. block.name .. " to " .. trainDirection .. " for " .. trainName)
    if block.taken == false then
        block:reserve(trainName)
    end
    block:enterReservedBlock(trainName, trainDirection)
end

function AkTrainControl.clearRoutes(trainName, ...)
    assert(trainName)
    assert(...)

    for _, route in pairs(...) do
        if route.taken == true or route.block1.trainName == trainName then
            pdbg(dbg.fs_schaltung, "Gebe Fahrstrasse " .. route.name .. " frei.")
            route:unlockRoute(trainName)
            route.block1:leaveBlock(trainName)

            -- Hack for the last block
            if not route.block2:hasRoutes() then
                pdbg(dbg.fs_schaltung,
                    "HACK: Resetting Block: \"" .. route.block2.name .. "\" because it has no routes.")
                route.block2:reset()
            end
        end
    end

    for b in pairs(allStations) do
        b:showInfo()
    end
end

--- Berechnet, ob es Zeit fuer die Kalkulation der Route ist
--
local function timeForRouteCalculation()
    local currentTime = EEPTime
    local runCalc = false
    -- Zeitsprung um Mitternacht (60*60*24=86400 Sekunden)
    if lastRouteCalculation > currentTime then lastRouteCalculation = lastRouteCalculation - 86400 end
    if math.abs(lastRouteCalculation - currentTime) >= ROUTE_CALCULATION_TIMEOUT_SECONDS then
        runCalc = true
        lastRouteCalculation = currentTime
    end
    --pdbg(dbg.fs_pruefung, "Letzte Pruefung: " .. lastRouteCalculation .. " ... aktuelle Zeit: " .. currentTime .. "")
    return runCalc
end

local function timeHasCome(currentTime, scheduledTime)
    assert(type(currentTime) == "number")
    assert(type(scheduledTime) == "number")
    local zeitIstReif = false
    if scheduledTime >= 86400 and currentTime < 43200 and currentTime + 86400 >= scheduledTime then
        zeitIstReif = true
    elseif currentTime >= scheduledTime then
        zeitIstReif = true
    end
    return zeitIstReif
end

--- Berechnet alle routen
--
function AkTrainControl.calculateRoutes()
    if not timeForRouteCalculation() then
        return
    end
    local currentTime = EEPTime

    pdbg(dbg.debug, "Pruefe Fahrstrassen ... " .. EEPTime)

    -- Fahrstrassen sichern (crossings)
    --  a) Fahrstrassen merken, die noch nicht gesichert sind
    for blockAnforderung, scheduledTime in pairs(ROUTE_REQUESTS) do
        if timeHasCome(currentTime, scheduledTime) then
            local route = blockAnforderung:findFreeRoute()
            if route then
                route:reserveRoute(blockAnforderung.trainName or "UNBEKANNT")
            else
                pdbg(dbg.debug, "Keine freie Fahrstrasse fuer " .. blockAnforderung.eepSaveId
                        .. " (" .. blockAnforderung.name .. " -> "
                        .. (blockAnforderung.trainDirection and blockAnforderung.trainDirection or "NO DIRECTION!")
                        .. ")")
            end
        else
            pdbg(dbg.fs_pruefung, "Fahrstrasse fuer "
                    .. blockAnforderung.name .. " Richtung " .. (blockAnforderung.trainDirection or "UNBEKANNT")
                    .. " wird spaeter angefordert: " .. scheduledTime .. " (" .. currentTime .. ")")
        end
    end

    local securedRoutes = {}
    for route, scheduledTime in pairs(ROUTE_CROSSINGS_SECURE_TIME) do
        if timeHasCome(currentTime, scheduledTime) then
            route:setSecured()
            table.insert(securedRoutes, route)
        else
            pdbg(dbg.fs_pruefung, "Fahrstrasse " .. route.name .. " gesichert in "
                    .. scheduledTime .. " (" .. currentTime .. ")")
        end
    end

    --  b) Fahrstrassen, die gesichert sind koennen geschaltet werden
    for _, route in pairs(securedRoutes) do
        route:lockRoute(route.trainName and route.trainName or "UNBEKANNT")
    end

    for b in pairs(allStations) do
        b:showInfo()
    end
end

function AkTrainControl.reset()
    for route, _ in pairs(allRoutes) do
        route:reset()
        route.block1:reset()
        route.block2:reset()
    end
    for switchId, _ in pairs(allSwitches) do
        EEPShowInfoSwitch(switchId, false)
    end
    for signalId, _ in pairs(allSignals) do
        EEPShowInfoSignal(signalId, false)
    end
    for k, _ in pairs(ROUTE_CROSSINGS_SECURE_TIME) do
        ROUTE_CROSSINGS_SECURE_TIME[k] = nil
    end
    for k, _ in pairs(ROUTE_REQUESTS) do
        ROUTE_REQUESTS[k] = nil
    end
    for b in pairs(allStations) do
        b:showInfo()
    end
end
