insulate("RuntimeRegistry", function()
    local function clearModule(name) package.loaded[name] = nil end

    before_each(function()
        clearModule("ce.hub.util.RuntimeRegistry")
        clearModule("ce.hub.data.runtime.RuntimeMetrics")
    end)

    it("runTimed stores runtime and returns original results", function()
        local RuntimeRegistry = require("ce.hub.util.RuntimeRegistry")
        local RuntimeMetrics = require("ce.hub.data.runtime.RuntimeMetrics")

        local first, second = RuntimeRegistry.runTimed("spec.runTimed", function(prefix, value)
            return prefix .. value, value * 2
        end, "v", 3)

        local runtime = RuntimeMetrics.get("spec.runTimed")
        assert.equals("v3", first)
        assert.equals(6, second)
        assert.equals(1, runtime.count)
        assert.is_true(runtime.time >= 0)
        assert.is_true(runtime.lastTime >= 0)
    end)

    it("runTimedAndKeep keeps groups across resetAll", function()
        local RuntimeRegistry = require("ce.hub.util.RuntimeRegistry")
        local RuntimeMetrics = require("ce.hub.data.runtime.RuntimeMetrics")

        RuntimeRegistry.runTimedAndKeep("spec.keep", function() end)
        RuntimeMetrics.resetAll()

        local runtime = RuntimeMetrics.get("spec.keep")
        assert.equals(1, runtime.count)
        assert.is_true(runtime.lastTime >= 0)
    end)

    it("keeps executeAndStoreRunTime compatible", function()
        local RuntimeRegistry = require("ce.hub.util.RuntimeRegistry")
        local RuntimeMetrics = require("ce.hub.data.runtime.RuntimeMetrics")

        local result = RuntimeRegistry.executeAndStoreRunTime(function(value)
            return value + 1
        end, "spec.compat", 4)

        local runtime = RuntimeMetrics.get("spec.compat")
        assert.equals(5, result)
        assert.equals(1, runtime.count)
        assert.is_true(runtime.lastTime >= 0)
    end)
end)
