---@class Platform
---@field type string
---@field id string
---@field roadStation RoadStation
---@field platformNumber number
local Platform = {}

--- Creates a new Bus or Tram Station
---@param roadStation RoadStation a roadstation
---@param platformNumber number number of the platform starting with 1
---@return Platform
function Platform:new(roadStation, platformNumber)
    assert(type(roadStation) == "table", "Need 'roadStation' as RoadStation")
    assert(roadStation.type == "RoadStation", "Need 'roadStation' as RoadStation")
    assert(type(platformNumber) == "number", "Need 'platformNumber' as number")
    local o = {}
    o.type = "Platform"
    o.id = roadStation.name .. "#" .. platformNumber
    o.roadStation = roadStation
    o.platformNumber = platformNumber
    self.__index = self
    setmetatable(o, self)
    return o
end

function Platform:addDisplay(structureName, displayModel)
    self.roadStation:addDisplay(structureName, displayModel, self.platformNumber)
end

return Platform
