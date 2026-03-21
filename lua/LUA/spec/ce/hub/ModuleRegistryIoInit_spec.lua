insulate("ControlExtensionHub IO init", function()
    require("ce.hub.eep.EepSimulator")

    local function clearModule(name) package.loaded[name] = nil end

    before_each(function()
        clearModule("ce.ControlExtension")
        clearModule("ce.hub.ControlExtensionHub")
        clearModule("ce.hub.ModuleRegistry")
        clearModule("ce.hub.MainLoopRunner")
        clearModule("ce.hub.mods.HubCeModule")
        clearModule("ce.databridge.IoInit")
    end)

    it("calls IoInit.initialize while requiring ControlExtensionHub", function()
        local initCalls = 0
        local IoInit = require("ce.databridge.IoInit")
        IoInit.initialize = function() initCalls = initCalls + 1 end

        require("ce.hub.ControlExtensionHub")

        assert.equals(1, initCalls)
    end)

    it("does not call IoInit.initialize again from ControlExtension.initTasks", function()
        local initCalls = 0
        local IoInit = require("ce.databridge.IoInit")
        IoInit.initialize = function() initCalls = initCalls + 1 end

        local ControlExtension = require("ce.ControlExtension")
        local MainLoopRunner = require("ce.hub.MainLoopRunner")
        MainLoopRunner.initModules = function() end

        ControlExtension.initTasks()

        assert.equals(1, initCalls)
    end)

    it("does not call IoInit.initialize again from ControlExtension.runTasks", function()
        local initCalls = 0
        local IoInit = require("ce.databridge.IoInit")
        IoInit.initialize = function() initCalls = initCalls + 1 end

        local ControlExtension = require("ce.ControlExtension")
        local MainLoopRunner = require("ce.hub.MainLoopRunner")
        MainLoopRunner.areModulesInitialized = function() return true end
        MainLoopRunner.runCycle = function() return 0 end

        ControlExtension.runTasks(5)

        assert.equals(1, initCalls)
    end)
end)
