if AkDebugLoad then print("[#Start] Loading ak.io.ServerExchangeFileIo ...") end
local ExchangeDirRegistry = require("ak.io.ExchangeDirRegistry")

local ServerExchangeFileIo = {}
ServerExchangeFileIo.debug = AkStartWithDebug or false

--- Pruefe ob Datei existiert.
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
local function writeFile(fileName, content)
    local file = io.open(fileName, "w")
    assert(file, fileName)
    file:write(content)
    file:flush()
    file:close()
end

local serverWasReadyLastTime = true
local serverWasListeningLastTime = true
--- Pruefe Status des Web Servers.
function ServerExchangeFileIo.isServerReady()
    if fileExists(ExchangeDirRegistry.getExchangeDirectory() .. "/ak-server.iswatching") then
        if fileExists(ExchangeDirRegistry.getExchangeDirectory() .. "/ak-eep-out-json.isfinished") then
            if ServerExchangeFileIo.debug and serverWasReadyLastTime then
                print("[#ServerExchangeFileIo] SERVER IS NOT READY")
            end
            serverWasReadyLastTime = false
            return false
        else
            if ServerExchangeFileIo.debug and (not serverWasReadyLastTime or not serverWasListeningLastTime) then
                print("SERVER IS READY AND LISTENING")
            end
            serverWasReadyLastTime = true
            serverWasListeningLastTime = true
            return true
        end
    else
        if ServerExchangeFileIo.debug and serverWasListeningLastTime then
            print("[#ServerExchangeFileIo] SERVER IS NOT LISTENING")
        end
        serverWasListeningLastTime = false
        return false
    end
end

local writing = false
--- Schreibe Datei.
---@param jsonData string Dateiinhalt als JSON-formatierter String
function ServerExchangeFileIo.writeOutgoingEvents(jsonData)
    ServerExchangeFileIo.inFileNameEventCounter = ExchangeDirRegistry.getExchangeDirectory() ..
                                                  "/ak-eep-web-server-state.counter"

    if not writing then
        writing = true
        if not pcall(writeFile, ExchangeDirRegistry.getExchangeDirectory() .. "/ak-eep-out.json", jsonData .. "\n") then
            print("[#ServerExchangeFileIo] CANNOT WRITE TO " .. ExchangeDirRegistry.getExchangeDirectory() ..
                  "/ak-eep-out.json")
        end
        writing = false
    end

    if fileExists(ExchangeDirRegistry.getExchangeDirectory() .. "/ak-server.iswatching") then
        writeFile(ExchangeDirRegistry.getExchangeDirectory() .. "/ak-eep-out-json.isfinished", "")
    end
end

return ServerExchangeFileIo
