-- Lade das Hauptskript
require("ce.demo-anlagen.tutorial-ampel.Andreas_Kreuz-Tutorial-Ampelkreuzung-2-main")

-- Schalte Tipp-Texte ein
local CrossingSetting = require("ce.mods.road.IntersectionSetting")
CrossingSetting.showSignalIdOnSignal = true
CrossingSetting.showSequenceOnSignal = true
CrossingSetting.showRequestsOnSignal = true

[EEPLuaData]
DS_100 = "f=2,p=Rot,q=#Opal Vitaro MEDIA MARKT|#Opal Vitaro MEDIA MARKT;001,w=0,"
DS_102 = "f=0,p=Rot,q=,w=1,"
DS_104 = "f=0,p=Rot,q=,w=1,"
DS_105 = "f=0,p=Rot,q=,w=2,"
DS_107 = "f=0,p=Rot,q=,w=1,"
DS_108 = "f=0,p=Rot,q=#B_GT6N-ER_B-Teil,w=1,"
