if AkDebugLoad then print("[#Start] Loading ak.core.MainLoopRunner ...") end

local DataChangeBus = require("ak.events.DataChangeBus")
local DataStoreFileWriter = require("ak.io.DataStoreFileWriter")
local IncomingCommandFileReader = require("ak.io.IncomingCommandFileReader")
local RuntimeDtoFactory = require("ak.core.RuntimeDtoFactory")
local ServerExchangeCoordinator = require("ak.io.ServerExchangeCoordinator")
local StatePublisherRegistry = require("ak.core.StatePublisherRegistry")
local RuntimeRegistry = require("ak.util.RuntimeRegistry")

local MainLoopRunner = {}
MainLoopRunner.debug = AkStartWithDebug or false

local modulesInitialized = false
local initializedStatePublisherNames = {}
local ioCycleIndex = -1
local runTimed = RuntimeRegistry.runTimed
local runTimedAndKeep = RuntimeRegistry.runTimedAndKeep

local function runInitModulesPhase(executionOrderModuleNames, registeredLuaModules)
    if modulesInitialized then return end

    ServerExchangeCoordinator.initialize()

    for _, moduleName in ipairs(executionOrderModuleNames) do
        if MainLoopRunner.debug then
            print(string.format("[#MainLoopRunner] Begin initTask() for \"%s\"", moduleName))
        end
        local module = registeredLuaModules[moduleName]
        runTimedAndKeep("LuaModule." .. module.name .. ".init", function () module.init() end)
        if MainLoopRunner.debug then
            print(string.format("[#MainLoopRunner] End initTask() for \"%s\" after %.3f seconds", module.name,
                                RuntimeRegistry.get("LuaModule." .. module.name .. ".init").lastTime / 1000))
        end
    end

    modulesInitialized = true
end

local function runModulesPhase(executionOrderModuleNames, registeredLuaModules)
    for _, moduleName in ipairs(executionOrderModuleNames) do
        if MainLoopRunner.debug then
            print(string.format("[#MainLoopRunner] Begin run() for \"%s\"", moduleName))
        end
        local module = registeredLuaModules[moduleName]
        runTimed("LuaModule." .. module.name .. ".run", function () module.run() end)
        local moduleTime = RuntimeRegistry.get("LuaModule." .. module.name .. ".run").lastTime / 1000
        if MainLoopRunner.debug and moduleTime > 0.01 then
            print(string.format("[#MainLoopRunner] WARNING: run() %.3f seconds for \"%s\"", moduleTime, moduleName))
        end
    end
end

local function runInitStatePublishersPhase(statePublishers)
    local printFirstTime = false

    for _, statePublisher in ipairs(statePublishers) do
        if not initializedStatePublisherNames[statePublisher.name] then
            runTimedAndKeep("StatePublisher." .. statePublisher.name .. ".initialize", function ()
                statePublisher.initialize()
            end)
            initializedStatePublisherNames[statePublisher.name] = true
            if MainLoopRunner.debug then
                print(string.format("[#MainLoopRunner] initialize() %4.0f ms for \"%s\"",
                                    RuntimeRegistry.get("StatePublisher." .. statePublisher.name .. ".initialize")
                                    .lastTime,
                                    statePublisher.name))
            end
            printFirstTime = true
        end
    end

    return printFirstTime
end

local function runSyncStatePhase(statePublishers, printFirstTime)
    for _, statePublisher in ipairs(statePublishers) do
        runTimed("StatePublisher." .. statePublisher.name .. ".syncState", function () statePublisher.syncState() end)
        local statePublisherTime = RuntimeRegistry.get("StatePublisher." .. statePublisher.name .. ".syncState")
            .lastTime
        if MainLoopRunner.debug and (statePublisherTime > 10 or printFirstTime) then
            print(string.format("[#MainLoopRunner] syncState() %4.0f ms for \"%s\"", statePublisherTime,
                                statePublisher.name))
        end
    end
end

function MainLoopRunner.areModulesInitialized() return modulesInitialized end

function MainLoopRunner.initModules(executionOrderModuleNames, registeredLuaModules)
    runTimed("MainLoopRunner.runCycle-1-initModules", function ()
        runInitModulesPhase(executionOrderModuleNames, registeredLuaModules)
    end)
end

function MainLoopRunner.runCycle(cycleCount, executionOrderModuleNames, registeredLuaModules, options)
    options = options or {}
    if options.debug ~= nil then MainLoopRunner.debug = options.debug end
    if not cycleCount or type(cycleCount) ~= "number" then cycleCount = 5 end

    local statePublishers = StatePublisherRegistry.getStatePublishers()
    ioCycleIndex = ioCycleIndex + 1
    local publishIo = cycleCount == 0 or ioCycleIndex % cycleCount == 0
    local serverIsReady = false
    local enableServer = options.enableServer ~= false
    local enableDataStoreJson = options.enableDataStoreJson == true
    local publishRuntime = false
    local printFirstTime = false
    local totalTime

    runTimed("MainLoopRunner.runCycle-OVERALL", function ()
        runTimed("MainLoopRunner.runCycle-1-initModules", function ()
            runInitModulesPhase(executionOrderModuleNames, registeredLuaModules)
        end)
        runTimed("MainLoopRunner.runCycle-2-runModules", function ()
            runModulesPhase(executionOrderModuleNames, registeredLuaModules)
        end)
        ---@diagnostic disable-next-line: cast-local-type
        printFirstTime = runTimed("MainLoopRunner.runCycle-3-initStatePublishers", function ()
            return runInitStatePublishersPhase(statePublishers)
        end)
        runTimed("MainLoopRunner.runCycle-4-syncState", function ()
            runSyncStatePhase(statePublishers, printFirstTime)
        end)


        runTimed("MainLoopRunner.runCycle-5-commands", function ()
            IncomingCommandFileReader.readAndExecuteIncomingCommands()
        end)

        if publishIo and enableServer then
            ---@diagnostic disable-next-line: cast-local-type
            serverIsReady = runTimed("MainLoopRunner.runCycle-6-waitForServer", function ()
                return ServerExchangeCoordinator.isServerReady()
            end)
        end

        if publishIo and enableServer and serverIsReady then
            runTimed("MainLoopRunner.runCycle-7-serverOutput", function ()
                return ServerExchangeCoordinator.runServerOutputCycle()
            end)
        end

        if publishIo and enableDataStoreJson then
            runTimed("MainLoopRunner.runCycle-8-dataStoreWrite", function ()
                DataStoreFileWriter.write()
            end)
        end

        publishRuntime = publishIo and (enableServer or enableDataStoreJson)
    end)

    totalTime = RuntimeRegistry.get("MainLoopRunner.runCycle-OVERALL").lastTime / 1000

    if MainLoopRunner.debug then
        local initModulesTime = RuntimeRegistry.get("MainLoopRunner.runCycle-1-initModules").lastTime
        local runModulesTime = RuntimeRegistry.get("MainLoopRunner.runCycle-2-runModules").lastTime
        local initStatePublishersTime = RuntimeRegistry.get("MainLoopRunner.runCycle-3-initStatePublishers").lastTime
        local syncStateTime = RuntimeRegistry.get("MainLoopRunner.runCycle-4-syncState").lastTime
        local commandsTime = RuntimeRegistry.get("MainLoopRunner.runCycle-5-commands").lastTime
        local waitForServerTime = RuntimeRegistry.get("MainLoopRunner.runCycle-6-waitForServer").lastTime
        local serverOutputTime = RuntimeRegistry.get("MainLoopRunner.runCycle-7-serverOutput").lastTime
        local dataStoreWriteTime = RuntimeRegistry.get("MainLoopRunner.runCycle-8-dataStoreWrite").lastTime
        print(string.format("[#MainLoopRunner] runCycle(%d) time: %.0f ms " ..
                            "(1-initModules: %.0f ms," ..
                            " 2-runModules: %.0f ms," ..
                            " 3-initStatePublishers: %.0f ms," ..
                            " 4-syncState: %.0f ms," ..
                            " 5-commands: %.0f ms," ..
                            " 6-waitForServer: %.0f ms," ..
                            " 7-serverOutput: %.0f ms," ..
                            " 8-dataStoreWrite: %.0f ms)",
                            cycleCount, totalTime * 1000, initModulesTime, runModulesTime,
                            initStatePublishersTime, syncStateTime, commandsTime, waitForServerTime,
                            serverOutputTime, dataStoreWriteTime))
    end

    if publishRuntime then
        local values = RuntimeRegistry.getAll()
        if values then DataChangeBus.fireListChange(RuntimeDtoFactory.createRuntimeDtoList(values)) end
        RuntimeRegistry.resetAll()
        DataChangeBus.printEventCounter()
    end

    return totalTime
end

return MainLoopRunner
