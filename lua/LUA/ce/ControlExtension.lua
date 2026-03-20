if AkDebugLoad then print("[#Start] Loading ce.ControlExtension ...") end

local ControlExtensionHub = require("ce.hub.ControlExtensionHub")
local ModuleRegistry = require("ce.hub.ModuleRegistry")

local ControlExtension = {}

function ControlExtension.addModules(...)
    return ModuleRegistry.registerModules(...)
end

function ControlExtension.initTasks()
    return ControlExtensionHub.initTasks()
end

function ControlExtension.runTasks(cycleCount)
    return ControlExtensionHub.runTasks(cycleCount)
end

function ControlExtension.activateServer()
    return ControlExtensionHub.activateServer()
end

function ControlExtension.deactivateServer()
    return ControlExtensionHub.deactivateServer()
end

function ControlExtension.setDebug(debug)
    return ControlExtensionHub.setDebug(debug)
end

function ControlExtension.setPauseEepDuringInitialization(pauseEepDuringInitialization)
    return ControlExtensionHub.setPauseEepDuringInitialization(pauseEepDuringInitialization)
end

return ControlExtension
