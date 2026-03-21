---
layout: page_with_toc
title: ControlExtension verwenden
subtitle: Öffentliche API für das Einbinden und Starten der Hub-Module in EEP
permalink: lua/ce/hub/
feature-img: "/docs/assets/headers/SourceCode.png"
img: "/docs/assets/headers/SourceCode.png"
---

# Motivation

`ce.ControlExtension` ist der stabile Einstiegspunkt für EEP-Skripte.

Über diese API bindest Du die benötigten Module ein und führst sie in `EEPMain()` zyklisch aus.
Dabei musst Du die interne Hub-Infrastruktur nicht kennen.

Die öffentliche Beschreibung endet bewusst dort, wo Du Module an `ControlExtension.addModules(...)` übergibst.
Interne Dateien unter `ce.hub` sind Implementierungsdetails und gehören nicht zur öffentlichen API.

# Öffentliche API

## Einstiegspunkt laden

```lua
local ControlExtension = require("ce.ControlExtension")
```

## `ControlExtension.addModules(...)`

Registriert die CeModule, die später ausgeführt werden sollen.

Beispiele für zulässige Module:

- `require("ce.mods.road.RoadCeModule")`
- `require("ce.hub.mods.DataCeModule")`
- `require("ce.hub.mods.SchedulerCeModule")`

Das Modul `ce.hub.mods.CoreCeModule` wird automatisch geladen und muss im Normalfall nicht explizit angegeben werden.

## `ControlExtension.initTasks()`

Initialisiert die registrierten Module einmalig.

Diese Funktion ist optional.
Wenn Du sie nicht selbst aufrufst, geschieht die Initialisierung automatisch beim ersten Aufruf von `ControlExtension.runTasks(...)`.

## `ControlExtension.runTasks(cycleCount)`

Führt die registrierten Module zyklisch aus.

Dieser Aufruf gehört in `EEPMain()`.
Der optionale Parameter `cycleCount` steuert, in welchem Abstand I/O-nahe Veröffentlichungen erfolgen:

- `1`: bei jedem EEP-Zyklus
- `5`: ungefähr einmal pro Sekunde
- `0`: bei jedem Zyklus ohne Intervallprüfung

## `ControlExtension.activateServer()`

Aktiviert die Server-Kommunikation wieder, falls sie zuvor deaktiviert wurde.

## `ControlExtension.deactivateServer()`

Deaktiviert die Server-Kommunikation, ohne die übrigen Modulzyklen abzuschalten.

## `ControlExtension.setDebug(boolean)`

Schaltet Debug-Ausgaben für den Laufzeitablauf ein oder aus.

## `ControlExtension.setPauseEepDuringInitialization(boolean)`

Steuert, ob EEP während der ersten Initialisierung der Module kurz pausiert werden soll.

## Beispiel

```lua
local ControlExtension = require("ce.ControlExtension")

ControlExtension.setDebug(true)
ControlExtension.setPauseEepDuringInitialization(true)

local modules = ControlExtension.addModules(
    require("ce.hub.mods.DataCeModule"),
    require("ce.mods.road.RoadCeModule")
)

modules["ce.hub.mods.DataCeModule"].setOptions({
    activeCollectors = {
        "ce.hub.data.trains.TrainsAndTracksStatePublisher",
    },
})

function EEPMain()
    ControlExtension.runTasks(1)
    return 1
end
```

# Architektur

Das Zielbild aus Anwendersicht ist bewusst einfach:

1. `ce.ControlExtension` ist die öffentliche Fassade.
2. Über `addModules(...)` registrierst Du die gewünschten Module.
3. `EEPMain()` ruft `runTasks(...)` regelmäßig auf.
4. Die registrierten Module führen ihre Initialisierung und ihre zyklischen Aufgaben aus.

Wichtig ist dabei:

- Du arbeitest gegen `ce.ControlExtension`, nicht gegen interne Hub-Dateien.
- Hub-Module dürfen als Argumente an `addModules(...)` genannt werden.
- Die interne Orchestrierung innerhalb von `ce.hub` ist kein Teil der öffentlichen API.

# Unterverzeichnisse

- [data/DTO.md](data/DTO.md) — Alle Datenräume und DTO-Typen der eingebauten Collector
- [eep/README.md](eep/README.md) — EEP-Simulator für Tests ohne EEP
- [scheduler/README.md](scheduler/README.md) — Zeitbasierter Task-Planer
- [util/README.md](util/README.md) — Hilfsfunktionen für persistente Zustandsablage
