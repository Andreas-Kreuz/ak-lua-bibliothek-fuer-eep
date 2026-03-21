--------------------------------------------------------------------------------------
-- Erstellt Installationsverzeichnisse für Skripte und Demo-Anlagen in modell-pakete
--------------------------------------------------------------------------------------
local AkModellInstaller = require("ce.modellpacker.AkModellInstaller")
local AkModellPaket = require("ce.modellpacker.AkModellPaket")

local currentDirectory = ".."
if arg and arg[1] then currentDirectory = arg[1] end
print("[#ModellInstallation] Suche Installationsdateien in Verzeichnis \"" .. currentDirectory .. "\"")

-----------------------------------------
-- Paket: Skripte von Andreas Kreuz
-----------------------------------------
local paket0 = AkModellPaket:new("13,2", "Lua-Bibliothek von Andreas Kreuz",
                                 "Lua-Bibliothek mit Verkehrssteuerung, Aufgabenplanung und Modell-Installation")
paket0:addFiles(currentDirectory, "", "LUA\\ce", {
    "README.md",
    "anlagen",
    "ce-version.txt",
    "commands-to-ce",
    "desktop.ini",
    "events-from-ce",
    "events-from-ce.pending",
    "log-from-ce",
    "server-is-running"
})

do
    local installer = AkModellInstaller:new("Installer-AK-Lua-Bibliothek-fuer-EEP")
    installer:addModelPackage(paket0)
    installer:generatePackage(currentDirectory .. "\\modell-pakete")
end

-----------------------------------------
-- Paket: Demo-Anlage Ampelkreuzung
-----------------------------------------
local paket1 = AkModellPaket:new("13,2", "Demo-Anlage (Ampel, ÖPNV)", "Die Demo-Anlagen für Ampeln und ÖPNV")
paket1:addFiles(currentDirectory, "", "LUA\\ce\\demo-anlagen\\ampel", { "README.md", "desktop.ini" })
paket1:addFiles(currentDirectory, "", "Resourcen\\Anlagen\\Andreas_Kreuz-Demo-Ampel",
                { ".dds", "README.md", "desktop.ini" })
paket1:addFiles(currentDirectory, "", "LUA\\ce\\demo-anlagen\\demo-linien",
                { ".dds", "README.md", "desktop.ini" })
paket1:addFiles(currentDirectory, "", "Resourcen\\Anlagen\\Andreas_Kreuz-Demo-Linien",
                { ".dds", "README.md", "desktop.ini" })

-----------------------------------------
-- Paket: Demo-Anlage testen
-----------------------------------------
local paket2 = AkModellPaket:new("13,2", "Demo-Anlage Testen mit EEP (Erweiterte Modelle)",
                                 "Eine Anlage mit Shop-Modellen - mit zwei komplexen Kreuzungen und Ampel-Skripten")
paket2:addFiles(currentDirectory, "", "LUA\\ce\\demo-anlagen\\testen", { "README.md", "desktop.ini" })
paket2:addFiles(currentDirectory, "", "Resourcen\\Anlagen\\Andreas_Kreuz-Demo-Testen",
                { ".dds", "README.md", "desktop.ini" })

-----------------------------------------
-- Paket: Tutorial Ampelkreuzung
-----------------------------------------
local paket3 = AkModellPaket:new("13,2", "Tutorial - Aufbau einer Ampelkreuzung",
                                 "Eine Anlage mit einer Kreuzung, die die Verwendung der Lua-Bibliothek erklärt")
paket3:addFiles(currentDirectory, "", "LUA\\ce\\demo-anlagen\\tutorial-ampel", { "README.md", "desktop.ini" })
paket3:addFiles(currentDirectory, "", "Resourcen\\Anlagen\\Andreas_Kreuz-Tutorial-Ampelkreuzung",
                { ".dds", "README.md", "desktop.ini" })

print("[#ModellInstallation] " .. paket0.germanName)
print("[#ModellInstallation] " .. paket1.germanName)
print("[#ModellInstallation] " .. paket2.germanName)
print("[#ModellInstallation] " .. paket3.germanName)

local installer = AkModellInstaller:new("Installer-AK-Lua-Bibliothek-fuer-EEP")
installer:addModelPackage(paket0)
installer:addModelPackage(paket1)
installer:addModelPackage(paket2)
installer:addModelPackage(paket3)
installer:generatePackage(currentDirectory .. "\\modell-pakete")
