if AkDebugLoad then print("Loading ak.io.AkWebServerIo ...") end
local AkWebServerIo = require "ak.io.AkWebServerIo"

local EventFileWriter = {}

local function updateEventFile(eventText)
    local file = assert(io.open(AkWebServerIo.outFileNameEvents, "a"))
    file:write(eventText .. "\n")
    file:close()
end

---Fires an event
---@param jsonText string
function EventFileWriter.fireEvent(jsonText)
    updateEventFile(jsonText)
end

---Clears the event log file
function EventFileWriter.clearEventFile()
    local file = io.open(AkWebServerIo.outFileNameEvents, "w+")
    file:close()
end

-- Clear event log when loading this class
EventFileWriter.clearEventFile()

return EventFileWriter
