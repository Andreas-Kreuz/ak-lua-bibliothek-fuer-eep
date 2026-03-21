if AkDebugLoad then print("[#Start] Loading ce.databridge.IncomingCommandFileReader ...") end
local ExchangeDirRegistry = require("ce.databridge.ExchangeDirRegistry")
local IncomingCommandExecutor = require("ce.databridge.IncomingCommandExecutor")

local IncomingCommandFileReader = {}

local commandsToCeFile
local commandsToCeFileName

local function writeFile(fileName, content)
    local file = io.open(fileName, "w")
    assert(file, fileName)
    file:write(content)
    file:flush()
    file:close()
end

local function prepareCommandFile()
    local nextCommandsToCeFileName = ExchangeDirRegistry.getExchangeDirectory() .. "/commands-to-ce"

    if commandsToCeFile and commandsToCeFileName == nextCommandsToCeFileName then return commandsToCeFile end

    if commandsToCeFile then pcall(function() commandsToCeFile:close() end) end
    writeFile(nextCommandsToCeFileName, "")
    commandsToCeFile = io.open(nextCommandsToCeFileName, "r")
    assert(commandsToCeFile, nextCommandsToCeFileName)
    commandsToCeFileName = nextCommandsToCeFileName
    return commandsToCeFile
end

function IncomingCommandFileReader.readAndExecuteIncomingCommands()
    local commandFile = prepareCommandFile()
    local commands = commandFile:read("*all") -- file: commands-to-ce
    if commands and commands ~= "" then IncomingCommandExecutor.executeIncomingCommands(commands) end
end

return IncomingCommandFileReader