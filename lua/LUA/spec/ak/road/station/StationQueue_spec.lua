describe("ak.road.station.StationQueue", function()
    require("ak.core.eep.EepSimulator")
    insulate("new Queue is empty", function()
        local Queue = require("ak.road.station.StationQueue")

        local myQueue = Queue:new();
        it("First is nil", function() assert.same({}, myQueue.entries) end)
        it("First is nil", function() assert.same({}, myQueue.entriesByArrival) end)
    end)

    insulate("Queue with elements is not empty", function()
        local Queue = require("ak.road.station.StationQueue")

        local myQueue = Queue:new()
        myQueue:push("train1", 5)
        myQueue:push("train2", 5)
        myQueue:push("train3", 5)

        it("First is nil", function() assert.same({ "train1", "train2", "train3" }, myQueue.entriesByArrival) end)
    end)

    insulate("Queue with elements is not empty", function()
        local Queue = require("ak.road.station.StationQueue")

        local myQueue = Queue:new()
        myQueue:push("train1", 2, 1)
        myQueue:push("train2", 4, 2)
        myQueue:push("train3", 3, 3)

        it("First is nil", function() assert.same({ "train1", "train3", "train2" }, myQueue.entriesByArrival) end)
    end)

    insulate("Queue with elements is not empty", function()
        local Queue = require("ak.road.station.StationQueue")

        local myQueue = Queue:new()
        myQueue:push("train1", 5, 1)
        myQueue:push("train2", 5, 2)
        myQueue:push("train3", 5, "3")

        it("First is nil", function() assert.equals("train1", myQueue:getTrainEntries()[1].trainName) end)
        it("First is nil", function() assert.equals("train2", myQueue:getTrainEntries()[2].trainName) end)
        it("First is nil", function() assert.equals("train3", myQueue:getTrainEntries()[3].trainName) end)
        it("First is nil", function() assert.equals("train1", myQueue:getTrainEntries(1)[1].trainName) end)
        it("First is nil", function() assert.equals("train2", myQueue:getTrainEntries(2)[1].trainName) end)
        it("First is nil", function() assert.equals("train3", myQueue:getTrainEntries(3)[1].trainName) end)
        it("First is nil", function() assert.equals("train1", myQueue:getTrainEntries("1")[1].trainName) end)
        it("First is nil", function() assert.equals("train2", myQueue:getTrainEntries("2")[1].trainName) end)
        it("First is nil", function() assert.equals("train3", myQueue:getTrainEntries("3")[1].trainName) end)
    end)
end)
