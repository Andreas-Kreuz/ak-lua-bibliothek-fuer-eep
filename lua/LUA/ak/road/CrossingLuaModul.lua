if AkDebugLoad then print("[#Start] Loading ak.data.CrossingLuaModul ...") end
---@class CrossingLuaModul
CrossingLuaModul = {}
CrossingLuaModul.id = "c5a3e6d3-0f9b-4c89-a908-ed8cf8809362"
CrossingLuaModul.enabled = true
local initialized = false
-- Jedes Modul hat einen eindeutigen Namen
CrossingLuaModul.name = "ak.road.CrossingLuaModul"
local Crossing = require("ak.road.Crossing")

--- Diese Funktion wird einmalig durch ModuleRegistry.initTasks() aufgerufen
-- Ist ein Modul für EEPWeb vorhanden, dann solltes in dieser Funktion aufgerufen werden
-- @author Andreas Kreuz
function CrossingLuaModul.init()
    if not CrossingLuaModul.enabled or initialized then return end

    -- Hier wird der CoreWebConnector registriert, so dass die Kommunikation mit der WebApp funktioniert
    local CrossingWebConnector = require("ak.road.CrossingWebConnector")
    CrossingWebConnector.registerJsonCollectors()
    CrossingWebConnector.registerFunctions()

    Crossing.initSequences()

    initialized = true
end

--- Diese Funktion wird regelmäßig durch ModuleRegistry.runTasks() aufgerufen
-- @author Andreas Kreuz
function CrossingLuaModul.run()
    if not CrossingLuaModul.enabled then return end

    -- Hier folgen die wiederkehrenden Funktionen jedes Moduls (müssen dann nicht in EEPMain aufgerufen werden)
    Crossing.switchSequences()
end

do
    -- Das CrossingLuaModul benötigt das SchedulerLuaModule
    -- Dies wird beim Einlesen dieser Datei automatisch registriert
    local ModuleRegistry = require("ak.core.ModuleRegistry")
    ModuleRegistry.registerModules(require("ak.scheduler.SchedulerLuaModule"))
end

return CrossingLuaModul
