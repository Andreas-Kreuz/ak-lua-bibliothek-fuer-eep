describe("ak.road.station.StationQueue", function()
    require("ak.core.eep.EepSimulator")

    insulate("new EepTrain is empty", function()
        local EepTrain = require("ak.train.EepTrain")

        local tram = EepTrain:new("#EepTrain1");

        it("EepTrain has right name", function() assert.equals("#EepTrain1", tram.trainName) end)
        it("Dest is nil", function() assert.is_nil(tram.values[EepTrain.Key.destination]) end)
        it("Line is nil", function() assert.is_nil(tram.values[EepTrain.Key.line]) end)
    end)

    insulate("Destination is set", function()
        local EepTrain = require("ak.train.EepTrain")

        local tram = EepTrain:new("#EepTrain1");
        tram:setDestination("DEST")

        it("Dest is nil", function() assert.equals("DEST", tram.values[EepTrain.Key.destination]) end)
    end)

    insulate("Line is set", function()
        local EepTrain = require("ak.train.EepTrain")

        local tram = EepTrain:new("#EepTrain1");
        tram:setLine("Line")

        it("Line is Set", function() assert.equals("Line", tram.values[EepTrain.Key.line]) end)
    end)

    insulate("Line is string", function()
        local EepTrain = require("ak.train.EepTrain")

        local tram = EepTrain:new("#EepTrain1");
        tram:setLine(12)

        it("Line is String", function() assert.equals("12", tram.values[EepTrain.Key.line]) end)
    end)
end)
