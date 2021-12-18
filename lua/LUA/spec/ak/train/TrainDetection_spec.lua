describe("TrainDetection", function()
    local debug = false

    local EepSimulator = require("ak.core.eep.EepSimulator")
    EepSimulator.debug = debug
    EepSimulator.addTrain("#EepTrain1", "RollingStock 1", "RollingStock 2")

    insulate("with #EepTrain1:", function()
        local TrainDetection = require("ak.data.TrainDetection")
        local TrainRegistry = require("ak.train.TrainRegistry")
        TrainDetection.debug = debug
        TrainRegistry.debug = debug

        TrainDetection.initialize()
        TrainDetection.update();

        local haveTrainInitially = TrainRegistry.getAllTrainNames()["#EepTrain1"]
        it("have no train first", function() assert.is_falsy(haveTrainInitially) end)

        EepSimulator.setzeZugAufGleis(1, "#EepTrain1")
        TrainDetection.update();

        local haveTrain1AfterInserting = TrainRegistry.getAllTrainNames()["#EepTrain1"]
        local haveTrain2AfterInserting = TrainRegistry.getAllTrainNames()["#EepTrain1;001"]
        local rsCount1AfterInserting = TrainRegistry.forName("#EepTrain1"):getRollingStockCount()
        it("have #EepTrain1 after inserting", function() assert.is_true(haveTrain1AfterInserting) end)
        it("no #EepTrain1;001 after inserting", function() assert.is_falsy(haveTrain2AfterInserting) end)
        it("#EepTrain1 has 2 rollingStock", function() assert.equals(2, rsCount1AfterInserting) end)
        it("train #EepTrain1 was not created", function()
            local train, created = TrainRegistry.forName("#EepTrain1")
            assert.is_false(created)
        end)

        EepSimulator.splitTrain("#EepTrain1", 1)
        TrainDetection.update();
        local haveTrain1AfterSplitting = TrainRegistry.getAllTrainNames()["#EepTrain1"]
        local haveTrain2AfterSplitting = TrainRegistry.getAllTrainNames()["#EepTrain1;001"]
        local rsCount1AfterSplitting = TrainRegistry.forName("#EepTrain1"):getRollingStockCount()
        local rsCount2AfterSplitting = TrainRegistry.forName("#EepTrain1;001"):getRollingStockCount()
        it("have #EepTrain1 after splitTrain", function() assert.is_true(haveTrain1AfterSplitting) end)
        it("no #EepTrain1;001 after splitTrain", function() assert.is_true(haveTrain2AfterSplitting) end)
        it("#EepTrain1 has 1 rollingStock", function() assert.equals(1, rsCount1AfterSplitting) end)
        it("#EepTrain1;001 has 1 rollingStock", function() assert.equals(1, rsCount2AfterSplitting) end)
    end)
end)

