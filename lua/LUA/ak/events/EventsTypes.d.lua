---@meta

---@class ChangeType
---@field completeReset "CompleteReset"
---@field dataAdded "DataAdded"
---@field dataChanged "DataChanged"
---@field listChanged "ListChanged"
---@field dataRemoved "DataRemoved"

---@class CompleteResetPayload
---@field info string

---@class DataElementPayload
---@field room string
---@field keyId string
---@field element table

---@class DataListPayload
---@field room string
---@field keyId string
---@field list table

---@class CompleteResetEvent
---@field eventCounter number
---@field type "CompleteReset"
---@field payload CompleteResetPayload

---@class DataAddedEvent
---@field eventCounter number
---@field type "DataAdded"
---@field payload DataElementPayload

---@class DataChangedEvent
---@field eventCounter number
---@field type "DataChanged"
---@field payload DataElementPayload

---@class DataRemovedEvent
---@field eventCounter number
---@field type "DataRemoved"
---@field payload DataElementPayload

---@class ListChangedEvent
---@field eventCounter number
---@field type "ListChanged"
---@field payload DataListPayload

---@alias DataChangeEvent CompleteResetEvent|DataAddedEvent|DataChangedEvent|DataRemovedEvent|ListChangedEvent

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
---@field fireDataChanged fun(room: string, keyId: string, keyOrElement: string|number|table, element?: table):nil
---@field fireDataAdded fun(room: string, keyId: string, keyOrElement: string|number|table, element?: table):nil
---@field fireDataRemoved fun(room: string, keyId: string, keyOrElement: string|number|table, element?: table):nil
---@field fireListChange fun(room: string, keyId: string, list: table):nil
---@field fireCompleteReset fun():nil
