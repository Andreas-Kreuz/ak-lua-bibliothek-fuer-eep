print("Lade ak.road.Road ...")
print(
    [[
############################################################################################
# require("ak.scheduler.Road") wird nicht mehr unterstützt!!!
# Bitte stattdessen unbedingt die notwendigen Dinge einzeln mittels zuweisen:
# local <Module> = require("<Modulname>")
############################################################################################
-- Strasse
local TramSwitch = require("ak.road.TramSwitch")
local TrafficLightModel = require("ak.road.TrafficLightModel")
local AxisStructureTrafficLight = require("ak.road.AxisStructureTrafficLight")
local LightStructureTrafficLight = require("ak.road.LightStructureTrafficLight")
local TrafficLight = require("ak.road.TrafficLight")
local Lane = require("ak.road.Lane")
local Crossing = require("ak.road.Crossing")
local CrossingCircuit = require("ak.road.CrossingCircuit")
-- Speicher
local StorageUtility = require("ak.storage.StorageUtility")
local fmt = require("ak.core.eep.AkTippTextFormat")
############################################################################################
]]
)

-- LEGACY SUPPORT -- ALL THESE REQUIRES SHOULD BE local !!!
Scheduler = require("ak.scheduler.Scheduler")
AxisStructureTrafficLight = require("ak.road.AxisStructureTrafficLight")
TrafficLight = require("ak.road.TrafficLight")
TrafficLightModel = require("ak.road.TrafficLightModel")
Crossing = require("ak.road.Crossing")
CrossingCircuit = require("ak.road.CrossingCircuit")
LightStructureTrafficLight = require("ak.road.LightStructureTrafficLight")
Lane = require("ak.road.Lane")
TramSwitch = require("ak.road.TramSwitch")
StorageUtility = require("ak.storage.StorageUtility")

-- return Road
