require("ak.core.eep.AkEepFunktionen")

EEPSaveData(1, 0) -- Speichere den Zähler auf 0 - muss vor dem Skript aufgerufen werden

-- Laden das Haupt-Skripts
require("ak.demo-anlagen.testen.Andreas_Kreuz-Lua-Testbeispiel-main")


assert(1 == EEPMain()) -- EEPMain muss 1 zurückgeben!
assert (4 == EEPGetSignal(1)) -- Der Zaehler ist 0, das Signal muss auf 4 stehen


zaehleHoch() -- simuliere ein Fahrzeug, welches in den Bereich einfährt
assert(1 == zaehler)
EEPMain() -- EEPMain aufrufen und danach das Signal prüfen
assert (4 == EEPGetSignal(1)) -- Der Zaehler ist 1, das Signal muss auf 4 stehen

zaehleHoch() -- simuliere ein Fahrzeug, welches in den Bereich einfährt
assert(2 == zaehler)
EEPMain() -- EEPMain aufrufen und danach das Signal prüfen
assert (1 == EEPGetSignal(1)) -- Der Zaehler ist 2, das Signal muss auf 1 stehen

zaehleRunter() -- simuliere ein Fahrzeug, welches in den Bereich einfährt
assert(1 == zaehler)
EEPMain() -- EEPMain aufrufen und danach das Signal prüfen
assert (4 == EEPGetSignal(1)) -- Der Zaehler ist 2, das Signal muss auf 1 stehen

zaehleRunter() -- simuliere ein Fahrzeug, welches in den Bereich einfährt
assert(0 == zaehler)
EEPMain() -- EEPMain aufrufen und danach das Signal prüfen
assert (4 == EEPGetSignal(1)) -- Der Zaehler ist 2, das Signal muss auf 1 stehen
