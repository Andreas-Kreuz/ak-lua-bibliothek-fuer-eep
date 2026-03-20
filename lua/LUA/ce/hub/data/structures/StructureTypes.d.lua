---@meta

---@class StructureStatePublisher
---@field name string
---@field initialize fun():nil
---@field syncState fun():table

---@class StructureDataCollector
---@field collectInitialStructures fun():table
---@field refreshDirtyStructures fun(existingStructures: table):table
