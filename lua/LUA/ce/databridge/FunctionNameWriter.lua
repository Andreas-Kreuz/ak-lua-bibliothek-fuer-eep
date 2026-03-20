if AkDebugLoad then print("[#Start] Loading ce.databridge.FunctionNameWriter ...") end
local ExchangeDirRegistry = require("ce.databridge.ExchangeDirRegistry")

local FunctionNameWriter = {}
local initialized = false

local function outputFileName() return ExchangeDirRegistry.getExchangeDirectory() .. "/ak-runtime-functions.txt" end

local function collectGlobalNames()
    local names = {}
    for name in pairs(_G) do table.insert(names, name) end
    table.sort(names)
    return names
end

local function writeFunctionNames()
    local fileName = outputFileName()
    local file = io.open(fileName, "w")
    assert(file, fileName)
    file:write(table.concat(collectGlobalNames(), "\n") .. "\n")
    file:flush()
    file:close()
end

function FunctionNameWriter.initialize()
    if initialized then return end

    writeFunctionNames()
    initialized = true
end

return FunctionNameWriter
