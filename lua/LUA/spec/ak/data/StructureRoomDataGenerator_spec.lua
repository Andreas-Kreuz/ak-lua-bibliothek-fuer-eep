insulate("ak.data.StructureRoomDataGenerator", function ()
    local function clearModule(name) package.loaded[name] = nil end

    before_each(function ()
        clearModule("ak.data.StructureRoomDataGenerator")
    end)

    it("projects structures to detached room data tables", function ()
        local StructureRoomDataGenerator = require("ak.data.StructureRoomDataGenerator")
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

        local roomData = StructureRoomDataGenerator.toRoomDataStructure(structure)
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
        }, roomData)
    end)
end)
