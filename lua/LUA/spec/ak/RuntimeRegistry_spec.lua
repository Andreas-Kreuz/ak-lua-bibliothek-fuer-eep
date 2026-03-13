insulate("RuntimeRegistry", function()
    local function clearModule(name) package.loaded[name] = nil end

    before_each(function() clearModule("ak.util.RuntimeRegistry") end)

    it("stores count, accumulated time and lastTime", function()
        local RuntimeRegistry = require("ak.util.RuntimeRegistry")

        RuntimeRegistry.storeRunTime("spec.group", 0.125)
        RuntimeRegistry.storeRunTime("spec.group", 0.25)

        local runtime = RuntimeRegistry.get("spec.group")
        assert.equals(2, runtime.count)
        assert.equals(375, runtime.time)
        assert.equals(250, runtime.lastTime)
    end)

    it("runTimed stores runtime and returns original results", function()
        local RuntimeRegistry = require("ak.util.RuntimeRegistry")

        local first, second = RuntimeRegistry.runTimed("spec.runTimed", function(prefix, value)
            return prefix .. value, value * 2
        end, "v", 3)

        local runtime = RuntimeRegistry.get("spec.runTimed")
        assert.equals("v3", first)
        assert.equals(6, second)
        assert.equals(1, runtime.count)
        assert.is_true(runtime.time >= 0)
        assert.is_true(runtime.lastTime >= 0)
    end)

    it("runTimedAndKeep keeps groups across resetAll", function()
        local RuntimeRegistry = require("ak.util.RuntimeRegistry")

        RuntimeRegistry.runTimedAndKeep("spec.keep", function() end)
        RuntimeRegistry.resetAll()

        local runtime = RuntimeRegistry.get("spec.keep")
        assert.equals(1, runtime.count)
        assert.is_true(runtime.lastTime >= 0)
    end)

    it("keeps executeAndStoreRunTime compatible", function()
        local RuntimeRegistry = require("ak.util.RuntimeRegistry")

        local result = RuntimeRegistry.executeAndStoreRunTime(function(value)
            return value + 1
        end, "spec.compat", 4)

        local runtime = RuntimeRegistry.get("spec.compat")
        assert.equals(5, result)
        assert.equals(1, runtime.count)
        assert.is_true(runtime.lastTime >= 0)
    end)
end)
