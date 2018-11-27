print("Lade ak.io.AkWebServerIo ...")

local AkWebServerIo = {}

local function dirExists(dir)
    local file = io.open(dir .. "/" .. "ak-eep-version.txt", "w")
    file:write(EEPVer)
    file:flush()
    file:close()
    return true
end

local function existingDirOf(...)
    for _, dir in pairs(...) do
        if pcall(dirExists, dir) then
            return dir
        end
    end
    return nil;
end

local function fileExists(name)
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

local function writeFile(fileName, inhalt)
    local file = io.open(fileName, "w")
    assert(file, "Kann Datei nicht schreiben " .. fileName)
    file:write(inhalt)
    file:flush()
    file:close()
end

local ioDirectoryName
local outFileNameLog
local outFileNameJson
local watchFileNameServer
local watchFileNameLua
local inFileCommands

function AkWebServerIo.setOutputDirectory(dirName)
    assert(dirName, "Verzeichnis angeben!")

    ioDirectoryName = dirName
    outFileNameLog = ioDirectoryName .. '/ak-eep-out.socket'
    outFileNameJson = ioDirectoryName .. '/ak-eep-out.json'
    watchFileNameServer = ioDirectoryName .. '/ak-server.iswatching'
    watchFileNameLua = ioDirectoryName .. '/ak-eep-out-json.isfinished'

    local inFileNameCommands = ioDirectoryName .. '/ak-eep-in.commands'
    writeFile(inFileNameCommands, "")
    inFileCommands = io.open(inFileNameCommands, "r")
end

AkWebServerIo.setOutputDirectory(existingDirOf({ "../LUA/ak/io/exchange", "./LUA/ak/io/exchange" }) or ".")

local writing = false
---
--- Sendet Inhalte als Ausgabe "type"
--- @param type - Inhaltstyp
--- @param jsonData - Dateiinhalt
function AkWebServerIo.updateJsonFile(jsonData)
    if fileExists(watchFileNameServer)
            and fileExists(watchFileNameLua) then
        print("SKIPPING - server not ready")
        return
    end

    if not writing then
        writing = true
        if not pcall(writeFile, outFileNameJson, jsonData) then
            print("CANNOT WRITE TO " .. outFileNameJson)
        end
        writing = false
    end

    if fileExists(watchFileNameServer) then
        writeFile(watchFileNameLua, "")
    end
end

---
--- Liest Inhalte von der Eingabe "type"
--- @param type
function AkWebServerIo.processNewCommands()
    local commands = io.read(inFileCommands)
    if (commands) then
        print("RECEIVED COMMANDS: " .. commands)
    end
end

local _print = print
function print(...)
    -- use the original print function
    _print(...)

    -- print the output to the file
    local file = assert(io.open(outFileNameLog, "a"))
    local args = table.pack(...)
    local text = ""
    for i = 1, args.n do
        text = text .. tostring(args[i])
    end
    file:write(text .. "\n")
    file:close()
end

local _clearlog = clearlog
function clearlog()
    _clearlog()
    io.open(outFileNameLog, "w+"):close()
end

return AkWebServerIo