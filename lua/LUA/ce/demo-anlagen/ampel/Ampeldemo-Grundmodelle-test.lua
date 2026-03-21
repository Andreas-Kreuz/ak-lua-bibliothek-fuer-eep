Zugname = "#PLATZHALTER"

require("ce.hub.eep.EepSimulator")

local ModuleRegistry = require("ce.hub.ModuleRegistry")
local Scheduler = require("ce.hub.scheduler.Scheduler")
local ServerExchangeCoordinator = require("ce.databridge.ServerExchangeCoordinator")
local TrafficLight = require("ce.mods.road.TrafficLight")
local Intersection = require("ce.mods.road.Intersection")
local IntersectionSettings = require("ce.mods.road.IntersectionSettings")
local StorageUtility = require("ce.hub.util.StorageUtility")
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
require("ce.demo-anlagen.ampel.Ampeldemo-Grundmodelle-main")

--------------------------------------------------------------------
-- Zeige erweiterte Informationen an                              --
--------------------------------------------------------------------
TrafficLight.debug = false
Intersection.debug = false
IntersectionSettings.showRequestsOnSignal = true
IntersectionSettings.showSequenceOnSignal = true
IntersectionSettings.showSignalIdOnSignal = false
Scheduler.debug = false
StorageUtility.debug = false
ModuleRegistry.debug = false
ServerExchangeCoordinator.debug = false

--------------------------------------------------------------------
-- Erste Hilfe - normalerweise nicht notwendig                    --
--------------------------------------------------------------------
-- Intersection.resetVehicles()
-------------------------------------------------------------------

Intersection.initSequences()
Intersection.debug = true
enterLane(Zugname, c1Lane8)
enterLane(Zugname, c1Lane8)
assert(c1Lane8.vehicleCount == 2, c1Lane8.vehicleCount)
Intersection.resetVehicles()
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
