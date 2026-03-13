if AkDebugLoad then print("[#Start] Loading ak.io.DataStoreFileWriter ...") end
local DataStore = require("ak.data.DataStore")
local ExchangeDirRegistry = require("ak.io.ExchangeDirRegistry")
local json = require("ak.third-party.json")

local DataStoreFileWriter = {}

---Schreibt den Inhalt von DataStore.rooms als JSON in eine Datei.
---@return string
function DataStoreFileWriter.write()
    local encodedRooms = json.encode(DataStore.rooms)
    local fileName = ExchangeDirRegistry.getExchangeDirectory() .. "/ak-eep-lib-store.json"
    local file = io.open(fileName, "w")
    assert(file, fileName)
    file:write(encodedRooms)
    file:flush()
    file:close()
    return encodedRooms
end

return DataStoreFileWriter
