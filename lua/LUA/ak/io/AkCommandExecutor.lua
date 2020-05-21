if AkDebugLoad then print("Loading ak.io.AkCommandExecutor ...") end

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

local AkCommandExecutor = {}
--- List of acceptedFunctions for remote execution
--- Parameters of these functions are separated by | in the calls
local acceptedRemoteFunctions = {}

--- Adding an accepted function
---NOTE: acceptedFunctions are typically added via the Modules WebConnector
---@param fName string @using the name of the function as called from EEP-Web
---@param f function
function AkCommandExecutor.addAcceptedRemoteFunction(fName, f)
    assert(fName and type(fName) == "string", "Es muss ein Funktionsname angegeben werden.")
    assert(f and type(f) == "function", "Es muss eine Funktion angegeben werden fuer " .. fName)
    acceptedRemoteFunctions[fName] = f
end

-- Accept EEPPause function
AkCommandExecutor.addAcceptedRemoteFunction("EEPPause", EEPPause)

-- Accept all EEP*Set functions
for name, value in pairs(_G) do
    if string.find(name, "^EEP.*Set") and type(value) == "function" then
        --print(string.format("Adding %s to acceptedRemoteFunctions", name))
        AkCommandExecutor.addAcceptedRemoteFunction(name, value)
    end
end

function AkCommandExecutor.callSavely(functionAndArgs)
    local fName = table.remove(functionAndArgs, 1)
    local args = functionAndArgs

    if fName == "" then -- ignore empty commands
        return
    end

    local f = acceptedRemoteFunctions[fName]

    assert(f, "Funktionsname nicht hinterlegt: " .. fName)

    if f then
        local status, error = pcall(f, table.unpack(args))
        if not status then
            print(error)
        end
    else
        print("Aufruf von " .. fName .. " nicht erlaubt")
    end
end

function AkCommandExecutor.execute(commands)
    commands = split(commands, "\n")

    for _, command in ipairs(commands) do
        if command ~= "" then
            -- print("Command: " .. command)
            local functionAndArgs = split(command, "|")

            AkCommandExecutor.callSavely(functionAndArgs)
        end
    end
end

return AkCommandExecutor
