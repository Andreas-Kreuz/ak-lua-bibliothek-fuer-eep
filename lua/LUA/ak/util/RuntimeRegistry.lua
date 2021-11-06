local RuntimeRegistry = {}

local runtimeData = {}

--- Store runtime information
-- @author Frank Buchholz
function RuntimeRegistry.storeRunTime(group, time)
    -- collect and sum runtime date, needs rework
    if not runtimeData then runtimeData = {} end
    if not runtimeData[group] then runtimeData[group] = {id = group, count = 0, time = 0} end
    local runtime = runtimeData[group]
    runtime.count = runtime.count + 1
    runtime.time = runtime.time + time * 1000
end

--- Indirect call of EEP function (or any other function) including time measurement
-- @author Frank Buchholz
function executeAndStoreRunTime(func, group, ...)
    if not func then return end

    local t0 = os.clock()

    local result = {func(...)}

    local t1 = os.clock()
    storeRunTime(group, t1 - t0)

    return table.unpack(result)
end

function RuntimeRegistry.get(group) return runtimeData[group] or {id = group, count = 0, time = 0} end

function RuntimeRegistry.getAll() return runtimeData or {} end

function RuntimeRegistry.reset(group) runtimeData[group] = nil end

function RuntimeRegistry.resetAll(keepThose)
    local newRuntimeData = {}
    for key in pairs(keepThose) do newRuntimeData[key] = runtimeData[key] end
    runtimeData = newRuntimeData
end

return RuntimeRegistry
