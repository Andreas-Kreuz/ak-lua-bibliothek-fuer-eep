if AkDebugLoad then print("[#Start] Loading ce.databridge.DataStoreFileWriter ...") end
local InternalDataStore = require("ce.hub.publish.InternalDataStore")
local ExchangeDirRegistry = require("ce.databridge.ExchangeDirRegistry")
local json = require("ce.third-party.json")

local DataStoreFileWriter = {}

---Schreibt den Inhalt von InternalDataStore.rooms als JSON in eine Datei.
---@return string
function DataStoreFileWriter.write()
    local encodedRooms = json.encode(InternalDataStore.rooms)
    local fileName = ExchangeDirRegistry.getExchangeDirectory() .. "/ak-eep-lib-store.json"
    local file = io.open(fileName, "w")
    assert(file, fileName)
    file:write(encodedRooms)
    file:flush()
    file:close()
    return encodedRooms
end

return DataStoreFileWriter
