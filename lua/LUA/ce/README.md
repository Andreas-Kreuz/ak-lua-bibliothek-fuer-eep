---
layout: page_landing
title: Control Extension
subtitle: Hier findest du Informationen zur Control Extension
permalink: lua/ce/
feature-img: "/docs/assets/headers/SourceCode.png"
img: "/docs/assets/headers/SourceCode.png"
---

# Motivation

Die Control Extension für EEP ist eine Erweiterung für EEP.

Sie besteht aus 4 Bestandteilen:

1. **Lua Hub** in `ce.hub` ist die Steuerzentrale und wird mittels `ce.ControlExtension` in EEPMain() genutzt. Er erfüllt verschiedene Aufgaben:
   - Datenerfassung zur aktuellen Anlage aus EEP.
   - Datenhaltung und Datenbereitstellung über einen Datenbus.
   - Allgemeine Steuerung mittels EEP-Funktionen.

2. **Data Bridge** (optional) in `ce.databridge` besteht aus Lua Code und stellt Daten des Datenbus nach außen bereit und nimmt Funktionsaufrufe entgegen.

3. **Control Extension Server** (optional) bereitet die Daten der Data Bridge generisch auf und stellt sie für externe Clients bereit.

4. **Control Extension Web App** (optional) bietet eine Web-Oberfläche für Anzeige und Bedienung.

## Modulerweiterungen `CeModule`

Der Lua Hub selbst ist so aufgebaut, dass er weitere CeModule einbinden kann. Diese CeModule müssen dafür mitbringen:

### Notwendige Felder für Module

- `id` (`string`) - Eindeutige UUID des Modules, die sich nicht ändern darf, z.B. `8aeef2ab-8672-4f9a-a929-d62845f5f1fc`
- `name` (`string`) - Name des Moduls - ist der Name der Datei wie in der require-Methode von Lua beschrieben, z.B. `ce.hub.mods.CoreCeModule`
- `enabled` (`boolean`) - Soll gesetzt werden können, um das Modul zu aktivieren

### Notwendige Methoden für Module

- `init()` - Kein Rückgabewert - Wird beim ersten Lauf von EEPMain() aufgerufen und dann nicht wieder.
- `run()` - Kein Rückgabewert - Wird bei jedem Lauf von EEPMain() aufgerufen.

### Daten mit Modulen an die Data Bridge übergeben

Wenn ein Modul Daten bereitstellen möchte, kann es das über den Datenbus tun. Dazu bietet sich die run()-Methode an, aber auch jeder andere beliebige Zeitpunkt.

Die Konvention, an die sich die integrierten Module des Hubs halten ist folgender Ablauf: \
Die gesammelten Daten werden vom `*StatePublisher` des Moduls mit `*DataCollector` eingesammelt und mittels `*DtoFactory` in Datentransferobjekte (DTOs) umgewandelt. Damit die Summe aller DTOs eindeutig ist, werden alle Daten in Datenabschnitte (`room`) einsortiert und jeder dieser Datenabschnitte enthält eine Liste von Daten, für jeden Typ von DTOs ist klar festgelegt, anhand welches Feldes, die DTOs eindeutig in der Tabelle aufgefunden werden. Dies erlaubt die Ablage in Map-Strukturen `room:string` -> `dtoId:string|number` -> `dto:table`

## Dokumentation

### Für Anwender

- [hub/README.md](hub/README.md) — Öffentliche API: `ControlExtension.addModules`, `runTasks`, `setDebug` u.a.
- [databridge/README.md](databridge/README.md) — Dateibasierte Kommunikation mit dem Web-Server
- [mods/README.md](mods/README.md) — Verfügbare Erweiterungsmodule (Ampel, ÖPNV)
- [template/README.md](template/README.md) — Vorlagen für eigene Anlagen

### Für Entwickler

- [DEVELOP.md](DEVELOP.md) — Eigene CeModule entwickeln und integrieren
- [hub/data/DTO.md](hub/data/DTO.md) — Alle Datenräume und DTO-Typen im Überblick

### Weitere Pakete

- [rail/README.md](rail/README.md) — Zugsteuerung (in Arbeit)
- [modellpacker/README.md](modellpacker/README.md) — EEP-Installer erstellen
- [demo-anlagen/README.md](demo-anlagen/README.md) — Fertige Beispielanlagen
