if AkDebugLoad then print("Loading ak.core.ModuleRegistry ...") end
local ModuleRegistry = {}

local os = require("os")
ModuleRegistry.debug = AkDebugLoad or false
local ServerController = require("ak.io.ServerController")
local enableServer = true
local initialized = false
-- @type name
local registeredLuaModules = {}

---
-- Registers a module to be used in EEP Web
-- @param module a module of type AkLuaControlModule
function ModuleRegistry.registerModules(...)
    assert(not initialized, "All tasks must be registered before ModuleRegistry.initTasks()")

    for _, module in ipairs({...}) do
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

    -- pass the modules to the caller in the EEP script
    return registeredLuaModules
end

---
-- Unregisters a module
-- @param module a module of type AkLuaControlModule
function ModuleRegistry.unregisterModules(...)
    for _, module in ipairs({...}) do
        -- Check the module
        assert(module.name and type(module.name) == "string", "A module must have a string name")

        -- Remove the module by it's name
        registeredLuaModules[module.name] = nil
    end
end

-- ACHTUNG: DIE VERWENDUNG ERFOLGT AUF EIGENE GEFAHR. ES IST GUT MÖGLICH,
--          DASS EEP ABSTÜRZT, WENN NICHT ALLE ABHÄNGIGKEITEN DER BIBLIOTHEK
--          GEFUNDEN WERDEN.
function ModuleRegistry.useDlls(enableDlls)
    assert(enableDlls == true or enableDlls == false)
    ServerController.useDlls(enableDlls)
end

local function initTask(module)
    if ModuleRegistry.debug then print(string.format('Begin ModuleRegistry.initTask() for "%s"', module.name)) end
    local t0 = os.clock()
    module.init()
    local t1 = os.clock()
    local timeDiff = t1 - t0
    if ModuleRegistry.debug then
        print(string.format('ModuleRegistry.initTask() %.3f seconds for "%s"', timeDiff, module.name))
    end
end

local function runTask(module)
    if ModuleRegistry.debug then print(string.format('Begin ModuleRegistry.runTask() for "%s"', module.name)) end
    local t0 = os.clock()
    module.run()
    local t1 = os.clock()
    local timeDiff = t1 - t0
    -- print(string.format('ModuleRegistry.runTask() %.3f seconds for "%s"', timeDiff, module.name)) --###
    if timeDiff > 0.005 then
        print(string.format('WARNING: ModuleRegistry.runTask() %.3f seconds for "%s"', timeDiff, module.name))
    end
end

---
-- This will init all registeredLuaModules
function ModuleRegistry.initTasks()
    if not initialized then
        for _, module in pairs(registeredLuaModules) do initTask(module) end

        initialized = true
    end
end

---
-- This will run all registeredLuaModules
-- @param cycleCount Repetion frequency (1: every 200 ms, 5: every second, ...)
function ModuleRegistry.runTasks(cycleCount)
    local t1 = os.clock()
    if not initialized then ModuleRegistry.initTasks() end

    local t2 = os.clock()
    for _, module in pairs(registeredLuaModules) do runTask(module) end

    local t3 = os.clock()
    if enableServer then
        -- Sorgt dafür, dass alle JsonDaten der registrieren XxxJsonColletor zum Server kommen
        -- und dass die Befehle des Servers ausgewertet werden
        ServerController.communicateWithServer(cycleCount)
    end
    local t4 = os.clock()

    if ModuleRegistry.debug then
        print(string.format(
                  "ModuleRegistry.runTasks(cycleCount) time: %.0f ms (%.0f ms init, %.0f ms runTask, %.0f ms serveData)",
                  (t4 - t1) * 1000, (t2 - t1) * 1000, (t3 - t2) * 1000, (t4 - t3) * 1000))
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
