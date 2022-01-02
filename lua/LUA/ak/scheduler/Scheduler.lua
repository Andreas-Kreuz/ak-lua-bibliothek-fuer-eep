if AkDebugLoad then print("Loading ak.scheduler.Scheduler ...") end
local os = require("os")

local secondsPerDay = 24 * 60 * 60

--- Get the time from EEP or the current system
-- @return the time of the current day in seconds
local function currentSecondsSinceMidnight()
    local calculatedSeconds
    if EEPTime then
        calculatedSeconds = EEPTime
    else
        print("[Scheduler] System time!")
        local time = os.date("*t")
        calculatedSeconds = os.time {
            year = 1970,
            month = 1,
            day = 1,
            hour = time.hour,
            min = time.min,
            sec = time.sec
        }
    end
    return calculatedSeconds
end

------------------
-- Class Scheduler
------------------
local Scheduler = {ready = true}
Scheduler.debug = AkStartWithDebug or false
Scheduler.scheduledTasks = {}
Scheduler.futureTasks = {} -- Wird zu self.eingeplanteAktionen hinzugefuegt
Scheduler.lastRuntime = 0

local function scheduleAfter(scheduledTasks, newTask, offsetInSeconds, previousTask)
    local previousTaskFound = false
    for scheduledTask in pairs(scheduledTasks) do
        if previousTask == scheduledTask then
            scheduledTask:addSubsequentTask(newTask, offsetInSeconds)
            previousTaskFound = true
            if Scheduler.debug then
                print("[Scheduler] Task scheduled: '" .. newTask.name .. "' (" .. offsetInSeconds ..
                      " seconds after '" .. previousTask.name .. "')")
            end
        else
            -- schedule the subsequentTask of the newTask
            previousTaskFound = scheduleAfter(scheduledTask.subsequentTask, newTask, offsetInSeconds, previousTask)
        end
        if (previousTaskFound) then break end
    end
    return previousTaskFound
end

function Scheduler:runTasks()
    if self.ready then
        self.ready = false
        for action, plannedAtSeconds in pairs(self.futureTasks) do
            self.scheduledTasks[action] = plannedAtSeconds
            self.futureTasks[action] = nil
        end

        local secondsSinceMidnight = currentSecondsSinceMidnight()
        ---@type table<Task,boolean>
        local scheduledTasks = {}
        for currentTask, plannedAtSeconds in pairs(self.scheduledTasks) do
            -- On a day change, last time is bigger than this time and we need to wrap to the next day
            if self.lastRuntime > secondsSinceMidnight then
                plannedAtSeconds = plannedAtSeconds % secondsPerDay
                self.scheduledTasks[currentTask] = plannedAtSeconds
            end
            if secondsSinceMidnight >= plannedAtSeconds then
                if Scheduler.debug then
                    print("[Scheduler " .. secondsSinceMidnight .. "] Running Task: '" .. currentTask.name ..
                          "' (NOW)")
                end
                currentTask:starteAktion()
                scheduledTasks[currentTask] = true
            end
        end

        for currentTask in pairs(scheduledTasks) do
            self.scheduledTasks[currentTask] = nil
            for successorAction, offsetSeconds in pairs(currentTask.subsequentTask) do
                if Scheduler.debug then
                    print("[Scheduler " .. secondsSinceMidnight .. "] Scheduling Task: '" .. successorAction.name ..
                          "' in " .. offsetSeconds .. " seconds " .. "(at " .. currentSecondsSinceMidnight() +
                          offsetSeconds .. ")")
                end
                self.scheduledTasks[successorAction] = currentSecondsSinceMidnight() + offsetSeconds
            end
        end

        self.lastRuntime = secondsSinceMidnight
        self.ready = true
    end
end

--- the newAction will be called after offsetSeconds milliseconds of the current action
---@param offsetInSeconds number Zeitspanne nach der die einzuplanende Aktion ausgeführt werden soll kann nicht
---                              groesser sein als AkSekundenProTag
---@param newTask Task the new action to be performed
---@param precedingTask Task optional - wenn angegeben, wird die neue Aktion eingeplant, wenn die zeitspanneInSekunden
-- nach Ausfuehren der vorgaengerAktion vergangen ist
function Scheduler:scheduleTask(offsetInSeconds, newTask, precedingTask)
    assert(offsetInSeconds, "Specify offsetInSeconds")
    assert(newTask, "Specify newTask")
    assert(offsetInSeconds < secondsPerDay)
    assert(offsetInSeconds >= 0)

    local previousTaskFound = false
    if precedingTask then
        previousTaskFound = scheduleAfter(self.scheduledTasks, newTask, offsetInSeconds, precedingTask) or
                            scheduleAfter(self.futureTasks, newTask, offsetInSeconds, precedingTask)
        if not previousTaskFound then
            print("[Scheduler] DID NOT FIND PREDECESSOR TASK FOR! : " .. precedingTask.name .. " --> " .. newTask.name)
        end
    end

    if not previousTaskFound and not self.scheduledTasks[newTask] then
        self.futureTasks[newTask] = currentSecondsSinceMidnight() + offsetInSeconds
        if Scheduler.debug then
            print("[Scheduler] Task scheduled: '" .. newTask.name .. "' in " .. offsetInSeconds .. " seconds (at " ..
                  currentSecondsSinceMidnight() + offsetInSeconds .. ")")
        end
    end
end

return Scheduler
