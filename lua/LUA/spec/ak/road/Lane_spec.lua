-- Lua code for testing the lane's functions

describe("Lane ...", function()
    insulate("Register traffic lights", function()
        require("ak.core.eep.AkEepFunktionen")
        local TrafficLightModel = require("ak.road.TrafficLightModel")
        local TrafficLightState = require("ak.road.TrafficLightState")
        local TrafficLight = require("ak.road.TrafficLight")
        local Lane = require("ak.road.Lane")
        local signalId = 55

        -- Set the route for train "#Car1"
        EEPSetTrainRoute("#Car1", "Some Route")
        -- Traffic Light which is visible to tell the lanes traffic to drive
        local laneTrafficLight = TrafficLight:new(signalId, TrafficLightModel.Unsichtbar_2er)
        -- EEP Signal, which is used to start and stop the lanes traffic (needs to be switched to green too)
        local laneSignal = TrafficLight:new(11, TrafficLightModel.Unsichtbar_2er)

        local lane = Lane:new("Lane A", 34, laneSignal)
        local tlsBeforeDriveOn = lane.trafficLightsTodriveOn
        it("Lane has signal", function() assert.is_nil(tlsBeforeDriveOn) end)

        lane:driveOn(laneTrafficLight)

        it("Lane has signal", function() assert.is_truthy(lane.trafficLightsTodriveOn) end)
        it("Lane has signal", function() assert.are.same({}, lane.trafficLightsTodriveOn[laneTrafficLight]) end)
        describe("Can drive at red", function()
            laneTrafficLight:switchTo(TrafficLightState.RED)
            local canDriveAtRed = lane:canDrive()
            it("SignalId is correct", function()
                assert.equals(TrafficLightModel.Unsichtbar_2er.signalIndexRed, EEPGetSignal(laneTrafficLight.signalId))
            end)
            it("canDrive()", function() assert.is_false(canDriveAtRed) end)
        end)
        describe("Can drive at green", function()
            laneTrafficLight:switchTo(TrafficLightState.GREEN)
            local canDriveAtGreen = lane:canDrive()
            it("SignalId is correct", function()
                assert.equals(TrafficLightModel.Unsichtbar_2er.signalIndexGreen,
                EEPGetSignal(laneTrafficLight.signalId))
            end)
            it("canDrive()", function() assert.is_true(canDriveAtGreen) end)
        end)
    end)
    insulate("Can drive on route", function ()
        require("ak.core.eep.AkEepFunktionen")
        local TrafficLightModel = require("ak.road.TrafficLightModel")
        local TrafficLightState = require("ak.road.TrafficLightState")
        local TrafficLight = require("ak.road.TrafficLight")
        local Lane = require("ak.road.Lane")

        -- Set the route for train "#Car1"
        EEPSetTrainRoute("#Car1", "Matching Route")
        -- Traffic Light which is visible to tell the lanes traffic to drive
        local K1 = TrafficLight:new(55, TrafficLightModel.JS2_3er_mit_FG)
        local K2 = TrafficLight:new(56, TrafficLightModel.JS2_3er_mit_FG)
        -- EEP Signal, which is used to start and stop the lanes traffic (needs to be switched to green too)
        local laneSignal = TrafficLight:new(11, TrafficLightModel.Unsichtbar_2er)

        ---@type Lane
        local lane = Lane:new("Lane A", 34, laneSignal)
        local tlsBeforeDriveOn = lane.trafficLightsTodriveOn
        it("Lane has signal", function() assert.is_nil(tlsBeforeDriveOn) end)

        lane:driveOn(K1)
        lane:driveOn(K2, "Some other route", "Matching Route", "Another")

        it("Lane has signal", function() assert.is_truthy(lane.trafficLightsTodriveOn) end)
        it("Lane has signal", function() assert.are.same({}, lane.trafficLightsTodriveOn[K1]) end)
        it("Lane has signal", function()
            assert.are.same({"Some other route", "Matching Route", "Another" }, lane.trafficLightsTodriveOn[K2])
        end)
        describe("K1 can drive at red", function()
            K1:switchTo(TrafficLightState.RED)
            local canDriveAtRed = lane:canDrive()
            local signalIndexK1 = EEPGetSignal(K1.signalId)
            it("SignalId is correct", function()
                assert.equals(TrafficLightModel.JS2_3er_mit_FG.signalIndexRed,signalIndexK1)
            end)
                it("canDrive()", function() assert.is_false(canDriveAtRed) end)
                K1:switchTo(TrafficLightState.RED)
            end)
        describe("K1 can drive at green", function()
            K1:switchTo(TrafficLightState.GREEN)
            local canDriveAtGreen = lane:canDrive()
            local signalIndexK1 = EEPGetSignal(K1.signalId)
            it("SignalId is correct", function()
                assert.equals(TrafficLightModel.JS2_3er_mit_FG.signalIndexGreen, signalIndexK1)
            end)
            it("canDrive()", function() assert.is_true(canDriveAtGreen) end)
            K1:switchTo(TrafficLightState.RED)
        end)
        describe("K2 can drive at green", function()
            K2:switchTo(TrafficLightState.RED)
            local canDriveAtRed = lane:canDrive()
            local signalIndexK2 = EEPGetSignal(K2.signalId)
            it("SignalId is correct", function()
                assert.equals(TrafficLightModel.JS2_3er_mit_FG.signalIndexRed, signalIndexK2)
                end)
            it("canDrive()", function() assert.is_false(canDriveAtRed) end)
            K2:switchTo(TrafficLightState.RED)
        end)
        describe("K2 can drive at green", function()
            K2:switchTo(TrafficLightState.GREEN)
            local signalIndexK2 = EEPGetSignal(K2.signalId)
            it("SignalId is correct", function()
                assert.equals(TrafficLightModel.JS2_3er_mit_FG.signalIndexGreen, signalIndexK2)
                end)

            local canDriveNoVehicle = lane:canDrive()
            it("canDrive() noVehicle", function() assert.is_false(canDriveNoVehicle) end)

            lane:vehicleEntered("#Car1")
            local firstVehiclesRoute1 = lane.firstVehiclesRoute
            local canDriveAtGreen2 = lane:canDrive()
            it("canDrive() vehicleWithRoute", function() assert.equals("Matching Route", firstVehiclesRoute1) end)
            it("canDrive() vehicleWithRoute", function() assert.is_true(canDriveAtGreen2) end)
            lane:vehicleLeft("#Car1")

            lane:vehicleEntered( "#Car2")
            local firstVehiclesRoute2 = lane.firstVehiclesRoute
            local canDriveAtGreen3 = lane:canDrive()
            it("canDrive() vehicleWithRoute", function() assert.equals("Alle", firstVehiclesRoute2) end)
            it("canDrive() vehicleWithRoute", function( ) assert.is_false(canDriveAtGreen3) end)
            lane:vehicleLeft("#Car2")

            K2:switchTo(TrafficLightState.RED)
        end)
    end)

    insulate("Register traffic lights", function()
        require("ak.core.eep.AkEepFunktionen")
        local TrafficLightModel = require("ak.road.TrafficLightModel")
        local TrafficLightState = require("ak.road.TrafficLightState")
        local TrafficLight = require("ak.road.TrafficLight")
        local Lane = require("ak.road.Lane")
        local signalId = 55

        -- Set the route for train "#Car1"
        EEPSetTrainRoute("#Car1", "Some Route")
        -- Traffic Light which is visible to tell the lanes traffic to drive
        local K1 = TrafficLight:new(signalId, TrafficLightModel.JS2_3er_ohne_FG)
        -- EEP Signal, which is used to start and stop the lanes traffic (needs to be switched to green too)
        local L1 = TrafficLight:new(11, TrafficLightModel.Unsichtbar_2er)

        local lane = Lane:new("Lane A", 34, L1)
        local tlsBeforeDriveOn = lane.trafficLightsTodriveOn
        it("Lane has signal", function() assert.is_nil(tlsBeforeDriveOn) end)

        lane:driveOn(K1)

        it("Lane has signal", function() assert.is_truthy(lane.trafficLightsTodriveOn) end)
        it("Lane has signal", function() assert.are.same({}, lane.trafficLightsTodriveOn[K1]) end)
        describe("Can drive at red", function()
            K1:switchTo(TrafficLightState.RED)
            local canDriveAtRed = lane:canDrive()
            local k1SignalIndex = EEPGetSignal(K1.signalId)
            it("SignalId is correct", function()
                assert.equals(TrafficLightModel.JS2_3er_ohne_FG.signalIndexRed, k1SignalIndex)
            end)
            it("canDrive()", function() assert.is_false(canDriveAtRed) end)
        end)
        describe("Can drive at green", function()
            K1:switchTo(TrafficLightState.GREEN)
            local canDriveAtGreen = lane:canDrive()
            local k1SignalIndex = EEPGetSignal(K1.signalId)
            it("SignalId is correct", function()
                assert.equals(TrafficLightModel.JS2_3er_ohne_FG.signalIndexGreen,
                k1SignalIndex)
            end)
            it("canDrive()", function() assert.is_true(canDriveAtGreen) end)
        end)
    end)

    insulate("Show requests on the correct traffic lights", function()
        require("ak.core.eep.AkEepFunktionen")
        local TrafficLightModel = require("ak.road.TrafficLightModel")
        --local TrafficLightState = require("ak.road.TrafficLightState")
        local TrafficLight = require("ak.road.TrafficLight")
        local Lane = require("ak.road.Lane")
        local signalId = 55

        -- Set the route for train "#Car1"
        EEPSetTrainRoute("#Car1", "Route A")
        EEPSetTrainRoute("#Car2", "Route B")
        EEPSetTrainRoute("#Car3", "Route C")

        -- Traffic Light which is visible to tell the lanes traffic to drive
        local K1 = TrafficLight:new(signalId, TrafficLightModel.JS2_3er_ohne_FG,
        "#11_RED", "#12_GREEN", "#13_YELLOW", "#14_REQUEST")
        local K2 = TrafficLight:new(signalId, TrafficLightModel.JS2_3er_ohne_FG,
        "#21_RED", "#22_GREEN", "#23_YELLOW", "#24_REQUEST")
        local K3 = TrafficLight:new(signalId, TrafficLightModel.JS2_3er_ohne_FG,
        "#31_RED", "#32_GREEN", "#33_YELLOW", "#34_REQUEST")
        -- EEP Signal, which is used to start and stop the lanes traffic (needs to be switched to green too)
        local L1 = TrafficLight:new(11, TrafficLightModel.Unsichtbar_2er)

        local lane = Lane:new("Lane A", 34, L1)
        lane:showRequestsOn(K1)
        lane:showRequestsOn(K2, "Route A")
        lane:showRequestsOn(K3, "Route B", "Route C")

        it("K1 is registered for !ALL!", function() assert.same({ K1 }, lane.requestTrafficLights["!ALL!"]) end)
        it("K2 is registered for Route A", function() assert.same({ K2 }, lane.requestTrafficLights["Route A"]) end)
        it("K3 is registered for Route B", function() assert.same({ K3 }, lane.requestTrafficLights["Route B"]) end)
        it("K3 is registered for Route C", function() assert.same({ K3 }, lane.requestTrafficLights["Route C"]) end)

        lane:vehicleLeft("#Car4")
        local _, lightOnK1NoCar = EEPStructureGetLight("#14")
        local _, lightOnK2NoCar = EEPStructureGetLight("#24")
        local _, lightOnK3NoCar = EEPStructureGetLight("#34")
        it("  Light on K1 NoCar", function() assert.is_false(lightOnK1NoCar) end)
        it("  Light on K2 NoCar", function() assert.is_false(lightOnK2NoCar) end)
        it("  Light on K3 NoCar", function() assert.is_false(lightOnK3NoCar) end)

        lane:vehicleEntered("#Car2")
        lane:vehicleEntered("#Car1")
        local _, lightOnK1Car2 = EEPStructureGetLight("#14")
        local _, lightOnK2Car2 = EEPStructureGetLight("#24")
        local _, lightOnK3Car2 = EEPStructureGetLight("#34")
        it("  Light on K1 Car2", function() assert.is_true(lightOnK1Car2) end)
        it("  Light on K2 Car2", function() assert.is_true(lightOnK2Car2) end)
        it("  Light on K3 Car2", function() assert.is_true(lightOnK3Car2) end)
        lane:vehicleLeft("#Car2")
        lane:vehicleLeft("#Car1")

        lane:vehicleEntered("#Car3")
        local _, lightOnK1Car3 = EEPStructureGetLight("#14")
        local _, lightOnK2Car3 = EEPStructureGetLight("#24")
        local _, lightOnK3Car3 = EEPStructureGetLight("#34")
        it("  Light on K1 Car3", function() assert.is_true(lightOnK1Car3) end)
        it("  Light on K2 Car3", function() assert.is_false(lightOnK2Car3) end)
        it("  Light on K3 Car3", function() assert.is_true(lightOnK3Car3) end)
        lane:vehicleLeft("#Car3")

        lane:vehicleLeft("#Car3")
        local _, lightOnK1NoCar2 = EEPStructureGetLight("#14")
        local _, lightOnK2NoCar2 = EEPStructureGetLight("#24")
        local _, lightOnK3NoCar2 = EEPStructureGetLight("#34")
        it("  Light on K1 NoCar", function() assert.is_false(lightOnK1NoCar2) end)
        it("  Light on K2 NoCar", function() assert.is_false(lightOnK2NoCar2) end)
        it("  Light on K3 NoCar", function() assert.is_false(lightOnK3NoCar2) end)
    end)

    describe("Legacy loading", function ()
        insulate("No saved vehicles, but a counter", function()
            require("ak.core.eep.AkEepFunktionen")
            local StorageUtility = require("ak.storage.StorageUtility")
            local TrafficLightModel = require("ak.road.TrafficLightModel")
            local TrafficLight = require("ak.road.TrafficLight")
            local Lane = require("ak.road.Lane")
            local signalId = 55

            StorageUtility.saveTable(34, { f = "4" })
            local lane = Lane:new("Lane A", 34, TrafficLight:new(signalId, TrafficLightModel.Unsichtbar_2er))
            insulate("Vehicles have generic names", function()
                it("Queue looks as follows", function()
                    assert.are.same({ "train 1", "train 2", "train 3", "train 4" }, lane.queue:elements())
                end)
                it("Lane queue size is 4", function() assert.equals(4, lane.queue:size()) end)
                it("Lane vehicle count is 4", function() assert.equals(4, lane.vehicleCount) end)
            end)
            insulate("First vehicle leaving will remove one element from queue", function()
                lane:vehicleLeft("train 1")
                it("Queue looks as follows", function()
                    assert.are.same({ "train 2", "train 3", "train 4" }, lane.queue:elements())
                end)
                it("Lane queue size is decreased", function() assert.equals(3, lane.queue:size()) end)
                it("Lane vehicle count is decreased", function() assert.equals(3, lane.vehicleCount) end)
            end)
            insulate("Third vehicle leaving will remove two more elements from queue", function()
                lane:vehicleLeft("train 3")
                it("Queue looks as follows", function()
                    assert.are.same({ "train 4" }, lane.queue:elements())
                end)
                it("Lane queue size is decreased", function() assert.equals(1, lane.queue:size()) end)
                it("Lane vehicle count is decreased", function() assert.equals(1, lane.vehicleCount) end)
            end)
            insulate("all elements are removed from queue", function()
                lane:vehicleLeft(function()
                    assert.are.same({ }, lane.queue:elements())
                end)
                it("Lane queue size is decreased", function() assert.equals(0, lane.queue:size()) end)
                it("Lane vehicle count is decreased", function() assert.equals(0, lane.vehicleCount) end)
            end)
            insulate("all entries until the first good entered vehicle are removed from queue", function()
                lane:vehicleEntered("train 5")
                lane:vehicleEntered("train 6")
                lane:vehicleLeft("no matching train")
                it("Queue looks as follows", function()
                    assert.are.same({ "train 5", "train 6" }, lane.queue:elements())
                end)
                it("Lane queue size is decreased", function() assert.equals(2, lane.queue:size()) end)
                it("Lane vehicle count is decreased", function() assert.equals(2, lane.vehicleCount) end)
            end)
        end)
    end)


    describe(":useSignalForQueue()", function()
        insulate("disabled", function()
            require("ak.core.eep.AkEepFunktionen")
            local TrafficLightModel = require("ak.road.TrafficLightModel")
            local TrafficLight = require("ak.road.TrafficLight")
            local Lane = require("ak.road.Lane")
            local signalId = 55

            -- Set the route for train "#Car1"
            EEPSetTrainRoute("#Car1", "Some Route")
            local lane = Lane:new("Lane A", 34, TrafficLight:new(signalId, TrafficLightModel.Unsichtbar_2er))

            it("Traffic lights are not used", function() assert.is_false(lane.signalUsedForRequest) end)
            it("Traffic lights there is no entry in the table",
               function() for x in pairs(lane.routesToCount) do assert(false, x) end end)
            lane:checkRequests()
        end)

        insulate("without train", function()
            require("ak.core.eep.AkEepFunktionen")
            local TrafficLightModel = require("ak.road.TrafficLightModel")
            local TrafficLight = require("ak.road.TrafficLight")
            local Lane = require("ak.road.Lane")
            local signalId = 55

            -- Set the route for train "#Car1"
            EEPSetTrainRoute("#Car1", "Some Route")
            local lane = Lane:new("Lane A", 34, TrafficLight:new(signalId, TrafficLightModel.Unsichtbar_2er))

            lane:useSignalForQueue()
            lane:checkRequests()

            it("No trains waiting on signal", function() assert.equals(0, EEPGetSignalTrainsCount(signalId)) end)
            it("Traffic lights are used", function() assert.is_true(lane.signalUsedForRequest) end)
            it("There is no request", function() assert.equals(0, lane.queue:size()) end)
        end)

        insulate("with train", function()
            local EepSimulator = require("ak.core.eep.AkEepFunktionen")
            local TrafficLightModel = require("ak.road.TrafficLightModel")
            local TrafficLight = require("ak.road.TrafficLight")
            local Lane = require("ak.road.Lane")
            local signalId = 55

            -- Set the route for train "#Car1"
            EEPSetTrainRoute("#Car1", "Some Route")
            EEPSetTrainRoute("#Car2", "Some Route")

            EepSimulator.queueTrainOnSignal(signalId, "#Car1")
            EepSimulator.queueTrainOnSignal(signalId, "#Car2")
            local lane = Lane:new("Lane A", 34, TrafficLight:new(signalId, TrafficLightModel.Unsichtbar_2er))
            lane:useSignalForQueue()
            lane:checkRequests()

            it("No trains waiting on signal", function() assert.equals(2, EEPGetSignalTrainsCount(signalId)) end)
            it("No trains waiting on signal", function()
                assert.equals("#Car1", EEPGetSignalTrainName(signalId, 1))
                assert.equals("#Car2", EEPGetSignalTrainName(signalId, 2))
            end)
            it("Traffic lights are used", function() assert.is_true(lane.signalUsedForRequest) end)
            it("There is a car on the lane signal", function() assert.equals(2, lane.queue:size()) end)
            it("There is #Car1 on the lane signal", function()
                assert.equals("#Car1", lane.queue:firstElement())
            end)
        end)
    end)

     describe(":useTracklForQueue()", function()
        insulate("disabled", function()
            require("ak.core.eep.AkEepFunktionen")
            local TrafficLightModel = require("ak.road.TrafficLightModel")
            local TrafficLight = require("ak.road.TrafficLight")
            local Lane = require("ak.road.Lane")

            -- Set the route for train "#Car1"
            EEPSetTrainRoute("#Car1", "Some Route")
            local lane = Lane:new("Lane A", 34, TrafficLight:new(66, TrafficLightModel.Unsichtbar_2er))

            it("Traffic lights are not used", function() assert.is_false(lane.tracksUsedForRequest) end)
            it("Traffic lights there is no entry in the table",
               function() for x in pairs(lane.tracksForRequests) do assert(false, x) end end)
            lane:checkRequests()
        end)

        insulate("without train", function()
            require("ak.core.eep.AkEepFunktionen")
            local TrafficLightModel = require("ak.road.TrafficLightModel")
            local TrafficLight = require("ak.road.TrafficLight")
            local Lane = require("ak.road.Lane")
            local roadId = 55

            -- Set the route for train "#Car1"
            EEPSetTrainRoute("#Car1", "Some Route")
            local lane = Lane:new("Lane A", 34, TrafficLight:new(66, TrafficLightModel.Unsichtbar_2er))

            lane:useTracklForQueue(roadId)
            lane:checkRequests()
            lane:checkRequests()
            lane:checkRequests()

            it("No trains waiting on signal", function() assert.equals(0, EEPGetSignalTrainsCount(roadId)) end)
            it("Traffic lights are used", function() assert.is_true(lane.tracksUsedForRequest) end)
            it("There is no request", function() assert.equals(0, lane.queue:size()) end)
        end)

        insulate("with train", function()
            local EepSimulator = require("ak.core.eep.AkEepFunktionen")
            local TrafficLightModel = require("ak.road.TrafficLightModel")
            local TrafficLight = require("ak.road.TrafficLight")
            local Lane = require("ak.road.Lane")
            local roadId = 55

            -- Set the route for train "#Car1"
            EEPSetTrainRoute("#Car1", "Some Route")

            EepSimulator.setzeZugAufStrasse(roadId, "#Car1")
            local lane = Lane:new("Lane A", 34, TrafficLight:new(66, TrafficLightModel.Unsichtbar_2er))
            lane:useTracklForQueue(roadId)
            lane:checkRequests()
            lane:checkRequests()
            lane:checkRequests()

            it("- #Car1 is on the road", function()
                local trackRegistered, trackOccupied, trainName = EEPIsRoadTrackReserved(roadId, true)
                assert.equals(true, trackRegistered)
                assert.equals(true, trackOccupied)
                assert.equals("#Car1", trainName)
            end)
            it("- Road counting is used", function() assert.is_true(lane.tracksUsedForRequest) end)
            it("- There is a request on the road track", function() assert.equals(1, lane.queue:size()) end)
            it("- There is a request on the road track", function()
                assert.equals("#Car1", lane.queue:firstElement())
            end)
        end)
    end)
end)
