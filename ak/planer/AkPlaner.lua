AkSecondsPerDay = 24 * 60 * 60
function AkTimeH()
    if EEPTimeH then
        return EEPTimeH
    else
        local time = os.date("*t");
        return time.hour
    end
end

function AkTimeM()
    if EEPTimeM then
        return EEPTimeM
    else
        local time = os.date("*t");
        return time.min
    end
end

function AkTimeS()
    if EEPTimeS then
        return EEPTimeS
    else
        local time = os.date("*t");
        return time.sec
    end
end

--- Get the time from EEP or the current system
-- @return the time of the current day in seconds
function AkTime()
    local secondsSinceMidnight
    if EEPTime then
        secondsSinceMidnight = EEPTime
    else
        print("[AkScheduler] System time!")
        local time = os.date("*t")
        secondsSinceMidnight = os.time { year = 1970, month = 1, day = 1, hour = time.hour, min = time.min, sec = time.sec }
    end
    return secondsSinceMidnight
end

------------------
-- Class Scheduler
------------------

AkScheduler = { ready = true }
AkScheduler.debug = AkDebugInit or false
AkScheduler.actions = {}
AkScheduler.actionsToSchedule = {} -- table to add to self.actions later
AkScheduler.lastTime = 0

function AkScheduler:run()
    if self.ready then
        self.ready = false
        for action, plannedAtSeconds in pairs(self.actionsToSchedule) do
            self.actions[action] = plannedAtSeconds
            self.actionsToSchedule[action] = nil
        end

        local currentSecondsSinceMidnight = AkTime()
        local performed = {}
        for action, plannedAtSeconds in pairs(self.actions) do
            -- On a day change, last time is bigger than this time and we need to wrap to the next day
            if self.lastTime > currentSecondsSinceMidnight then
                plannedAtSeconds = plannedAtSeconds % AkSecondsPerDay
                self.actions[action] = plannedAtSeconds
            end
            if currentSecondsSinceMidnight >= plannedAtSeconds then
                if AkScheduler.debug then print("[AkScheduler] Call action: '" .. action.name .. "'") end
                action:callFunction()
                performed[action] = true
            end
        end

        for performedAction in pairs(performed) do
            self.actions[performedAction] = nil
            for action, offsetSeconds in pairs(performedAction.subsequentActions) do
                if AkScheduler.debug then print("[AkScheduler] Plan action: '" .. action.name .. "' in " .. offsetSeconds .. " seconds (at " .. AkTime() + offsetSeconds .. ")") end
                self.actions[action] = AkTime() + offsetSeconds
            end
        end

        self.lastTime = currentSecondsSinceMidnight
        self.ready = true
    end
end

--- the newAction will be called after offsetSeconds milliseconds of the current action
-- @param offsetSeconds delay of the newAction in milliseconds, cannot be bigger than AkSecondsPerDay
-- @param newAction the new action to be performed
-- @param previousAction the currentAction, after which the new action will be performed (optional)
--
function AkScheduler:addAction(offsetSeconds, newAction, previousAction)
    assert(offsetSeconds)
    assert(newAction)
    assert(offsetSeconds < AkSecondsPerDay)

    local plannedAfterPrevious = false
    if previousAction then
        plannedAfterPrevious = planAfterPreviousAction(self.actions, newAction, offsetSeconds, previousAction)
                or  planAfterPreviousAction(self.actionsToSchedule, newAction, offsetSeconds, previousAction)
        if not plannedAfterPrevious then
            print("[AkScheduler] PREVIOUS ACTION NOT FOUND: " .. previousAction.name .. " --> " .. newAction.name)
        end
    end

    if not plannedAfterPrevious and not self.actions[newAction] then
        self.actionsToSchedule[newAction] = AkTime() + offsetSeconds
        if AkScheduler.debug then print("[AkScheduler] Plan action: '" .. newAction.name .. "' in " .. offsetSeconds .. " seconds (at " .. AkTime() + offsetSeconds .. ")") end
    end
end

function planAfterPreviousAction(actions, newAction, offsetSeconds, previousAction)
    local plannedAfterPrevious = false
    for foundAction, plannedTime in pairs(actions) do
        if previousAction == foundAction then
            foundAction:planSubsequentAction(newAction, offsetSeconds)
            plannedAfterPrevious = true
        else
            -- plan in the subsequent actions of the current actions
            plannedAfterPrevious = planAfterPreviousAction(foundAction.subsequentActions, newAction, offsetSeconds, previousAction)
        end
        if (plannedAfterPrevious) then break end
    end
    return plannedAfterPrevious
end


---------------------------------------
-- Class AkAction - is just a function
---------------------------------------
AkAction = {}
AkAction.__index = AkAction

---
-- @param f The function to call in the action
-- @param name The name of the action
--
function AkAction.new(f, name)
    local self = setmetatable({}, AkAction)
    self.f = f
    self.name = name
    self.subsequentActions = {}
    return self
end

function AkAction:planSubsequentAction(action, offsetSeconds)
    self.subsequentActions[action] = offsetSeconds
end

function AkAction:callFunction()
    self.f()
end

function AkAction:getName() return self.name end
