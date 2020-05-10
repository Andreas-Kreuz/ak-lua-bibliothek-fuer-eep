---
layout: page_with_toc
title: Simuliere den Simulator!
subtitle: Mit diesem Skript kannst Du Deine Skripte ohne EEP testen.<br>Binde diese Skripte in ein Testskript ein und prüfe Deine Schaltungen.
permalink: lua/ak/core/eep/
feature-img: "/docs/assets/headers/SourceCode.png"
img: "/docs/assets/headers/SourceCode.png"
---

# Paket ak.core.eep

* Bietet die Funktionen von EEP 16 für Deine Tests.

Das Skript `AkEepFunktionen` stellt alle dokumentierten Funktionen von EEP zur Verfügung und ist für die Verwendung in Test-Klassen vorgesehen.

## Verwendung

* Ein Testskript lädt zuerst die Funktionen von EEP:<br>
  `require 'ak.core.eep.AkEepFunktionen'`

* Danach wird das eigentliche Skript geladen:<br>
  `require 'anlagen-script'`

Ein ausführlicheres Tutorial zu dem Thema findest Du hier: **[Demo-Anlage-Testen](../../../_anleitungen-fortgeschrittene/demo-anlage-testen.md)**

## Beispiel

Prüfe, ob ein Signal gesetzt wurde:

```lua
require("ak.core.eep.AkEepFunktionen")

EEPSetSignal(32, 2)
assert (2 == EEPGetSignal(32))
```
