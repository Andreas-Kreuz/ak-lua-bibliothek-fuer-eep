insulate("ModuleRegistry IO init", function()
    require("ak.core.eep.EepSimulator")

    local function clearModule(name) package.loaded[name] = nil end

    before_each(function()
        clearModule("ak.core.ModuleRegistry")
        clearModule("ak.core.MainLoopRunner")
        clearModule("ak.core.CoreLuaModule")
        clearModule("ak.io.IoInit")
    end)

    it("calls IoInit.initialize while requiring ModuleRegistry", function()
        local initCalls = 0
        local IoInit = require("ak.io.IoInit")
        IoInit.initialize = function() initCalls = initCalls + 1 end

        require("ak.core.ModuleRegistry")

        assert.equals(1, initCalls)
    end)

    it("does not call IoInit.initialize again from initTasks", function()
        local initCalls = 0
        local IoInit = require("ak.io.IoInit")
        IoInit.initialize = function() initCalls = initCalls + 1 end

        local ModuleRegistry = require("ak.core.ModuleRegistry")
        local MainLoopRunner = require("ak.core.MainLoopRunner")
        MainLoopRunner.initModules = function() end

        ModuleRegistry.initTasks()

        assert.equals(1, initCalls)
    end)

    it("does not call IoInit.initialize again from runTasks", function()
        local initCalls = 0
        local IoInit = require("ak.io.IoInit")
        IoInit.initialize = function() initCalls = initCalls + 1 end

        local ModuleRegistry = require("ak.core.ModuleRegistry")
        local MainLoopRunner = require("ak.core.MainLoopRunner")
        MainLoopRunner.areModulesInitialized = function() return true end
        MainLoopRunner.runCycle = function() return 0 end

        ModuleRegistry.runTasks(5)

        assert.equals(1, initCalls)
    end)
end)
