if AkDebugLoad then print("[#Start] Loading ce.hub.mods.SchedulerCeModule ...") end
SchedulerCeModule = {}
SchedulerCeModule.id = "725585f1-cfee-4237-97e1-135c5e9f4d02"
SchedulerCeModule.enabled = true
local initialized = false
-- Jedes Modul hat einen eindeutigen Namen
SchedulerCeModule.name = "ce.hub.mods.SchedulerCeModule"
local Scheduler = require("ce.hub.scheduler.Scheduler")

--- Diese Funktion wird einmalig durch ControlExtensionHub.initTasks() aufgerufen
-- Ist ein Modul fuer EEPWeb vorhanden, dann solltes in dieser Funktion aufgerufen werden
-- @author Andreas Kreuz
function SchedulerCeModule.init()
    if not SchedulerCeModule.enabled or initialized then return end

    -- Aktuell gibt es fuer den Scheduler noch keinen eigenen BridgeConnector.

    initialized = true
end

--- Diese Funktion wird regelmaessig durch ControlExtensionHub.runTasks() aufgerufen
-- @author Andreas Kreuz
function SchedulerCeModule.run()
    if not SchedulerCeModule.enabled then
        print("[#SchedulerCeModule] WARNING: SchedulerCeModule is not enabled")
        return
    end

    -- Hier folgen die wiederkehrenden Funktionen jedes Moduls (muessen dann nicht in EEPMain aufgerufen werden)
    Scheduler:runTasks()
end

return SchedulerCeModule