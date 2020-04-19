print "Lade ak.data.PlanerLuaModul ..."
PlanerLuaModul = {}
local enabled = true
local initialized = false
-- Jedes Modul hat einen eindeutigen Namen
PlanerLuaModul.name = "ak.data.PlanerLuaModul"
local AkPlaner = require("ak.planer.AkPlaner")

--- Diese Funktion wird einmalig durch ModuleRegistry.initTasks() aufgerufen
-- Ist ein Modul für EEPWeb vorhanden, dann solltes in dieser Funktion aufgerufen werden
-- @author Andreas Kreuz
function PlanerLuaModul.init()
    if not enabled or initialized then
        return
    end

    -- Hier wird der CoreWebConnector registriert, so dass die Kommunikation mit der WebApp funktioniert
    -- Not there yet
    --local PlanerWebConnector = require("ak.planer.PlanerWebConnector")
    --PlanerWebConnector.registerJsonCollectors();

    initialized = true
end

--- Diese Funktion wird regelmäßig durch ModuleRegistry.runTasks() aufgerufen
-- @author Andreas Kreuz
function PlanerLuaModul.run()
    if not enabled then
        return
    end

    -- Hier folgen die wiederkehrenden Funktionen jedes Moduls (müssen dann nicht in EEPMain aufgerufen werden)
    AkPlaner:fuehreGeplanteAktionenAus()
end

return PlanerLuaModul
