--- Export EEP data / read and execute commands.
-- LuaDoc: http://keplerproject.github.io/luadoc/manual.html
--
--[[ Usage:
-- Do NOT use this class manually
-- Use this class in XxxWebConnector to register JsonCollectors and commands
local ServerController = require("ak.io.ServerController")
--]]
-- @author Andreas Kreuz
-- @release 0.9.0
print("Lade ak.io.ServerController ...")
local AkWebServerIo = require("ak.io.AkWebServerIo")
local AkCommandExecutor = require("ak.io.AkCommandExecutor")
local os = require("os")
local json1 = require("ak.io.json")
-- local json2 = require("ak.io.dkjson")

local ServerController = {}
ServerController.programVersion = "0.9.0"

-- checkServerStatus:
-- true: Check status of EEP-Web Server before updating the json file
-- false: Update json file without checking if the EEP-Web Server is ready
ServerController.checkServerStatus = true

local registeredJsonCollectors = {}
local collectedData = {}
local checksum = 0
local initialized = false

function ServerController.addAcceptedRemoteFunction(fName, f)
    AkCommandExecutor.addAcceptedRemoteFunction(fName, f)
end

local function fillApiEntriesV1(orderedKeys)
    collectedData["api-entries"] = {}
    checksum = checksum + 1
    local apiEntries = {}
    local apiEntry
    for _, key in ipairs(orderedKeys) do
        local count = 0
        for _ in pairs(collectedData[key]) do
            count = count + 1
        end

        local o = {
            name = key,
            url = "/api/v1/" .. key,
            count = count,
            checksum = checksum,
            updated = true
        }
        table.insert(apiEntries, o)

        if o.name == "api-entries" then
            apiEntry = o
        end
    end

    if apiEntry then
        apiEntry.count = #apiEntries
    end

    collectedData["api-entries"] = apiEntries
end

local function initializeJsonCollector(jsonCollector)
    local t0 = os.clock()
    jsonCollector.initialize()
    local t1 = os.clock()
    local timeDiff = t1 - t0
    print(string.format('ServerController: initialize() %.2f Sekunden fuer "%s"', timeDiff, jsonCollector.name))
end

local function collectFrom(jsonCollector, printFirstTime)
    local t0 = os.clock()
    local newData = jsonCollector.collectData()
    local t1 = os.clock()
    local timeDiff = t1 - t0
    if timeDiff > 0.02 or printFirstTime then
        print(string.format('ServerController:collectData() %.2f Sekunden fuer "%s"', timeDiff, jsonCollector.name))
    end
    return newData
end

local function collectData(printFirstTime)
    for _, jsonCollector in pairs(registeredJsonCollectors) do
        local newData = collectFrom(jsonCollector, printFirstTime)
        for key, value in pairs(newData) do
            collectedData[key] = value
        end
    end
end

--- Initialize data.
-- do it once
local function initialize()
    print("ServerController: initialize()")
    for _, jsonCollector in pairs(registeredJsonCollectors) do
        initializeJsonCollector(jsonCollector)
    end

    initialized = true
end

function ServerController.addJsonCollector(...)
    for _, jsonCollector in ipairs({...}) do
        -- Check the jsonCollector
        assert(
            jsonCollector.name and type(jsonCollector.name) == "string",
            "Der Name des Moduls muss gesetzt und ein String sein"
        )
        assert(
            jsonCollector.initialize and type(jsonCollector.initialize) == "function",
            "Das Modul muss eine Funktion initialize() besitzen"
        )
        assert(
            jsonCollector.collectData and type(jsonCollector.collectData) == "function",
            "Das Modul muss eine Funktion collectData() besitzen"
        )

        -- Remember the jsonCollector by it's name
        print(string.format("ServerController.addJsonCollector(%s)", jsonCollector.name))
        registeredJsonCollectors[jsonCollector.name] = jsonCollector

        if initialized then
            initializeJsonCollector(jsonCollector)
        end
    end
end

function collectAndWriteData(printFirstTime, modulus)
    local t0 = os.clock()
    collectData(printFirstTime)

    -- add statistical data
    local t1 = os.clock()
    local orderedKeys = {}
    for key in pairs(collectedData) do
        table.insert(orderedKeys, key)
    end
    table.sort(orderedKeys)
    fillApiEntriesV1(orderedKeys)

    -- write file
    local t2 = os.clock()

    -- local tStartSorted = os.clock()
    local content = json1.encode(collectedData, {keyorder = orderedKeys})
    -- local tSorted = os.clock() - tStartSorted

    -- local tStartUnsorted = os.clock()
    -- content = json1.encode(collectedData)
    -- local tUnsorted = os.clock() - tStartUnsorted

    -- local tStartJson2Unsorted = os.clock()
    -- content = json2.encode(collectedData)
    -- local tJson2Unsorted = os.clock() - tStartJson2Unsorted

    -- print(string.format("JSON: Sortiert: %.2f, Unsortiert: %.2f, Json2: %.2f", tSorted, tUnsorted, tJson2Unsorted))

    local t3 = os.clock()
    AkWebServerIo.updateJsonFile(content)

    local t4 = os.clock()

    -- Do not print warning on the first time
    if not printFirstTime and t4 - t0 > .2 * modulus then
        print(
            string.format(
                "WARNUNG: ServerController.collectAndWriteData()   time is %.2f s --- " ..
                    "collect: %.2f s, sort: %.2f s, encode: %.2f s, writeFile: %.2f s",
                t4 - t0,
                t1 - t0,
                t2 - t1,
                t3 - t2,
                t4 - t3
            )
        )
    end

    if printFirstTime then
        local sizes = "Data sizes: "
        for _, key in ipairs(orderedKeys) do
            local value = collectedData[key]
            local size = string.len(json1.encode(value, {keyorder = orderedKeys}))
            sizes = sizes .. string.format("\n%10d Bytes: %s", size, key)
        end
        print(sizes)
    end
end

local i = -1

--- Main function of this module.
-- Call this function in main loop of EEP.
-- do it frequently
-- @param modulus Repetion frequency (1: every 200 ms, 5: every second, ...)
function ServerController.communicateWithServer(modulus)
    -- default value for optional parameter
    if not modulus or type(modulus) ~= "number" then
        modulus = 5
    end
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
    if i % modulus == 0 and serverIsReady then
        collectAndWriteData(printFirstTime, modulus)
    end

    local overallTime4 = os.clock()
    local timeDiff = overallTime4 - overallTime0
    local allowedTimeDiff = modulus * 0.200
    if printFirstTime or timeDiff > allowedTimeDiff then
        print(
            string.format(
                (printFirstTime and "MIT INITIALISIERUNG" or "WARNUNG") ..
                    ": ServerController.communicateWithServer() time is %.2f s --- " ..
                        "waitForServer: %.2f s, initialize: %.2f s, " ..
                            "processNewCommands: %.2f s, collectAndWriteData: %.2f s" .. "(allowed: %.2f s)",
                timeDiff,
                overallTime1 - overallTime0,
                overallTime2 - overallTime1,
                overallTime3 - overallTime2,
                overallTime4 - overallTime3,
                allowedTimeDiff
            )
        )
    end
end

return ServerController
