if AkDebugLoad then print("Loading ak.road.LightStructureTrafficLight ...") end

---@class LightStructureTrafficLight
local LightStructureTrafficLight = {}

--- Schaltet das Licht der angegebenen Immobilien beim Schalten der Ampel auf rot, gelb, grün oder Anforderung
---@param redStructure string Immo deren Licht eingeschaltet wird, wenn die Ampel rot oder rot-gelb ist
---@param greenStructure string Immo deren Licht eingeschaltet wird, wenn die Ampel grün ist
---@param yellowStructure string Immo deren Licht eingeschaltet wird, wenn die Ampel gelb oder rot-gelb ist
---@param requestStructure string Immo deren Licht eingeschaltet wird, wenn die Ampel eine Anforderung erkennt
--
function LightStructureTrafficLight:new(redStructure, greenStructure, yellowStructure, requestStructure)
    assert(type(redStructure) == "string", "Need 'redStructure' as string")
    assert(EEPStructureGetLight(redStructure), redStructure)
    assert(type(greenStructure) == "string", "Need 'greenStructure' as string")
    assert(EEPStructureGetLight(greenStructure), greenStructure)
    if yellowStructure then
        assert(type(yellowStructure) == "string", "Need 'yellowStructure' as string")
        assert(EEPStructureGetLight(yellowStructure), yellowStructure)
    end
    if requestStructure then
        assert(type(requestStructure) == "string",
               "Need 'requestStructure' as string not as " .. type(requestStructure))
        assert(EEPStructureGetLight(requestStructure), requestStructure)
    end
    local o = {
        redStructure = redStructure,
        greenStructure = greenStructure,
        yellowStructure = yellowStructure or redStructure,
        requestStructure = requestStructure
    }
    self.__index = self
    o = setmetatable(o, self)
    return o
end

return LightStructureTrafficLight
