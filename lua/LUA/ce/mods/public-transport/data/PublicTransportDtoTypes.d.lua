---@meta

---@class PublicTransportStationDto
---@field id string

---@class PublicTransportLineSegmentStationDto
---@field station table
---@field timeToStation number|nil

---@class PublicTransportLineSegmentDto
---@field id string
---@field destination string
---@field routeName string
---@field lineNr string|nil
---@field stations PublicTransportLineSegmentStationDto[]

---@class PublicTransportLineDto
---@field id string
---@field nr string
---@field trafficType string
---@field lineSegments PublicTransportLineSegmentDto[]

---@class PublicTransportModuleSettingDto
---@field category string
---@field name string
---@field description string
---@field type string
---@field value boolean
---@field eepFunction string

---@class PublicTransportDtoFactory
---@field createPublicTransportStationDto fun(station: table):string,string,string|number,PublicTransportStationDto
---@field createPublicTransportStationDtoList fun(stations: table):string,string,table
---@field createPublicTransportLineDto fun(line: Line|table):string,string,string|number,PublicTransportLineDto
---@field createPublicTransportLineDtoList fun(lines: table):string,string,table
---@field createPublicTransportModuleSettingDto fun(
---    setting: table
---):string,string,string|number,PublicTransportModuleSettingDto
---@field createPublicTransportModuleSettingDtoList fun(settings: table):string,string,table
---@field createPublicTransportLineNameDto fun(line: Line|table):string,string,string|number,PublicTransportLineDto
---@field createPublicTransportLineNameDtoList fun(lines: table):string,string,table
