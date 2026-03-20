insulate("ce.databridge.IncomingCommandFileReader", function()
    require("ce.hub.eep.EepSimulator")

    local function clearModule(name) package.loaded[name] = nil end

    local originalIoOpen = io.open

    before_each(function()
        clearModule("ce.databridge.ExchangeDirRegistry")
        clearModule("ce.databridge.IncomingCommandExecutor")
        clearModule("ce.databridge.IncomingCommandFileReader")
        io.open = originalIoOpen
    end)

    after_each(function() io.open = originalIoOpen end)

    it("prepares the command file in the exchange directory and executes commands from it", function()
        local openCalls = {}
        local commands = {}

        io.open = function(name, mode)
            if name ~= "../LUA/ce/databridge/exchange/ak-eep-version.txt" and
               name ~= "custom-dir/ak-eep-version.txt" and
               name ~= "custom-dir/ak-eep-in.commands" then
                return originalIoOpen(name, mode)
            end

            table.insert(openCalls, {name = name, mode = mode})
            if mode == "r" then
                return {read = function() return "print|" end, close = function() end}
            end
            return {write = function() end, flush = function() end, close = function() end}
        end

        local ExchangeDirRegistry = require("ce.databridge.ExchangeDirRegistry")
        local IncomingCommandExecutor = require("ce.databridge.IncomingCommandExecutor")
        local IncomingCommandFileReader = require("ce.databridge.IncomingCommandFileReader")
        IncomingCommandExecutor.executeIncomingCommands = function(commandText)
            table.insert(commands, commandText)
        end

        openCalls = {}
        ExchangeDirRegistry.setExchangeDirectory("custom-dir")
        IncomingCommandFileReader.readAndExecuteIncomingCommands()

        assert.same({
            {name = "custom-dir/ak-eep-version.txt", mode = "w"},
            {name = "custom-dir/ak-eep-in.commands", mode = "w"}, {name = "custom-dir/ak-eep-in.commands", mode = "r"}
        }, openCalls)
        assert.same({"print|"}, commands)
    end)

    it("prepares the command file again when the exchange directory changes", function()
        local openCalls = {}
        local commands = {}

        io.open = function(name, mode)
            if name ~= "../LUA/ce/databridge/exchange/ak-eep-version.txt" and
               name ~= "custom-dir/ak-eep-version.txt" and
               name ~= "custom-dir/ak-eep-in.commands" and
               name ~= "other-dir/ak-eep-version.txt" and
               name ~= "other-dir/ak-eep-in.commands" then
                return originalIoOpen(name, mode)
            end

            table.insert(openCalls, {name = name, mode = mode})
            if mode == "r" then
                local content = name == "other-dir/ak-eep-in.commands" and "clearlog" or ""
                return {read = function() return content end, close = function() end}
            end
            return {write = function() end, flush = function() end, close = function() end}
        end

        local ExchangeDirRegistry = require("ce.databridge.ExchangeDirRegistry")
        local IncomingCommandExecutor = require("ce.databridge.IncomingCommandExecutor")
        local IncomingCommandFileReader = require("ce.databridge.IncomingCommandFileReader")
        IncomingCommandExecutor.executeIncomingCommands = function(commandText)
            table.insert(commands, commandText)
        end

        ExchangeDirRegistry.setExchangeDirectory("custom-dir")
        IncomingCommandFileReader.readAndExecuteIncomingCommands()

        openCalls = {}
        ExchangeDirRegistry.setExchangeDirectory("other-dir")
        IncomingCommandFileReader.readAndExecuteIncomingCommands()

        assert.same({
            {name = "other-dir/ak-eep-version.txt", mode = "w"}, {name = "other-dir/ak-eep-in.commands", mode = "w"},
            {name = "other-dir/ak-eep-in.commands", mode = "r"}
        }, openCalls)
        assert.same({"clearlog"}, commands)
    end)
end)
