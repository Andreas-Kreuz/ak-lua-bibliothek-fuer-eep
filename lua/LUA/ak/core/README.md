---
layout: page_with_toc
title: Der Kern der App
subtitle: Dieser Teil enthält das Standardmodul 
permalink: lua/ak/eep/
feature-img: "/docs/assets/headers/SourceCode.png"
img: "/docs/assets/headers/SourceCode.png"
---

# Paket ak.core

* Dieses Paket enthält das Skript für das Einbinden und Starten der anderen Module.

Das Skript `ModuleRegistry` wird genutzt um die Module zu registrieren.
Die Einbindung von `ModuleRegistry.runTasks()` in `EEPMain()` sorgt dafür, dass die Tasks der Module ausgeführt werden.

## Verwendung

Hier ein minimales Beispiel (bei dem die Kreuzungssteuerung genutzt wird):

```lua
local ModuleRegistry = require("ak.core.ModuleRegistry")
ModuleRegistry.registerModules(
    -- require("ak.core.CoreLuaModule"), -- loaded automatically 
    require("ak.strasse.KreuzungLuaModul")
)

function EEPMain()
    ModuleRegistry.runTasks()
    return 1
end
```

## Verwendung von DataLuaModule / erweitertes Beispiel

Das Modul `DataLuaModule` kann, wie im vorigen Abschnitt beschrieben, aufgerufen werden. 

Es bietet zusätzliche Optionen an, mit der die Auswahl den Daten-Kollektoren und die Auswahl der zu exportierenden Daten genau eingestellt werden kann.

Dazu dienen die zusätzlichen Funktionen `registerCollectors` und `setActiveEntries`, denen Listen der jeweils aktiven Objekten übergeben werden kann. Ohne diese Ausrufe, oder wenn eine leere Liste übergeben wird, werden alle Daten gesammelt und exportiert. Im Beispiel unten werden alle Optionen angegeben (kommentiert, so dass mit diesem Beispiel leere Listen genutzt werden.)

Mit der Funktion `setWaitForServer` kann festgelegt werden, ob die Dateien immer aktualiert werden sollen oder ob dies nur geschehen soll wenn der EEP-Webserver aktiv und empfangsbereit ist (default).

Die Funktion `runTasks()` besitzt einen zusätzlichen Parameter mit der angegeben werden kann nach wievielen Zyklen die Dateien aktualisiert werden sollen. 

Die Standardfunktion `clearlog()` wird von dem Modul überladen. Damit wird dann nicht nur das Protokoll in EEP gelöscht sondern auch der Inhalt der exportierten Log-Datei.  

```
clearlog() -- This call before loading EEP-Web clears the log within EEP but does not clear the log file of EEP Web

-- Load EEP Web Modules
local ModuleRegistry = require("ak.core.ModuleRegistry")
ModuleRegistry.registerModules(
--  require("ak.core.CoreLuaModule"), -- loaded automatically 
    require("ak.data.DataLuaModule")
)
-- DataLuaModule: register JsonCollectors (default = all)
ModuleRegistry.registerCollectors({
--  "ak.data.DataSlotsJsonCollector",
--  "ak.data.SignalJsonCollector",
--  "ak.data.SwitchJsonCollector",
--  "ak.data.StructureJsonCollector",
--  "ak.data.TimeJsonCollector",
--  "ak.data.TrainsAndTracksJsonCollector",
})
-- DataLuaModule: set active entries (default = all)
ModuleRegistry.setActiveEntries({
    -- Collector: common
--  "api-entries",

    -- Collector: "ak.data.TimeJsonCollector",
--  "times",

    -- Collector: "ak.core.VersionJsonCollector",
--  "eep-version",

    -- Collector: "ak.data.TrainsAndTracksJsonCollector",
--  "rail-rolling-stock-infos-dynamic",
--  "rail-rolling-stocks",
--  "rail-tracks",
--  "rail-train-infos-dynamic",
--  "rail-trains",
--  "tram-rolling-stock-infos-dynamic",
--  "tram-rolling-stocks",
--  "tram-tracks",
--  "tram-train-infos-dynamic",
--  "tram-trains",
--  "road-rolling-stock-infos-dynamic",
--  "road-rolling-stocks",
--  "road-tracks",
--  "road-train-infos-dynamic",
--  "road-trains",
--  "auxiliary-rolling-stock-infos-dynamic",
--  "auxiliary-rolling-stocks",
--  "auxiliary-tracks",
--  "auxiliary-train-infos-dynamic",
--  "auxiliary-trains",
--  "control-rolling-stock-infos-dynamic",
--  "control-rolling-stocks",
--  "control-tracks",
--  "control-train-infos-dynamic",
--  "control-trains",
--  "runtime",

    -- Collector: "ak.data.SwitchJsonCollector",
--  "switches",

    -- Collector: "ak.data.SignalJsonCollector",
--  "signals",
--  "waiting-on-signals",

    -- Collector: "ak.data.StructureJsonCollector",
--  "structures",

    -- Collector: "ak.data.DataSlotsJsonCollector",
--  "save-slots",
--  "free-slots",

})

-- Allow to update the json file without checking if the Web Server is ready
ModuleRegistry.setWaitForServer(true) 

--clearlog() -- This call after loading EEP Web clears the log file, too

function EEPMain()
    ModuleRegistry.runTasks(1) -- 1: every 200 ms, 5: every second, ...
    return 1
end
```
