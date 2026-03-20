insulate("ce.hub.data.structures.StructureDtoFactory", function ()
    local function clearModule(name) package.loaded[name] = nil end

    before_each(function ()
        clearModule("ce.hub.data.structures.StructureDtoFactory")
    end)

    it("projects structures to detached DTO tables", function ()
        local StructureDtoFactory = require("ce.hub.data.structures.StructureDtoFactory")
        local structure = {
            id = "#7",
            name = "#7",
            pos_x = 1,
            pos_y = 2,
            pos_z = 3,
            rot_x = 4,
            rot_y = 5,
            rot_z = 6,
            modelType = 22,
            modelTypeText = "Immobilie",
            tag = "alpha",
            light = true,
            smoke = false,
            fire = true
        }

        local room, keyId, key, structureDto = StructureDtoFactory.createStructureDto(structure)
        local listRoom, listKeyId, structureDtos = StructureDtoFactory.createStructureDtoList({ structure })
        structure.tag = "changed"

        assert.equals("structures", room)
        assert.equals("id", keyId)
        assert.equals("#7", key)
        assert.same({
            id = "#7",
            name = "#7",
            pos_x = 1,
            pos_y = 2,
            pos_z = 3,
            rot_x = 4,
            rot_y = 5,
            rot_z = 6,
            modelType = 22,
            modelTypeText = "Immobilie",
            tag = "alpha",
            light = true,
            smoke = false,
            fire = true
        }, structureDto)
        assert.equals("structures", listRoom)
        assert.equals("id", listKeyId)
        assert.same({ {
            id = "#7",
            name = "#7",
            pos_x = 1,
            pos_y = 2,
            pos_z = 3,
            rot_x = 4,
            rot_y = 5,
            rot_z = 6,
            modelType = 22,
            modelTypeText = "Immobilie",
            tag = "alpha",
            light = true,
            smoke = false,
            fire = true
        } }, structureDtos)
    end)
end)
