---
layout: page_with_toc
title: Eigene Module entwickeln
subtitle: Wie Du ein eigenes CeModule baust und in die Control Extension integrierst
permalink: lua/ce/develop/
feature-img: "/docs/assets/headers/SourceCode.png"
img: "/docs/assets/headers/SourceCode.png"
---

# Eigene Module entwickeln

Die Control Extension ist modular aufgebaut. Du kannst eigene `CeModule` schreiben und über `ControlExtension.addModules(...)` einbinden.

## Was ist ein CeModule?

Ein `CeModule` ist ein Lua-Modul (eine Tabelle), das eine festgelegte Schnittstelle implementiert. Der Hub ruft die Methoden des Moduls automatisch in jedem EEP-Zyklus auf.

## Pflichtfelder

| Feld | Typ | Beschreibung |
| --- | --- | --- |
| `id` | `string` | Eindeutige UUID des Moduls — darf sich nie ändern |
| `name` | `string` | Lua-require-Name des Moduls, z.B. `"ce.mods.road.RoadCeModule"` |
| `enabled` | `boolean` | Kann gesetzt werden um das Modul zu aktivieren oder zu deaktivieren |

## Pflichtmethoden

| Methode | Rückgabe | Beschreibung |
| --- | --- | --- |
| `init()` | — | Wird einmalig beim ersten Lauf von `EEPMain()` aufgerufen |
| `run()` | — | Wird bei jedem Lauf von `EEPMain()` aufgerufen |

## Minimales Beispiel

```lua
-- ce/mods/mymod/MyCeModule.lua
local MyCeModule = {
    id = "a1b2c3d4-0000-0000-0000-000000000001",
    name = "ce.mods.mymod.MyCeModule",
    enabled = true,
}

function MyCeModule.init()
    print("MyCeModule initialisiert")
end

function MyCeModule.run()
    -- Wird bei jedem EEP-Zyklus aufgerufen
end

return MyCeModule
```

Einbinden in EEP:

```lua
local ControlExtension = require("ce.ControlExtension")
ControlExtension.addModules(require("ce.mods.mymod.MyCeModule"))

function EEPMain()
    ControlExtension.runTasks(1)
    return 1
end
```

## Daten auf den Datenbus schreiben

Wenn Dein Modul Daten für die Data Bridge oder die Web App bereitstellen soll, schreibst Du diese über den eingebauten Datenbus.

Die Konvention der eingebauten Module:

1. Ein `*StatePublisher` sammelt mit einem `*DataCollector` die aktuellen Zustände.
2. Eine `*DtoFactory` wandelt die Zustände in Datentransferobjekte (DTOs) um.
3. Die DTOs werden in Datenräume (`room`) einsortiert: `room:string` → `dtoId:string|number` → `dto:table`.

Räume und DTO-Strukturen aller eingebauten Module sind in [hub/data/DTO.md](hub/data/DTO.md) dokumentiert.

## Optionale Methoden

Du kannst weitere Methoden hinzufügen, z.B. für Konfiguration:

```lua
function MyCeModule.setOptions(options)
    -- Konfigurationsoptionen verarbeiten
end
```

`setOptions` wird nicht automatisch vom Hub aufgerufen — Du rufst es selbst auf, bevor Du `ControlExtension.runTasks()` startest:

```lua
local modules = ControlExtension.addModules(require("ce.mods.mymod.MyCeModule"))
modules["ce.mods.mymod.MyCeModule"].setOptions({ debug = true })
```

## Vorlagen

Fertige Vorlagen findest Du in [`ce.template`](template/README.md).
Bestehende Module wie `ce.mods.road.RoadCeModule` können als Referenz dienen — siehe [`ce.mods`](mods/README.md).

## Weiterführende Dokumentation

- [Öffentliche API von ce.ControlExtension](hub/README.md)
- [Datenmodell und DTO-Räume](hub/data/DTO.md)
- [StatePublisher-Muster](hub/StatePublishers.md)
