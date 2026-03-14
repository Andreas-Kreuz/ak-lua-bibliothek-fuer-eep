if AkDebugLoad then print("[#Start] Loading ak.core.ModuleDtoFactory ...") end

local ModuleDtoFactory = {}

local ROOM = "modules"
local KEY_ID = "id"

local function toModuleDto(moduleName, module)
    return {
        id = module.id,
        name = moduleName,
        enabled = module.enabled
    }
end

function ModuleDtoFactory.createModuleDto(moduleName, module)
    local dto = toModuleDto(moduleName, module)
    return ROOM, KEY_ID, dto[KEY_ID], dto
end

function ModuleDtoFactory.createModuleDtoList(modules)
    local moduleDtos = {}

    for moduleName, module in pairs(modules) do
        local _, _, _, dto = ModuleDtoFactory.createModuleDto(moduleName, module)
        moduleDtos[module.id] = dto
    end

    return ROOM, KEY_ID, moduleDtos
end

function ModuleDtoFactory.createModuleReferenceDto(moduleId)
    local dto = { id = moduleId }
    return ROOM, KEY_ID, moduleId, dto
end

return ModuleDtoFactory
