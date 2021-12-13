describe("ak.public-transport.StationQueue", function()
    local EepSimulator = require("ak.core.eep.EepSimulator")
    EepSimulator.addTrain("train1", "RollingStock 1a", "RollingStock 2b")
    EepSimulator.addTrain("train2", "RollingStock 2a", "RollingStock 2b")
    EepSimulator.addTrain("train3", "RollingStock 3a", "RollingStock 3b")

    insulate("new StationQueue is empty", function()
        local StationQueue = require("ak.public-transport.StationQueue")

        local myQueue = StationQueue:new();
        it("First is nil", function() assert.same({}, myQueue.entries) end)
        it("First is nil", function() assert.same({}, myQueue.entriesByArrival) end)
    end)

    insulate("all in order", function()
        local StationQueue = require("ak.public-transport.StationQueue")

        local myQueue = StationQueue:new()
        myQueue:push("train1", "A", "1", 5)
        myQueue:push("train2", "A", "1", 5)
        myQueue:push("train3", "A", "1", 5)

        it("entriesByArrival",
           function() assert.same({"1&A&train1", "1&A&train2", "1&A&train3"}, myQueue.entriesByArrival) end)
    end)

    insulate("train3 before train2", function()
        local StationQueue = require("ak.public-transport.StationQueue")

        local myQueue = StationQueue:new()
        myQueue:push("train1", "A", "1", 2, 1)
        myQueue:push("train2", "A", "1", 4, 2)
        myQueue:push("train3", "A", "1", 3, 3)

        it("entriesByArrival",
           function() assert.same({"1&A&train1", "1&A&train3", "1&A&train2"}, myQueue.entriesByArrival) end)
    end)

    insulate("station and platform trains", function()
        local StationQueue = require("ak.public-transport.StationQueue")

        local myQueue = StationQueue:new()
        myQueue:push("train1", "A", "1", 5, 1)
        myQueue:push("train2", "A", "1", 5, 2)
        myQueue:push("train3", "A", "1", 5, "3")

        it("All platforms 1st", function() assert.equals("train1", myQueue:getTrainEntries()[1].trainName) end)
        it("All platforms 2nd", function() assert.equals("train2", myQueue:getTrainEntries()[2].trainName) end)
        it("All platforms 3rd", function() assert.equals("train3", myQueue:getTrainEntries()[3].trainName) end)
        it("Platform 1 - 1st", function() assert.equals("train1", myQueue:getTrainEntries(1)[1].trainName) end)
        it("Platform 2 - 1st", function() assert.equals("train2", myQueue:getTrainEntries(2)[1].trainName) end)
        it("Platform 3 - 1st", function() assert.equals("train3", myQueue:getTrainEntries(3)[1].trainName) end)
        it("Platform \"1\"", function() assert.equals("train1", myQueue:getTrainEntries("1")[1].trainName) end)
        it("Platform \"2\"", function() assert.equals("train2", myQueue:getTrainEntries("2")[1].trainName) end)
        it("Platform \"3\"", function() assert.equals("train3", myQueue:getTrainEntries("3")[1].trainName) end)
    end)
end)
