insulate("ce.hub.data.trains.TrainDtoFactories", function ()
    local function clearModule(name) package.loaded[name] = nil end

    before_each(function ()
        clearModule("ce.hub.data.trains.TrainDtoFactory")
        clearModule("ce.hub.data.rollingstock.RollingStockDtoFactory")
    end)

    it("provides metadata for train and rolling stock DTOs", function ()
        local TrainDtoFactory = require("ce.hub.data.trains.TrainDtoFactory")
        local RollingStockDtoFactory = require("ce.hub.data.rollingstock.RollingStockDtoFactory")

        local occupiedTracks = { [11] = 11 }
        local train = {
            getName = function () return "T1" end,
            getRoute = function () return "R" end,
            getRollingStockCount = function () return 1 end,
            getLength = function () return 2 end,
            getLine = function () return "L1" end,
            getDestination = function () return "Depot" end,
            getDirection = function () return "North" end,
            getTrackType = function () return "rail" end,
            getMovesForward = function () return true end,
            getSpeed = function () return 3 end,
            getOnTrack = function () return occupiedTracks end,
            toJsonStatic = function () error("createTrainDto should not use toJsonStatic") end
        }
        local rollingStock = {
            rollingStockName = "RS1",
            getTrainName = function () return "T1" end,
            getPositionInTrain = function () return 0 end,
            getCouplingFront = function () return 2 end,
            getCouplingRear = function () return 3 end,
            getLength = function () return 12.5 end,
            getPropelled = function () return true end,
            getModelType = function () return 8 end,
            getModelTypeText = function () return "Tram" end,
            getTag = function () return "tag" end,
            getWagonNr = function () return "42" end,
            getTrackId = function () return 99 end,
            getTrackDistance = function () return 10.5 end,
            getTrackDirection = function () return 1 end,
            getTrackSystem = function () return 3 end,
            getTrackType = function () return "road" end,
            getX = function () return 1 end,
            getY = function () return 2 end,
            getZ = function () return 3 end,
            getMileage = function () return 4 end,
            toJsonStatic = function () error("createRollingStockDto should not use toJsonStatic") end
        }

        local trainRoom, trainKeyId, trainKey, trainDto = TrainDtoFactory.createTrainDto(train)
        local rsRoom, rsKeyId, rsKey, rsDto = RollingStockDtoFactory.createRollingStockDto(rollingStock)

        occupiedTracks[12] = 12

        assert.equals("trains", trainRoom)
        assert.equals("id", trainKeyId)
        assert.equals("T1", trainKey)
        assert.same({
            id = "T1",
            route = "R",
            rollingStockCount = 1,
            length = 2,
            line = "L1",
            destination = "Depot",
            direction = "North",
            trackType = "rail",
            movesForward = true,
            speed = 3,
            occupiedTacks = { [11] = 11 }
        },
                    trainDto)
        assert.equals("rolling-stocks", rsRoom)
        assert.equals("id", rsKeyId)
        assert.equals("RS1", rsKey)
        assert.same({
            id = "RS1",
            name = "RS1",
            trainName = "T1",
            positionInTrain = 0,
            couplingFront = 2,
            couplingRear = 3,
            length = 12.5,
            propelled = true,
            modelType = 8,
            modelTypeText = "Tram",
            tag = "tag",
            nr = "42",
            trackId = 99,
            trackDistance = 10.5,
            trackDirection = 1,
            trackSystem = 3,
            trackType = "road",
            posX = 1,
            posY = 2,
            posZ = 3,
            mileage = 4
        }, rsDto)
    end)
end)
