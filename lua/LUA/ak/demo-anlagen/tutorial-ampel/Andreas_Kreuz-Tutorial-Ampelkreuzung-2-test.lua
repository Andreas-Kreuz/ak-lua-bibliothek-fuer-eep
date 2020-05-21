if AkDebugLoad then print("Loading AkEepFunctions ...") end
local EepSimulator = require("ak.core.eep.AkEepFunktionen")

local Scheduler = require("ak.scheduler.Scheduler")
local TrafficLight = require("ak.road.TrafficLight")
local Crossing = require("ak.road.Crossing")
local StorageUtility = require("ak.storage.StorageUtility")

clearlog()
--------------------------------------------------------------------
-- Zeigt erweiterte Informationen waehrend der Initialisierung an --
--------------------------------------------------------------------
AkStartMitDebug = false

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
Crossing.zeigeSignalIdsAllerSignale = false
Crossing.zeigeAnforderungenAlsInfo = true
Crossing.zeigeSchaltungAlsInfo = true

--------------------------------------------------------------------
-- Erste Hilfe - normalerweise nicht notwendig                    --
--------------------------------------------------------------------
-- Crossing.zaehlerZuruecksetzen()


-------------------------------------------------------------------
--Crossing.debug = true
-------------------------------------------------------------------
local function run()
    EEPTime = EEPTime + 20
    EEPMain()
end

EepSimulator.queueTrainOnSignal(14, "#Zug1")
EEPSetTrainRoute("#Zug1", "Meine Route 1")

assert(true == os.verwendeZaehlAmpeln)
os:checkSignalRequests()
assert(true == os.anforderungAnSignal)

for i = 1, 10 do
    print(i)
    run()
    run()
    run()
    run()
    run()
end
