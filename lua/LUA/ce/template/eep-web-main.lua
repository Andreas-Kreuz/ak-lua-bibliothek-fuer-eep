-- Wenn Du bisher kein Lua in Deinen Anlagen verwendest, dann binde dieses Skript in EEP ein:
-- require("ce.template.eep-web-main")
clearlog()
print("[#Anlage] Willkommen...")

-- Diese Zeile l�dt den Einstiegspunkt der Lua-Bibliothek
local ControlExtension = require("ce.ControlExtension")
local coreCeModule = require("ce.hub.mods.CoreCeModule")
local dataCeModule = require("ce.hub.mods.DataCeModule")
local crossingCeModule = require("ce.mods.road.RoadCeModule")

-- Diese Zeilen registrieren die folgenden Module
-- * Core (immer ben�tigt)
-- * Data (Export der Daten f�r EEP)
-- * Crossing (f�r die Ampelsteuerung notwendig)
ControlExtension.addModules(coreCeModule, dataCeModule, crossingCeModule)

-- Die EEPMain Methode wird von EEP genutzt. Sie muss immer 1 zur�ckgeben.
function EEPMain()
    -- ControlExtension startet die Aufgaben in allen Modulen bei jedem f�nften EEPMain-Aufruf
    ControlExtension.runTasks(5)
    return 1
end

-- Nutze einen Speicherslot in EEP um die Einstellungen f�r Kreuzungen zu laden und zu speichern
-- Crossing.loadSettingsFromSlot(1)
