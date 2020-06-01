describe("ak.util.TableUtils", function()
    insulate("sameListEntries()", function()
        local TableUtils = require("ak.util.TableUtils")
        insulate("empty are equal", function()
            local t1 = {}
            local t2 = {}
            it("Can pop all three elements in order", function() assert.is_true(TableUtils.sameListEntries(t1, t2)) end)
        end)
    end)
end)
