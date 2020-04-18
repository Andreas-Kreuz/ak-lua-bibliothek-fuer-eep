print("Lade ak.io.AkCommandExecutor ...")

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

local allowedFunctions = {
    "clearlog",
    "print",
    "AkKreuzungSchalteManuell",
    "AkKreuzungSchalteAutomatisch",
    "EEPPause"
}

function AkCommandExecutor.callSave(functionAndArgs)
    local fName = table.remove(functionAndArgs, 1)
    local args = functionAndArgs
    local accepted = false

    if fName == "" then -- ignore empty commands
        return
    end

    --for i, arg in ipairs(args) do
    --    print(i .. "-" .. arg)
    --end

    if string.find(fName, "^EEP.*Set") then -- Accept all EEP-Set-functions
        accepted = true
    else
        for _, allowedName in ipairs(allowedFunctions) do
            if fName == allowedName then
                accepted = true
                break
            end
        end
    end

    if accepted then
        if pcall(_G[fName], table.unpack(args)) then
            print("Aufruf von " .. fName)
        else
            print("Aufruf von " .. fName .. " fehlgeschlagen")
        end
    else
        print("Aufruf von " .. fName .. " nicht erlaubt")
    end
end

function AkCommandExecutor.execute(commands)
    commands = split(commands, "\n")

    for _, command in ipairs(commands) do
        print("Command: " .. command)
        local functionAndArgs = split(command, "|")

        AkCommandExecutor.callSave(functionAndArgs)
    end
end

return AkCommandExecutor
