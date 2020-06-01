insulate("Crossing", function()
    -- This is the setup
    --                                |    N   |        |        |
    --                                | lane 1 |        |        |
    --                                |        |        |        |
    --                                |STRAIGHT|        |        |
    --                                | +RIGHT |        |        |
    --                             K1 |========|========|========| K2
    --                                |        |        |        |
    --                    K3          |        |        |        |
    --  ------------------------------+        +        |        |
    --                       |  |                                |
    --                       |  |                                |
    --                       |  |                                |
    --  ----------------------  ------+                          |
    --                       |  |                                |
    --  W lane 2  LEFT+RIGHT |K5|                                |
    --                       |  |                                |
    --  ------------------------------+        +        |        |
    --                    K6,         |        |        |        |
    --                    K7          |        |        |        |
    --  In lane 2 all cars         K8=|========|========|========|-K9
    --  allowed to turn               |        | LEFT   |STRAIGHT|
    --  right when lane 3             |        |        |        |
    --  is turning left               |        | lane 3 | lane 4 |
    --  (Route: "RIGHT TURN")         |        |   S    |    S   |
    --
    require("ak.core.eep.AkEepFunktionen")
    local Lane = require("ak.road.Lane")
    local Crossing = require("ak.road.Crossing")
    -- local CrossingCircuit = require("ak.road.CrossingCircuit")
    -- local LaneSettings = require("ak.road.LaneSettings")
    local TrafficLight = require("ak.road.TrafficLight")
    local TrafficLightModel = require("ak.road.TrafficLightModel")
    require("ak.storage.StorageUtility")
    local L1, L2, L3, L4
    local lane1, lane2, lane3, lane4
    local K1, K2, K3, K5, K6, K7, K8, K9
    local switchingA, switchingB, switchingC
    local crossing

    L1 = TrafficLight:new(11, TrafficLightModel.Unsichtbar_2er) -- Signal for Lane 1
    L2 = TrafficLight:new(12, TrafficLightModel.Unsichtbar_2er) -- Signal for Lane 2
    L3 = TrafficLight:new(13, TrafficLightModel.Unsichtbar_2er) -- Signal for Lane 3
    L4 = TrafficLight:new(14, TrafficLightModel.Unsichtbar_2er) -- Signal for Lane 4
    K1 = TrafficLight:new(23, TrafficLightModel.JS2_3er_mit_FG) -- NORTH STRAIGHT 1 (right)
    K2 = TrafficLight:new(24, TrafficLightModel.JS2_3er_mit_FG) -- NORTH STRAIGHT 2 (left)
    K3 = TrafficLight:new(25, TrafficLightModel.JS2_3er_mit_FG) -- EAST STRAIGHT (left)
    K5 = TrafficLight:new(27, TrafficLightModel.JS2_3er_ohne_FG) -- EAST STRAIGHT (above lane)
    K6 = TrafficLight:new(28, TrafficLightModel.JS2_3er_mit_FG) -- EAST STRAIGHT (right)
    K7 = TrafficLight:new(29, TrafficLightModel.JS2_2er_OFF_YELLOW_GREEN) -- EAST RIGHT ADDITIONAL (right)
    K8 = TrafficLight:new(30, TrafficLightModel.JS2_3er_mit_FG) -- SOUTH LEFT (left)
    K9 = TrafficLight:new(31, TrafficLightModel.JS2_3er_mit_FG) -- SOUTH STRAIGHT (right)

    crossing = Crossing:new("My Crossing")
    lane1 = crossing:newLane("Lane 1 N", 1, L1, Lane.Directions.STRAIGHT, Lane.Directions.RIGHT)
    lane2 = crossing:newLane("Lane 2 E", 2, L2, Lane.Directions.LEFT, Lane.Directions.RIGHT)
    lane3 = crossing:newLane("Lane 3 S", 3, L3, Lane.Directions.LEFT)
    lane4 = crossing:newLane("Lane 4 S", 4, L4, Lane.Directions.STRAIGHT)

    ---@type CrossingCircuit
    switchingA = crossing:newSwitching("Switching A - North South")
    switchingA:addLane(lane1)
    switchingA:addTrafficLight(K1)
    switchingA:addTrafficLight(K2)
    switchingA:addLane(lane4)
    switchingA:addTrafficLight(K9)
    switchingA:addPedestrianLight(K3)
    switchingA:addPedestrianLight(K6)

    switchingB = crossing:newSwitching("Switching B - South + East Right")
    switchingB:addLane(lane2, {Lane.Directions.RIGHT}, {"RIGHT TURN"})
    switchingB:addTrafficLight(K7)
    switchingB:addLane(lane3)
    switchingB:addTrafficLight(K8)
    switchingB:addLane(lane4)
    switchingB:addTrafficLight(K9)

    switchingC = crossing:newSwitching("Switching C - East only")
    switchingC:addLane(lane2)
    switchingC:addTrafficLight(K3)
    switchingC:addTrafficLight(K5)
    switchingC:addTrafficLight(K6)
    switchingC:addPedestrianLight(K1)
    switchingC:addPedestrianLight(K2)
    switchingC:addPedestrianLight(K8)
    switchingC:addPedestrianLight(K9)

    describe("Lane switching NONE -> A", function()
        local r, g = switchingA:lanesToTurnRedAndGreen()
        it("Red   length", function() assert(0, #r) end)
        it("Green length", function() assert(1, #g) end)
        it("Green lane1 ", function() assert(lane1, g[1]) end)
    end)

    describe("Lane switching NONE -> B", function()
        local r, g = switchingB:lanesToTurnRedAndGreen()
        it("Red   length", function() assert(0, #r) end)
        it("Green length", function() assert(2, #g) end)
        it("Green lane2 ", function() assert(lane2, g[1]) end)
        it("Green lane3 ", function() assert(lane3, g[2]) end)
    end)

    describe("Lane switching A -> B", function()
        local r, g = switchingB:lanesToTurnRedAndGreen(switchingA)
        it("Red   length", function() assert(1, #r) end)
        it("Red   lane1 ", function() assert(lane1, r[1]) end)
        it("Green length", function() assert(2, #g) end)
        it("Green lane2 ", function() assert(lane2, g[1]) end)
        it("Green lane3 ", function() assert(lane3, g[2]) end)
    end)

    describe("Lane switching B -> A", function()
        local r, g = switchingA:lanesToTurnRedAndGreen(switchingB)
        it("Red   length", function() assert(2, #r) end)
        it("Red   lane2 ", function() assert(lane2, r[1]) end)
        it("Red   lane3 ", function() assert(lane3, r[2]) end)
        it("Green length", function() assert(1, #g) end)
        it("Green lane1 ", function() assert(lane1, g[1]) end)
    end)

    describe("Lane switching B -> C", function()
        local r, g = switchingC:lanesToTurnRedAndGreen(switchingB)
        it("Red   length", function() assert(3, #r) end)
        it("Red   lane2 ", function() assert(lane2, r[1]) end)
        it("Red   lane3 ", function() assert(lane3, r[2]) end)
        it("Red   lane4 ", function() assert(lane4, r[3]) end)
        it("Green length", function() assert(1, #g) end)
        it("Green lane2 ", function() assert(lane2, g[1]) end)
    end)

    describe("Lane switching C -> B", function()
        local r, g = switchingC:lanesToTurnRedAndGreen(switchingB)
        it("Red   length", function() assert(1, #r) end)
        it("Red   lane2 ", function() assert(lane2, r[1]) end)
        it("Green length", function() assert(1, #g) end)
        it("Green lane2 ", function() assert(lane2, g[1]) end)
        it("Green lane3 ", function() assert(lane3, g[2]) end)
        it("Green lane4 ", function() assert(lane4, g[3]) end)
    end)

    describe("Lane switching A -> A", function()
        local r, g = switchingA:lanesToTurnRedAndGreen(switchingA)
        it("Red   length", function() assert(0, #r) end)
        it("Green length", function() assert(0, #g) end)
    end)
    describe("Lane switching B -> B", function()
        local r, g = switchingB:lanesToTurnRedAndGreen(switchingB)
        it("Red   length", function() assert(0, #r) end)
        it("Green length", function() assert(0, #g) end)
    end)
    describe("Lane switching C -> C", function()
        local r, g = switchingC:lanesToTurnRedAndGreen(switchingC)
        it("Red   length", function() assert(0, #r) end)
        it("Green length", function() assert(0, #g) end)
    end)
end)
