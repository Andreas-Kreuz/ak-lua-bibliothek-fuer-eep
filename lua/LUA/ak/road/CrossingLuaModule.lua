if AkDebugLoad then print("[#Start] Loading ak.road.CrossingLuaModule ...") end
---@class CrossingLuaModule
CrossingLuaModule = {}
CrossingLuaModule.id = "c5a3e6d3-0f9b-4c89-a908-ed8cf8809362"
CrossingLuaModule.enabled = true
local initialized = false
-- Jedes Modul hat einen eindeutigen Namen
CrossingLuaModule.name = "ak.road.CrossingLuaModule"
local Crossing = require("ak.road.Crossing")

--- Diese Funktion wird einmalig durch ModuleRegistry.initTasks() aufgerufen
-- Ist ein Modul für EEPWeb vorhanden, dann solltes in dieser Funktion aufgerufen werden
-- @author Andreas Kreuz
function CrossingLuaModule.init()
    if not CrossingLuaModule.enabled or initialized then return end

    -- Hier wird der CoreWebConnector registriert, so dass die Kommunikation mit der WebApp funktioniert
    local CrossingWebConnector = require("ak.road.CrossingWebConnector")
    CrossingWebConnector.registerStatePublishers()
    CrossingWebConnector.registerFunctions()

    Crossing.initSequences()

    initialized = true
end

--- Diese Funktion wird regelmäßig durch ModuleRegistry.runTasks() aufgerufen
-- @author Andreas Kreuz
function CrossingLuaModule.run()
    if not CrossingLuaModule.enabled then return end

    -- Hier folgen die wiederkehrenden Funktionen jedes Moduls (müssen dann nicht in EEPMain aufgerufen werden)
    Crossing.switchSequences()
end

do
    -- Das CrossingLuaModule benötigt das SchedulerLuaModule
    -- Dies wird beim Einlesen dieser Datei automatisch registriert
    local ModuleRegistry = require("ak.core.ModuleRegistry")
    local schedulerLuaModule = require("ak.scheduler.SchedulerLuaModule")
    ModuleRegistry.registerModules(schedulerLuaModule)
end

return CrossingLuaModule
