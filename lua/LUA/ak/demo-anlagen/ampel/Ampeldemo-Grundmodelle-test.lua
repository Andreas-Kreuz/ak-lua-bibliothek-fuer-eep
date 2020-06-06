Zugname = "#PLATZHALTER"

require("ak.core.eep.AkEepFunktionen")

local Scheduler = require("ak.scheduler.Scheduler")
local TrafficLight = require("ak.road.TrafficLight")
local Crossing = require("ak.road.Crossing")
local StorageUtility = require("ak.storage.StorageUtility")
-- endregion

clearlog()
--------------------------------------------------------------------
-- Zeigt erweiterte Informationen waehrend der Initialisierung an --
--------------------------------------------------------------------
AkStartMitDebug = false

--------------------------------------------------------------------
-- Zeigt erweiterte Informationen waehrend der erste Schitte an   --
--------------------------------------------------------------------
if AkDebugLoad then print("Loading Ampeldemo-Grundmodelle-main ...") end
require("ak.demo-anlagen.ampel.Ampeldemo-Grundmodelle-main")

--------------------------------------------------------------------
-- Zeige erweiterte Informationen an                              --
--------------------------------------------------------------------
TrafficLight.debug = false
Crossing.debug = false
Crossing.showRequestsOnSignal = true
Crossing.showSequenceOnSignal = true
Crossing.showSignalIdOnSignal = false
Scheduler.debug = false
StorageUtility.debug = false

--------------------------------------------------------------------
-- Erste Hilfe - normalerweise nicht notwendig                    --
--------------------------------------------------------------------
-- Crossing.resetVehicles()





-------------------------------------------------------------------
Crossing.debug = true
enterLane(k1_r8)
enterLane(k1_r8)
assert(k1_r8.vehicleCount == 2, k1_r8.anzahlFahrzeuge)
Crossing.resetVehicles()
assert(k1_r8.vehicleCount == 0)
-------------------------------------------------------------------
local function run()
    EEPTime = EEPTime + 20
    EEPMain()
end

for _ = 1, 10 do
    print("Betritt Block")
    enterLane(k1_r8)
    run()
    run()
    run()
    run()
    print("Verlasse Block")
    leaveLane(k1_r8,true)
    run()
end
