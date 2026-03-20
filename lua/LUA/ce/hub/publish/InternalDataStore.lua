if AkDebugLoad then print("[#Start] Loading ce.hub.publish.InternalDataStore ...") end

local InternalDataStore = {
    rooms = {}
}

---Leert eine Tabelle in-place.
---@param tb table
local function clearTable(tb)
    for key in pairs(tb) do tb[key] = nil end
end

---Erzeugt eine tiefe Kopie eines Wertes, damit Event-Payloads nicht von aussen mutiert werden.
---@param value any
---@return any
local function deepCopy(value)
    if type(value) ~= "table" then return value end

    local copy = {}
    for key, entry in pairs(value) do copy[key] = deepCopy(entry) end
    return copy
end

---Liest den Schluessel eines Elements ueber das konfigurierte keyId-Feld.
---@param keyId string
---@param element table
---@return string
local function getElementKey(keyId, element)
    return tostring(element[keyId])
end

---Liefert den Room-Speicher und legt ihn bei Bedarf an.
---@param room string
---@return InternalDataStoreRoom
local function ensureRoom(room)
    if not InternalDataStore.rooms[room] then InternalDataStore.rooms[room] = {} end
    return InternalDataStore.rooms[room]
end

---Entfernt leere Rooms nach dem Loeschen des letzten Elements.
---@param room string
local function removeRoomIfEmpty(room)
    local roomState = InternalDataStore.rooms[room]
    if not roomState or next(roomState) then return end
    InternalDataStore.rooms[room] = nil
end

---Ersetzt den kompletten bekannten Inhalt eines Rooms durch die uebergebene Liste.
---@param room string
---@param keyId string
---@param list DataStoreList
local function replaceRoom(room, keyId, list)
    local roomState = {}
    for _, element in pairs(list) do roomState[getElementKey(keyId, element)] = deepCopy(element) end
    InternalDataStore.rooms[room] = roomState
end

---Fuehrt partielle Aenderungen mit einem vorhandenen Element zusammen.
---@param room string
---@param keyId string
---@param element DataStoreElement
local function mergeElement(room, keyId, element)
    local roomState = ensureRoom(room)
    local elementKey = getElementKey(keyId, element)
    local existingElement = roomState[elementKey] or {}
    local mergedElement = deepCopy(existingElement)

    for fieldName, value in pairs(element) do mergedElement[fieldName] = deepCopy(value) end
    roomState[elementKey] = mergedElement
end

---Setzt den bekannten Datenbestand vollstaendig zurueck.
function InternalDataStore.reset()
    clearTable(InternalDataStore.rooms)
end

---Liefert alle bekannten Elemente eines Rooms.
---@param room string
---@return InternalDataStoreRoom|nil
function InternalDataStore.getRoom(room)
    return InternalDataStore.rooms[room]
end

---Liefert ein einzelnes bekanntes Element aus einem Room.
---@param room string
---@param key string|number
---@return InternalDataStoreElement|nil
function InternalDataStore.get(room, key)
    local roomState = InternalDataStore.getRoom(room)
    if not roomState then return nil end
    return roomState[tostring(key)]
end

---Verarbeitet ein Event des DataChangeBus und aktualisiert den internen Snapshot.
---@param event DataChangeEvent
function InternalDataStore.fireEvent(event)
    if event.type == "CompleteReset" then
        InternalDataStore.reset()
        return
    end

    local payload = event.payload

    if event.type == "DataAdded" then
        ---@cast payload DataElementPayload
        ensureRoom(payload.room)[getElementKey(payload.keyId, payload.element)] = deepCopy(payload.element)
        return
    end

    if event.type == "DataChanged" then
        ---@cast payload DataElementPayload
        mergeElement(payload.room, payload.keyId, payload.element)
        return
    end

    if event.type == "DataRemoved" then
        ---@cast payload DataElementPayload
        local roomState = InternalDataStore.getRoom(payload.room)
        if not roomState then return end

        roomState[getElementKey(payload.keyId, payload.element)] = nil
        removeRoomIfEmpty(payload.room)
        return
    end

    if event.type == "ListChanged" then
        ---@cast payload DataListPayload
        replaceRoom(payload.room, payload.keyId, payload.list)
    end
end

return InternalDataStore