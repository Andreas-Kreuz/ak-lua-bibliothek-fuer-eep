local AkModellPacker = require("ak.modellpacker.AkModellPacker")

local AkModellInstaller = {}

function AkModellInstaller:neu(verzeichnisname)
    assert(verzeichnisname)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.modellPakete = {}
    o.index = 0
    o.verzeichnisname = verzeichnisname
    return o
end

function AkModellInstaller:fuegeModellPaketHinzu(modellPaket)
    self.modellPakete[self.index] = modellPaket
    self.index = self.index + 1
end

function AkModellInstaller:erzeugePaket(ausgabeverzeichnis)
    -- Unterverzeichnis erzeugen
    local installation_verzeichnis = ausgabeverzeichnis .. "\\" .. self.verzeichnisname
    os.execute([[rmdir "]] .. installation_verzeichnis .. [["  /S /Q]])
    os.execute([[mkdir "]] .. installation_verzeichnis .. [["]])

    local inhalt = ""
    for index = 0, (self.index - 1) do
        local modellPaket = self.modellPakete[index]
        inhalt = inhalt .. self.erzeugeKonfigurationsAbschnitt(index, modellPaket)

        -- Modellpaket anlegen
        local modellPaketVerzeichnis = string.format(installation_verzeichnis .. "\\Install_%02d", index)
        os.execute([[mkdir "]] .. modellPaketVerzeichnis .. [["]])

        -- Dateien des Modellpakets kopieren
        for pfad, dateiname in pairs(modellPaket.modellPfade) do
            if not os.execute(
                [[copy "]] .. pfad .. [[" "]] .. modellPaketVerzeichnis .. "\\" .. dateiname .. [[" >nul]]) then
                print([[copy "]] .. pfad .. [[" "]] .. modellPaketVerzeichnis .. "\\" .. dateiname .. [["]])
                os.execute([[copy "]] .. pfad .. [[" "]] .. modellPaketVerzeichnis .. "\\" .. dateiname .. [[" ]])
                os.exit(1)
            end
        end

        -- Install ini schreiben
        local installIniDatei = modellPaketVerzeichnis .. "\\install.ini"
        AkModellPacker.schreibeDatei(installIniDatei,
            AkModellPacker.erzeugeInstallIniInhalt(modellPaket.installationsPfade, modellPaket.eepVersion))
    end
    local installation_eep_datei = string.format(installation_verzeichnis .. "\\Installation.eep")
    AkModellPacker.schreibeDatei(installation_eep_datei, inhalt)

    if os.execute([[dir "C:\Program Files\7-Zip\7z.exe" > nul 2> nul]]) then
        os.execute([[del /F "]] .. ausgabeverzeichnis .. "\\" .. self.verzeichnisname .. [[.zip"]])
        os.execute([["C:\Program Files\7-Zip\7z.exe" a ]] .. ausgabeverzeichnis .. "\\"
                .. self.verzeichnisname .. [[.zip ]] .. installation_verzeichnis .. [[\*]])
    end
end

function AkModellInstaller.erzeugeKonfigurationsAbschnitt(index, modellPaket)
    local t = string.format("[Install_%02d]" .. "\n", index)
    t = t .. string.format([[Name_GER	 = "%s"]] .. "\n", modellPaket.deutscherName)
    t = t .. string.format([[Name_ENG	 = "%s"]] .. "\n", modellPaket.englischerName)
    t = t .. string.format([[Name_FRA	 = "%s"]] .. "\n", modellPaket.franzoesischerName)
    t = t .. string.format([[Name_POL	 = "%s"]] .. "\n", modellPaket.polnischerName)
    t = t .. string.format([[Desc_GER	 = "%s"]] .. "\n", modellPaket.deutscheBeschreibung)
    t = t .. string.format([[Desc_ENG	 = "%s"]] .. "\n", modellPaket.englischeBeschreibung)
    t = t .. string.format([[Desc_FRA	 = "%s"]] .. "\n", modellPaket.franzoesischeBeschreibung)
    t = t .. string.format([[Desc_POL	 = "%s"]] .. "\n", modellPaket.polnischeBeschreibung)
    t = t .. string.format([[Script	 = "Install_%02d\Install.ini"]] .. "\n", index)
    return t
end

return AkModellInstaller