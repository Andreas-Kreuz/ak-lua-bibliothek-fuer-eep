insulate("ControlExtension", function ()
    local function clearModule(name)
        package.loaded[name] = nil
    end

    before_each(function ()
        clearModule("ce.ControlExtension")
        clearModule("ce.hub.ControlExtensionHub")
        clearModule("ce.hub.ModuleRegistry")
        clearModule("ce.hub.MainLoopRunner")
        clearModule("ce.hub.mods.HubCeModule")
        clearModule("ce.hub.eep.EepSimulator")
        clearModule("ce.databridge.IncomingCommandExecutor")
        require("ce.hub.eep.EepSimulator")
    end)

    it("delegates registration to ModuleRegistry and runtime control to ControlExtensionHub", function ()
        local ControlExtensionHub = require("ce.hub.ControlExtensionHub")
        local ModuleRegistry = require("ce.hub.ModuleRegistry")
        local ControlExtension = require("ce.ControlExtension")
        local calls = {}
        local oldRegisterModules = ModuleRegistry.registerModules
        local oldInitTasks = ControlExtensionHub.initTasks
        local oldRunTasks = ControlExtensionHub.runTasks
        local oldSetDebug = ControlExtensionHub.setDebug
        local oldSetPause = ControlExtensionHub.setPauseEepDuringInitialization
        local oldActivateServer = ControlExtensionHub.activateServer
        local oldDeactivateServer = ControlExtensionHub.deactivateServer

        ModuleRegistry.registerModules = function (...)
            calls.registerModules = { ... }
            return "registered"
        end
        ControlExtensionHub.initTasks = function ()
            calls.initTasks = true
            return "initialized"
        end
        ControlExtensionHub.runTasks = function (cycleCount)
            calls.runTasks = cycleCount
            return "ran"
        end
        ControlExtensionHub.setDebug = function (debug)
            calls.setDebug = debug
            return debug
        end
        ControlExtensionHub.setPauseEepDuringInitialization = function (pauseEepDuringInitialization)
            calls.setPause = pauseEepDuringInitialization
            return pauseEepDuringInitialization
        end
        ControlExtensionHub.activateServer = function ()
            calls.activateServer = true
            return "activated"
        end
        ControlExtensionHub.deactivateServer = function ()
            calls.deactivateServer = true
            return "deactivated"
        end

        local firstModule = { name = "spec.FirstModule" }
        local secondModule = { name = "spec.SecondModule" }

        assert.equals("registered", ControlExtension.addModules(firstModule, secondModule))
        assert.same({ firstModule, secondModule }, calls.registerModules)
        assert.equals("initialized", ControlExtension.initTasks())
        assert.is_true(calls.initTasks)
        assert.equals("ran", ControlExtension.runTasks(7))
        assert.equals(7, calls.runTasks)
        assert.equals("activated", ControlExtension.activateServer())
        assert.is_true(calls.activateServer)
        assert.equals("deactivated", ControlExtension.deactivateServer())
        assert.is_true(calls.deactivateServer)

        assert.is_true(ControlExtension.setDebug(true))
        assert.is_true(calls.setDebug)
        assert.is_true(ControlExtension.setPauseEepDuringInitialization(true))
        assert.is_true(calls.setPause)

        assert.is_nil(ControlExtension.useModules)
        assert.is_nil(ControlExtension.run)
        assert.is_nil(ControlExtension.disableServer)
        assert.is_nil(ControlExtension.debug)
        assert.is_nil(ControlExtension.pauseEepDuringInitialization)
        assert.is_nil(ControlExtension.registerModules)
        assert.is_nil(ControlExtension.removeModules)
        assert.is_nil(ControlExtension.unregisterModules)
        assert.is_nil(ControlExtension.getModuleNames)
        assert.is_nil(ControlExtension.init)

        ModuleRegistry.registerModules = oldRegisterModules
        ControlExtensionHub.initTasks = oldInitTasks
        ControlExtensionHub.runTasks = oldRunTasks
        ControlExtensionHub.setDebug = oldSetDebug
        ControlExtensionHub.setPauseEepDuringInitialization = oldSetPause
        ControlExtensionHub.activateServer = oldActivateServer
        ControlExtensionHub.deactivateServer = oldDeactivateServer
    end)
end)
