print("Loading ak.road.TrafficLightState ...")

---@class TrafficLightState
local TrafficLightState = {}
TrafficLightState.RED = "Rot"
TrafficLightState.REDYELLOW = "Rot-Gelb"
TrafficLightState.YELLOW = "Gelb"
TrafficLightState.GREEN = "Gruen"
TrafficLightState.PEDESTRIAN = "Fussg"
TrafficLightState.OFF = "Aus"
TrafficLightState.OFF_BLINKING = "Aus blinkend"

return TrafficLightState
