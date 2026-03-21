insulate("ce.databridge.DataStoreFileWriter", function()
    require("ce.hub.eep.EepSimulator")

    local function clearModule(name) package.loaded[name] = nil end

    local originalIoOpen = io.open

    before_each(function()
        clearModule("ce.hub.publish.InternalDataStore")
        clearModule("ce.databridge.ExchangeDirRegistry")
        clearModule("ce.databridge.DataStoreFileWriter")
        io.open = originalIoOpen
    end)

    after_each(function() io.open = originalIoOpen end)

    it("writes DataStore.rooms as json to ak-eep-lib-store.json in the exchange directory", function()
        local writtenContent
        local flushCalled = false
        local closeCalled = false
        local openCalls = {}

        io.open = function(name, mode)
            if name ~= "../LUA/ce/databridge/exchange/ce-version.txt" and
               name ~= "exchange-dir/ce-version.txt" and
               name ~= "exchange-dir/ak-eep-lib-store.json" then
                return originalIoOpen(name, mode)
            end

            table.insert(openCalls, {name = name, mode = mode})

            return {
                write = function(_, content)
                    if name == "exchange-dir/ak-eep-lib-store.json" then writtenContent = content end
                end,
                flush = function() flushCalled = true end,
                close = function() closeCalled = true end
            }
        end

        local DataStore = require("ce.hub.publish.InternalDataStore")
        local ExchangeDirRegistry = require("ce.databridge.ExchangeDirRegistry")
        local DataStoreFileWriter = require("ce.databridge.DataStoreFileWriter")
        local json = require("ce.third-party.json")

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
            {name = "../LUA/ce/databridge/exchange/ce-version.txt", mode = "w"},
            {name = "exchange-dir/ce-version.txt", mode = "w"},
            {name = "exchange-dir/ak-eep-lib-store.json", mode = "w"}
        }, openCalls)
        assert.equals(writtenContent, returnedContent)
        assert.is_true(flushCalled)
        assert.is_true(closeCalled)
        assert.same(DataStore.rooms, json.decode(writtenContent))
    end)
end)
