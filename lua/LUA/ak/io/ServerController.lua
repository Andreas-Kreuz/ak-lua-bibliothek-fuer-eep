--- Export EEP data / read and execute commands.
-- LuaDoc: http://keplerproject.github.io/luadoc/manual.html
--
--[[ Usage:
-- Do NOT use this class manually
-- Use this class in XxxWebConnector to register JsonCollectors and commands
local ServerController = require("ak.io.ServerController")
--]] -- @author Andreas Kreuz
-- @release 0.10.2
if AkDebugLoad then print("[#Start] Loading ak.io.ServerController ...") end
local EventBroker = require("ak.util.EventBroker")
local EventFileWriter = require("ak.io.EventFileWriter")
local AkWebServerIo = require("ak.io.AkWebServerIo")
local AkCommandExecutor = require("ak.io.AkCommandExecutor")
local RuntimeRegistry = require("ak.util.RuntimeRegistry")
local os = require("os")

local ServerController = {}
ServerController.debug = AkStartWithDebug or false

local function readVersion()
    local file = io.open("LUA/ak/VERSION", "r")
    if file then
        version = file:read()
        file:close()
        return version
    else
        return "NO VERSION IN LUA/ak/VERSION"
    end
end
ServerController.programVersion = readVersion()

local json

-- ACHTUNG: DIE VERWENDUNG ERFOLGT AUF EIGENE GEFAHR. ES IST GUT MOEGLICH,
--          DASS EEP ABSTUERZT, WENN NICHT ALLE ABHAENGIGKEITEN DER BIBLIOTHEK
--          GEFUNDEN WERDEN.
function ServerController.useDlls(enableDlls)
    if enableDlls then
        package.cpath = package.cpath .. ";.\\LUA\\ak\\?.dll"
        if ServerController.debug then print("[#ServerController] " .. package.cpath) end
        json = require("cjson")
        -- Important: Empty tables must not be packed as objects {}, but as lists []
        json.encode_empty_table_as_object(false)
    else
        json = require("ak.third-party.json")
    end
end
ServerController.useDlls(false)

-- checkServerStatus:
-- true: Check status of EEP-Web Server before updating the json file
-- false: Update json file without checking if the EEP-Web Server is ready
ServerController.checkServerStatus = true

local registeredJsonCollectors = {}
local runTimeGroupsToKeep = {}
local collectedData = {}
local initialized = false

function ServerController.addAcceptedRemoteFunction(fName, f) AkCommandExecutor.addAcceptedRemoteFunction(fName, f) end

local function initializeJsonCollector(jsonCollector)
    local t0 = os.clock()
    jsonCollector.initialize()
    local t1 = os.clock()
    local timeDiff = t1 - t0
    if ServerController.debug then
        print(string.format("[#ServerController] initialize() %4.0f ms for \"%s\"", timeDiff * 1000,
                            jsonCollector.name))
    end
    local group = "JsonCollector." .. jsonCollector.name .. ".initialize"
    RuntimeRegistry.storeRunTime(group, timeDiff)
    runTimeGroupsToKeep[group] = true
end

local function collectFrom(jsonCollector, printFirstTime)
    local t0 = os.clock()
    local newData = jsonCollector.collectData()
    local t1 = os.clock()
    local timeDiff = t1 - t0
    if ServerController.debug and (timeDiff > 0.01 or printFirstTime) then
        print(string.format("[#ServerController] collectData() %4.0f ms for \"%s\"", timeDiff * 1000,
                            jsonCollector.name))
    end
    RuntimeRegistry.storeRunTime("JsonCollector." .. jsonCollector.name .. ".collectData", timeDiff)
    return newData
end

local function checkObjects(collectData, path)
    for key, value in pairs(collectData) do
        if type(key) ~= "string" and type(key) ~= "number" then
            error("Key must always be of type string " .. path .. "#" .. type(key))
        end
        if type(value) == "table" then checkObjects(value, path .. ">" .. key) end
        if type(value) == "function" then error("Value must not be a function " .. path .. "#" .. type(key)) end
    end
end

local function collectData(printFirstTime)
    for _, jsonCollector in pairs(registeredJsonCollectors) do
        local newData = collectFrom(jsonCollector, printFirstTime)
        for key, value in pairs(newData) do collectedData[key] = value end
    end

    checkObjects(collectedData, "")
end

--- Initialize data.
-- do it once
local function initialize()
    if ServerController.debug then print("[#ServerController] initialize()") end
    for _, jsonCollector in pairs(registeredJsonCollectors) do initializeJsonCollector(jsonCollector) end

    initialized = true
end

function ServerController.addJsonCollector(...)
    for _, jsonCollector in ipairs({...}) do
        -- Check the jsonCollector
        assert(jsonCollector.name and type(jsonCollector.name) == "string",
        -- "Der Name des Moduls muss gesetzt und ein String sein"
               "The name of the module must be defined and is has to be a string")
        assert(jsonCollector.initialize and type(jsonCollector.initialize) == "function",
        -- "Das Modul muss eine Funktion initialize() besitzen"
               string.format("jsonCollector %s must have a function initialize()", jsonCollector.name))
        assert(jsonCollector.collectData and type(jsonCollector.collectData) == "function",
        -- "Das Modul muss eine Funktion collectData() besitzen"
               string.format("jsonCollector %s must have a function collectData()", jsonCollector.name))

        -- Remember the jsonCollector by it's name
        if ServerController.debug then
            print(string.format("[#ServerController] addJsonCollector(%s)", jsonCollector.name))
        end
        registeredJsonCollectors[jsonCollector.name] = jsonCollector

        if initialized then initializeJsonCollector(jsonCollector) end
    end
end

local function writeData(jsonString) AkWebServerIo.updateJsonFile(jsonString) end

local i = -1

--- Main function of this module.
-- Call this function in main loop of EEP.
-- do it frequently
-- @param modulus Repetion frequency (0: always, 1: every 200 ms, 5: every second, ...)
function ServerController.communicateWithServer(modulus)
    -- default value for optional parameter
    if not modulus or type(modulus) ~= "number" then modulus = 5 end
    i = i + 1

    local overallTime0 = os.clock()
    local serverIsReady = not ServerController.checkServerStatus or AkWebServerIo.checkWebServer()

    -- initialization in first call
    local overallTime1 = os.clock()
    local printFirstTime = false
    if not initialized and serverIsReady then
        printFirstTime = true
        initialize()
    end

    -- process commands
    local overallTime2 = os.clock()
    AkWebServerIo.processNewCommands()

    -- export data regularly
    local overallTime3 = os.clock()
    local overallTime4 = overallTime3

    if (modulus == 0 or i % modulus == 0) and serverIsReady then
        collectData(printFirstTime)
        overallTime4 = os.clock()

        writeData(EventFileWriter.getAndResetEvents())
    end

    local overallTime5 = os.clock()
    local timeDiff = overallTime5 - overallTime0
    local allowedTimeDiff = modulus * 0.200
    if ServerController.debug and printFirstTime or timeDiff > allowedTimeDiff then
        local format = (printFirstTime and "INITIALIZATION" or "WARNING") ..
                       ": [#ServerController] communicateWithServer() time is %3.0f ms --- " ..
                       "waitForServer: %.0f ms, " .. "initialize: %.0f ms, " .. "commands: %2.0f ms, " ..
                       "collect: %3.0f ms, " .. " write: %.0f ms" .. " (allowed: %.0f ms)"
        print(string.format(format, -- format string
        (timeDiff) * 1000, -- communicateWithServer
        (overallTime1 - overallTime0) * 1000, -- waitForServer
        (overallTime2 - overallTime1) * 1000, -- initialize
        (overallTime3 - overallTime2) * 1000, -- commands
        (overallTime4 - overallTime3) * 1000, -- collect
        (overallTime5 - overallTime4) * 1000, -- write
        (allowedTimeDiff) * 1000)) -- allowed
    end

    if modulus == 0 or i % modulus == 0 then
        RuntimeRegistry.storeRunTime("ServerController.communicateWithServer-1-waitForServer",
                                     overallTime1 - overallTime0)
        RuntimeRegistry.storeRunTime("ServerController.communicateWithServer-2-initialize",
                                     overallTime2 - overallTime1)
        RuntimeRegistry.storeRunTime("ServerController.communicateWithServer-3-commands", overallTime3 - overallTime2)
        RuntimeRegistry.storeRunTime("ServerController.communicateWithServer-4-collect", overallTime4 - overallTime3)
        RuntimeRegistry.storeRunTime("ServerController.communicateWithServer-5-write", overallTime5 - overallTime4)
        RuntimeRegistry.storeRunTime("ServerController.communicateWithServer-OVERALL", timeDiff)
        local values = RuntimeRegistry.getAll()
        if (values) then EventBroker.fireListChange("runtime", "id", values) end
        RuntimeRegistry.resetAll(runTimeGroupsToKeep)
        EventBroker.printEventCounter()
    end

end

return ServerController
