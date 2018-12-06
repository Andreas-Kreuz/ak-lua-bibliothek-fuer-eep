print("Lade ak.io.AkCommandExecutor ...")
local json = require("ak.io.dkjson")

-- split a string
function string:split(delimiter)
    local result = { }
    local from = 1
    local delim_from, delim_to = string.find(self, delimiter, from, true)
    while delim_from do
        table.insert(result, string.sub(self, from, delim_from - 1))
        from = delim_to + 1
        delim_from, delim_to = string.find(self, delimiter, from, true)
    end
    table.insert(result, string.sub(self, from))
    return result
end

local AkCommandExecutor = {}

local allowedFunctions = {
    'clearlog',
    'print',
    'AkKreuzungSchalteManuell',
    'AkKreuzungSchalteAutomatisch',
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

            --local functionWithTable = fName:split(".")
            --local t = functionWithTable[2] and functionWithTable[1] or nil
            --local f = functionWithTable[2] and functionWithTable[2] or functionWithTable[1]
            --print(table.concat(functionWithTable, "."))
            --print("Table:    " .. (t and tostring(t) or '-'))
            --print("Function: " .. tostring(f))
            --local success, error
            --if t then
            --    if not _G[t] then
            --        print('Table _G[' .. t .. '] does not exist')
            --    end
            --    if not _G[t][f] then
            --        print('Table _G[' .. t .. '][' .. f .. '] does not exist')
            --    end
            --    print("Calling >" .. t .. "<>" .. f .. "(...)")
            --    success, error = pcall(_G[t][f], table.unpack(args))
            --else
            --    print("Calling >" .. f .. "<(...)")
            --    success, error = pcall(_G[f], table.unpack(args))
            --end
            --if not success then
            --    print('Cannot execute "' .. fName .. '(' ..  table.concat(args, ', ') .. ')"')
            --    print(error)
            --end
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