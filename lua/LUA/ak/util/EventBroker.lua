local json = require "ak.io.json"
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
local os = require("os")
local counter = -1
local listeners = {}

EventBroker.eventType = {dataChanged = "DataChanged", dataReset = "DataReset"}

---@class ChangeType
---@field dataAdded string
---@field dataRemoved string
---@field dataUpdated string
EventBroker.change = {dataAdded = "dataAdded", dataRemoved = "dataRemoved", dataUpdated = "dataUpdated"}

---@type EventListener
EventBroker.printListener = {fireEvent = function(jsonText) print(jsonText) end}

---Inform the EventBroker of new events, which will then be given to the EventListeners
---@param type string
---@param payload string
local function fire(type, payload)
    counter = counter + 1

    ---@type Event
    local event = {date = os.date("%X"), counter = counter, type = type, payload = payload}
    local jsonText = json.encode(event)

    for l in pairs(listeners) do l.fireEvent(jsonText) end
end

---Fire a data change event
---@param eventId string
---@param changeType ChangeType EventBroker.change.XXX
---@param room string
---@param keyId string
---@param element? table
function EventBroker.fireDataChange(eventId, changeType, room, keyId, element)
    if element then assert(element[keyId], "the element must contain the key") end
    fire(EventBroker.eventType.dataChanged, {
        eventId = eventId, -- a cool unique identifier, like "Train vanished" or "Train position update"
        changeType = changeType, -- EventBroker.change.XXX
        room = room, -- the affected data element, like given in the JSON collectors, e.g. "rail-trains"
        keyId = keyId, -- name of the field identifying the key, e.g. "trainName" or "id" or "name"
        element = element -- complete object with the changed fields or object with updated fields only
    })
end

---Add another listener to the event broker
---@param listener EventListener
function EventBroker.addListener(listener) listeners[listener] = true end

if AkStartWithDebug then EventBroker.addListener(EventBroker.printListener) end

EventBroker.addListener(EventFileWriter)
fire(EventBroker.eventType.dataReset, "-- fire a data reset on first start --")

return EventBroker
