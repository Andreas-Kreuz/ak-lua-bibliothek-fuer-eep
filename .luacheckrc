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
files["lua/LUA/ak/core/eep"].ignore = {"212", "131"}
files["lua/LUA/ak/demo-anlagen"].ignore = {"131"}
files["lua/LUA/ak/data/AkSlotNamesParser.lua"].ignore = {"212"}
files["lua/LUA/ak/core/LuaModule.d.lua"].ignore = {"631"}
files["lua/LUA/ak/road/Road.lua"].ignore = {"131"}
files["lua/LUA/ak/road/RoadTypes.d.lua"].ignore = {"631"}
files["lua/LUA/ak/data/TrackCollector.lua"].ignore = {"121", "211"}
files["lua/LUA/ak/data/TrainDetection.lua"].ignore = {"121", "211"}
files["lua/LUA/ak/io/LogOutputFileWriter.lua"].ignore = {"121"}
files["lua/LUA/ak/public-transport/PublicTransportTypes.d.lua"].ignore = {"631"}
files["lua/LUA/ak/train/TrainTypes.d.lua"].ignore = {"631"}
files["lua/LUA/spec/ak/core/VersionInfo_spec.lua"].ignore = {"122"}
files["lua/LUA/spec/ak/io/DataStoreFileWriter_spec.lua"].ignore = {"122"}
files["lua/LUA/spec/ak/io/ExchangeDirRegistry_spec.lua"].ignore = {"122"}
files["lua/LUA/spec/ak/io/FunctionNameWriter_spec.lua"].ignore = {"122"}
files["lua/LUA/spec/ak/io/IncomingCommandFileReader_spec.lua"].ignore = {"122"}
files["lua/LUA/spec/ak/io/LogOutputFileWriter_spec.lua"].ignore = {"121", "122"}
files["lua/LUA/spec/ak/io/ServerExchangeFileIo_spec.lua"].ignore = {"122"}

exclude_files = {
    ".vscode",
    "assets",
    "docs",
    "lua/LUA/SlotNames_BH2.lua",
    "lua/LUA/ak/anlagen/**",
    "lua/LUA/ak/io/crc32lua.lua",
    "lua/LUA/ak/io/dkjson.lua",
    "lua/LUA/ak/io/json.lua",
    "lua/LUA/ak/third-party/**",
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
