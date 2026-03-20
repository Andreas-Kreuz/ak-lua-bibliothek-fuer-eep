insulate("RuntimeMetrics", function()
    local function clearModule(name) package.loaded[name] = nil end

    before_each(function() clearModule("ce.hub.data.runtime.RuntimeMetrics") end)

    it("stores count, accumulated time and lastTime", function()
        local RuntimeMetrics = require("ce.hub.data.runtime.RuntimeMetrics")

        RuntimeMetrics.storeRunTime("spec.group", 0.125)
        RuntimeMetrics.storeRunTime("spec.group", 0.25)

        local runtime = RuntimeMetrics.get("spec.group")
        assert.equals(2, runtime.count)
        assert.equals(375, runtime.time)
        assert.equals(250, runtime.lastTime)
    end)
end)
