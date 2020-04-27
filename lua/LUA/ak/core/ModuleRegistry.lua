print("Load ak.core.ModuleRegistry ...")
local ModuleRegistry = {}

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
        assert(
            module.init and type(module.init) == "function",
            string.format("Module %s must have a function init()", module.name)
        )
        assert(
            module.run and type(module.run) == "function",
            string.format("Module %s must have a function run()", module.name)
        )

        -- Remember the module by it's name
        registeredLuaModules[module.name] = module
    end
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

local function initTask(module)
    --print(string.format('Begin ModuleRegistry.initTask() for "%s"', module.name))
    local t0 = os.clock()
    module.init()
    local t1 = os.clock()
    local timeDiff = t1 - t0
    print(string.format('ModuleRegistry.initTask() %.3f seconds for "%s"', timeDiff, module.name))
end

local function runTask(module)
    --print(string.format('Begin ModuleRegistry.runTask() for "%s"', module.name))
    local t0 = os.clock()
    module.run()
    local t1 = os.clock()
    local timeDiff = t1 - t0
    --print(string.format('ModuleRegistry.runTask() %.3f seconds for "%s"', timeDiff, module.name)) --###
    if timeDiff > 0.2 then
        print(string.format('WARNING: ModuleRegistry.runTask() %.3f seconds for "%s"', timeDiff, module.name))
    end
end

---
-- This will init all registeredLuaModules
function ModuleRegistry.initTasks()
    if not initialized then
        for _, module in pairs(registeredLuaModules) do
            initTask(module)
        end

        initialized = true
    end
end

---
-- This will run all registeredLuaModules
-- @param cycleCount Repetion frequency (1: every 200 ms, 5: every second, ...)
function ModuleRegistry.runTasks(cycleCount)
    if not initialized then
        ModuleRegistry.initTasks()
    end

    for _, module in pairs(registeredLuaModules) do
        runTask(module)
    end

    if enableServer then
        -- Sorgt daf�r, dass alle JsonDaten der registrieren XxxJsonColletor zum Server kommen
        -- und dass die Befehle des Servers ausgewertet werden
        ServerController.communicateWithServer(cycleCount)
    end
end

function ModuleRegistry.activateServer()
    enableServer = true
end

function ModuleRegistry.deactivateServer()
    enableServer = false
end

---
-- Set option of the ServerController 
-- @param flag true(default)/false to decide if Lua should check if the EEP Server is running and ready
function ModuleRegistry.setWaitForServer(flag) 
    ServerController.checkServerStatus = flag 
end

-- Register the core module to hold basic data
do
    local CoreLuaModule = require("ak.core.CoreLuaModule")
    CoreLuaModule.setRegisteredLuaModules(registeredLuaModules)
    ModuleRegistry.registerModules(CoreLuaModule)
end

return ModuleRegistry
