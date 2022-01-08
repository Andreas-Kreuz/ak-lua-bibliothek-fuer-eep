if AkDebugLoad then print("[#Start] Loading ak.road.TrafficLightState ...") end

---@class TrafficLightState
local TrafficLightState = {}
TrafficLightState.RED = "Rot"
TrafficLightState.REDYELLOW = "Rot-Gelb"
TrafficLightState.YELLOW = "Gelb"
TrafficLightState.GREEN = "Gruen"
TrafficLightState.PEDESTRIAN = "Fussg"
TrafficLightState.OFF = "Aus"
TrafficLightState.OFF_BLINKING = "Aus blinkend"

function TrafficLightState.canDrive(phase)
    return phase == TrafficLightState.GREEN or phase == TrafficLightState.OFF or phase ==
           TrafficLightState.OFF_BLINKING
end

return TrafficLightState
