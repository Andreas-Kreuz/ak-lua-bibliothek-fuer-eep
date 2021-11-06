describe("ak.util.TableUtils", function()
    local TableUtils = require("ak.util.TableUtils")
    describe("sameArrayEntries()", function()
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
    describe("sameDictEntries()", function()
        insulate("on different entries", function()
            local t1 = {key = "value"}
            local t2 = {key = "other_value"}
            it("is false", function() assert.is_false(TableUtils.sameDictEntries(t1, t2)) end)
        end)
        insulate("on different entries", function()
            local t1 = {[123] = 123, [456] = 456}
            local t2 = {}
            it("is false", function() assert.is_false(TableUtils.sameDictEntries(t1, t2)) end)
        end)
        insulate("on different entries", function()
            local t1 = {}
            local t2 = {[123] = 123, [456] = 456}
            it("is false", function() assert.is_false(TableUtils.sameDictEntries(t1, t2)) end)
        end)
        insulate("on same entries", function()
            local t1 = {[123] = 123, [456] = 456}
            local t2 = {[123] = 123, [456] = 456}
            it("is true", function() assert.is_true(TableUtils.sameDictEntries(t1, t2)) end)
        end)
    end)
end)
