---
layout: page_with_toc
title: Der Kern der App
subtitle: Dieser Teil enthält das Standardmodul und die 
permalink: lua/ak/eep/
feature-img: "/docs/assets/headers/SourceCode.png"
img: "/docs/assets/headers/SourceCode.png"
---

# Paket ak.core

* Dieses Paket enthält das Skript für das Einplanen der Aufgaben für die App.

Das Skript `ModuleRegistry` wird genutzt um die Module zu registrieren.
Die Einbindung von `ModuleRegistry.runTasks()` in `EEPMain()` sorgt dafür, dass die Tasks der Module ausgeführt werden.

## Verwendung

```lua
local ModuleRegistry = require("ak.core.ModuleRegistry")
ModuleRegistry.registerModules(
    require("ak.core.CoreLuaModule"),
    require("ak.strasse.KreuzungLuaModul")
)

function EEPMain()
    ModuleRegistry.runTasks()
    return 1
end
```
