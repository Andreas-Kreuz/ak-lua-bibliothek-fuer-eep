insulate("ce.hub.data.structures.StructureDataCollector", function ()
    local function clearModule(name) package.loaded[name] = nil end

    local originalStructureGetLight = _G.EEPStructureGetLight
    local originalStructureGetSmoke = _G.EEPStructureGetSmoke
    local originalStructureGetFire = _G.EEPStructureGetFire
    local originalStructureGetPosition = _G.EEPStructureGetPosition
    local originalStructureGetRotation = _G.EEPStructureGetRotation
    local originalStructureGetModelType = _G.EEPStructureGetModelType
    local originalStructureGetTagText = _G.EEPStructureGetTagText

    before_each(function ()
        clearModule("ce.hub.data.structures.StructureDataCollector")

        local states = {
            ["#3"] = {
                light = true,
                smoke = false,
                fire = false,
                pos = { 1.111, 2.222, 3.333 },
                rot = { 4.444, 5.555, 6.666 },
                modelType = 22,
                tag = "Depot"
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

        _G.__structure_test_states = states
    end)

    after_each(function ()
        rawset(_G, "EEPStructureGetLight", originalStructureGetLight)
        rawset(_G, "EEPStructureGetSmoke", originalStructureGetSmoke)
        rawset(_G, "EEPStructureGetFire", originalStructureGetFire)
        rawset(_G, "EEPStructureGetPosition", originalStructureGetPosition)
        rawset(_G, "EEPStructureGetRotation", originalStructureGetRotation)
        rawset(_G, "EEPStructureGetModelType", originalStructureGetModelType)
        rawset(_G, "EEPStructureGetTagText", originalStructureGetTagText)
        _G.__structure_test_states = nil
    end)

    it("collects initial structures with static and dynamic fields", function ()
        local StructureDataCollector = require("ce.hub.data.structures.StructureDataCollector")

        local structures = StructureDataCollector.collectInitialStructures()

        assert.same(1, #structures)
        assert.same({
            id = "#3",
            name = "#3",
            pos_x = 1.11,
            pos_y = 2.22,
            pos_z = 3.33,
            rot_x = 4.44,
            rot_y = 5.55,
            rot_z = 6.67,
            modelType = 22,
            modelTypeText = "Immobilie",
            tag = "Depot",
            light = true,
            smoke = false,
            fire = false
        }, structures[1])
    end)

    it("refreshes only dirty structures and updates them in place", function ()
        local StructureDataCollector = require("ce.hub.data.structures.StructureDataCollector")

        local structures = StructureDataCollector.collectInitialStructures()
        _G.__structure_test_states["#3"].smoke = true

        local dirtyStructures = StructureDataCollector.refreshDirtyStructures(structures)

        assert.same(1, #dirtyStructures)
        assert.is_true(dirtyStructures[1] == structures[1])
        assert.is_true(structures[1].smoke)
        assert.is_false(structures[1].fire)
    end)
end)
