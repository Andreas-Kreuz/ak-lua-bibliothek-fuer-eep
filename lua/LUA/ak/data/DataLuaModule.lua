print "Lade ak.data.DataLuaModule ..."
---@class DataLuaModule
DataLuaModule = {}
DataLuaModule.id = "e538a124-3f0a-4848-98cf-02b08563bf32"
DataLuaModule.enabled = true
local initialized = false
-- Jedes Modul hat einen eindeutigen Namen
DataLuaModule.name = "ak.data.DataLuaModule"

-- List of collectors which should be active (default = all)
-- Example: { ["ak.core.VersionJsonCollector"] = true, ["ak.data.TrainsAndTracksJsonCollector"] = true, }
local activeCollectors = {}

--- Diese Funktion wird einmalig durch ModuleRegistry.initTasks() aufgerufen
-- Ist ein Modul für EEPWeb vorhanden, dann solltes in dieser Funktion aufgerufen werden
-- @author Andreas Kreuz
function DataLuaModule.init()
    if not DataLuaModule.enabled or initialized then
        return
    end

    -- Hier wird der DataWebConnector registriert, so dass die Kommunikation mit der WebApp funktioniert
    local DataWebConnector = require("ak.data.DataWebConnector")
    DataWebConnector.registerJsonCollectors(activeCollectors)

    initialized = true
end

--- Diese Funktion wird regelmäßig durch ModuleRegistry.runTasks() aufgerufen
-- @author Andreas Kreuz
function DataLuaModule.run()
    if not DataLuaModule.enabled then
        return
    end

    -- Hier folgen die wiederkehrenden Funktionen jedes Moduls (müssen dann nicht in EEPMain aufgerufen werden)
    -- Das CoreModul hat keine wiederkehrenden Funktionen
end

--- Über diese Funktion kann das EEP Skript die Optionen des Moduls setzen
-- @author Frank Buchholz
-- @options List of options { activeCollectors = array of jsonCollector names, }
function DataLuaModule.setOptions(options)
    if options.activeCollectors then
        local collectorsList = {}
        for _, value in pairs(options.activeCollectors) do
            collectorsList[value] = true
        end
        activeCollectors = collectorsList
    end
end
return DataLuaModule
