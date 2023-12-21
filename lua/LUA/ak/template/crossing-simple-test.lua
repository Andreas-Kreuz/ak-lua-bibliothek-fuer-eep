-----------------------------------------------------------------------------------------------------------------------
-- Diese Skript ist eine kleine Vorlage für das Testen von Kreuzungen, wenn Du bereits ein Lua-Skript mit Kreuzungen,
-- Schaltungen und Ampeln hast
--
-- Voraussetzung: Du hast Lua auf der Kommandozeile installiert
--
-- Ablauf
-- 1) Kopiere dieses Skript in das LUA-Verzeichnis von EEP
-- 2) Benenne die Kopie um, z.B. "anlage1-test.lua"
-- 3) Ändere die weiter unten stehenden Zeile auf den Namen der zu testenden Anlage ab
--    require("anlage1")
-- 4) Rufe "lua anlage1-test.lua" auf der Kommandozeile auf
-----------------------------------------------------------------------------------------------------------------------
-- Zeigt erweiterte Informationen waehrend der Initialisierung an (oder nicht)
AkDebugLoad = false
AkStartWithDebug = false

-- Lädt den EEP Simulator
local EepSimulator = require("ak.core.eep.EepSimulator")

-- Zum Test setzen wir ein paar Züge, Autos und Trams auf Gleise und Straßen
EepSimulator.setzeZugAufGleis(5, "Tuff Tuff Zug")
EepSimulator.setzeZugAufGleis(7, "Zoom Zoom Zug")
EepSimulator.setzeZugAufStrasse(3, "Feuerwehr")
EepSimulator.setzeZugAufStrasse(4, "Tram")
EepSimulator.setzeZugAufStrasse(5, "Tram")
EepSimulator.setzeZugAufStrasse(6, "Tram")

------------------------------------------------------------------------------------
-- Es folge der Import der Anlage, die getestet werden soll.
-- Ändere die folgende Zeile, wenn Du eine andere Anlage testen möchtest
------------------------------------------------------------------------------------
require("ak.template.crossing-simple")

-- Zeige erweiterte Informationen an                              --
local Scheduler = require("ak.scheduler.Scheduler")
Scheduler.debug = false
local TrafficLight = require("ak.road.TrafficLight")
TrafficLight.debug = false
local Crossing = require("ak.road.Crossing")
Crossing.debug = false
Crossing.showSignalIdOnSignal = false
Crossing.showRequestsOnSignal = false
Crossing.showSequenceOnSignal = false
local StorageUtility = require("ak.storage.StorageUtility")
StorageUtility.debug = false

-- Diese Methode nutzen wir später um vergangene Zeit in EEP zu simulieren und die EEPMain-Methode aufzurufen
local function run()
    EEPTime = EEPTime + 20
    EEPMain()
end

-- Wir rufen 50 Mal hintereinandere die run() Methode auf und simulieren so 50 EEPMain Aufrufe
-- mit aufeinanderfolgenden Zeiten
for _ = 1, 50 do run() end
