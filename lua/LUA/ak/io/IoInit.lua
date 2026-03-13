if AkDebugLoad then print("[#Start] Loading ak.io.IoInit ...") end
local ExchangeDirRegistry = require("ak.io.ExchangeDirRegistry")
local LogOutputFileWriter = require("ak.io.LogOutputFileWriter")

local IoInit = {}
local initialized = false

function IoInit.initialize()
    if initialized then return end

    assert(ExchangeDirRegistry.getExchangeDirectory(), "ExchangeDir ist nicht gesetzt")
    LogOutputFileWriter.initialize()
    initialized = true
end

return IoInit
