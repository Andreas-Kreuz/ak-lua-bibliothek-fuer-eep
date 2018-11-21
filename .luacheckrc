read_globals = {
    "AkAktion",
    "AkPlaner",
    "AkSpeicherHilfe",
    "AkStartMitDebug",
    "AkTimeH",
    "AkTimeM",
    "AkTimeS",
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
    "EEPShowInfoSignal",
    "EEPShowInfoSwitch",
    "FAHRZEUG_INITIALISIERE",
}

allow_defined_top = true
files["LUA/ak/eep"].ignore = {"212","131"}

exclude_files = {
    "LUA/ak/io/dkjson.lua",
    "LUA/ak/io/json.lua",
}