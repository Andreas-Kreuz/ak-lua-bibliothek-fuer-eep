if AkDebugLoad then print("[#Start] Loading ce.hub.mods.CoreCeModule ...") end

---@class CoreCeModule: CeModule
CoreCeModule = {}
CoreCeModule.id = "8aeef2ab-8672-4f9a-a929-d62845f5f1fc"
CoreCeModule.enabled = true
local initialized = false
-- Jedes Modul hat einen eindeutigen Namen
CoreCeModule.name = "ce.hub.mods.CoreCeModule"
---@type table<string, CeModule>|nil
local registeredCeModules = nil

---@param modules table<string, CeModule>
function CoreCeModule.setRegisteredCeModules(modules) registeredCeModules = modules end

--- Diese Funktion wird einmalig durch ControlExtensionHub.initTasks() aufgerufen
-- Ist ein Modul für EEPWeb vorhanden, dann sollte es in dieser Funktion aufgerufen werden
-- @author Andreas Kreuz
function CoreCeModule.init()
    if not CoreCeModule.enabled or initialized then return end

    -- Hier wird der CoreBridgeConnector registriert, so dass die Kommunikation mit der WebApp funktioniert
    local CoreBridgeConnector = require("ce.hub.bridge.CoreBridgeConnector")
    assert(registeredCeModules)
    CoreBridgeConnector.setRegisteredCeModules(registeredCeModules)
    CoreBridgeConnector.registerStatePublishers();

    initialized = true
end

--- Diese Funktion wird regelmäßig durch ControlExtensionHub.runTasks() aufgerufen
-- @author Andreas Kreuz
function CoreCeModule.run()
    if not CoreCeModule.enabled then return end

    -- Hier folgen die wiederkehrenden Funktionen jedes Moduls (müssen dann nicht in EEPMain aufgerufen werden)
    -- Das CoreModul hat keine wiederkehrenden Funktionen
end

--- Über diese Funktion kann das EEP Skript die Optionen des Moduls setzen
-- @options List of options { waitForServer = true/false, }
local ServerExchangeCoordinator = require("ce.databridge.ServerExchangeCoordinator")
function CoreCeModule.setOptions(options)
    if options.waitForServer ~= nil then ServerExchangeCoordinator.checkServerStatus = options.waitForServer end
end

return CoreCeModule
