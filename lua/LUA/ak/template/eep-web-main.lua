-- Wenn Du bisher kein Lua in Deinen Anlagen verwendest, dann binde dieses Skript in EEP ein:
-- require("ak.template.eep-web-main")
clearlog()
print("[#Anlage] Willkommen...")

-- Diese Zeile lädt die Modulverwaltung der Lua-Bibliothek
local ModuleRegistry = require("ak.core.ModuleRegistry")
local coreLuaModule = require("ak.core.CoreLuaModule")
local dataLuaModule = require("ak.data.DataLuaModule")
local crossingLuaModul = require("ak.road.CrossingLuaModul")

-- Diese Zeilen aktivieren die folgenden Module in der Modulverwaltung
-- * Core (immer benötigt)
-- * Data (Export der Daten für EEP)
-- * Crossing (für die Ampelsteuerung notwendig)
ModuleRegistry.registerModules(coreLuaModule, dataLuaModule, crossingLuaModul)

-- Die EEPMain Methode wird von EEP genutzt. Sie muss immer 1 zurückgeben.
function EEPMain()
    -- Die Modulverwaltung startet die Aufgaben in allen Modulen bei jedem fünften EEPMain-Aufruf
    ModuleRegistry.runTasks(5)
    return 1
end

-- Nutze einen Speicherslot in EEP um die Einstellungen für Kreuzungen zu laden und zu speichern
-- Crossing.loadSettingsFromSlot(1)
