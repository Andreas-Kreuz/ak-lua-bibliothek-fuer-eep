describe("ak.public-transport.StationQueue", function()
    local EepSimulator = require("ak.core.eep.EepSimulator")
    EepSimulator.addTrain("train1", "RollingStock 1a", "RollingStock 2b")
    EepSimulator.addTrain("train2", "RollingStock 2a", "RollingStock 2b")
    EepSimulator.addTrain("train3", "RollingStock 3a", "RollingStock 3b")

    insulate("new Queue is empty", function() require("ak.demo-anlagen.demo-linien.demo-linien-main") end)
end)
