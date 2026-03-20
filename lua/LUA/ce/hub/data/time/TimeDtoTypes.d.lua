---@meta

---@class TimeDto
---@field id string
---@field name string
---@field timeComplete number
---@field timeH number
---@field timeM number
---@field timeS number

---@class TimeDtoFactory
---@field createTimeDto fun(timeData: table):string,string,string|number,TimeDto
---@field createTimeDtoList fun(times: table):string,string,table
