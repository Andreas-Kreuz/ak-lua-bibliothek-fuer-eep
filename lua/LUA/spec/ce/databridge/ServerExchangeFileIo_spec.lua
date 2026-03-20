insulate("ce.databridge.ServerExchangeFileIo", function()
    require("ce.hub.eep.EepSimulator")

    local function clearModule(name) package.loaded[name] = nil end

    local originalIoOpen = io.open
    local originalIoClose = io.close

    before_each(function()
        clearModule("ce.databridge.ExchangeDirRegistry")
        clearModule("ce.databridge.ServerExchangeFileIo")
        io.open = originalIoOpen
        io.close = originalIoClose
    end)

    after_each(function()
        io.open = originalIoOpen
        io.close = originalIoClose
    end)

    it("detects a ready server from the exchange directory", function()
        local openCalls = {}

        io.close = function() end
        io.open = function(name, mode)
            if name ~= "../LUA/ce/databridge/exchange/ak-eep-version.txt" and
               name ~= "custom-dir/ak-eep-version.txt" and
               name ~= "custom-dir/ak-server.iswatching" and
               name ~= "custom-dir/ak-eep-out-json.isfinished" then
                return originalIoOpen(name, mode)
            end

            table.insert(openCalls, {name = name, mode = mode})
            if mode == "r" then
                if name == "custom-dir/ak-server.iswatching" then return {close = function() end} end
                return nil
            end
            return {write = function() end, flush = function() end, close = function() end}
        end

        local ExchangeDirRegistry = require("ce.databridge.ExchangeDirRegistry")
        local ServerExchangeFileIo = require("ce.databridge.ServerExchangeFileIo")

        openCalls = {}
        ExchangeDirRegistry.setExchangeDirectory("custom-dir")

        assert.is_true(ServerExchangeFileIo.isServerReady())
        assert.same({
            {name = "custom-dir/ak-eep-version.txt", mode = "w"},
            {name = "custom-dir/ak-server.iswatching", mode = "r"},
            {name = "custom-dir/ak-eep-out-json.isfinished", mode = "r"}
        }, openCalls)
    end)

    it("writes outgoing events and finished marker in the exchange directory", function()
        local openCalls = {}
        local writtenFiles = {}

        io.close = function() end
        io.open = function(name, mode)
            if name ~= "../LUA/ce/databridge/exchange/ak-eep-version.txt" and
               name ~= "custom-dir/ak-eep-version.txt" and
               name ~= "custom-dir/ak-eep-out.json" and
               name ~= "custom-dir/ak-server.iswatching" and
               name ~= "custom-dir/ak-eep-out-json.isfinished" then
                return originalIoOpen(name, mode)
            end

            table.insert(openCalls, {name = name, mode = mode})
            if mode == "r" then
                if name == "custom-dir/ak-server.iswatching" then return {close = function() end} end
                return nil
            end
            return {
                write = function(_, content) writtenFiles[name] = content end,
                flush = function() end,
                close = function() end
            }
        end

        local ExchangeDirRegistry = require("ce.databridge.ExchangeDirRegistry")
        local ServerExchangeFileIo = require("ce.databridge.ServerExchangeFileIo")

        openCalls = {}
        ExchangeDirRegistry.setExchangeDirectory("custom-dir")
        ServerExchangeFileIo.writeOutgoingEvents("{\"kind\":\"event\"}")

        assert.same({
            {name = "custom-dir/ak-eep-version.txt", mode = "w"}, {name = "custom-dir/ak-eep-out.json", mode = "w"},
            {name = "custom-dir/ak-server.iswatching", mode = "r"},
            {name = "custom-dir/ak-eep-out-json.isfinished", mode = "w"}
        }, openCalls)
        assert.equals("{\"kind\":\"event\"}\n", writtenFiles["custom-dir/ak-eep-out.json"])
        assert.equals("", writtenFiles["custom-dir/ak-eep-out-json.isfinished"])
        assert.equals("custom-dir/ak-eep-web-server-state.counter", ServerExchangeFileIo.inFileNameEventCounter)
    end)
end)
