if AkDebugLoad then print("[#Start] Loading ce.databridge.LogOutputFileWriter ...") end
local ExchangeDirRegistry = require("ce.databridge.ExchangeDirRegistry")
local IncomingCommandExecutor = require("ce.databridge.IncomingCommandExecutor")
local os = require("os")

local LogOutputFileWriter = {}
local initialized = false
local resetMarker = "@@CE_LOG_RESET@@"

local originalAssert
local originalError
local originalPrint
local originalWarn
local originalClearlog

local function logFromCeFileName() return ExchangeDirRegistry.getExchangeDirectory() .. "/log-from-ce" end

local function appendRawLine(text)
    local file = originalAssert(io.open(logFromCeFileName(), "a"))
    file:write(text .. "\n")
    file:close()
end

local function printToFile(...)
    if ... then
        local time = ""
        if os.date then time = tostring(os.date("%X ")) end
        local text = "" .. time
        local args = { ... }
        for _, arg in ipairs(args) do text = text .. tostring(arg):gsub("\n", "\n       . ") end
        appendRawLine(text)
    end
end

local function deleteLogFile()
    local file = io.open(logFromCeFileName(), "w+")
    originalAssert(file, logFromCeFileName())
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
        appendRawLine(resetMarker)
        originalClearlog()
    end

    deleteLogFile()
    IncomingCommandExecutor.registerAllowedCommand("clearlog", clearlog)
    IncomingCommandExecutor.registerAllowedCommand("print", print)
    initialized = true
end

return LogOutputFileWriter