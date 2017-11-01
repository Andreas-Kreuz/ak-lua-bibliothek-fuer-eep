require 'ak.modellpacker.AkModellInstallerHilfe'
local aktuellerOrdner = ".."
if arg and arg[1] then
    aktuellerOrdner = arg[1]
end
print("Suche Installationsdateien in Verzeichnis \"" .. aktuellerOrdner .. "\"")


-----------------------------------------
-- Paket: Skripte von Andreas Kreuz
-----------------------------------------
local paket0 = AkModellPaket:neu(14, "Skriptsammlung von Andreas Kreuz", "Diverse Lua-Skripte")
paket0:fuegeDateienHinzu(aktuellerOrdner, "", "LUA\\ak\\eep", { "README.md" })
paket0:fuegeDateienHinzu(aktuellerOrdner, "", "LUA\\ak\\schiene", { "README.md" })
paket0:fuegeDateienHinzu(aktuellerOrdner, "", "LUA\\ak\\planer", { "README.md" })
paket0:fuegeDateienHinzu(aktuellerOrdner, "", "LUA\\ak\\speicher", { "README.md" })
paket0:fuegeDateienHinzu(aktuellerOrdner, "", "LUA\\ak\\strasse", { "README.md" })
paket0:fuegeDateienHinzu(aktuellerOrdner, "", "LUA\\ak\\text", { "README.md" })

do
    local installer = AkModellInstaller:neu("Andreas-Kreuz-Skriptsammlung")
    installer:fuegeModellPaketHinzu(paket0)
    installer:erzeugePaket(aktuellerOrdner .. "\\modell-pakete")
end


-----------------------------------------
-- Paket: Demo-Anlage Ampelkreuzung
-----------------------------------------
do
    local paket1 = AkModellPaket:neu(14, "Demo-Anlage Ampel (Grundmodelle)", "Eine Anlage mit Grundmodellen aus EEP 14 - mit zwei Kreuzungen und Ampel-Skripten")
    paket1:fuegeDateienHinzu(aktuellerOrdner, "", "LUA\\ak\\demo-anlagen\\ampel", { "README.md" })
    paket1:fuegeDateienHinzu(aktuellerOrdner, "", "Resourcen\\Anlagen\\Andreas_Kreuz-Demo-Ampel", { ".dds", "README.md" })

    print(paket0.deutscherName)
    print(paket1.deutscherName)

    local installer = AkModellInstaller:neu("Demo-Anlage-Ampel-Grundmodelle")
    installer:fuegeModellPaketHinzu(paket0)
    installer:fuegeModellPaketHinzu(paket1)
    installer:erzeugePaket(aktuellerOrdner .. "\\modell-pakete")
end


-----------------------------------------
-- Paket: Demo-Anlage testen
-----------------------------------------
do
    local paket1 = AkModellPaket:neu(14, "Demo-Anlage Testen mit EEP (Erweiterte Modelle)", "Eine Anlage mit Shop-Modellen - mit zwei komplexen Kreuzungen und Ampel-Skripten")
    paket1:fuegeDateienHinzu(aktuellerOrdner, "", "LUA\\ak\\demo-anlagen\\testen", { "README.md" })
    paket1:fuegeDateienHinzu(aktuellerOrdner, "", "Resourcen\\Anlagen\\Andreas_Kreuz-Demo-Testen", { ".dds", "README.md" })

    print(paket0.deutscherName)
    print(paket1.deutscherName)

    local installer = AkModellInstaller:neu("Demo-Anlage-Testen-Grundmodelle")
    installer:fuegeModellPaketHinzu(paket0)
    installer:fuegeModellPaketHinzu(paket1)
    installer:erzeugePaket(aktuellerOrdner .. "\\modell-pakete")
end
