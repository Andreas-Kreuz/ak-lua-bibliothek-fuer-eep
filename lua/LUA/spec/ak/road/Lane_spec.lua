describe("Lane", function()
    describe("Lane count vehicles", function()
        insulate("Traffic Light Counting disabled", function()
            require("ak.core.eep.AkEepFunktionen")
            local TrafficLightModel = require("ak.road.TrafficLightModel")
            local TrafficLight = require("ak.road.TrafficLight")
            local Lane = require("ak.road.Lane")
            local signalId = 55

            -- Set the route for train "#car1"
            EEPSetTrainRoute("#car1", "Main Route 1")
            local lane = Lane:new("Lane A", 34, {TrafficLight:new(signalId, TrafficLightModel.Unsichtbar_2er)})

            it("Traffic lights are not used", function() assert.is_false(lane.verwendeZaehlAmpeln) end)
            it("Traffic lights there is no entry in the table",
               function() for x in pairs(lane.zaehlAmpeln) do assert(false, x) end end)
            lane:checkRequests()
        end)

        insulate("Traffic Light Counting enabled without train", function()
            require("ak.core.eep.AkEepFunktionen")
            local TrafficLightModel = require("ak.road.TrafficLightModel")
            local TrafficLight = require("ak.road.TrafficLight")
            local Lane = require("ak.road.Lane")
            local signalId = 55

            -- Set the route for train "#car1"
            EEPSetTrainRoute("#car1", "Main Route 1")
            local lane = Lane:new("Lane A", 34, {TrafficLight:new(signalId, TrafficLightModel.Unsichtbar_2er)})

            lane:zaehleAnAmpelAlle(signalId)
            lane:checkRequests()

            it("No trains waiting on signal", function() assert.equals(0, EEPGetSignalTrainsCount(signalId)) end)
            it("Traffic lights are used", function() assert.is_true(lane.verwendeZaehlAmpeln) end)
            it("There is no request", function() assert.is_false(lane.hasRequestOnSignal) end)
        end)

        insulate("Traffic Light Counting enabled with train", function()
            local EepSimulator = require("ak.core.eep.AkEepFunktionen")
            local TrafficLightModel = require("ak.road.TrafficLightModel")
            local TrafficLight = require("ak.road.TrafficLight")
            local Lane = require("ak.road.Lane")
            local signalId = 55

            -- Set the route for train "#car1"
            EEPSetTrainRoute("#car1", "Main Route 1")

            EepSimulator.queueTrainOnSignal(signalId, "#car1")
            local lane = Lane:new("Lane A", 34, {TrafficLight:new(signalId, TrafficLightModel.Unsichtbar_2er)})
            lane:checkRequests()
            lane:zaehleAnAmpelAlle(signalId)
            lane:checkRequests()

            it("No trains waiting on signal", function() assert.equals(1, EEPGetSignalTrainsCount(signalId)) end)
            it("No trains waiting on signal", function()
                assert.equals("#car1", EEPGetSignalTrainName(signalId, 1))
            end)
            it("Traffic lights are used", function() assert.is_true(lane.verwendeZaehlAmpeln) end)
            it("There is a request on the lane signal", function() assert.is_true(lane.hasRequestOnSignal) end)
        end)
    end)
end)
