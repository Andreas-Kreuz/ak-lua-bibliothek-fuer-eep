if AkDebugLoad then print("[#Start] Loading ak.util.RuntimeRegistry ...") end

---@class RuntimeRegistry
local RuntimeRegistry = {}

---@type table<string, RuntimeEntry>
local runtimeData = {}
local groupsToKeep = {}

local function executeAndStoreRunTimeInternal(group, func, ...)
    if not func then return end

    local t0 = os.clock()
    local result = { func(...) }
    RuntimeRegistry.storeRunTime(group, os.clock() - t0)

    return table.unpack(result)
end

--- Store runtime information
-- @author Frank Buchholz
function RuntimeRegistry.storeRunTime(group, time)
    assert(group)
    -- collect and sum runtime date, needs rework
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

function RuntimeRegistry.keepGroup(group)
    assert(group)
    groupsToKeep[group] = true
end

function RuntimeRegistry.runTimed(group, func, ...)
    return executeAndStoreRunTimeInternal(group, func, ...)
end

function RuntimeRegistry.runTimedAndKeep(group, func, ...)
    RuntimeRegistry.keepGroup(group)
    return executeAndStoreRunTimeInternal(group, func, ...)
end

--- Indirect call of EEP function (or any other function) including time measurement
-- @author Frank Buchholz
function RuntimeRegistry.executeAndStoreRunTime(func, group, ...)
    return executeAndStoreRunTimeInternal(group, func, ...)
end

function RuntimeRegistry.get(group) return runtimeData[group] or { id = group, count = 0, time = 0, lastTime = 0 } end

function RuntimeRegistry.getAll() return runtimeData end

function RuntimeRegistry.reset(group) runtimeData[group] = nil end

function RuntimeRegistry.resetAll()
    local newRuntimeData = {}
    for key, value in pairs(runtimeData) do
        if groupsToKeep[key] then newRuntimeData[key] = value end
    end
    runtimeData = newRuntimeData
end

return RuntimeRegistry
