if AkDebugLoad then print("[#Start] Loading ce.mods.road.LaneSettings ...") end

local Lane = require("ce.mods.road.Lane")
-- local Queue = require("ce.hub.util.Queue")
-- local Scheduler = require("ce.hub.scheduler.Scheduler")
-- local StorageUtility = require("ce.hub.util.StorageUtility")
-- local TableUtils = require("ce.hub.util.TableUtils")
-- local Task = require("ce.hub.scheduler.Task")
-- local TrafficLightState = require("ce.mods.road.TrafficLightState")
-- local fmt = require("ce.hub.eep.TippTextFormatter")

---This will remember the lane and its settings within this request. Each lane can have one settings only.
---@class LaneSettings
local LaneSettings = {}
---@param routes string[] @matching routes
function LaneSettings:setRoutes(routes) self.routes = routes end

--- Erzeugt eine Fahrspur, welche durch eine Ampel gesteuert wird.
---@param lane Lane @Sichtbare Ampeln
---@param directions LaneDirection[], @EEPSaveSlot-Id fuer das Speichern der Fahrspur
---@param routes string[] @matching routes
---@param requestType LaneRequestType @typ der Anforderung (nur bei Anforderung schalten ignoriert die
---                                      Anzahl der Rotphasen beim Umschalten)
function LaneSettings:new(lane, directions, routes, requestType)
    local o = {
        lane = lane,
        directions = directions or { Lane.Directions.LEFT, Lane.Directions.STRAIGHT, Lane.Directions.RIGHT },
        requestType = requestType or Lane.RequestType.NICHT_VERWENDET,
        routes = routes or {},
        vehicleMultiplier = 1
    }

    self.__index = self
    setmetatable(o, self)
    return o
end

return LaneSettings
