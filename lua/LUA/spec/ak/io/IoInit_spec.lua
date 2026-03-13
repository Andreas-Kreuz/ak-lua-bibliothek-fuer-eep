insulate("ak.io.IoInit", function()
    require("ak.core.eep.EepSimulator")

    local function clearModule(name) package.loaded[name] = nil end

    before_each(function()
        clearModule("ak.io.ExchangeDirRegistry")
        clearModule("ak.io.FunctionNameWriter")
        clearModule("ak.io.IncomingCommandExecutor")
        clearModule("ak.io.IncomingCommandFileReader")
        clearModule("ak.io.LogOutputFileWriter")
        clearModule("ak.io.ServerExchangeFileIo")
        clearModule("ak.io.IoInit")
    end)

    it("initializes log output once", function()
        local calls = {}
        local ExchangeDirRegistry = require("ak.io.ExchangeDirRegistry")
        local LogOutputFileWriter = require("ak.io.LogOutputFileWriter")

        LogOutputFileWriter.initialize = function() table.insert(calls, "log") end

        clearModule("ak.io.IoInit")
        local IoInit = require("ak.io.IoInit")

        IoInit.initialize()
        IoInit.initialize()

        assert.is_not_nil(ExchangeDirRegistry.getExchangeDirectory())
        assert.same({"log"}, calls)
    end)
end)
