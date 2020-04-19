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
print("Lade ak.io.AkStatistik ...")
local AkWebServerIo = require("ak.io.AkWebServerIo")
local os = require("os")
local json = require("ak.io.dkjson")

local AkStatistik = {}
AkStatistik.programVersion = "0.8.4"

-- checkServerStatus:
-- true: Check status of EEP-Web Server before updating the json file
-- false: Update json file without checking if the EEP-Web Server is ready
AkStatistik.checkServerStatus = true

local registeredJsonCollectors = {}
local writeLater = {}
local checksum = 0
local initialized = false

--- Store additional data in json file.
-- Call this function in your Lua script to store additional data in the json file.
-- @param key Key.
-- @param value Data.
function AkStatistik.writeLater(key, value)
    writeLater[key] = value
end

local function fillApiEntriesV1(orderedKeys)
    writeLater["api-entries"] = {}
    checksum = checksum + 1
    local apiEntries = {}
    local apiEntry
    for _, key in ipairs(orderedKeys) do
        local count = 0
        for _ in pairs(writeLater[key]) do
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

    writeLater["api-entries"] = apiEntries
end

local function initializeJsonCollector(jsonCollector)
    local t0 = os.clock()
    jsonCollector.initialize()
    local t1 = os.clock()
    local timeDiff = t1 - t0
    print(string.format('AkStatistik: initialize() %.3f Sekunden fuer "%s"', timeDiff, jsonCollector.name))
end

local function collectFrom(jsonCollector, printFirstTime)
    local t0 = os.clock()
    local newData = jsonCollector.collectData()
    local t1 = os.clock()
    local timeDiff = t1 - t0
    if timeDiff > 0.02 or printFirstTime then
        print(string.format('AkStatistik:collectData() %.3f Sekunden fuer "%s"', timeDiff, jsonCollector.name))
    end
    return newData
end

local function collectData(printFirstTime)
    for _, jsonCollector in pairs(registeredJsonCollectors) do
        local newData = collectFrom(jsonCollector, printFirstTime)
        for key, value in pairs(newData) do
            writeLater[key] = value
        end
    end
end

--- Initialize data.
-- do it once
local function initialize()
    print("AkStatistik: initialize()")
    for _, jsonCollector in pairs(registeredJsonCollectors) do
        initializeJsonCollector(jsonCollector)
    end

    initialized = true
end

function AkStatistik.addJsonCollector(...)
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
        print(string.format("AkStatistik.addJsonCollector(%s)", jsonCollector.name))
        registeredJsonCollectors[jsonCollector.name] = jsonCollector

        if initialized then
            initializeJsonCollector(jsonCollector)
        end
    end
end

function collectAndWriteData(printFirstTime)
    local t0 = os.clock()
    collectData(printFirstTime)

    -- add statistical data
    local t1 = os.clock()
    local orderedKeys = {}
    for key in pairs(writeLater) do
        table.insert(orderedKeys, key)
    end
    table.sort(orderedKeys)
    fillApiEntriesV1(orderedKeys)

    -- write file
    local t2 = os.clock()
    AkWebServerIo.updateJsonFile(json.encode(writeLater, {keyorder = orderedKeys}))

    local t3 = os.clock()
    if t3 - t0 > 1 then
        print(
            string.format(
                "WARNUNG: AkStatistik:collectAndWriteData(): dauerte %.2f s - " ..
                    "collect: %.2f s, sort: %.2f s, writeFile: %.2f s",
                t3 - t0,
                t1 - t0,
                t2 - t1,
                t3 - t2
            )
        )
    end
end

local i = -1

--- Main function of this module.
-- Call this function in main loop of EEP.
-- do it frequently
-- @param modulus Repetion frequency (1: every 200 ms, 5: every second, ...)
function AkStatistik.statistikAusgabe(modulus)
    -- default value for optional parameter
    if not modulus or type(modulus) ~= "number" then
        modulus = 5
    end
    i = i + 1

    local overallTime0 = os.clock()
    local serverIsReady = not AkStatistik.checkServerStatus or AkWebServerIo.checkWebServer()

    -- initialization in first call
    local printFirstTime = false
    if not initialized and serverIsReady then
        printFirstTime = true
        initialize()
    end

    -- process commands
    local overallTime1 = os.clock()
    AkWebServerIo.processNewCommands()

    -- export data regularly
    local overallTime2 = os.clock()
    if i % modulus == 0 and serverIsReady then
        collectAndWriteData(printFirstTime)
    end

    local overallTime3 = os.clock()
    local timeDiff = overallTime3 - overallTime0
    if printFirstTime then
        print(
            string.format(
                "FIRST TIME for AkStatistik.statistikAusgabe() was %.3f s" ..
                    "\ninitialize: %.3f\nprocessNewCommands: %.3f\ncollectAndWriteData: %.3f",
                timeDiff,
                overallTime3 - overallTime2,
                overallTime2 - overallTime1,
                overallTime1 - overallTime0
            )
        )
    else
        local allowedTimeDiff = modulus * 0.200
        if timeDiff > allowedTimeDiff then
            print(
                string.format(
                    "WARNING!!! Current time for AkStatistik.statistikAusgabe() %.3f s is " ..
                        "bigger than allowedTime %.3f s",
                    timeDiff,
                    allowedTimeDiff
                )
            )
        end
    end
end

return AkStatistik
