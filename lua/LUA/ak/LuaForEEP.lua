if AkDebugLoad then print("[#Start] Loading ak.LuaForEEP ...") end

local ModuleRegistry = require("ak.core.ModuleRegistry")

local LuaForEEP = {}

function LuaForEEP.useModules(...)
    return ModuleRegistry.registerModules(...)
end

function LuaForEEP.run(cycleCount)
    return ModuleRegistry.runTasks(cycleCount)
end

function LuaForEEP.disableServer()
    return ModuleRegistry.deactivateServer()
end

return LuaForEEP
