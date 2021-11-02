describe("ak.train.RollingStock", function()
    require("ak.core.eep.EepSimulator")

    insulate("parse rollingstockname", function()
        local RollingStock = require("ak.train.RollingStock")
        assert(RollingStock)
    end)

end)

insulate("parse rollingstockname", function()
    local RollingStock = require("ak.train.RollingStock")
    local RollingStockModel = require("ak.train.RollingStockModel")
    local RollingStockModels = require("ak.train.RollingStockModels")

    RollingStockModels.addModelByName("MyModel", RollingStockModel:new({myMarker = "MODEL A"}))
    RollingStockModels.assignModel("MyModel;005", RollingStockModel:new({myMarker = "MODEL B"}))

    local stock1 = RollingStock.forName("MyModel;003")
    local stock2 = RollingStock.forName("MyModel;005")

    it("stock1 name", function() assert.equals("MyModel;003", stock1.rollingStockName) end)
    it("stock2 name", function() assert.equals("MyModel;005", stock2.rollingStockName) end)

    it("MODEL A", function() assert.equals("MODEL A", stock1.model["myMarker"]) end)
    it("MODEL B", function() assert.equals("MODEL B", stock2.model["myMarker"]) end)
end)
