read_globals = {
    "AkAktion",
    "AkPlaner",
    "AkSpeicherHilfe",
    "AkStartMitDebug",
    "AkTimeH",
    "AkTimeM",
    "AkTimeS",
    "clearlog",
    "EEPPause",
    "EEPVer",
    "EEPChangeInfoSignal",
    "EEPChangeInfoSwitch",
    "EEPStructureGetLight",
    "EEPGetSignal",
    "EEPGetSwitch",
    "EEPGetTrainAxis",
    "EEPRegisterRailTrack",
    "EEPRegisterRoadTrack",
    "EEPRegisterTramTrack",
    "EEPRegisterSwitch",
    "EEPRegisterSignal",
    "EEPStructureSetLight",
    "EEPSetSignal",
    "EEPSetSwitch",
    "EEPSetTrainAxis",
    "EEPSetTrainRoute",
    "EEPShowInfoSignal",
    "EEPShowInfoSwitch",
    "Zugname",
}

allow_defined_top = true

-- See https://luacheck.readthedocs.io/en/stable/warnings.html
-- 131 - global assignment
-- 212 - unused argument
files["lua/LUA/ak/core/eep"].ignore = { "212" , "131" }
files["lua/LUA/ak/data/AkSlotNamesParser.lua"].ignore = { "212" }
files["lua/LUA/ak/strasse/AkStrasse.lua"].ignore = { "131" }

exclude_files = {
    "lua/LUA/ak/io/crc32lua.lua",
    "lua/LUA/ak/io/dkjson.lua",
    "lua/LUA/ak/io/json.lua",
    "lua/LUA/ak/anlagen/**",
    "lua/LUA/SlotNames_BH2.lua",
}
