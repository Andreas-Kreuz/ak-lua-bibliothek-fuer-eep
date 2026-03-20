---@meta

---@class SwitchDataCollector
---@field collectInitialSwitches fun():table
---@field refreshSwitches fun(switches: table):nil

---@class SwitchStatePublisher
---@field name string
---@field initialize fun():nil
---@field syncState fun():table
