if AkDebugLoad then print("[#Start] Loading ce.hub.mods.HubCeModule ...") end

---@class HubCeModule: CeModule
HubCeModule = {}
HubCeModule.id = "b9f34a2e-1c5d-4f8a-9e7b-3d0a6c8f2e41"
HubCeModule.enabled = true
local initialized = false
HubCeModule.name = "ce.hub.mods.HubCeModule"
local Scheduler = require("ce.hub.scheduler.Scheduler")
local HubBridgeConnector = require("ce.hub.bridge.HubBridgeConnector")

--- Diese Funktion wird einmalig durch ControlExtensionHub.initTasks() aufgerufen
-- @author Andreas Kreuz
function HubCeModule.init()
    if not HubCeModule.enabled or initialized then return end
    HubBridgeConnector.registerStatePublishers()
    initialized = true
end

--- Diese Funktion wird regelmaessig durch ControlExtensionHub.runTasks() aufgerufen
-- @author Andreas Kreuz
function HubCeModule.run()
    if not HubCeModule.enabled then return end
    Scheduler:runTasks()
end

--- Ueber diese Funktion kann das EEP Skript die Optionen des Moduls setzen
-- @options List of options { waitForServer = true/false, activeCollectors = array of publisher names }
function HubCeModule.setOptions(options)
    if options.waitForServer ~= nil then
        local ServerExchangeCoordinator = require("ce.databridge.ServerExchangeCoordinator")
        ServerExchangeCoordinator.checkServerStatus = options.waitForServer
    end
    if options.activeCollectors then
        HubBridgeConnector.setActiveCollectors(options.activeCollectors)
    end
end

return HubCeModule
