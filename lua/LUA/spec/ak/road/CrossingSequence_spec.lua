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
    require("ak.core.eep.EepSimulator")
    local Lane = require("ak.road.Lane")
    local Crossing = require("ak.road.Crossing")
    -- local CrossingSequence = require("ak.road.CrossingSequence")
    -- local LaneSettings = require("ak.road.LaneSettings")
    local TrafficLight = require("ak.road.TrafficLight")
    local TrafficLightModel = require("ak.road.TrafficLightModel")
    require("ak.storage.StorageUtility")
    local L1, L2, L3, L4
    local lane1, lane2, lane3, lane4
    local K1, K2, K3, K5, K6, K7, K8, K9
    local sequenceA, sequenceB, sequenceC
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
    lane1 = Lane:new("Lane 1 N", 1, L1, Lane.Directions.STRAIGHT, Lane.Directions.RIGHT)
    lane2 = Lane:new("Lane 2 E", 2, L2, Lane.Directions.LEFT, Lane.Directions.RIGHT)
    lane3 = Lane:new("Lane 3 S", 3, L3, Lane.Directions.LEFT)
    lane4 = Lane:new("Lane 4 S", 4, L4, Lane.Directions.STRAIGHT)

    K1:applyToLane(lane1)
    K6:applyToLane(lane2)
    K7:applyToLane(lane2, "TURN RIGHT")
    K8:applyToLane(lane3)
    K9:applyToLane(lane4)

    ---@type CrossingSequence
    sequenceA = crossing:newSequence("Sequence A - North South")
    sequenceA:addTrafficLights(K1)
    sequenceA:addTrafficLights(K2)
    sequenceA:addTrafficLights(K9)
    sequenceA:addPedestrianLights(K3)
    sequenceA:addPedestrianLights(K6)

    sequenceB = crossing:newSequence("Sequence B - South + East Right")
    sequenceB:addTrafficLights(K7)
    sequenceB:addTrafficLights(K8)
    sequenceB:addTrafficLights(K9)

    sequenceC = crossing:newSequence("Sequence C - East only")
    sequenceC:addTrafficLights(K3)
    sequenceC:addTrafficLights(K5)
    sequenceC:addTrafficLights(K6)
    sequenceC:addPedestrianLights(K1)
    sequenceC:addPedestrianLights(K2)
    sequenceC:addPedestrianLights(K8)
    sequenceC:addPedestrianLights(K9)

    Crossing.initSequences()

    describe("Lane sequence NONE -> A", function()
        local r, g = sequenceA:trafficLightsToTurnRedAndGreen()

        it("Red K1 ", function() assert.is_falsy(r[K1]) end)
        it("Red K2 ", function() assert.is_falsy(r[K2]) end)
        it("Red K3 ", function() assert.is_falsy(r[K3]) end)
        it("Red K5 ", function() assert.is_falsy(r[K5]) end)
        it("Red K6 ", function() assert.is_falsy(r[K6]) end)
        it("Red K7 ", function() assert.is_falsy(r[K7]) end)
        it("Red K8 ", function() assert.is_falsy(r[K8]) end)
        it("Red K9 ", function() assert.is_falsy(r[K9]) end)

        it("Green K1 ", function() assert.is_true(g[K1]) end)
        it("Green K2 ", function() assert.is_true(g[K2]) end)
        it("Green K3 ", function() assert.is_falsy(g[K3]) end)
        it("Green K5 ", function() assert.is_falsy(g[K5]) end)
        it("Green K6 ", function() assert.is_falsy(g[K6]) end)
        it("Green K7 ", function() assert.is_falsy(g[K7]) end)
        it("Green K8 ", function() assert.is_falsy(g[K8]) end)
        it("Green K9 ", function() assert.is_true(g[K9]) end)
    end)

    describe("Lane sequence NONE -> B", function()
        local r, g = sequenceB:trafficLightsToTurnRedAndGreen()

        it("Red K1 ", function() assert.is_falsy(r[K1]) end)
        it("Red K2 ", function() assert.is_falsy(r[K2]) end)
        it("Red K3 ", function() assert.is_falsy(r[K3]) end)
        it("Red K5 ", function() assert.is_falsy(r[K5]) end)
        it("Red K6 ", function() assert.is_falsy(r[K6]) end)
        it("Red K7 ", function() assert.is_falsy(r[K7]) end)
        it("Red K8 ", function() assert.is_falsy(r[K8]) end)
        it("Red K9 ", function() assert.is_falsy(r[K9]) end)

        it("Green K1 ", function() assert.is_falsy(g[K1]) end)
        it("Green K2 ", function() assert.is_falsy(g[K2]) end)
        it("Green K3 ", function() assert.is_falsy(g[K3]) end)
        it("Green K5 ", function() assert.is_falsy(g[K5]) end)
        it("Green K6 ", function() assert.is_falsy(g[K6]) end)
        it("Green K7 ", function() assert.is_true(g[K7]) end)
        it("Green K8 ", function() assert.is_true(g[K8]) end)
        it("Green K9 ", function() assert.is_true(g[K9]) end)
    end)

    describe("Lane sequence NONE -> C", function()
        local r, g = sequenceC:trafficLightsToTurnRedAndGreen()

        it("Red K1 ", function() assert.is_falsy(r[K1]) end)
        it("Red K2 ", function() assert.is_falsy(r[K2]) end)
        it("Red K3 ", function() assert.is_falsy(r[K3]) end)
        it("Red K5 ", function() assert.is_falsy(r[K5]) end)
        it("Red K6 ", function() assert.is_falsy(r[K6]) end)
        it("Red K7 ", function() assert.is_falsy(r[K7]) end)
        it("Red K8 ", function() assert.is_falsy(r[K8]) end)
        it("Red K9 ", function() assert.is_falsy(r[K9]) end)

        it("Green K1 ", function() assert.is_falsy(g[K1]) end)
        it("Green K2 ", function() assert.is_falsy(g[K2]) end)
        it("Green K3 ", function() assert.is_true(g[K3]) end)
        it("Green K5 ", function() assert.is_true(g[K5]) end)
        it("Green K6 ", function() assert.is_true(g[K6]) end)
        it("Green K7 ", function() assert.is_falsy(g[K7]) end)
        it("Green K8 ", function() assert.is_falsy(g[K8]) end)
        it("Green K9 ", function() assert.is_falsy(g[K9]) end)
    end)

    describe("Lane sequence A -> B", function()
        local r, g = sequenceB:trafficLightsToTurnRedAndGreen(sequenceA)

        it("Red K1 ", function() assert.is_true(r[K1]) end)
        it("Red K2 ", function() assert.is_true(r[K2]) end)
        it("Red K3 ", function() assert.is_falsy(r[K3]) end)
        it("Red K5 ", function() assert.is_falsy(r[K5]) end)
        it("Red K6 ", function() assert.is_falsy(r[K6]) end)
        it("Red K7 ", function() assert.is_falsy(r[K7]) end)
        it("Red K8 ", function() assert.is_falsy(r[K8]) end)
        it("Red K9 ", function() assert.is_falsy(r[K9]) end)

        it("Green K1 ", function() assert.is_falsy(g[K1]) end)
        it("Green K2 ", function() assert.is_falsy(g[K2]) end)
        it("Green K3 ", function() assert.is_falsy(g[K3]) end)
        it("Green K5 ", function() assert.is_falsy(g[K5]) end)
        it("Green K6 ", function() assert.is_falsy(g[K6]) end)
        it("Green K7 ", function() assert.is_true(g[K7]) end)
        it("Green K8 ", function() assert.is_true(g[K8]) end)
        it("Green K9 ", function() assert.is_falsy(g[K9]) end)
    end)

    describe("Lane sequence A -> A", function()
        local r, g = sequenceA:trafficLightsToTurnRedAndGreen(sequenceA)

        it("Red K1 ", function() assert.is_falsy(r[K1]) end)
        it("Red K2 ", function() assert.is_falsy(r[K2]) end)
        it("Red K3 ", function() assert.is_falsy(r[K3]) end)
        it("Red K5 ", function() assert.is_falsy(r[K5]) end)
        it("Red K6 ", function() assert.is_falsy(r[K6]) end)
        it("Red K7 ", function() assert.is_falsy(r[K7]) end)
        it("Red K8 ", function() assert.is_falsy(r[K8]) end)
        it("Red K9 ", function() assert.is_falsy(r[K9]) end)

        it("Green K1 ", function() assert.is_falsy(g[K1]) end)
        it("Green K2 ", function() assert.is_falsy(g[K2]) end)
        it("Green K3 ", function() assert.is_falsy(g[K3]) end)
        it("Green K5 ", function() assert.is_falsy(g[K5]) end)
        it("Green K6 ", function() assert.is_falsy(g[K6]) end)
        it("Green K7 ", function() assert.is_falsy(g[K7]) end)
        it("Green K8 ", function() assert.is_falsy(g[K8]) end)
        it("Green K9 ", function() assert.is_falsy(g[K9]) end)
    end)
    describe("Lane sequence B -> B", function()
        local r, g = sequenceB:trafficLightsToTurnRedAndGreen(sequenceB)

        it("Red K1 ", function() assert.is_falsy(r[K1]) end)
        it("Red K2 ", function() assert.is_falsy(r[K2]) end)
        it("Red K3 ", function() assert.is_falsy(r[K3]) end)
        it("Red K5 ", function() assert.is_falsy(r[K5]) end)
        it("Red K6 ", function() assert.is_falsy(r[K6]) end)
        it("Red K7 ", function() assert.is_falsy(r[K7]) end)
        it("Red K8 ", function() assert.is_falsy(r[K8]) end)
        it("Red K9 ", function() assert.is_falsy(r[K9]) end)

        it("Green K1 ", function() assert.is_falsy(g[K1]) end)
        it("Green K2 ", function() assert.is_falsy(g[K2]) end)
        it("Green K3 ", function() assert.is_falsy(g[K3]) end)
        it("Green K5 ", function() assert.is_falsy(g[K5]) end)
        it("Green K6 ", function() assert.is_falsy(g[K6]) end)
        it("Green K7 ", function() assert.is_falsy(g[K7]) end)
        it("Green K8 ", function() assert.is_falsy(g[K8]) end)
        it("Green K9 ", function() assert.is_falsy(g[K9]) end)
    end)
    describe("Lane sequence C -> C", function()
        local r, g = sequenceC:trafficLightsToTurnRedAndGreen(sequenceC)

        it("Red K1 ", function() assert.is_falsy(r[K1]) end)
        it("Red K2 ", function() assert.is_falsy(r[K2]) end)
        it("Red K3 ", function() assert.is_falsy(r[K3]) end)
        it("Red K5 ", function() assert.is_falsy(r[K5]) end)
        it("Red K6 ", function() assert.is_falsy(r[K6]) end)
        it("Red K7 ", function() assert.is_falsy(r[K7]) end)
        it("Red K8 ", function() assert.is_falsy(r[K8]) end)
        it("Red K9 ", function() assert.is_falsy(r[K9]) end)

        it("Green K1 ", function() assert.is_falsy(g[K1]) end)
        it("Green K2 ", function() assert.is_falsy(g[K2]) end)
        it("Green K3 ", function() assert.is_falsy(g[K3]) end)
        it("Green K5 ", function() assert.is_falsy(g[K5]) end)
        it("Green K6 ", function() assert.is_falsy(g[K6]) end)
        it("Green K7 ", function() assert.is_falsy(g[K7]) end)
        it("Green K8 ", function() assert.is_falsy(g[K8]) end)
        it("Green K9 ", function() assert.is_falsy(g[K9]) end)
    end)
end)
