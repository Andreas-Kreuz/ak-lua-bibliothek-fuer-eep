print("Lade ak.planer.AkAktion ...")


---------------------------------------
-- Class AkAktion - is just a function
---------------------------------------
local AkAktion = {}

---
-- @param f Auszuführende Funktion (die zu startende Aktion)
-- @param name Name der Aktion
--
function AkAktion:neu(f, name)
    local o = {
        f = f,
        name = name,
        folgeAktionen = {},
    }
    self.__index = self
    return setmetatable(o, self)
end

function AkAktion:planeFolgeAktion(folgeAktion, zeitspanneInSekunden)
    self.folgeAktionen[folgeAktion] = zeitspanneInSekunden
end

function AkAktion:starteAktion()
    self.f()
end

function AkAktion:getName()
    return self.name
end

return AkAktion
