insulate("ak.io.FunctionNameWriter", function()
    require("ak.core.eep.EepSimulator")

    local function clearModule(name) package.loaded[name] = nil end

    local originalIoOpen = io.open

    before_each(function()
        clearModule("ak.io.ExchangeDirRegistry")
        clearModule("ak.io.FunctionNameWriter")
        io.open = originalIoOpen
    end)

    after_each(function() io.open = originalIoOpen end)

    it("writes the sorted global names to ak-runtime-functions.txt in the exchange directory", function()
        local openCalls = {}
        local writtenContent

        io.open = function(name, mode)
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

        local ExchangeDirRegistry = require("ak.io.ExchangeDirRegistry")
        local FunctionNameWriter = require("ak.io.FunctionNameWriter")

        openCalls = {}
        ExchangeDirRegistry.setExchangeDirectory("exchange-dir")
        FunctionNameWriter.initialize()

        writtenContent = "\n" .. writtenContent

        assert.same({
            {name = "exchange-dir/ak-eep-version.txt", mode = "w"},
            {name = "exchange-dir/ak-runtime-functions.txt", mode = "w"}
        }, openCalls)
        assert.is_not_nil(string.find(writtenContent, "\nEEPVer\n", 1, true))
        assert.is_not_nil(string.find(writtenContent, "\nclearlog\n", 1, true))
        assert.is_not_nil(string.find(writtenContent, "\nprint\n", 1, true))
        assert.is_true(string.find(writtenContent, "\nEEPVer\n", 1, true) <
                       string.find(writtenContent, "\nprint\n", 1, true))
    end)
end)
