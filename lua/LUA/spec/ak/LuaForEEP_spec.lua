insulate("LuaForEEP", function ()
    local function clearModule(name)
        package.loaded[name] = nil
    end

    before_each(function ()
        clearModule("ak.LuaForEEP")
        clearModule("ak.core.ModuleRegistry")
        clearModule("ak.core.MainLoopRunner")
        clearModule("ak.core.CoreLuaModule")
        clearModule("ak.core.eep.EepSimulator")
        clearModule("ak.io.IncomingServerCommandExecutor")
        require("ak.core.eep.EepSimulator")
    end)

    it("delegates the reduced public api to ModuleRegistry", function ()
        local ModuleRegistry = require("ak.core.ModuleRegistry")
        local LuaForEEP = require("ak.LuaForEEP")
        local calls = {}
        local oldRegisterModules = ModuleRegistry.registerModules
        local oldRunTasks = ModuleRegistry.runTasks
        local oldDeactivateServer = ModuleRegistry.deactivateServer

        ModuleRegistry.registerModules = function (...)
            calls.registerModules = { ... }
            return "registered"
        end
        ModuleRegistry.runTasks = function (cycleCount)
            calls.runTasks = cycleCount
            return "ran"
        end
        ModuleRegistry.deactivateServer = function ()
            calls.deactivateServer = true
            return "deactivated"
        end

        local firstModule = { name = "spec.FirstModule" }
        local secondModule = { name = "spec.SecondModule" }

        assert.equals("registered", LuaForEEP.useModules(firstModule, secondModule))
        assert.same({ firstModule, secondModule }, calls.registerModules)
        assert.equals("ran", LuaForEEP.run(7))
        assert.equals(7, calls.runTasks)
        assert.equals("deactivated", LuaForEEP.disableServer())
        assert.is_true(calls.deactivateServer)
        assert.is_nil(LuaForEEP.addModules)
        assert.is_nil(LuaForEEP.registerModules)
        assert.is_nil(LuaForEEP.removeModules)
        assert.is_nil(LuaForEEP.unregisterModules)
        assert.is_nil(LuaForEEP.getModuleNames)
        assert.is_nil(LuaForEEP.init)
        assert.is_nil(LuaForEEP.activateServer)
        assert.is_nil(LuaForEEP.deactivateServer)
        assert.is_nil(LuaForEEP.useDlls)
        assert.is_nil(LuaForEEP.debug)
        assert.is_nil(LuaForEEP.pauseEepDuringInitialization)

        ModuleRegistry.registerModules = oldRegisterModules
        ModuleRegistry.runTasks = oldRunTasks
        ModuleRegistry.deactivateServer = oldDeactivateServer
    end)
end)
