describe("Road.lua", function()
    describe("EEPSetSignal", function()
        describe(".zaehleAnAmpelAlle()", function()
            insulate("ohne Zähler", function()
                require("ak.core.eep.AkEepFunktionen")
                local TrafficLightModel = require("ak.road.TrafficLightModel")
                local TrafficLight = require("ak.road.TrafficLight")
                local Lane = require("ak.road.Lane")

                EEPSetTrainRoute("#Auto1", "Meine Route 1")

                local richtung1 = Lane:neu("Richtung 1", 34, {
                    TrafficLight:neu(55, TrafficLightModel.Unsichtbar_2er)
                })
                richtung1:pruefeAnforderungen()
                it("Keine Zählampeln vorhanden", function()
                    for x in pairs(richtung1.zaehlAmpeln) do assert(false, x) end
                end)

                it("Anforderungen erfolgen ohne Signale", function()
                    assert.is_false(richtung1.verwendeZaehlAmpeln)
                end)
            end)

            insulate("mit Zähler, ohne Anforderung", function()
                require("ak.core.eep.AkEepFunktionen")
                local TrafficLightModel = require("ak.road.TrafficLightModel")
                local TrafficLight = require("ak.road.TrafficLight")
                local Lane = require("ak.road.Lane")

                EEPSetTrainRoute("#Auto1", "Meine Route 1")

                local richtung1 = Lane:neu("Richtung 1", 34, {
                    TrafficLight:neu(55, TrafficLightModel.Unsichtbar_2er)
                })


                richtung1:zaehleAnAmpelAlle(55)
                richtung1:pruefeAnforderungen()
                it("Anforderungen erfolgen mit Signalen", function()
                    assert.is_true(richtung1.verwendeZaehlAmpeln)
                end)

                it(" Es liegt keine Anforderungen an", function()
                    assert.is_false(richtung1.anforderungAnSignal)
                end)
            end)

            insulate("mit Zähler, mit Anforderung", function()
                local AkEEPHilfe = require("ak.core.eep.AkEepFunktionen")
                local TrafficLightModel = require("ak.road.TrafficLightModel")
                local TrafficLight = require("ak.road.TrafficLight")
                local Lane = require("ak.road.Lane")

                EEPSetTrainRoute("#Auto1", "Meine Route 1")
                AkEEPHilfe.zahlDerZuegeAnSignal[55] = 0
                AkEEPHilfe.namenDerZuegeAnSignal[55] = {}

                local richtung1 = Lane:neu("Richtung 1", 35, {
                    TrafficLight:neu(55, TrafficLightModel.Unsichtbar_2er)
                })
                richtung1:zaehleAnAmpelAlle(55)
                AkEEPHilfe.zahlDerZuegeAnSignal[55] = 1
                AkEEPHilfe.namenDerZuegeAnSignal[55] = {}
                AkEEPHilfe.namenDerZuegeAnSignal[55][1] = "#Auto1"

                richtung1:pruefeAnforderungen()
                it("Es liegt eine Anforderungen an", function()
                    assert.is_true(richtung1.anforderungAnSignal)
                end)
            end)
        end)
    end)

    describe(".zaehleAnStrasseAlle()", function()
        insulate("ohne Zähler", function()
            require("ak.core.eep.AkEepFunktionen")
            local TrafficLightModel = require("ak.road.TrafficLightModel")
            local TrafficLight = require("ak.road.TrafficLight")
            local Lane = require("ak.road.Lane")
            EEPSetTrainRoute("#Auto1", "Meine Route 1")

            local richtung1 = Lane:neu("Richtung 1", 34, {
                TrafficLight:neu(55, TrafficLightModel.Unsichtbar_2er)
            })
            richtung1:pruefeAnforderungen()
            it("Keine Zählampeln vorhanden", function()
                for x in pairs(richtung1.zaehlAmpeln) do assert(false, x) end
            end)

            it("Anforderungen erfolgen ohne Strasse", function()
                assert.is_false(richtung1.verwendeZaehlStrassen)
            end)
        end)

        insulate("mit Zähler, ohne Anforderung", function()
            require("ak.core.eep.AkEepFunktionen")
            local TrafficLightModel = require("ak.road.TrafficLightModel")
            local TrafficLight = require("ak.road.TrafficLight")
            local Lane = require("ak.road.Lane")

            EEPSetTrainRoute("#Auto1", "Meine Route 1")

            local richtung1 = Lane:neu("Richtung 1", 34, {
                TrafficLight:neu(55, TrafficLightModel.Unsichtbar_2er)
            })


            richtung1:zaehleAnStrasseAlle(55)
            richtung1:pruefeAnforderungen()
            it("Anforderungen erfolgen mit Strasse", function()
                assert.is_true(richtung1.verwendeZaehlStrassen)
            end)

            it(" Es liegt keine Anforderungen an", function()
                assert.is_false(richtung1.anforderungAnStrasse)
            end)
        end)

        insulate("mit Zähler, mit Anforderung", function()
            local AkEEPHilfe = require("ak.core.eep.AkEepFunktionen")
            local TrafficLightModel = require("ak.road.TrafficLightModel")
            local TrafficLight = require("ak.road.TrafficLight")
            local Lane = require("ak.road.Lane")

            EEPSetTrainRoute("#Auto1", "Meine Route 1")

            local richtung1 = Lane:neu("Richtung 1", 35, {
                TrafficLight:neu(55, TrafficLightModel.Unsichtbar_2er)
            })
            richtung1:zaehleAnStrasseAlle(55)
            AkEEPHilfe.setzeZugAufStrasse(55, "#Auto1")

            richtung1:pruefeAnforderungen()
            it("Es liegt eine Anforderungen an", function()
                assert.is_true(richtung1.anforderungAnStrasse)
            end)
        end)
    end)

    describe(".zaehleAnStrasseRoute()", function()
        insulate("mit Zähler, mit Anforderung", function()
            local AkEEPHilfe = require("ak.core.eep.AkEepFunktionen")
            local TrafficLightModel = require("ak.road.TrafficLightModel")
            local TrafficLight = require("ak.road.TrafficLight")
            local Lane = require("ak.road.Lane")

            EEPSetTrainRoute("#Auto1", "Meine Route 1")
            EEPSetTrainRoute("#Auto2", "Meine Route 2")

            local richtung1 = Lane:neu("Richtung 1", 35, {
                TrafficLight:neu(55, TrafficLightModel.Unsichtbar_2er)
            })
            richtung1:zaehleAnStrasseBeiRoute(55, "Meine Route 1")
            AkEEPHilfe.setzeZugAufStrasse(55, "#Auto2")

            richtung1:pruefeAnforderungen()
            it("Es liegt keine Anforderungen an", function()
                assert.is_false(richtung1.anforderungAnStrasse)
            end)
        end)

        insulate("mit Zähler, mit Anforderung", function()
            local AkEEPHilfe = require("ak.core.eep.AkEepFunktionen")
            local TrafficLightModel = require("ak.road.TrafficLightModel")
            local TrafficLight = require("ak.road.TrafficLight")
            local Lane = require("ak.road.Lane")

            EEPSetTrainRoute("#Auto1", "Meine Route 1")
            EEPSetTrainRoute("#Auto2", "Meine Route 2")


            local richtung1 = Lane:neu("Richtung 1", 35, {
                TrafficLight:neu(55, TrafficLightModel.Unsichtbar_2er)
            })
            richtung1:zaehleAnStrasseBeiRoute(55, "Meine Route 1")
            AkEEPHilfe.setzeZugAufStrasse(55, "#Auto1")

            richtung1:pruefeAnforderungen()
            it("Es liegt eine Anforderungen an", function()
                assert.is_true(richtung1.anforderungAnStrasse)
            end)
        end)
    end)
end)
