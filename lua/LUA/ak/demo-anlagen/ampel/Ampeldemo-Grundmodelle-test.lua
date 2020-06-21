Zugname = "#PLATZHALTER"

require("ak.core.eep.EepSimulator")

local ModuleRegistry = require("ak.core.ModuleRegistry")
local Scheduler = require("ak.scheduler.Scheduler")
local ServerController = require("ak.io.ServerController")
local TrafficLight = require("ak.road.TrafficLight")
local Crossing = require("ak.road.Crossing")
local StorageUtility = require("ak.storage.StorageUtility")
-- endregion

clearlog()
--------------------------------------------------------------------
-- Zeigt erweiterte Informationen waehrend der Initialisierung an --
--------------------------------------------------------------------
AkStartWithDebug = false

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
ModuleRegistry.debug = false
ServerController.debug = false

--------------------------------------------------------------------
-- Erste Hilfe - normalerweise nicht notwendig                    --
--------------------------------------------------------------------
-- Crossing.resetVehicles()
-------------------------------------------------------------------

Crossing.initSequences()
Crossing.debug = true
enterLane(Zugname, c1Lane8)
enterLane(Zugname, c1Lane8)
assert(c1Lane8.vehicleCount == 2, c1Lane8.anzahlFahrzeuge)
Crossing.resetVehicles()
assert(c1Lane8.vehicleCount == 0)
-------------------------------------------------------------------
local function run()
    EEPTime = EEPTime + 20
    EEPMain()
end

for _ = 1, 10 do
    print("Betritt Block")
    enterLane(Zugname, c1Lane8)
    run()
    run()
    run()
    run()
    print("Verlasse Block")
    leaveLane(Zugname, c1Lane8, true)
    run()
end
