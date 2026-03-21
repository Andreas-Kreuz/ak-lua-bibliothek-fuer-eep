---@meta

---@class IntersectionDto
---@field id number
---@field name string
---@field currentSwitching string|nil
---@field manualSwitching string|nil
---@field nextSwitching string|nil
---@field ready boolean
---@field timeForGreen number
---@field staticCams table

---@class IntersectionLaneDto
---@field id string
---@field intersectionId number
---@field name string
---@field phase string
---@field vehicleMultiplier number
---@field eepSaveId number
---@field type string
---@field countType string
---@field waitingTrains table
---@field waitingForGreenCyclesCount number
---@field directions table
---@field switchings table
---@field tracks table

---@class IntersectionSwitchingDto
---@field id string
---@field intersectionId string|number
---@field name string
---@field prio number

---@class IntersectionTrafficLightStructureDto
---@field structureRed string|nil
---@field structureGreen string|nil
---@field structureYellow string|nil
---@field structureRequest string|nil

---@class IntersectionTrafficLightAxisStructureDto
---@field structureName string
---@field axisName string
---@field positionDefault number
---@field positionRed number|nil
---@field positionGreen number|nil
---@field positionYellow number|nil
---@field positionPedestrian number|nil
---@field positionRedYellow number|nil

---@class IntersectionTrafficLightDto
---@field id number
---@field signalId number
---@field modelId string
---@field currentPhase string
---@field intersectionId number
---@field lightStructures table<string, IntersectionTrafficLightStructureDto>
---@field axisStructures IntersectionTrafficLightAxisStructureDto[]

---@class IntersectionModuleSettingDto
---@field category string
---@field name string
---@field description string
---@field type string
---@field value boolean
---@field eepFunction string

---@class SignalTypeDefinitionPositionsDto
---@field positionRed number
---@field positionGreen number
---@field positionYellow number
---@field positionRedYellow number
---@field positionPedestrians number
---@field positionOff number
---@field positionOffBlinking number

---@class SignalTypeDefinitionDto
---@field id string
---@field name string
---@field type string
---@field positions SignalTypeDefinitionPositionsDto

---@class RoadDtoFactory
---@field createIntersectionDto fun(intersection: table):string,string,string|number,IntersectionDto
---@field createIntersectionDtoList fun(intersections: table):string,string,table
---@field createIntersectionLaneDto fun(lane: table):string,string,string|number,IntersectionLaneDto
---@field createIntersectionLaneDtoList fun(lanes: table):string,string,table
---@field createIntersectionSwitchingDto fun(switching: table):string,string,string|number,IntersectionSwitchingDto
---@field createIntersectionSwitchingDtoList fun(switchings: table):string,string,table
---@field createIntersectionTrafficLightDto fun(
---    trafficLight: table
---):string,string,string|number,IntersectionTrafficLightDto
---@field createIntersectionTrafficLightDtoList fun(trafficLights: table):string,string,table
---@field createIntersectionModuleSettingDto fun(
---    setting: table
---):string,string,string|number,IntersectionModuleSettingDto
---@field createIntersectionModuleSettingDtoList fun(settings: table):string,string,table

---@class TrafficLightModelDtoFactory
---@field createSignalTypeDefinitionDto fun(definition: table):string,string,string|number,SignalTypeDefinitionDto
---@field createSignalTypeDefinitionDtoList fun(definitions: table):string,string,table
