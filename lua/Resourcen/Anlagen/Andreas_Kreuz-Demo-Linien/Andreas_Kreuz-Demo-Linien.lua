clearlog()
require("ce.demo-anlagen.demo-linien.demo-linien-main")

-- Diese Zeile l�dt den Einstiegspunkt der Lua-Bibliothek
local ControlExtension = require("ce.ControlExtension")

-- Diese Zeilen registrieren die folgenden Module
-- * Core (immer ben�tigt)
-- * Data (Export der Daten f�r EEP)
-- * Intersection (f�r die Ampelsteuerung notwendig)
ControlExtension.addModules(require("ce.hub.mods.CoreCeModule"),
                               require("ce.hub.mods.DataCeModule"),
                               require("ce.mods.road.RoadCeModule"),
                               require("ce.mods.transit.TransitCeModule"))

-- Die EEPMain Methode wird von EEP genutzt. Sie muss immer 1 zur�ckgeben.
function EEPMain()
    -- ControlExtension startet die Aufgaben in allen Modulen bei jedem f�nften EEPMain-Aufruf
    ControlExtension.runTasks(5)
    return 1
end

-- Nutze einen Speicherslot in EEP um die Einstellungen f�r Kreuzungen zu laden und zu speichern
-- Intersection.loadSettingsFromSlot(1)
