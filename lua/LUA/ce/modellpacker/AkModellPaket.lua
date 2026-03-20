local AkModellPacker = require("ce.modellpacker.AkModellPacker")

local AkModellPaket = {}
function AkModellPaket:new(eepVersion, germanName, germanDescription)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.eepVersion = eepVersion
    o.germanName = germanName
    o.germanDescription = germanDescription
    o:setName()
    o:setDescription()
    o.modelPaths = {}
    o.installationPaths = {}
    return o
end

function AkModellPaket:setName(englishName, frenchName, polishName)
    self.englishName = englishName or self.germanName
    self.frenchName = frenchName or self.englishName
    self.polishName = polishName or self.englishName
end

function AkModellPaket:setDescription(englisch, franzoesisch, polnisch)
    self.englishDescription = englisch or self.germanDescription
    self.frenchDescription = franzoesisch or self.englishDescription
    self.polishDescription = polnisch or self.englishDescription
end

--- Sucht im Unterordner des Basisordners nach Modellen
-- Alle erkannten Dateien werden als "prefix\subdirectory\...\Datei" erkannt und installiert
-- @param baseDirectory
-- @param prefix
-- @param subdirectory
-- @param excludePattern
--
function AkModellPaket:addFiles(baseDirectory, prefix, subdirectory, pathExclusionPattern)
    assert(type(baseDirectory) == "string", "Need 'baseDirectory' as string")
    assert(type(prefix) == "string", "Need 'prefix' as string")
    assert(type(subdirectory) == "string", "Need 'subdirectory' as string")
    local newPaths = {}
    print(string.format("[#ModellPaket] Durchsuche \"%s\" in Unterordner \"%s\"", baseDirectory, subdirectory))
    local _, fileFound = AkModellPacker.searchFiles(newPaths, baseDirectory, subdirectory)
    assert(fileFound,
           string.format("Keine Datei gefunden: \"%s\" in Unterordner \"%s\"", baseDirectory, subdirectory))

    for path, file in pairs(newPaths) do
        if pathExclusionPattern and AkModellPaket.excludePath(path, pathExclusionPattern) then
            print("[#ModellPaket] Ueberspringe: " .. path)
        else
            print("[#ModellPaket] Fuege Datei hinzu: " .. path)
            self.installationPaths[prefix .. path] = file
            self.modelPaths[baseDirectory .. "\\" .. path] = file
        end
    end
end

function AkModellPaket.excludePath(path, pathExclusionPattern)
    if not pathExclusionPattern then return false end

    for _, pattern in ipairs(pathExclusionPattern) do if string.find(path, pattern, 1, true) then return true end end
    return false
end

return AkModellPaket
