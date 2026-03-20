local AkModellPacker = require("ce.modellpacker.AkModellPacker")

local AkModellInstaller = {}

function AkModellInstaller:new(directoryName)
    assert(type(directoryName) == "string", "Need 'directoryName' as string")
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.modelPackages = {}
    o.index = 0
    o.directoryName = directoryName
    return o
end

function AkModellInstaller:addModelPackage(modelPackage)
    self.modelPackages[self.index] = modelPackage
    self.index = self.index + 1
end

function AkModellInstaller:generatePackage(outputDirectory)
    -- Unterverzeichnis erzeugen
    local installationDirectory = outputDirectory .. "\\" .. self.directoryName
    os.execute([[rmdir "]] .. installationDirectory .. [["  /S /Q]])
    os.execute([[mkdir "]] .. installationDirectory .. [["]])

    local content = ""
    for index = 0, (self.index - 1) do
        local modelPackage = self.modelPackages[index]
        content = content .. self.generateConfigurationSection(index, modelPackage)

        -- Modellpaket anlegen
        local modelPackageDirectory = string.format(installationDirectory .. "\\Install_%02d", index)
        os.execute([[mkdir "]] .. modelPackageDirectory .. [["]])

        -- Dateien des Modellpakets kopieren
        for path, fileName in pairs(modelPackage.modelPaths) do
            if not os.execute([[copy "]] .. path .. [[" "]] .. modelPackageDirectory .. "\\" .. fileName ..
                    [[" >nul]]) then
                print([[copy "]] .. path .. [[" "]] .. modelPackageDirectory .. "\\" .. fileName .. [["]])
                os.execute([[copy "]] .. path .. [[" "]] .. modelPackageDirectory .. "\\" .. fileName .. [[" ]])
                os.exit(1)
            end
        end

        -- Install ini schreiben
        local installIniFile = modelPackageDirectory .. "\\install.ini"
        AkModellPacker.writeFile(installIniFile, AkModellPacker.generateInstallIniContent(
            modelPackage.installationPaths, modelPackage.eepVersion))
    end
    local installationEepFile = string.format(installationDirectory .. "\\Installation.eep")
    AkModellPacker.writeFile(installationEepFile, content)

    if os.execute([[dir "C:\Program Files\7-Zip\7z.exe" > nul 2> nul]]) then
        os.execute([[del /F "]] .. outputDirectory .. "\\" .. self.directoryName .. [[.zip"]])
        os.execute([["C:\Program Files\7-Zip\7z.exe" a ]] .. outputDirectory .. "\\" .. self.directoryName ..
            [[.zip ]] .. installationDirectory .. [[\*]])
    end
end

function AkModellInstaller.generateConfigurationSection(index, modelPackage)
    local t = string.format("[Install_%02d]" .. "\n", index)
    t = t .. string.format([[Name_GER	 = "%s"]] .. "\n", modelPackage.germanName)
    t = t .. string.format([[Name_ENG	 = "%s"]] .. "\n", modelPackage.englishName)
    t = t .. string.format([[Name_FRA	 = "%s"]] .. "\n", modelPackage.frenchName)
    t = t .. string.format([[Name_POL	 = "%s"]] .. "\n", modelPackage.polishName)
    t = t .. string.format([[Desc_GER	 = "%s"]] .. "\n", modelPackage.germanDescription)
    t = t .. string.format([[Desc_ENG	 = "%s"]] .. "\n", modelPackage.englishDescription)
    t = t .. string.format([[Desc_FRA	 = "%s"]] .. "\n", modelPackage.frenchDescription)
    t = t .. string.format([[Desc_POL	 = "%s"]] .. "\n", modelPackage.polishDescription)
    t = t .. string.format([[Script	 = "Install_%02d\Install.ini"]] .. "\n", index)
    return t
end

return AkModellInstaller
