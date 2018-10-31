AkCommunicator = {}
json = require("ak.io.json")


local ausgabeVerzeichnis = "."

local function writeFile(dateiname, inhalt)
    local file = io.open(dateiname, "w+")
    assert(file, "Kann Datei nicht öffnen " .. dateiname)
    io.output(file)
    io.write(inhalt)
    io.close(file)
end

---
-- Sendet Inhalte als Ausgabe "type"
-- @param type - Inhaltstyp
-- @param inhalt - Dateiinhalt
function AkCommunicator.send(type, inhalt, verzeichnis)
    local dir = verzeichnis and verzeichnis or ausgabeVerzeichnis
    local dateiname = dir .. "/" .. "ak_out_" .. type .. ".json"
    if not pcall(writeFile, dateiname, inhalt) then
        print("CANNOT WRITE TO " .. dateiname)
    end
    print("Schreibe " .. dateiname)
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
    inhalt = "Hello World!"

    return inhalt;
end

function AkCommunicator.setOutputDirectory(verzeichnis)
    assert(verzeichnis, "Verzeichnis angeben!")
    --ret = os.execute("dir " .. verzeichnis)
    --assert(ret, verzeichnis .. " existiert nicht")
    ausgabeVerzeichnis = verzeichnis
end
