insulate("RuntimeDataCollector", function ()
    local function clearModule(name) package.loaded[name] = nil end

    before_each(function ()
        clearModule("ce.hub.data.runtime.RuntimeDataCollector")
    end)

    it("returns only the latest publishable snapshot", function ()
        local RuntimeDataCollector = require("ce.hub.data.runtime.RuntimeDataCollector")

        RuntimeDataCollector.setLastCycleRuntimeEntries({
            sample = { id = "sample", count = 1, time = 2, lastTime = 2 }
        }, false)

        assert.is_nil(RuntimeDataCollector.collectRuntimeEntries())

        RuntimeDataCollector.setLastCycleRuntimeEntries({
            sample = { id = "sample", count = 2, time = 4, lastTime = 1 }
        }, true)

        local firstSnapshot = RuntimeDataCollector.collectRuntimeEntries()
        assert.same({
            sample = { id = "sample", count = 2, time = 4, lastTime = 1 }
        }, firstSnapshot)

        firstSnapshot.sample.count = 99

        assert.is_nil(RuntimeDataCollector.collectRuntimeEntries())
    end)
end)
