--------------------------------------------------------------------------------------
-- Erstellt Installationsverzeichnisse für Skripte und Demo-Anlagen in modell-pakete
--------------------------------------------------------------------------------------
local AkModellInstaller = require("ak.modellpacker.AkModellInstaller")
local AkModellPaket = require("ak.modellpacker.AkModellPaket")

local aktuellerOrdner = ".."
if arg and arg[1] then
    aktuellerOrdner = arg[1]
end
print("Suche Installationsdateien in Verzeichnis \"" .. aktuellerOrdner .. "\"")


-----------------------------------------
-- Paket: Skripte von Andreas Kreuz
-----------------------------------------
local paket0 = AkModellPaket:neu("13,2", "Lua-Bibliothek von Andreas Kreuz",
    "Lua-Bibliothek mit Verkehrssteuerung, Aufgabenplanung und Modell-Installation")
paket0:fuegeDateienHinzu(aktuellerOrdner, "", "LUA\\ak", {
    "README.md",
    "ak-eep-in.commands",
    "ak-eep-out.json",
    "ak-eep-out-json.isfinished",
    "ak-eep-out.log",
    "ak-eep-version.txt",
    "ak-server.iswatching",
    "anlagen",
})

do
    local installer = AkModellInstaller:neu("Installer-AK-Lua-Bibliothek-fuer-EEP")
    installer:fuegeModellPaketHinzu(paket0)
    installer:erzeugePaket(aktuellerOrdner .. "\\modell-pakete")
end

-----------------------------------------
-- Paket: Demo-Anlage Ampelkreuzung
-----------------------------------------
local paket1 = AkModellPaket:neu("13,2", "Demo-Anlage Ampel (Grundmodelle)",
        "Eine Anlage mit Grundmodellen aus EEP 14 - mit zwei Kreuzungen und Ampel-Skripten")
paket1:fuegeDateienHinzu(aktuellerOrdner, "", "LUA\\ak\\demo-anlagen\\ampel", {
    "README.md"
})
paket1:fuegeDateienHinzu(aktuellerOrdner, "", "Resourcen\\Anlagen\\Andreas_Kreuz-Demo-Ampel", {
    ".dds", "README.md"
})

-----------------------------------------
-- Paket: Demo-Anlage testen
-----------------------------------------
local paket2 = AkModellPaket:neu("13,2", "Demo-Anlage Testen mit EEP (Erweiterte Modelle)",
        "Eine Anlage mit Shop-Modellen - mit zwei komplexen Kreuzungen und Ampel-Skripten")
paket2:fuegeDateienHinzu(aktuellerOrdner, "", "LUA\\ak\\demo-anlagen\\testen", {
    "README.md"
})
paket2:fuegeDateienHinzu(aktuellerOrdner, "", "Resourcen\\Anlagen\\Andreas_Kreuz-Demo-Testen", {
    ".dds", "README.md"
})

-----------------------------------------
-- Paket: Tutorial Ampelkreuzung
-----------------------------------------
local paket3 = AkModellPaket:neu("13,2", "Tutorial - Aufbau einer Ampelkreuzung",
        "Eine Anlage mit einer Kreuzung, die die Verwendung der Lua-Bibliothek erklärt")
paket3:fuegeDateienHinzu(aktuellerOrdner, "", "LUA\\ak\\demo-anlagen\\tutorial-ampel", {
    "README.md"
})
paket3:fuegeDateienHinzu(aktuellerOrdner, "", "Resourcen\\Anlagen\\Andreas_Kreuz-Tutorial-Ampelkreuzung", {
    ".dds", "README.md"
})

print(paket0.deutscherName)
print(paket1.deutscherName)
print(paket2.deutscherName)
print(paket3.deutscherName)

local installer = AkModellInstaller:neu("Installer-AK-Lua-Bibliothek-fuer-EEP")
installer:fuegeModellPaketHinzu(paket0)
installer:fuegeModellPaketHinzu(paket1)
installer:fuegeModellPaketHinzu(paket2)
installer:fuegeModellPaketHinzu(paket3)
installer:erzeugePaket(aktuellerOrdner .. "\\modell-pakete")
