print("Lade ak.io.AkCommandExecutor ...")
local json = require("ak.io.dkjson")

-- split a string
function string:split(delimiter)
    local result = { }
    local from = 1
    local delim_from, delim_to = string.find(self, delimiter, from)
    while delim_from do
        table.insert(result, string.sub(self, from, delim_from - 1))
        from = delim_to + 1
        delim_from, delim_to = string.find(self, delimiter, from)
    end
    table.insert(result, string.sub(self, from))
    return result
end

local AkCommandExecutor = {}

local allowedFunctions = {
    'clearlog',
    'print',
}

function AkCommandExecutor.callSave(functionAndArgs)
    local fName = table.remove(functionAndArgs, 1)
    local args = functionAndArgs

    --for i, arg in ipairs(args) do
    --    print(i .. "-" .. arg)
    --end
    for _, allowedName in ipairs(allowedFunctions) do
        if fName == allowedName then
            --print("Calling >" .. fName .. "<(...)")
            pcall(_G[fName], table.unpack(args))
            return
        end
    end
    print('Nicht erlaubt: ' .. fName)
end

function AkCommandExecutor.execute(commands)
    commands = commands:split('\n')

    for _, command in ipairs(commands) do
        print('Command: ' .. command)
        local functionAndArgs = command:split(',')

        AkCommandExecutor.callSave(functionAndArgs)
    end
end

return AkCommandExecutor