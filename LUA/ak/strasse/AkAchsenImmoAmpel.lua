print("Lade ak.strasse.AkAchsenImmoAmpel ...")

local AkAchsenImmoAmpel = {}
function AkAchsenImmoAmpel.neuAusTabelle(tabelle)
    return AkAchsenImmoAmpel:neu(tabelle.immoName,
        tabelle.achse,
        tabelle.grundStellung,
        tabelle.stellungRot,
        tabelle.stellungGruen,
        tabelle.stellungGelb,
        tabelle.stellungRotGelb,
        tabelle.stellungFG)
end

--- Ändert die Achsstellung der angegebenen Immobilien beim Schalten der Ampel auf rot, gelb, grün oder Fußgänger
-- @param immoName Name der Immobilie, deren Achse gesteuert werden soll
-- @param achsName Name der Achse in der Immobilie, die gesteuert werden soll
-- @param grundStellung Grundstellung der Achse (wird eingestellt, wenn eine Stellung nicht angegeben wurde
-- @param stellungRot Achsstellung bei rot
-- @param stellungGruen Achsstellung bei grün
-- @param stellungGelb Achsstellung bei gelb
-- @param stellungFG Achsstellung bei FG
--
function AkAchsenImmoAmpel:neu(immoName, achse, grundStellung, stellungRot, stellungGruen,
stellungGelb, stellungRotGelb, stellungFG)
    assert(immoName)
    assert(type(immoName) == "string")
    assert(achse)
    assert(type(achse) == "string")
    assert(EEPStructureGetAxis(immoName, achse))
    assert(type(grundStellung) == "number")
    if stellungRot then assert(type(stellungRot) == "number") end
    if stellungGruen then assert(type(stellungGruen) == "number") end
    if stellungGelb then assert(type(stellungGelb) == "number") end
    if stellungRotGelb then assert(type(stellungRotGelb) == "number") end
    if stellungFG then assert(type(stellungFG) == "number") end
    local o = {
        immoName = immoName,
        achse = achse,
        grundStellung = grundStellung,
        stellungRot = stellungRot,
        stellungGruen = stellungGruen,
        stellungGelb = stellungGelb or stellungRot,
        stellungFG = stellungFG,
        stellungRotGelb = stellungRotGelb
    }
    self.__index = self
    o = setmetatable(o, self)
    return o
end

return AkAchsenImmoAmpel