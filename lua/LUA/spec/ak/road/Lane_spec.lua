describe("Lane ...", function()
    describe(":zaehleAnAmpelAlle()", function()
        insulate("disabled", function()
            require("ak.core.eep.AkEepFunktionen")
            local TrafficLightModel = require("ak.road.TrafficLightModel")
            local TrafficLight = require("ak.road.TrafficLight")
            local Lane = require("ak.road.Lane")
            local signalId = 55

            -- Set the route for train "#Car1"
            EEPSetTrainRoute("#Car1", "Some Route")
            local lane = Lane:new("Lane A", 34, {TrafficLight:new(signalId, TrafficLightModel.Unsichtbar_2er)})

            it("Traffic lights are not used", function() assert.is_false(lane.verwendeZaehlAmpeln) end)
            it("Traffic lights there is no entry in the table",
               function() for x in pairs(lane.zaehlAmpeln) do assert(false, x) end end)
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
            local lane = Lane:new("Lane A", 34, {TrafficLight:new(signalId, TrafficLightModel.Unsichtbar_2er)})

            lane:zaehleAnAmpelAlle(signalId)
            lane:checkRequests()

            it("No trains waiting on signal", function() assert.equals(0, EEPGetSignalTrainsCount(signalId)) end)
            it("Traffic lights are used", function() assert.is_true(lane.verwendeZaehlAmpeln) end)
            it("There is no request", function() assert.is_false(lane.hasRequestOnSignal) end)
        end)

        insulate("with train", function()
            local EepSimulator = require("ak.core.eep.AkEepFunktionen")
            local TrafficLightModel = require("ak.road.TrafficLightModel")
            local TrafficLight = require("ak.road.TrafficLight")
            local Lane = require("ak.road.Lane")
            local signalId = 55

            -- Set the route for train "#Car1"
            EEPSetTrainRoute("#Car1", "Some Route")

            EepSimulator.queueTrainOnSignal(signalId, "#Car1")
            local lane = Lane:new("Lane A", 34, {TrafficLight:new(signalId, TrafficLightModel.Unsichtbar_2er)})
            lane:zaehleAnAmpelAlle(signalId)
            lane:checkRequests()

            it("No trains waiting on signal", function() assert.equals(1, EEPGetSignalTrainsCount(signalId)) end)
            it("No trains waiting on signal", function()
                assert.equals("#Car1", EEPGetSignalTrainName(signalId, 1))
            end)
            it("Traffic lights are used", function() assert.is_true(lane.verwendeZaehlAmpeln) end)
            it("There is a request on the lane signal", function() assert.is_true(lane.hasRequestOnSignal) end)
        end)
    end)

    describe(":zaehleAnAmpelBeiRoute()", function()
        insulate("with non-matching train", function()
            local EepSimulator = require("ak.core.eep.AkEepFunktionen")
            local TrafficLightModel = require("ak.road.TrafficLightModel")
            local TrafficLight = require("ak.road.TrafficLight")
            local Lane = require("ak.road.Lane")
            local signalId = 55

            EEPSetTrainRoute("#Car1", "Matching Route")
            EEPSetTrainRoute("#Car2", "Non-Matching Route")

            local lane = Lane:new("Richtung 1", 35, {TrafficLight:new(signalId, TrafficLightModel.Unsichtbar_2er)})
            lane:zaehleAnAmpelBeiRoute(signalId, "Matching Route")
            EepSimulator.queueTrainOnSignal(signalId, "#Car2")

            lane:checkRequests()
            it("Train does not have matching route", function() assert.is_false(lane.hasRequestOnSignal) end)
        end)

        insulate("with one matching train", function()
            local EepSimulator = require("ak.core.eep.AkEepFunktionen")
            local TrafficLightModel = require("ak.road.TrafficLightModel")
            local TrafficLight = require("ak.road.TrafficLight")
            local Lane = require("ak.road.Lane")
            local signalId = 55

            EEPSetTrainRoute("#Car1", "Matching Route")
            EEPSetTrainRoute("#Car2", "Non-Matching Route")

            local lane = Lane:new("Richtung 1", 35, {TrafficLight:new(signalId, TrafficLightModel.Unsichtbar_2er)})
            lane:zaehleAnAmpelBeiRoute(signalId, "Matching Route")
            EepSimulator.queueTrainOnSignal(signalId, "#Car1")

            lane:checkRequests()
            it("Train has matching route", function() assert.is_true(lane.hasRequestOnSignal) end)
        end)

        insulate("with two trains (first non-matching)", function()
            local EepSimulator = require("ak.core.eep.AkEepFunktionen")
            local TrafficLightModel = require("ak.road.TrafficLightModel")
            local TrafficLight = require("ak.road.TrafficLight")
            local Lane = require("ak.road.Lane")
            local signalId = 55

            EEPSetTrainRoute("#Car1", "Non-Matching Route")
            EEPSetTrainRoute("#Car2", "Matching Route")

            local lane = Lane:new("Richtung 1", 35, {TrafficLight:new(signalId, TrafficLightModel.Unsichtbar_2er)})
            lane:zaehleAnAmpelBeiRoute(signalId, "Matching Route")
            EepSimulator.queueTrainOnSignal(signalId, "#Car1")
            EepSimulator.queueTrainOnSignal(signalId, "#Car2")

            lane:checkRequests()
            it("First train does not match the route", function() assert.is_false(lane.hasRequestOnSignal) end)
        end)

        insulate("with two trains (first matching)", function()
            local EepSimulator = require("ak.core.eep.AkEepFunktionen")
            local TrafficLightModel = require("ak.road.TrafficLightModel")
            local TrafficLight = require("ak.road.TrafficLight")
            local Lane = require("ak.road.Lane")
            local signalId = 55

            EEPSetTrainRoute("#Car1", "Matching Route")
            EEPSetTrainRoute("#Car2", "Non-Matching Route")

            local lane = Lane:new("Richtung 1", 35, {TrafficLight:new(signalId, TrafficLightModel.Unsichtbar_2er)})
            lane:zaehleAnAmpelBeiRoute(signalId, "Matching Route")
            EepSimulator.queueTrainOnSignal(signalId, "#Car1")
            EepSimulator.queueTrainOnSignal(signalId, "#Car2")

            lane:checkRequests()
            it("First train matches the route", function() assert.is_true(lane.hasRequestOnSignal) end)
        end)
    end)

    describe(":zaehleAnStrasseAlle()", function()
        insulate("disabled", function()
            require("ak.core.eep.AkEepFunktionen")
            local TrafficLightModel = require("ak.road.TrafficLightModel")
            local TrafficLight = require("ak.road.TrafficLight")
            local Lane = require("ak.road.Lane")

            -- Set the route for train "#Car1"
            EEPSetTrainRoute("#Car1", "Some Route")
            local lane = Lane:new("Lane A", 34, {TrafficLight:new(66, TrafficLightModel.Unsichtbar_2er)})

            it("Traffic lights are not used", function() assert.is_false(lane.verwendeZaehlStrassen) end)
            it("Traffic lights there is no entry in the table",
               function() for x in pairs(lane.zaehlStrassen) do assert(false, x) end end)
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
            local lane = Lane:new("Lane A", 34, {TrafficLight:new(66, TrafficLightModel.Unsichtbar_2er)})

            lane:zaehleAnStrasseAlle(roadId)
            lane:checkRequests()

            it("No trains waiting on signal", function() assert.equals(0, EEPGetSignalTrainsCount(roadId)) end)
            it("Traffic lights are used", function() assert.is_true(lane.verwendeZaehlStrassen) end)
            it("There is no request", function() assert.is_false(lane.hasRequestOnRoad) end)
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
            local lane = Lane:new("Lane A", 34, {TrafficLight:new(66, TrafficLightModel.Unsichtbar_2er)})
            lane:zaehleAnStrasseAlle(roadId)
            lane:checkRequests()

            it("- #Car1 is on the road", function()
                local trackRegistered, trackOccupied, trainName = EEPIsRoadTrackReserved(roadId, true)
                assert.equals(true, trackRegistered)
                assert.equals(true, trackOccupied)
                assert.equals("#Car1", trainName)
            end)
            it("- Road counting is used", function() assert.is_true(lane.verwendeZaehlStrassen) end)
            it("- There is a request on the road track", function() assert.is_true(lane.hasRequestOnRoad) end)
        end)
    end)

    describe(":zaehleAnStrasseRoute()", function()
        insulate("with counter but without request", function()
            local EepSimulator = require("ak.core.eep.AkEepFunktionen")
            local TrafficLightModel = require("ak.road.TrafficLightModel")
            local TrafficLight = require("ak.road.TrafficLight")
            local Lane = require("ak.road.Lane")

            EEPSetTrainRoute("#Car1", "Matching Route")
            EEPSetTrainRoute("#Car2", "Non-Matching Route")

            local lane = Lane:new("Richtung 1", 35, {TrafficLight:new(55, TrafficLightModel.Unsichtbar_2er)})
            lane:zaehleAnStrasseBeiRoute(55, "Matching Route")
            EepSimulator.setzeZugAufStrasse(55, "#Car2")

            lane:checkRequests()
            it("Train does not have matching route", function() assert.is_false(lane.hasRequestOnRoad) end)
        end)

        insulate("with counter and request", function()
            local EepSimulator = require("ak.core.eep.AkEepFunktionen")
            local TrafficLightModel = require("ak.road.TrafficLightModel")
            local TrafficLight = require("ak.road.TrafficLight")
            local Lane = require("ak.road.Lane")

            EEPSetTrainRoute("#Car1", "Matching Route")
            EEPSetTrainRoute("#Car2", "Non-Matching Route")

            local lane = Lane:new("Richtung 1", 35, {TrafficLight:new(55, TrafficLightModel.Unsichtbar_2er)})
            lane:zaehleAnStrasseBeiRoute(55, "Matching Route")
            EepSimulator.setzeZugAufStrasse(55, "#Car1")

            lane:checkRequests()
            it("Train has matching route", function() assert.is_true(lane.hasRequestOnRoad) end)
        end)
    end)
end)
