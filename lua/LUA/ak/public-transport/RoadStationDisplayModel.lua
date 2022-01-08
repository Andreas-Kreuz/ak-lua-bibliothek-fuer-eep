if AkDebugLoad then print("[#Start] Loading ak.public-transport.RoadStationDisplayModel ...") end
local SimpleStructure = require("ak.public-transport.models.SimpleStructure")
local Tram_Schild_DL1 = require("ak.public-transport.models.V15NDL10027_Tram_Schild_DL1")
local BusHSInfo_RG3 = require("ak.public-transport.models.V15NRG35002_BusHSInfo_RG3")
local BusHSdfi_RG3 = require("ak.public-transport.models.V15NRG35002_BusHSdfi_RG3")
local BusHS_Tram_Info_6_RG3 = require("ak.public-transport.models.V15NRG35023_BusHS_Tram_Info_6_RG3")
local BusHS_Tram_dfi_6_RG3 = require("ak.public-transport.models.V15NRG35023_BusHS_Tram_dfi_6_RG3")

------------------------------------------------------------------------------------------
-- Klasse DisplayModel
-- Weiss, welche Signalstellung fuer rot, gelb und gruen geschaltet werden muessen.
------------------------------------------------------------------------------------------
---@class DisplayModel
---@field name string
---@field initStation function function to initialize the station
---@field displayEntries function function to display the station entries
local DisplayModel = {}
DisplayModel.allModels = {}

---
-- @param name Name of the model
-- @param displayEntries function to display a list of stationQueueEntries
function DisplayModel:new(name, initStation, displayEntries)
    assert(type(name) == "string", "Need 'name' as string")
    assert(type(initStation) == "function", "Need 'initStation' as function")
    assert(type(displayEntries) == "function", "Need 'displayEntries' as function")
    local o = {name = name, initStation = initStation, displayEntries = displayEntries}
    self.__index = self
    local x = setmetatable(o, self)
    table.insert(DisplayModel.allModels, o)
    return x
end

function DisplayModel:printName() print("[#DisplayModel] name: " .. self.name) end

function DisplayModel:print(displayStructure, stationQueueEntries)
    self.displayEntries(displayStructure, stationQueueEntries)
end

--------------------------------------------------------------------------------------------------------------------
-- Simple Structure - works with any model
--------------------------------------------------------------------------------------------------------------------
DisplayModel.SimpleStructure = DisplayModel:new(SimpleStructure.name, SimpleStructure.initStation,
                                                SimpleStructure.displayEntries)

--------------------------------------------------------------------------------------------------------------------
-- V15NDL10027 - Texturierbare Zielanzeigen für Haltestellen
--------------------------------------------------------------------------------------------------------------------
DisplayModel.Tram_Schild_DL1 = DisplayModel:new(Tram_Schild_DL1.name, Tram_Schild_DL1.initStation,
                                                Tram_Schild_DL1.displayEntries)

--------------------------------------------------------------------------------------------------------------------
-- V15NRG35002 - Buswartehaeuser in Dioramaqualitaet mit DFI
--------------------------------------------------------------------------------------------------------------------
DisplayModel.BusHSInfo_RG3 = DisplayModel:new(BusHSInfo_RG3.name, BusHSInfo_RG3.initStation,
                                              BusHSInfo_RG3.displayEntries)
DisplayModel.BusHSdfi_RG3 = DisplayModel:new(BusHSdfi_RG3.name, BusHSdfi_RG3.initStation, BusHSdfi_RG3.displayEntries)

--------------------------------------------------------------------------------------------------------------------
-- V15NRG35023 - DFI digitale Fahrgastinformation für 6 Linien
--------------------------------------------------------------------------------------------------------------------
DisplayModel.BusHS_Tram_Info_6_RG3 = DisplayModel:new(BusHS_Tram_Info_6_RG3.name, BusHS_Tram_Info_6_RG3.initStation,
                                                      BusHS_Tram_Info_6_RG3.displayEntries)
DisplayModel.BusHS_Tram_dfi_6_RG3 = DisplayModel:new(BusHS_Tram_dfi_6_RG3.name, BusHS_Tram_dfi_6_RG3.initStation,
                                                     BusHS_Tram_dfi_6_RG3.displayEntries)

return DisplayModel
