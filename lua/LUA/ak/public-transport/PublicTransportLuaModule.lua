if AkDebugLoad then print("[#Start] Loading ak.public-transport.PublicTransportLuaModule ...") end
---@class PublicTransportLuaModule
PublicTransportLuaModule = {}
PublicTransportLuaModule.id = "83ce6b42-1bda-45e0-8b4a-e8daeed047ab"
PublicTransportLuaModule.enabled = true
local initialized = false
-- Jedes Modul hat einen eindeutigen Namen
PublicTransportLuaModule.name = "ak.public-transport.PublicTransportLuaModule"

--- Diese Funktion wird einmalig durch ModuleRegistry.initTasks() aufgerufen
-- Ist ein Modul für EEPWeb vorhanden, dann solltes in dieser Funktion aufgerufen werden
-- @author Andreas Kreuz
function PublicTransportLuaModule.init()
    if not PublicTransportLuaModule.enabled or initialized then return end

    -- Hier wird der CoreWebConnector registriert, so dass die Kommunikation mit der WebApp funktioniert
    local PublicTransportWebConnector = require("ak.public-transport.PublicTransportWebConnector")
    PublicTransportWebConnector.registerStatePublishers()
    PublicTransportWebConnector.registerFunctions()

    initialized = true
end

--- Diese Funktion wird regelmäßig durch ModuleRegistry.runTasks() aufgerufen
-- @author Andreas Kreuz
function PublicTransportLuaModule.run()
    if not PublicTransportLuaModule.enabled then return end

    -- Hier folgen die wiederkehrenden Funktionen jedes Moduls (müssen dann nicht in EEPMain aufgerufen werden)
end

do
    -- Das CrossingLuaModule benötigt das SchedulerLuaModule
    -- Dies wird beim Einlesen dieser Datei automatisch registriert
    local ModuleRegistry = require("ak.core.ModuleRegistry")
    local schedulerLuaModule = require("ak.scheduler.SchedulerLuaModule")
    ModuleRegistry.registerModules(schedulerLuaModule)
end

return PublicTransportLuaModule
