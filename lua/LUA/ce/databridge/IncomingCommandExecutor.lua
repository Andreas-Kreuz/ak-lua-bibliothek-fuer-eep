if AkDebugLoad then print("[#Start] Loading ce.databridge.IncomingCommandExecutor ...") end

-- split a string
local function split(text, delimiter)
    local result = {}
    local from = 1
    local delim_from, delim_to = string.find(text, delimiter, from, true)
    while delim_from do
        table.insert(result, string.sub(text, from, delim_from - 1))
        from = delim_to + 1
        delim_from, delim_to = string.find(text, delimiter, from, true)
    end
    table.insert(result, string.sub(text, from))
    return result
end

local IncomingCommandExecutor = {}
--- List of acceptedFunctions for remote execution
--- Parameters of these functions are separated by | in the calls
local allowedCommands = {}

--- Adding an accepted function
---NOTE: acceptedFunctions are typically added via the Modules BridgeConnector
---@param fName string @using the name of the function as called from EEP-Web
---@param f function
function IncomingCommandExecutor.registerAllowedCommand(fName, f)
    assert(type(fName) == "string", "Need 'fName' as string")
    assert(type(f) == "function", fName)
    allowedCommands[fName] = f
end

-- Accept EEPPause function
IncomingCommandExecutor.registerAllowedCommand("EEPPause", EEPPause)

-- Accept all EEP*Set functions
for name, value in pairs(_G) do
    if string.find(name, "^EEP.*Set") and type(value) == "function" then
        -- print(string.format("[#IncomingCommandExecutor] Adding %s to allowedCommands", name))
        IncomingCommandExecutor.registerAllowedCommand(name, value)
    end
end

function IncomingCommandExecutor.executeCommandSafely(functionAndArgs)
    local fName = table.remove(functionAndArgs, 1)
    local args = functionAndArgs

    if fName == "" then -- ignore empty commands
        return
    end

    local f = allowedCommands[fName]

    assert(f, fName)
    local status, error = pcall(f, table.unpack(args))
    if not status then print(error) end
end

function IncomingCommandExecutor.executeIncomingCommands(commands)
    commands = split(commands, "\n")

    for _, command in ipairs(commands) do
        if command ~= "" then
            -- print("[#IncomingCommandExecutor] Command: " .. command)
            local functionAndArgs = split(command, "|")

            IncomingCommandExecutor.executeCommandSafely(functionAndArgs)
        end
    end
end

return IncomingCommandExecutor