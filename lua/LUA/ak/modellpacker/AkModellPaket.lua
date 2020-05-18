local AkModellPacker = require("ak.modellpacker.AkModellPacker")

local AkModellPaket = {}
function AkModellPaket:new(eepVersion, deutscherName, deutscheBeschreibung)
    local o = {}
    setmetatable(o, self)
    self.__index = self
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
    print(string.format('Durchsuche "%s" in Unterordner "%s"', basisOrdner, unterOrdner))
    local _, dateiGefunden = AkModellPacker.dateienSuchen(neuePfade, basisOrdner, unterOrdner)
    assert(dateiGefunden, string.format('Keine Datei gefunden: "%s" in Unterordner "%s"', basisOrdner, unterOrdner))

    for pfad, datei in pairs(neuePfade) do
        if pfadAusschlussMuster and AkModellPaket.pfadAusschliessen(pfad, pfadAusschlussMuster) then
            print("Ueberspringe: " .. pfad)
        else
            print("Fuege Datei hinzu: " .. pfad)
            self.installationsPfade[praefix .. pfad] = datei
            self.modellPfade[basisOrdner .. "\\" .. pfad] = datei
        end
    end
end

function AkModellPaket.pfadAusschliessen(pfad, pfadAusschlussMuster)
    if not pfadAusschlussMuster then
        return false
    end

    for _, muster in ipairs(pfadAusschlussMuster) do
        if string.find(pfad, muster, 1, true) then
            return true
        end
    end
    return false
end

return AkModellPaket
