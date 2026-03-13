insulate("ak.io.ExchangeDirRegistry", function()
    require("ak.core.eep.EepSimulator")

    local function clearModule(name) package.loaded[name] = nil end

    local originalIoOpen = io.open

    before_each(function()
        clearModule("ak.io.ExchangeDirRegistry")
        io.open = originalIoOpen
    end)

    after_each(function() io.open = originalIoOpen end)

    it("stores the resolved default exchange directory during module load", function()
        local openCalls = {}

        io.open = function(name, mode)
            table.insert(openCalls, {name = name, mode = mode})
            if name == "../LUA/ak/io/exchange/ak-eep-version.txt" then return nil end
            return {write = function() end, flush = function() end, close = function() end}
        end

        local ExchangeDirRegistry = require("ak.io.ExchangeDirRegistry")

        assert.equals("./LUA/ak/io/exchange", ExchangeDirRegistry.getExchangeDirectory())
        assert.equals("./LUA/ak/io/exchange", ExchangeDirRegistry.resolveDefaultExchangeDirectory())
        assert.same({
            {name = "../LUA/ak/io/exchange/ak-eep-version.txt", mode = "w"},
            {name = "./LUA/ak/io/exchange/ak-eep-version.txt", mode = "w"},
            {name = "../LUA/ak/io/exchange/ak-eep-version.txt", mode = "w"},
            {name = "./LUA/ak/io/exchange/ak-eep-version.txt", mode = "w"}
        }, openCalls)
    end)

    it("stores a validated exchange directory", function()
        local openCalls = {}

        io.open = function(name, mode)
            table.insert(openCalls, {name = name, mode = mode})
            return {write = function() end, flush = function() end, close = function() end}
        end

        local ExchangeDirRegistry = require("ak.io.ExchangeDirRegistry")

        openCalls = {}
        assert.equals("exchange-dir", ExchangeDirRegistry.setExchangeDirectory("exchange-dir"))
        assert.equals("exchange-dir", ExchangeDirRegistry.getExchangeDirectory())
        assert.same({{name = "exchange-dir/ak-eep-version.txt", mode = "w"}}, openCalls)
    end)
end)
