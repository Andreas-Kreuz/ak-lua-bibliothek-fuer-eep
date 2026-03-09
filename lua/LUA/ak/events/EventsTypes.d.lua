---@meta

---@class ChangeType
---@field completeReset string
---@field dataAdded string
---@field dataChanged string
---@field listChanged string
---@field dataRemoved string

---@class DataChangeEvent
---@field eventCounter number
---@field type string
---@field payload any

---@class EventListener
---@field fireEvent fun(event: DataChangeEvent):nil

---@class PrintEventListener: EventListener

---@class DataChangeBus
---@field debug boolean
---@field eventType ChangeType
---@field printListener PrintEventListener
---@field addListener fun(listener: EventListener):nil
---@field initialize fun():nil
---@field printEventCounter fun():nil
---@field fireDataChanged fun(room: string, keyId: string, element: table):nil
---@field fireDataAdded fun(room: string, keyId: string, element: table):nil
---@field fireDataRemoved fun(room: string, keyId: string, element: table):nil
---@field fireListChange fun(room: string, keyId: string, list: table):nil
---@field fireCompleteReset fun():nil
