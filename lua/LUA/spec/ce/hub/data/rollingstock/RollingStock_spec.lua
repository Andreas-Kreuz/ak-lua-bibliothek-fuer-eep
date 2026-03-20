describe("ce.hub.data.rollingstock.RollingStock", function()
    require("ce.hub.eep.EepSimulator")

    insulate("parse rollingstockname", function()
        local RollingStock = require("ce.hub.data.rollingstock.RollingStock")
        assert(RollingStock)
    end)

end)

insulate("parse rollingstockname", function()
    local RollingStockRegistry = require("ce.hub.data.rollingstock.RollingStockRegistry")
    local RollingStockModel = require("ce.hub.data.rollingstock.RollingStockModel")
    local RollingStockModels = require("ce.hub.data.rollingstock.RollingStockModels")

    RollingStockModels.addModelByName("MyModel", RollingStockModel:new({myMarker = "MODEL A"}))
    RollingStockModels.assignModel("MyModel;005", RollingStockModel:new({myMarker = "MODEL B"}))

    local stock1 = RollingStockRegistry.forName("MyModel;003")
    local stock2 = RollingStockRegistry.forName("MyModel;005")

    it("stock1 name", function() assert.equals("MyModel;003", stock1.rollingStockName) end)
    it("stock2 name", function() assert.equals("MyModel;005", stock2.rollingStockName) end)

    it("MODEL A", function() assert.equals("MODEL A", stock1.model["myMarker"]) end)
    it("MODEL B", function() assert.equals("MODEL B", stock2.model["myMarker"]) end)
end)
