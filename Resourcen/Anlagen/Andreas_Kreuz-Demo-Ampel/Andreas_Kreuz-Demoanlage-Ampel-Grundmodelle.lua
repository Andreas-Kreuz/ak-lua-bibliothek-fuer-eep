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
AkPlaner.debug = false
AkSpeicherHilfe.debug = false
AkAmpel.debug = false
AkKreuzung.debug = false
AkKreuzung.showAnforderungenAlsInfo = false
AkKreuzung.showSchaltungAlsInfo = false

--------------------------------------------------------------------
-- Erste Hilfe - normalerweise nicht notwendig                    --
--------------------------------------------------------------------
-- AkKreuzung.zaehlerZuruecksetzen()

[EEPLuaData]
DS_101 = "f=1,p=Rot,w=3,"
DS_102 = "f=0,p=Gruen,w=1,"
DS_103 = "f=3,p=Gruen,w=0,"
DS_104 = "f=1,p=Rot,w=2,"
DS_105 = "f=2,p=Rot,w=3,"
DS_106 = "f=0,p=Gruen,w=1,"
DS_107 = "f=3,p=Gruen,w=0,"
DS_108 = "f=1,p=Rot,w=2,"
DS_121 = "f=0,p=Rot,w=0,"
DS_122 = "f=0,p=Rot,w=0,"
DS_123 = "f=0,p=Gruen,w=1,"
DS_124 = "f=0,p=Gruen,w=1,"
DS_125 = "f=0,p=Rot,w=2,"
