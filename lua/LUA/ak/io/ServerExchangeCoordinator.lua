--- Export EEP data / read and execute commands.
-- LuaDoc: http://keplerproject.github.io/luadoc/manual.html
--
--[[ Usage:
-- Do NOT use this class manually
-- Use this class in XxxWebConnector to register commands
local ServerExchangeCoordinator = require("ak.io.ServerExchangeCoordinator")
--]] -- @author Andreas Kreuz
-- @release 0.10.2
if AkDebugLoad then print("[#Start] Loading ak.io.ServerExchangeCoordinator ...") end
local DataChangeBus = require("ak.events.DataChangeBus")
local ServerEventBuffer = require("ak.io.ServerEventBuffer")
local ServerExchangeFileIo = require("ak.io.ServerExchangeFileIo")
local IncomingCommandExecutor = require("ak.io.IncomingCommandExecutor")
local os = require("os")

local ServerExchangeCoordinator = {}
ServerExchangeCoordinator.debug = AkStartWithDebug or false
local initialized = false


-- checkServerStatus:
-- true: Check status of EEP-Web Server before updating the json file
-- false: Update json file without checking if the EEP-Web Server is ready
ServerExchangeCoordinator.checkServerStatus = true

function ServerExchangeCoordinator.registerAllowedCommand(fName, f)
    IncomingCommandExecutor.registerAllowedCommand(fName, f)
end

function ServerExchangeCoordinator.initialize()
    if initialized then return end

    DataChangeBus.addListener(ServerEventBuffer)
    DataChangeBus.fireCompleteReset()
    initialized = true
end

local function writeOutgoingEvents(jsonString) ServerExchangeFileIo.writeOutgoingEvents(jsonString) end

local i = -1

--- Main function of this module. Is called by MainLoopRunner.
-- @param modulus Repetition frequency (0: always, 1: every 200 ms, 5: every second, ...)
function ServerExchangeCoordinator.runServerExchangeCycle(modulus)
    if not modulus or type(modulus) ~= "number" then modulus = 5 end
    i = i + 1

    local overallTime0 = os.clock()
    local serverIsReady = not ServerExchangeCoordinator.checkServerStatus or ServerExchangeFileIo.isServerReady()
    local overallTime1 = os.clock()

    ServerExchangeFileIo.readAndExecuteIncomingCommands()
    local overallTime2 = os.clock()

    local publishRuntime = modulus == 0 or i % modulus == 0
    local overallTime3 = overallTime2
    local overallTime4 = overallTime2
    if publishRuntime and serverIsReady then
        local encodedEvents = ServerEventBuffer.drainBufferedEvents()
        overallTime3 = os.clock()
        writeOutgoingEvents(encodedEvents)
        overallTime4 = os.clock()
    end

    local waitForServerTime = overallTime1 - overallTime0
    local commandsTime = overallTime2 - overallTime1
    local encodeTime = overallTime3 - overallTime2
    local writeTime = overallTime4 - overallTime3
    local totalTime = overallTime4 - overallTime0

    if ServerExchangeCoordinator.debug then
        print(string.format("INFO: [#ServerExchangeCoordinator] runServerExchangeCycle() time is %3.0f ms --- " ..
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

return ServerExchangeCoordinator