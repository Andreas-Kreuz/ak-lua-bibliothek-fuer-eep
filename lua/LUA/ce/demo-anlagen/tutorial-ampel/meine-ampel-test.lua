if AkDebugLoad then print("[#Start] Loading AkEepFunctions ...") end
require("ce.hub.eep.EepSimulator")

local Scheduler = require("ce.hub.scheduler.Scheduler")
local TrafficLight = require("ce.mods.road.TrafficLight")
local Crossing = require("ce.mods.road.Crossing")
local CrossingSettings = require("ce.mods.road.CrossingSettings")
local StorageUtility = require("ce.hub.util.StorageUtility")

clearlog()
--------------------------------------------------------------------
-- Zeigt erweiterte Informationen waehrend der Initialisierung an --
--------------------------------------------------------------------
AkStartWithDebug = false

-- Ampeln für die Straßenbahn nutzen die Lichtfunktion der einzelnen Immobilien
EEPStructureSetLight("#29_Straba Signal Halt", false)      -- rot
EEPStructureSetLight("#28_Straba Signal geradeaus", false) -- gruen
EEPStructureSetLight("#27_Straba Signal anhalten", false)  -- gelb
EEPStructureSetLight("#26_Straba Signal A", false)         -- Anforderung
EEPStructureSetLight("#32_Straba Signal Halt", false)      -- rot
EEPStructureSetLight("#30_Straba Signal geradeaus", false) -- gruen
EEPStructureSetLight("#31_Straba Signal anhalten", false)  -- gelb
EEPStructureSetLight("#33_Straba Signal A", false)         -- Anforderung

--------------------------------------------------------------------
-- Zeigt erweiterte Informationen waehrend der erste Schitte an   --
--------------------------------------------------------------------
if AkDebugLoad then print("[#Start] Loading ce.demo-anlagen.tutorial-ampel.meine-ampel-main ...") end
require("ce.demo-anlagen.tutorial-ampel.meine-ampel-main")

--------------------------------------------------------------------
-- Zeige erweiterte Informationen an                              --
--------------------------------------------------------------------
Scheduler.debug = true
StorageUtility.debug = true
TrafficLight.debug = false
Crossing.debug = false
CrossingSettings.showSignalIdOnSignal = false
CrossingSettings.showRequestsOnSignal = true
CrossingSettings.showSequenceOnSignal = true

--------------------------------------------------------------------
-- Erste Hilfe - normalerweise nicht notwendig                    --
--------------------------------------------------------------------
-- Crossing.resetVehicles()

-------------------------------------------------------------------
-- Crossing.debug = true
-------------------------------------------------------------------
local function run()
    EEPTime = EEPTime + 20
    EEPMain()
end

-- EepSimulator.simulateQueueTrainOnSignal(14, "#Zug1")
-- EEPSetTrainRoute("#Zug1", "Meine Route 1")

-- assert(true == os.signalUsedForRequest)
-- os:resetQueueFromSignal()
-- assert(1 == os.queue:size())

for i = 1, 10 do
    print(i)
    run()
    run()
    run()
    run()
    run()
end
