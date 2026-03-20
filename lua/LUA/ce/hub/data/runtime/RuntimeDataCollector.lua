if AkDebugLoad then print("[#Start] Loading ce.hub.data.runtime.RuntimeDataCollector ...") end

local RuntimeDataCollector = {}

---@type table<string, RuntimeDto>|nil
local lastCycleRuntimeEntries = nil
local lastCycleRuntimeEntriesPublishable = false

local function deepCopy(value)
    if type(value) ~= "table" then return value end

    local copy = {}
    for key, entry in pairs(value) do copy[key] = deepCopy(entry) end
    return copy
end

---@param runtimeEntries table<string, RuntimeEntry>|nil
---@param publishable boolean
function RuntimeDataCollector.setLastCycleRuntimeEntries(runtimeEntries, publishable)
    lastCycleRuntimeEntries = runtimeEntries and deepCopy(runtimeEntries) or nil
    lastCycleRuntimeEntriesPublishable = publishable == true
end

---@return table<string, RuntimeEntry>|nil
function RuntimeDataCollector.collectRuntimeEntries()
    if not lastCycleRuntimeEntriesPublishable or not lastCycleRuntimeEntries then return nil end

    lastCycleRuntimeEntriesPublishable = false
    return deepCopy(lastCycleRuntimeEntries)
end

function RuntimeDataCollector.reset()
    lastCycleRuntimeEntries = nil
    lastCycleRuntimeEntriesPublishable = false
end

return RuntimeDataCollector
