---
layout: page_with_toc
title: Ampeln? Automatisch!
subtitle: Du willst Dich nicht mehr um die Steuerung Deiner Ampeln kümmern? - Dann beschreibe in Lua, wie Deine Kreuzung aussieht und das Skript Crossing übernimmt für Dich den Rest.
permalink: lua/ak/road/
feature-img: "/docs/assets/headers/SourceCode.png"
img: "/docs/assets/headers/SourceCode.png"
---

# Motivation

Willst Du mehr? - Lege Kontaktpunkte für die Verkehrszählung an, damit die Ampel mit dem meisten Andrang bevorzugt geschaltet wird.

Features:

- Automatisches Schalten von Ampeln an Kreuzungen
- Priorisiertes Schalten der Ampeln nach Verkehrsandrang
- Optional, Ampeln nur dann schalten, wenn jemand davor wartet

# Zur Verwendung vorgesehene Klassen und Funktionen

## Klasse `TrafficLightModel`

Beschreibt das Modell einer Ampel mit den Schaltungen für rot, grün, gelb und rot-gelb, sowie dem Fußgängersignal (falls vorhanden - dann hat die Ampel für den Straßenverkehr rot)

### Mitgelieferte Ampelmodelle

- `TrafficLightModel.NP1_3er_mit_FG = TrafficLightModel:new("Ampel_NP1_mit_FG", 2, 4, 5, 3, 1)`
- `TrafficLightModel.NP1_3er_ohne_FG = TrafficLightModel:new("Ampel_NP1_ohne_FG", 1, 3, 4, 2)`
- `TrafficLightModel.JS2_2er_nur_FG = TrafficLightModel:new("Ak_Ampel_2er_nur_FG", 1, 1, 1, 1, 2)`
- `TrafficLightModel.JS2_3er_ohne_FG = TrafficLightModel:new("Ampel_3er_XXX_ohne_FG", 1, 3, 5, 2)`
- `TrafficLightModel.JS2_3er_mit_FG = TrafficLightModel:new("Ampel_3er_XXX_mit_FG", 1, 3, 5, 2, 6)`
- `TrafficLightModel.Unsichtbar_2er = TrafficLightModel:new("Unsichtbares Signal", 2, 1, 2, 2)`

  Siehe auch <https://eepshopping.de/> - Ampel-Baukasten für mehrspurige Straßenkreuzungen (V80NJS20039)

### Ampelmodell anlegen

`function TrafficLightModel:new(name, signalIndexRed, signalIndexGreen, signalIndexYellow, signalIndexRedYellow, signalIndexPedestrian)`

_Beschreibung:_

- Legt eine neues Ampelmodell an, welches in `TrafficLight` verwendet werden kann.

_Parameter:_

- `name` Name des Modells für die Ausgabe im Log
- `signalIndexRed` ist der Index der Signalstellung der Stellung **rot** (erforderlich)
- `signalIndexGreen` ist der Index der Signalstellung der Stellung **grün** (erforderlich)
- `signalIndexYellow` ist der Index der Signalstellung der Stellung **gelb** (optional, wenn nicht vorhanden wird rot verwendet)
- `signalIndexRedYellow` ist der Index der Signalstellung der Stellung **rot-gelb** (optional, wenn nicht vorhanden wird rot verwendet)
- `signalIndexPedestrian` ist der Index der Signalstellung der Stellung **Fußgänger grün** (optional, wenn nicht vorhanden, werden Fußgänger nicht auf grün geschaltet)

_Rückgabewert:_

- Die Ampel (Typ `TrafficLight`)

## Klasse `TrafficLight`

Diese Klasse wird dazu verwendet eine Signal auf der Anlage (signalId) mit einem Modell zu verknüpfen. Eine so verknüpfte Ampel kann dann einer Richtung zugewiesen werden.

### Neue Ampel erzeugen

`function TrafficLight:new(signalId, ampelModell)`

_Beschreibung:_

- Legt eine neue Ampel an, welche einer Richtung hinzugefügt werden kann.
- Normalerweise wird jede in der Anlage eingesetzte Ampel mit ihrer `signalId` nur einmal verwendet, da es für jede Ampel normalerweise nur eine Richtung gibt. Folgende Ausnahmen beschreiben, wann man eine Ampel für mehrere Richtungen benötigt:
  - Soll eine unsichtbare Ampel für mehrere Richtungen an unterschiedliche Immobilien gekoppelt werden, dann ist es notwendig diese Ampel für jede Richtung einzeln anzulegen, da sonst die Umschaltung der Ampel die falschen Immobilien schalten würde.

_Parameter:_

- `signalId` ist die Signal-ID der zu steuernden Ampel in EEP
- `ampelModell` muss vom Typ `TrafficLightModel` sein

_Rückgabewert:_

- Die Ampel (Typ `TrafficLight`)

### Lichtsteuerung von Immobilien

`function TrafficLight:addLightStructure(redStructure, greenStructure, yellowStructure, requestStructure)`

_Beschreibung:_

- Fügt bis zu vier Immobilien hinzu, deren Licht ein oder ausgeschaltet wird, sobald die Ampel auf rot, gelb oder grün geschaltet wird bzw. wenn sich die Anforderung an der Ampel ändert.

_Parameter:_

- `redStructure` Name der Immobilie, deren Licht eingeschaltet wird, wenn die Ampel rot oder rot-gelb ist
- `greenStructure` Name der Immobilie, deren Licht eingeschaltet wird, wenn die Ampel grün ist
- `yellowStructure` Name der Immobilie, deren Licht eingeschaltet wird, wenn die Ampel gelb oder rot-gelb ist
- `requestStructure` Name der Immobilie, deren Licht eingeschaltet wird, wenn die Ampel eine Anforderung erkennt

_Rückgabewert:_

- Die Ampel (Typ `TrafficLight`)

Passende Modelle für die Steuerung der Immobilien mit Licht findest Du im Modellset V10MA1F011. Download unter <http://eep.euma.de/download/> - Im Modell befindet sich eine ausführliche Doku.

### Achssteuerung einer Immobilie

`function TrafficLight:addAxisStructure(structureName, axisName, positionDefault, positionRed, positionGreen, positionRed, positionPedestrian)`

_Beschreibung:_

- Ändert die Achsstellung der angegebenen Immobilien beim Schalten der Ampel auf rot, gelb, grün oder Fußgänger

_Parameter:_

- `structureName` Name der Immobilie, deren Achse gesteuert werden soll
- `axisName` Name der Achse in der Immobilie, die gesteuert werden soll
- `positionDefault` Grundstellung der Achse (wird eingestellt, wenn eine Stellung nicht angegeben wurde
- `positionRed` Achsstellung bei rot
- `positionGreen` Achsstellung bei grün
- `positionRed` Achsstellung bei gelb
- `positionPedestrian` Achsstellung bei FG

_Rückgabewert:_

- Die Ampel (Typ `TrafficLight`)

## Klasse `Lane`

Wird dazu verwendet mehrere Ampeln gleichzeitig zu schalten. Die kann für eine oder mehrere Fahrspuren geschehen.

### Neue Richtung anlegen

`function Lane:new(name, eepSaveId, ...)`

_Beschreibung:_

- Legt eine neue Richtung mit den dazu passenden Ampeln an

_Parameter:_

- `name` Name der Richtung (z.B. "Richtung 1")
- `eepSaveId` Freie EEP-Speicher-ID (1 - 1000)
- `...` List von Ampeln (Typ `TrafficLight`), mindestens eine

_Rückgabewert:_

- Die Ampel (Typ `Lane`)

### Fahrzeuge erkennen

Es gibt drei Möglichkeiten Fahrzeuge zu erkennen:

1. **Fahrzeuge am roten Signal zählen**

   Über diese Funktion wird erkannt, wie viele Fahrzeuge zwischen einem bestimmten Vor- und Hauptsignal auf dem Straßenstück warten.

   - Um die Richtung zu priorisieren, wenn sich **ein beliebiges Fahrzeug** auf der Straße vor der Ampel befindet, muss die signalID der Ampel einmalig hinterlegt werden: `lane:useSignalForQueue()`

   - Um die Richtung nur dann zu Priorisieren, wenn ein bestimmtes Fahrzeug an der Ampel wartet, kann stattdessen die Funktion mit Route verwendet werden: `lane:zaehleAnAmpelBeiRoute(route)`<br>
     Diese Funktion prüft, ob das erste Fahrzeug an der Ampel die passende Route hat.

2. **Fahrzeuge auf der Straße vor dem Signal erkennen**

   Über diese Funktion wird erkannt, ob sich _ein_ Fahrzeuge auf dem Straßenstück befindet.

   - Um die Richtung zu priorisieren, wenn sich **ein beliebiges Fahrzeug** auf der Straße vor der Ampel befindet, muss die ID des Straßenstücks einmalig hinterlegt werden: `lane:useTracklForQueue(strassenId)``

   - Um die Richtung nur dann zu Priorisieren, wenn sich ein bestimmtes Fahrzeug auf der Straße vor der Ampel befindet, kann stattdessen die Funktion mit Route verwendet werden: `lane:zaehleAnStrasseBeiRoute(strassenId, route)`

3. **Fahrzeuge mit Kontaktpunkten zählen**

   Das Zählen mit Kontaktpunkten hinterlegt die Anzahl der Fahrzeuge in der Richtung und führt dazu, dass Richtungen mit mehr Fahrzeugen bevorzugt werden.

   Es werden zwei Kontaktpunkte benötigt:

   1. _Richtung betreten_<br> Rufe im Kontaktpunkt die Funktion `lane:vehicleEntered(Zugname)` auf, wenn ein Fahrzeug den Bereich betritt.

   2. _Richtung verlassen_<br> Rufe im Kontaktpunkt die Funktion `lane:vehicleLeft(Zugname)` auf, wenn ein Fahrzeug den Bereich verlässt.

      Wenn das Fahrzeug die Richtung verläßt, dann kann es die Ampel auf rot setzen, wenn gewünscht.

## Klasse `CrossingCircuit`

Wird dazu verwendet, mehrere Richtungen gleichzeitig zu schalten. Es muss sichergestellt werden, dass sich die Fahrwege der Richtungen einer Schaltung nicht überlappen.

- `function CrossingCircuit:new(name)` - legt eine neue Schaltung an

- `function CrossingCircuit:addLane(richtung)` fügt eine Richtung hinzu, für die mit den Zyklen Rot, Rot-Gelb, Gruen und Gelb geschaltet wird.

- `function CrossingCircuit:addPedestrianCrossing(richtung)` fügt eine Richtung hinzu, für die mit den Zyklen Rot, Gruen_Fussgaenger geschaltet wird.

- `function CrossingCircuit:fuegeRichtungMitAnforderungHinzu(richtung)` fügt eine Richtung hinzu, für die mit den Zyklen Rot, Rot-Gelb, Gruen und Gelb geschaltet wird.

**Beachte:** Eine solche Richtung wird nur dann auf Grün geschaltet, wenn eine Anforderung vorliegt. Sie schaltet sofort wieder auf Rot, wenn keine weitere Anforderung vorliegt.

## Klasse `Crossing`

Wird dazu verwendet, die Kreuzung zu verwalten, enthält mehrere Schaltungen.

- `Crossing:new(name)` - legt eine neue Kreuzung an. Diese wird automatisch anhand ihrer Richtungen geschaltet.

- `function Crossing:fuegeSchaltungHinzu(schaltung)` fügt eine Schaltung zur Kreuzung hinzu.

## Funktion `Crossing:planeSchaltungenEin()`

Muss in `EEPMain()` aufgerufen werden - plant die Umschaltung von Kreuzungsschaltungen.

# Wichtige Hinweise

- **Damit das Ganze funktioniert**, muss `EEPMain()` mindestens folgende Befehle verwenden:

  ````lua
  local ModuleRegistry = require("ak.core.ModuleRegistry")
  ModuleRegistry.registerModules(
      require("ak.core.CoreLuaModule"),
      require("ak.road.CrossingLuaModul") -- Registriert das Kreuzungsmodul
  )

  function EEPMain()
      ModuleRegistry.runTasks()               -- Führt alle anstehenden Aktionen der registrierten Module aus
      return 1
  end```

  ````

- **Richtungen mit Anforderungen benötigen zwingend Zählfunktionen** für die Fahrzeuge dieser Richtung. Für andere Richtungen ist dies optional.

  - `richtung:vehicleEntered(Zugname)` - im Kontaktpunkt aufrufen, wenn eine Richtung betreten wird (z.B. 50m vor der Ampel; aber nur auf dieser Richtungsfahrbahn)

  - `richtung:vehicleLeft(Zugname)` - im Kontaktpunkt aufrufen, wenn eine Richtung verlassen wird (hinter der Ampel)

    **Beachte:** Die Zählfunktionen müssen beim Betreten und Verlassen einer Richtung verwendet werden.
