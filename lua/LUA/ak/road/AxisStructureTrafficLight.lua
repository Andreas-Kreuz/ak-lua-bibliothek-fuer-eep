if AkDebugLoad then print("[#Start] Loading ak.road.AxisStructureTrafficLight ...") end

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
    assert(type(structureName) == "string", "Need 'structureName' as string")
    assert(type(axisName) == "string", "Need 'axisName' as string")
    assert(EEPStructureGetAxis(structureName, axisName))
    assert(type(positionDefault) == "number", "Need 'positionDefault' as number")
    if positionRed then assert(type(positionRed) == "number", "Need 'positionRed' as number") end
    if positionGreen then assert(type(positionGreen) == "number", "Need 'positionGreen' as number") end
    if positionYellow then assert(type(positionYellow) == "number", "Need 'positionYellow' as number") end
    if positionRedYellow then
        assert(type(positionRedYellow) == "number",
               "Need 'positionRedYellow' as number not as " .. type(positionRedYellow))
    end
    if positionPedestrian then
        assert(type(positionPedestrian) == "number",
               "Need 'positionPedestrian' as number not as " .. type(positionPedestrian))
    end
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
