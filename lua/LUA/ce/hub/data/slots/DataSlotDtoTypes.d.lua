---@meta

---@class DataSlotDto
---@field id number
---@field name string|nil
---@field data string|nil

---@class DataSlotDtoFactory
---@field createFilledDataSlotDto fun(slot: table):string,string,string|number,DataSlotDto
---@field createFilledDataSlotDtoList fun(filledSlots: table):string,string,table
---@field createEmptyDataSlotDto fun(slot: table):string,string,string|number,DataSlotDto
---@field createEmptyDataSlotDtoList fun(emptySlots: table):string,string,table
