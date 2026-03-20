if AkDebugLoad then print("[#Start] Loading ce.hub.ControlExtensionHub ...") end

require("ce.databridge.IoInit").initialize()

local MainLoopRunner = require("ce.hub.MainLoopRunner")
local ModuleRegistry = require("ce.hub.ModuleRegistry")

local ControlExtensionHub = {}
ControlExtensionHub.debug = AkStartWithDebug or false
ControlExtensionHub.pauseEepDuringInitialization = false

local enableServer = true

-- ACHTUNG: DIE VERWENDUNG ERFOLGT AUF EIGENE GEFAHR. ES IST GUT MOEGLICH,
--          DASS EEP ABSTUERZT, WENN NICHT ALLE ABHAENGIGKEITEN DER BIBLIOTHEK
--          GEFUNDEN WERDEN.
function ControlExtensionHub.setDebug(debug)
    assert(debug == true or debug == false)
    ControlExtensionHub.debug = debug
    return debug
end

function ControlExtensionHub.setPauseEepDuringInitialization(pauseEepDuringInitialization)
    assert(pauseEepDuringInitialization == true or pauseEepDuringInitialization == false)
    ControlExtensionHub.pauseEepDuringInitialization = pauseEepDuringInitialization
    return pauseEepDuringInitialization
end

function ControlExtensionHub.initTasks()
    MainLoopRunner.debug = ControlExtensionHub.debug
    MainLoopRunner.initModules(ModuleRegistry.getModuleNames(), ModuleRegistry.getRegisteredCeModules())
end

function ControlExtensionHub.runTasks(cycleCount)
    local effectiveCycleCount = type(cycleCount) == "number" and cycleCount or 5
    local resumeEEP
    if not MainLoopRunner.areModulesInitialized() and ControlExtensionHub.pauseEepDuringInitialization then
        if ControlExtensionHub.debug then print("[ControlExtensionHub] Pause EEP during initialization") end
        EEPPause(1)
        resumeEEP = true
    end

    local totalTime = MainLoopRunner.runCycle(effectiveCycleCount, ModuleRegistry.getModuleNames(),
                                              ModuleRegistry.getRegisteredCeModules(),
                                              { debug = ControlExtensionHub.debug, enableServer = enableServer })

    if resumeEEP then
        if ControlExtensionHub.debug then
            print(string.format("[ControlExtensionHub] Resume EEP after initialization %3.0f ms", totalTime * 1000))
        end
        EEPPause(0)
    end

    return totalTime
end

function ControlExtensionHub.activateServer() enableServer = true end

function ControlExtensionHub.deactivateServer() enableServer = false end

return ControlExtensionHub
