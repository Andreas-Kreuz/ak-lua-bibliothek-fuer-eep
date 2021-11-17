local json = require "ak.third-party.json"
if AkDebugLoad then print("Loading ak.util.Queue ...") end
local EventFileWriter = require "ak.io.EventFileWriter"

---@class Event
---@field date string
---@field counter number
---@field type string
---@field payload any

---@class EventListener
---@field fireEvent fun(jsonText:string):nil

---The event broker will receive all events via fire method and inform all listeners.
---@class EventBroker
---@field fire fun(type:string, payload:string):nil
---@field addListener fun(listener:EventListener):nil
---@field printListener EventListener a default listeners to print out all events to the standard-out
local EventBroker = {}
local listeners = {}

---@class ChangeType
---@field dataAdded string
---@field dataRemoved string
---@field dataChanged string
---@field completeReset string
EventBroker.eventType = {
    completeReset = "CompleteReset",
    dataAdded = "DataAdded",
    dataChanged = "DataChanged",
    listChanged = "ListChanged",
    dataRemoved = "DataRemoved"
}

---@type EventListener
EventBroker.printListener = {fireEvent = function(jsonText) print(jsonText) end}

---Inform the EventBroker of new events, which will then be given to the EventListeners
---@param eventType string
---@param payload string
local function fire(eventType, payload)
    ---@type Event
    local event = {type = eventType, payload = payload}
    local jsonText = json.encode(event)

    for l in pairs(listeners) do l.fireEvent(jsonText) end
end

---Fire a data change event
---@param eventType ChangeType EventBroker.eventType.XXX
---@param room string
---@param keyId string
---@param element? table
function EventBroker.fireDataChange(eventType, room, keyId, element)
    assert(
    eventType == EventBroker.eventType.dataChanged or eventType == EventBroker.eventType.dataAdded or eventType ==
    EventBroker.eventType.dataRemoved)
    assert(room)
    assert(keyId)
    assert(element)
    assert(element[keyId], "the element must contain the key")
    fire(eventType, {
        room = room, -- the affected data element, like given in the JSON collectors, e.g. "rail-trains"
        keyId = keyId, -- name of the field identifying the key, e.g. "trainName" or "id" or "name"
        element = element -- complete object with the changed fields or object with updated fields only
    })
end

---Fire a data change event
---@param room string
---@param keyId string
---@param list table dictionary or array
function EventBroker.fireListChange(room, keyId, list)
    assert(room)
    assert(keyId)
    assert(list)
    for _, v in pairs(list) do assert(v[keyId], "each element must contain the key") end
    fire(EventBroker.eventType.listChanged, {
        room = room, -- the affected data element, like given in the JSON collectors, e.g. "rail-trains"
        keyId = keyId, -- name of the field identifying the key, e.g. "trainName" or "id" or "name"
        list = list -- complete object with the changed fields or object with updated fields only
    })
end

---Add another listener to the event broker
---@param listener EventListener
function EventBroker.addListener(listener) listeners[listener] = true end

if AkStartWithDebug then EventBroker.addListener(EventBroker.printListener) end

EventBroker.addListener(EventFileWriter)
fire(EventBroker.eventType.completeReset, "-- fire a data reset on first start --")

return EventBroker
