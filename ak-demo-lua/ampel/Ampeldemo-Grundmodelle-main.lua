--------------------------------
-- Lade Funktionen fuer Ampeln
--------------------------------
print('Lade AkStrasse ...')
require 'ak.strasse.AkStrasse'
AkTrafficLightsFunctions.showAnforderungen = true

------------------------------------------------
-- Damit kommt wird die Variable "Zugname" automatisch durch EEP belegt
-- http://emaps-eep.de/lua/code-schnipsel
------------------------------------------------
setmetatable(_ENV, { __index = function(_, k) local p = load(k); if p then local f = function(z) local s = Zugname; Zugname = z; p(); Zugname = s end; _ENV[k] = f; return f end; return nil end })

--------------------------------------------
-- Definiere Funktionen fuer Kontaktpunkte
--------------------------------------------
function KpBetritt(richtung)
    assert(richtung, "richtung darf nicht nil sein. Richtige Lua-Funktion im Kontaktpunkt?")
    --print(richtung.name .. " betreten durch: " .. Zugname)
    richtung:betritt()
end

function KpVerlasse(richtung, signalaufrot)
    assert(richtung, "richtung darf nicht nil sein. Richtige Lua-Funktion im Kontaktpunkt?")
    --print(richtung.name .. " verlassen von: " .. Zugname)
    richtung:verlasse(signalaufrot, Zugname)
end

----------------------------------------------------------------------------------------------------------------------
-- Definiere eigene Ampel-Modelle - hier Ampel 3 aus dem Grundbestand
-- Fuer die Signalstellung siehe Auswahlbox unter "Auswahl des Signalbegriffs"
-- bei Rechtsklick auf das Signal im 2D Editor
----------------------------------------------------------------------------------------------------------------------
Grundmodell_Ampel_3 = AkAmpelModell:neu("Grundmodell Ampel 3", -- Name des Modells
    2, -- Signalstellung fuer rot   (2. Stellung)
    1, -- Signalstellung fuer gruen (1. Stellung)
    3) -- Signalstellung fuer gelb  (3. Stellung)

Grundmodell_Ampel_3_FG = AkAmpelModell:neu("Grundmodell Ampel 3 FG", -- Name des Modells
    2, -- Signalstellung fuer rot   (2. Stellung)
    2, -- Signalstellung fuer rot   (2. Stellung)
    2, -- Signalstellung fuer rot   (2. Stellung)
    2, -- Signalstellung fuer rot   (2. Stellung)
    1) -- Signalstellung fuer gruen (1. Stellung)


-- Zeige die Signal-IDs aller Ampeln an
for i = 1, 1000 do
    EEPShowInfoSignal(i, true)
    EEPChangeInfoSignal(i, "Signal " .. i)
end




-- region K2-Richtungen
----------------------------------------------------------------------------------------------------------------------
-- Definiere alle Richtungen fuer Kreuzung 1
----------------------------------------------------------------------------------------------------------------------

--      +------------------------------------------------------ Neue Richtung
--      |              +--------------------------------------- Name der Richtung
--      |              |             +------------------------- Speicher ID - um die Anzahl der Fahrzeuge
--      |              |             |                                        und die Wartezeit zu speichern
--      |              |             |      +------------------ neue Ampel für diese Richtung (
--      |              |             |      |           +------ Signal-ID dieser Ampel
--      |              |             |      |           |   +-- Modell dieser Ampel - weiss wo rot, gelb und gruen ist
k2_r1 = AkRichtung:new("Richtung 1", 121, { AkAmpel:new(32, Grundmodell_Ampel_3) })
k2_r2 = AkRichtung:new("Richtung 2", 122, { AkAmpel:new(31, Grundmodell_Ampel_3) })
k2_r3 = AkRichtung:new("Richtung 3", 123, { AkAmpel:new(34, Grundmodell_Ampel_3) })
k2_r4 = AkRichtung:new("Richtung 4", 124, { AkAmpel:new(33, Grundmodell_Ampel_3) })
k2_r5 = AkRichtung:new("Richtung 5", 125, { AkAmpel:new(30, Grundmodell_Ampel_3) })
--region K1-Schaltungen
----------------------------------------------------------------------------------------------------------------------
-- Definiere alle Schaltungen fuer Kreuzung 2
----------------------------------------------------------------------------------------------------------------------
-- Eine Schaltung bestimmt, welche Richtungen gleichzeitig auf grün geschaltet werden dürfen, alle anderen sind rot

--- Kreuzung 2: Schaltung 1
local k2_schaltung1 = AkKreuzungsSchaltung:new("Schaltung 1")
k2_schaltung1:addRichtung(k2_r1)
k2_schaltung1:addRichtung(k2_r2)
k2_schaltung1:addRichtung(k2_r3)

--- Kreuzung 2: Schaltung 2
local k2_schaltung2 = AkKreuzungsSchaltung:new("Schaltung 2")
k2_schaltung2:addRichtung(k2_r1)
k2_schaltung2:addRichtung(k2_r2)

--- Kreuzung 2: Schaltung 3
local k2_schaltung3 = AkKreuzungsSchaltung:new("Schaltung 3")
k2_schaltung3:addRichtung(k2_r3)
k2_schaltung3:addRichtung(k2_r4)

--- Kreuzung 2: Schaltung 4
local k2_schaltung4 = AkKreuzungsSchaltung:new("Schaltung 4")
k2_schaltung4:addRichtung(k2_r5)

k2 = AkKreuzung:new("Kreuzung 2")
k2:addSchaltung(k2_schaltung1)
k2:addSchaltung(k2_schaltung2)
k2:addSchaltung(k2_schaltung3)
k2:addSchaltung(k2_schaltung4)
--endregion

-- region K1-Richtungen
----------------------------------------------------------------------------------------------------------------------
-- Definiere alle Richtungen fuer Kreuzung 1
----------------------------------------------------------------------------------------------------------------------

--      +------------------------------------------------------ Neue Richtung
--      |              +--------------------------------------- Name der Richtung
--      |              |             +------------------------- Speicher ID - um die Anzahl der Fahrzeuge
--      |              |             |                                        und die Wartezeit zu speichern
--      |              |             |      +------------------ neue Ampel für diese Richtung (
--      |              |             |      |           +------ Signal-ID dieser Ampel
--      |              |             |      |           |   +-- Modell dieser Ampel - weiss wo rot, gelb und gruen ist
k1_r1 = AkRichtung:new("Richtung 1", 101, { AkAmpel:new(17, Grundmodell_Ampel_3) })
k1_r2 = AkRichtung:new("Richtung 2", 102, { AkAmpel:new(13, Grundmodell_Ampel_3) })
k1_r3 = AkRichtung:new("Richtung 3", 103, { AkAmpel:new(12, Grundmodell_Ampel_3) })
k1_r4 = AkRichtung:new("Richtung 4", 104, { AkAmpel:new(11, Grundmodell_Ampel_3) })
k1_r5 = AkRichtung:new("Richtung 5", 105, { AkAmpel:new(10, Grundmodell_Ampel_3) })
k1_r6 = AkRichtung:new("Richtung 6", 106, { AkAmpel:new(09, Grundmodell_Ampel_3) })
k1_r7 = AkRichtung:new("Richtung 7", 107, { AkAmpel:new(16, Grundmodell_Ampel_3) })
k1_r8 = AkRichtung:new("Richtung 8", 108, { AkAmpel:new(15, Grundmodell_Ampel_3) })

k1_r1_5_fg = AkRichtung:new("Richtung 1+5 FG", -1, { -- keine Speicher-ID fuer Fussgaenger notwendig (-1)
    AkAmpel:new(40, Grundmodell_Ampel_3_FG), AkAmpel:new(41, Grundmodell_Ampel_3_FG),
    AkAmpel:new(36, Grundmodell_Ampel_3_FG), AkAmpel:new(37, Grundmodell_Ampel_3_FG)
})
k1_r3_7_fg = AkRichtung:new("Richtung 3+7 FG", -1, { -- keine Speicher-ID fuer Fussgaenger notwendig (-1)
    AkAmpel:new(38, Grundmodell_Ampel_3_FG), AkAmpel:new(39, Grundmodell_Ampel_3_FG),
    AkAmpel:new(42, Grundmodell_Ampel_3_FG), AkAmpel:new(43, Grundmodell_Ampel_3_FG)
})

--endregion
--region K1-Schaltungen
----------------------------------------------------------------------------------------------------------------------
-- Definiere alle Schaltungen fuer Kreuzung 1
----------------------------------------------------------------------------------------------------------------------
-- Eine Schaltung bestimmt, welche Richtungen gleichzeitig auf grün geschaltet werden dürfen, alle anderen sind rot

--- Kreuzung 1: Schaltung 1
local k1_schaltung1 = AkKreuzungsSchaltung:new("Schaltung 1")
k1_schaltung1:addRichtung(k1_r1)
k1_schaltung1:addRichtung(k1_r5)
k1_schaltung1:addRichtungFuerFussgaenger(k1_r1_5_fg)

--- Kreuzung 1: Schaltung 2
local k1_schaltung2 = AkKreuzungsSchaltung:new("Schaltung 2")
k1_schaltung2:addRichtung(k1_r2)
k1_schaltung2:addRichtung(k1_r6)

--- Kreuzung 1: Schaltung 3
local k1_schaltung3 = AkKreuzungsSchaltung:new("Schaltung 3")
k1_schaltung3:addRichtung(k1_r3)
k1_schaltung3:addRichtung(k1_r7)
k1_schaltung3:addRichtungFuerFussgaenger(k1_r3_7_fg)

--- Kreuzung 1: Schaltung 4
local k1_schaltung4 = AkKreuzungsSchaltung:new("Schaltung 4")
k1_schaltung4:addRichtung(k1_r4)
k1_schaltung4:addRichtung(k1_r8)

k1 = AkKreuzung:new("Kreuzung 1")
k1:addSchaltung(k1_schaltung1)
k1:addSchaltung(k1_schaltung2)
k1:addSchaltung(k1_schaltung3)
k1:addSchaltung(k1_schaltung4)
--endregion

function EEPMain()
    --print("Speicher: " .. collectgarbage("count"))
    AkSchaltungStart()
    AkScheduler:run()
    return 1
end
