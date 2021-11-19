if AkDebugLoad then print("Loading ak.util.EventBroker ...") end
local json = require "ak.third-party.json"
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
EventBroker.debug = false

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
local eventCounter = 0;
function EventBroker.printEventCounter() if EventBroker.debug then print("EventCounter: " .. eventCounter) end end

---Inform the EventBroker of new events, which will then be given to the EventListeners
---@param eventType string
---@param payload table
local function fire(eventType, payload)
    ---@type Event
    local event = {eventCounter = eventCounter, type = eventType, payload = payload}
    eventCounter = eventCounter + 1

    -- Pack the event into JSON
    local jsonText = json.encode(event)

    -- Fire the event
    for l in pairs(listeners) do l.fireEvent(jsonText) end
end

---Fire a data change event
---@param room string -- the affected data element, like given in the JSON collectors, e.g. "rail-trains"
---@param keyId string -- name of the field identifying the key, e.g. "trainName" or "id" or "name"
---@param element? table -- complete object with the changed fields or object with updated fields only
function EventBroker.fireDataChanged(room, keyId, element)
    assert(room)
    assert(keyId)
    assert(element)
    assert(element[keyId], "the element must contain the key")
    fire(EventBroker.eventType.dataChanged, {room = room, keyId = keyId, element = element})
end

---Fire a data change event
---@param room string -- the affected data element, like given in the JSON collectors, e.g. "rail-trains"
---@param keyId string -- name of the field identifying the key, e.g. "trainName" or "id" or "name"
---@param element? table -- complete object with the changed fields or object with updated fields only
function EventBroker.fireDataAdded(room, keyId, element)
    assert(room)
    assert(keyId)
    assert(element)
    assert(element[keyId], "the element must contain the key")
    fire(EventBroker.eventType.dataAdded, {room = room, keyId = keyId, element = element})
end

---Fire a data change event
---@param room string -- the affected data element, like given in the JSON collectors, e.g. "rail-trains"
---@param keyId string -- name of the field identifying the key, e.g. "trainName" or "id" or "name"
---@param element? table -- complete object with the changed fields or object with updated fields only
function EventBroker.fireDataRemoved(room, keyId, element)
    assert(room)
    assert(keyId)
    assert(element)
    assert(element[keyId], "the element must contain the key")
    fire(EventBroker.eventType.dataRemoved, {room = room, keyId = keyId, element = element})
end

---Fire a data change event
---@param room string -- the affected data element, like given in the JSON collectors, e.g. "rail-trains"
---@param keyId string -- name of the field identifying the key, e.g. "trainName" or "id" or "name"
---@param list table dictionary  -- complete array with the changed objects
function EventBroker.fireListChange(room, keyId, list)
    assert(room)
    assert(keyId)
    assert(list)
    for _, v in pairs(list) do assert(v[keyId], "each element must contain the key") end
    fire(EventBroker.eventType.listChanged, {room = room, keyId = keyId, list = list})
end

---Add another listener to the event broker
---@param listener EventListener
function EventBroker.addListener(listener) listeners[listener] = true end

if AkStartWithDebug then EventBroker.addListener(EventBroker.printListener) end

EventBroker.addListener(EventFileWriter)
fire(EventBroker.eventType.completeReset, "-- fire a data reset on first start --")

return EventBroker
