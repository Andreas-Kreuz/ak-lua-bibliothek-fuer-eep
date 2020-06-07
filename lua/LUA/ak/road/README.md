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

Diese Klasse wird dazu verwendet eine Signal auf der Anlage (signalId) mit einem Modell zu verknüpfen. Eine so verknüpfte Ampel kann dann einer Fahrspur zugewiesen werden. Die Ampel gilt für eine bestimmte Richtung und damit gegebenenfall für eine oder mehrere Fahrspuren.

### Neue Ampel erzeugen

`function TrafficLight:new(name, signalId, ampelModell)`

_Beschreibung:_

- Legt eine neue Ampel an, welche als Fahrspur-Ampel oder Teil einer Kreuzungsschaltung genutzt werden kann.
- Normalerweise wird jede in der Anlage eingesetzte Ampel mit ihrer `signalId` nur einmal verwendet, da es für jede Ampel normalerweise nur eine Richtung gibt.

_Parameter:_

- `name` ist ein selbst vergebener Name; Vorschlag:
  - K1, K2, K3, ... für Kfz
  - F1, F2, F3, ... für Fußgänger
  - S1, S2, S3, ... für Tram
  - B1, B2, B3, ... für Bus
  - L1, L2, L3, ... für unsichtbare Fahrspursignale
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

### Neue Fahrspur anlegen

`function Lane:new(name, eepSaveId, ...)`

_Beschreibung:_

- Legt eine neue Fahrspur mit den dazu passenden Ampeln an

_Parameter:_

- `name` Name der Fahrspur (z.B. "Fahrspur 1")
- `eepSaveId` Freie EEP-Speicher-ID (1 - 1000)
- `...` List von Ampeln (Typ `TrafficLight`), mindestens eine

_Rückgabewert:_

- Die Ampel (Typ `Lane`)

### Fahrzeuge erkennen

Es gibt drei Möglichkeiten Fahrzeuge zu erkennen:

1. **Fahrzeuge mit Kontaktpunkten zählen (Empfohlen)**

   Das Zählen mit Kontaktpunkten hinterlegt die Anzahl der Fahrzeuge in der Fahrspur und führt dazu, dass Fahrspuren mit mehr Fahrzeugen bevorzugt werden.

   Es werden zwei Kontaktpunkte benötigt:

   1. _Fahrspur betreten_<br> Rufe im Kontaktpunkt die Funktion `lane:vehicleEntered(Zugname)` auf, wenn ein Fahrzeug den Bereich betritt.

   2. _Fahrspur verlassen_<br> Rufe im Kontaktpunkt die Funktion `lane:vehicleLeft(Zugname)` auf, wenn ein Fahrzeug den Bereich verlässt.

      Wenn das Fahrzeug die Fahrspur verläßt, dann kann es die Ampel auf rot setzen, wenn gewünscht.

2. **Fahrzeuge am roten Signal zählen (NICHT EMPFOHLEN)**

   Über diese Funktion wird erkannt, wie viele Fahrzeuge zwischen einem bestimmten Vor- und Hauptsignal auf dem Straßenstück warten.

   - Um die Fahrspur zu priorisieren, wenn sich **ein beliebiges Fahrzeug** auf der Straße vor der Ampel befindet, muss die signalID der Ampel einmalig hinterlegt werden: `lane:useSignalForQueue()`

3. **Fahrzeuge auf der Straße vor dem Signal erkennen (NICHT EMPFOHLEN)**

   Über diese Funktion wird erkannt, ob sich _ein_ Fahrzeuge auf dem Straßenstück befindet.

   - Um die Fahrspur zu priorisieren, wenn sich **ein beliebiges Fahrzeug** auf der Straße vor der Ampel befindet, muss die ID des Straßenstücks einmalig hinterlegt werden: `lane:useTracklForQueue(strassenId)`

## Klasse `CrossingSequence`

Wird dazu verwendet, mehrere Fahrspuren gleichzeitig zu schalten. Es muss sichergestellt werden, dass sich die Fahrwege der Fahrspuren einer Schaltung nicht überlappen.

- `function CrossingSequence:new(name)` - legt eine neue Schaltung an

- `function CrossingSequence:addCarLights(K1)` fügt eine Ampel hinzu, für die mit den Zyklen Rot, Rot-Gelb, Gruen und Gelb geschaltet wird.

- `function CrossingSequence:addTramLights(S1)` fügt eine Ampel hinzu, für die mit den Zyklen Rot, Gruen und Gelb geschaltet wird.

- `function CrossingSequence:addPedestrianLights(F1)` fügt eine Fahrspur hinzu, für die mit den Zyklen Rot, Gruen_Fussgaenger geschaltet wird.

## Klasse `Crossing`

Wird dazu verwendet, die Kreuzung zu verwalten, enthält mehrere Schaltungen.

- `Crossing:new(name)` - legt eine neue Kreuzung an. Diese nutzt automatisch die vorhanden Schaltungen und nutzt diese je nach Prioriät und Wartezeit der Fahrspuren.

- `function Crossing:addSequence(sequenceA)` fügt eine Schaltung zur Kreuzung hinzu.

## Funktion `Crossing:switchSequences()`

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
      ModuleRegistry.runTasks() -- Führt alle anstehenden Aktionen der registrierten Module aus
      return 1
  end```

  ````

- **Fahrspuren mit Anforderungen und Fahrspuren die durch unterschiedliche Ampeln gesteuert werden benötigen zwingend Zählfunktionen** für die Fahrzeuge dieser Fahrspur. Für andere Fahrspuren ist dies optional.

  - `lane:vehicleEntered(Zugname)` - im Kontaktpunkt aufrufen, wenn eine Fahrspur betreten wird (z.B. 50m vor der Ampel; aber nur auf dieser Fahrspursfahrbahn)

  - `lane:vehicleLeft(Zugname)` - im Kontaktpunkt aufrufen, wenn eine Fahrspur verlassen wird (hinter der Ampel)

  In der Zählfunktion MUSS der Zugname benutzt werden, da die Anforderungen und unterschiedlichen Ampeln durch die Routen der Fahrzeuge berechnet werden. Dazu dient folgender Quellcode:

  ```lua
  ------------------------------------------------
  -- Damit kommt wird die Variable "Zugname" automatisch durch EEP belegt
  -- http://emaps-eep.de/lua/code-schnipsel
  ------------------------------------------------
  setmetatable(_ENV, {
      __index = function(_, k)
          local p = load(k)
          if p then
              local f = function(z)
                  local s = Zugname
                  Zugname = z
                  p()
                  Zugname = s
              end
              _ENV[k] = f
              return f
          end
          return nil
      end
  })
  ```

  **Beachte:** Die Zählfunktionen müssen beim Betreten und Verlassen einer Fahrspur verwendet werden.
