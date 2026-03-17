if AkDebugLoad then print("[#Start] Loading ak.io.IncomingCommandFileReader ...") end
local ExchangeDirRegistry = require("ak.io.ExchangeDirRegistry")
local IncomingCommandExecutor = require("ak.io.IncomingCommandExecutor")

local IncomingCommandFileReader = {}

local inFileCommands
local inFileNameCommands

local function writeFile(fileName, content)
    local file = io.open(fileName, "w")
    assert(file, fileName)
    file:write(content)
    file:flush()
    file:close()
end

local function prepareCommandFile()
    local nextInFileNameCommands = ExchangeDirRegistry.getExchangeDirectory() .. "/ak-eep-in.commands"

    if inFileCommands and inFileNameCommands == nextInFileNameCommands then return inFileCommands end

    if inFileCommands then pcall(function() inFileCommands:close() end) end
    writeFile(nextInFileNameCommands, "")
    inFileCommands = io.open(nextInFileNameCommands, "r")
    assert(inFileCommands, nextInFileNameCommands)
    inFileNameCommands = nextInFileNameCommands
    return inFileCommands
end

function IncomingCommandFileReader.readAndExecuteIncomingCommands()
    local commandFile = prepareCommandFile()
    local commands = commandFile:read("*all") -- file: ak-eep-in.commands
    if commands and commands ~= "" then IncomingCommandExecutor.executeIncomingCommands(commands) end
end

return IncomingCommandFileReader
