if AkDebugLoad then print("[#Start] Loading ce.hub.data.structures.StructureDataCollector ...") end

local StructureDataCollector = {}

local MAX_STRUCTURES = 50000

local EEPStructureGetLight = _G.EEPStructureGetLight or function () end         -- EEP 11.1 Plug-In 1
local EEPStructureGetSmoke = _G.EEPStructureGetSmoke or function () end         -- EEP 11.1 Plug-In 1
local EEPStructureGetFire = _G.EEPStructureGetFire or function () end           -- EEP 11.1 Plug-In 1
local EEPStructureGetPosition = _G.EEPStructureGetPosition or function () end   -- EEP 14.2
local EEPStructureGetModelType = _G.EEPStructureGetModelType or function () end -- EEP 14.2
local EEPStructureGetTagText = _G.EEPStructureGetTagText or function () end     -- EEP 14.2
local EEPStructureGetRotation = _G.EEPStructureGetRotation or function () end   -- EEP 16.1

local EEPStructureModelTypeText = {
    [16] = "Gleis/Gleisobjekt",
    [17] = "Schiene/Gleisobjekt",
    [18] = "Strasse/Gleisobjekt",
    [19] = "Sonstiges/Gleisobjekt",
    [22] = "Immobilie",
    [23] = "Landschaftselement/Fauna",
    [24] = "Landschaftselement/Flora",
    [25] = "Landschaftselement/Terra",
    [38] = "Landschaftselement/Instancing"
}

local function round2(value)
    return value and tonumber(string.format("%.2f", value)) or 0
end

local function createStructure(name, light, smoke, fire)
    local structure = {}
    structure.id = name
    structure.name = name

    local _, pos_x, pos_y, pos_z = EEPStructureGetPosition(name)
    local _, rot_x, rot_y, rot_z = EEPStructureGetRotation(name)
    local _, modelType = EEPStructureGetModelType(name)
    local _, tag = EEPStructureGetTagText(name)

    structure.pos_x = round2(pos_x)
    structure.pos_y = round2(pos_y)
    structure.pos_z = round2(pos_z)
    structure.rot_x = round2(rot_x)
    structure.rot_y = round2(rot_y)
    structure.rot_z = round2(rot_z)
    structure.modelType = modelType or 0
    structure.modelTypeText = EEPStructureModelTypeText[modelType] or ""
    structure.tag = tag or ""
    structure.light = light
    structure.smoke = smoke
    structure.fire = fire

    return structure
end

function StructureDataCollector.collectInitialStructures()
    local structures = {}

    for i = 0, MAX_STRUCTURES do
        local name = "#" .. tostring(i)

        local hasLight, light = EEPStructureGetLight(name)
        local hasSmoke, smoke = EEPStructureGetSmoke(name)
        local hasFire, fire = EEPStructureGetFire(name)

        if hasLight or hasSmoke or hasFire then
            table.insert(structures, createStructure(name, light, smoke, fire))
        end
    end

    return structures
end

---@param existingStructures table
function StructureDataCollector.refreshDirtyStructures(existingStructures)
    local dirtyStructures = {}

    for i = 1, #existingStructures do
        local structure = existingStructures[i]

        local _, light = EEPStructureGetLight(structure.name)
        local _, smoke = EEPStructureGetSmoke(structure.name)
        local _, fire = EEPStructureGetFire(structure.name)

        if light ~= structure.light or fire ~= structure.fire or smoke ~= structure.smoke then
            structure.light = light
            structure.smoke = smoke
            structure.fire = fire
            table.insert(dirtyStructures, structure)
        end
    end

    return dirtyStructures
end

return StructureDataCollector
