insulate("ce.databridge.FunctionNameWriter", function()
    require("ce.hub.eep.EepSimulator")

    local function clearModule(name) package.loaded[name] = nil end

    local originalIoOpen = io.open

    before_each(function()
        clearModule("ce.databridge.ExchangeDirRegistry")
        clearModule("ce.databridge.FunctionNameWriter")
        io.open = originalIoOpen
    end)

    after_each(function() io.open = originalIoOpen end)

    it("writes the sorted global names to ak-runtime-functions.txt in the exchange directory", function()
        local openCalls = {}
        local writtenContent

        io.open = function(name, mode)
            if name ~= "../LUA/ce/databridge/exchange/ce-version.txt" and
               name ~= "exchange-dir/ce-version.txt" and
               name ~= "exchange-dir/ak-runtime-functions.txt" then
                return originalIoOpen(name, mode)
            end

            table.insert(openCalls, {name = name, mode = mode})
            return {
                write = function(_, content)
                    if name == "exchange-dir/ak-runtime-functions.txt" then
                        writtenContent = content
                    end
                end,
                flush = function() end,
                close = function() end
            }
        end

        local ExchangeDirRegistry = require("ce.databridge.ExchangeDirRegistry")
        local FunctionNameWriter = require("ce.databridge.FunctionNameWriter")

        openCalls = {}
        ExchangeDirRegistry.setExchangeDirectory("exchange-dir")
        FunctionNameWriter.initialize()

        writtenContent = "\n" .. writtenContent

        assert.same({
            {name = "exchange-dir/ce-version.txt", mode = "w"},
            {name = "exchange-dir/ak-runtime-functions.txt", mode = "w"}
        }, openCalls)
        assert.is_not_nil(string.find(writtenContent, "\nEEPVer\n", 1, true))
        assert.is_not_nil(string.find(writtenContent, "\nclearlog\n", 1, true))
        assert.is_not_nil(string.find(writtenContent, "\nprint\n", 1, true))
        assert.is_true(string.find(writtenContent, "\nEEPVer\n", 1, true) <
                       string.find(writtenContent, "\nprint\n", 1, true))
    end)
end)
