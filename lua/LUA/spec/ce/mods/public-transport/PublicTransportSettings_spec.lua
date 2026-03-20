insulate("ce.mods.public-transport.PublicTransportSettings", function ()
    local function clearModule(name) package.loaded[name] = nil end

    before_each(function ()
        require("ce.hub.eep.EepSimulator")
        clearModule("ce.hub.util.StorageUtility")
        clearModule("ce.mods.public-transport.RoadStation")
        clearModule("ce.mods.public-transport.PublicTransportSettings")
    end)

    after_each(function ()
        local StorageUtility = require("ce.hub.util.StorageUtility")
        StorageUtility.reset()
    end)

    it("loads the departure info setting from storage", function ()
        local PublicTransportSettings = require("ce.mods.public-transport.PublicTransportSettings")

        EEPSaveData(22, "depInfo=true,")
        PublicTransportSettings.loadSettingsFromSlot(22)

        assert.is_true(PublicTransportSettings.showDepartureTippText)
    end)

    it("saves the departure info setting", function ()
        local StorageUtility = require("ce.hub.util.StorageUtility")
        local PublicTransportSettings = require("ce.mods.public-transport.PublicTransportSettings")

        PublicTransportSettings.loadSettingsFromSlot(23)
        PublicTransportSettings.setShowDepartureTippText(true)

        local data = StorageUtility.loadTable(23, "PublicTransport settings")
        assert.equals("true", data["depInfo"])
    end)

    it("refreshes station displays after changing the setting", function ()
        local PublicTransportSettings = require("ce.mods.public-transport.PublicTransportSettings")
        local RoadStation = require("ce.mods.public-transport.RoadStation")
        local refreshCalls = 0
        local oldShowTippText = RoadStation.showTippText

        RoadStation.showTippText = function () refreshCalls = refreshCalls + 1 end

        PublicTransportSettings.loadSettingsFromSlot(24)
        PublicTransportSettings.setShowDepartureTippText(true)

        assert.equals(1, refreshCalls)

        RoadStation.showTippText = oldShowTippText
    end)
end)
