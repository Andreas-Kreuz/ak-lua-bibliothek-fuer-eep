if AkDebugLoad then print("[#Start] Loading ce.mods.transit.TransitCeModule ...") end
---@class TransitCeModule
TransitCeModule = {}
TransitCeModule.id = "83ce6b42-1bda-45e0-8b4a-e8daeed047ab"
TransitCeModule.enabled = true
local initialized = false
TransitCeModule.name = "ce.mods.transit.TransitCeModule"
local TransitSettings = require("ce.mods.transit.TransitSettings")

function TransitCeModule.loadSettingsFromSlot(eepSaveId) return TransitSettings.loadSettingsFromSlot(eepSaveId) end

function TransitCeModule.init()
    if not TransitCeModule.enabled or initialized then return end

    local TransitBridgeConnector = require("ce.mods.transit.bridge.TransitBridgeConnector")
    TransitBridgeConnector.registerStatePublishers()
    TransitBridgeConnector.registerFunctions()

    initialized = true
end

function TransitCeModule.run()
    if not TransitCeModule.enabled then return end
end

return TransitCeModule
