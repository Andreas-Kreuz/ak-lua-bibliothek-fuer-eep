if AkDebugLoad then print("Loading ak.road.LaneSettings ...") end

local Lane = require("ak.road.Lane")
-- local Queue = require("ak.util.Queue")
-- local Scheduler = require("ak.scheduler.Scheduler")
-- local StorageUtility = require("ak.storage.StorageUtility")
-- local TableUtils = require("ak.util.TableUtils")
-- local Task = require("ak.scheduler.Task")
-- local TrafficLightState = require("ak.road.TrafficLightState")
-- local fmt = require("ak.core.eep.AkTippTextFormat")

---This will remember the lane and its settings within this switching. Each lane can have one settings only.
---@class LaneSettings
local LaneSettings = {}
---@param routes string[] @matching routes
function LaneSettings:setRoutes(routes) self.routes = routes end

--- Erzeugt eine Richtung, welche durch eine Ampel gesteuert wird.
---@param lane Lane @Sichtbare Ampeln
---@param directions LaneDirection[], @EEPSaveSlot-Id fuer das Speichern der Richtung
---@param switchingType LaneRequestType @typ der Anforderung (nur bei Anforderung schalten ignoriert die
---                                      Anzahl der Rotphasen beim Umschalten)
---@param routes string[] @matching routes
function LaneSettings:new(lane, directions, routes, switchingType)
    local o = {
        lane = lane,
        directions = directions or {Lane.Directions.LEFT, Lane.Directions.STRAIGHT, Lane.Directions.RIGHT},
        schaltungsTyp = switchingType or Lane.SchaltungsTyp.NICHT_VERWENDET,
        routes = routes or {},
        vehicleMultiplier = 1
    }

    self.__index = self
    setmetatable(o, self)
    return o
end

return LaneSettings
