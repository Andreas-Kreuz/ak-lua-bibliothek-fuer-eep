insulate("Crossing", function()
    -- This is the setup
    --                                |    N   |        |        |
    --                                | lane 1 |        |        |
    --                                |        |        |        |
    --                                |STRAIGHT|        |        |
    --                             S1 | +RIGHT |        |        |
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
    --                    K7          |        |        |        | S2
    --  In lane 2 all cars         K8=|========|========|========|-K9
    --  allowed to turn               |        | LEFT   |STRAIGHT|
    --  right when lane 3             |        |        |        |
    --  is turning left               |        | lane 3 | lane 4 |
    --  (Route: RIGHT_TURN_ROUTE)     |        |   S    |    S   |
    --
    require("ak.core.eep.EepSimulator")
    local Lane = require("ak.road.Lane")
    local Crossing = require("ak.road.Crossing")
    -- local CrossingSequence = require("ak.road.CrossingSequence")
    -- local LaneSettings = require("ak.road.LaneSettings")
    local TrafficLight = require("ak.road.TrafficLight")
    local TrafficLightModel = require("ak.road.TrafficLightModel")
    local StorageUtility = require("ak.storage.StorageUtility")
    local L1, L2, L3, L4
    local lane1, lane2, lane3, lane4
    local K1, K2, K3, K5, K6, K7, K8, K9, S1, S2
    local sequenceA, sequenceB, sequenceC
    local crossing

    local RIGHT_TURN_ROUTE = "TURN RIGHT"
    EEPSetTrainRoute("#Car2a", RIGHT_TURN_ROUTE)

    before_each(function()
        EEPStructureSetLight("#5433_Straba Signal A", false)
        EEPStructureSetLight("#5434_Straba Signal links", false)
        EEPStructureSetLight("#5435_Straba Signal Halt", false)
        EEPStructureSetLight("#5436_Straba Signal rechts", false)
        EEPStructureSetLight("#5518_Straba Signal A", false)
        EEPStructureSetLight("#5520_Straba Signal anhalten", false)
        EEPStructureSetLight("#5521_Straba Signal geradeaus", false)
        EEPStructureSetLight("#5522_Straba Signal anhalten", false)
        EEPStructureSetLight("#5523_Straba Signal Halt", false)
        EEPStructureSetLight("#5524_Straba Signal A", false)
        EEPStructureSetLight("#5525_Straba Signal Halt", false)
        EEPStructureSetLight("#5526_Straba Signal anhalten", false)
        EEPStructureSetLight("#5528_Straba Signal Halt", false)
        EEPStructureSetLight("#5529_Straba Signal anhalten", false)
        EEPStructureSetLight("#5530_Straba Signal A", false)
        EEPStructureSetLight("#5531_Straba Signal geradeaus", false)
        EEPStructureSetLight("#5533_Straba Signal A", false)
        EEPStructureSetLight("#5534_Straba Signal anhalten", false)
        EEPStructureSetLight("#5535_Straba Signal Halt", false)
        EEPStructureSetLight("#5536_Straba Signal rechts", false)
        EEPStructureSetLight("#5537_Straba Signal Halt", false)
        EEPStructureSetLight("#5538_Straba Signal links", false)
        EEPStructureSetLight("#5539_Straba Signal anhalten", false)
        EEPStructureSetLight("#5540_Straba Signal A", false)

        L1 = TrafficLight:new("L1", 11, TrafficLightModel.Unsichtbar_2er) -- Signal for Lane 1
        L2 = TrafficLight:new("L2", 12, TrafficLightModel.Unsichtbar_2er) -- Signal for Lane 2
        L3 = TrafficLight:new("L3", 13, TrafficLightModel.Unsichtbar_2er) -- Signal for Lane 3
        L4 = TrafficLight:new("L4", 14, TrafficLightModel.Unsichtbar_2er) -- Signal for Lane 4
        K1 = TrafficLight:new("K1", 23, TrafficLightModel.JS2_3er_mit_FG) -- NORTH STRAIGHT 1 (right)
        K2 = TrafficLight:new("K2", 24, TrafficLightModel.JS2_3er_mit_FG) -- NORTH STRAIGHT 2 (left)
        K3 = TrafficLight:new("K3", 25, TrafficLightModel.JS2_3er_mit_FG) -- EAST STRAIGHT (left)
        K5 = TrafficLight:new("K5", 27, TrafficLightModel.JS2_3er_ohne_FG) -- EAST STRAIGHT (above lane)
        K6 = TrafficLight:new("K6", 28, TrafficLightModel.JS2_3er_mit_FG) -- EAST STRAIGHT (right)
        K7 = TrafficLight:new("K7", 29, TrafficLightModel.JS2_2er_OFF_YELLOW_GREEN) -- EAST RIGHT ADDITIONAL (right)
        K8 = TrafficLight:new("K8", 30, TrafficLightModel.JS2_3er_mit_FG) -- SOUTH LEFT (left)
        K9 = TrafficLight:new("K9", 31, TrafficLightModel.JS2_3er_mit_FG) -- SOUTH STRAIGHT (right)


        S1 = TrafficLight:new("S1", -1, TrafficLightModel.NONE, "#5528_Straba Signal Halt",
        "#5531_Straba Signal geradeaus", "#5529_Straba Signal anhalten",
        "#5530_Straba Signal A")
        S2 = TrafficLight:new("S2", -1, TrafficLightModel.NONE, "#5435_Straba Signal Halt",
        "#5521_Straba Signal geradeaus", "#5520_Straba Signal anhalten",
        "#5518_Straba Signal A")

        crossing = Crossing:new("My Crossing")
        lane1 = Lane:new("Lane 1 N", 1, L1, {Lane.Directions.STRAIGHT, Lane.Directions.RIGHT})
        lane2 = Lane:new("Lane 2 E", 2, L2, {Lane.Directions.LEFT, Lane.Directions.RIGHT})
        lane3 = Lane:new("Lane 3 S", 3, L3, {Lane.Directions.LEFT})
        lane4 = Lane:new("Lane 4 S", 4, L4, {Lane.Directions.STRAIGHT})

        K1:applyToLane(lane1)
        K6:applyToLane(lane2)
        K7:applyToLane(lane2, RIGHT_TURN_ROUTE)
        K8:applyToLane(lane3)
        K9:applyToLane(lane4)

        ---@type CrossingSequence
        sequenceA = crossing:newSequence("Sequence A - North South")
        sequenceA:addCarLights(K1)
        sequenceA:addCarLights(K2)
        sequenceA:addTramLights(S1)
        sequenceA:addCarLights(K9)
        sequenceA:addTramLights(S2)
        sequenceA:addPedestrianLights(K3)
        sequenceA:addPedestrianLights(K6)

        sequenceB = crossing:newSequence("Sequence B - South + East Right")
        sequenceB:addCarLights(K7)
        sequenceB:addCarLights(K8)
        sequenceB:addCarLights(K9)

        sequenceC = crossing:newSequence("Sequence C - East only")
        sequenceC:addCarLights(K3)
        sequenceC:addCarLights(K5)
        sequenceC:addCarLights(K6)
        sequenceC:addPedestrianLights(K1)
        sequenceC:addPedestrianLights(K2)
        sequenceC:addPedestrianLights(K8)
        sequenceC:addPedestrianLights(K9)

        -- Not neccessary on ModuleRegistry Tasks
        Crossing.initSequences()
    end)

    after_each(function() StorageUtility.reset() end)

    insulate("Check initial stuff", function()
        it("Lanes are there", function()
            assert.is_same(lane1, crossing.lanes[lane1.name])
            assert.is_same(lane2, crossing.lanes[lane2.name])
            assert.is_same(lane3, crossing.lanes[lane3.name])
            assert.is_same(lane4, crossing.lanes[lane4.name])
        end)
        it("Switchings are there", function()
            local sequenceMap = {}
            for _, sequence in ipairs(crossing:getSequences()) do sequenceMap[sequence] = true end

            assert.is_same(true, sequenceMap[sequenceA])
            assert.is_same(true, sequenceMap[sequenceB])
            assert.is_same(true, sequenceMap[sequenceC])
        end)
        it("Lanes are there", function()
            assert.is_truthy(sequenceA.lanes[lane1])
            assert.is_falsy(sequenceA.lanes[lane2])
            assert.is_falsy(sequenceA.lanes[lane3])
            assert.is_truthy(sequenceA.lanes[lane4])
        end)
        it("TrafficLights are there", function()
            assert.is_same(Lane.Type.CAR, sequenceA.trafficLights[K1])
            assert.is_same(Lane.Type.CAR, sequenceA.trafficLights[K2])
            assert.is_same(Lane.Type.CAR, sequenceA.trafficLights[K9])
        end)
        it("Pedestrian TrafficLights are there", function()
            assert.is_same(Lane.Type.PEDESTRIAN, sequenceA.trafficLights[K3])
            assert.is_same(Lane.Type.PEDESTRIAN, sequenceA.trafficLights[K6])
        end)
        it("Tra, TrafficLights are there", function()
            assert.is_same(Lane.Type.TRAM, sequenceA.trafficLights[S1])
            assert.is_same(Lane.Type.TRAM, sequenceA.trafficLights[S2])
        end)
    end)

    insulate("Calculate priorities", function()
        describe("No priorities at the start", function()
            it("TrafficLights are there", function()
                assert.equals(0, sequenceA:calculatePriority())
                assert.equals(0, sequenceB:calculatePriority())
                assert.equals(0, sequenceC:calculatePriority())
            end)
        end)
        describe("Same priorities on same vehicles", function()
            lane1:vehicleEntered("#Car1a")
            lane2:vehicleEntered("#Car2a")
            lane3:vehicleEntered("#Car3a")

            it("Car priorities for 1 car per lane", function()
                assert.equals(1.5, sequenceA:calculatePriority())
                assert.equals(2.0, sequenceB:calculatePriority())
                assert.equals(3.0, sequenceC:calculatePriority())
            end)
        end)
        describe("Car priorities for 2 cars per lane", function()
            lane1:vehicleEntered("#Car1b")
            lane2:vehicleEntered("#Car2b")
            lane3:vehicleEntered("#Car3b")

            it("TrafficLights are there", function()
                assert.equals(3.0, sequenceA:calculatePriority())
                assert.equals(4.0, sequenceB:calculatePriority())
                assert.equals(6.0, sequenceC:calculatePriority())
            end)
        end)
        describe("Car priorities for 1 car per lane (again)", function()
            lane1:vehicleLeft("#Car1a")
            lane2:vehicleLeft("#Car2a")
            lane3:vehicleLeft("#Car3a")

            it("TrafficLights are there", function()
                assert.equals(1.5, sequenceA:calculatePriority())
                assert.equals(2.0, sequenceB:calculatePriority())
                assert.equals(3.0, sequenceC:calculatePriority())
            end)
        end)
        describe("Car priorities for 0 cars per lane after leaving", function()
            lane1:vehicleLeft("#Car1b")
            lane2:vehicleLeft("#Car2b")
            lane3:vehicleLeft("#Car3b")

            it("TrafficLights are there", function()
                assert.equals(0, sequenceA:calculatePriority())
                assert.equals(0, sequenceB:calculatePriority())
                assert.equals(0, sequenceC:calculatePriority())
            end)
        end)
    end)
end)

insulate("Check traffic light sequence", function()
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
    --  (Route: RIGHT_TURN_ROUTE)         |        |   S    |    S   |
    --
    require("ak.core.eep.EepSimulator")
    local Lane = require("ak.road.Lane")
    local Crossing = require("ak.road.Crossing")
    local CrossingSequence = require("ak.road.CrossingSequence")
    -- local LaneSettings = require("ak.road.LaneSettings")
    local TrafficLight = require("ak.road.TrafficLight")
    local TrafficLightModel = require("ak.road.TrafficLightModel")

    ---@type Lane
    local lane1, lane2, lane3, lane4
    ---@type TrafficLight
    local c1Lane1Signal, c1Lane2Signal, c1Lane3Signal, c1Lane4Signal
    ---@type TrafficLight
    local K1, K2, K3, K5, K6, K7, K8, K9
    ---@type CrossingSequence
    local sequenceA, sequenceB, sequenceC
    ---@type Crossing
    local crossing

    local RIGHT_TURN_ROUTE = "TURN RIGHT"
    EEPSetTrainRoute("#Car2a", RIGHT_TURN_ROUTE)

    c1Lane1Signal = TrafficLight:new("c1Lane1Signal", 11, TrafficLightModel.Unsichtbar_2er)
    c1Lane2Signal = TrafficLight:new("c1Lane2Signal", 12, TrafficLightModel.Unsichtbar_2er)
    c1Lane3Signal = TrafficLight:new("c1Lane3Signal", 13, TrafficLightModel.Unsichtbar_2er)
    c1Lane4Signal = TrafficLight:new("c1Lane4Signal", 14, TrafficLightModel.Unsichtbar_2er)
    K1 = TrafficLight:new("K1", 23, TrafficLightModel.JS2_3er_mit_FG) -- NORTH STRAIGHT 1 (right)
    K2 = TrafficLight:new("K2", 24, TrafficLightModel.JS2_3er_mit_FG) -- NORTH STRAIGHT 2 (left)
    K3 = TrafficLight:new("K3", 25, TrafficLightModel.JS2_3er_mit_FG) -- EAST STRAIGHT (left)
    K5 = TrafficLight:new("K5", 27, TrafficLightModel.JS2_3er_ohne_FG) -- EAST STRAIGHT (above lane)
    K6 = TrafficLight:new("K6", 28, TrafficLightModel.JS2_3er_mit_FG) -- EAST STRAIGHT (right)
    K7 = TrafficLight:new("K7", 29, TrafficLightModel.JS2_2er_OFF_YELLOW_GREEN) -- EAST RIGHT ADDITIONAL (right)
    K8 = TrafficLight:new("K8", 30, TrafficLightModel.JS2_3er_mit_FG) -- SOUTH LEFT (left)
    K9 = TrafficLight:new("K9", 31, TrafficLightModel.JS2_3er_mit_FG) -- SOUTH STRAIGHT (right)

    crossing = Crossing:new("My Crossing")
    lane1 = Lane:new("Lane 1 N", 1, c1Lane1Signal, {Lane.Directions.STRAIGHT, Lane.Directions.RIGHT})
    lane2 = Lane:new("Lane 2 E", 2, c1Lane2Signal, {Lane.Directions.LEFT, Lane.Directions.RIGHT})
    lane3 = Lane:new("Lane 3 S", 3, c1Lane3Signal, {Lane.Directions.LEFT})
    lane4 = Lane:new("Lane 4 S", 4, c1Lane4Signal, {Lane.Directions.STRAIGHT})

    K1:applyToLane(lane1)
    K6:applyToLane(lane2)
    K7:applyToLane(lane2, RIGHT_TURN_ROUTE) -- .showRequestOn(K7)
    K8:applyToLane(lane3)
    K9:applyToLane(lane4)

    ---@type CrossingSequence
    sequenceA = crossing:newSequence("Sequence A - North South")
    sequenceA:addCarLights(K1)
    sequenceA:addCarLights(K2)
    sequenceA:addCarLights(K9)
    sequenceA:addPedestrianLights(K3)
    sequenceA:addPedestrianLights(K6)

    ---@type CrossingSequence
    sequenceB = crossing:newSequence("Sequence B - South + East Right")
    sequenceB:addCarLights(K7)
    sequenceB:addCarLights(K8)
    sequenceB:addCarLights(K9)

    ---@type CrossingSequence
    sequenceC = crossing:newSequence("Sequence C - East only")
    sequenceC:addCarLights(K3)
    sequenceC:addCarLights(K5)
    sequenceC:addCarLights(K6)
    sequenceC:addPedestrianLights(K1)
    sequenceC:addPedestrianLights(K2)
    sequenceC:addPedestrianLights(K8)
    sequenceC:addPedestrianLights(K9)

    -- Not neccessary on ModuleRegistry Tasks
    Crossing.initSequences()

    local ModuleRegistry = require("ak.core.ModuleRegistry")
    local Scheduler = require("ak.scheduler.Scheduler")

    _G.EEPTime = 10000

    ModuleRegistry.debug = false
    Scheduler.debug = false
    Crossing.debug = false
    CrossingSequence.debug = false
    ModuleRegistry.registerModules(require("ak.road.CrossingLuaModul"))

    local U_R = 2
    local U_G = 1
    local RED = 1
    local RYE = 2
    local GRE = 3
    local YEL = 5
    local _P_ = 6

    EEPSetSignal(11, U_R)
    EEPSetSignal(12, U_R)
    EEPSetSignal(13, U_R)
    EEPSetSignal(14, U_R)
    EEPSetSignal(23, GRE)
    EEPSetSignal(24, RED)
    EEPSetSignal(25, RED)
    EEPSetSignal(27, RED)
    EEPSetSignal(28, RED)
    EEPSetSignal(29, RED)
    EEPSetSignal(30, RED)
    EEPSetSignal(31, RED)

    lane1:vehicleEntered("#Car1a")

    do
        it("Lane1 Traffic Light", function() assert.equals(11, lane1.trafficLight.signalId) end)
        it("Lane2 Traffic Light", function() assert.equals(12, lane2.trafficLight.signalId) end)
        it("Lane3 Traffic Light", function() assert.equals(13, lane3.trafficLight.signalId) end)
        it("Lane4 Traffic Light", function() assert.equals(14, lane4.trafficLight.signalId) end)

        local step0Line1WaitCount = lane1:getWaitCount() --           step0
        local step0Line2WaitCount = lane2:getWaitCount() --           step0
        local step0Line3WaitCount = lane3:getWaitCount() --           step0
        local step0Line4WaitCount = lane4:getWaitCount() --           step0
        local step0Lane1Prio = lane1:calculatePriority() --           step0
        local step0Lane2Prio = lane2:calculatePriority() --           step0
        local step0Lane3Prio = lane3:calculatePriority() --           step0
        local step0Lane4Prio = lane4:calculatePriority() --           step0
        local step0SwitchingAPrio = sequenceA:calculatePriority() -- step0
        local step0SwitchingBPrio = sequenceB:calculatePriority() -- step0
        local step0SwitchingCPrio = sequenceC:calculatePriority() -- step0
        it("# step0 - lane1 WaitCount", function() assert.equals(000, step0Line1WaitCount) end)
        it("# step0 - lane2 WaitCount", function() assert.equals(000, step0Line2WaitCount) end)
        it("# step0 - lane3 WaitCount", function() assert.equals(000, step0Line3WaitCount) end)
        it("# step0 - lane4 WaitCount", function() assert.equals(000, step0Line4WaitCount) end)
        it("# step0 - lane1 prio     ", function() assert.equals(003, step0Lane1Prio) end)
        it("# step0 - lane2 prio     ", function() assert.equals(000, step0Lane2Prio) end)
        it("# step0 - lane3 prio     ", function() assert.equals(000, step0Lane3Prio) end)
        it("# step0 - lane4 prio     ", function() assert.equals(000, step0Lane4Prio) end)
        it("# step0 - sequenceA prio", function() assert.equals(1.5, step0SwitchingAPrio) end)
        it("# step0 - sequenceB prio", function() assert.equals(000, step0SwitchingBPrio) end)
        it("# step0 - sequenceC prio", function() assert.equals(000, step0SwitchingCPrio) end)
        local step0Ready = crossing:isGreenPhaseFinished() --                     step0
        local step0SignalAxisK1 = EEPGetSignal(23) -- store signal    step0
        local step0SignalAxisK2 = EEPGetSignal(24) -- store signal    step0
        local step0SignalAxisK3 = EEPGetSignal(25) -- store signal    step0
        local step0SignalAxisK5 = EEPGetSignal(27) -- store signal    step0
        local step0SignalAxisK6 = EEPGetSignal(28) -- store signal    step0
        local step0SignalAxisK7 = EEPGetSignal(29) -- store signal    step0
        local step0SignalAxisK8 = EEPGetSignal(30) -- store signal    step0
        local step0SignalAxisK9 = EEPGetSignal(31) -- store signal    step0
        it("# step0 - Crossing ready     ", function() assert.is_true(step0Ready) end)
        it("# step0 - Signal K1 (23) ", function() assert.equals(GRE, step0SignalAxisK1) end)
        it("# step0 - Signal K2 (24) ", function() assert.equals(RED, step0SignalAxisK2) end)
        it("# step0 - Signal K3 (25) ", function() assert.equals(RED, step0SignalAxisK3) end)
        it("# step0 - Signal K5 (27) ", function() assert.equals(RED, step0SignalAxisK5) end)
        it("# step0 - Signal K6 (28) ", function() assert.equals(RED, step0SignalAxisK6) end)
        it("# step0 - Signal K7 (29) ", function() assert.equals(RED, step0SignalAxisK7) end)
        it("# step0 - Signal K8 (30) ", function() assert.equals(RED, step0SignalAxisK8) end)
        it("# step0 - Signal K9 (31) ", function() assert.equals(RED, step0SignalAxisK9) end)
    end

    _G.EEPTime = _G.EEPTime + 200
    ModuleRegistry.runTasks() -- First Plan crossing

    do
        local step1Line1WaitCount = lane1:getWaitCount() --           step1
        local step1Line2WaitCount = lane2:getWaitCount() --           step1
        local step1Line3WaitCount = lane3:getWaitCount() --           step1
        local step1Line4WaitCount = lane4:getWaitCount() --           step1
        local step1Lane1Prio = lane1:calculatePriority() --           step1
        local step1Lane2Prio = lane2:calculatePriority() --           step1
        local step1Lane3Prio = lane3:calculatePriority() --           step1
        local step1Lane4Prio = lane4:calculatePriority() --           step1
        local step1SwitchingAPrio = sequenceA:calculatePriority() -- step1
        local step1SwitchingBPrio = sequenceB:calculatePriority() -- step1
        local step1SwitchingCPrio = sequenceC:calculatePriority() -- step1
        it("# step1 - lane1 WaitCount", function() assert.equals(000, step1Line1WaitCount) end)
        it("# step1 - lane2 WaitCount", function() assert.equals(000, step1Line2WaitCount) end)
        it("# step1 - lane3 WaitCount", function() assert.equals(000, step1Line3WaitCount) end)
        it("# step1 - lane4 WaitCount", function() assert.equals(000, step1Line4WaitCount) end)
        it("# step1 - lane1 prio     ", function() assert.equals(003, step1Lane1Prio) end)
        it("# step1 - lane2 prio     ", function() assert.equals(000, step1Lane2Prio) end)
        it("# step1 - lane3 prio     ", function() assert.equals(000, step1Lane3Prio) end)
        it("# step1 - lane4 prio     ", function() assert.equals(000, step1Lane4Prio) end)
        it("# step1 - sequenceA prio", function() assert.equals(1.5, step1SwitchingAPrio) end)
        it("# step1 - sequenceB prio", function() assert.equals(000, step1SwitchingBPrio) end)
        it("# step1 - sequenceC prio", function() assert.equals(000, step1SwitchingCPrio) end)
        local step1Ready = crossing:isGreenPhaseFinished() --                     step1
        local step1SignalAxisK1 = EEPGetSignal(23) -- store signal    step1
        local step1SignalAxisK2 = EEPGetSignal(24) -- store signal    step1
        local step1SignalAxisK3 = EEPGetSignal(25) -- store signal    step1
        local step1SignalAxisK5 = EEPGetSignal(27) -- store signal    step1
        local step1SignalAxisK6 = EEPGetSignal(28) -- store signal    step1
        local step1SignalAxisK7 = EEPGetSignal(29) -- store signal    step1
        local step1SignalAxisK8 = EEPGetSignal(30) -- store signal    step1
        local step1SignalAxisK9 = EEPGetSignal(31) -- store signal    step1
        it("# step1 - Crossing ready    ", function() assert.is_false(step1Ready) end)
        it("# step1 - Signal K1 (23) ", function() assert.equals(RED, step1SignalAxisK1) end)
        it("# step1 - Signal K2 (24) ", function() assert.equals(RED, step1SignalAxisK2) end)
        it("# step1 - Signal K3 (25) ", function() assert.equals(RED, step1SignalAxisK3) end)
        it("# step1 - Signal K5 (27) ", function() assert.equals(RED, step1SignalAxisK5) end)
        it("# step1 - Signal K6 (28) ", function() assert.equals(RED, step1SignalAxisK6) end)
        it("# step1 - Signal K7 (29) ", function() assert.equals(RED, step1SignalAxisK7) end)
        it("# step1 - Signal K8 (30) ", function() assert.equals(RED, step1SignalAxisK8) end)
        it("# step1 - Signal K9 (31) ", function() assert.equals(RED, step1SignalAxisK9) end)
    end

    _G.EEPTime = _G.EEPTime + 200
    ModuleRegistry.runTasks() -- First Turn old to yellow + Pedestrian Red

    do
        local step3Ready = crossing:isGreenPhaseFinished() --                     step3
        local step3SignalAxisK1 = EEPGetSignal(23) -- store signal    step3
        local step3SignalAxisK2 = EEPGetSignal(24) -- store signal    step3
        local step3SignalAxisK3 = EEPGetSignal(25) -- store signal    step3
        local step3SignalAxisK5 = EEPGetSignal(27) -- store signal    step3
        local step3SignalAxisK6 = EEPGetSignal(28) -- store signal    step3
        local step3SignalAxisK7 = EEPGetSignal(29) -- store signal    step3
        local step3SignalAxisK8 = EEPGetSignal(30) -- store signal    step3
        local step3SignalAxisK9 = EEPGetSignal(31) -- store signal    step3
        it("# step3 - Crossing ready    ", function() assert.is_false(step3Ready) end)
        it("# step3 - Signal K1 (23) ", function() assert.equals(RED, step3SignalAxisK1) end)
        it("# step3 - Signal K2 (24) ", function() assert.equals(RED, step3SignalAxisK2) end)
        it("# step3 - Signal K3 (25) ", function() assert.equals(RED, step3SignalAxisK3) end)
        it("# step3 - Signal K5 (27) ", function() assert.equals(RED, step3SignalAxisK5) end)
        it("# step3 - Signal K6 (28) ", function() assert.equals(RED, step3SignalAxisK6) end)
        it("# step3 - Signal K7 (29) ", function() assert.equals(RED, step3SignalAxisK7) end)
        it("# step3 - Signal K8 (30) ", function() assert.equals(RED, step3SignalAxisK8) end)
        it("# step3 - Signal K9 (31) ", function() assert.equals(RED, step3SignalAxisK9) end)
    end

    -- _G.EEPTime = _G.EEPTime + 200
    -- ModuleRegistry.runTasks() -- First Turn old to red

    -- do
    --     local step4Ready = crossing:isGreenPhaseFinished() --                     step4
    --     local step4SignalAxisK1 = EEPGetSignal(23) -- store signal    step4
    --     local step4SignalAxisK2 = EEPGetSignal(24) -- store signal    step4
    --     local step4SignalAxisK3 = EEPGetSignal(25) -- store signal    step4
    --     local step4SignalAxisK5 = EEPGetSignal(27) -- store signal    step4
    --     local step4SignalAxisK6 = EEPGetSignal(28) -- store signal    step4
    --     local step4SignalAxisK7 = EEPGetSignal(29) -- store signal    step4
    --     local step4SignalAxisK8 = EEPGetSignal(30) -- store signal    step4
    --     local step4SignalAxisK9 = EEPGetSignal(31) -- store signal    step4
    --     it("# step4 - Crossing ready    ", function() assert.is_false(step4Ready) end)
    --     it("# step4 - Signal K1 (23) ", function() assert.equals(RED, step4SignalAxisK1) end)
    --     it("# step4 - Signal K2 (24) ", function() assert.equals(RED, step4SignalAxisK2) end)
    --     it("# step4 - Signal K3 (25) ", function() assert.equals(RED, step4SignalAxisK3) end)
    --     it("# step4 - Signal K5 (27) ", function() assert.equals(RED, step4SignalAxisK5) end)
    --     it("# step4 - Signal K6 (28) ", function() assert.equals(RED, step4SignalAxisK6) end)
    --     it("# step4 - Signal K7 (29) ", function() assert.equals(RED, step4SignalAxisK7) end)
    --     it("# step4 - Signal K8 (30) ", function() assert.equals(RED, step4SignalAxisK8) end)
    --     it("# step4 - Signal K9 (31) ", function() assert.equals(RED, step4SignalAxisK9) end)
    -- end

    -- _G.EEPTime = _G.EEPTime + 200
    -- ModuleRegistry.runTasks() -- First Turn new to red_yellow

    -- do
    --     local step5Ready = crossing:isGreenPhaseFinished() --                     step5
    --     local step5SignalAxisL1 = EEPGetSignal(11) -- store signal    step5
    --     local step5SignalAxisL2 = EEPGetSignal(12) -- store signal    step5
    --     local step5SignalAxisL3 = EEPGetSignal(13) -- store signal    step5
    --     local step5SignalAxisL4 = EEPGetSignal(14) -- store signal    step5
    --     local step5SignalAxisK1 = EEPGetSignal(23) -- store signal    step5
    --     local step5SignalAxisK2 = EEPGetSignal(24) -- store signal    step5
    --     local step5SignalAxisK3 = EEPGetSignal(25) -- store signal    step5
    --     local step5SignalAxisK5 = EEPGetSignal(27) -- store signal    step5
    --     local step5SignalAxisK6 = EEPGetSignal(28) -- store signal    step5
    --     local step5SignalAxisK7 = EEPGetSignal(29) -- store signal    step5
    --     local step5SignalAxisK8 = EEPGetSignal(30) -- store signal    step5
    --     local step5SignalAxisK9 = EEPGetSignal(31) -- store signal    step5
    --     it("# step5 - Crossing ready    ", function() assert.is_false(step5Ready) end)
    --     it("# step5 - Signal L1 (11) ", function() assert.equals(U_R, step5SignalAxisL1) end)
    --     it("# step5 - Signal L2 (12) ", function() assert.equals(U_R, step5SignalAxisL2) end)
    --     it("# step5 - Signal L3 (13) ", function() assert.equals(U_R, step5SignalAxisL3) end)
    --     it("# step5 - Signal L4 (14) ", function() assert.equals(U_R, step5SignalAxisL4) end)
    --     it("# step5 - Signal K1 (23) ", function() assert.equals(RED, step5SignalAxisK1) end)
    --     it("# step5 - Signal K2 (24) ", function() assert.equals(RED, step5SignalAxisK2) end)
    --     it("# step5 - Signal K3 (25) ", function() assert.equals(RED, step5SignalAxisK3) end)
    --     it("# step5 - Signal K5 (27) ", function() assert.equals(RED, step5SignalAxisK5) end)
    --     it("# step5 - Signal K6 (28) ", function() assert.equals(RED, step5SignalAxisK6) end)
    --     it("# step5 - Signal K7 (29) ", function() assert.equals(RED, step5SignalAxisK7) end)
    --     it("# step5 - Signal K8 (30) ", function() assert.equals(RED, step5SignalAxisK8) end)
    --     it("# step5 - Signal K9 (31) ", function() assert.equals(RED, step5SignalAxisK9) end)
    -- end

    _G.EEPTime = _G.EEPTime + 200
    ModuleRegistry.runTasks() -- First Turn new to red_yellow

    do
        local step6Ready = crossing:isGreenPhaseFinished() --                     step6
        local step6SignalAxisL1 = EEPGetSignal(11) -- store signal    step6
        local step6SignalAxisL2 = EEPGetSignal(12) -- store signal    step6
        local step6SignalAxisL3 = EEPGetSignal(13) -- store signal    step6
        local step6SignalAxisL4 = EEPGetSignal(14) -- store signal    step6
        local step6SignalAxisK1 = EEPGetSignal(23) -- store signal    step6
        local step6SignalAxisK2 = EEPGetSignal(24) -- store signal    step6
        local step6SignalAxisK3 = EEPGetSignal(25) -- store signal    step6
        local step6SignalAxisK5 = EEPGetSignal(27) -- store signal    step6
        local step6SignalAxisK6 = EEPGetSignal(28) -- store signal    step6
        local step6SignalAxisK7 = EEPGetSignal(29) -- store signal    step6
        local step6SignalAxisK8 = EEPGetSignal(30) -- store signal    step6
        local step6SignalAxisK9 = EEPGetSignal(31) -- store signal    step6
        it("# step6 - Signal L1 (11) ", function() assert.equals(U_R, step6SignalAxisL1) end)
        it("# step6 - Signal L2 (12) ", function() assert.equals(U_R, step6SignalAxisL2) end)
        it("# step6 - Signal L3 (13) ", function() assert.equals(U_R, step6SignalAxisL3) end)
        it("# step6 - Signal L4 (14) ", function() assert.equals(U_R, step6SignalAxisL4) end)
        it("# step6 - Crossing ready    ", function() assert.is_false(step6Ready) end)
        it("# step6 - Signal K1 (23) ", function() assert.equals(RYE, step6SignalAxisK1) end)
        it("# step6 - Signal K2 (24) ", function() assert.equals(RYE, step6SignalAxisK2) end)
        it("# step6 - Signal K3 (25) ", function() assert.equals(_P_, step6SignalAxisK3) end)
        it("# step6 - Signal K5 (27) ", function() assert.equals(RED, step6SignalAxisK5) end)
        it("# step6 - Signal K6 (28) ", function() assert.equals(_P_, step6SignalAxisK6) end)
        it("# step6 - Signal K7 (29) ", function() assert.equals(RED, step6SignalAxisK7) end)
        it("# step6 - Signal K8 (30) ", function() assert.equals(RED, step6SignalAxisK8) end)
        it("# step6 - Signal K9 (31) ", function() assert.equals(RYE, step6SignalAxisK9) end)
    end

    lane1:vehicleLeft("#Car1a")
    lane2:vehicleEntered("#Car2a")

    do
        local step6Line1WaitCount = lane1:getWaitCount() --           step6
        local step6Line2WaitCount = lane2:getWaitCount() --           step6
        local step6Line3WaitCount = lane3:getWaitCount() --           step6
        local step6Line4WaitCount = lane4:getWaitCount() --           step6
        local step6Lane1Prio = lane1:calculatePriority() --           step6
        local step6Lane2Prio = lane2:calculatePriority() --           step6
        local step6Lane3Prio = lane3:calculatePriority() --           step6
        local step6Lane4Prio = lane4:calculatePriority() --           step6
        local step6SwitchingAPrio = sequenceA:calculatePriority() -- step6
        local step6SwitchingBPrio = sequenceB:calculatePriority() -- step6
        local step6SwitchingCPrio = sequenceC:calculatePriority() -- step6
        it("# step6 - lane1 WaitCount", function() assert.equals(000, step6Line1WaitCount) end)
        it("# step6 - lane2 WaitCount", function() assert.equals(000, step6Line2WaitCount) end)
        it("# step6 - lane3 WaitCount", function() assert.equals(000, step6Line3WaitCount) end)
        it("# step6 - lane4 WaitCount", function() assert.equals(000, step6Line4WaitCount) end)
        it("# step6 - lane1 prio     ", function() assert.equals(000, step6Lane1Prio) end)
        it("# step6 - lane2 prio     ", function() assert.equals(003, step6Lane2Prio) end)
        it("# step6 - lane3 prio     ", function() assert.equals(000, step6Lane3Prio) end)
        it("# step6 - lane4 prio     ", function() assert.equals(000, step6Lane4Prio) end)
        it("# step6 - sequenceA prio", function() assert.equals(000, step6SwitchingAPrio) end)
        it("# step6 - sequenceB prio", function() assert.equals(001, step6SwitchingBPrio) end)
        it("# step6 - sequenceC prio", function() assert.equals(003, step6SwitchingCPrio) end)
    end

    _G.EEPTime = _G.EEPTime + 200
    ModuleRegistry.runTasks() -- First Set new to green
    _G.EEPTime = _G.EEPTime + 200
    ModuleRegistry.runTasks() -- First Set ready -- Scheduler.debug = true

    do
        local step7Ready = crossing:isGreenPhaseFinished() --         step7
        local step7SignalAxisL1 = EEPGetSignal(11) -- store signal    step7
        local step7SignalAxisL2 = EEPGetSignal(12) -- store signal    step7
        local step7SignalAxisL3 = EEPGetSignal(13) -- store signal    step7
        local step7SignalAxisL4 = EEPGetSignal(14) -- store signal    step7
        local step7SignalAxisK1 = EEPGetSignal(23) -- store signal    step7
        local step7SignalAxisK2 = EEPGetSignal(24) -- store signal    step7
        local step7SignalAxisK3 = EEPGetSignal(25) -- store signal    step7
        local step7SignalAxisK5 = EEPGetSignal(27) -- store signal    step7
        local step7SignalAxisK6 = EEPGetSignal(28) -- store signal    step7
        local step7SignalAxisK7 = EEPGetSignal(29) -- store signal    step7
        local step7SignalAxisK8 = EEPGetSignal(30) -- store signal    step7
        local step7SignalAxisK9 = EEPGetSignal(31) -- store signal    step7
        it("# step7 - Signal L1 (11) ", function() assert.equals(U_G, step7SignalAxisL1) end)
        it("# step7 - Signal L2 (12) ", function() assert.equals(U_R, step7SignalAxisL2) end)
        it("# step7 - Signal L3 (13) ", function() assert.equals(U_R, step7SignalAxisL3) end)
        it("# step7 - Signal L4 (14) ", function() assert.equals(U_G, step7SignalAxisL4) end)
        it("# step7 - Crossing ready    ", function() assert.is_false(step7Ready) end)
        it("# step7 - Signal K1 (23) ", function() assert.equals(GRE, step7SignalAxisK1) end)
        it("# step7 - Signal K2 (24) ", function() assert.equals(GRE, step7SignalAxisK2) end)
        it("# step7 - Signal K3 (25) ", function() assert.equals(_P_, step7SignalAxisK3) end)
        it("# step7 - Signal K5 (27) ", function() assert.equals(RED, step7SignalAxisK5) end)
        it("# step7 - Signal K6 (28) ", function() assert.equals(_P_, step7SignalAxisK6) end)
        it("# step7 - Signal K7 (29) ", function() assert.equals(RED, step7SignalAxisK7) end)
        it("# step7 - Signal K8 (30) ", function() assert.equals(RED, step7SignalAxisK8) end)
        it("# step7 - Signal K9 (31) ", function() assert.equals(GRE, step7SignalAxisK9) end)
    end

    lane2:vehicleLeft("#Car2a")
    lane4:vehicleEntered("#Car4a")

    do
        local step7Line1WaitCount = lane1:getWaitCount() --           step7
        local step7Line2WaitCount = lane2:getWaitCount() --           step7
        local step7Line3WaitCount = lane3:getWaitCount() --           step7
        local step7Line4WaitCount = lane4:getWaitCount() --           step7
        local step7Lane1Prio = lane1:calculatePriority() --           step7
        local step7Lane2Prio = lane2:calculatePriority() --           step7
        local step7Lane3Prio = lane3:calculatePriority() --           step7
        local step7Lane4Prio = lane4:calculatePriority() --           step7
        local step7SwitchingAPrio = sequenceA:calculatePriority() -- step7
        local step7SwitchingBPrio = sequenceB:calculatePriority() -- step7
        local step7SwitchingCPrio = sequenceC:calculatePriority() -- step7
        it("# step7 - lane1 WaitCount", function() assert.equals(000, step7Line1WaitCount) end)
        it("# step7 - lane2 WaitCount", function() assert.equals(001, step7Line2WaitCount) end)
        it("# step7 - lane3 WaitCount", function() assert.equals(001, step7Line3WaitCount) end)
        it("# step7 - lane4 WaitCount", function() assert.equals(000, step7Line4WaitCount) end)
        it("# step7 - lane1 prio     ", function() assert.equals(000, step7Lane1Prio) end)
        it("# step7 - lane2 prio     ", function() assert.equals(001, step7Lane2Prio) end)
        it("# step7 - lane3 prio     ", function() assert.equals(001, step7Lane3Prio) end)
        it("# step7 - lane4 prio     ", function() assert.equals(003, step7Lane4Prio) end)
        it("# step7 - sequenceA prio", function() assert.equals(1.5, step7SwitchingAPrio) end)
        it("# step7 - sequenceB prio", function() assert.equals(5 / 3, step7SwitchingBPrio) end)
        it("# step7 - sequenceC prio", function() assert.equals(001, step7SwitchingCPrio) end)
    end

    _G.EEPTime = _G.EEPTime + 200
    ModuleRegistry.runTasks() -- Second Plan switched

    do
        local step8Ready = crossing:isGreenPhaseFinished() --                     step8
        local step8SignalAxisL1 = EEPGetSignal(11) -- store signal    step8
        local step8SignalAxisL2 = EEPGetSignal(12) -- store signal    step8
        local step8SignalAxisL3 = EEPGetSignal(13) -- store signal    step8
        local step8SignalAxisL4 = EEPGetSignal(14) -- store signal    step8
        local step8SignalAxisK1 = EEPGetSignal(23) -- store signal    step8
        local step8SignalAxisK2 = EEPGetSignal(24) -- store signal    step8
        local step8SignalAxisK3 = EEPGetSignal(25) -- store signal    step8
        local step8SignalAxisK5 = EEPGetSignal(27) -- store signal    step8
        local step8SignalAxisK6 = EEPGetSignal(28) -- store signal    step8
        local step8SignalAxisK7 = EEPGetSignal(29) -- store signal    step8
        local step8SignalAxisK8 = EEPGetSignal(30) -- store signal    step8
        local step8SignalAxisK9 = EEPGetSignal(31) -- store signal    step8
        it("# step8 - Crossing ready    ", function() assert.is_false(step8Ready) end)
        it("# step8 - Signal L1 (11) ", function() assert.equals(U_G, step8SignalAxisL1) end)
        it("# step8 - Signal L2 (12) ", function() assert.equals(U_R, step8SignalAxisL2) end)
        it("# step8 - Signal L3 (13) ", function() assert.equals(U_R, step8SignalAxisL3) end)
        it("# step8 - Signal L4 (14) ", function() assert.equals(U_G, step8SignalAxisL4) end)
        it("# step8 - Signal K1 (23) ", function() assert.equals(GRE, step8SignalAxisK1) end)
        it("# step8 - Signal K2 (24) ", function() assert.equals(GRE, step8SignalAxisK2) end)
        it("# step8 - Signal K3 (25) ", function() assert.equals(_P_, step8SignalAxisK3) end)
        it("# step8 - Signal K5 (27) ", function() assert.equals(RED, step8SignalAxisK5) end)
        it("# step8 - Signal K6 (28) ", function() assert.equals(_P_, step8SignalAxisK6) end)
        it("# step8 - Signal K7 (29) ", function() assert.equals(RED, step8SignalAxisK7) end)
        it("# step8 - Signal K8 (30) ", function() assert.equals(RED, step8SignalAxisK8) end)
        it("# step8 - Signal K9 (31) ", function() assert.equals(GRE, step8SignalAxisK9) end)
    end

    _G.EEPTime = _G.EEPTime + 200
    ModuleRegistry.runTasks() -- Second Old Pedestrians RED

    do
        local step9Ready = crossing:isGreenPhaseFinished() --                     step9
        local step9SignalAxisL1 = EEPGetSignal(11) -- store signal    step9
        local step9SignalAxisL2 = EEPGetSignal(12) -- store signal    step9
        local step9SignalAxisL3 = EEPGetSignal(13) -- store signal    step9
        local step9SignalAxisL4 = EEPGetSignal(14) -- store signal    step9
        local step9SignalAxisK1 = EEPGetSignal(23) -- store signal    step9
        local step9SignalAxisK2 = EEPGetSignal(24) -- store signal    step9
        local step9SignalAxisK3 = EEPGetSignal(25) -- store signal    step9
        local step9SignalAxisK5 = EEPGetSignal(27) -- store signal    step9
        local step9SignalAxisK6 = EEPGetSignal(28) -- store signal    step9
        local step9SignalAxisK7 = EEPGetSignal(29) -- store signal    step9
        local step9SignalAxisK8 = EEPGetSignal(30) -- store signal    step9
        local step9SignalAxisK9 = EEPGetSignal(31) -- store signal    step9
        it("# step9 - Crossing ready    ", function() assert.is_false(step9Ready) end)
        it("# step9 - Signal L1 (11) ", function() assert.equals(U_G, step9SignalAxisL1) end)
        it("# step9 - Signal L2 (12) ", function() assert.equals(U_R, step9SignalAxisL2) end)
        it("# step9 - Signal L3 (13) ", function() assert.equals(U_R, step9SignalAxisL3) end)
        it("# step9 - Signal L4 (14) ", function() assert.equals(U_G, step9SignalAxisL4) end)
        it("# step9 - Signal K1 (23) ", function() assert.equals(GRE, step9SignalAxisK1) end)
        it("# step9 - Signal K2 (24) ", function() assert.equals(GRE, step9SignalAxisK2) end)
        it("# step9 - Signal K3 (25) ", function() assert.equals(RED, step9SignalAxisK3) end)
        it("# step9 - Signal K5 (27) ", function() assert.equals(RED, step9SignalAxisK5) end)
        it("# step9 - Signal K6 (28) ", function() assert.equals(RED, step9SignalAxisK6) end)
        it("# step9 - Signal K7 (29) ", function() assert.equals(RED, step9SignalAxisK7) end)
        it("# step9 - Signal K8 (30) ", function() assert.equals(RED, step9SignalAxisK8) end)
        it("# step9 - Signal K9 (31) ", function() assert.equals(GRE, step9SignalAxisK9) end)
    end

    _G.EEPTime = _G.EEPTime + 200
    ModuleRegistry.runTasks() -- Second Old Lanes YEL

    do
        local step10Ready = crossing:isGreenPhaseFinished() --                     step10
        local step10SignalAxisL1 = EEPGetSignal(11) -- store signal    step10
        local step10SignalAxisL2 = EEPGetSignal(12) -- store signal    step10
        local step10SignalAxisL3 = EEPGetSignal(13) -- store signal    step10
        local step10SignalAxisL4 = EEPGetSignal(14) -- store signal    step10
        local step10SignalAxisK1 = EEPGetSignal(23) -- store signal    step10
        local step10SignalAxisK2 = EEPGetSignal(24) -- store signal    step10
        local step10SignalAxisK3 = EEPGetSignal(25) -- store signal    step10
        local step10SignalAxisK5 = EEPGetSignal(27) -- store signal    step10
        local step10SignalAxisK6 = EEPGetSignal(28) -- store signal    step10
        local step10SignalAxisK7 = EEPGetSignal(29) -- store signal    step10
        local step10SignalAxisK8 = EEPGetSignal(30) -- store signal    step10
        local step10SignalAxisK9 = EEPGetSignal(31) -- store signal    step10
        it("# step10 - Crossing ready    ", function() assert.is_false(step10Ready) end)
        it("# step10 - Signal L1 (11) ", function() assert.equals(U_R, step10SignalAxisL1) end)
        it("# step10 - Signal L2 (12) ", function() assert.equals(U_R, step10SignalAxisL2) end)
        it("# step10 - Signal L3 (13) ", function() assert.equals(U_R, step10SignalAxisL3) end)
        it("# step10 - Signal L4 (14) ", function() assert.equals(U_G, step10SignalAxisL4) end)
        it("# step10 - Signal K1 (23) ", function() assert.equals(YEL, step10SignalAxisK1) end)
        it("# step10 - Signal K2 (24) ", function() assert.equals(YEL, step10SignalAxisK2) end)
        it("# step10 - Signal K3 (25) ", function() assert.equals(RED, step10SignalAxisK3) end)
        it("# step10 - Signal K5 (27) ", function() assert.equals(RED, step10SignalAxisK5) end)
        it("# step10 - Signal K6 (28) ", function() assert.equals(RED, step10SignalAxisK6) end)
        it("# step10 - Signal K7 (29) ", function() assert.equals(RED, step10SignalAxisK7) end)
        it("# step10 - Signal K8 (30) ", function() assert.equals(RED, step10SignalAxisK8) end)
        it("# step10 - Signal K9 (31) ", function() assert.equals(GRE, step10SignalAxisK9) end)
    end

    _G.EEPTime = _G.EEPTime + 200
    ModuleRegistry.runTasks() -- Second Old Lanes RED

    do
        local step11Ready = crossing:isGreenPhaseFinished() --                     step11
        local step11SignalAxisL1 = EEPGetSignal(11) -- store signal    step11
        local step11SignalAxisL2 = EEPGetSignal(12) -- store signal    step11
        local step11SignalAxisL3 = EEPGetSignal(13) -- store signal    step11
        local step11SignalAxisL4 = EEPGetSignal(14) -- store signal    step11
        local step11SignalAxisK1 = EEPGetSignal(23) -- store signal    step11
        local step11SignalAxisK2 = EEPGetSignal(24) -- store signal    step11
        local step11SignalAxisK3 = EEPGetSignal(25) -- store signal    step11
        local step11SignalAxisK5 = EEPGetSignal(27) -- store signal    step11
        local step11SignalAxisK6 = EEPGetSignal(28) -- store signal    step11
        local step11SignalAxisK7 = EEPGetSignal(29) -- store signal    step11
        local step11SignalAxisK8 = EEPGetSignal(30) -- store signal    step11
        local step11SignalAxisK9 = EEPGetSignal(31) -- store signal    step11
        it("# step11 - Crossing ready    ", function() assert.is_false(step11Ready) end)
        it("# step11 - Signal L1 (11) ", function() assert.equals(U_R, step11SignalAxisL1) end)
        it("# step11 - Signal L2 (12) ", function() assert.equals(U_R, step11SignalAxisL2) end)
        it("# step11 - Signal L3 (13) ", function() assert.equals(U_R, step11SignalAxisL3) end)
        it("# step11 - Signal L4 (14) ", function() assert.equals(U_G, step11SignalAxisL4) end)
        it("# step11 - Signal K1 (23) ", function() assert.equals(RED, step11SignalAxisK1) end)
        it("# step11 - Signal K2 (24) ", function() assert.equals(RED, step11SignalAxisK2) end)
        it("# step11 - Signal K3 (25) ", function() assert.equals(RED, step11SignalAxisK3) end)
        it("# step11 - Signal K5 (27) ", function() assert.equals(RED, step11SignalAxisK5) end)
        it("# step11 - Signal K6 (28) ", function() assert.equals(RED, step11SignalAxisK6) end)
        it("# step11 - Signal K7 (29) ", function() assert.equals(RED, step11SignalAxisK7) end)
        it("# step11 - Signal K8 (30) ", function() assert.equals(RED, step11SignalAxisK8) end)
        it("# step11 - Signal K9 (31) ", function() assert.equals(GRE, step11SignalAxisK9) end)
    end

    _G.EEPTime = _G.EEPTime + 200
    ModuleRegistry.runTasks() -- Second New Lanes YEL

    do
        local step12Ready = crossing:isGreenPhaseFinished() --                     step12
        local step12SignalAxisL1 = EEPGetSignal(11) -- store signal    step12
        local step12SignalAxisL2 = EEPGetSignal(12) -- store signal    step12
        local step12SignalAxisL3 = EEPGetSignal(13) -- store signal    step12
        local step12SignalAxisL4 = EEPGetSignal(14) -- store signal    step12
        local step12SignalAxisK1 = EEPGetSignal(23) -- store signal    step12
        local step12SignalAxisK2 = EEPGetSignal(24) -- store signal    step12
        local step12SignalAxisK3 = EEPGetSignal(25) -- store signal    step12
        local step12SignalAxisK5 = EEPGetSignal(27) -- store signal    step12
        local step12SignalAxisK6 = EEPGetSignal(28) -- store signal    step12
        local step12SignalAxisK7 = EEPGetSignal(29) -- store signal    step12
        local step12SignalAxisK8 = EEPGetSignal(30) -- store signal    step12
        local step12SignalAxisK9 = EEPGetSignal(31) -- store signal    step12
        it("# step12 - Crossing ready    ", function() assert.is_false(step12Ready) end)
        it("# step12 - Signal L1 (11) ", function() assert.equals(U_R, step12SignalAxisL1) end)
        it("# step12 - Signal L2 (12) ", function() assert.equals(U_R, step12SignalAxisL2) end)
        it("# step12 - Signal L3 (13) ", function() assert.equals(U_R, step12SignalAxisL3) end)
        it("# step12 - Signal L4 (14) ", function() assert.equals(U_G, step12SignalAxisL4) end)
        it("# step12 - Signal K1 (23) ", function() assert.equals(RED, step12SignalAxisK1) end)
        it("# step12 - Signal K2 (24) ", function() assert.equals(RED, step12SignalAxisK2) end)
        it("# step12 - Signal K3 (25) ", function() assert.equals(RED, step12SignalAxisK3) end)
        it("# step12 - Signal K5 (27) ", function() assert.equals(RED, step12SignalAxisK5) end)
        it("# step12 - Signal K6 (28) ", function() assert.equals(RED, step12SignalAxisK6) end)
        it("# step12 - Signal K7 (29) ", function() assert.equals(RED, step12SignalAxisK7) end) -- NOT YELLOW SPECIAL!
        it("# step12 - Signal K8 (30) ", function() assert.equals(RYE, step12SignalAxisK8) end)
        it("# step12 - Signal K9 (31) ", function() assert.equals(GRE, step12SignalAxisK9) end)
    end

    _G.EEPTime = _G.EEPTime + 200
    ModuleRegistry.runTasks() -- Second New Lanes GRE

    do
        local step13Ready = crossing:isGreenPhaseFinished() --                     step13
        local step13SignalAxisL1 = EEPGetSignal(11) -- store signal    step13
        local step13SignalAxisL2 = EEPGetSignal(12) -- store signal    step13
        local step13SignalAxisL3 = EEPGetSignal(13) -- store signal    step13
        local step13SignalAxisL4 = EEPGetSignal(14) -- store signal    step13
        local step13SignalAxisK1 = EEPGetSignal(23) -- store signal    step13
        local step13SignalAxisK2 = EEPGetSignal(24) -- store signal    step13
        local step13SignalAxisK3 = EEPGetSignal(25) -- store signal    step13
        local step13SignalAxisK5 = EEPGetSignal(27) -- store signal    step13
        local step13SignalAxisK6 = EEPGetSignal(28) -- store signal    step13
        local step13SignalAxisK7 = EEPGetSignal(29) -- store signal    step13
        local step13SignalAxisK8 = EEPGetSignal(30) -- store signal    step13
        local step13SignalAxisK9 = EEPGetSignal(31) -- store signal    step13
        it("# step13 - Crossing ready    ", function() assert.is_false(step13Ready) end)
        it("# step13 - Signal L1 (11) ", function() assert.equals(U_R, step13SignalAxisL1) end)
        it("# step13 - Signal L2 (12) ", function() assert.equals(U_R, step13SignalAxisL2) end)
        it("# step13 - Signal L3 (13) ", function() assert.equals(U_G, step13SignalAxisL3) end)
        it("# step13 - Signal L4 (14) ", function() assert.equals(U_G, step13SignalAxisL4) end)
        it("# step13 - Signal K1 (23) ", function() assert.equals(RED, step13SignalAxisK1) end)
        it("# step13 - Signal K2 (24) ", function() assert.equals(RED, step13SignalAxisK2) end)
        it("# step13 - Signal K3 (25) ", function() assert.equals(RED, step13SignalAxisK3) end)
        it("# step13 - Signal K5 (27) ", function() assert.equals(RED, step13SignalAxisK5) end)
        it("# step13 - Signal K6 (28) ", function() assert.equals(RED, step13SignalAxisK6) end)
        it("# step13 - Signal K7 (29) ", function() assert.equals(GRE, step13SignalAxisK7) end)
        it("# step13 - Signal K8 (30) ", function() assert.equals(GRE, step13SignalAxisK8) end)
        it("# step13 - Signal K9 (31) ", function() assert.equals(GRE, step13SignalAxisK9) end)
        pending("Look that each lane turns their signal to green")
        pending("Look that each lane turns their signal to red")
        pending("Look that each lane turns their signal to green on route only")
        pending("Look that each lane turns their signal to red on route only")

        -- Check the lane signal switching
        do
        lane2:vehicleEntered("#Car2a")
            local afterTurnCarEntered = EEPGetSignal(12) -- store signal    step13
            it("# step13 - Signal L2 (12) ", function() assert.equals(U_G, afterTurnCarEntered) end)
        end
        do
            lane2:vehicleEntered("#Car3a")
            local afterOtherCarEntered = EEPGetSignal(12) -- store signal    step13
            it("# step13 - Signal L2 (12) ", function() assert.equals(U_G, afterOtherCarEntered) end)
        end
        do
            lane2:vehicleLeft("#Car2a")
            local afterTurnCarLeft = EEPGetSignal(12) -- store signal    step13
            it("# step13 - Signal L2 (12) ", function() assert.equals(U_R, afterTurnCarLeft) end)
        end
    end
end)
