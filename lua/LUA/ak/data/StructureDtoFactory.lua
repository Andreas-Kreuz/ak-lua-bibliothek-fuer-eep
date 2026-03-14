if AkDebugLoad then print("[#Start] Loading ak.data.StructureDtoFactory ...") end

local StructureDtoFactory = {}

function StructureDtoFactory.createStructureDto(structure)
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

function StructureDtoFactory.createStructureDtoList(structures)
    local structureDtos = {}

    for i = 1, #structures do
        structureDtos[i] = StructureDtoFactory.createStructureDto(structures[i])
    end

    return structureDtos
end

return StructureDtoFactory
