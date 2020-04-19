print "Lade ak.data.CoreLuaModule ..."
CoreLuaModule = {}
local enabled = true
local initialized = false
-- Jedes Modul hat einen eindeutigen Namen
CoreLuaModule.name = "ak.data.CoreLuaModule"

--- Diese Funktion wird einmalig durch ModuleRegistry.initTasks() aufgerufen
-- Ist ein Modul für EEPWeb vorhanden, dann solltes in dieser Funktion aufgerufen werden
-- @author Andreas Kreuz
function CoreLuaModule.init()
    if not enabled or initialized then
        return
    end

    -- Hier wird der CoreWebConnector registriert, so dass die Kommunikation mit der WebApp funktioniert
    local CoreWebConnector = require("ak.core.CoreWebConnector")
    CoreWebConnector.registerJsonCollectors();

    initialized = true
end

--- Diese Funktion wird regelmäßig durch ModuleRegistry.runTasks() aufgerufen
-- @author Andreas Kreuz
function CoreLuaModule.run()
    if not enabled then
        return
    end

    -- Hier folgen die wiederkehrenden Funktionen jedes Moduls (müssen dann nicht in EEPMain aufgerufen werden)
    -- Das CoreModul hat keine wiederkehrenden Funktionen
end

return CoreLuaModule
