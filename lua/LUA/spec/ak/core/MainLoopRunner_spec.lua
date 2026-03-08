insulate("MainLoopRunner", function ()
    require("ak.core.eep.EepSimulator")

    local function clearModule(name)
        package.loaded[name] = nil
    end

    local function resetCoreModules()
        clearModule("ak.core.ModuleRegistry")
        clearModule("ak.core.MainLoopRunner")
        clearModule("ak.core.StatePublisherRegistry")
        clearModule("ak.core.CoreLuaModule")
        clearModule("ak.core.CoreWebConnector")
        clearModule("ak.core.ModulesStatePublisher")
        clearModule("ak.core.VersionStatePublisher")
        clearModule("ak.core.VersionInfo")
        clearModule("ak.io.ServerBridge")
        clearModule("ak.io.AkWebServerIo")
        clearModule("ak.io.AkCommandExecutor")
        clearModule("ak.io.EventRecorder")
        clearModule("ak.events.DataChangeBus")
        clearModule("ak.util.RuntimeRegistry")
    end

    before_each(function ()
        resetCoreModules()
        require("ak.core.eep.EepSimulator")
    end)

    it("runs modules and state publishers on every ModuleRegistry cycle", function ()
        local DataChangeBus = require("ak.events.DataChangeBus")
        local ModuleRegistry = require("ak.core.ModuleRegistry")
        local StatePublisherRegistry = require("ak.core.StatePublisherRegistry")
        local ServerBridge = require("ak.io.ServerBridge")
        local RuntimeRegistry = require("ak.util.RuntimeRegistry")
        local communicateCalls = 0
        local moduleInitCalls = 0
        local moduleRunCalls = 0
        local publisherInitCalls = 0
        local publisherSyncCalls = 0
        local capturedRuntimePublishes = {}

        local testModule = {
            id = "spec-test-module-1",
            name = "spec.TestLuaModule",
            enabled = true,
            init = function () moduleInitCalls = moduleInitCalls + 1 end,
            run = function () moduleRunCalls = moduleRunCalls + 1 end
        }
        local testStatePublisher = {
            name = "spec.TestStatePublisher",
            initialize = function () publisherInitCalls = publisherInitCalls + 1 end,
            syncState = function ()
                publisherSyncCalls = publisherSyncCalls + 1
                return {}
            end
        }

        DataChangeBus.fireListChange = function (room, keyId, list)
            if room ~= "runtime" then return end
            table.insert(capturedRuntimePublishes, {
                keyId = keyId,
                overallCount = list["MainLoopRunner.runCycle-OVERALL"] and list["MainLoopRunner.runCycle-OVERALL"].count or 0,
                syncStateCount = list["MainLoopRunner.runCycle-4-syncState"] and
                    list["MainLoopRunner.runCycle-4-syncState"].count or 0,
                encodeCount = list["MainLoopRunner.runCycle-7-encode"] and
                    list["MainLoopRunner.runCycle-7-encode"].count or 0,
                initModuleCount = list["LuaModule.spec.TestLuaModule.init"] and
                    list["LuaModule.spec.TestLuaModule.init"].count or 0
            })
        end
        DataChangeBus.printEventCounter = function () end

        ServerBridge.exchangeWithServer = function (cycleCount)
            communicateCalls = communicateCalls + 1
            assert.equals(5, cycleCount)
            return {
                waitForServerTime = 0.001,
                commandsTime = 0.002,
                encodeTime = 0.003,
                writeTime = 0.004,
                totalTime = 0.01,
                publishRuntime = true
            }
        end

        ModuleRegistry.registerModules(testModule)
        StatePublisherRegistry.registerStatePublishers(testStatePublisher)

        ModuleRegistry.runTasks(5)
        ModuleRegistry.runTasks(5)

        assert.equals(1, moduleInitCalls)
        assert.equals(2, moduleRunCalls)
        assert.equals(1, publisherInitCalls)
        assert.equals(2, publisherSyncCalls)
        assert.equals(2, communicateCalls)
        assert.equals(2, #capturedRuntimePublishes)
        assert.equals("id", capturedRuntimePublishes[1].keyId)
        assert.equals(1, capturedRuntimePublishes[1].overallCount)
        assert.equals(1, capturedRuntimePublishes[1].syncStateCount)
        assert.equals(1, capturedRuntimePublishes[2].overallCount)
        assert.equals(1, capturedRuntimePublishes[2].syncStateCount)
        assert.equals(1, capturedRuntimePublishes[2].encodeCount)
        assert.equals(1, capturedRuntimePublishes[2].initModuleCount)
        assert.is_true(RuntimeRegistry.get("StatePublisher.spec.TestStatePublisher.syncState").count == 0)
        assert.is_true(RuntimeRegistry.get("LuaModule.spec.TestLuaModule.init").count > 0)
    end)

    it("skips exchangeWithServer while server is deactivated", function ()
        local ModuleRegistry = require("ak.core.ModuleRegistry")
        local StatePublisherRegistry = require("ak.core.StatePublisherRegistry")
        local ServerBridge = require("ak.io.ServerBridge")
        local RuntimeRegistry = require("ak.util.RuntimeRegistry")
        local communicateCalls = 0
        local publisherSyncCalls = 0

        local testModule = {
            id = "spec-test-module-2",
            name = "spec.DisabledServerModule",
            enabled = true,
            init = function () end,
            run = function () end
        }
        local testStatePublisher = {
            name = "spec.DisabledServerPublisher",
            initialize = function () end,
            syncState = function ()
                publisherSyncCalls = publisherSyncCalls + 1
                return {}
            end
        }

        ServerBridge.exchangeWithServer = function ()
            communicateCalls = communicateCalls + 1
            return {
                waitForServerTime = 0.001,
                commandsTime = 0.002,
                encodeTime = 0.003,
                writeTime = 0.004,
                totalTime = 0.01,
                publishRuntime = true
            }
        end

        ModuleRegistry.registerModules(testModule)
        StatePublisherRegistry.registerStatePublishers(testStatePublisher)
        ModuleRegistry.deactivateServer()

        ModuleRegistry.runTasks(3)

        assert.equals(1, publisherSyncCalls)
        assert.equals(0, communicateCalls)
        assert.equals(0, RuntimeRegistry.get("MainLoopRunner.runCycle-7-encode").time)
        assert.equals(0, RuntimeRegistry.get("MainLoopRunner.runCycle-8-write").time)
    end)
end)