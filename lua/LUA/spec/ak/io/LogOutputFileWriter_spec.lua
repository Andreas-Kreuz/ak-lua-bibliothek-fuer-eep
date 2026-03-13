insulate("ak.io.LogOutputFileWriter", function()
    require("ak.core.eep.EepSimulator")

    local function clearModule(name) package.loaded[name] = nil end

    local originalIoOpen = io.open
    local originalAssert = assert
    local originalError = error
    local originalPrint = print
    local originalWarn = warn
    local originalClearlog = clearlog

    local function installSimpleGlobals()
        assert = function(v, message)
            if not v then originalError(message and message or "Assertion failed.", 0) end
            return v
        end
        error = function(message, level) originalError(message, level and level or 1) end
        print = function() end
        warn = function() end
        clearlog = function() end
    end

    before_each(function()
        clearModule("ak.io.ExchangeDirRegistry")
        clearModule("ak.io.IncomingCommandExecutor")
        clearModule("ak.io.LogOutputFileWriter")
        io.open = originalIoOpen
        assert = originalAssert
        error = originalError
        print = originalPrint
        warn = originalWarn
        clearlog = originalClearlog
    end)

    after_each(function()
        io.open = originalIoOpen
        assert = originalAssert
        error = originalError
        print = originalPrint
        warn = originalWarn
        clearlog = originalClearlog
    end)

    it("wraps print and clearlog and writes to the log file", function()
        local openCalls = {}

        installSimpleGlobals()
        io.open = function(name, mode)
            table.insert(openCalls, {name = name, mode = mode})
            return {write = function() end, flush = function() end, close = function() end}
        end

        local ExchangeDirRegistry = require("ak.io.ExchangeDirRegistry")
        local LogOutputFileWriter = require("ak.io.LogOutputFileWriter")

        openCalls = {}
        ExchangeDirRegistry.setExchangeDirectory("exchange-dir")
        LogOutputFileWriter.initialize()

        _G.print("hello")
        _G.clearlog()

        originalAssert.same({
            {name = "exchange-dir/ak-eep-version.txt", mode = "w"},
            {name = "exchange-dir/ak-eep-out.log", mode = "w+"}, {name = "exchange-dir/ak-eep-out.log", mode = "a"},
            {name = "exchange-dir/ak-eep-out.log", mode = "a"}, {name = "exchange-dir/ak-eep-out.log", mode = "w+"},
            {name = "exchange-dir/ak-eep-out.log", mode = "a"}
        }, openCalls)
    end)

    it("registers wrapped print and keeps assert fail-loud", function()
        local openCalls = {}

        installSimpleGlobals()
        io.open = function(name, mode)
            table.insert(openCalls, {name = name, mode = mode})
            return {write = function() end, flush = function() end, close = function() end}
        end

        local ExchangeDirRegistry = require("ak.io.ExchangeDirRegistry")
        local IncomingCommandExecutor = require("ak.io.IncomingCommandExecutor")
        local LogOutputFileWriter = require("ak.io.LogOutputFileWriter")

        openCalls = {}
        ExchangeDirRegistry.setExchangeDirectory("exchange-dir")
        LogOutputFileWriter.initialize()
        openCalls = {}

        IncomingCommandExecutor.executeIncomingCommands("print|hello")
        local ok, err = pcall(_G.assert, false, "boom")

        originalAssert.is_true(#openCalls >= 2)
        for _, openCall in ipairs(openCalls) do
            originalAssert.same({name = "exchange-dir/ak-eep-out.log", mode = "a"}, openCall)
        end
        originalAssert.is_false(ok)
        originalAssert.is_not_nil(string.find(err, "boom", 1, true))
        originalAssert.is_not_nil(string.find(err, "stack traceback", 1, true))
    end)
end)
