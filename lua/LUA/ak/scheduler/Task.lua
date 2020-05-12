print("Loading ak.scheduler.Task ...")


---------------------------------------
-- Class Task - is just a function
---------------------------------------
local Task = {}

---
-- @param f Auszuführende Funktion (die zu startende Aktion)
-- @param name Name der Aktion
--
function Task:neu(f, name)
    local o = {
        f = f,
        name = name,
        folgeAktionen = {},
    }
    self.__index = self
    return setmetatable(o, self)
end

function Task:planeFolgeAktion(folgeAktion, zeitspanneInSekunden)
    self.folgeAktionen[folgeAktion] = zeitspanneInSekunden
end

function Task:starteAktion()
    self.f()
end

function Task:getName()
    return self.name
end

return Task
