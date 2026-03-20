if AkDebugLoad then print("[#Start] Loading ce.databridge.IoInit ...") end
local ExchangeDirRegistry = require("ce.databridge.ExchangeDirRegistry")
local LogOutputFileWriter = require("ce.databridge.LogOutputFileWriter")

local IoInit = {}
local initialized = false

function IoInit.initialize()
    if initialized then return end

    assert(ExchangeDirRegistry.getExchangeDirectory(), "ExchangeDir ist nicht gesetzt")
    LogOutputFileWriter.initialize()
    initialized = true
end

return IoInit
