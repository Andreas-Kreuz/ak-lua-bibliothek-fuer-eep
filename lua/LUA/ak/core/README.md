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
local modules = ModuleRegistry.registerModules(
    require("ak.core.CoreLuaModule"),
    require("ak.data.DataLuaModule")
)

-- Optional: Set options of CoreLuaModule
modules["ak.core.CoreLuaModule"].setOptions({
    waitForServer = false, -- false: Allow to update the json file without checking if the Web Server is ready
})

-- Optional: Set options of DataLuaModule
modules["ak.data.DataLuaModule"].setOptions({
    activeCollectors = { --register JsonCollectors (default = all)
        --  "ak.data.DataSlotsJsonCollector",
        --  "ak.data.SignalJsonCollector",
        --  "ak.data.SwitchJsonCollector",
        --  "ak.data.StructureJsonCollector",
        --  "ak.data.TimeJsonCollector",
          "ak.data.TrainsAndTracksJsonCollector",
    },
})

-- Optional: Set more options of CoreLuaModule
modules["ak.core.CoreLuaModule"].setOptions({
    activeEntries = { -- Choose entries which get exported to file (default = empty list = all)
        -- Collector: common
        --  "api-entries",

        -- Collector: "ak.data.TimeJsonCollector",
        --  "times",

        -- Collector: "ak.core.VersionJsonCollector",
        --  "eep-version",

        -- Collector: "ak.data.TrainsAndTracksJsonCollector",
        --  "rail-tracks",
          "rail-trains",
          "rail-train-infos-dynamic",
          "rail-rolling-stocks",
          "rail-rolling-stock-infos-dynamic",
        --  "tram-tracks",
        --  "tram-trains",
        --  "tram-train-infos-dynamic",
        --  "tram-rolling-stocks",
        --  "tram-rolling-stock-infos-dynamic",
        --  "road-tracks",
        --  "road-trains",
        --  "road-train-infos-dynamic",
        --  "road-rolling-stocks",
        --  "road-rolling-stock-infos-dynamic",
        --  "auxiliary-tracks",
        --  "control-tracks",
        --  "auxiliary-trains",
        --  "auxiliary-train-infos-dynamic",
        --  "auxiliary-rolling-stocks",
        --  "auxiliary-rolling-stock-infos-dynamic",
        --  "control-trains",
        --  "control-train-infos-dynamic",
        --  "control-rolling-stocks",
        --  "control-rolling-stock-infos-dynamic",
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
    },
})

--clearlog() -- This call after loading EEP Web clears the log file, too

function EEPMain()
    ModuleRegistry.runTasks(1) -- 1: every 200 ms, 5: every second, ...
    return 1
end
```
