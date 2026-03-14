insulate("ak.data.StructureDtoFactory", function ()
    local function clearModule(name) package.loaded[name] = nil end

    before_each(function ()
        clearModule("ak.data.StructureDtoFactory")
    end)

    it("projects structures to detached DTO tables", function ()
        local StructureDtoFactory = require("ak.data.StructureDtoFactory")
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

        local structureDto = StructureDtoFactory.createStructureDto(structure)
        structure.tag = "changed"

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
    end)
end)
