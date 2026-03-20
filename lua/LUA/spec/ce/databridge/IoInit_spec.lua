insulate("ce.databridge.IoInit", function()
    require("ce.hub.eep.EepSimulator")

    local function clearModule(name) package.loaded[name] = nil end

    before_each(function()
        clearModule("ce.databridge.ExchangeDirRegistry")
        clearModule("ce.databridge.FunctionNameWriter")
        clearModule("ce.databridge.IncomingCommandExecutor")
        clearModule("ce.databridge.IncomingCommandFileReader")
        clearModule("ce.databridge.LogOutputFileWriter")
        clearModule("ce.databridge.ServerExchangeFileIo")
        clearModule("ce.databridge.IoInit")
    end)

    it("initializes log output once", function()
        local calls = {}
        local ExchangeDirRegistry = require("ce.databridge.ExchangeDirRegistry")
        local LogOutputFileWriter = require("ce.databridge.LogOutputFileWriter")

        LogOutputFileWriter.initialize = function() table.insert(calls, "log") end

        clearModule("ce.databridge.IoInit")
        local IoInit = require("ce.databridge.IoInit")

        IoInit.initialize()
        IoInit.initialize()

        assert.is_not_nil(ExchangeDirRegistry.getExchangeDirectory())
        assert.same({"log"}, calls)
    end)
end)
