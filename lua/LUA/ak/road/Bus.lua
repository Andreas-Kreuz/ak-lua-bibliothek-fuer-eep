if AkDebugLoad then print("[#Start] Loading Bus ...") end

-----------------------
-- Bushaltestellen
-----------------------
---@class Bus
Bus = {}

--- Oeffnet die Tueren eines Busses (Fahrzeugverband)
-- @param bus Fahrzeugverband
--
function Bus.openDoors(bus)
    assert(bus, "bus wurde nicht angegeben.")
    -- Ikarus Busse und andere?
    EEPSetTrainAxis(bus, "Tuer1", 100)
    if (math.random(0, 1) > 0) then EEPSetTrainAxis(bus, "Tuer2", 100) end
    if (math.random(0, 1) > 0) then EEPSetTrainAxis(bus, "Tuer3", 100) end
    if (math.random(0, 1) > 0) then EEPSetTrainAxis(bus, "Tuer4", 100) end
end

--- Schliesst die Tueren eines Busses (Fahrzeugverband)
-- @param bus Fahrzeugverband
--
function Bus.closeDoors(bus)
    assert(bus, "bus wurde nicht angegeben.")
    -- Ikarus Busse und andere?
    EEPSetTrainAxis(bus, "Tuer1", 0)
    EEPSetTrainAxis(bus, "Tuer2", 0)
    EEPSetTrainAxis(bus, "Tuer3", 0)
    EEPSetTrainAxis(bus, "Tuer4", 0)
end

--- Schaltet den Fahrer und die Fahrgaeste ein
-- @param fahrzeugverband
--
function Bus.initialisiere(fahrzeugverband)
    EEPSetTrainAxis(fahrzeugverband, "Fahrer", 100)
    EEPSetTrainAxis(fahrzeugverband, "Fahrgast", 100)
end

-- luacheck: push ignore FAHRZEUG_INITIALISIERE
--- Funktion fuer den Aufruf direkt in EEP
-- @param fahrzeug wird von EEP automatisch gefuellt
--
function FAHRZEUG_INITIALISIERE(fahrzeug) Bus.initialisiere(fahrzeug) end
-- luacheck: pop
