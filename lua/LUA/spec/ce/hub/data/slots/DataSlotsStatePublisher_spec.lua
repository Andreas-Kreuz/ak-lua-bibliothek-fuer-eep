insulate("ce.hub.data.slots.DataSlotsStatePublisher", function ()
    local function clearModule(name) package.loaded[name] = nil end

    local originalLoadData = _G.EEPLoadData

    before_each(function ()
        clearModule("ce.hub.data.slots.DataSlotsStatePublisher")
        clearModule("ce.hub.data.slots.DataSlotDtoFactory")
        clearModule("ce.hub.data.slots.DataSlotNameResolver")
        clearModule("ce.hub.util.StorageUtility")
        clearModule("ce.hub.publish.InternalDataStore")
        clearModule("ce.databridge.ServerEventBuffer")
        clearModule("ce.hub.publish.DataChangeBus")

        rawset(_G, "EEPLoadData", function (id)
            if id == 1 then return true, "payload-1" end
            return false, nil
        end)
    end)

    after_each(function ()
        rawset(_G, "EEPLoadData", originalLoadData)
    end)

    it("fires save-slots and free-slots with the existing wire format", function ()
        local DataSlotsStatePublisher = require("ce.hub.data.slots.DataSlotsStatePublisher")
        local DataSlotNameResolver = require("ce.hub.data.slots.DataSlotNameResolver")
        local StorageUtility = require("ce.hub.util.StorageUtility")
        local DataStore = require("ce.hub.publish.InternalDataStore")

        DataSlotNameResolver.updateSlotNames = function () end
        DataSlotNameResolver.getSlotName = function (id)
            if id == 1 then return "Named Slot" end
            return nil
        end
        StorageUtility.getName = function () return nil end

        DataSlotsStatePublisher.initialize()
        DataSlotsStatePublisher.syncState()

        assert.same({
            ["1"] = {
                id = 1,
                name = "Named Slot",
                data = "payload-1"
            }
        }, DataStore.getRoom("save-slots"))
        assert.same({
            ["2"] = {
                id = 2
            }
        }, { ["2"] = DataStore.get("free-slots", 2) })
    end)
end)
