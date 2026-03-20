insulate("ce.hub.data.structures.StructureStatePublisher", function ()
    local function clearModule(name) package.loaded[name] = nil end

    local originalStructureGetLight = _G.EEPStructureGetLight
    local originalStructureGetSmoke = _G.EEPStructureGetSmoke
    local originalStructureGetFire = _G.EEPStructureGetFire
    local originalStructureGetPosition = _G.EEPStructureGetPosition
    local originalStructureGetRotation = _G.EEPStructureGetRotation
    local originalStructureGetModelType = _G.EEPStructureGetModelType
    local originalStructureGetTagText = _G.EEPStructureGetTagText

    before_each(function ()
        clearModule("ce.hub.data.structures.StructureStatePublisher")
        clearModule("ce.hub.data.structures.StructureDataCollector")
        clearModule("ce.hub.data.structures.StructureDtoFactory")
        clearModule("ce.hub.publish.InternalDataStore")
        clearModule("ce.databridge.ServerEventBuffer")
        clearModule("ce.hub.publish.DataChangeBus")

        local states = {
            ["#2"] = {
                light = true,
                smoke = false,
                fire = false,
                pos = { 1, 2, 3 },
                rot = { 4, 5, 6 },
                modelType = 22,
                tag = "shed"
            }
        }

        rawset(_G, "EEPStructureGetLight", function (name)
            local entry = states[name]
            if not entry then return false, false end
            return true, entry.light
        end)
        rawset(_G, "EEPStructureGetSmoke", function (name)
            local entry = states[name]
            if not entry then return false, false end
            return true, entry.smoke
        end)
        rawset(_G, "EEPStructureGetFire", function (name)
            local entry = states[name]
            if not entry then return false, false end
            return true, entry.fire
        end)
        rawset(_G, "EEPStructureGetPosition", function (name)
            local entry = states[name]
            if not entry then return false end
            return true, entry.pos[1], entry.pos[2], entry.pos[3]
        end)
        rawset(_G, "EEPStructureGetRotation", function (name)
            local entry = states[name]
            if not entry then return false end
            return true, entry.rot[1], entry.rot[2], entry.rot[3]
        end)
        rawset(_G, "EEPStructureGetModelType", function (name)
            local entry = states[name]
            if not entry then return false end
            return true, entry.modelType
        end)
        rawset(_G, "EEPStructureGetTagText", function (name)
            local entry = states[name]
            if not entry then return false end
            return true, entry.tag
        end)

        _G.__structure_state_test_states = states
    end)

    after_each(function ()
        rawset(_G, "EEPStructureGetLight", originalStructureGetLight)
        rawset(_G, "EEPStructureGetSmoke", originalStructureGetSmoke)
        rawset(_G, "EEPStructureGetFire", originalStructureGetFire)
        rawset(_G, "EEPStructureGetPosition", originalStructureGetPosition)
        rawset(_G, "EEPStructureGetRotation", originalStructureGetRotation)
        rawset(_G, "EEPStructureGetModelType", originalStructureGetModelType)
        rawset(_G, "EEPStructureGetTagText", originalStructureGetTagText)
        _G.__structure_state_test_states = nil
    end)

    it("fires initial room data and later only dirty room data", function ()
        local StructureStatePublisher = require("ce.hub.data.structures.StructureStatePublisher")
        local DataStore = require("ce.hub.publish.InternalDataStore")

        StructureStatePublisher.initialize()

        assert.same({
            ["#2"] = {
                id = "#2",
                name = "#2",
                pos_x = 1,
                pos_y = 2,
                pos_z = 3,
                rot_x = 4,
                rot_y = 5,
                rot_z = 6,
                modelType = 22,
                modelTypeText = "Immobilie",
                tag = "shed",
                light = true,
                smoke = false,
                fire = false
            }
        }, DataStore.getRoom("structures"))

        _G.__structure_state_test_states["#2"].fire = true
        StructureStatePublisher.syncState()

        assert.is_true(DataStore.get("structures", "#2").fire)
    end)
end)
