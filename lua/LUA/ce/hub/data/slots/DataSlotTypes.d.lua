---@meta

---@class DataSlotNameResolver
---@field updateSlotNames fun():nil
---@field getSlotName fun(slot: string|number):string|nil

---@class DataSlotsStatePublisher
---@field name string
---@field initialize fun():nil
---@field syncState fun():table
