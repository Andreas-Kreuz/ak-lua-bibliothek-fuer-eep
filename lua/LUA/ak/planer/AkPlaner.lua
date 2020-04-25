print("Lade ak.planer.AkPlaner ...")

local AkSekundenProTag = 24 * 60 * 60

--- Get the time from EEP or the current system
-- @return the time of the current day in seconds
local function AkSekundenSeitMitternacht()
    local secondsSinceMidnight
    if EEPTime then
        secondsSinceMidnight = EEPTime
    else
        print("[AkPlaner] System time!")
        local time = os.date("*t")
        secondsSinceMidnight = os.time {
            year = 1970, month = 1, day = 1, hour = time.hour, min = time.min, sec = time.sec
        }
    end
    return secondsSinceMidnight
end

------------------
-- Class Scheduler
------------------

local AkPlaner = { bereit = true }
AkPlaner.debug = AkStartMitDebug or false
AkPlaner.eingeplanteAktionen = {}
AkPlaner.spaetereAktionen = {} -- Wird zu self.eingeplanteAktionen hinzugefuegt
AkPlaner.letzteAusfuehrung = 0

function AkPlaner:fuehreGeplanteAktionenAus()
    if self.bereit then
        self.bereit = false
        for action, plannedAtSeconds in pairs(self.spaetereAktionen) do
            self.eingeplanteAktionen[action] = plannedAtSeconds
            self.spaetereAktionen[action] = nil
        end

        local anzahlSekundenSeitLetzterMitternacht = AkSekundenSeitMitternacht()
        local ausgefuehrteAktionen = {}
        for action, plannedAtSeconds in pairs(self.eingeplanteAktionen) do
            -- On a day change, last time is bigger than this time and we need to wrap to the next day
            if self.letzteAusfuehrung > anzahlSekundenSeitLetzterMitternacht then
                plannedAtSeconds = plannedAtSeconds % AkSekundenProTag
                self.eingeplanteAktionen[action] = plannedAtSeconds
            end
            if anzahlSekundenSeitLetzterMitternacht >= plannedAtSeconds then
                if AkPlaner.debug then print("[AkPlaner] Starte Aktion: '" .. action.name .. "'") end
                action:starteAktion()
                ausgefuehrteAktionen[action] = true
            end
        end

        for ausgefuehrteAktion in pairs(ausgefuehrteAktionen) do
            self.eingeplanteAktionen[ausgefuehrteAktion] = nil
            for action, offsetSeconds in pairs(ausgefuehrteAktion.folgeAktionen) do
                if AkPlaner.debug then print("[AkPlaner] Plan action: '" .. action.name .. "' in " .. offsetSeconds
                        .. " seconds (at " .. AkSekundenSeitMitternacht() + offsetSeconds .. ")")
                end
                self.eingeplanteAktionen[action] = AkSekundenSeitMitternacht() + offsetSeconds
            end
        end

        self.letzteAusfuehrung = anzahlSekundenSeitLetzterMitternacht
        self.bereit = true
    end
end

--- the newAction will be called after offsetSeconds milliseconds of the current action
-- @param zeitspanneInSekunden Zeitspanne nach der die einzuplanende Aktion ausgeführt werden soll kann nicht groesser
-- sein als AkSekundenProTag
-- @param einzuplanendeAktion the new action to be performed
-- @param vorgaengerAktion optional - wenn angegeben, wird die neue Aktion eingeplant, wenn die zeitspanneInSekunden
-- nach Ausfuehren der vorgaengerAktion vergangen ist
function AkPlaner:planeAktion(zeitspanneInSekunden, einzuplanendeAktion, vorgaengerAktion)
    assert(zeitspanneInSekunden)
    assert(einzuplanendeAktion)
    assert(zeitspanneInSekunden < AkSekundenProTag)

    local vorhergehendeAktionGefunden = false
    if vorgaengerAktion then
        vorhergehendeAktionGefunden
        = planeNachAktion(self.eingeplanteAktionen, einzuplanendeAktion, zeitspanneInSekunden, vorgaengerAktion)
                or planeNachAktion(self.spaetereAktionen, einzuplanendeAktion,
            zeitspanneInSekunden, vorgaengerAktion)
        if not vorhergehendeAktionGefunden then
            print("[AkPlaner] VORGAENGER-AKTION NICHT GEFUNDEN! : "
                    .. vorgaengerAktion.name .. " --> " .. einzuplanendeAktion.name)
        end
    end

    if not vorhergehendeAktionGefunden and not self.eingeplanteAktionen[einzuplanendeAktion] then
        self.spaetereAktionen[einzuplanendeAktion] = AkSekundenSeitMitternacht() + zeitspanneInSekunden
        if AkPlaner.debug then print("[AkPlaner] Plane Aktion: '" .. einzuplanendeAktion.name
                .. "' in " .. zeitspanneInSekunden .. " Sekunden (um "
                .. AkSekundenSeitMitternacht() + zeitspanneInSekunden .. ")")
        end
    end
end

function planeNachAktion(eingeplanteAktionen, einzuplanendeAktion, zeitspanneInSekunden, vorgaengerAktion)
    local vorhergehendeAktionGefunden = false
    for foundAction in pairs(eingeplanteAktionen) do
        if vorgaengerAktion == foundAction then
            foundAction:planeFolgeAktion(einzuplanendeAktion, zeitspanneInSekunden)
            vorhergehendeAktionGefunden = true
        else
            -- plan in the subsequent eingeplanteAktionen of the current eingeplanteAktionen
            vorhergehendeAktionGefunden = planeNachAktion(foundAction.folgeAktionen, einzuplanendeAktion,
                zeitspanneInSekunden, vorgaengerAktion)
        end
        if (vorhergehendeAktionGefunden) then break end
    end
    return vorhergehendeAktionGefunden
end




return AkPlaner
