insulate("ce.mods.transit.TransitSettings", function ()
    local function clearModule(name) package.loaded[name] = nil end

    before_each(function ()
        require("ce.hub.eep.EepSimulator")
        clearModule("ce.hub.util.StorageUtility")
        clearModule("ce.mods.transit.RoadStation")
        clearModule("ce.mods.transit.TransitSettings")
    end)

    after_each(function ()
        local StorageUtility = require("ce.hub.util.StorageUtility")
        StorageUtility.reset()
    end)

    it("loads the departure info setting from storage", function ()
        local TransitSettings = require("ce.mods.transit.TransitSettings")

        EEPSaveData(22, "depInfo=true,")
        TransitSettings.loadSettingsFromSlot(22)

        assert.is_true(TransitSettings.showDepartureTippText)
    end)

    it("saves the departure info setting", function ()
        local StorageUtility = require("ce.hub.util.StorageUtility")
        local TransitSettings = require("ce.mods.transit.TransitSettings")

        TransitSettings.loadSettingsFromSlot(23)
        TransitSettings.setShowDepartureTippText(true)

        local data = StorageUtility.loadTable(23, "Transit settings")
        assert.equals("true", data["depInfo"])
    end)

    it("refreshes station displays after changing the setting", function ()
        local TransitSettings = require("ce.mods.transit.TransitSettings")
        local RoadStation = require("ce.mods.transit.RoadStation")
        local refreshCalls = 0
        local oldShowTippText = RoadStation.showTippText

        RoadStation.showTippText = function () refreshCalls = refreshCalls + 1 end

        TransitSettings.loadSettingsFromSlot(24)
        TransitSettings.setShowDepartureTippText(true)

        assert.equals(1, refreshCalls)

        RoadStation.showTippText = oldShowTippText
    end)
end)
