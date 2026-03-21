insulate("ce.databridge.LogOutputFileWriter", function()
    require("ce.hub.eep.EepSimulator")

    local function clearModule(name) package.loaded[name] = nil end

    local originalIoOpen = io.open
    local originalAssert = assert
    local originalError = error
    local originalPrint = print
    local originalWarn = warn
    local originalClearlog = clearlog
    local originalOsDate = os.date

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
        clearModule("ce.databridge.ExchangeDirRegistry")
        clearModule("ce.databridge.IncomingCommandExecutor")
        clearModule("ce.databridge.LogOutputFileWriter")
        io.open = originalIoOpen
        assert = originalAssert
        error = originalError
        print = originalPrint
        warn = originalWarn
        clearlog = originalClearlog
        os.date = originalOsDate
    end)

    after_each(function()
        io.open = originalIoOpen
        assert = originalAssert
        error = originalError
        print = originalPrint
        warn = originalWarn
        clearlog = originalClearlog
        os.date = originalOsDate
    end)

    it("writes newline-terminated log entries and reset markers", function()
        local logWrites = {}
        local logOpenModes = {}

        installSimpleGlobals()
        os.date = function() return "" end
        io.open = function(name, mode)
            if name ~= "../LUA/ce/databridge/exchange/ce-version.txt" and
               name ~= "exchange-dir/ce-version.txt" and
               name ~= "exchange-dir/log-from-ce" then
                return originalIoOpen(name, mode)
            end

            if name == "exchange-dir/log-from-ce" then
                table.insert(logOpenModes, mode)
            end

            return {
                write = function(_, content)
                    if name == "exchange-dir/log-from-ce" then table.insert(logWrites, content) end
                end,
                flush = function() end,
                close = function() end
            }
        end

        local ExchangeDirRegistry = require("ce.databridge.ExchangeDirRegistry")
        local LogOutputFileWriter = require("ce.databridge.LogOutputFileWriter")

        ExchangeDirRegistry.setExchangeDirectory("exchange-dir")
        LogOutputFileWriter.initialize()

        _G.print("Line 1\nLine 2")
        _G.clearlog()

        originalAssert.same({"w+", "a", "a"}, logOpenModes)
        originalAssert.same({"Line 1\n       . Line 2\n", "@@CE_LOG_RESET@@\n"}, logWrites)
        for _, content in ipairs(logWrites) do
            originalAssert.equals("\n", content:sub(-1))
        end
    end)

    it("registers wrapped print and keeps assert fail-loud", function()
        local openCalls = {}

        installSimpleGlobals()
        io.open = function(name, mode)
            if name ~= "../LUA/ce/databridge/exchange/ce-version.txt" and
               name ~= "exchange-dir/ce-version.txt" and
               name ~= "exchange-dir/log-from-ce" then
                return originalIoOpen(name, mode)
            end

            table.insert(openCalls, {name = name, mode = mode})
            return {write = function() end, flush = function() end, close = function() end}
        end

        local ExchangeDirRegistry = require("ce.databridge.ExchangeDirRegistry")
        local IncomingCommandExecutor = require("ce.databridge.IncomingCommandExecutor")
        local LogOutputFileWriter = require("ce.databridge.LogOutputFileWriter")

        openCalls = {}
        ExchangeDirRegistry.setExchangeDirectory("exchange-dir")
        LogOutputFileWriter.initialize()
        openCalls = {}

        IncomingCommandExecutor.executeIncomingCommands("print|")
        local ok, err = pcall(_G.assert, false, "boom")

        originalAssert.is_true(#openCalls >= 2)
        for _, openCall in ipairs(openCalls) do
            originalAssert.same({name = "exchange-dir/log-from-ce", mode = "a"}, openCall)
        end
        originalAssert.is_false(ok)
        originalAssert.is_not_nil(string.find(err, "boom", 1, true))
        originalAssert.is_not_nil(string.find(err, "stack traceback", 1, true))
    end)
end)