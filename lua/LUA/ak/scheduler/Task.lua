print("Loading ak.scheduler.Task ...")


---------------------------------------
-- Class Task - is just a function
---------------------------------------
---@class Task
local Task = {}

---
-- @param f Auszuführende Funktion (die zu startende Aktion)
-- @param name Name der Aktion
--
function Task:new(f, name)
    local o = {
        f = f,
        name = name,
        subsequentTask = {},
    }
    self.__index = self
    return setmetatable(o, self)
end

function Task:addSubsequentTask(folgeAktion, zeitspanneInSekunden)
    self.subsequentTask[folgeAktion] = zeitspanneInSekunden
end

function Task:starteAktion()
    self.f()
end

function Task:getName()
    return self.name
end

return Task
