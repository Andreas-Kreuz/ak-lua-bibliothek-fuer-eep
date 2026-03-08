if AkDebugLoad then print("[#Start] Loading ak.events.DataChangeBus ...") end
local ServerEventBuffer = require("ak.io.ServerEventBuffer")
local TableUtils = require("ak.util.TableUtils")

---@class Event
---@field eventCounter number
---@field type string
---@field payload any

---@class EventListener
---@field fireEvent fun(jsonText:string):nil

---The data change bus will receive all events via fire method and inform all listeners.
---It must stay generic and must not know the contents or semantics of room, keyId or element.
---The only event type whose payload shape is known here is CompleteReset.
---@class DataChangeBus
---@field fire fun(type:string, payload:string):nil
---@field addListener fun(listener:EventListener):nil
---@field printListener EventListener a default listeners to print out all events to the standard-out
local DataChangeBus = {}
local listeners = {}
DataChangeBus.debug = AkStartWithDebug or false

---@class ChangeType
---@field dataAdded string
---@field dataRemoved string
---@field dataChanged string
---@field completeReset string
DataChangeBus.eventType = {
    completeReset = "CompleteReset",
    dataAdded = "DataAdded",
    dataChanged = "DataChanged",
    listChanged = "ListChanged",
    dataRemoved = "DataRemoved"
}

---@type EventListener
DataChangeBus.printListener = {
    ---@param event Event
    fireEvent = function (event)
        local t = type(event.payload)
        if t == "table" then
            if event.payload.room then t = event.payload.room .. ": " .. t end
            if event.payload.list and type(event.payload.list) == "table" then
                t = t .. " with " .. TableUtils.length(event.payload.list) .. " entries"
            end
        else
            t = t .. ": " .. tostring(event.payload)
        end
        print("[#EventCounter] " .. event.eventCounter .. ": " .. event.type .. " .. " .. t)
    end
}

local eventCounter = 0;
function DataChangeBus.printEventCounter()
    if DataChangeBus.debug then print("[#EventCounter] " .. "value " .. eventCounter) end
end

---Inform the DataChangeBus of new events, which will then be given to the EventListeners
---@param eventType string
---@param payload table
local function fire(eventType, payload)
    eventCounter = eventCounter + 1
    ---@type Event
    local event = { eventCounter = eventCounter, type = eventType, payload = payload }

    -- Fire the event
    for l in pairs(listeners) do l.fireEvent(event) end
end

---Fire a data change event.
---The bus forwards room, keyId and element unchanged and must not interpret them.
---@param room string -- the affected data element, like given in the JSON collectors, e.g. "rail-trains"
---@param keyId string -- name of the field identifying the key, e.g. "trainName" or "id" or "name"
---@param element? table -- complete object with the changed fields or object with updated fields only
function DataChangeBus.fireDataChanged(room, keyId, element)
    assert(room)
    assert(keyId)
    assert(element)
    assert(element[keyId], "the element must contain the key")
    fire(DataChangeBus.eventType.dataChanged, { room = room, keyId = keyId, element = element })
end

---Fire a data change event.
---The bus forwards room, keyId and element unchanged and must not interpret them.
---@param room string -- the affected data element, like given in the JSON collectors, e.g. "rail-trains"
---@param keyId string -- name of the field identifying the key, e.g. "trainName" or "id" or "name"
---@param element? table -- complete object with the changed fields or object with updated fields only
function DataChangeBus.fireDataAdded(room, keyId, element)
    assert(room)
    assert(keyId)
    assert(element)
    assert(element[keyId], "the element must contain the key")
    fire(DataChangeBus.eventType.dataAdded, { room = room, keyId = keyId, element = element })
end

---Fire a data change event.
---The bus forwards room, keyId and element unchanged and must not interpret them.
---@param room string -- the affected data element, like given in the JSON collectors, e.g. "rail-trains"
---@param keyId string -- name of the field identifying the key, e.g. "trainName" or "id" or "name"
---@param element? table -- complete object with the changed fields or object with updated fields only
function DataChangeBus.fireDataRemoved(room, keyId, element)
    assert(room)
    assert(keyId)
    assert(element)
    assert(element[keyId], "the element must contain the key")
    fire(DataChangeBus.eventType.dataRemoved, { room = room, keyId = keyId, element = element })
end

---Fire a data change event.
---The bus forwards room, keyId and list unchanged and must not interpret them.
---@param room string -- the affected data element, like given in the JSON collectors, e.g. "rail-trains"
---@param keyId string -- name of the field identifying the key, e.g. "trainName" or "id" or "name"
---@param list table dictionary  -- complete array with the changed objects
function DataChangeBus.fireListChange(room, keyId, list)
    assert(room)
    assert(keyId)
    assert(list)
    for _, v in pairs(list) do assert(v[keyId], "each element must contain the key") end
    fire(DataChangeBus.eventType.listChanged, { room = room, keyId = keyId, list = list })
end

---Add another listener to the data change bus
---@param listener EventListener
function DataChangeBus.addListener(listener) listeners[listener] = true end

if DataChangeBus.debug then DataChangeBus.addListener(DataChangeBus.printListener) end

DataChangeBus.addListener(ServerEventBuffer)
fire(DataChangeBus.eventType.completeReset, { info = "-- fire a data reset on first start --" })

return DataChangeBus
