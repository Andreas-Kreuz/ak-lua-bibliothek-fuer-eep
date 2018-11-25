read_globals = {
    "AkAktion",
    "AkPlaner",
    "AkSpeicherHilfe",
    "AkStartMitDebug",
    "AkTimeH",
    "AkTimeM",
    "AkTimeS",
    "clearlog",
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
-- 212 - unused variables
files["LUA/ak/eep"].ignore = { "212" , "131" }
files["LUA/ak/data/AkSlotNamesParser.lua"].ignore = { "212" }
files["LUA/ak/strasse/AkStrasse.lua"].ignore = { "131" }

exclude_files = {
    "LUA/ak/io/crc32lua.lua",
    "LUA/ak/io/dkjson.lua",
    "LUA/ak/io/json.lua",
}