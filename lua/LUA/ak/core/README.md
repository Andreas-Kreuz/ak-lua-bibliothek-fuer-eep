---
layout: page_with_toc
title: Der Kern der App
subtitle: Dieser Teil enthält das Standardmodul
permalink: lua/ak/core/
feature-img: "/docs/assets/headers/SourceCode.png"
img: "/docs/assets/headers/SourceCode.png"
---

# Paket ak.core

- Dieses Paket enthält das Skript für das Einbinden und Starten der anderen Module.

Das Skript `ModuleRegistry` wird genutzt um die Module zu registrieren.
Die Einbindung von `ModuleRegistry.runTasks()` in `EEPMain()` sorgt dafür, dass die Tasks der Module ausgeführt werden.

## Verwendung

Hier ein minimales Beispiel (bei dem die Kreuzungssteuerung genutzt wird):

```lua
local ModuleRegistry = require("ak.core.ModuleRegistry")
ModuleRegistry.registerModules(
    -- require("ak.core.CoreLuaModule"), -- loaded automatically
    require("ak.road.CrossingLuaModul")
)

function EEPMain()
    ModuleRegistry.runTasks()
    return 1
end
```

## Verwendung von DataLuaModule / erweitertes Beispiel

Das Modul `DataLuaModule` kann, wie im vorigen Abschnitt beschrieben, aufgerufen werden.

Es bietet zusätzliche Optionen an, mit der die Auswahl den Daten-Kollektoren eingestellt werden kann.

Mit der Option `activeCollectors` wird dazu eine Liste der aktiven Kollektoren übergeben. Wenn die Option nicht gesetzt  oder eine leere Liste übergeben wird, werden alle Daten gesammelt und exportiert. Im Beispiel unten werden alle verfügbaren Kollektoren angegeben, wobei einige auskommentiert sind.

Mit der Option `setWaitForServer` von Modul `ak.core.CoreLuaModule` kann festgelegt werden, ob die Dateien immer aktualiert werden sollen oder ob dies nur geschehen soll wenn der EEP-Webserver aktiv und empfangsbereit ist (default).

Die Funktion `runTasks(cycles)` besitzt einen zusätzlichen Parameter mit der angegeben werden kann nach wievielen Zyklen die Dateien aktualisiert werden sollen.

Die Standardfunktion `clearlog()` wird von dem Modul überladen. Damit wird dann nicht nur das Protokoll in EEP gelöscht sondern auch der Inhalt der exportierten Log-Datei.

```lua
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

--clearlog() -- This call after loading EEP Web clears the log file, too

function EEPMain()
    ModuleRegistry.runTasks(1) -- 1: every 200 ms, 5: every second, ...
    return 1
end
```

## JSON Export beschleunigen

Optional kann für den JSON-Export eine für Windows gebaute Bibliothek (DLL) genutzt werden. Dafür wurde die Bibliothek
[lua-cjson2](https://luarocks.org/modules/criztianix/lua-cjson2) genutzt.
Der Export der JSON-Dateien wird dadurch stark beschleunigt.

```lua
-- ACHTUNG: DIE VERWENDUNG ERFOLGT AUF EIGENE GEFAHR. ES IST GUT MÖGLICH,
--          DASS EEP ABSTÜRZT, WENN NICHT ALLE ABHÄNGIGKEITEN DER BIBLIOTHEK
--          GEFUNDEN WERDEN.
ModuleRegistry.useDlls(true)
```

**ACHTUNG**: DIE VERWENDUNG ERFOLGT AUF EIGENE GEFAHR. ES IST GUT MÖGLICH, DASS EEP ABSTÜRZT,
WENN NICHT ALLE ABHÄNGIGKEITEN GEFUNDEN WERDEN.
