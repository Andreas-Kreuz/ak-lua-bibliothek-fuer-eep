---@meta

---@class SwitchDto
---@field id number
---@field position number
---@field tag string

---@class SignalDto
---@field id number
---@field position number
---@field tag string
---@field waitingVehiclesCount number

---@class WaitingOnSignalDto
---@field id string
---@field signalId number
---@field waitingPosition number
---@field vehicleName string
---@field waitingCount number

---@class StructureDto
---@field id string
---@field name string
---@field pos_x number
---@field pos_y number
---@field pos_z number
---@field rot_x number
---@field rot_y number
---@field rot_z number
---@field modelType number
---@field modelTypeText string
---@field tag string
---@field light boolean
---@field smoke boolean
---@field fire boolean

---@class TimeDto
---@field id string
---@field name string
---@field timeComplete number
---@field timeH number
---@field timeM number
---@field timeS number

---@class DataSlotDto
---@field id number
---@field name string|nil
---@field data string|nil

---@class ModuleDto
---@field id string
---@field name string
---@field enabled boolean

---@class VersionDto
---@field id string
---@field name string
---@field eepVersion string
---@field luaVersion string
---@field singleVersion string

---@class RuntimeDto
---@field id string
---@field count number
---@field time number
---@field lastTime number

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
---@field intersectionId string
---@field name string
---@field prio number

---@class IntersectionTrafficLightAxisStructureDto
---@field structureName string
---@field axisName string
---@field positionDefault number
---@field positionRed number
---@field positionGreen number
---@field positionYellow number
---@field positionPedestrian number
---@field positionRedYellow number

---@class IntersectionTrafficLightStructureDto
---@field structureRed string
---@field structureGreen string
---@field structureYellow string
---@field structureRequest string|nil

---@class IntersectionTrafficLightDto
---@field id number
---@field signalId number
---@field modelId string
---@field currentPhase any
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

---@class PublicTransportStationDto
---@field id string

---@class PublicTransportLineSegmentStationDto
---@field station table
---@field timeToStation number

---@class PublicTransportLineSegmentDto
---@field id string
---@field destination string
---@field routeName string
---@field lineNr string
---@field stations PublicTransportLineSegmentStationDto[]

---@class PublicTransportLineDto
---@field id string
---@field nr string
---@field trafficType string
---@field lineSegments PublicTransportLineSegmentDto[]

---@alias PublicTransportLineNameDto PublicTransportLineDto

---@class PublicTransportModuleSettingDto
---@field category string
---@field name string
---@field description string
---@field type string
---@field value boolean
---@field eepFunction string

---@class TrainDto
---@field id string
---@field route string
---@field rollingStockCount number
---@field length number
---@field line string|nil
---@field destination string|nil
---@field direction string|nil
---@field trackType string|nil
---@field movesForward boolean
---@field speed number
---@field occupiedTacks table

---@class RollingStockDto
---@field id string
---@field name string
---@field trainName string
---@field positionInTrain number
---@field couplingFront number
---@field couplingRear number
---@field length number
---@field propelled boolean
---@field modelType number
---@field modelTypeText string
---@field tag string
---@field nr string|nil
---@field trackId number
---@field trackDistance number
---@field trackDirection number
---@field trackSystem number
---@field trackType string|nil
---@field posX number
---@field posY number
---@field posZ number
---@field mileage number

---@class TrackDto
---@field id number
