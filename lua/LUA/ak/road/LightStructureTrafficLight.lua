print("Loading ak.road.LightStructureTrafficLight ...")

---@class LightStructureTrafficLight
local LightStructureTrafficLight = {}
function LightStructureTrafficLight.neuAusTabelle(tabelle)
    return LightStructureTrafficLight:neu(tabelle.rotImmo, tabelle.gruenImmo, tabelle.gelbImmo, tabelle.anforderungImmo)
end

--- Schaltet das Licht der angegebenen Immobilien beim Schalten der Ampel auf rot, gelb, grün oder Anforderung
-- @param rotImmo Immo deren Licht eingeschaltet wird, wenn die Ampel rot oder rot-gelb ist
-- @param gruenImmo Immo deren Licht eingeschaltet wird, wenn die Ampel grün ist
-- @param gelbImmo Immo deren Licht eingeschaltet wird, wenn die Ampel gelb oder rot-gelb ist
-- @param anforderungImmo Immo deren Licht eingeschaltet wird, wenn die Ampel eine Anforderung erkennt
--
function LightStructureTrafficLight:neu(rotImmo, gruenImmo, gelbImmo, anforderungImmo)
    assert(rotImmo)
    assert(type(rotImmo) == "string")
    assert(EEPStructureGetLight(gruenImmo))
    assert(gruenImmo)
    assert(type(gruenImmo) == "string")
    assert(EEPStructureGetLight(gruenImmo))
    if gelbImmo then
        assert(type(gelbImmo) == "string")
        assert(EEPStructureGetLight(gelbImmo))
    end
    if anforderungImmo then
        assert(type(anforderungImmo) == "string")
        assert(EEPStructureGetLight(anforderungImmo))
    end
    local o = {
        rotImmo = rotImmo,
        gruenImmo = gruenImmo,
        gelbImmo = gelbImmo or rotImmo,
        anforderungImmo = anforderungImmo
    }
    self.__index = self
    o = setmetatable(o, self)
    return o
end

return LightStructureTrafficLight
