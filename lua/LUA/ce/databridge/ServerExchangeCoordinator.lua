--- Export EEP data / read and execute commands.
-- LuaDoc: http://keplerproject.github.io/luadoc/manual.html
--
--[[ Usage:
-- Do NOT use this class manually
-- Use this class in XxxBridgeConnector to register commands
local ServerExchangeCoordinator = require("ce.databridge.ServerExchangeCoordinator")
--]] -- @author Andreas Kreuz
-- @release 0.10.2
if AkDebugLoad then print("[#Start] Loading ce.databridge.ServerExchangeCoordinator ...") end
local DataChangeBus = require("ce.hub.publish.DataChangeBus")
local ServerEventBuffer = require("ce.databridge.ServerEventBuffer")
local ServerExchangeFileIo = require("ce.databridge.ServerExchangeFileIo")
local IncomingCommandExecutor = require("ce.databridge.IncomingCommandExecutor")
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

    DataChangeBus.initialize()
    initialized = true
end

function ServerExchangeCoordinator.isServerReady()
    return not ServerExchangeCoordinator.checkServerStatus or ServerExchangeFileIo.isServerReady()
end

--- Main function of this module. Is called by MainLoopRunner.
function ServerExchangeCoordinator.runServerOutputCycle()
    local overallTime0 = os.clock()
    local encodedEvents = ServerEventBuffer.drainBufferedEvents()
    local overallTime1 = os.clock()
    ServerExchangeFileIo.writeOutgoingEvents(encodedEvents)
    local overallTime2 = os.clock()

    local encodeTime = overallTime1 - overallTime0
    local writeTime = overallTime2 - overallTime1
    local totalTime = overallTime2 - overallTime0

    if ServerExchangeCoordinator.debug then
        print(string.format(
            "INFO: [#ServerExchangeCoordinator] runServerOutputCycle() time is %3.0f ms" ..
            " --- encode: %.0f ms, write: %.0f ms",
            totalTime * 1000, encodeTime * 1000, writeTime * 1000))
    end

    return { encodeTime = encodeTime, writeTime = writeTime, totalTime = totalTime }
end

return ServerExchangeCoordinator
