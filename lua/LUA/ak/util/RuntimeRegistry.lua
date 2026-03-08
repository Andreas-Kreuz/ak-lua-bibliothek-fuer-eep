if AkDebugLoad then print("[#Start] Loading ak.util.RuntimeRegistry ...") end

---@class RuntimeRegistry
local RuntimeRegistry = {}

---@type table<string, RuntimeEntry>
local runtimeData = {}
local groupsToKeep = {}

--- Store runtime information
-- @author Frank Buchholz
function RuntimeRegistry.storeRunTime(group, time)
    assert(group)
    -- collect and sum runtime date, needs rework
    if not runtimeData then runtimeData = {} end
    if not runtimeData[group] then
        ---@class RuntimeEntry
        ---@field group string
        ---@field count number
        ---@field time number
        local runTimeEntry = { id = group, count = 0, time = 0 }
        runtimeData[group] = runTimeEntry
    end
    local runtime = runtimeData[group]
    runtime.count = runtime.count + 1
    runtime.time = runtime.time + time * 1000
end

function RuntimeRegistry.keepGroup(group)
    assert(group)
    groupsToKeep[group] = true
end

--- Indirect call of EEP function (or any other function) including time measurement
-- @author Frank Buchholz
function RuntimeRegistry.executeAndStoreRunTime(func, group, ...)
    if not func then return end

    local t0 = os.clock()

    local result = { func(...) }

    local t1 = os.clock()
    RuntimeRegistry.storeRunTime(group, t1 - t0)

    return table.unpack(result)
end

function RuntimeRegistry.get(group) return runtimeData[group] or { id = group, count = 0, time = 0 } end

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
