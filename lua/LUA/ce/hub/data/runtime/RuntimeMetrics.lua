if AkDebugLoad then print("[#Start] Loading ce.hub.data.runtime.RuntimeMetrics ...") end

---@class RuntimeMetrics
local RuntimeMetrics = {}

---@type table<string, RuntimeEntry>
local runtimeData = {}
local groupsToKeep = {}

--- Store runtime information
function RuntimeMetrics.storeRunTime(group, time)
    assert(group)
    -- collect and sum runtime data, needs rework
    if not runtimeData then runtimeData = {} end
    if not runtimeData[group] then
        ---@class RuntimeEntry
        ---@field id string
        ---@field count number
        ---@field time number
        ---@field lastTime number
        local runTimeEntry = { id = group, count = 0, time = 0, lastTime = 0 }
        runtimeData[group] = runTimeEntry
    end
    local runtime = runtimeData[group]
    local timeMs = time * 1000
    runtime.count = runtime.count + 1
    runtime.time = runtime.time + timeMs
    runtime.lastTime = timeMs
end

function RuntimeMetrics.keepGroup(group)
    assert(group)
    groupsToKeep[group] = true
end

function RuntimeMetrics.get(group) return runtimeData[group] or { id = group, count = 0, time = 0, lastTime = 0 } end

function RuntimeMetrics.getAll() return runtimeData end

function RuntimeMetrics.reset(group) runtimeData[group] = nil end

function RuntimeMetrics.resetAll()
    local newRuntimeData = {}
    for key, value in pairs(runtimeData) do
        if groupsToKeep[key] then newRuntimeData[key] = value end
    end
    runtimeData = newRuntimeData
end

return RuntimeMetrics
