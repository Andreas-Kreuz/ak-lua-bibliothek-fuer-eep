---
layout: page_with_toc
title: Lua in Kreuzungen
type: Tipps & Tricks
subtitle: ... in meiner Kreuzung dies oder jenes erreichen.
img: "/assets/thumbnails/ampel-aufstellen.jpg"
date: 2017-09-04
permalink: anleitungen-fortgeschrittene/tipps-kreuzungen
tags: [Verwendung, Anleitung]
---

# Allgemeines

## Ich bekomme Fehler

Lies den Fehler genau. Meist hast Du Dich vertippt.

Häufige Fehler können sein:

- Schau genau hin, ob die Funktion einen Doppelpunkt (`:`) statt eines Punktes (`.`) verwendet.
  Dann muss auch der Funktionsaufruf mit dem Doppelpunkt erfolgen, z.B. `TrafficLight:new(...)` statt `TrafficLight.new()`

- Du hast Dich bei den Parameter zwischen Klammern einer Funktion verzählt.

# Ampeln

## Ampel mit Achssteuerung nutzen

Du willst eine Immobilie mit Achsen als Ampel verwenden?

Weise diese Immobilien aus EEP mit der Funktion `:addAxisStructure(...)` einer bestehenden Ampel (`TrafficLight`) zu. (Es müssen mindesten rot und grün angegeben werden, ist ein Wert für gelb, rot-gelb oder Fußgänger nicht angegeben, dann wird die Standard-Position der Achse verwendet.)

- Langform (mit Kommentaren): Du schreibst die Kommentare hinter die Parameter im Funktionsaufruf. So kannst Du gleich sehen, welcher Wert was bedeutet.

  ```lua
  -- Füge die Achsenampel zu einer Ampel hinzu: LANGFORM INKLUSIVE KOMMENTARE!
  K1:addAxisStructure("#0141_Immo", -- structureName:     Name der Immobilie in EEP
                      "Achsenname", -- axisName:          Welche Achse soll verändert werden
                      0,            -- positionDefault:   Standardposition der Achse
                      20,           -- positionRed:       Position der Achse für Rot
                      40,           -- positionGreen:     Position der Achse für Grün
                      80,           -- positionYellow:    Position der Achse für Gelb
                      90,           -- positionRedYellow: Position der Achse für Rot-Gelb
                      100)          -- positionPedestrian:Position der Achse für Fußgänger
  ```

- Kurzform (ohne Kommentare): Die Schreibweise ist viel kürzer, aber Du musst wissen, wofür jede Zahl steht.

  ```lua
  -- Füge die Achsenampel zu einer Ampel hinzu: KURZFORM OHNE KOMMENTARE!
  K1:addAxisStructure("#0141_Immo", "Achsenname", 0, 20 ,40, 80, 90, 100)
  ```

Um Deine Achsenampel zu verwenden, kannst Du sie einem der folgenden Signale zuweisen:

1. **Du willst die Ampel zusätzlich zu einer bestehenden sichtbaren Fahrspur-Ampel benutzen** - sie teilt sich dann die Ampelphasen rot, gelb und grün mit dieser Fahrspur-Ampel und wird gemeinsam mit dieser geschaltet.

   ```lua
   -- Schritt 1) Lege die Fahrspur-Ampel an, z.B. eine 3er Ampel mit Fußgängerschaltung:
   local K1 = TrafficLight:new("K1", 12, TrafficLightModel.JS2_3er_mit_FG)

   -- Schritt 2) Füge die Achsenampel hinzu: KURZFORM OHNE KOMMENTARE!
   K1:addAxisStructure("#0141_Immo", "Achsenname", 0, 20 ,40, 80, 90, 100)
   ```

2. **Du willst die Ampel an eine bestehende unsichtbare Fahrspur-Ampel koppeln** - sie teilt sich dann die Ampelphasen rot, gelb und grün mit dieser Fahrspur-Ampel und wird gemeinsam mit dieser geschaltet. Es sieht jedoch so aus, als ob die Immobilien-Ampel die Fahrspur steuert.

   ```lua
   -- Schritt 1) Lege eine Dummy-Ampel an:
   local L1 = TrafficLight:new("L1", 12, TrafficLightModel.Unsichtbar_2er)

   -- Schritt 2) Füge die Achsenampel hinzu: KURZFORM OHNE KOMMENTARE!
   L1:addAxisStructure("#0141_Immo", "Achsenname", 0, 20 ,40, 80, 90, 100)
   ```

3. **Du willst die Ampel nicht an ein Signal auf der Anlage zu koppeln.**
   Dazu legen wir nur in Lua eine Dummy-Ampel an. Die Dummy-Ampel bekommt eine -1 als signalID und wird wie eine normale Ampel in Schaltungen verwendet.

   ```lua
   -- Schritt 1) Lege eine Dummy-Ampel an:
   local Dummy1 = TrafficLight:new("Dummy1", -1, TrafficLightModel.Unsichtbar_2er)

   -- Schritt 2) Füge die Achsenampel hinzu: KURZFORM OHNE KOMMENTARE!
   Dummy1:addAxisStructure("#0141_Immo", "Achsenname", 0, 20 ,40, 80, 90, 100)
   ```

## Ampel mit Lichtsteuerung von Immobilien nutzen

![]({{ site.baseurl }}/assets/tutorial/tutorial2/immo-ampel.jpg)

Du willst einzelne Lichter einer Immobilie als Ampel verwenden?

Weise diese Immobilien aus EEP mit der Funktion `:addLightStructure(...)` einer bestehenden Ampel (`TrafficLight`) zu. (Es müssen mindesten rot und grün angegeben werden)

- **Langform einer Immobilienampel (mit Kommentaren)**: Du schreibst die Kommentare hinter die Parameter im Funktionsaufruf. So kannst Du gleich sehen, welcher Wert was bedeutet.

  ```lua
  K1:addLightStructure("#29_Straba Signal Halt", --       rot  schaltet das Licht dieser Immobilie ein
                      "#28_Straba Signal geradeaus", --  gruen schaltet das Licht dieser Immobilie ein
                      "#27_Straba Signal anhalten", --   gelb  schaltet das Licht dieser Immobilie ein
                      "#26_Straba Signal A") --    Anforderung schaltet das Licht dieser Immobilie ein
  ```

- **Kurzform (ohne Kommentare)**: Die Schreibweise ist viel kürzer, aber Du musst wissen, wofür jeder Parameter steht.

  ```lua
  K1:addLightStructure("#29_Straba Signal Halt", "#28_Straba Signal geradeaus",
                          "#27_Straba Signal anhalten", "#26_Straba Signal A")
  ```

Um Deine Achsenampel zu verwenden, kannst Du sie einem der folgenden Signale zuweisen:

1. **Du willst die Ampel zusätzlich zu einer bestehenden sichtbaren Fahrspur-Ampel benutzen** - sie teilt sich dann die Ampelphasen rot, gelb und grün mit dieser Fahrspur-Ampel und wird gemeinsam mit dieser geschaltet.

   ```lua
   -- Schritt 1) Lege die Fahrspur-Ampel an, z.B. eine 3er Ampel mit Fußgängerschaltung:
   local K1 = TrafficLight:new("K1", 12, TrafficLightModel.JS2_3er_mit_FG)

   -- Schritt 2) Füge die Achsenampel hinzu: KURZFORM OHNE KOMMENTARE!
   K1:addLightStructure("#29_Straba Signal Halt", "#28_Straba Signal geradeaus",
                            "#27_Straba Signal anhalten", "#26_Straba Signal A")
   ```

2. **Du willst die Ampel an eine bestehende sichtbare Fahrspur-Ampel koppeln** - sie teilt sich dann die Ampelphasen rot, gelb und grün mit dieser Fahrspur-Ampel und wird gemeinsam mit dieser geschaltet.

   ```lua
   -- Schritt 1) Lege eine Dummy-Ampel an:
   local L1 = TrafficLight:new("L1", 12, TrafficLightModel.Unsichtbar_2er)

   -- Schritt 2) Füge die Achsenampel hinzu: KURZFORM OHNE KOMMENTARE!
   L1:addLightStructure("#29_Straba Signal Halt", "#28_Straba Signal geradeaus",
                            "#27_Straba Signal anhalten", "#26_Straba Signal A")
   ```

3. **Du willst die Ampel nicht an ein Signal auf der Anlage zu koppeln.**
   Dazu legen wir nur in Lua eine Dummy-Ampel an. Die Dummy-Ampel bekommt eine -1 als signalID und wird wie eine normale Ampel in Schaltungen verwendet.

   ```lua
   -- Schritt 1) Lege eine Dummy-Ampel an:
   local Dummy1 = TrafficLight:new("Dummy1", -1, TrafficLightModel.Unsichtbar_2er)

   -- Schritt 2) Füge die Achsenampel hinzu: KURZFORM OHNE KOMMENTARE!
   Dummy1:addLightStructure("#29_Straba Signal Halt", "#28_Straba Signal geradeaus",
                            "#27_Straba Signal anhalten", "#26_Straba Signal A")
   ```

Siehe auch _[Tutorial Immobilien-Ampel](tutorial2-immobilien-ampel)_

## Mehrere Ampeln in einer Fahrspur nutzen

Es muss immer genau eine Fahrspur-Ampel geben, an der die Autos warten.

### ... alle Ampeln für die Fahrspur werden gleich geschaltet

Du möchtest mehrere Ampeln für eine Fahrspur nutzen und diese immer gleichzeitig schalten?

Lösung: Lege weitere Ampeln an und verwende sie gemeinsam mit der Fahrspur-Ampel in der selben Schaltung.

```lua
-- Schritt 1) Lege Deine Ampeln an.
--            Beispiel 3 Ampeln: Rechts (K1), mittig (K2) und links (K3) gelten für die selbe Fahrspur
local K1 = TrafficLight:new("K1", 92, TrafficLightModel.JS2_3er_mit_FG)
local K2 = TrafficLight:new("K2", 91, TrafficLightModel.JS2_3er_ohne_FG)
local K3 = TrafficLight:new("K3", 26, TrafficLightModel.JS2_3er_mit_FG)

-- K1 wird als Fahrspur-Ampel verwendet
c1Lane1 = Lane:new("K1 - Fahrspur 1", 110, K1, {Lane.Directions.STRAIGHT})

-- In der Schaltung werden K1, K2 und K3 gleichzeitig angegeben
c1 = Crossing:new("Bahnhofstr. - Hauptstr.")  -- Kreuzung anlegen
c1Switching1 = c1:newSequence("S1")           -- Schaltung anlegen
c1Switching1:addCarLights(K1, K2, K3)         -- Alle 3 Ampeln zur Schaltung hinzufügen
```

### ... es gibt unterschiedlich geschaltete Ampeln für die Fahrspur

Im folgenden Beispiel gibt es eine "normale" Ampel (K4) und einen Rechtsabbieger-Pfeil (K5).

![]({{ site.baseurl }}/assets/web/rechtsabbieger.jpg)

Für das Einrichten dieser Fahrspur müssen folgende Dinge beachtet werden:

1. Die Fahrzeuge müssen über Kontaktpunkte gezählt werden (siehe [Priorisierung von Fahrzeugen](tutorial3-priorisierung)).
   Dadurch wird sichergestellt, dass die einzelnen Fahrzeuge an der Fahrspur-Ampel bekannt sind.
2. Das Fahrspur-Signal muss unsichtbar sein, so dass die Schaltvorgänge für das erste Fahrzeug nicht sichtbar sind.
3. Die beiden Ampeln K4 und K5 müssen einzeln angelegt werden.
4. Die Fahrzeuge müssen unterschiedliche Routen verwenden. Im Beispiel gilt Folgendes:
   - Die Ampel K4 gilt für alle Routen: `K4:applyToLane(lane4)`
   - Die Ampel K5 gilt nur für bestimmte Routen: `K5:applyToLane(lane4, "Rechtsabbieger")`
5. Die Ampeln K4 und K5 können in unterschiedlichen Schaltungen verwendet werden
   - Ist K4 grün, dann fahren alle Fahrzeuge
   - Ist K5 grün, dann fährt das erste Fahrzeug in der Fahrspur nur dann, wenn es die Route "Rechtsabbieger" hat.

```lua
-- Es gibt eine unsichtbare Fahrspur-Ampel für Fahrspur 4
local lane4Sig = TrafficLight:new("lane4Sig", 89, TrafficLightModel.Unsichtbar_2er)

-- Anlegen von Ampel K4 (Normal mit Fußgängern) gerade und rechts
local K4 = TrafficLight:new("K4", 142, TrafficLightModel.JS2_3er_mit_FG)
-- Anlegen von Ampel K5 (Rechtsabbiegerpfeil) nur rechts
local K5 = TrafficLight:new("K5", 140, TrafficLightModel.JS2_2er_OFF_YELLOW_GREEN)

-- Fahrspur 4 führt geradeaus und rechts entlang.
lane4 = Lane:new("K1 - Fahrspur 4", 4, lane4Sig, {Lane.Directions.STRAIGHT, Lane.Directions.RIGHT})

-- Die Ampeln K4 gilt für geradeaus und rechts, die Ampel K5 gilt nur für "Rechtsabbieger"
K4:applyToLane(lane4)                         -- K4 gilt für Fahrspur 4 (alle)
K5:applyToLane(lane4, "Rechtsabbieger")       -- K4 gilt für Fahrspur 4 (nur Route "Rechtsabbieger")

-- Kreuzung mit zwei Schaltungen anlegen und die Ampeln K4 und K5 verwenden
c1 = Crossing:new("Bahnhofstr. - Hauptstr.")  -- Kreuzung anlegen
-- ...                                        -- Weitere Ampeln
c1Switching2 = c1:newSequence("S2")           -- Schaltung 2 anlegen
c1Switching2:addCarLights(K5)                 -- Ampel K5 als Auto-Ampel hinzufügen
c1Switching3 = c1:newSequence("S3")           -- Schaltung 3 anlegen
c1Switching3:addCarLights(K4)                 -- Ampel K4 als Auto-Ampel hinzufügen
```

## Tram und Bus

### Tram-Ampeln verwenden

1. Konfiguriere die Straßenbahn-Ampeln (im Beispiel als Immobilien-Signal)

   ```lua
   local S1 = TrafficLight:new("S1", 96, TrafficLightModel.Unsichtbar_2er,
                               "#5528_Straba Signal Halt",     -- Immobilie Halt
                              "#5531_Straba Signal geradeaus", -- Immobilie Fahrt
                               "#5529_Straba Signal anhalten", -- Immobilie Gelb
                               "#5530_Straba Signal A")        -- Immobilie Anforderung
   local S2 = TrafficLight:new("S2", -1, TrafficLightModel.NONE,
                               "#5435_Straba Signal Halt", "#5521_Straba Signal geradeaus",
                               "#5520_Straba Signal anhalten", "#5518_Straba Signal A")
   local S3 = TrafficLight:new("S3", -1, TrafficLightModel.NONE,
                               "#5523_Straba Signal Halt", "#5434_Straba Signal links",
                               "#5522_Straba Signal anhalten", "#5433_Straba Signal A")
   local S4 = TrafficLight:new("S4", 95, TrafficLightModel.Unsichtbar_2er,
                               "#5525_Straba Signal Halt",  "#5436_Straba Signal rechts",
                               "#5526_Straba Signal anhalten", "#5524_Straba Signal A")
   ```

2. Zeige die Anforderungen der einzelnen Fahrspuren an den Tram-Ampeln an

   a. Sag der Fahrspur, an welchem Signal die Anforderungen angezeigt werden sollen `lane:showRequestsOn(trafficLight)`.

   b. Wenn mehrere Tram-Ampeln je nach Route einer Fahrspur die Ampeln schalten sollen, 
      dann gib dahinter die Route an `lane:showRequestsOn(trafficLight, "Name der Route")`

   ```lua
   -- Zeige Anforderung an Ampel S1 bei jedem Fahrzeug in Fahrspur 1
   c1Lane3:showRequestsOn(S1)

   -- Zeige Anforderungen an Ampel S2 / S3 je nach Route in Fahrspur 8
   c1Lane8:showRequestsOn(S2, "Strabalinie 10")
   c1Lane8:showRequestsOn(S3, "Strabalinie 04")

   -- Zeige Anforderung an Ampel S4 bei jedem Fahrzeug in Fahrspur 11
   c1Lane11:showRequestsOn(S4)
   ```

# Fahrspuren

## Jede Fahrspur hat genau eine Fahrspur-Ampel

Die Fahrspur-Ampel wird genutzt, um die Fahrzeuge der Fahrspur zu steuern. Es gibt folgende Möglichkeiten, das Fahrspur-Signal zu benutzen.

1. Sollen sich alle Fahrzeuge gleichzeitig fahren, dann kann die Fahrspur-Ampel direkt in Schaltungen verwendet werden.

2. Sollen die Fahrzeuge einer Fahrspur durch unterschiedliche Ampeln je nach Route gesteuert werden, dann darf das Fahrspur-Signal nicht in Schaltungen verwendet werden.

Siehe oben: _Mehrere Ampeln in einer Fahrspur verwenden_.
