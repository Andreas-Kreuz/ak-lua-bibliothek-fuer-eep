require("ak.core.eep.EepSimulator")

insulate("parse rollingstockname", function()
    local Models = require("ak.train.RollingStockModels")

    it("MyModel",       function() assert.equals("MyModel", Models.parseModelName("MyModel")) end)
    it("MyModel;001",   function() assert.equals("MyModel", Models.parseModelName("MyModel;001")) end)
    it("My Model",      function() assert.equals("My Model", Models.parseModelName("My Model")) end)
    it("My Model;001",  function() assert.equals("My Model", Models.parseModelName("My Model;001")) end)
    it("My (M)odel;;;", function() assert.equals("My (M)odel", Models.parseModelName("My (M)odel;;;")) end)
end)

insulate("parse rollingstockname", function()
    local RollingStockModel = require("ak.train.RollingStockModel")
    local RollingStockModels = require("ak.train.RollingStockModels")

    RollingStockModels.addModelByName("MyModel", RollingStockModel:new({ myMarker = "MODEL A" }))
    RollingStockModels.assingModel("MyModel;005", RollingStockModel:new({ myMarker = "MODEL B" }))

    it("MODEL A", function() assert.equals("MODEL A", RollingStockModels.modelFor("MyModel")["myMarker"]) end)
    it("MODEL A", function() assert.equals("MODEL A", RollingStockModels.modelFor("MyModel;001")["myMarker"]) end)
    it("MODEL B", function() assert.equals("MODEL B", RollingStockModels.modelFor("MyModel;005")["myMarker"]) end)
end)
