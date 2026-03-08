Zugname = "#PLATZHALTER"

require("ak.core.eep.EepSimulator")

local ModuleRegistry = require("ak.core.ModuleRegistry")
local Scheduler = require("ak.scheduler.Scheduler")
local ServerExchangeCoordinator = require("ak.io.ServerExchangeCoordinator")
local TrafficLight = require("ak.road.TrafficLight")
local Crossing = require("ak.road.Crossing")
local CrossingSetting = require("ak.road.CrossingSetting")
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
if AkDebugLoad then print("[#Start] Loading Ampeldemo-Grundmodelle-main ...") end
require("ak.demo-anlagen.ampel.Ampeldemo-Grundmodelle-main")

--------------------------------------------------------------------
-- Zeige erweiterte Informationen an                              --
--------------------------------------------------------------------
TrafficLight.debug = false
Crossing.debug = false
CrossingSetting.showRequestsOnSignal = true
CrossingSetting.showSequenceOnSignal = true
CrossingSetting.showSignalIdOnSignal = false
Scheduler.debug = false
StorageUtility.debug = false
ModuleRegistry.debug = false
ServerExchangeCoordinator.debug = false

--------------------------------------------------------------------
-- Erste Hilfe - normalerweise nicht notwendig                    --
--------------------------------------------------------------------
-- Crossing.resetVehicles()
-------------------------------------------------------------------

Crossing.initSequences()
Crossing.debug = true
enterLane(Zugname, c1Lane8)
enterLane(Zugname, c1Lane8)
assert(c1Lane8.vehicleCount == 2, c1Lane8.vehicleCount)
Crossing.resetVehicles()
assert(c1Lane8.vehicleCount == 0)
-------------------------------------------------------------------
local function run()
    EEPTime = EEPTime + 20
    EEPMain()
end

for _ = 1, 10 do
    print("[#Test] Betritt Block")
    enterLane(Zugname, c1Lane8)
    run()
    run()
    run()
    run()
    print("[#Test] Verlasse Block")
    leaveLane(Zugname, c1Lane8)
    run()
end
