insulate("ak.train.TrainDtoFactories", function ()
    local function clearModule(name) package.loaded[name] = nil end

    before_each(function ()
        clearModule("ak.train.TrainDtoFactory")
        clearModule("ak.train.RollingStockDtoFactory")
    end)

    it("provides metadata for train and rolling stock DTOs", function ()
        local TrainDtoFactory = require("ak.train.TrainDtoFactory")
        local RollingStockDtoFactory = require("ak.train.RollingStockDtoFactory")

        local train = { toJsonStatic = function ()
            return { id = "T1", route = "R", rollingStockCount = 1, length = 2, movesForward = true, speed = 3 }
        end }
        local rollingStock = { toJsonStatic = function ()
            return { id = "RS1", name = "RS1", trainName = "T1" }
        end }

        local trainRoom, trainKeyId, trainKey, trainDto = TrainDtoFactory.createTrainDto(train)
        local rsRoom, rsKeyId, rsKey, rsDto = RollingStockDtoFactory.createRollingStockDto(rollingStock)

        assert.equals("trains", trainRoom)
        assert.equals("id", trainKeyId)
        assert.equals("T1", trainKey)
        assert.same({ id = "T1", route = "R", rollingStockCount = 1, length = 2, movesForward = true, speed = 3 },
                    trainDto)
        assert.equals("rolling-stocks", rsRoom)
        assert.equals("id", rsKeyId)
        assert.equals("RS1", rsKey)
        assert.same({ id = "RS1", name = "RS1", trainName = "T1" }, rsDto)
    end)
end)
