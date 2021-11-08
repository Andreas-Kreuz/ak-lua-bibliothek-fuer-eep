if AkDebugLoad then print("Loading ak.data.StructureJsonCollector ...") end
StructureJsonCollector = {}
local enabled = true
local initialized = false
StructureJsonCollector.name = "ak.data.StructureJsonCollector"

local MAX_STRUCTURES = 50000
local structures = {}

local EEPStructureGetPosition = EEPStructureGetPosition or function() end -- EEP 14.2
local EEPStructureGetModelType = EEPStructureGetModelType or function() end -- EEP 14.2
local EEPStructureGetTagText = EEPStructureGetTagText or function() end -- EEP 14.2

--- Ermittelt die Ausrichtung der Immobilie/des Landschaftselementes in Grad
-- OK, RotX, RotY, RotZ = EEPStructureGetRotation("#aunnel")
local EEPStructureGetRotation = EEPStructureGetRotation or function() end -- EEP 16.1

function StructureJsonCollector.initialize()
    if not enabled or initialized then return end

    for i = 0, MAX_STRUCTURES do
        local name = "#" .. tostring(i)

        local hasLight = EEPStructureGetLight(name) -- EEP 11.1 Plug-In 1
        local hasSmoke = EEPStructureGetSmoke(name) -- EEP 11.1 Plug-In 1
        local hasFire = EEPStructureGetFire(name) -- EEP 11.1 Plug-In 1

        if hasLight or hasSmoke or hasFire then
            local structure = {}
            structure.name = name

            local _, pos_x, pos_y, pos_z = EEPStructureGetPosition(name)
            local _, rot_x, rot_y, rot_z = EEPStructureGetRotation(name)
            local _, modelType = EEPStructureGetModelType(name)
            local EEPStructureModelTypeText = {
                [16] = "Gleis/Gleisobjekt",
                [17] = "Schiene/Gleisobjekt",
                [18] = "Straﬂe/Gleisobjekt",
                [19] = "Sonstiges/Gleisobjekt",
                [22] = "Immobilie",
                [23] = "Landschaftselement/Fauna",
                [24] = "Landschaftselement/Flora",
                [25] = "Landschaftselement/Terra",
                [38] = "Landschaftselement/Instancing"
            }
            local _, tag = EEPStructureGetTagText(name)

            structure.pos_x = pos_x and tonumber(string.format("%.2f", pos_x)) or 0
            structure.pos_y = pos_y and tonumber(string.format("%.2f", pos_y)) or 0
            structure.pos_z = pos_z and tonumber(string.format("%.2f", pos_z)) or 0
            structure.rot_x = rot_x and tonumber(string.format("%.2f", rot_x)) or 0
            structure.rot_y = rot_y and tonumber(string.format("%.2f", rot_y)) or 0
            structure.rot_z = rot_z and tonumber(string.format("%.2f", rot_z)) or 0
            structure.modelType = modelType or 0
            structure.modelTypeText = EEPStructureModelTypeText[modelType] or ""
            structure.tag = tag or ""
            table.insert(structures, structure)
        end
    end

    initialized = true
end

function StructureJsonCollector.collectData()
    if not enabled then return end

    if not initialized then StructureJsonCollector.initialize() end

    for i = 1, #structures do
        local structure = structures[i]

        local _, light = EEPStructureGetLight(structure.name) -- EEP 11.1 Plug-In 1
        local _, smoke = EEPStructureGetSmoke(structure.name) -- EEP 11.1 Plug-In 1
        local _, fire = EEPStructureGetFire(structure.name) -- EEP 11.1 Plug-In 1

        structure.light = light
        structure.smoke = smoke
        structure.fire = fire
    end

    return {["structures"] = structures}
end

return StructureJsonCollector
