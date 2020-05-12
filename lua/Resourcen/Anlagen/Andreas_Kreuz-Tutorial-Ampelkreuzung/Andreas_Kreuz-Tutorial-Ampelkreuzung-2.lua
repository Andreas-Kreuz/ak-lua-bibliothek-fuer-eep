local Crossing = require("ak.road.Crossing")
require("ak.demo-anlagen.tutorial-ampel.Andreas_Kreuz-Tutorial-Ampelkreuzung-2-main")

-- Hier kommt der Code
Crossing.zeigeSignalIdsAllerSignale = true
Crossing.zeigeSchaltungAlsInfo = true
Crossing.zeigeAnforderungenAlsInfo = true
[EEPLuaData]
DS_100 = "f=2,p=Rot,w=0,"
DS_102 = "f=0,p=Rot,w=2,"
DS_104 = "f=0,p=Rot,w=2,"
DS_105 = "f=0,p=Rot,w=3,"
DS_107 = "f=0,p=Rot,w=2,"
DS_108 = "f=0,p=Rot,w=2,"
