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

local registeredPublishers = {}
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

local function initializePublisher(publisher)
    local t0 = os.clock()
    publisher.initialize()
    local t1 = os.clock()
    local timeDiff = t1 - t0
    print(string.format('AkStatistik: initialize() %.3f Sekunden fuer "%s"', timeDiff, publisher.name))
end

--- Initialize data.
-- do it once
local function initialize()
    local DefaultPublishers = require("ak.core.DefaultPublishers")
    DefaultPublishers.addDefaultPublishers()

    print("AkStatistik: initialize()")
    for _, publisher in pairs(registeredPublishers) do
        initializePublisher(publisher)
    end

    initialized = true
end

function AkStatistik.addPublisher(...)
    for _, publisher in ipairs({...}) do
        -- Check the publisher
        assert(
            publisher.name and type(publisher.name) == "string",
            "Der Name des Moduls muss gesetzt und ein String sein"
        )
        assert(
            publisher.initialize and type(publisher.initialize) == "function",
            "Das Modul muss eine Funktion initialize() besitzen"
        )
        assert(
            publisher.updateData and type(publisher.updateData) == "function",
            "Das Modul muss eine Funktion updateData() besitzen"
        )

        -- Remember the publisher by it's name
        print(string.format("AkStatistik.addPublisher(%s)", publisher.name))
        registeredPublishers[publisher.name] = publisher

        if initialized then
            initializePublisher(publisher)
        end
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

    local printFirstTime = false
    local overallTime0 = os.clock()
    -- initialization in first call
    if not initialized and (not AkStatistik.checkServerStatus or AkWebServerIo.checkWebServer()) then
        printFirstTime = true
        initialize()
    end
    i = i + 1

    -- process commands
    AkWebServerIo.processNewCommands()

    -- export data regularly
    if i % modulus == 0 and (not AkStatistik.checkServerStatus or AkWebServerIo.checkWebServer()) then
        local t0 = os.clock()
        for _, publisher in pairs(registeredPublishers) do
            -- local t0 = os.clock()
            publisher.updateData()
            -- local t1 = os.clock()
            -- local timeDiff = t1 - t0
            -- print(string.format("AkStatistik: updateData() %.3f Sekunden fuer \"%s\"", timeDiff, publisher.name))
        end

        -- add statistical data
        local orderedKeys = {}
        for key in pairs(writeLater) do
            table.insert(orderedKeys, key)
        end
        table.sort(orderedKeys)
        fillApiEntriesV1(orderedKeys)

        local t1 = os.clock()

        -- export data
        AkWebServerIo.updateJsonFile(
            json.encode(
                writeLater,
                {
                    keyorder = orderedKeys
                }
            )
        )

        -- clear additional data
        -- NOT USED ANYMORE! writeLater = {}

        local t2 = os.clock()

        local timeDiff = t2 - t0
        if timeDiff > 1 then
            print(string.format("AkStatistik: fill: %.2f sec, store: %.2f sec", t1 - t0, t2 - t1))
            print(
                string.format(
                    "WARNUNG: AkStatistik.statistikAusgabe schreiben dauerte %.2f Sekunden " ..
                        "(nur interessant, wenn EEP nicht pausiert wurde)",
                    timeDiff
                )
            )
        end
    end

    local overallTime1 = os.clock()
    local timeDiff = overallTime1 - overallTime0
    if printFirstTime then
        print(string.format("FIRST TIME for AkStatistik.statistikAusgabe() was %.3f s", timeDiff))
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
