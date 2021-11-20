if AkDebugLoad then print("Loading ak.io.AkWebServerIo ...") end
local json = require "ak.third-party.json"

local EventFileWriter = {}
local eventTexts = {}

---Fires an event
---@param event table the event object string
function EventFileWriter.fireEvent(event)
    -- Pack the event into JSON
    local jsonText = json.encode(event)
    table.insert(eventTexts, jsonText)
end

---Get a list of all cached events
function EventFileWriter.getAndResetEvents()
    local lineSeparatedEvents = table.concat(eventTexts, "\n")
    eventTexts = {}
    return lineSeparatedEvents
end

return EventFileWriter
