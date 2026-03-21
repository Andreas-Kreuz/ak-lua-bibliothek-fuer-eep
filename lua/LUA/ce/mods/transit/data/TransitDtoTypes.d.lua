---@meta

---@class TransitStationDto
---@field id string

---@class TransitLineSegmentStationDto
---@field station table
---@field timeToStation number|nil

---@class TransitLineSegmentDto
---@field id string
---@field destination string
---@field routeName string
---@field lineNr string|nil
---@field stations TransitLineSegmentStationDto[]

---@class TransitLineDto
---@field id string
---@field nr string
---@field trafficType string
---@field lineSegments TransitLineSegmentDto[]

---@class TransitModuleSettingDto
---@field category string
---@field name string
---@field description string
---@field type string
---@field value boolean
---@field eepFunction string

---@class TransitDtoFactory
---@field createTransitStationDto fun(station: table):string,string,string|number,TransitStationDto
---@field createTransitStationDtoList fun(stations: table):string,string,table
---@field createTransitLineDto fun(line: Line|table):string,string,string|number,TransitLineDto
---@field createTransitLineDtoList fun(lines: table):string,string,table
---@field createTransitModuleSettingDto fun(
---    setting: table
---):string,string,string|number,TransitModuleSettingDto
---@field createTransitModuleSettingDtoList fun(settings: table):string,string,table
---@field createTransitLineNameDto fun(line: Line|table):string,string,string|number,TransitLineDto
---@field createTransitLineNameDtoList fun(lines: table):string,string,table
