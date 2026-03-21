if AkDebugLoad then print("[#Start] Loading ce.hub.ModuleRegistry ...") end
local MainLoopRunner = require("ce.hub.MainLoopRunner")
local TableUtils = require("ce.hub.util.TableUtils")

local ModuleRegistry = {}
---@type table<string,CeModule>
local registeredCeModules = {}
---@type string[]
local executionOrderModuleNames = {}

local function updateModuleOrder()
    TableUtils.clearArray(executionOrderModuleNames)
    for moduleName in pairs(registeredCeModules) do table.insert(executionOrderModuleNames, moduleName) end
    -- keep the hub bootstrap order stable across namespace changes
    table.sort(executionOrderModuleNames, function(n1, n2)
        local priority = {
            ["ce.hub.mods.HubCeModule"] = 1,
        }
        local p1 = priority[n1] or 10
        local p2 = priority[n2] or 10
        if p1 ~= p2 then return p1 < p2 end
        return n1 < n2
    end)
end

function ModuleRegistry.getModuleNames()
    local copy = {}
    for i, v in ipairs(executionOrderModuleNames) do copy[i] = v end
    return copy
end

function ModuleRegistry.getRegisteredCeModules() return registeredCeModules end

---
-- Registers a module to be used in EEP Web
-- @param module a module of type AkLuaControlModule
function ModuleRegistry.registerModules(...)
    assert(not MainLoopRunner.areModulesInitialized(),
           "All tasks must be registered before initialization starts")

    for _, module in ipairs({...}) do
        -- Check the module
        assert(module.name and type(module.name) == "string", "A module must have a string name")
        assert(type(module.enabled) == "boolean", string.format("Module %s must have a boolean enabled", module.name))
        assert(module.init and type(module.init) == "function",
               string.format("Module %s must have a function init()", module.name))
        assert(module.run and type(module.run) == "function",
               string.format("Module %s must have a function run()", module.name))

        -- Remember the module by its name
        registeredCeModules[module.name] = module
    end

    updateModuleOrder()

    -- pass the modules to the caller in the EEP script
    return registeredCeModules
end

---
-- Unregisters a module
-- @param module a module of type AkLuaControlModule
function ModuleRegistry.unregisterModules(...)
    for _, module in ipairs({...}) do
        -- Check the module
        assert(module.name and type(module.name) == "string", "A module must have a string name")

        -- Remove the module by its name
        registeredCeModules[module.name] = nil
    end
    updateModuleOrder()
end

-- Register the hub module (bootstraps scheduler, core publishers, and data publishers)
ModuleRegistry.registerModules(require("ce.hub.mods.HubCeModule"))

return ModuleRegistry
