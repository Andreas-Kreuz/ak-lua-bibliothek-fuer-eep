if AkDebugLoad then print("[#Start] Loading ce.mods.public-transport.PublicTransportCeModule ...") end
---@class PublicTransportCeModule
PublicTransportCeModule = {}
PublicTransportCeModule.id = "83ce6b42-1bda-45e0-8b4a-e8daeed047ab"
PublicTransportCeModule.enabled = true
local initialized = false
PublicTransportCeModule.name = "ce.mods.public-transport.PublicTransportCeModule"

function PublicTransportCeModule.init()
    if not PublicTransportCeModule.enabled or initialized then return end

    local PublicTransportBridgeConnector = require("ce.mods.public-transport.bridge.PublicTransportBridgeConnector")
    PublicTransportBridgeConnector.registerStatePublishers()
    PublicTransportBridgeConnector.registerFunctions()

    initialized = true
end

function PublicTransportCeModule.run()
    if not PublicTransportCeModule.enabled then return end
end

do
    local ModuleRegistry = require("ce.hub.ModuleRegistry")
    local schedulerCeModule = require("ce.hub.mods.SchedulerCeModule")
    ModuleRegistry.registerModules(schedulerCeModule)
end

return PublicTransportCeModule
