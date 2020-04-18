clearlog()
print("Der wahre Schatz liegt in: ")
print([[EEP\LUA\ak\demo-anlagen\testen\Andreas_Kreuz-Lua-Testbeispiel-test.lua]])
print("")
print("Mit der test-Datei kann man diese Datei hier ohne EEP testen!")

-- Lade den aktuellen Zähler
zaehler = 0
geladen, loadedZaehler = EEPLoadData(1)
if geladen then
	zaehler = loadedZaehler
	print(zaehler .. " (geladen)")
end

-- Ein Fahrzeug verlässt den Bereich vor dem Signal
function zaehleHoch()
	zaehler = zaehler + 1
	EEPSaveData(1, zaehler)
	print(zaehler .. " erwarte: " .. ((zaehler < 2) and "rot" or "gruen"))
end

-- Ein Fahrzeug verlässt den Bereich vor dem Signal
function zaehleRunter()
	zaehler = zaehler - 1
	EEPSaveData(1, zaehler)
	print(zaehler .. " erwarte: " .. ((zaehler < 2) and "rot" or "gruen"))
end

-- Bei weniger als zwei Fahrzeigen im Bereich setzen wir die Ampel auf rot
function EEPMain()
    if zaehler < 2 then
		EEPSetSignal(1, 4) -- Signal 1 auf rot
	else
		EEPSetSignal(1, 1) -- Signal 1 auf gruen
	end
	return 1
end
