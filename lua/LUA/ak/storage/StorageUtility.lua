if AkDebugLoad then print("Loading ak.storage.StorageUtility ...") end

local saveSlots = {}
local savedValues = {}
local StorageUtility = {}
StorageUtility.debugDatei = "StorageUtilityValues.txt"
StorageUtility.debug = AkStartWithDebug or false

--- Prueft einen EEP-Speicherslot zwischen 1 und 1000 und markiert ihn als benutzt.
--- Es wird ein Fehler ausgegeben, wenn der gleiche Slot noch mal registriert wird.
--- -------------------------------------------------------------------------------
--- Checks an EEP-Storage slot between 1 and 1000 and markes it as used.
--- An error will be created, if this ID was already registered somewhere else.
-- @param eepSaveId 1-1000 - Speicherplatz in EEP
-- @param name optional: Name des Speicherortes fuer Debug-Anzeige
--
function StorageUtility.registerId(eepSaveId, name)
    name = name and name or "?"
    assert(type(eepSaveId) == "number" and eepSaveId > 0 and eepSaveId <= 1000, eepSaveId)
    assert(saveSlots[eepSaveId] == nil,
           "Speicher-ID ist bereits vergeben: " .. eepSaveId .. " (" ..
           (saveSlots[eepSaveId] and saveSlots[eepSaveId] or "nil") .. ")" .. "\n" .. debug.traceback())
    saveSlots[eepSaveId] = name
end

function StorageUtility.getName(eepSaveId) return saveSlots[eepSaveId] end

--- Laedt die Daten aus dem Speicherslot in eine neue Tabelle.
--- Das Speichern der Daten sollte komma-separiert erfolgen, z.B.:
--- belegt = true, anzahl = 15
--- Dann koennen die Daten wie folgt aus der Tabelle geladen werden:
--- local t = StorageUtility.loadTable(eepSaveId, "Name")
--- local belegt = t["belegt"]
--- local anzahl = t["anzahl"]
--- ---------------------------------------------------------------
--- Loads data from the Storage slot to a new table.
--- Storage should have been done in Table Syntax, e.g.:
--- traffic = true, count = 15
--- Then loading can be done with these functions as follows:
--- local t = StorageUtility.loadTable(eepSaveId, "Name")
--- local traffic = t["traffic"]
--- local count = t["count"]-- @param eepSaveId
-- @param eepSaveId 1-1000 - Speicherplatz in EEP
-- @param name optional: Name des Speicherortes fuer Debug-Anzeige
--
function StorageUtility.loadTable(eepSaveId, name)
    name = name and name or "?"
    local hResult, data = EEPLoadData(eepSaveId)
    if hResult then
        if StorageUtility.debug then
            print("[StorageUtility  ] Laden: [OK] - " .. eepSaveId .. " - " .. name .. " gefunden: " .. data)
        end
    else
        if StorageUtility.debug then
            print("[StorageUtility  ] Laden: [!!] - " .. eepSaveId .. " (DataSlot) - " .. name .. " nicht gefunden!")
        end
    end

    return StorageUtility.parseTableFromString(data)
end

function StorageUtility.parseTableFromString(data)
    local t = {}
    if data then
        for k, v in string.gmatch(data, "(%w+)=(.-[,])") do
            v = v:sub(1, -2)
            if StorageUtility.debug then print(k .. "=" .. v) end
            t[k] = v
        end
    end
    return t
end

---Load a table of key = value (string, string) from a rollingstock
--- Storage should have been done in Table Syntax, e.g.:
--- traffic = true, count = 15
--- Then loading can be done with these functions as follows:
--- local t = StorageUtility.loadTableRollingStock(rollingStockName)
--- local traffic = t["traffic"]
--- local count = t["count"]-- @param eepSaveId
-- @param rollingStockName string Name of the rollingStock in EEP
function StorageUtility.loadTableRollingStock(rollingStockName)
    local hResult, data = EEPRollingstockGetTagText(rollingStockName)
    if hResult then
        if StorageUtility.debug then
            print("[StorageUtility  ] Load: [OK] - " .. rollingStockName .. " (RollingStock) found: " .. data)
        end
    else
        print("[StorageUtility  ] Load: [!!] - " .. rollingStockName .. " (RollingStock) not found!")
    end

    return StorageUtility.parseTableFromString(data)
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
        if a[i] == nil then
            return nil
        else
            return a[i], t[a[i]]
        end
    end
    return iter
end

--- Speichert die Daten einer Tabelle in einen EEP-Datenslot, z.B.:
--- local t = {}
--- t[belegt] = true
--- t[anzahl] = 15
--- StorageUtility.storeToTable(100, t, "Meine Kreuzung")
--- --------------------------------------------------------
--- Stores the data of a table into an EEP data slot
-- @param eepSaveId number 1-1000 - Speicherplatz in EEP
-- @param table table eine Lua Tabelle mit Daten und moeglichst kurzem Key und Value
-- @param name string optional: Name des Speicherortes fuer Debug-Anzeige
--
function StorageUtility.saveTable(eepSaveId, table, name)
    name = name and name or "?"
    local text = StorageUtility.encodeTable(table)
    if text:len() > 1024 then
        print("Cannot store more than 1024 characters in slot " .. eepSaveId .. " - " .. name)
    end
    assert(text:len() <= 1024)
    local hresult = EEPSaveData(eepSaveId, text)
    if StorageUtility.debug then
        print(
        "[StorageUtility  ] Speichern [" .. (hresult and "OK" or "!!") .. "] - " .. eepSaveId .. " - " .. name ..
        " gespeichert: " .. text)
    end
    savedValues[eepSaveId] = text
    if StorageUtility.debug then StorageUtility.updateDebugFile() end
end

--- Stores the data of a table into an EEP data slot
-- @param rollingStockName string Rolling stock name in EEP
-- @param table table eine Lua Tabelle mit Daten und moeglichst kurzem Key und Value
function StorageUtility.encodeTable(table)
    local text = ""
    for k, v in pairsByKeys(table) do
        assert(type(k) == "string", "Need 'k' as string")
        assert(type(v) == "string", "Need 'v' as string")
        assert(not string.find(k, ","))
        assert(not string.find(v, ","))
        text = text .. k .. "=" .. v .. ","
    end
    if text:len() > 1024 then print("Cannot store more than 1024 characters") end
    assert(text:len() <= 1024)
    return text
end

--- Konvertiert einen Wert in ein boolean
--- --------------------------------------------------------
--- Converts a value to boolean
-- @param value optional: Name des Speicherortes fuer Debug-Anzeige
--
function StorageUtility.toboolean(value) return (value and value == "true") and true or false end

function StorageUtility.calcEepLuaData()
    local ausgabeT = {"[EEPLuaData]\n"}
    for i = 1, 1000 do
        local t = type(savedValues[i])
        local typeValue
        local encodedValue
        if t == "string" then
            typeValue = "DS_"
            encodedValue = "\"" .. savedValues[i] .. "\""
        elseif t == "number" then
            typeValue = "DN_"
            encodedValue = string.format("%f", savedValues[i])
        elseif t == "boolean" then
            typeValue = "DB_"
            encodedValue = savedValues[i] and "1" or "0"
        end

        if (encodedValue) then
            table.insert(ausgabeT, typeValue)
            table.insert(ausgabeT, i)
            table.insert(ausgabeT, " = ")
            table.insert(ausgabeT, encodedValue)
            table.insert(ausgabeT, "\n")
        end
    end
    return table.concat(ausgabeT, "")
end

function StorageUtility.updateDebugFile()
    local datei = assert(io.open(StorageUtility.debugDatei, "w"))
    datei:write(StorageUtility.calcEepLuaData())
    datei:close()
end

function StorageUtility.reset()
    saveSlots = {}
    savedValues = {}
end

--- Lädt
for i = 1, 1000 do
    local hResult, data = EEPLoadData(i)
    if hResult then savedValues[i] = data end
    if StorageUtility.debug then StorageUtility.updateDebugFile() end
end

return StorageUtility
