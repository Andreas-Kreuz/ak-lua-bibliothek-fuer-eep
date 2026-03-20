insulate("RuntimeStatePublisher", function ()
    local function clearModule(name) package.loaded[name] = nil end

    before_each(function ()
        clearModule("ce.hub.data.runtime.RuntimeDataCollector")
        clearModule("ce.hub.data.runtime.RuntimeDtoFactory")
        clearModule("ce.hub.data.runtime.RuntimeStatePublisher")
        clearModule("ce.hub.publish.DataChangeBus")
    end)

    it("publishes the last completed runtime snapshot only once", function ()
        local DataChangeBus = require("ce.hub.publish.DataChangeBus")
        local RuntimeDataCollector = require("ce.hub.data.runtime.RuntimeDataCollector")
        local RuntimeStatePublisher = require("ce.hub.data.runtime.RuntimeStatePublisher")
        local published = {}

        DataChangeBus.fireListChange = function (room, keyId, list)
            table.insert(published, { room = room, keyId = keyId, list = list })
        end

        RuntimeStatePublisher.syncState()
        assert.equals(0, #published)

        RuntimeDataCollector.setLastCycleRuntimeEntries({
            sample = { id = "sample", count = 2, time = 4, lastTime = 1 }
        }, true)

        RuntimeStatePublisher.syncState()
        assert.equals(1, #published)
        assert.equals("runtime", published[1].room)
        assert.equals("id", published[1].keyId)
        assert.same({
            sample = { id = "sample", count = 2, time = 4, lastTime = 1 }
        }, published[1].list)

        RuntimeStatePublisher.syncState()
        assert.equals(1, #published)
    end)
end)
