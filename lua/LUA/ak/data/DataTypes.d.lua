---@meta

---@alias DataStoreElement table
---@alias DataStoreList table<any, DataStoreElement>
---@alias DataStoreRoom table<string, DataStoreElement>
---@alias DataStoreRooms table<string, DataStoreRoom>

---@class DataStoreEventPayload
---@field room? string
---@field keyId? string
---@field element? DataStoreElement
---@field list? DataStoreList
---@field payload DataStoreEventPayload

---@class DataStore: EventListener
---@field rooms DataStoreRooms
---@field reset fun():nil
---@field getRoom fun(room: string):DataStoreRoom|nil
---@field get fun(room: string, key: string|number):DataStoreElement|nil
---@field fireEvent fun(event: DataChangeEvent):nil

---@class DataLuaModule
---@field id string
---@field enabled boolean
---@field name string
---@field init fun():nil
---@field run fun():nil
---@field setOptions fun(options: table):nil

---@class DataSlotNameResolver
---@field updateSlotNames fun():nil
---@field getSlotName fun(slot: string|number):string|nil

---@class DataSlotsStatePublisher
---@field name string
---@field initialize fun():nil
---@field syncState fun():table

---@class DataWebConnector
---@field registerStatePublishers fun(activeCollectors: table<string, boolean>|nil):nil

---@class SignalStatePublisher
---@field name string
---@field initialize fun():nil
---@field syncState fun():table

---@class StructureStatePublisher
---@field name string
---@field initialize fun():nil
---@field syncState fun():table

---@class SwitchStatePublisher
---@field name string
---@field initialize fun():nil
---@field syncState fun():table

---@class TimeStatePublisher
---@field name string
---@field initialize fun():nil
---@field syncState fun():table

---@class TrackDetection
---@field tracks table<number, Track>
---@field trackType string
---@field reservedFunction function
---@field registerFunction function
---@field storeRunTime fun(self: TrackDetection, identifier: string, time: number):nil
---@field findTrainsOnTrack fun(self: TrackDetection):table<string, table<string, number>>
---@field initialize fun(self: TrackDetection):nil
---@field updateData fun(self: TrackDetection):table
---@field new fun(self: TrackDetection, trackType: string):TrackDetection

---@class Track
---@field id number

---@class TrainDetection
---@field debug boolean
---@field registerForTrainDetection fun():nil
---@field refreshTrainInfos fun(allKnownTrains: table<string, TrainUpdateInfo>):nil
---@field trainInfosForAllTrains fun(detected: table<string, boolean>, dirtyTrains: table<string, boolean>, movedTrains: table<string, boolean>, trainTracks: table<string, table<string, table<string, number>>>):table<string, TrainUpdateInfo>
---@field initialize fun():nil
---@field update fun():nil

---@class TrainUpdateInfo
---@field name string
---@field trackType string
---@field tracks table<string, number>
---@field speed number
---@field dirty boolean
---@field created boolean
---@field moved boolean

---@class TrainsAndTracksStatePublisher
---@field name string
---@field initialize fun():nil
---@field syncState fun():table
