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
local EepSimulator = require("ce.hub.eep.EepSimulator")

-- Zum Test setzen wir ein paar Züge, Autos und Trams auf Gleise und Straßen
EepSimulator.simulatePlaceTrainOnRailTrack(5, "Tuff Tuff Zug")
EepSimulator.simulatePlaceTrainOnRailTrack(7, "Zoom Zoom Zug")
EepSimulator.simulatePlaceTrainOnRoadTrack(3, "Feuerwehr")
EepSimulator.simulatePlaceTrainOnRoadTrack(4, "Tram")
EepSimulator.simulatePlaceTrainOnRoadTrack(5, "Tram")
EepSimulator.simulatePlaceTrainOnRoadTrack(6, "Tram")

------------------------------------------------------------------------------------
-- Es folge der Import der Anlage, die getestet werden soll.
-- Ändere die folgende Zeile, wenn Du eine andere Anlage testen möchtest
------------------------------------------------------------------------------------
require("ce.template.crossing-simple")

-- Zeige erweiterte Informationen an                              --
local Scheduler = require("ce.hub.scheduler.Scheduler")
Scheduler.debug = false
local TrafficLight = require("ce.mods.road.TrafficLight")
TrafficLight.debug = false
local Crossing = require("ce.mods.road.Crossing")
local CrossingSettings = require("ce.mods.road.CrossingSettings")
Crossing.debug = false
CrossingSettings.showSignalIdOnSignal = false
CrossingSettings.showRequestsOnSignal = false
CrossingSettings.showSequenceOnSignal = false
local StorageUtility = require("ce.hub.util.StorageUtility")
StorageUtility.debug = false

-- Diese Methode nutzen wir später um vergangene Zeit in EEP zu simulieren und die EEPMain-Methode aufzurufen
local function run()
    EEPTime = EEPTime + 20
    EEPMain()
end

-- Wir rufen 50 Mal hintereinandere die run() Methode auf und simulieren so 50 EEPMain Aufrufe
-- mit aufeinanderfolgenden Zeiten
for _ = 1, 50 do run() end
