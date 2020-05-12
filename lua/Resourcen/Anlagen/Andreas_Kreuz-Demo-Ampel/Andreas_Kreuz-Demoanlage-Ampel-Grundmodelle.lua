clearlog()
--------------------------------------------------------------------
-- Zeigt erweiterte Informationen waehrend der Initialisierung an --
--------------------------------------------------------------------
AkStartMitDebug = false

--------------------------------------------------------------------
-- Zeigt erweiterte Informationen waehrend der erste Schitte an   --
--------------------------------------------------------------------

require("ak.demo-anlagen.ampel.Ampeldemo-Grundmodelle-main")
local Scheduler = require("ak.scheduler.Scheduler")
local TrafficLight = require("ak.road.TrafficLight")
local Crossing = require("ak.road.Crossing")
local StorageUtility = require("ak.storage.StorageUtility")


--------------------------------------------------------------------
-- Zeige erweiterte Informationen an                              --
--------------------------------------------------------------------
TrafficLight.debug = false
Scheduler.debug = false
Crossing.debug = false
Crossing.zeigeSignalIdsAllerSignale = false
Crossing.zeigeAnforderungenAlsInfo = false
Crossing.zeigeSchaltungAlsInfo = false
StorageUtility.debug = false

--------------------------------------------------------------------
-- Erste Hilfe - normalerweise nicht notwendig                    --
--------------------------------------------------------------------
--Crossing.zaehlerZuruecksetzen()


[EEPLuaData]
DS_101 = "f=2,p=Rot,w=5,"
DS_102 = "f=0,p=Rot,w=3,"
DS_103 = "f=3,p=Rot,w=0,"
DS_104 = "f=0,p=Rot,w=2,"
DS_105 = "f=1,p=Rot,w=5,"
DS_106 = "f=1,p=Rot,w=3,"
DS_107 = "f=2,p=Rot,w=0,"
DS_108 = "f=2,p=Rot,w=2,"
DS_121 = "f=0,p=Rot,w=1,"
DS_122 = "f=0,p=Rot,w=1,"
DS_123 = "f=0,p=Rot,w=2,"
DS_124 = "f=0,p=Rot,w=2,"
DS_125 = "f=0,p=Rot,w=0,"
