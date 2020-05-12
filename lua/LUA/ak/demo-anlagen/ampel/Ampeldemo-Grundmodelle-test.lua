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
print("Lade Ampeldemo-Grundmodelle-main ...")
require("ak.demo-anlagen.ampel.Ampeldemo-Grundmodelle-main")

--------------------------------------------------------------------
-- Zeige erweiterte Informationen an                              --
--------------------------------------------------------------------
TrafficLight.debug = false
Crossing.debug = false
Crossing.zeigeAnforderungenAlsInfo = true
Crossing.zeigeSchaltungAlsInfo = true
Crossing.zeigeSignalIdsAllerSignale = false
Scheduler.debug = false
StorageUtility.debug = false

--------------------------------------------------------------------
-- Erste Hilfe - normalerweise nicht notwendig                    --
--------------------------------------------------------------------
-- Crossing.zaehlerZuruecksetzen()





-------------------------------------------------------------------
Crossing.debug = true
KpBetritt(k1_r8)
KpBetritt(k1_r8)
assert(k1_r8.fahrzeuge == 2, k1_r8.anzahlFahrzeuge)
Crossing.zaehlerZuruecksetzen()
assert(k1_r8.fahrzeuge == 0)
-------------------------------------------------------------------
local function run()
    EEPTime = EEPTime + 20
    EEPMain()
end

for _ = 1, 10 do
    print("Betritt Block")
    KpBetritt(k1_r8)
    run()
    run()
    run()
    run()
    print("Verlasse Block")
    KpVerlasse(k1_r8,true)
    run()
end
