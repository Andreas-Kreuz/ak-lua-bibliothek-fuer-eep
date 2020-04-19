print("Lade ak.eep.ModuleRegistry ...")
local ModuleRegistry = {}

local AkStatistik = require("ak.io.AkStatistik")
local enableServer = true
local initialized = false
local registeredLuaModules = {}

---
-- Registers a module to be used in EEP Web
-- @param module a module of type AkLuaControlModule
function ModuleRegistry.registerModules(...)
    assert(not initialized, "All tasks must be registered before ModuleRegistry.initTasks()")

    for _, module in ipairs({...}) do
        -- Check the module
        assert(module.name and type(module.name) == "string", "A module must have a string name")
        assert(module.init and type(module.init) == "function", "A module must have a function init()")
        assert(module.run and type(module.run) == "function", "A module must have a function run()")

        -- Remember the module by it's name
        registeredLuaModules[module.name] = module
    end
end

---
-- Registers a module to be used in EEP Web
-- @param module a module of type AkLuaControlModule
function ModuleRegistry.unregisterModules(...)
    for _, module in ipairs({...}) do
        -- Check the module
        assert(module.name and type(module.name) == "string", "A module must have a string name")

        -- Remove the module by it's name
        registeredLuaModules[module.name] = nil
    end
end

local function initTask(module)
    local t0 = os.clock()
    module.init()
    local t1 = os.clock()
    local timeDiff = t1 - t0
    print(string.format('ModuleRegistry.initTasks() %.3f Sekunden fuer "%s"', timeDiff, module.name))
end

---
-- This will init all registeredLuaModules
-- @param module a module of type AkLuaControlModule
function ModuleRegistry.initTasks()
    if not initialized then
        for _, module in pairs(registeredLuaModules) do
            initTask(module)
        end

        initialized = true
    end
end

---
-- This will init all registeredLuaModules
-- @param module a module of type AkLuaControlModule
function ModuleRegistry.runTasks()
    if not initialized then
        ModuleRegistry.initTasks()
    end

    for _, module in pairs(registeredLuaModules) do
        module.run()
    end

    if enableServer then
        -- Sorgt dafür, dass alle JsonDaten der registrieren XxxJsonColletor zum Server kommen
        -- und dass die Befehle des Servers ausgewertet werden
        AkStatistik.statistikAusgabe(1)
    end
end

function ModuleRegistry.activateServer()
    enableServer = true
end

function ModuleRegistry.deactivateServer()
    enableServer = false
end

return ModuleRegistry
