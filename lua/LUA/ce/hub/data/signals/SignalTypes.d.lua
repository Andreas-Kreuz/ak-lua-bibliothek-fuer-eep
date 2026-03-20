---@meta

---@class SignalStatePublisher
---@field name string
---@field initialize fun():nil
---@field syncState fun():table

---@class SignalDataCollector
---@field collectInitialSignals fun():table
---@field refreshSignals fun(signals: table):nil
---@field collectWaitingOnSignals fun(signals: table):table
