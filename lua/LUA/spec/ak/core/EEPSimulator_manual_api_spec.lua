describe("EepSimulator manual API", function()
    insulate("train state", function()
        require("ak.core.eep.EepSimulator")

        it("stores routes per train", function()
            assert.is_true(EEPSetTrainRoute("#RouteTrain", "RB20"))

            local ok, route = EEPGetTrainRoute("#RouteTrain")
            assert.is_true(ok)
            assert.equals("RB20", route)
        end)

        it("returns the default route for unknown trains", function()
            local ok, route = EEPGetTrainRoute("#UnknownTrain")
            assert.is_false(ok)
            assert.equals("Alle", route)
        end)

        it("stores train lights by source", function()
            assert.is_true(EEPSetTrainLight("#LightTrain", true, 2))

            local okBlinker, blinkerOn = EEPGetTrainLight("#LightTrain", 2)
            local okDefault, defaultOn = EEPGetTrainLight("#LightTrain")

            assert.is_true(okBlinker)
            assert.is_true(blinkerOn)
            assert.is_true(okDefault)
            assert.is_false(defaultOn)
        end)

        it("stores train coupling state", function()
            assert.is_true(EEPSetTrainCouplingFront("#CouplingTrain", true))
            assert.is_true(EEPSetTrainCouplingRear("#CouplingTrain", false))

            local okFront, frontState = EEPGetTrainCouplingFront("#CouplingTrain")
            local okRear, rearState = EEPGetTrainCouplingRear("#CouplingTrain")

            assert.is_true(okFront)
            assert.equals(1, frontState)
            assert.is_true(okRear)
            assert.equals(2, rearState)
        end)
    end)

    insulate("trainyard state", function()
        local EepSimulator = require("ak.core.eep.EepSimulator")

        EepSimulator.addTrainToTrainyard(3, "#DepotTrain")

        it("lists trainyard entries", function()
            assert.equals(1, EEPGetTrainyardItemsCount(3))
            assert.equals("#DepotTrain", EEPGetTrainyardItemName(3, 0))
            assert.equals(1, EEPGetTrainyardItemStatus(3, "#DepotTrain", 0))
        end)

        it("detects trains waiting in the depot", function()
            local ok, depotId = EEPIsTrainInTrainyard("#DepotTrain")
            assert.is_true(ok)
            assert.equals(3, depotId)
        end)

        it("moves trains out of the depot", function()
            assert.is_true(EEPGetTrainFromTrainyard(3, "#DepotTrain", 0))
            assert.equals(0, EEPGetTrainyardItemStatus(3, "#DepotTrain", 0))

            local ok, depotId = EEPIsTrainInTrainyard("#DepotTrain")
            assert.is_false(ok)
            assert.is_nil(depotId)
        end)

        it("moves trains back into a depot", function()
            assert.is_true(EEPPutTrainToTrainyard(4, "#DepotTrain"))
            assert.equals(1, EEPGetTrainyardItemsCount(4))
            assert.equals("#DepotTrain", EEPGetTrainyardItemName(4, 0))
            assert.equals(1, EEPGetTrainyardItemStatus(4, "#DepotTrain", 0))

            local ok, depotId = EEPIsTrainInTrainyard("#DepotTrain")
            assert.is_true(ok)
            assert.equals(4, depotId)
        end)
    end)

    insulate("camera state", function()
        require("ak.core.eep.EepSimulator")

        it("stores perspective camera per train and globally", function()
            assert.is_true(EEPSetPerspectiveCamera(9, "#CameraTrain"))

            local okTrain, trainPerspective = EEPGetPerspectiveCamera("#CameraTrain")
            local okGlobal, globalPerspective = EEPGetPerspectiveCamera()

            assert.is_true(okTrain)
            assert.equals(9, trainPerspective)
            assert.is_true(okGlobal)
            assert.equals(9, globalPerspective)
        end)

        it("stores a user camera with the documented signature", function()
            assert.is_true(EEPRollingstockSetUserCamera("Salonwagen", -4, 0, 2, 180, 90, 1))

            local ok, posX, posY, posZ, rotH, rotV = EEPRollingstockGetUserCamera("Salonwagen")
            assert.is_true(ok)
            assert.equals(-4, posX)
            assert.equals(0, posY)
            assert.equals(2, posZ)
            assert.equals(180, rotH)
            assert.equals(90, rotV)
        end)

        it("keeps compatibility with the old simulator signature", function()
            assert.is_true(EEPRollingstockSetUserCamera("LegacyCar", 1, 2, 3, 120, 45, 0, true))

            local ok, posX, posY, posZ, rotH, rotV = EEPRollingstockGetUserCamera("LegacyCar")
            assert.is_true(ok)
            assert.equals(1, posX)
            assert.equals(2, posY)
            assert.equals(3, posZ)
            assert.equals(120, rotH)
            assert.equals(45, rotV)
        end)
    end)
end)
