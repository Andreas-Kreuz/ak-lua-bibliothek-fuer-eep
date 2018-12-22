print("Lade ak.speicher.AkSpeicher ...")

local speicherPlaetze = {}
local gespeicherteWerte = {}
local AkSpeicherHilfe = {}
AkSpeicherHilfe.debugDatei = "AkSpeicherWerte.txt"
AkSpeicherHilfe.debug = AkStartMitDebug or false

--- Prueft einen EEP-Speicherslot zwischen 1 und 1000 und markiert ihn als benutzt.
--- Es wird ein Fehler ausgegeben, wenn der gleiche Slot noch mal registriert wird.
--- -------------------------------------------------------------------------------
--- Checks an EEP-Storage slot between 1 and 1000 and markes it as used.
--- An error will be created, if this ID was already registered somewhere else.
-- @param eepSaveId 1-1000 - Speicherplatz in EEP
-- @param name optional: Name des Speicherortes fuer Debug-Anzeige
--
function AkSpeicherHilfe.registriereId(eepSaveId, name)
    name = name and name or "?"
    assert(type(eepSaveId) == "number" and eepSaveId > 0 and eepSaveId <= 1000, "Falsche eepSaveId " .. eepSaveId)
    assert(speicherPlaetze[eepSaveId] == nil, "Speicher-ID ist bereits vergeben: "
            .. eepSaveId .. " (" .. (speicherPlaetze[eepSaveId] and speicherPlaetze[eepSaveId] or "nil") .. ")"
            .. "\n" .. debug.traceback())
    speicherPlaetze[eepSaveId] = name
end

function AkSpeicherHilfe.getName(eepSaveId)
    return speicherPlaetze[eepSaveId]
end

--- Laedt die Daten aus dem Speicherslot in eine neue Tabelle.
--- Das Speichern der Daten sollte komma-separiert erfolgen, z.B.:
--- belegt = true, anzahl = 15
--- Dann koennen die Daten wie folgt aus der Tabelle geladen werden:
--- local t = AkSpeicherHilfe.ladeTabelle(eepSaveId, "Name")
--- local belegt = t["belegt"]
--- local anzahl = t["anzahl"]
--- ---------------------------------------------------------------
--- Loads data from the Storage slot to a new table.
--- Storage should have been done in Table Syntax, e.g.:
--- traffic = true, count = 15
--- Then loading can be done with these functions as follows:
--- local t = AkSpeicherHilfe.ladeTabelle(eepSaveId, "Name")
--- local traffic = t["traffic"]
--- local count = t["count"]-- @param eepSaveId
-- @param eepSaveId 1-1000 - Speicherplatz in EEP
-- @param name optional: Name des Speicherortes fuer Debug-Anzeige
--
function AkSpeicherHilfe.ladeTabelle(eepSaveId, name)
    name = name and name or "?"
    local hResult, data = EEPLoadData(eepSaveId)
    if hResult then
        if AkSpeicherHilfe.debug then print("[AkSpeicherHilfe  ] Laden: [OK] - "
                .. eepSaveId .. " - " .. name .. " gefunden: " .. data) end
    else
        if AkSpeicherHilfe.debug then print("[AkSpeicherHilfe  ] Laden: [!!] - "
                .. eepSaveId .. " - " .. name .. " nicht gefunden!") end
    end

    local t = {}
    if data then
        for k, v in string.gmatch(data, "(%w+)=(.-[,])") do
            v = v:sub(1, -2)
            if AkSpeicherHilfe.debug then print(k .. "=" .. v) end
            t[k] = v
        end
    end
    return t
end

--- Hilfsroutine für die sortierte Ausgabe einer Tabelle
-- @param t eine Tabelle
-- @param f optionale Sortierfunktion
--
local function pairsByKeys(t, f)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
    table.sort(a, f)
    local i = 0 -- iterator variable
    local iter = function() -- iterator function
        i = i + 1
        if a[i] == nil then return nil
        else return a[i], t[a[i]]
        end
    end
    return iter
end

--- Speichert die Daten einer Tabelle in einen EEP-Datenslot, z.B.:
--- local t = {}
--- t[belegt] = true
--- t[anzahl] = 15
--- AkSpeicherHilfe.storeToTable(100, t, "Meine Kreuzung")
--- --------------------------------------------------------
--- Stores the data of a table into an EEP data slot
-- @param eepSaveId 1-1000 - Speicherplatz in EEP
-- @param table eine Lua Tabelle mit Daten und moeglichst kurzem Key und Value
-- @param name optional: Name des Speicherortes fuer Debug-Anzeige
--
function AkSpeicherHilfe.speichereTabelle(eepSaveId, table, name)
    name = name and name or "?"
    local text = ""
    for k, v in pairsByKeys(table) do
        assert(type(k) == "string", "Key ist kein string: " .. tostring(v))
        assert(type(v) == "string", "Wert ist kein string: " .. tostring(v) .. " (" .. tostring(k) .. ")")
        assert(not string.find(k, ","))
        assert(not string.find(v, ","))
        text = text .. k .. "=" .. v .. ","
    end
    local hresult = EEPSaveData(eepSaveId, text)
    if AkSpeicherHilfe.debug then
        print("[AkSpeicherHilfe  ] Speichern [" .. (hresult and "OK" or "!!") .. "] - " .. eepSaveId
                .. " - " .. name .. " gespeichert: " .. text)
    end
    gespeicherteWerte[eepSaveId] = text
    if AkSpeicherHilfe.debug then
        AkSpeicherHilfe.aktualisiereDebugDatei()
    end
end

--- Konvertiert einen Wert in ein boolean
--- --------------------------------------------------------
--- Converts a value to boolean
-- @param value optional: Name des Speicherortes fuer Debug-Anzeige
--
function AkSpeicherHilfe.toboolean(value)
    return (value and value == "true") and true or false
end

function AkSpeicherHilfe.aktualisiereDebugDatei()
    local datei = assert(io.open(AkSpeicherHilfe.debugDatei, "w"))
    local ausgabe = ""
    for i = 1, 1000 do
        if gespeicherteWerte[i] then
            ausgabe = ausgabe .. "DS_" .. i .. " = \"" .. gespeicherteWerte[i] .. "\"\n"
        end
    end
    datei:write(ausgabe .. "\n")
    datei:close()
end

--- Lädt
for i = 1, 1000 do
    local hResult, data = EEPLoadData(i)
    if hResult then
        gespeicherteWerte[i] = data
    end
    if AkSpeicherHilfe.debug then
        AkSpeicherHilfe.aktualisiereDebugDatei()
    end
end

return AkSpeicherHilfe
