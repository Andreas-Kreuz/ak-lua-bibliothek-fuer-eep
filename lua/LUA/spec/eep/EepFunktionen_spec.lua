describe("EepFunktionen.lua", function()
    require("ak.eep.AkEepFunktionen")

    it("EEPVer steht auf \"15\"", function()
        assert.are.equals(15, EEPVer)
    end)

    it("print() Funktion ", function()
        clearlog()
    end)

    describe("EEPSetSignal", function()
        describe("setzt Signal 2 auf Stellung 4", function()
            EEPSetSignal(2, 4, 1)

            it("gibt 4 zurück bei EEPGetSignal(2)", function()
                assert.are.equals(4, EEPGetSignal(2))
            end)
        end)

        describe("setzt Signal 2 auf Stellung 3", function()
            EEPSetSignal(2, 3, 1)

            it("gibt 4 zurück bei EEPGetSignal(3)", function()
                assert.are.equals(3, EEPGetSignal(2))
            end)
        end)
    end)

    -- more tests pertaining to the top level
end)
