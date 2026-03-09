if AkDebugLoad then print("[#Start] Loading ak.events.DataChangeBus ...") end
local TableUtils = require("ak.util.TableUtils")

---The data change bus will receive all events via fire method and inform all listeners.
---It must stay generic and must not know the contents or semantics of room, keyId or element.
---The only event type whose payload shape is known here is CompleteReset.
local DataChangeBus = {}
---@type table<EventListener, boolean>
local listeners = {}
DataChangeBus.debug = AkStartWithDebug or false
local initialized = false

DataChangeBus.eventType = {
    completeReset = "CompleteReset",
    dataAdded = "DataAdded",
    dataChanged = "DataChanged",
    listChanged = "ListChanged",
    dataRemoved = "DataRemoved"
}

---@type PrintEventListener
DataChangeBus.printListener = {
    ---@param event DataChangeEvent
    fireEvent = function (event)
        local payload = event.payload
        local t = type(payload)
        if t == "table" then
            if event.type == "ListChanged" then
                ---@cast payload DataListPayload
                t = payload.room .. ": " .. t .. " with " .. TableUtils.length(payload.list) .. " entries"
            elseif event.type == "CompleteReset" then
                ---@cast payload CompleteResetPayload
                t = t .. ": " .. payload.info
            else
                ---@cast payload DataElementPayload
                t = payload.room .. ": " .. t
            end
        else
            t = t .. ": " .. tostring(payload)
        end
        print("[#EventCounter] " .. event.eventCounter .. ": " .. event.type .. " .. " .. t)
    end
}

local eventCounter = 0;
function DataChangeBus.printEventCounter()
    if DataChangeBus.debug then print("[#EventCounter] " .. "value " .. eventCounter) end
end

local function registerDefaultListeners()
    DataChangeBus.addListener(require("ak.data.DataStore"))
    DataChangeBus.addListener(require("ak.io.ServerEventBuffer"))
end

function DataChangeBus.initialize()
    if initialized then return end

    registerDefaultListeners()
    initialized = true
    DataChangeBus.fireCompleteReset()
end

---Inform the DataChangeBus of new events, which will then be given to the EventListeners
---@overload fun(eventType: "CompleteReset", payload: CompleteResetPayload):nil
---@overload fun(eventType: "DataAdded"|"DataChanged"|"DataRemoved", payload: DataElementPayload):nil
---@overload fun(eventType: "ListChanged", payload: DataListPayload):nil
---@param eventType "CompleteReset"|"DataAdded"|"DataChanged"|"DataRemoved"|"ListChanged"
---@param payload CompleteResetPayload|DataElementPayload|DataListPayload
local function fire(eventType, payload)
    if not initialized then DataChangeBus.initialize() end
    eventCounter = eventCounter + 1
    ---@type DataChangeEvent
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

function DataChangeBus.fireCompleteReset()
    fire(DataChangeBus.eventType.completeReset, { info = "-- fire a data reset on first start --" })
end

if DataChangeBus.debug then DataChangeBus.addListener(DataChangeBus.printListener) end

return DataChangeBus