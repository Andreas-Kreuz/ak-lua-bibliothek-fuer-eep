if AkDebugLoad then print("Loading ak.util.Queue ...") end

---@class Event
---@field date string
---@field counter number
---@field type string
---@field payload string

---@class EventListener
---@field fireEvent fun(event:Event):nil

---The event broker will receive all events via fire method and inform all listeners.
---@class EventBroker
---@field fire fun(type:string, payload:string):nil
---@field addListener fun(listener:EventListener):nil
---@field printListener EventListener a default listeners to print out all events to the standard-out
local EventBroker = {}
local os = require("os")
local counter = -1
local listeners = {}

---@type EventListener
EventBroker.printListener = {
    fireEvent = function(event) print(event.date, event.counter, event.type, event.payload) end
}

---Inform the EventBroker of new events, which will then be given to the EventListeners
---@param type string
---@param payload string
function EventBroker.fire(type, payload)
    counter = counter + 1

    ---@type Event
    local event = {date = os.date("%X"), counter = counter, type = type, payload = payload}

    for l in pairs(listeners) do l.fireEvent(event) end
end

---Add another listener to the event broker
---@param listener EventListener
function EventBroker.addListener(listener) listeners[listener] = true end

if AkStartWithDebug then EventBroker.addListener(EventBroker.printListener) end

EventBroker.fire("ak.EventBroker.reset", "------------------------------------------------")

return EventBroker
