read_globals = {
    "AkDebugLoad",
    "AkStartWithDebug",
    "EEPChangeInfoStructure",
    "EEPChangeInfoSwitch",
    "EEPGetCameraPosition",
    "EEPGetCameraRotation",
    "EEPGetCloudIntensity",
    "EEPGetFogIntensity",
    "EEPGetHailIntensity",
    "EEPGetPerspectiveCamera",
    "EEPGetRainIntensity",
    "EEPGetRollingstockItemName",
    "EEPGetRollingstockItemsCount",
    "EEPGetSignal",
    "EEPGetSignalFunction",
    "EEPGetSignalFunctions",
    "EEPGetSignalItemName",
    "EEPGetSignalTrainName",
    "EEPGetSignalTrainsCount",
    "EEPGetSnowIntensity",
    "EEPGetSwitch",
    "EEPGetTrainActive",
    "EEPGetTrainCouplingFront",
    "EEPGetTrainCouplingRear",
    "EEPGetTrainFromTrainyard",
    "EEPGetTrainLength",
    "EEPGetTrainLight",
    "EEPGetTrainRoute",
    "EEPGetTrainSpeed",
    "EEPGetTrainyardItemName",
    "EEPGetTrainyardItemStatus",
    "EEPGetTrainyardItemsCount",
    "EEPGetWindIntensity",
    "EEPGoodsGetRotation",
    "EEPGoodsGetTagText",
    "EEPGoodsGetTextureText",
    "EEPGoodsSetTagText",
    "EEPGoodsSetTextureText",
    "EEPIsTrainInTrainyard",
    "EEPIsAuxiliaryTrackReserved",
    "EEPIsControlTrackReserved",
    "EEPIsRailTrackReserved",
    "EEPIsRoadTrackReserved",
    "EEPIsTramTrackReserved",
    "EEPLoadData",
    "EEPOnTrainEnterTrainyard",
    "EEPOnTrainCoupling",
    "EEPOnTrainExitTrainyard",
    "EEPOnTrainLooseCoupling",
    "EEPPause",
    "EEPPutTrainToTrainyard",
    "EEPRailTrackGetTextureText",
    "EEPRailTrackSetTextureText",
    "EEPRegisterAuxiliaryTrack",
    "EEPRegisterControlTrack",
    "EEPRegisterRailTrack",
    "EEPRegisterRoadTrack",
    "EEPRegisterTramTrack",
    "EEPRoadTrackGetTextureText",
    "EEPRoadTrackSetTextureText",
    "EEPRollingstockGetActive",
    "EEPRollingstockGetCouplingFront",
    "EEPRollingstockGetCouplingRear",
    "EEPRollingstockGetHook",
    "EEPRollingstockGetHookGlue",
    "EEPRollingstockGetLength",
    "EEPRollingstockGetModelType",
    "EEPRollingstockGetMotor",
    "EEPRollingstockGetOrientation",
    "EEPRollingstockGetTrainName",
    "EEPRollingstockGetPosition",
    "EEPRollingstockGetSmoke",
    "EEPRollingstockGetTagText",
    "EEPRollingstockGetTextureText",
    "EEPRollingstockGetTrack",
    "EEPRollingstockGetUserCamera",
    "EEPRollingstockSetTextureText",
    "EEPRollingstockSetUserCamera",
    "EEPSaveData",
    "EEPShowInfoStructure",
    "EEPStructureGetAxis",
    "EEPStructureGetFire",
    "EEPStructureGetLight",
    "EEPStructureGetRotation",
    "EEPStructureGetSmoke",
    "EEPStructureGetTagText",
    "EEPStructureGetTextureText",
    "EEPStructureSetAxis",
    "EEPStructureSetTagText",
    "EEPStructureSetTextureText",
    "EEPSignalGetTagText",
    "EEPSignalSetTagText",
    "EEPSwitchGetTagText",
    "EEPSwitchSetTagText",
    "EEPSetPerspectiveCamera",
    "EEPSetTrainCouplingFront",
    "EEPSetTrainCouplingRear",
    "EEPSetTrainLight",
    "EEPTime",
    "EEPTimeH",
    "EEPTimeM",
    "EEPTimeS",
    "EEPTramTrackGetTextureText",
    "EEPTramTrackSetTextureText",
    "EEPVer",
    "EEPAuxiliaryTrackGetTextureText",
    "EEPAuxiliaryTrackSetTextureText",
    "EEPMain",
    "EEPWeb",
    "after_each",
    "before_each",
    "clearlog",
    "describe",
    "insulate",
    "it",
    "pending"
}

allow_defined_top = true

-- See https://luacheck.readthedocs.io/en/stable/warnings.html
-- 121 - global assignment to readonly
-- 122 - global field assignment to readonly
-- 131 - global assignment
-- 212 - unused argument
-- 631 - line is too long
files["lua/LUA/ce/hub/eep"].ignore = {"212", "131"}
files["lua/LUA/ce/demo-anlagen"].ignore = {"131"}
files["lua/LUA/ce/hub/mods/CeModule.d.lua"].ignore = {"631"}
files["lua/LUA/ce/mods/road/RoadTypes.d.lua"].ignore = {"631"}
files["lua/LUA/ce/hub/data/rollingstock/TagKeys.lua"].ignore = {"631"}
files["lua/LUA/ce/hub/data/tracks/TrackDetection.lua"].ignore = {"121", "211"}
files["lua/LUA/ce/hub/data/trains/TrainDetection.lua"].ignore = {"121", "211"}
files["lua/LUA/ce/databridge/LogOutputFileWriter.lua"].ignore = {"111", "113", "121"}
files["lua/LUA/ce/mods/transit/TransitTypes.d.lua"].ignore = {"631"}
files["lua/LUA/ce/hub/data/trains/TrainTypes.d.lua"].ignore = {"631"}
files["lua/LUA/spec/ce/hub/data/version/VersionInfo_spec.lua"].ignore = {"122"}
files["lua/LUA/spec/ce/databridge/DataStoreFileWriter_spec.lua"].ignore = {"122"}
files["lua/LUA/spec/ce/databridge/ExchangeDirRegistry_spec.lua"].ignore = {"122"}
files["lua/LUA/spec/ce/databridge/FunctionNameWriter_spec.lua"].ignore = {"122"}
files["lua/LUA/spec/ce/databridge/IncomingCommandFileReader_spec.lua"].ignore = {"122"}
files["lua/LUA/spec/ce/databridge/LogOutputFileWriter_spec.lua"].ignore = {"111", "113", "121", "122"}
files["lua/LUA/spec/ce/databridge/ServerExchangeFileIo_spec.lua"].ignore = {"122"}

exclude_files = {
    ".vscode",
    "assets",
    "docs",
    "lua/LUA/SlotNames_BH2.lua",
    "lua/LUA/ce/third-party/**",
    "lua/LUA/ce/anlagen/**",
    "lua/Resourcen/Anlagen/Andreas_Kreuz-Demo-Ampel/Andreas_Kreuz-Demoanlage-Ampel-Grundmodelle.lua",
    "lua/Resourcen/Anlagen/Andreas_Kreuz-Demo-Testen/Andreas_Kreuz-Lua-Testbeispiel.lua",
    "lua/Resourcen/Anlagen/Andreas_Kreuz-Tutorial-Ampelkreuzung/Andreas_Kreuz-Tutorial-Ampelkreuzung.lua",
    "lua/Resourcen/Anlagen/Andreas_Kreuz-Tutorial-Ampelkreuzung/Andreas_Kreuz-Tutorial-Ampelkreuzung-2.lua",
    "lua/modell-pakete",
    "scripts",
    "web-app",
    "web-server",
    "web-shared"
}
