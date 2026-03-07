if AkDebugLoad then print("[#Start] Loading ak.io.EventRecorder ...") end
local json = require("ak.third-party.json")

local EventRecorder = {}
local recordedEvents = {}

--- All events must be fired with this function, so they are recorded in the list of recordedEvents and can be written to a file later.
---@param event table the event object string
function EventRecorder.fireEvent(event)
    -- Pack the event into JSON
    local jsonText = json.encode(event)
    table.insert(recordedEvents, jsonText)
end

--- Return a list of all recordedEvents and clear the list
function EventRecorder.collectAndResetEvents()
    local lineSeparatedEvents = table.concat(recordedEvents, "\n")
    recordedEvents = {}
    return lineSeparatedEvents
end

return EventRecorder
