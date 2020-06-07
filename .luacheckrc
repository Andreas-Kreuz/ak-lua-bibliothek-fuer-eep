read_globals = {
    "AkDebugLoad",
    "EEPChangeInfoStructure",
    "EEPGetRollingstockItemName",
    "EEPGetRollingstockItemsCount",
    "EEPGetSignal",
    "EEPGetSignalTrainName",
    "EEPGetSignalTrainsCount",
    "EEPGetSwitch",
    "EEPGetTrainLength",
    "EEPGetTrainRoute",
    "EEPGetTrainSpeed",
    "EEPIsAuxiliaryTrackReserved",
    "EEPIsControlTrackReserved",
    "EEPIsRailTrackReserved",
    "EEPIsRoadTrackReserved",
    "EEPIsTramTrackReserved",
    "EEPLoadData",
    "EEPOnTrainCoupling",
    "EEPOnTrainExitTrainyard",
    "EEPOnTrainLooseCoupling",
    "EEPPause",
    "EEPRegisterAuxiliaryTrack",
    "EEPRegisterControlTrack",
    "EEPRegisterRailTrack",
    "EEPRegisterRoadTrack",
    "EEPRegisterTramTrack",
    "EEPRollingstockGetCouplingFront",
    "EEPRollingstockGetCouplingRear",
    "EEPRollingstockGetLength",
    "EEPRollingstockGetModelType",
    "EEPRollingstockGetMotor",
    "EEPRollingstockGetPosition",
    "EEPRollingstockGetTagText",
    "EEPRollingstockGetTrack",
    "EEPSaveData",
    "EEPShowInfoStructure",
    "EEPStructureGetAxis",
    "EEPStructureGetFire",
    "EEPStructureGetLight",
    "EEPStructureGetSmoke",
    "EEPStructureSetAxis",
    "EEPTime",
    "EEPTimeH",
    "EEPTimeM",
    "EEPTimeS",
    "EEPVer",
    "after_each",
    "before_each",
    "clearlog",
    "describe",
    "insulate",
    "it",
    "pending",
}

allow_defined_top = true

-- See https://luacheck.readthedocs.io/en/stable/warnings.html
-- 121 - global assignment to readonly
-- 131 - global assignment
-- 212 - unused argument
files["lua/LUA/ak/core/eep"].ignore = { "212" , "131" }
files["lua/LUA/ak/demo-anlagen"].ignore = { "131" }
files["lua/LUA/ak/data/AkSlotNamesParser.lua"].ignore = { "212" }
files["lua/LUA/ak/strasse/Road.lua"].ignore = { "131" }
files["lua/LUA/ak/data/TrackCollector.lua"].ignore = { "121" }

exclude_files = {
    "lua/LUA/ak/io/crc32lua.lua",
    "lua/LUA/ak/io/dkjson.lua",
    "lua/LUA/ak/io/json.lua",
    "lua/LUA/ak/anlagen/**",
    "lua/LUA/SlotNames_BH2.lua",
    "lua/Resourcen/**/*.lua",
}
