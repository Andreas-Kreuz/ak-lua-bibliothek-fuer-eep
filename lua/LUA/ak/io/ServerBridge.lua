--- Export EEP data / read and execute commands.
-- LuaDoc: http://keplerproject.github.io/luadoc/manual.html
--
--[[ Usage:
-- Do NOT use this class manually
-- Use this class in XxxWebConnector to register commands
local ServerBridge = require("ak.io.ServerBridge")
--]] -- @author Andreas Kreuz
-- @release 0.10.2
if AkDebugLoad then print("[#Start] Loading ak.io.ServerBridge ...") end
local EventRecorder = require("ak.io.EventRecorder")
local AkWebServerIo = require("ak.io.AkWebServerIo")
local AkCommandExecutor = require("ak.io.AkCommandExecutor")
local os = require("os")

local ServerBridge = {}
ServerBridge.debug = AkStartWithDebug or false


-- checkServerStatus:
-- true: Check status of EEP-Web Server before updating the json file
-- false: Update json file without checking if the EEP-Web Server is ready
ServerBridge.checkServerStatus = true

function ServerBridge.addAcceptedRemoteFunction(fName, f) AkCommandExecutor.addAcceptedRemoteFunction(fName, f) end

local function writeData(jsonString) AkWebServerIo.updateJsonFile(jsonString) end

local i = -1

--- Main function of this module. Is called by MainLoopRunner.
-- @param modulus Repetition frequency (0: always, 1: every 200 ms, 5: every second, ...)
function ServerBridge.exchangeWithServer(modulus)
    if not modulus or type(modulus) ~= "number" then modulus = 5 end
    i = i + 1

    local overallTime0 = os.clock()
    local serverIsReady = not ServerBridge.checkServerStatus or AkWebServerIo.checkWebServer()
    local overallTime1 = os.clock()

    AkWebServerIo.processNewCommands()
    local overallTime2 = os.clock()

    local publishRuntime = modulus == 0 or i % modulus == 0
    local overallTime3 = overallTime2
    local overallTime4 = overallTime2
    if publishRuntime and serverIsReady then
        local encodedEvents = EventRecorder.collectAndResetEvents()
        overallTime3 = os.clock()
        writeData(encodedEvents)
        overallTime4 = os.clock()
    end

    local waitForServerTime = overallTime1 - overallTime0
    local commandsTime = overallTime2 - overallTime1
    local encodeTime = overallTime3 - overallTime2
    local writeTime = overallTime4 - overallTime3
    local totalTime = overallTime4 - overallTime0

    if ServerBridge.debug then
        print(string.format("INFO: [#ServerBridge] exchangeWithServer() time is %3.0f ms --- " ..
                            "waitForServer: %.0f ms, commands: %2.0f ms, encode: %.0f ms, write: %.0f ms",
                            totalTime * 1000, waitForServerTime * 1000, commandsTime * 1000,
                            encodeTime * 1000, writeTime * 1000))
    end

    return {
        waitForServerTime = waitForServerTime,
        commandsTime = commandsTime,
        encodeTime = encodeTime,
        writeTime = writeTime,
        totalTime = totalTime,
        publishRuntime = publishRuntime
    }
end

return ServerBridge
