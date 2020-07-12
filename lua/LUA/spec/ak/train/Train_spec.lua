describe("ak.train.Train", function()
    local EepSimulator = require("ak.core.eep.EepSimulator")
    EepSimulator.addTrain("#EepTrain1", "RollingStock 1", "RollingStock 2")

    insulate("new Train is empty", function()
        local Train = require("ak.train.Train")

        local tram = Train.forName("#EepTrain1");

        it("Train has right name", function() assert.equals("#EepTrain1", tram.trainName) end)
        it("Dest is nil", function() assert.is_nil(tram:getDestination()) end)
        it("Line is nil", function() assert.is_nil(tram:getLine()) end)
    end)
end)

describe("ak.train.Train", function()
    local EepSimulator = require("ak.core.eep.EepSimulator")
    EepSimulator.addTrain("#EepTrain1", "RollingStock 1", "RollingStock 2")

    insulate("Destination is set", function()
        local Train = require("ak.train.Train")

        local tram = Train.forName("#EepTrain1");
        tram:setDestination("DEST")

        it("Dest is nil", function() assert.equals("DEST", tram:getDestination()) end)
    end)
end)

describe("ak.train.Train", function()
    local EepSimulator = require("ak.core.eep.EepSimulator")
    EepSimulator.addTrain("#EepTrain1", "RollingStock 1", "RollingStock 2")

    insulate("Line is set", function()
        local Train = require("ak.train.Train")

        local tram = Train.forName("#EepTrain1");
        tram:setLine("Line")

        it("Line is Set", function() assert.equals("Line", tram:getLine()) end)
    end)
end)

describe("ak.train.Train", function()
    local EepSimulator = require("ak.core.eep.EepSimulator")
    EepSimulator.addTrain("#EepTrain1", "RollingStock 1", "RollingStock 2")

    insulate("Line is string", function()
        local Train = require("ak.train.Train")

        local tram = Train.forName("#EepTrain1");
        tram:setLine(12)

        it("Line is String", function() assert.equals("12", tram:getLine()) end)
    end)
end)
