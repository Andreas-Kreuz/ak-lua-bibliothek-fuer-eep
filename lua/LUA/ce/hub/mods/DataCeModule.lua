if AkDebugLoad then print("[#Start] Loading ce.hub.mods.DataCeModule ...") end
DataCeModule = {}
DataCeModule.id = "e538a124-3f0a-4848-98cf-02b08563bf32"
DataCeModule.enabled = true
local initialized = false
-- Jedes Modul hat einen eindeutigen Namen
DataCeModule.name = "ce.hub.mods.DataCeModule"

-- List of collectors which should be active (default = all)
-- Example: { ["ce.hub.VersionStatePublisher"] = true, ["ce.hub.data.trains.TrainsAndTracksStatePublisher"] = true, }
local activeCollectors = {}

--- Diese Funktion wird einmalig durch ControlExtensionHub.initTasks() aufgerufen
-- Ist ein Modul für EEPWeb vorhanden, dann solltes in dieser Funktion aufgerufen werden
-- @author Andreas Kreuz
function DataCeModule.init()
    if not DataCeModule.enabled or initialized then return end

    -- Hier wird der DataBridgeConnector registriert, so dass die Kommunikation mit der WebApp funktioniert
    local DataBridgeConnector = require("ce.hub.bridge.DataBridgeConnector")
    DataBridgeConnector.registerStatePublishers(activeCollectors)

    initialized = true
end

--- Diese Funktion wird regelmäßig durch ControlExtensionHub.runTasks() aufgerufen
-- @author Andreas Kreuz
function DataCeModule.run()
    if not DataCeModule.enabled then return end

    -- Hier folgen die wiederkehrenden Funktionen jedes Moduls (müssen dann nicht in EEPMain aufgerufen werden)
    -- Das CoreModul hat keine wiederkehrenden Funktionen
end

--- Über diese Funktion kann das EEP Skript die Optionen des Moduls setzen
-- @options List of options { activeCollectors = array of jsonCollector names, }
function DataCeModule.setOptions(options)
    if options.activeCollectors then
        local collectorsList = {}
        for _, value in pairs(options.activeCollectors) do collectorsList[value] = true end
        activeCollectors = collectorsList
    end
end

return DataCeModule
