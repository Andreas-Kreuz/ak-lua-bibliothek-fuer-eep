---
layout: page_with_toc
title: Erweiterungsmodule
subtitle: Domain-spezifische CeModule für Ampelsteuerung, ÖPNV und Zugsteuerung
permalink: lua/ce/mods/
feature-img: "/docs/assets/headers/SourceCode.png"
img: "/docs/assets/headers/SourceCode.png"
---

# Paket `ce.mods` — Erweiterungsmodule

Dieses Verzeichnis enthält domain-spezifische Module, die als `CeModule` in die Control Extension eingebunden werden.
Jedes Modul ist unabhängig und kann einzeln aktiviert werden.

## Module

- [ce.mods.road — Ampelsteuerung](road/README.md)
  Automatische Steuerung von Ampelkreuzungen. Unterstützt verschiedene Ampelmodelle, Fahrspuren und Schaltfolgen.

- [ce.mods.transit — ÖPNV-Linienführung](transit/README.md)
  Verwaltung von Bus- und Straßenbahnlinien, Haltestellen und Abfahrtsplänen.

## Einbinden eines Moduls

```lua
local ControlExtension = require("ce.ControlExtension")

ControlExtension.addModules(
    require("ce.mods.road.RoadCeModule"),
    require("ce.mods.transit.TransitCeModule")
)

function EEPMain()
    ControlExtension.runTasks(1)
    return 1
end
```

Wie Du eigene Module entwickelst, findest Du in [DEVELOP.md](../DEVELOP.md).
