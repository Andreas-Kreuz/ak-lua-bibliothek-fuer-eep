insulate("MainLoopRunner", function()
    require("ce.hub.eep.EepSimulator")

    local function clearModule(name) package.loaded[name] = nil end

    local function resetCoreModules()
        clearModule("ce.ControlExtension")
        clearModule("ce.hub.ControlExtensionHub")
        clearModule("ce.hub.ModuleRegistry")
        clearModule("ce.hub.MainLoopRunner")
        clearModule("ce.hub.StatePublisherRegistry")
        clearModule("ce.hub.mods.HubCeModule")
        clearModule("ce.hub.bridge.HubBridgeConnector")
        clearModule("ce.hub.data.modules.ModulesStatePublisher")
        clearModule("ce.hub.data.version.VersionStatePublisher")
        clearModule("ce.hub.data.modules.ModuleDtoFactory")
        clearModule("ce.hub.data.version.VersionDtoFactory")
        clearModule("ce.hub.data.modules.ModulesDataCollector")
        clearModule("ce.hub.data.version.VersionDataCollector")
        clearModule("ce.hub.data.version.VersionInfo")
        clearModule("ce.hub.data.runtime.RuntimeDataCollector")
        clearModule("ce.hub.data.runtime.RuntimeMetrics")
        clearModule("ce.hub.data.runtime.RuntimeDtoFactory")
        clearModule("ce.hub.data.runtime.RuntimeStatePublisher")
        clearModule("ce.databridge.ServerExchangeCoordinator")
        clearModule("ce.databridge.ServerExchangeFileIo")
        clearModule("ce.databridge.IncomingCommandFileReader")
        clearModule("ce.databridge.LogOutputFileWriter")
        clearModule("ce.databridge.IoInit")
        clearModule("ce.databridge.ExchangeDirRegistry")
        clearModule("ce.databridge.IncomingCommandExecutor")
        clearModule("ce.databridge.ServerEventBuffer")
        clearModule("ce.databridge.DataStoreFileWriter")
        clearModule("ce.hub.publish.DataChangeBus")
        clearModule("ce.hub.util.RuntimeRegistry")
    end

    before_each(function()
        resetCoreModules()
        require("ce.hub.eep.EepSimulator")
        local IoInit = require("ce.databridge.IoInit")
        IoInit.initialize = function() end
    end)

    it("runs modules, state publishers and io on every ControlExtension cycle", function()
        local DataChangeBus = require("ce.hub.publish.DataChangeBus")
        local ControlExtension = require("ce.ControlExtension")
        local ModuleRegistry = require("ce.hub.ModuleRegistry")
        local StatePublisherRegistry = require("ce.hub.StatePublisherRegistry")
        local ServerExchangeCoordinator = require("ce.databridge.ServerExchangeCoordinator")
        local IncomingCommandFileReader = require("ce.databridge.IncomingCommandFileReader")
        local DataStoreFileWriter = require("ce.databridge.DataStoreFileWriter")
        local RuntimeMetrics = require("ce.hub.data.runtime.RuntimeMetrics")
        local communicateCalls = 0
        local commandReadCalls = 0
        local dataStoreWriteCalls = 0
        local moduleInitCalls = 0
        local moduleRunCalls = 0
        local publisherInitCalls = 0
        local publisherSyncCalls = 0
        local capturedRuntimePublishes = {}

        local testModule = {
            id = "spec-test-module-1",
            name = "spec.TestCeModule",
            enabled = true,
            init = function() moduleInitCalls = moduleInitCalls + 1 end,
            run = function() moduleRunCalls = moduleRunCalls + 1 end
        }
        local testStatePublisher = {
            name = "spec.TestStatePublisher",
            initialize = function() publisherInitCalls = publisherInitCalls + 1 end,
            syncState = function()
                publisherSyncCalls = publisherSyncCalls + 1
                return {}
            end
        }

        DataChangeBus.fireListChange = function(room, keyId, list)
            if room ~= "runtime" then return end
            table.insert(capturedRuntimePublishes, {
                keyId = keyId,
                overallCount = list["MainLoopRunner.runCycle-OVERALL"] and
                list["MainLoopRunner.runCycle-OVERALL"].count or 0,
                syncStateCount = list["MainLoopRunner.runCycle-4-syncState"] and
                list["MainLoopRunner.runCycle-4-syncState"].count or 0,
                serverOutputCount = list["MainLoopRunner.runCycle-7-serverOutput"] and
                list["MainLoopRunner.runCycle-7-serverOutput"].count or 0,
                initModuleCount = list["CeModule.spec.TestCeModule.init"] and
                list["CeModule.spec.TestCeModule.init"].count or 0
            })
        end
        DataChangeBus.printEventCounter = function() end

        IncomingCommandFileReader.readAndExecuteIncomingCommands = function()
            commandReadCalls = commandReadCalls + 1
        end
        ServerExchangeCoordinator.isServerReady = function() return true end
        ServerExchangeCoordinator.runServerOutputCycle = function()
            communicateCalls = communicateCalls + 1
            return {encodeTime = 0.003, writeTime = 0.004, totalTime = 0.01}
        end
        DataStoreFileWriter.write = function() dataStoreWriteCalls = dataStoreWriteCalls + 1 end

        ModuleRegistry.registerModules(testModule)
        StatePublisherRegistry.registerStatePublishers(testStatePublisher)

        ControlExtension.runTasks(0)
        ControlExtension.runTasks(0)
        ControlExtension.runTasks(0)

        assert.equals(1, moduleInitCalls)
        assert.equals(3, moduleRunCalls)
        assert.equals(1, publisherInitCalls)
        assert.equals(3, publisherSyncCalls)
        assert.equals(3, commandReadCalls)
        assert.equals(3, communicateCalls)
        assert.equals(0, dataStoreWriteCalls)
        assert.equals(2, #capturedRuntimePublishes)
        assert.equals("id", capturedRuntimePublishes[1].keyId)
        assert.equals(1, capturedRuntimePublishes[1].overallCount)
        assert.equals(1, capturedRuntimePublishes[1].syncStateCount)
        assert.equals(1, capturedRuntimePublishes[2].overallCount)
        assert.equals(1, capturedRuntimePublishes[2].syncStateCount)
        assert.equals(1, capturedRuntimePublishes[2].serverOutputCount)
        assert.equals(1, capturedRuntimePublishes[2].initModuleCount)
        assert.is_true(RuntimeMetrics.get("StatePublisher.spec.TestStatePublisher.syncState").count == 0)
        assert.equals(0, RuntimeMetrics.get("StatePublisher.spec.TestStatePublisher.syncState").lastTime)
        assert.is_true(RuntimeMetrics.get("CeModule.spec.TestCeModule.init").count > 0)
        assert.is_true(RuntimeMetrics.get("CeModule.spec.TestCeModule.init").lastTime >= 0)
    end)

    it("skips server output while server is deactivated but still reads commands", function()
        local ControlExtension = require("ce.ControlExtension")
        local ModuleRegistry = require("ce.hub.ModuleRegistry")
        local StatePublisherRegistry = require("ce.hub.StatePublisherRegistry")
        local ServerExchangeCoordinator = require("ce.databridge.ServerExchangeCoordinator")
        local IncomingCommandFileReader = require("ce.databridge.IncomingCommandFileReader")
        local RuntimeMetrics = require("ce.hub.data.runtime.RuntimeMetrics")
        local communicateCalls = 0
        local commandReadCalls = 0
        local publisherSyncCalls = 0

        local testModule = {
            id = "spec-test-module-2",
            name = "spec.DisabledServerModule",
            enabled = true,
            init = function() end,
            run = function() end
        }
        local testStatePublisher = {
            name = "spec.DisabledServerPublisher",
            initialize = function() end,
            syncState = function()
                publisherSyncCalls = publisherSyncCalls + 1
                return {}
            end
        }

        IncomingCommandFileReader.readAndExecuteIncomingCommands = function()
            commandReadCalls = commandReadCalls + 1
        end
        ServerExchangeCoordinator.runServerOutputCycle = function()
            communicateCalls = communicateCalls + 1
            return {encodeTime = 0.003, writeTime = 0.004, totalTime = 0.01}
        end

        ModuleRegistry.registerModules(testModule)
        StatePublisherRegistry.registerStatePublishers(testStatePublisher)
        ControlExtension.deactivateServer()

        ControlExtension.runTasks(3)

        assert.equals(1, publisherSyncCalls)
        assert.equals(1, commandReadCalls)
        assert.equals(0, communicateCalls)
        assert.equals(0, RuntimeMetrics.get("MainLoopRunner.runCycle-7-serverOutput").time)
        assert.equals(0, RuntimeMetrics.get("MainLoopRunner.runCycle-8-dataStoreWrite").time)
        assert.equals(0, RuntimeMetrics.get("MainLoopRunner.runCycle-7-serverOutput").lastTime)
        assert.equals(0, RuntimeMetrics.get("MainLoopRunner.runCycle-8-dataStoreWrite").lastTime)
    end)

    it("writes the DataStore json only on publish cycles when enabled", function()
        local DataChangeBus = require("ce.hub.publish.DataChangeBus")
        local MainLoopRunner = require("ce.hub.MainLoopRunner")
        local IncomingCommandFileReader = require("ce.databridge.IncomingCommandFileReader")
        local ServerExchangeCoordinator = require("ce.databridge.ServerExchangeCoordinator")
        local DataStoreFileWriter = require("ce.databridge.DataStoreFileWriter")
        local dataStoreWriteCalls = 0
        local commandReadCalls = 0
        local communicateCalls = 0

        DataChangeBus.fireListChange = function() end
        DataChangeBus.printEventCounter = function() end

        IncomingCommandFileReader.readAndExecuteIncomingCommands = function()
            commandReadCalls = commandReadCalls + 1
        end
        ServerExchangeCoordinator.runServerOutputCycle = function()
            communicateCalls = communicateCalls + 1
            return {encodeTime = 0.003, writeTime = 0.004, totalTime = 0.01}
        end
        DataStoreFileWriter.write = function() dataStoreWriteCalls = dataStoreWriteCalls + 1 end

        MainLoopRunner.runCycle(5, {}, {}, {enableServer = false, enableDataStoreJson = true})
        MainLoopRunner.runCycle(5, {}, {}, {enableServer = false, enableDataStoreJson = true})

        assert.equals(2, commandReadCalls)
        assert.equals(0, communicateCalls)
        assert.equals(1, dataStoreWriteCalls)
    end)

    it("prints all collected runCycle timings in debug output", function()
        local DataChangeBus = require("ce.hub.publish.DataChangeBus")
        local MainLoopRunner = require("ce.hub.MainLoopRunner")
        local IncomingCommandFileReader = require("ce.databridge.IncomingCommandFileReader")
        local DataStoreFileWriter = require("ce.databridge.DataStoreFileWriter")
        local printedMessages = {}
        local originalPrint = print

        DataChangeBus.fireListChange = function() end
        DataChangeBus.printEventCounter = function() end
        IncomingCommandFileReader.readAndExecuteIncomingCommands = function() end
        DataStoreFileWriter.write = function() end

        _G.print = function(message)
            table.insert(printedMessages, tostring(message))
        end

        local ok, err = pcall(function()
            MainLoopRunner.runCycle(5, {}, {}, {debug = true, enableServer = false, enableDataStoreJson = true})
        end)

        _G.print = originalPrint
        if not ok then error(err) end

        local runCycleLog
        for _, message in ipairs(printedMessages) do
            if string.find(message, "[#MainLoopRunner] runCycle(5) time:", 1, true) then
                runCycleLog = message
                break
            end
        end

        assert.is_not_nil(runCycleLog)
        assert.is_truthy(string.find(runCycleLog, "1%-initModules:") ~= nil)
        assert.is_truthy(string.find(runCycleLog, "5%-commands:") ~= nil)
        assert.is_truthy(string.find(runCycleLog, "6%-waitForServer:") ~= nil)
        assert.is_truthy(string.find(runCycleLog, "8%-dataStoreWrite:") ~= nil)
    end)

    it("pauses EEP around first initialization when enabled", function()
        local ControlExtension = require("ce.ControlExtension")
        local ModuleRegistry = require("ce.hub.ModuleRegistry")
        local MainLoopRunner = require("ce.hub.MainLoopRunner")
        local pauseCalls = {}

        local testModule = {
            id = "spec-test-module-3",
            name = "spec.PauseModule",
            enabled = true,
            init = function() end,
            run = function() end
        }

        ModuleRegistry.registerModules(testModule)
        ControlExtension.setPauseEepDuringInitialization(true)
        MainLoopRunner.runCycle = function()
            assert.equals(1, #pauseCalls)
            assert.equals(1, pauseCalls[1])
            return 0
        end
        _G.EEPPause = function(value)
            table.insert(pauseCalls, value)
        end

        ControlExtension.runTasks(5)

        assert.same({ 1, 0 }, pauseCalls)
    end)
end)
