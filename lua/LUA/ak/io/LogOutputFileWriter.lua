if AkDebugLoad then print("[#Start] Loading ak.io.LogOutputFileWriter ...") end
local ExchangeDirRegistry = require("ak.io.ExchangeDirRegistry")
local IncomingCommandExecutor = require("ak.io.IncomingCommandExecutor")
local os = require("os")

local LogOutputFileWriter = {}
local initialized = false

local originalAssert
local originalError
local originalPrint
local originalWarn
local originalClearlog

local function logFileName() return ExchangeDirRegistry.getExchangeDirectory() .. "/ak-eep-out.log" end

local function printToFile(...)
    if ... then
        -- We open the file for every write, so EEP will not keep this file open all the time
        local file = originalAssert(io.open(logFileName(), "a"))
        local time = ""
        if os.date then time = tostring(os.date("%X ")) end
        local text = "" .. time
        local args = { ... }
        for _, arg in ipairs(args) do text = text .. tostring(arg):gsub("\n", "\n       . ") end
        file:write(text .. "\n")
        file:close()
    end
end

local function deleteLogFile()
    local fileName = logFileName()
    local file = io.open(fileName, "w+")
    originalAssert(file, fileName)
    file:close()
    file = originalAssert(io.open(fileName, "a"))
    file:write("")
    file:close()
end

function LogOutputFileWriter.initialize()
    if initialized then return end

    originalAssert = assert
    originalError = error
    originalPrint = print
    originalWarn = warn
    originalClearlog = clearlog

    function print(...)
        printToFile(...)   -- print the output to the log file
        originalPrint(...) -- call the original print function
    end

    error = function (message, level)
        printToFile(message)          -- print the output to the file
        originalError(message, level) -- call the original error function
    end

    warn = function (message, ...)
        printToFile(message, ...) -- print the output to the file
        if originalWarn then originalWarn(message, ...) end
    end

    assert = function (v, message)
        local status, retval = pcall(originalAssert, v, message)
        if not status then error(debug.traceback(message and message or "Assertion failed.", 2), 0) end
        return retval
    end

    function clearlog()
        deleteLogFile()
        originalClearlog()
    end

    deleteLogFile()
    IncomingCommandExecutor.registerAllowedCommand("clearlog", clearlog)
    IncomingCommandExecutor.registerAllowedCommand("print", print)
    initialized = true
end

return LogOutputFileWriter
