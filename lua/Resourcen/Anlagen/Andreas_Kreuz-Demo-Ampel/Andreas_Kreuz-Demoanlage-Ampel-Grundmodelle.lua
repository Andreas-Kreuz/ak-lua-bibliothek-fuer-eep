clearlog()
--------------------------------------------------------------------
-- Zeigt erweiterte Informationen waehrend der Initialisierung an --
--------------------------------------------------------------------
AkStartMitDebug = false

--------------------------------------------------------------------
-- Lädt das eigentliche Skript                                    --
--------------------------------------------------------------------
require("ak.demo-anlagen.ampel.Ampeldemo-Grundmodelle-main")

--------------------------------------------------------------------
-- Zeigt erweiterte Informationen waehrend der erste Schitte an   --
--------------------------------------------------------------------
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
Crossing.showSignalIdOnSignal = false
Crossing.showRequestsOnSignal = false
Crossing.showSequenceOnSignal = false
StorageUtility.debug = false

--------------------------------------------------------------------
-- Erste Hilfe - normalerweise nicht notwendig                    --
--------------------------------------------------------------------
-- Crossing.resetVehicles()


[EEPLuaData]
DS_101 = "f=1,p=Rot,q=#Solaris Urbino 12 gelb (v8);001,w=2,"
DS_102 = "f=1,p=Rot,q=#Solaris Urbino 12 gelb (v8);018,w=0,"
DS_103 = "f=2,p=Rot,q=#Solaris Urbino 12 gelb (v8);019|#Solaris Urbino 12 gelb (v8);002,w=3,"
DS_104 = "f=1,p=Rot,q=#Solaris Urbino 12 gelb (v8);004,w=1,"
DS_105 = "f=0,p=Rot,q=,w=2,"
DS_106 = "f=1,p=Rot,q=#Solaris Urbino 12 gelb (v8);008,w=0,"
DS_107 = "f=2,p=Rot,q=#Solaris Urbino 12 gelb (v8);022|#Solaris Urbino 12 gelb (v8);021,w=3,"
DS_108 = "f=1,p=Rot,q=#Solaris Urbino 12 gelb (v8);009,w=1,"
DS_121 = "f=0,p=Rot,q=,w=2,"
DS_122 = "f=0,p=Rot,q=,w=2,"
DS_123 = "f=0,p=Rot,q=,w=0,"
DS_124 = "f=0,p=Rot,q=,w=0,"
DS_125 = "f=0,p=Rot,q=,w=1,"
