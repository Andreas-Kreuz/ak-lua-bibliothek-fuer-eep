print("Lade AkWebServerIo ...")

AkWebServerIo = {}

local function dirExists(dir)
    local file = io.open(dir .. "/" .. "tmp.txt", "w")
    file:write(EEPVer)
    file:flush()
    file:close()
    return true
end

local function existingDirOf(...)
    for _, dir in pairs(...) do
        if pcall(dirExists, dir) then return dir end
    end
    return nil;
end

local ausgabeVerzeichnis = existingDirOf(--{"."}
    { "../LUA/ak/io/exchange", "./LUA/ak/io/exchange" }) or "."
local writing = false

local function fileExists(name)
    local f = io.open(name, "r")
    if f ~= nil then io.close(f) return true else return false end
end

local function writeFile(dateiname, inhalt)
    local file = io.open(dateiname, "w")
    assert(file, "Kann Datei nicht öffnen " .. dateiname)
    file:write(inhalt)
    file:flush()
    file:close()
end

---
-- Sendet Inhalte als Ausgabe "type"
-- @param type - Inhaltstyp
-- @param inhalt - Dateiinhalt
function AkWebServerIo.send(type, inhalt, verzeichnis)
    local dir = verzeichnis and verzeichnis or ausgabeVerzeichnis
    if fileExists(dir .. "/ak_out_eep-web-server.on-sync-only")
            and fileExists(dir .. "/ak_out_eep-web-server.lua-is-finished-writing-data") then
        print("SKIPPING - server not ready")
        return
    end

    local dateiname = dir .. "/" .. "ak_out_" .. type .. ".json"
    if not writing then
        writing = true
        if not pcall(writeFile, dateiname, inhalt) then
            print("CANNOT WRITE TO " .. dateiname)
        end
        writing = false
    end

    if fileExists(dir .. "/ak_out_eep-web-server.on-sync-only") then
        writeFile(dir .. "/ak_out_eep-web-server.lua-is-finished-writing-data", "")
    end
end

-----
---- Liest Inhalte von der Eingabe "type"
---- @param type
-- function AkWebServerIo.receive(type, verzeichnis)
-- -- local dir = verzeichnis and verzeichnis or ausgabeVerzeichnis
-- -- local dateiname = dir .. "/" .. "ak_in_" .. type .. ".json"
-- -- local file = io.open(dateiname, "r")
-- -- assert(file, "Kann Datei nicht öffnen " .. dateiname)
-- -- inhalt = io.read(file)
-- -- io.close(file)
-- local inhalt = "Hello World!"
--
-- return inhalt;
-- end

function AkWebServerIo.setOutputDirectory(verzeichnis)
    assert(verzeichnis, "Verzeichnis angeben!")
    --ret = os.execute("dir " .. verzeichnis)
    --assert(ret, verzeichnis .. " existiert nicht")
    ausgabeVerzeichnis = verzeichnis
end
