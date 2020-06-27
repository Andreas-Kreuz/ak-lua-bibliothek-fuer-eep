describe("ak.train.Train", function()
    require("ak.core.eep.EepSimulator")

    insulate("new Train is empty", function()
        local Train = require("ak.train.Train")

        local tram = Train.forName("#EepTrain1");

        it("Train has right name", function() assert.equals("#EepTrain1", tram.trainName) end)
        it("Dest is nil", function() assert.is_nil(tram.values[Train.Key.destination]) end)
        it("Line is nil", function() assert.is_nil(tram.values[Train.Key.line]) end)
    end)
end)

describe("ak.train.Train", function()
    require("ak.core.eep.EepSimulator")

    insulate("Destination is set", function()
        local Train = require("ak.train.Train")

        local tram = Train.forName("#EepTrain1");
        tram:setDestination("DEST")

        it("Dest is nil", function() assert.equals("DEST", tram.values[Train.Key.destination]) end)
    end)
end)

describe("ak.train.Train", function()
    require("ak.core.eep.EepSimulator")

    insulate("Line is set", function()
        local Train = require("ak.train.Train")

        local tram = Train.forName("#EepTrain1");
        tram:setLine("Line")

        it("Line is Set", function() assert.equals("Line", tram.values[Train.Key.line]) end)
    end)
end)

describe("ak.train.Train", function()
    require("ak.core.eep.EepSimulator")
    insulate("Line is string", function()
        local Train = require("ak.train.Train")

        local tram = Train.forName("#EepTrain1");
        tram:setLine(12)

        it("Line is String", function() assert.equals("12", tram.values[Train.Key.line]) end)
    end)
end)
