AkCommunicator = {}

local ausgabeVerzeichnis = "."
local writing = false

local function fileExists(name)
    local f = io.open(name, "r")
    if f ~= nil then io.close(f) return true else return false end
end

local function writeFile(dateiname, inhalt)
    local file = io.open(dateiname, "w")
    assert(file, "Kann Datei nicht öffnen " .. dateiname)
    file:setvbuf("full", 2 * 1024 * 1024)
    io.output(file)
    io.write(inhalt)
    io.flush()
    io.close(file)
end

---
-- Sendet Inhalte als Ausgabe "type"
-- @param type - Inhaltstyp
-- @param inhalt - Dateiinhalt
function AkCommunicator.send(type, inhalt, verzeichnis)
    local dir = verzeichnis and verzeichnis or ausgabeVerzeichnis
    if fileExists(dir .. "//ak_out_eep-web-server.on-sync-only")
            and fileExists(dir .. "/ak_out_eep-web-server.lua-is-finished-writing-data") then
        print("SKIPPING - server not ready")
        return
    end

    local dateiname = dir .. "\\" .. "ak_out_" .. type .. ".json"
    if not writing then
        writing = true
        if not pcall(writeFile, dateiname, inhalt) then
            print("CANNOT WRITE TO " .. dateiname)
        end
        writing = false
    end

    if fileExists(dir .. "//ak_out_eep-web-server.on-sync-only") then
        writeFile(dir .. "/ak_out_eep-web-server.lua-is-finished-writing-data", "")
    end
end

---
-- Liest Inhalte von der Eingabe "type"
-- @param type
function AkCommunicator.receive(type, verzeichnis)
    local dir = verzeichnis and verzeichnis or ausgabeVerzeichnis
    local dateiname = dir .. "/" .. "ak_in_" .. type .. ".json"
    -- local file = io.open(dateiname, "r")
    -- assert(file, "Kann Datei nicht öffnen " .. dateiname)
    -- inhalt = io.read(file)
    -- io.close(file)
    local inhalt = "Hello World!"

    return inhalt;
end

function AkCommunicator.setOutputDirectory(verzeichnis)
    assert(verzeichnis, "Verzeichnis angeben!")
    --ret = os.execute("dir " .. verzeichnis)
    --assert(ret, verzeichnis .. " existiert nicht")
    ausgabeVerzeichnis = verzeichnis
end
