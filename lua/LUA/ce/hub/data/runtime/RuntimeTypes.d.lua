---@meta

---@class RuntimeEntry
---@field id string
---@field count number
---@field time number
---@field lastTime number

---@class RuntimeMetrics
---@field storeRunTime fun(group: string, time: number):nil
---@field keepGroup fun(group: string):nil
---@field get fun(group: string):RuntimeEntry
---@field getAll fun():table<string, RuntimeEntry>
---@field reset fun(group: string):nil
---@field resetAll fun():nil

---@class RuntimeRegistry
---@field runTimed fun(group: string, func: function, ...: any):...
---@field runTimedAndKeep fun(group: string, func: function, ...: any):...
---@field executeAndStoreRunTime fun(func: function, group: string, ...: any):...

---@class RuntimeDataCollector
---@field setLastCycleRuntimeEntries fun(runtimeEntries: table<string, RuntimeEntry>|nil, publishable: boolean):nil
---@field collectRuntimeEntries fun():table<string, RuntimeEntry>|nil
---@field reset fun():nil

---@class RuntimeStatePublisher
---@field name string
---@field initialize fun():nil
---@field syncState fun():table
