print("Lade ak.strasse.AkStrasse ...")
print([[
############################################################################################
# require("ak.planer.AkStrasse") wird nicht mehr unterstützt!!!
# Bitte stattdessen unbedingt die notwendigen Dinge einzeln mittels zuweisen:
# local <Module> = require("<Modulname>")
############################################################################################
-- Planer
local AkPlaner = require("ak.planer.AkPlaner")
-- IO
local AkStatistik = require("ak.io.AkStatistik")
-- Strasse
local AkStrabWeiche = require("ak.strasse.AkStrabWeiche")
local AkAmpelModell = require("ak.strasse.AkAmpelModell")
local AkAchsenImmoAmpel = require("ak.strasse.AkAchsenImmoAmpel")
local AkLichtImmoAmpel = require("ak.strasse.AkLichtImmoAmpel")
local AkAmpel = require("ak.strasse.AkAmpel")
local AkRichtung = require("ak.strasse.AkRichtung")
local AkKreuzung = require("ak.strasse.AkKreuzung")
local AkKreuzungsSchaltung = require("ak.strasse.AkKreuzungsSchaltung")
-- Speicher
local AkSpeicherHilfe = require("ak.speicher.AkSpeicher")
############################################################################################
]])

-- LEGACY SUPPORT -- ALL THESE REQUIRES SHOULD BE local !!!
AkPlaner = require("ak.planer.AkPlaner")
AkAchsenImmoAmpel = require("ak.strasse.AkAchsenImmoAmpel")
AkAmpel = require("ak.strasse.AkAmpel")
AkAmpelModell = require("ak.strasse.AkAmpelModell")
AkKreuzung = require("ak.strasse.AkKreuzung")
AkKreuzungsSchaltung = require("ak.strasse.AkKreuzungsSchaltung")
AkLichtImmoAmpel = require("ak.strasse.AkLichtImmoAmpel")
AkRichtung = require("ak.strasse.AkRichtung")
AkStrabWeiche = require("ak.strasse.AkStrabWeiche")
AkSpeicherHilfe = require("ak.speicher.AkSpeicher")
require("ak.text.AkAusgabe")

return AkStrasse