if AkDebugLoad then print("[#Start] Loading ak.scheduler.Task ...") end

---------------------------------------
-- Class Task - is just a function
---------------------------------------
---@class Task
---@field subsequentTask table<Task, number> Task and offset in seconds (will be scheduled if this task is done)
---@field f function task function
---@field name string Name of the taks
local Task = {}

---
-- @param f Auszuführende Funktion (die zu startende Aktion)
-- @param name Name der Aktion
--
function Task:new(f, name)
    local o = {f = f, name = name, subsequentTask = {}}
    self.__index = self
    return setmetatable(o, self)
end

function Task:addSubsequentTask(folgeAktion, zeitspanneInSekunden)
    self.subsequentTask[folgeAktion] = zeitspanneInSekunden
end

function Task:starteAktion() self.f() end

function Task:getName() return self.name end

return Task
