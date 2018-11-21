local AkModellPacker = {}

function AkModellPacker.schreibeDatei(dateiname, inhalt)
    local file = io.open(dateiname, "w+")
    assert(file, "Kann Datei nicht öffnen " .. dateiname)
    io.output(file)
    io.write(inhalt)
    io.close(file)
    print("----- Start " .. dateiname .. " --------------------------------------------------------------\n"
            .. inhalt
            .. "----- Ende " .. dateiname .. " --------------------------------------------------------------")
end

function AkModellPacker.dateienSuchen(dateiPfade, basisOrdner, unterOrdner)
    local dateiGefunden = false
    local aktuellerOrdner = basisOrdner .. "\\" .. unterOrdner
    if os.execute([[dir ]] .. aktuellerOrdner .. [[ /b /a-d >nul]]) then
        for datei in io.popen([[dir ]] .. aktuellerOrdner .. [[ /b /a-d ]]):lines() do
            print(unterOrdner .. "\\" .. datei)
            dateiPfade[unterOrdner .. "\\" .. datei] = datei
            dateiGefunden = true
        end
    else
        print([[Ordner nicht gefunden: "]] .. aktuellerOrdner .. [["]])
    end
    for ordner in io.popen([[dir "]] .. aktuellerOrdner .. [[" /b /ad]]):lines() do
        local sub_files = AkModellPacker.dateienSuchen(dateiPfade, basisOrdner, unterOrdner .. "\\" .. ordner)
        for pfad, datei in pairs(sub_files) do
            dateiPfade[pfad] = datei
            dateiGefunden = true
        end
    end
    return dateiPfade, dateiGefunden
end

--- Erzeugt den Inhalt von Install.ini
-- @param dateiPfade Map von Dateipfad zu Dateiname
function AkModellPacker.erzeugeInstallIniInhalt(dateiPfade, eepVersion)
    local install_ini = ""
    install_ini = install_ini .. "[EEPInstall]\n"
    install_ini = install_ini .. "EEPVersion = " .. eepVersion .. "\n"
    install_ini = install_ini .. "\n"

    local count = 1
    for path, file in pairs(dateiPfade) do
        install_ini = install_ini .. string.format([[File%03d = "%s", "%s"]], count, file, path) .. "\n"
        count = count + 1
    end
    return install_ini
end

return AkModellPacker