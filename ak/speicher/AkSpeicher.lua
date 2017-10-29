local storageSlots = {}
local storedValues = {}
AkStorage = {}
AkStorage.storedValuesFile = "AkSpeicherWerte.txt"
AkStorage.debug = AkDebugInit or false

--- Prueft einen EEP-Speicherslot zwischen 1 und 1000 und markiert ihn als benutzt.
--- Es wird ein Fehler ausgegeben, wenn der gleiche Slot noch mal registriert wird.
--- -------------------------------------------------------------------------------
--- Checks an EEP-Storage slot between 1 and 1000 and markes it as used.
--- An error will be created, if this ID was already registered somewhere else.
-- @param eepSaveId 1-1000 - Speicherplatz in EEP
-- @param name optional: Name des Speicherortes fuer Debug-Anzeige
--
function AkStorage.register(eepSaveId, name)
    local name = name and name or "?"
    assert(type(eepSaveId) == "number" and eepSaveId > 0 and eepSaveId <= 1000, "Falsche eepSaveId " .. eepSaveId)
    assert(storageSlots[eepSaveId] == nil, "Speicher-ID ist bereits vergeben: " .. eepSaveId .. " (" .. (storageSlots[eepSaveId] and storageSlots[eepSaveId] or "nil") .. ")")
    storageSlots[eepSaveId] = name
end

--- Laedt die Daten aus dem Speicherslot in eine neue Tabelle.
--- Das Speichern der Daten sollte komma-separiert erfolgen, z.B.:
--- belegt = true, anzahl = 15
--- Dann koennen die Daten wie folgt aus der Tabelle geladen werden:
--- local t = AkStorage.loadTable(eepSaveId, "Name")
--- local belegt = t["belegt"]
--- local anzahl = t["anzahl"]
--- ---------------------------------------------------------------
--- Loads data from the Storage slot to a new table.
--- Storage should have been done in Table Syntax, e.g.:
--- traffic = true, count = 15
--- Then loading can be done with these functions as follows:
--- local t = AkStorage.loadTable(eepSaveId, "Name")
--- local traffic = t["traffic"]
--- local count = t["count"]-- @param eepSaveId
-- @param eepSaveId 1-1000 - Speicherplatz in EEP
-- @param name optional: Name des Speicherortes fuer Debug-Anzeige
--
function AkStorage.loadTable(eepSaveId, name)
    local name = name and name or "?"
    local hResult, data = EEPLoadData(eepSaveId)
    if hResult then
        if AkStorage.debug then print("[AkStorage  ] Laden: [OK] - " .. eepSaveId .. " - " .. name .. " gefunden: " .. data) end
    else
        if AkStorage.debug then print("[AkStorage  ] Laden: [!!] - " .. eepSaveId .. " - " .. name .. " nicht gefunden!") end
    end

    local t = {}
    if data then
        for k, v in string.gmatch(data, "(%w+)=(.-[,])") do
            v = v:sub(1, -2)
            if AkStorage.debug then print(k .. "=" .. v) end
            t[k] = v
        end
    end
    return t
end

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
--- AkStorage.storeToTable(100, t, "Meine Kreuzung")
--- --------------------------------------------------------
--- Stores the data of a table into an EEP data slot
-- @param eepSaveId 1-1000 - Speicherplatz in EEP
-- @param table eine Lua Tabelle mit Daten und moeglichst kurzem Key und Value
-- @param name optional: Name des Speicherortes fuer Debug-Anzeige
--
function AkStorage.storeTable(eepSaveId, table, name)
    local name = name and name or "?"
    local text = ""
    for k, v in pairsByKeys(table) do
        assert(type(k) == "string", "Key ist kein string: " .. tostring(v))
        assert(type(v) == "string", "Wert ist kein string: " .. tostring(v) .. " (" .. tostring(k) .. ")")
        assert(not string.find(k, ","))
        assert(not string.find(v, ","))
        text = text .. k .. "=" .. v .. ","
    end
    local hresult = EEPSaveData(eepSaveId, text)
    if AkStorage.debug then
        print("[AkStorage  ] Speichern [" .. (hresult and "OK" or "!!") .. "] - " .. eepSaveId
                .. " - " .. name .. " gespeichert: " .. text)
    end
    storedValues[eepSaveId] = text
    if AkStorage.debug then
        AkStorage.updateStoredValuesFile()
    end
end

--- Konvertiert einen Wert in ein boolean
--- --------------------------------------------------------
--- Converts a value to boolean
-- @param value optional: Name des Speicherortes fuer Debug-Anzeige
--
function AkStorage.toboolean(value)
    return (value and value == "true") and true or false
end

function AkStorage.updateStoredValuesFile()
    local file = assert(io.open((AkDebug and AkDebug.outputPath or "") .. AkStorage.storedValuesFile, "w"))
    local output = ""
    for i = 1, 1000 do
        if storedValues[i] then
            output = output .. "DS_" .. i .. " = \"" .. storedValues[i] .. "\"\n"
        end
    end
    file:write(output .. "\n")
    file:close()
end


for i = 1, 1000 do
    local hResult, data = EEPLoadData(i)
    if hesult then
        storedValues[i] = data
    end
    if AkStorage.debug then
        AkStorage.updateStoredValuesFile()
    end
end