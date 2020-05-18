print("Loading ak.road.AxisStructureTrafficLight ...")

---@class AxisStructureTrafficLight
---@field structureName string Name der Immobilie, deren Achse gesteuert werden soll
---@field axisName string Name der Achse in der Immobilie, die gesteuert werden soll
---@field positionDefault number Grundstellung der Achse (wird eingestellt, wenn eine Stellung nicht angegeben wurde
---@field positionRed number Achsstellung bei rot
---@field positionGreen number Achsstellung bei grün
---@field positionYellow number Achsstellung bei gelb
---@field positionRedYellow number Achsstellung bei gelb
---@field positionPedestrian number Achsstellung bei FG
local AxisStructureTrafficLight = {}

--- Ändert die Achsstellung der angegebenen Immobilien beim Schalten der Ampel auf rot, gelb, grün oder Fußgänger
---@param structureName string Name der Immobilie, deren Achse gesteuert werden soll
---@param axisName string Name der Achse in der Immobilie, die gesteuert werden soll
---@param positionDefault number Grundstellung der Achse (wird eingestellt, wenn eine Stellung nicht angegeben wurde
---@param positionRed number Achsstellung bei rot
---@param positionGreen number Achsstellung bei grün
---@param positionYellow number Achsstellung bei gelb
---@param positionRedYellow number Achsstellung bei gelb
---@param positionPedestrian number Achsstellung bei FG
--
function AxisStructureTrafficLight:new(structureName, axisName, positionDefault, positionRed, positionGreen,
                                       positionYellow, positionRedYellow, positionPedestrian)
    assert(structureName)
    assert(type(structureName) == "string")
    assert(axisName)
    assert(type(axisName) == "string")
    assert(EEPStructureGetAxis(structureName, axisName))
    assert(type(positionDefault) == "number")
    if positionRed then assert(type(positionRed) == "number") end
    if positionGreen then assert(type(positionGreen) == "number") end
    if positionYellow then assert(type(positionYellow) == "number") end
    if positionRedYellow then assert(type(positionRedYellow) == "number") end
    if positionPedestrian then assert(type(positionPedestrian) == "number") end
    local o = {
        structureName = structureName,
        axisName = axisName,
        positionDefault = positionDefault,
        positionRed = positionRed,
        positionGreen = positionGreen,
        positionYellow = positionYellow or positionRed,
        positionPedestrian = positionPedestrian,
        positionRedYellow = positionRedYellow
    }
    self.__index = self
    o = setmetatable(o, self)
    return o
end

return AxisStructureTrafficLight
