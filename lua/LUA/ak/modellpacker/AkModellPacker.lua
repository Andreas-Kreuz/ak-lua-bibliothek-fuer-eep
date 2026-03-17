local AkModellPacker = {}

function AkModellPacker.writeFile(fileName, content)
    local file = io.open(fileName, "w+")
    assert(file, fileName)
    io.output(file)
    io.write(content)
    io.close(file)
    print("[#ModellPacker] ----- Start " .. fileName ..
        " --------------------------------------------------------------\n" .. content ..
        " -------------------- Ende " .. fileName ..
        " --------------------------------------------------------------")
end

function AkModellPacker.searchFiles(filePaths, baseDirectory, subdirectory)
    local fileFound = false
    local currentDirectory = baseDirectory .. "\\" .. subdirectory
    if os.execute([[dir ]] .. currentDirectory .. [[ /b /a-d >nul]]) then
        for file in io.popen([[dir ]] .. currentDirectory .. [[ /b /a-d ]]):lines() do
            print("[#ModellPacker] " .. subdirectory .. "\\" .. file)
            filePaths[subdirectory .. "\\" .. file] = file
            fileFound = true
        end
    else
        print("[#ModellPacker] " .. [[Ordner nicht gefunden: "]] .. currentDirectory .. [["]])
    end
    for directory in io.popen([[dir "]] .. currentDirectory .. [[" /b /ad]]):lines() do
        local sub_files = AkModellPacker.searchFiles(filePaths, baseDirectory, subdirectory .. "\\" .. directory)
        for path, file in pairs(sub_files) do
            filePaths[path] = file
            fileFound = true
        end
    end
    return filePaths, fileFound
end

--- Erzeugt den Inhalt von Install.ini
-- @param filePaths Map von Dateipfad zu Dateiname
function AkModellPacker.generateInstallIniContent(filePaths, eepVersion)
    local install_ini = ""
    install_ini = install_ini .. "[EEPInstall]\n"
    install_ini = install_ini .. "EEPVersion = " .. eepVersion .. "\n"
    install_ini = install_ini .. "\n"

    local count = 1
    for path, file in pairs(filePaths) do
        install_ini = install_ini .. string.format([[File%03d = "%s", "%s"]], count, file, path) .. "\n"
        count = count + 1
    end
    return install_ini
end

return AkModellPacker
