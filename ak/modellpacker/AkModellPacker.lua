local AkModellPacker = {}

AkModellInstaller = {}

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
        inhalt = inhalt .. self:erzeugeKonfigurationsAbschnitt(index, modellPaket)

        -- Modellpaket anlegen
        local modellPaketVerzeichnis = string.format(installation_verzeichnis .. "\\Install_%02d", index)
        os.execute([[mkdir "]] .. modellPaketVerzeichnis .. [["]])

        -- Dateien des Modellpakets kopieren
        for pfad, dateiname in pairs(modellPaket.modellPfade) do
            --print([[copy "]] .. pfad .. [[" "]] .. modellPaketVerzeichnis .. "\\" .. dateiname .. [["]])
            os.execute([[copy "]] .. pfad .. [[" "]] .. modellPaketVerzeichnis .. "\\" .. dateiname .. [[" > nul]])
        end

        -- Install ini schreiben
        local installIniDatei = modellPaketVerzeichnis .. "\\install.ini"
        AkModellPacker.schreibeDatei(installIniDatei, AkModellPacker.erzeugeInstallIniInhalt(modellPaket.installationsPfade))
    end
    local installation_eep_datei = string.format(installation_verzeichnis .. "\\Installation.eep")
    AkModellPacker.schreibeDatei(installation_eep_datei, inhalt)
end

function AkModellInstaller:erzeugeKonfigurationsAbschnitt(index, modellPaket)
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


AkModellPaket = {}
function AkModellPaket:neu(eepVersion, deutscherName, deutscheBeschreibung)
    local o = {}
    setmetatable(o, self)
    self.__index = self;
    o.eepVersion = eepVersion
    o.deutscherName = deutscherName
    o.deutscheBeschreibung = deutscheBeschreibung
    o:setzeName()
    o:setzeBeschreibung()
    o.modellPfade = {}
    o.installationsPfade = {}
    return o
end

function AkModellPaket:setzeName(englischerName, franzoesischerName, polnischerName)
    self.englischerName = englischerName or self.deutscherName
    self.franzoesischerName = franzoesischerName or self.englischerName
    self.polnischerName = polnischerName or self.englischerName
end

function AkModellPaket:setzeBeschreibung(englisch, franzoesisch, polnisch)
    self.englischeBeschreibung = englisch or self.deutscheBeschreibung
    self.franzoesischeBeschreibung = franzoesisch or self.englischeBeschreibung
    self.polnischeBeschreibung = polnisch or self.englischeBeschreibung
end

--- Sucht im Unterordner des Basisordners nach Modellen
-- Alle erkannten Dateien werden als "praefix\unterOrdner\...\Datei" erkannt und installiert
-- @param basisOrdner
-- @param praefix
-- @param unterOrdner
-- @param excludePattern
--
function AkModellPaket:fuegeDateienHinzu(basisOrdner, praefix, unterOrdner, pfadAusschlussMuster)
    assert(basisOrdner)
    assert(praefix)
    assert(unterOrdner)
    local neuePfade = {}
    AkModellPacker.dateienSuchen(neuePfade, basisOrdner, unterOrdner)

    for pfad, datei in pairs(neuePfade) do
        if not excludePatterns and not AkModellPaket.pfadAusschliessen(pfad, pfadAusschlussMuster) then
            self.installationsPfade[praefix .. "\\" .. pfad] = datei
            self.modellPfade[pfad] = datei
        end
    end
end

function AkModellPaket.pfadAusschliessen(pfad, pfadAusschlussMuster)
    if not pfadAusschlussMuster then return false end

    for _, muster in ipairs(pfadAusschlussMuster) do
        if string.find(pfad, muster) then
            return true
        end
    end
    return false
end

function AkModellPacker.schreibeDatei(dateiname, inhalt)
    file = io.open(dateiname, "w+")
    assert(file, "Kann Datei nicht öffnen " .. dateiname)
    io.output(file)
    io.write(inhalt)
    io.close(file)
    print("----- Start ".. dateiname .. " --------------------------------------------------------------\n"
            .. inhalt
            .. "----- Ende ".. dateiname .. " --------------------------------------------------------------")
end

function AkModellPacker.dateienSuchen(dateiPfade, basisOrdner, unterOrdner)
    local aktuellerOrdner = basisOrdner .. "\\" .. unterOrdner
    for datei in io.popen([[dir "]] .. aktuellerOrdner .. [[" /b /a-d 2> nul]]):lines() do
        --print(currentdir .. "\\" .. file1)
        dateiPfade[unterOrdner .. "\\" .. datei] = datei
    end
    for ordner in io.popen([[dir "]] .. aktuellerOrdner .. [[" /b /ad]]):lines() do
        local sub_files = AkModellPacker.dateienSuchen(dateiPfade, basisOrdner, unterOrdner .. "\\" .. ordner)
        for pfad, datei in pairs(sub_files) do
            dateiPfade[pfad] = datei
        end
    end
    return dateiPfade
end

--- Erzeugt den Inhalt von Install.ini
-- @param dateiPfade Map von Dateipfad zu Dateiname
function AkModellPacker.erzeugeInstallIniInhalt(dateiPfade)
    local install_ini = ""
    install_ini = install_ini .. "[EEPInstall]\n"
    install_ini = install_ini .. "EEPVersion = 14\n"
    install_ini = install_ini .. "\n"

    local count = 1
    for path, file in pairs(dateiPfade) do
        install_ini = install_ini .. string.format([[File%03d = "%s", "%s"]], count, file, path) .. "\n"
        count = count + 1
    end
    return install_ini
end
