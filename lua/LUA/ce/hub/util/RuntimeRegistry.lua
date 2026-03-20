if AkDebugLoad then print("[#Start] Loading ce.hub.util.RuntimeRegistry ...") end

local RuntimeMetrics = require("ce.hub.data.runtime.RuntimeMetrics")

---@class RuntimeRegistry
local RuntimeRegistry = {}

local function executeAndStoreRunTimeInternal(group, func, ...)
    if not func then return end

    local t0 = os.clock()
    local result = { func(...) }
    RuntimeMetrics.storeRunTime(group, os.clock() - t0)

    return table.unpack(result)
end

function RuntimeRegistry.runTimed(group, func, ...)
    return executeAndStoreRunTimeInternal(group, func, ...)
end

function RuntimeRegistry.runTimedAndKeep(group, func, ...)
    RuntimeMetrics.keepGroup(group)
    return executeAndStoreRunTimeInternal(group, func, ...)
end

--- Indirect call of EEP function (or any other function) including time measurement
function RuntimeRegistry.executeAndStoreRunTime(func, group, ...)
    return executeAndStoreRunTimeInternal(group, func, ...)
end

return RuntimeRegistry
