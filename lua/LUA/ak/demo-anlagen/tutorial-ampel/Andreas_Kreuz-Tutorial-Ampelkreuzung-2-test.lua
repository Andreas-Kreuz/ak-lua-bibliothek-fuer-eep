if AkDebugLoad then print("Loading AkEepFunctions ...") end
local EepSimulator = require("ak.core.eep.EepSimulator")

local Scheduler = require("ak.scheduler.Scheduler")
local TrafficLight = require("ak.road.TrafficLight")
local Crossing = require("ak.road.Crossing")
local StorageUtility = require("ak.storage.StorageUtility")

clearlog()
--------------------------------------------------------------------
-- Zeigt erweiterte Informationen waehrend der Initialisierung an --
--------------------------------------------------------------------
AkStartMitDebug = false

-- Ampeln für die Straßenbahn nutzen die Lichtfunktion der einzelnen Immobilien
EEPStructureSetLight("#29_Straba Signal Halt", false) --      rot
EEPStructureSetLight("#28_Straba Signal geradeaus", false) -- gruen
EEPStructureSetLight("#27_Straba Signal anhalten", false) --  gelb
EEPStructureSetLight("#26_Straba Signal A", false) --         Anforderung
EEPStructureSetLight("#32_Straba Signal Halt", false) --      rot
EEPStructureSetLight("#30_Straba Signal geradeaus", false) -- gruen
EEPStructureSetLight("#31_Straba Signal anhalten", false) --  gelb
EEPStructureSetLight("#33_Straba Signal A", false) --         Anforderung

--------------------------------------------------------------------
-- Zeigt erweiterte Informationen waehrend der erste Schitte an   --
--------------------------------------------------------------------
if AkDebugLoad then print("Loading ak.demo-anlagen.tutorial-ampel.Andreas_Kreuz-Tutorial-Ampelkreuzung-2-main ...") end
require("ak.demo-anlagen.tutorial-ampel.Andreas_Kreuz-Tutorial-Ampelkreuzung-2-main")

--------------------------------------------------------------------
-- Zeige erweiterte Informationen an                              --
--------------------------------------------------------------------
Scheduler.debug = true
StorageUtility.debug = true
TrafficLight.debug = false
Crossing.debug = false
Crossing.showSignalIdOnSignal = false
Crossing.showRequestsOnSignal = true
Crossing.showSequenceOnSignal = true

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

EepSimulator.queueTrainOnSignal(14, "#Zug1")
EEPSetTrainRoute("#Zug1", "Meine Route 1")

assert(true == os.signalUsedForRequest)
os:resetQueueFromSignal()
assert(1 == os.queue:size())

for i = 1, 10 do
    print(i)
    run()
    run()
    run()
    run()
    run()
end
