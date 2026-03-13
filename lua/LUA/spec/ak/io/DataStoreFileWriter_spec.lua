insulate("ak.io.DataStoreFileWriter", function()
    require("ak.core.eep.EepSimulator")

    local function clearModule(name) package.loaded[name] = nil end

    local originalIoOpen = io.open

    before_each(function()
        clearModule("ak.data.DataStore")
        clearModule("ak.io.ExchangeDirRegistry")
        clearModule("ak.io.DataStoreFileWriter")
        io.open = originalIoOpen
    end)

    after_each(function() io.open = originalIoOpen end)

    it("writes DataStore.rooms as json to ak-eep-lib-store.json in the exchange directory", function()
        local writtenContent
        local flushCalled = false
        local closeCalled = false
        local openCalls = {}

        io.open = function(name, mode)
            table.insert(openCalls, {name = name, mode = mode})

            return {
                write = function(_, content)
                    if name == "exchange-dir/ak-eep-lib-store.json" then writtenContent = content end
                end,
                flush = function() flushCalled = true end,
                close = function() closeCalled = true end
            }
        end

        local DataStore = require("ak.data.DataStore")
        local ExchangeDirRegistry = require("ak.io.ExchangeDirRegistry")
        local DataStoreFileWriter = require("ak.io.DataStoreFileWriter")
        local json = require("ak.third-party.json")

        ExchangeDirRegistry.setExchangeDirectory("exchange-dir")

        DataStore.rooms = {
            signals = {
                ["signal-1"] = {
                    id = "signal-1",
                    active = true,
                    retries = 3,
                    tags = {"north", "main", false, 7},
                    nested = {section = "A", enabled = true}
                }
            },
            modules = {["module-1"] = {id = "module-1", name = "Module A"}}
        }

        local returnedContent = DataStoreFileWriter.write()

        assert.same({
            {name = "../LUA/ak/io/exchange/ak-eep-version.txt", mode = "w"},
            {name = "exchange-dir/ak-eep-version.txt", mode = "w"},
            {name = "exchange-dir/ak-eep-lib-store.json", mode = "w"}
        }, openCalls)
        assert.equals(writtenContent, returnedContent)
        assert.is_true(flushCalled)
        assert.is_true(closeCalled)
        assert.same(DataStore.rooms, json.decode(writtenContent))
    end)
end)
