if AkDebugLoad then print("[#Start] Loading ak.public-transport.PublicTransportLuaModul ...") end
---@class PublicTransportLuaModul
local PublicTransportLuaModul = {}
PublicTransportLuaModul.id = "83ce6b42-1bda-45e0-8b4a-e8daeed047ab"
PublicTransportLuaModul.enabled = true
local initialized = false
-- Jedes Modul hat einen eindeutigen Namen
PublicTransportLuaModul.name = "ak.public-transport.PublicTransportLuaModul"

--- Diese Funktion wird einmalig durch ModuleRegistry.initTasks() aufgerufen
-- Ist ein Modul für EEPWeb vorhanden, dann solltes in dieser Funktion aufgerufen werden
-- @author Andreas Kreuz
function PublicTransportLuaModul.init()
    if not PublicTransportLuaModul.enabled or initialized then return end

    -- Hier wird der CoreWebConnector registriert, so dass die Kommunikation mit der WebApp funktioniert
    local PublicTransportWebConnector = require("ak.public-transport.PublicTransportWebConnector")
    PublicTransportWebConnector.registerJsonCollectors()
    PublicTransportWebConnector.registerFunctions()

    initialized = true
end

--- Diese Funktion wird regelmäßig durch ModuleRegistry.runTasks() aufgerufen
-- @author Andreas Kreuz
function PublicTransportLuaModul.run()
    if not PublicTransportLuaModul.enabled then return end

    -- Hier folgen die wiederkehrenden Funktionen jedes Moduls (müssen dann nicht in EEPMain aufgerufen werden)
end

do
    -- Das CrossingLuaModul benötigt das SchedulerLuaModule
    -- Dies wird beim Einlesen dieser Datei automatisch registriert
    local ModuleRegistry = require("ak.core.ModuleRegistry")
    ModuleRegistry.registerModules(require("ak.scheduler.SchedulerLuaModule"))
end

return PublicTransportLuaModul
