print "Lade ak.data.KreuzungLuaModul ..."
KreuzungLuaModul = {}
local enabled = true
local initialized = false
-- Jedes Modul hat einen eindeutigen Namen
KreuzungLuaModul.name = "ak.data.KreuzungLuaModul"
local AkKreuzung = require("ak.strasse.AkKreuzung")

--- Diese Funktion wird einmalig durch ModuleRegistry.initTasks() aufgerufen
-- Ist ein Modul für EEPWeb vorhanden, dann solltes in dieser Funktion aufgerufen werden
-- @author Andreas Kreuz
function KreuzungLuaModul.init()
    if not enabled or initialized then
        return
    end

    -- Hier wird der CoreWebConnector registriert, so dass die Kommunikation mit der WebApp funktioniert
    local KreuzungWebConnector = require("ak.strasse.KreuzungWebConnector")
    KreuzungWebConnector.registerJsonCollectors()
    KreuzungWebConnector.registerFunctions()

    initialized = true
end

--- Diese Funktion wird regelmäßig durch ModuleRegistry.runTasks() aufgerufen
-- @author Andreas Kreuz
function KreuzungLuaModul.run()
    if not enabled then
        return
    end

    -- Hier folgen die wiederkehrenden Funktionen jedes Moduls (müssen dann nicht in EEPMain aufgerufen werden)
    AkKreuzung:planeSchaltungenEin()
end

do
    -- Das KreuzungLuaModul benötigt das PlanerLuaModul
    -- Dies wird beim Einlesen dieser Datei automatisch registriert
    local ModuleRegistry = require("ak.core.ModuleRegistry")
    ModuleRegistry.registerModules(require("ak.planer.PlanerLuaModul"))
end

return KreuzungLuaModul
