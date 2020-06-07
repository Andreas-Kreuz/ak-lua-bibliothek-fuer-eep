describe("ak.util.TableUtils", function()
    describe("sameArrayEntries()", function()
        local TableUtils = require("ak.util.TableUtils")
        describe("empty are equal", function()
            local t1 = {}
            local t2 = {}
            it("equal", function() assert.is_true(TableUtils.sameArrayEntries(t1, t2)) end)
        end)
        insulate("same elements are equal", function()
            local t1 = {"LEFT"}
            local t2 = {"LEFT"}
            it("equal", function() assert.is_true(TableUtils.sameArrayEntries(t1, t2)) end)
        end)
        insulate("same elements are equal", function()
            local t1 = {"RIGHT", "LEFT"}
            local t2 = {"LEFT", "RIGHT"}
            it("equal", function() assert.is_true(TableUtils.sameArrayEntries(t1, t2)) end)
        end)
        insulate("asymmetric are not equal", function()
            local t1 = {}
            local t2 = {"LEFT"}
            it("not equal", function() assert.is_false(TableUtils.sameArrayEntries(t1, t2)) end)
        end)
        insulate("asymmetric are not equal", function()
            local t1 = {"LEFT"}
            local t2 = {}
            it("not equal", function() assert.is_false(TableUtils.sameArrayEntries(t1, t2)) end)
        end)
    end)
end)
