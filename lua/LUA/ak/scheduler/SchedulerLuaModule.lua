if AkDebugLoad then print("Loading ak.scheduler.SchedulerLuaModule ...") end
SchedulerLuaModule = {}
SchedulerLuaModule.id = "725585f1-cfee-4237-97e1-135c5e9f4d02"
SchedulerLuaModule.enabled = true
local initialized = false
-- Jedes Modul hat einen eindeutigen Namen
SchedulerLuaModule.name = "ak.scheduler.SchedulerLuaModule"
local Scheduler = require("ak.scheduler.Scheduler")

--- Diese Funktion wird einmalig durch ModuleRegistry.initTasks() aufgerufen
-- Ist ein Modul für EEPWeb vorhanden, dann solltes in dieser Funktion aufgerufen werden
-- @author Andreas Kreuz
function SchedulerLuaModule.init()
    if not SchedulerLuaModule.enabled or initialized then return end

    -- Hier wird der SchedulerWebConnector registriert, so dass die Kommunikation mit der WebApp funktioniert
    -- Not there yet
    -- local SchedulerWebConnector = require("ak.scheduler.SchedulerWebConnector")
    -- SchedulerWebConnector.registerJsonCollectors();

    initialized = true
end

--- Diese Funktion wird regelmäßig durch ModuleRegistry.runTasks() aufgerufen
-- @author Andreas Kreuz
function SchedulerLuaModule.run()
    if not SchedulerLuaModule.enabled then
        print("WARNING: PlannerLuaModul is not enabled")
        return
    end

    -- Hier folgen die wiederkehrenden Funktionen jedes Moduls (müssen dann nicht in EEPMain aufgerufen werden)
    Scheduler:runTasks()
end

return SchedulerLuaModule
