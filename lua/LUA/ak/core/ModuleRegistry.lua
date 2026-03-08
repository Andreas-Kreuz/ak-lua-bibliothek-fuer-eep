if AkDebugLoad then print("[#Start] Loading ak.core.ModuleRegistry ...") end
local MainLoopRunner = require("ak.core.MainLoopRunner")
local TableUtils = require("ak.util.TableUtils")

local ModuleRegistry = {}
ModuleRegistry.debug = AkStartWithDebug or false
ModuleRegistry.pauseEepDuringInitialization = false -- Option to pause EEP during initialization
local enableServer = true
---@type table<string,LuaModule>
local registeredLuaModules = {}
---@type string[]
local executionOrderModuleNames = {}

local function updateModuleOrder()
    TableUtils.clearArray(executionOrderModuleNames)
    for moduleName in pairs(registeredLuaModules) do table.insert(executionOrderModuleNames, moduleName) end
    table.sort(executionOrderModuleNames, function (n1, n2)
        if n1 == "ak.scheduler.SchedulerLuaModule" then return true end
        if n2 == "ak.scheduler.SchedulerLuaModule" then return false end
        return n1 < n2
    end)
end

function ModuleRegistry.getModuleNames()
    local copy = {}
    for i, v in ipairs(executionOrderModuleNames) do copy[i] = v end
    return copy
end

---
-- Registers a module to be used in EEP Web
-- @param module a module of type AkLuaControlModule
function ModuleRegistry.registerModules(...)
    assert(not MainLoopRunner.areModulesInitialized(), "All tasks must be registered before ModuleRegistry.initTasks()")

    for _, module in ipairs({ ... }) do
        -- Check the module
        assert(module.name and type(module.name) == "string", "A module must have a string name")
        assert(type(module.enabled) == "boolean", string.format("Module %s must have a boolean enabled", module.name))
        assert(module.init and type(module.init) == "function",
               string.format("Module %s must have a function init()", module.name))
        assert(module.run and type(module.run) == "function",
               string.format("Module %s must have a function run()", module.name))

        -- Remember the module by it's name
        registeredLuaModules[module.name] = module
    end

    updateModuleOrder()

    -- pass the modules to the caller in the EEP script
    return registeredLuaModules
end

---
-- Unregisters a module
-- @param module a module of type AkLuaControlModule
function ModuleRegistry.unregisterModules(...)
    for _, module in ipairs({ ... }) do
        -- Check the module
        assert(module.name and type(module.name) == "string", "A module must have a string name")

        -- Remove the module by it's name
        registeredLuaModules[module.name] = nil
    end
    updateModuleOrder()
end

-- ACHTUNG: DIE VERWENDUNG ERFOLGT AUF EIGENE GEFAHR. ES IST GUT MOEGLICH,
--          DASS EEP ABSTUERZT, WENN NICHT ALLE ABHAENGIGKEITEN DER BIBLIOTHEK
--          GEFUNDEN WERDEN.
function ModuleRegistry.useDlls(enableDlls)
    assert(enableDlls == true or enableDlls == false)
    -- NO OP
end

---
-- This will init all registeredLuaModules
function ModuleRegistry.initTasks()
    MainLoopRunner.debug = ModuleRegistry.debug
    MainLoopRunner.initModules(executionOrderModuleNames, registeredLuaModules)
end

---
-- This will run all registeredLuaModules
-- @param cycleCount Repetion frequency (1: every 200 ms, 5: every second, ...)
function ModuleRegistry.runTasks(cycleCount)
    local effectiveCycleCount = type(cycleCount) == "number" and cycleCount or 5
    local resumeEEP
    if not MainLoopRunner.areModulesInitialized() then
        -- Process option to suspend EEP during initialization
        if ModuleRegistry.pauseEepDuringInitialization then
            if ModuleRegistry.debug then print("[ModuleRegistry] Pause EEP during initialization") end
            EEPPause(1)
            resumeEEP = true
        end
    end

    local totalTime = MainLoopRunner.runCycle(effectiveCycleCount, executionOrderModuleNames, registeredLuaModules, {
        debug = ModuleRegistry.debug,
        enableServer = enableServer
    })

    -- resume EEP after initialization
    if resumeEEP then
        if ModuleRegistry.debug then
            print(string.format("[ModuleRegistry] Resume EEP after initialization %3.0f ms", totalTime * 1000))
        end
        EEPPause(0)
    end
end

function ModuleRegistry.activateServer() enableServer = true end

function ModuleRegistry.deactivateServer() enableServer = false end

-- Register the core module to hold basic data
do
    local CoreLuaModule = require("ak.core.CoreLuaModule")
    CoreLuaModule.setRegisteredLuaModules(registeredLuaModules)
    ModuleRegistry.registerModules(CoreLuaModule)
end

return ModuleRegistry
