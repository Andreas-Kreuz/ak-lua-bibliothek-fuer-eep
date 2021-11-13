clearlog()
require("ak.demo-anlagen.demo-linien.demo-linien-main")

-- Diese Zeile lädt die Modulverwaltung der Lua-Bibliothek
local ModuleRegistry = require("ak.core.ModuleRegistry")

-- Diese Zeilen aktivieren die folgenden Module in der Modulverwaltung
-- * Core (immer benötigt)
-- * Data (Export der Daten für EEP)
-- * Crossing (für die Ampelsteuerung notwendig)
ModuleRegistry.registerModules(require("ak.core.CoreLuaModule"), require("ak.data.DataLuaModule"),
                               require("ak.road.CrossingLuaModul"))

-- Die EEPMain Methode wird von EEP genutzt. Sie muss immer 1 zurückgeben.
function EEPMain()
    -- Die Modulverwaltung startet die Aufgaben in allen Modulen bei jedem fünften EEPMain-Aufruf
    ModuleRegistry.runTasks(5)
    return 1
end

-- Nutze einen Speicherslot in EEP um die Einstellungen für Kreuzungen zu laden und zu speichern
-- Crossing.loadSettingsFromSlot(1)