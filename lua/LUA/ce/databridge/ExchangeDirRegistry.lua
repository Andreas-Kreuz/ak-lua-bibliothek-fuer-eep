if AkDebugLoad then print("[#Start] Loading ce.databridge.ExchangeDirRegistry ...") end

--- Pruefe ob das Verzeichnis existiert und Dateien geschrieben werden koennen.
-- Call this function via pcall to catch any exceptions
---@param dir string
---@return boolean
local function dirExists(dir)
    local ceVersionFileName = dir .. "/" .. "ce-version.txt"
    local file = io.open(ceVersionFileName, "w")
    assert(file, ceVersionFileName)
    file:write(string.format("%.1f", EEPVer))
    file:flush()
    file:close()
    return true
end

--- Finde ein schreibbares Verzeichnis.
---@param dirs string[]
---@return string|nil
local function existingDirOf(dirs)
    for _, dir in pairs(dirs) do if pcall(dirExists, dir) then return dir end end
    return nil
end

--- Ermittelt das Default-Austauschverzeichnis.
---@return string
local function resolveDefaultExchangeDirectory()
    return existingDirOf({ "../LUA/ce/databridge/exchange", "./LUA/ce/databridge/exchange" }) or "."
end

local ExchangeDirRegistry = {}
local exchangeDirectory = resolveDefaultExchangeDirectory()

--- Setzt das Austauschverzeichnis.
---@param dirName string
---@return string
function ExchangeDirRegistry.setExchangeDirectory(dirName)
    assert(dirName, "Verzeichnis angeben!")
    assert(pcall(dirExists, dirName), dirName)
    exchangeDirectory = dirName
    return exchangeDirectory
end

--- Liefert das aktuelle Austauschverzeichnis.
---@return string
function ExchangeDirRegistry.getExchangeDirectory() return exchangeDirectory end

--- Ermittelt das Default-Austauschverzeichnis.
---@return string
function ExchangeDirRegistry.resolveDefaultExchangeDirectory() return resolveDefaultExchangeDirectory() end

return ExchangeDirRegistry
