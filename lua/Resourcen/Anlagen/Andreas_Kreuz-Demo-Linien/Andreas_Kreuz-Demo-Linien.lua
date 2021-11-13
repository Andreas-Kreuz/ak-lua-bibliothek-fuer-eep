-- Wenn Du bisher kein Lua in Deinen Anlagen verwendest, dann binde dieses Skript in EEP ein:
-- require("ak.template.eep-web-main")
-- Diese Zeile l�dt die Modulverwaltung der Lua-Bibliothek
local ModuleRegistry = require("ak.core.ModuleRegistry")

-- Diese Zeilen aktivieren die folgenden Module in der Modulverwaltung
-- * Core (immer ben�tigt)
-- * Data (Export der Daten f�r EEP)
-- * Crossing (f�r die Ampelsteuerung notwendig)
ModuleRegistry.registerModules(require("ak.core.CoreLuaModule"), require("ak.data.DataLuaModule"),
                               require("ak.road.CrossingLuaModul"))

-- Die EEPMain Methode wird von EEP genutzt. Sie muss immer 1 zur�ckgeben.
function EEPMain()
    -- Die Modulverwaltung startet die Aufgaben in allen Modulen bei jedem f�nften EEPMain-Aufruf
    ModuleRegistry.runTasks(5)
    return 1
end

-- Nutze einen Speicherslot in EEP um die Einstellungen f�r Kreuzungen zu laden und zu speichern
-- Crossing.loadSettingsFromSlot(1)