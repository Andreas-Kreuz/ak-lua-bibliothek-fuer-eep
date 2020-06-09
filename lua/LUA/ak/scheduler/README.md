---
layout: page_with_toc
title: Plane Aktionen nach Zeitablauf
subtitle: Sichere Planung zukünftiger Aktionen in EEP - so funktioniert die Ampelsteuerung auch in 10-facher Geschwindigkeit.
permalink: lua/ak/scheduler/
feature-img: "/docs/assets/headers/SourceCode.png"
img: "/docs/assets/headers/SourceCode.png"
---

# Motivation

Der Planer erlaubt es Dir **Aktionen** nach einer von Dir festgelegten Zeitspanne in Sekunden auszuführen.

Weiterhin kann der Planer **Folgeaktionen** dann einplanen, wenn eine von Dir festgelegte Zeitspanne nach der vorhergehenden Aktion vergangen ist.

# Funktionen

## Klasse `Task`

Beinhaltet eine Funktion, die später ausgeführt werden soll und einen Namen für diese Aktion der bei der Textausgabe des Planers verwendet wird.

- Funktion `Task:new(f, name)`

  Der erste Parameter `f` ist eine Lua-Funktion, die aufgerufen wird.

  Der zweite Parameter `name` ist ein Text, der für die Ausgabe der Informationen ausgegeben wird.

  Erzeugt eine neue Aktion, die mit der Funktion `Scheduler:scheduleTask(...)` aufgerufen werden kann.

## Klasse `Scheduler`

Nimmt Aktionen für die Planung entgegen und führt diese nach Ablauf einer bestimmten Zeitspanne aus.

- Variable: `Scheduler.debug = false` schaltet Ausgabefunktionen zu eingeplanten Aktionen aus, `Scheduler.debug = true` schaltet sie ein.

- Funktion `Scheduler:scheduleTask(offsetInSeconds, einzuplanendeAktion, vorgaengerAktion)`

  Der erste Parameter `offsetInSeconds` ist eine Wartezeit in Sekunden, bevor die Aktion gestartet wird.

  Der zweite Parameter `newTask` ist ein `Task`, der mit `Task:new(f, name)` erstellt wurde.

  Der dritte Parameter `precedingTask` ist **optional** und ein `Task`, der mit `Task:new(f, name)` erstellt wurde. Wird die Vorgängeraktion angegeben, so wird die einzuplanende Aktionen eingeplant sobald die Vorgängeraktion durchgeführt wurde (nach der angegebenen Zeitspanne).<br>
  Wird die Vorgängeraktion nicht angegeben, so wird die einzuplanende Aktion direkt eingeplant (nach der angegebenen Zeitspanne).

- Funktion `Scheduler:runTasks()`
  Diese Funktion muss regelmäßig aufgerufen werden. Sie prüft die vergangene Zeit und führt alle eingeplanten Aktionen aus, deren Zeitspanne zum aktuellen Zeitpunkt erreicht oder vergangen ist.

  Im Normalfall muss diese Funktion nicht manuell aufgerufen werden. Stattdessen wird dies erledigt durch das einmalige Registrieren des Moduls `SchedulerLuaModule`.

# Wichtig

Damit der Planer funktioniert musst Du ihn registrieren und den runTasks()-Aufruf in die EEPMain()-Methode einbinden:

```lua
local ModuleRegistry = require("ak.core.ModuleRegistry")
ModuleRegistry.registerModules(require("ak.scheduler.SchedulerLuaModule"))

function EEPMain()
    ModuleRegistry.runTasks()
    return 1
end
```
