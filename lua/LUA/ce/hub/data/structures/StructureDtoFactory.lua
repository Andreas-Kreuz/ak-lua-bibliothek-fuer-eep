if AkDebugLoad then print("[#Start] Loading ce.hub.data.structures.StructureDtoFactory ...") end

local StructureDtoFactory = {}

local ROOM = "structures"
local KEY_ID = "id"

local function toStructureDto(structure)
    return {
        id = structure.id,
        name = structure.name,
        pos_x = structure.pos_x,
        pos_y = structure.pos_y,
        pos_z = structure.pos_z,
        rot_x = structure.rot_x,
        rot_y = structure.rot_y,
        rot_z = structure.rot_z,
        modelType = structure.modelType,
        modelTypeText = structure.modelTypeText,
        tag = structure.tag,
        light = structure.light,
        smoke = structure.smoke,
        fire = structure.fire
    }
end

function StructureDtoFactory.createStructureDto(structure)
    local dto = toStructureDto(structure)
    return ROOM, KEY_ID, dto[KEY_ID], dto
end

function StructureDtoFactory.createStructureDtoList(structures)
    local structureDtos = {}

    for i = 1, #structures do
        local _, _, _, dto = StructureDtoFactory.createStructureDto(structures[i])
        structureDtos[i] = dto
    end

    return ROOM, KEY_ID, structureDtos
end

return StructureDtoFactory
