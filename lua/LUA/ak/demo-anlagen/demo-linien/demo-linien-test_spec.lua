describe("ak.roadline.StationQueue", function()
    local EepSimulator = require("ak.core.eep.EepSimulator")
    EepSimulator.addTrain("train1", "RollingStock 1a", "RollingStock 2b")
    EepSimulator.addTrain("train2", "RollingStock 1a", "RollingStock 2b")
    EepSimulator.addTrain("train3", "RollingStock 1a", "RollingStock 2b")

    insulate("new Queue is empty", function() require("ak.demo-anlagen.demo-linien.demo-linien-main") end)
end)