describe("ce.mods.transit.StationQueue", function ()
    local EepSimulator = require("ce.hub.eep.EepSimulator")
    EepSimulator.simulateAddTrain("train1", "RollingStock 1a", "RollingStock 2b")
    EepSimulator.simulateAddTrain("train2", "RollingStock 2a", "RollingStock 2b")
    EepSimulator.simulateAddTrain("train3", "RollingStock 3a", "RollingStock 3b")

    insulate("new Queue is empty", function () require("ce.demo-anlagen.demo-linien.demo-linien-main") end)
end)
