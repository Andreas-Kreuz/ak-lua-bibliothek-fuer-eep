require("ak.core.eep.EepSimulator")
local StorageUtility = require("ak.storage.StorageUtility")

StorageUtility.debug = false

------------------------------------------------------------------------------------
-- Ein Speicherplatz kann nur einmal verwendet werden
-- Sinnvoll zu nutzen, wenn man jedem Signal oder anderen Dingen eine eindeutige ID
-- geben möchte
------------------------------------------------------------------------------------
StorageUtility.registerId(800, "Speicherplatz 800")
-- Ein weiterer Aufruf mit dem selben Speicherplatz würde fehlschlagen (Test muss mit pcall erfolgen)
if pcall(StorageUtility.registerId, 800, "Speicherplatz 800") then
    assert(false, "Wenn das auftritt, dann wurde Speicherplatz 800 mehrfach angefragt.")
else
    print("[#StorageUtilityTest] Alles ok: Speicherplatz 800 konnte nicht doppelt verwendet werden.")
end

------------------------------------------------------------------------------------
-- Mit StorageUtility.saveTable(id, tabelle, [name]) kann man tables speichern,
-- deren Werte aus Text bestehen.
-- daten_zum_speichern wird als Tabelle angelegt
------------------------------------------------------------------------------------
do
    -- Daten werden definiert
    local zahl = 5
    local text1 = "Speichern von text"
    local text2 = "true"
    local boolean1 = true
    local boolean2 = false

    print("[#StorageUtilityTest] -----------------------------------------")
    print("[#StorageUtilityTest] Vor dem Speichern:")
    print("[#StorageUtilityTest] -----------------------------------------")
    print("[#StorageUtilityTest] " .. zahl .. " (Typ: " .. type(zahl) .. ")")
    print("[#StorageUtilityTest] " .. text1 .. " (Typ: " .. type(text1) .. ")")
    print("[#StorageUtilityTest] " .. text2 .. " (Typ: " .. type(text2) .. ")")
    print("[#StorageUtilityTest] " .. tostring(boolean1) .. " (Typ: " .. type(boolean1) .. ")")
    print("[#StorageUtilityTest] " .. tostring(boolean2) .. " (Typ: " .. type(boolean2) .. ")")

    -- Die Daten werden in eine Tabelle umgewandelt, welche als Schl�ssel und Wert nur Text enthält
    -- dies am besten in eine Funktion auslagern
    -- Es empfiehlt sich die Schlüssel kurz zu halten, da der
    -- Speicherplatz in EEP vermutlich begrenzt ist
    local zuSpeicherndeDaten = {
        z = tostring(5),
        t1 = "Speichern von text",
        t2 = "true",
        b1 = tostring(boolean1),
        b2 = tostring(boolean2)
    }

    StorageUtility.saveTable(700, zuSpeicherndeDaten, "Meine Daten")

    print("[#StorageUtilityTest] " .. "-----------------------------------------")
    print("[#StorageUtilityTest] " .. "Speicherplatzinhalt nach dem Speichern:")
    print("[#StorageUtilityTest] " .. "-----------------------------------------")
    local _, speicherplatz_inhalt = EEPLoadData(700)
    print("[#StorageUtilityTest] " .. speicherplatz_inhalt)
end

do
    local geladene_daten = StorageUtility.loadTable(700, "Meine Daten")

    -- Die Daten werden gelesen und aus der Tabelle in eigene Werte gespeichert.
    -- Dabei ist die Typumwandlung wichtig
    -- Diese Funktion muss wissen, wie die Schlüssel in der Tabelle aussehen
    -- Dies am besten auch in eine Funktion auslagern
    local zahl = tonumber(geladene_daten.z)
    local text1 = geladene_daten.t1
    local text2 = geladene_daten.t2
    local boolean1 = StorageUtility.toboolean(geladene_daten.b1)
    local boolean2 = StorageUtility.toboolean(geladene_daten.b2)

    print("[#StorageUtilityTest] " .. "-----------------------------------------")
    print("[#StorageUtilityTest] " .. "Nach dem Laden:")
    print("[#StorageUtilityTest] " .. "-----------------------------------------")
    print("[#StorageUtilityTest] " .. zahl .. " (Typ: " .. type(zahl) .. ")")
    print("[#StorageUtilityTest] " .. text1 .. " (Typ: " .. type(text1) .. ")")
    print("[#StorageUtilityTest] " .. text2 .. " (Typ: " .. type(text2) .. ")")
    print("[#StorageUtilityTest] " .. tostring(boolean1) .. " (Typ: " .. type(boolean1) .. ")")
    print("[#StorageUtilityTest] " .. tostring(boolean2) .. " (Typ: " .. type(boolean2) .. ")")
end

require("ak.storage.StorageUtility")
StorageUtility.debug = false
do
    -- Verschiedene Daten
    local anzahl_fahrzeuge = 88
    local block = {belegt = true, zugname = "#ICE-nach-Interlaken", prio = 7}

    -- Zum Speichern muss eine Lua Tabelle erstellt, werden, welche als Schlüssel und Werte nur Text enthält
    -- Es empfiehlt sich die Schlüssel kurz zu halten, da die Länge eines Speicherplatzes in EEP vermutlich begrenzt
    -- ist
    local daten_zum_speichern = {
        b = tostring(block.belegt),
        z = tostring(block.zugname),
        p = tostring(block.prio),
        a = tostring(anzahl_fahrzeuge)
    }

    StorageUtility.saveTable(600, daten_zum_speichern, "Meine Daten")

    print("[#StorageUtilityTest] " .. "-----------------------------------------\n" ..
          "Speicherplatzinhalt nach dem Speichern:" .. "\n-----------------------------------------")
    local _, speicherplatz_inhalt = EEPLoadData(600)
    print("[#StorageUtilityTest] " .. speicherplatz_inhalt)
end

do
    local geladene_daten = StorageUtility.loadTable(600, "Meine Daten")

    -- Nach dem Laden müssen die Werte aus der Tabelle wieder den Variablen zugeordnet werden.
    -- Dabei ist die Rückumwandlung vom string zum korrekten Typ wichtig (tonumber und StorageUtility.toboolean)
    local anzahl_fahrzeuge = tonumber(geladene_daten.a)
    local block = {
        belegt = StorageUtility.toboolean(true), -- StorageUtility.toboolean(x), da Lua kein toboolean(x) hat
        zugname = geladene_daten.z,
        prio = tonumber(geladene_daten.p)
    }

    print("[#StorageUtilityTest] " .. "-----------------------------------------")
    print("[#StorageUtilityTest] " .. "Nach dem Laden:")
    print("[#StorageUtilityTest] " .. "-----------------------------------------")
    print("[#StorageUtilityTest] " .. "anzahl_fahrzeuge=" .. tostring(anzahl_fahrzeuge) .. " (Typ: " ..
          type(anzahl_fahrzeuge) .. ")")
    print("[#StorageUtilityTest] " .. "block.belegt=" .. tostring(block.belegt) .. " (Typ: " .. type(block.belegt) ..
          ")")
    print(
    "[#StorageUtilityTest] " .. "block.zugname=" .. tostring(block.zugname) .. " (Typ: " .. type(block.zugname) .. ")")
    print("[#StorageUtilityTest] " .. "block.prio=" .. tostring(block.prio) .. " (Typ: " .. type(block.prio) .. ")")
end

print("[#StorageUtilityTest] " .. "Test bestanden")
