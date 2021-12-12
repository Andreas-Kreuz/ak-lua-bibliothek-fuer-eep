local EventBroker = require("ak.util.EventBroker")
local Line = require("ak.public-transport.Line")
local LineRegistry = {}
local allLines = {}

---Creates a line object for the given line name, the line must exist
---@param id string name of the line in EEP, e.g. "10" or "A1"
---@return Line,boolean returns the line and the status if the line was newly created
function LineRegistry.forId(id)
    assert(id, "Provide a name for the line")
    assert(type(id) == "string", "Need 'lineName' as string")
    if allLines[id] then
        return allLines[id], false
    else
        -- Initialize the line
        local line = Line:new({nr = id})
        allLines[line.id] = line
        return line, true
    end
end

---A line appeared on the map
function LineRegistry.lineAppeared(_)
    -- is included in "LineRegistry.fireChangeLinesEvent()"
    -- EventBroker.fireDataAdded("lines", "id", line:toJsonStatic())
end

---A line dissappeared from the map
---@param lineName string
function LineRegistry.lineDisappeared(lineName)
    allLines[lineName] = nil
    -- EventBroker.fireDataRemoved("lines", "id", {id = lineName})
end

function LineRegistry.fireChangeLinesEvent()
    local modifiedLines = {}
    for _, line in pairs(allLines) do
        if line.valuesUpdated then
            modifiedLines[line.id] = line:toJsonStatic()
            line.valuesUpdated = false
        end
    end
    EventBroker.fireListChange("public-transport-line-names", "id", modifiedLines)
end

return LineRegistry
