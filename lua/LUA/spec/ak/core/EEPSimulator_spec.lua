describe("EEPStructureSetLight", function()
    require("ak.core.eep.EepSimulator")
    it("", function() assert.equals("#1234", string.gsub("#1234", "(#%d*).*", "%1")) end)
    it("", function() assert.equals("#1234", string.gsub("#1234_SomeImmoModel", "(#%d*).*", "%1")) end)
    it("", function() assert.equals("#123", string.gsub("#123_", "(#%d*).*", "%1")) end)


    EEPStructureSetLight("#14", true)
    local _, on = EEPStructureGetLight("#14")
    it("on", function() assert.is_true(on) end)
    EEPStructureSetLight("#14", false)
    local _, off = EEPStructureGetLight("#14")
    it("off", function() assert.is_false(off) end)

    local _, off2 = EEPStructureGetLight("#15")
    it("off unknown", function() assert.is_false(off2) end)
end)
