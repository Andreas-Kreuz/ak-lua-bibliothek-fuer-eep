clearlog()
--------------------------------------------------------------------
-- Zeigt erweiterte Informationen waehrend der Initialisierung an --
--------------------------------------------------------------------
AkStartMitDebug = false

--------------------------------------------------------------------
-- Zeigt erweiterte Informationen waehrend der erste Schitte an   --
--------------------------------------------------------------------

require("ak.demo-anlagen.ampel.Ampeldemo-Grundmodelle-main")
local AkPlaner = require("ak.planer.AkPlaner")
local AkAmpel = require("ak.strasse.AkAmpel")
local AkKreuzung = require("ak.strasse.AkKreuzung")
local AkSpeicherHilfe = require("ak.speicher.AkSpeicher")


--------------------------------------------------------------------
-- Zeige erweiterte Informationen an                              --
--------------------------------------------------------------------
AkAmpel.debug = false
AkPlaner.debug = false
AkKreuzung.debug = false
AkKreuzung.zeigeSignalIdsAllerSignale = false
AkKreuzung.zeigeAnforderungenAlsInfo = false
AkKreuzung.zeigeSchaltungAlsInfo = false
AkSpeicherHilfe.debug = false

--------------------------------------------------------------------
-- Erste Hilfe - normalerweise nicht notwendig                    --
--------------------------------------------------------------------
--AkKreuzung.zaehlerZuruecksetzen()


[EEPLuaData]
DS_101 = "f=2,p=Rot,w=4,"
DS_102 = "f=0,p=Gruen,w=2,"
DS_103 = "f=2,p=Rot,w=0,"
DS_104 = "f=0,p=Gruen,w=1,"
DS_105 = "f=1,p=Rot,w=4,"
DS_106 = "f=0,p=Gruen,w=2,"
DS_107 = "f=1,p=Rot,w=0,"
DS_108 = "f=2,p=Gelb,w=1,"
DS_121 = "f=0,p=Rot,w=0,"
DS_122 = "f=0,p=Rot,w=0,"
DS_123 = "f=0,p=Rot,w=1,"
DS_124 = "f=0,p=Rot,w=1,"
DS_125 = "f=0,p=Gruen,w=2,"
