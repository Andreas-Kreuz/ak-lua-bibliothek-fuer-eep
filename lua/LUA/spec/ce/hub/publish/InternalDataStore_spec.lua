insulate("ce.hub.publish.InternalDataStore", function ()
    local function clearModule(name)
        package.loaded[name] = nil
    end

    before_each(function ()
        clearModule("ce.hub.publish.InternalDataStore")
        clearModule("ce.databridge.ServerEventBuffer")
        clearModule("ce.hub.publish.DataChangeBus")
    end)

    it("tracks added, changed, removed and list replacement events", function ()
        local DataChangeBus = require("ce.hub.publish.DataChangeBus")
        local DataStore = require("ce.hub.publish.InternalDataStore")
        local TableUtils = require("ce.hub.util.TableUtils")

        local addedElement = { name = "Alpha", nested = { value = 1 } }
        DataChangeBus.fireDataAdded("signals", "id", "signal-a", addedElement)
        addedElement.name = "mutated outside"
        addedElement.nested.value = 7

        DataChangeBus.fireDataChanged("signals", "id", "signal-a", { status = "go" })
        DataChangeBus.fireDataAdded("signals", "id", { id = "signal-b", name = "Beta" })
        DataChangeBus.fireDataRemoved("signals", "id", "signal-b", {})

        assert.is_true(TableUtils.deepDictCompare({
            ["signal-a"] = {
                id = "signal-a",
                name = "Alpha",
                nested = { value = 1 },
                status = "go"
            }
        }, DataStore.getRoom("signals")))

        DataChangeBus.fireListChange("signals", "id", {
            { id = "signal-c", name = "Gamma" },
            { id = "signal-d", name = "Delta" }
        })

        assert.is_nil(DataStore.get("signals", "signal-a"))
        assert.is_true(TableUtils.deepDictCompare({
            ["signal-c"] = { id = "signal-c", name = "Gamma" },
            ["signal-d"] = { id = "signal-d", name = "Delta" }
        }, DataStore.getRoom("signals")))

        DataChangeBus.fireCompleteReset()
        assert.is_nil(DataStore.getRoom("signals"))
    end)

    it("registers standard listeners once and emits the reset from the bus", function ()
        local DataChangeBus = require("ce.hub.publish.DataChangeBus")
        local ServerEventBuffer = require("ce.databridge.ServerEventBuffer")
        local DataStore = require("ce.hub.publish.InternalDataStore")
        local json = require("ce.third-party.json")

        DataChangeBus.fireDataAdded("modules", "id", { id = "module-a", name = "Module A" })

        local bufferedEvents = ServerEventBuffer.drainBufferedEvents()
        local eventLines = {}
        for line in bufferedEvents:gmatch("[^\r\n]+") do table.insert(eventLines, line) end

        assert.equals(2, #eventLines)
        assert.equals(DataChangeBus.eventType.completeReset, json.decode(eventLines[1]).type)
        assert.equals(DataChangeBus.eventType.dataAdded, json.decode(eventLines[2]).type)
        assert.same({ id = "module-a", name = "Module A" }, DataStore.get("modules", "module-a"))

        DataChangeBus.initialize()
        assert.equals("", ServerEventBuffer.drainBufferedEvents())
    end)
end)
