if AkDebugLoad then print("[#Start] Loading ak.io.AkWebServerIo ...") end
local AkCommandExecutor = require("ak.io.AkCommandExecutor")
local os = require("os")

local AkWebServerIo = {}
AkWebServerIo.debug = AkStartWithDebug or false

--- Pr�fe ob das Verzeichnis existiert und Dateien geschrieben werden k�nnen.
-- Call this function via pcall to catch any exceptions
local function dirExists(dir)
    local file = io.open(dir .. "/" .. "ak-eep-version.txt", "w")
    file:write(string.format("%.1f", EEPVer))
    file:flush()
    file:close()
    return true
end

--- Finde ein schreibbares Verzeichnis.
local function existingDirOf(...)
    for _, dir in pairs(...) do if pcall(dirExists, dir) then return dir end end
    return nil
end

--- Pr�fe ob Datei existiert.
local function fileExists(name)
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

--- Schreibe Datei.
local function writeFile(fileName, inhalt)
    local file = io.open(fileName, "w")
    assert(file, fileName)
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

--- Bestimme Dateipfade.
function AkWebServerIo.setOutputDirectory(dirName)
    assert(dirName, "Verzeichnis angeben!")

    ioDirectoryName = dirName

    -- EEP appends the log to this file
    outFileNameLog = ioDirectoryName .. "/ak-eep-out.log"

    -- EEP writes it's status to this file regularly
    -- but only if the Web Server is listening and has finished reading the previous version of the file
    outFileNameJson = ioDirectoryName .. "/ak-eep-out.json"

    -- EEP writes it's status to this file regularly
    -- but only if the Web Server is listening and has finished reading the previous version of the file
    AkWebServerIo.inFileNameEventCounter = ioDirectoryName .. "/ak-eep-web-server-state.counter"

    -- The Web Server creates this file at start and deletes it on exit
    -- Conclusion: The server is listening while this file exists
    watchFileNameServer = ioDirectoryName .. "/ak-server.iswatching"

    -- EEP creates this empty file after updating the json file to indicate that the Web Server
    -- can now read the json file
    -- The Web Server should delete this file after reading the json file
    -- Conclusion: The server is busy while this file exists
    watchFileNameLua = ioDirectoryName .. "/ak-eep-out-json.isfinished"
    -- Delete the file during initialization to trigger the creation of the json file once
    -- assert(os.remove(watchFileNameLua))
    -- However, this is not possible because within EEP, the library os contains only the following functions:
    -- setlocale date time difftime clock getenv tmpname
    -- EEP reads commands from this file
    local inFileNameCommands = ioDirectoryName .. "/ak-eep-in.commands"
    -- clear content of commands file
    writeFile(inFileNameCommands, "")
    inFileCommands = io.open(inFileNameCommands, "r")
end

--- Bestimme Default-Dateipfade.
AkWebServerIo.setOutputDirectory(existingDirOf({
    -- default value
    "../LUA/ak/io/exchange", "./LUA/ak/io/exchange"
}) or ".")

local _assert = assert
local _error = error
local _print = print
local _warn = warn

local function printToFile(...)
    if ... then
        -- We open the file for every write, so EEP will not keep this file open all the time
        local file = _assert(io.open(outFileNameLog, "a"))
        local time = ""
        if os.date then time = os.date("%X ") end
        local text = "" .. time
        local args = {...}
        for _, arg in ipairs(args) do text = text .. tostring(arg):gsub("\n", "\n       . ") end
        file:write(text .. "\n")
        file:close()
    end
end

--- Schreibe log zus�tzlich in Datei.
function print(...)
    printToFile(...) -- print the output to the log file
    _print(...) -- call the original print function
end

--- Schreibe Fehler zus�tzlich in Datei.
error = function(message, level)
    printToFile(message) -- print the output to the file
    _error(message, level) -- call the original error function
end

--- Schreibe Fehler zus�tzlich in Datei.
warn = function(message, ...)
    printToFile(message, ...) -- print the output to the file
    _warn(message, ...) -- call the original warn function
end

-- add traceback to assert message by default
assert = function(v, message)
    local status, retval = pcall(_assert, v, message)
    if not status then error(debug.traceback(message and message or "Assertion failed.", 2), 0) end
    return retval
end

local _clearlog = clearlog
--- L�sche Inhalt der log-Datei.
function clearlog()
    -- call the original clearlog function
    local file = io.open(outFileNameLog, "w+")
    file:close()
    file = _assert(io.open(outFileNameLog, "a"))
    file:write("")
    file:close()
    _clearlog()
end

-- These two functions must be registered AFTER print and clearlog are overwritten
AkCommandExecutor.addAcceptedRemoteFunction("clearlog", clearlog)
AkCommandExecutor.addAcceptedRemoteFunction("print", print)

local serverWasReadyLastTime = true
local serverWasListeningLastTime = true
--- Pr�fe Status des Web Servers.
function AkWebServerIo.checkWebServer()
    if fileExists(watchFileNameServer) then -- file: ak-server.iswatching
        if fileExists(watchFileNameLua) then -- file: ak-eep-out-json.isfinished
            if AkWebServerIo.debug and serverWasReadyLastTime then
                print("[#WebServerIo] SERVER IS NOT READY")
            end
            serverWasReadyLastTime = false
            return false
        else
            if AkWebServerIo.debug and (not serverWasReadyLastTime or not serverWasListeningLastTime) then
                print("SERVER IS READY AND LISTENING")
            end
            serverWasReadyLastTime = true
            serverWasListeningLastTime = true
            return true
        end
    else
        if AkWebServerIo.debug and serverWasListeningLastTime then
            print("[#WebServerIo] SERVER IS NOT LISTENING")
        end
        serverWasListeningLastTime = false
        return false
    end
end

local writing = false
--- Schreibe Datei.
---@param jsonData string Dateiinhalt als JSON-formatierter String
function AkWebServerIo.updateJsonFile(jsonData)
    if not writing then
        writing = true
        if not pcall(writeFile, outFileNameJson, jsonData .. "\n") then -- file: ak-eep-out.json
            print("[#WebServerIo] CANNOT WRITE TO " .. outFileNameJson)
        end
        writing = false
    end

    if fileExists(watchFileNameServer) then -- file: ak-server.iswatching
        writeFile(watchFileNameLua, "") -- file: ak-eep-out-json.isfinished
    end
end

--- Lese Kommandos aus Datei und f�hre sie aus.
function AkWebServerIo.processNewCommands()
    local commands = inFileCommands:read("*all") -- file: ak-eep-in.commands
    if commands and commands ~= "" then AkCommandExecutor.execute(commands) end
end

return AkWebServerIo
