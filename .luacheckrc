read_globals = {
    "AkAktion",
    "Scheduler",
    "AkSpeicherHilfe",
    "AkStartMitDebug",
    "AkTimeH",
    "AkTimeM",
    "AkTimeS",
    "EEPChangeInfoSignal",
    "EEPChangeInfoSwitch",
    "EEPGetSignal",
    "EEPGetSwitch",
    "EEPGetTrainAxis",
    "EEPOnTrainCoupling",
    "EEPOnTrainExitTrainyard",
    "EEPOnTrainLooseCoupling",
    "EEPPause",
    "EEPRegisterRailTrack",
    "EEPRegisterRoadTrack",
    "EEPRegisterSignal",
    "EEPRegisterSwitch",
    "EEPRegisterTramTrack",
    "EEPSetSignal",
    "EEPSetSwitch",
    "EEPSetTrainAxis",
    "EEPSetTrainRoute",
    "EEPShowInfoSignal",
    "EEPShowInfoSwitch",
    "EEPStructureGetLight",
    "EEPStructureSetLight",
    "EEPVer",
    "Zugname",
    "clearlog",
}

allow_defined_top = true

-- See https://luacheck.readthedocs.io/en/stable/warnings.html
-- 121 - global assignment to readonly
-- 131 - global assignment
-- 212 - unused argument
files["lua/LUA/ak/core/eep"].ignore = { "212" , "131" }
files["lua/LUA/ak/data/AkSlotNamesParser.lua"].ignore = { "212" }
files["lua/LUA/ak/strasse/Road.lua"].ignore = { "131" }
files["lua/LUA/ak/data/TrackCollector.lua"].ignore = { "121" }

exclude_files = {
    "lua/LUA/ak/io/crc32lua.lua",
    "lua/LUA/ak/io/dkjson.lua",
    "lua/LUA/ak/io/json.lua",
    "lua/LUA/ak/anlagen/**",
    "lua/LUA/SlotNames_BH2.lua",
}
