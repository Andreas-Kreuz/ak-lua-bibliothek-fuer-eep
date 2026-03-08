if AkDebugLoad then print("[#Start] Loading ak.core.MainLoopRunner ...") end

local DataChangeBus = require("ak.events.DataChangeBus")
local ServerExchangeCoordinator = require("ak.io.ServerExchangeCoordinator")
local StatePublisherRegistry = require("ak.core.StatePublisherRegistry")
local RuntimeRegistry = require("ak.util.RuntimeRegistry")
local os = require("os")

local MainLoopRunner = {}
MainLoopRunner.debug = AkStartWithDebug or false

local modulesInitialized = false
local initializedStatePublisherNames = {}

local function storeRuntime(group, time, keepGroup)
    RuntimeRegistry.storeRunTime(group, time)
    if keepGroup then RuntimeRegistry.keepGroup(group) end
end

local function runInitModulesPhase(executionOrderModuleNames, registeredLuaModules)
    if modulesInitialized then return { time = 0 } end
    local t0 = os.clock()

    ServerExchangeCoordinator.initialize()

    for _, moduleName in ipairs(executionOrderModuleNames) do
        if MainLoopRunner.debug then print(string.format("[#MainLoopRunner] Begin initTask() for \"%s\"", moduleName)) end
        local module = registeredLuaModules[moduleName]
        local moduleTime0 = os.clock()
        module.init()
        local moduleTime = os.clock() - moduleTime0
        storeRuntime("LuaModule." .. module.name .. ".init", moduleTime, true)
        if MainLoopRunner.debug then
            print(string.format("[#MainLoopRunner] End initTask() for \"%s\" after %.3f seconds", module.name,
                                moduleTime))
        end
    end

    modulesInitialized = true
    return { time = os.clock() - t0 }
end

local function runModulesPhase(executionOrderModuleNames, registeredLuaModules)
    local t0 = os.clock()

    for _, moduleName in ipairs(executionOrderModuleNames) do
        if MainLoopRunner.debug then print(string.format("[#MainLoopRunner] Begin run() for \"%s\"", moduleName)) end
        local module = registeredLuaModules[moduleName]
        local moduleTime0 = os.clock()
        module.run()
        local moduleTime = os.clock() - moduleTime0

        RuntimeRegistry.storeRunTime("LuaModule." .. module.name .. ".run", moduleTime)
        if MainLoopRunner.debug and moduleTime > 0.01 then
            print(string.format("[#MainLoopRunner] WARNING: run() %.3f seconds for \"%s\"", moduleTime,
                                moduleName))
        end
    end

    return { time = os.clock() - t0 }
end

local function runInitStatePublishersPhase(statePublishers)
    local t0 = os.clock()
    local printFirstTime = false

    for _, statePublisher in ipairs(statePublishers) do
        if not initializedStatePublisherNames[statePublisher.name] then
            local statePublisherTime0 = os.clock()
            statePublisher.initialize()
            initializedStatePublisherNames[statePublisher.name] = true
            local statePublisherTime = os.clock() - statePublisherTime0
            storeRuntime("StatePublisher." .. statePublisher.name .. ".initialize", statePublisherTime, true)
            if MainLoopRunner.debug then
                print(string.format("[#MainLoopRunner] initialize() %4.0f ms for \"%s\"",
                                    statePublisherTime * 1000, statePublisher.name))
            end
            printFirstTime = true
        end
    end

    return {
        time = os.clock() - t0,
        printFirstTime = printFirstTime
    }
end

local function runSyncStatePhase(statePublishers, printFirstTime)
    local t0 = os.clock()

    for _, statePublisher in ipairs(statePublishers) do
        local statePublisherTime0 = os.clock()
        statePublisher.syncState()
        local statePublisherTime = os.clock() - statePublisherTime0
        RuntimeRegistry.storeRunTime("StatePublisher." .. statePublisher.name .. ".syncState", statePublisherTime)
        if MainLoopRunner.debug and (statePublisherTime > 0.01 or printFirstTime) then
            print(string.format("[#MainLoopRunner] syncState() %4.0f ms for \"%s\"", statePublisherTime * 1000,
                                statePublisher.name))
        end
    end

    return { time = os.clock() - t0 }
end

local function runServerPhase(cycleCount, enableServer)
    local t0 = os.clock()
    local serverResult = {
        waitForServerTime = 0,
        commandsTime = 0,
        encodeTime = 0,
        writeTime = 0,
        totalTime = 0,
        publishRuntime = false
    }

    if enableServer then
        serverResult = ServerExchangeCoordinator.runServerExchangeCycle(cycleCount) or serverResult
    end

    return {
        time = os.clock() - t0,
        serverResult = serverResult,
        publishRuntime = serverResult.publishRuntime == true
    }
end

local function finalizeCycle(cycleCount, totalTime, initModulesTime, runModulesTime, initStatePublishersTime,
                             syncStateTime, serverTime, serverResult, publishRuntime)
    storeRuntime("MainLoopRunner.runCycle-1-initModules", initModulesTime)
    storeRuntime("MainLoopRunner.runCycle-2-runModules", runModulesTime)
    storeRuntime("MainLoopRunner.runCycle-3-initStatePublishers", initStatePublishersTime)
    storeRuntime("MainLoopRunner.runCycle-4-syncState", syncStateTime)
    storeRuntime("MainLoopRunner.runCycle-5-waitForServer", serverResult.waitForServerTime or 0)
    storeRuntime("MainLoopRunner.runCycle-6-commands", serverResult.commandsTime or 0)
    storeRuntime("MainLoopRunner.runCycle-7-encode", serverResult.encodeTime or 0)
    storeRuntime("MainLoopRunner.runCycle-8-write", serverResult.writeTime or 0)
    storeRuntime("MainLoopRunner.runCycle-OVERALL", totalTime)

    if publishRuntime then
        local values = RuntimeRegistry.getAll()
        if values then DataChangeBus.fireListChange("runtime", "id", values) end
        RuntimeRegistry.resetAll()
        DataChangeBus.printEventCounter()
    end

    if MainLoopRunner.debug then
        print(string.format("[#MainLoopRunner] runCycle(%d) time: %.0f ms " ..
                            "(%.0f ms initModules, %.0f ms runModules, %.0f ms initState, %.0f ms syncState, %.0f ms serveData)",
                            cycleCount, totalTime * 1000, initModulesTime * 1000,
                            runModulesTime * 1000, initStatePublishersTime * 1000,
                            syncStateTime * 1000, serverTime * 1000)
        )
    end
end

function MainLoopRunner.areModulesInitialized() return modulesInitialized end

function MainLoopRunner.initModules(executionOrderModuleNames, registeredLuaModules)
    return runInitModulesPhase(executionOrderModuleNames, registeredLuaModules).time
end

function MainLoopRunner.runCycle(cycleCount, executionOrderModuleNames, registeredLuaModules, options)
    options = options or {}
    if options.debug ~= nil then MainLoopRunner.debug = options.debug end
    local enableServer = options.enableServer ~= false
    local statePublishers = StatePublisherRegistry.getStatePublishers()

    local totalTime0 = os.clock()
    local initModulesInfo = runInitModulesPhase(executionOrderModuleNames, registeredLuaModules)
    local runModulesInfo = runModulesPhase(executionOrderModuleNames, registeredLuaModules)
    local initStatePublishersInfo = runInitStatePublishersPhase(statePublishers)
    local syncStateInfo = runSyncStatePhase(statePublishers, initStatePublishersInfo.printFirstTime)
    local serverPhaseInfo = runServerPhase(cycleCount, enableServer)
    local totalTime = os.clock() - totalTime0

    finalizeCycle(cycleCount, totalTime, initModulesInfo.time, runModulesInfo.time, initStatePublishersInfo.time,
                  syncStateInfo.time, serverPhaseInfo.time, serverPhaseInfo.serverResult,
                  serverPhaseInfo.publishRuntime)

    return totalTime
end

return MainLoopRunner
