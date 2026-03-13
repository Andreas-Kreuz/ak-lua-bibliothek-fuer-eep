insulate("ak.data.DataSlotsStatePublisher", function ()
    local function clearModule(name) package.loaded[name] = nil end

    local originalLoadData = _G.EEPLoadData

    before_each(function ()
        clearModule("ak.data.DataSlotsStatePublisher")
        clearModule("ak.data.DataSlotsRoomDataGenerator")
        clearModule("ak.data.DataSlotNameResolver")
        clearModule("ak.storage.StorageUtility")
        clearModule("ak.data.DataStore")
        clearModule("ak.io.ServerEventBuffer")
        clearModule("ak.events.DataChangeBus")

        rawset(_G, "EEPLoadData", function (id)
            if id == 1 then return true, "payload-1" end
            return false, nil
        end)
    end)

    after_each(function ()
        rawset(_G, "EEPLoadData", originalLoadData)
    end)

    it("fires save-slots and free-slots with the existing wire format", function ()
        local DataSlotsStatePublisher = require("ak.data.DataSlotsStatePublisher")
        local DataSlotNameResolver = require("ak.data.DataSlotNameResolver")
        local StorageUtility = require("ak.storage.StorageUtility")
        local DataStore = require("ak.data.DataStore")

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
