if AkDebugLoad then print("[#Start] Loading ak.scheduler.SchedulerLuaModule ...") end
SchedulerLuaModule = {}
SchedulerLuaModule.id = "725585f1-cfee-4237-97e1-135c5e9f4d02"
SchedulerLuaModule.enabled = true
local initialized = false
-- Jedes Modul hat einen eindeutigen Namen
SchedulerLuaModule.name = "ak.scheduler.SchedulerLuaModule"
local Scheduler = require("ak.scheduler.Scheduler")

--- Diese Funktion wird einmalig durch ModuleRegistry.initTasks() aufgerufen
-- Ist ein Modul fuer EEPWeb vorhanden, dann solltes in dieser Funktion aufgerufen werden
-- @author Andreas Kreuz
function SchedulerLuaModule.init()
    if not SchedulerLuaModule.enabled or initialized then return end

    -- Aktuell gibt es fuer den Scheduler noch keinen eigenen WebConnector.

    initialized = true
end

--- Diese Funktion wird regelmaessig durch ModuleRegistry.runTasks() aufgerufen
-- @author Andreas Kreuz
function SchedulerLuaModule.run()
    if not SchedulerLuaModule.enabled then
        print("[#SchedulerLuaModule] WARNING: SchedulerLuaModule is not enabled")
        return
    end

    -- Hier folgen die wiederkehrenden Funktionen jedes Moduls (muessen dann nicht in EEPMain aufgerufen werden)
    Scheduler:runTasks()
end

return SchedulerLuaModule