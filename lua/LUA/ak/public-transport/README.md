---
layout: page_with_toc
title: Linien für den Nahverkehr
subtitle: Die Dateien in diesem Verzeichnis dienenen dazu Linien und Haltestellen zu verwalten
permalink: lua/ak/public-transport
feature-img: "/docs/assets/headers/SourceCode.png"
img: "/docs/assets/headers/SourceCode.png"
---

## Paket `ak.public-transport`

Dieses Paket ermöglicht die Steuerung von ÖPNV-Linien in der EEP-Anlage.

⚠ **EEPRollingstockSetTagText in den Fahrzeugen wird verwendet, wenn Du die Lua-Funktionen in den Kontaktpunkten nutzt**.

## Begriffe

- **Linie** (`Line`): enthält eine Liste von Haltestellen.  
  Alle Haltestellen der Linie werden von einem Fahrzeug nacheinander angesteuert.  
  Die Linie ist geschlossen, d.h. nach der letzten Haltestelle kommt die erste Haltestelle.
- **Linienabschnitt** (`LineSection`):
  ist eine Teilstrecke auf der Linie, für das ein bestimmtes Ziel angegeben werden kann.  
  Eine **Ringlinie** fährt und immer das selbe Ziel hat (z.B. "Innerer Ring") kann mit einem einzigen
  Linienabschnitt betrieben werden.  
  Wenn **Hin- und Rückweg** jeweils ein anderes Ziel haben (z.B. "Hauptbahnhof" <-> "Flughafen"), dann kann
  die Linie mit zwei Linienabschnitten betrieben werden.
- **Haltestelle** (`RoadStation`):
  kann von den Fahrzeugen verschiedener Linien angefahren werden.
- **Steig** (`Platform`):
  Eine Haltestelle kann einen oder mehrere Bus-, Bahn- bzw. Tram-Steige haben, an denen die Fahrzeuge verschiedener
  Linien halten.
  Jeder Steig kann dann eine oder mehrere Anzeigetafeln und Haltestellenschilder haben.

## Anleitung für Haltestellen

### Einmaliger Import für Haltestellen

```lua
local RoadStation = require("ak.public-transport.RoadStation")
local RoadStationDisplayModel = require("ak.public-transport.RoadStationDisplayModel")
```

### Einrichten der Haltestellen in der Anlage

- Neue Haltestelle anlegen:  
  `RoadStation:new(name, speicherSlot)`
  - `name`: Name der Haltestelle
  - `speicherSlot`: Freier Speicherslot in EEP - hier könnten optional die Einstellungen gespeichert werden  
    Wird der Speicherslot nicht benötigt, kann `-1` verwendet werden.
- Ein Haltestellentafel oder Abfahrtstafel zur Haltestelle hinzufügen:  
  `RoadStation:addDisplay(eepImmoId, displayModel, platformId)`
  fügt der Haltestelle ein Display für eine bestimmte Plattform hinzu (Bussteig, Tramsteig, Bahnsteig)
  - `eepImmoId`: ID der Immobilie in EEP, z.B. `#223` oder `#223_Bus-Haltestelle modern` - unterstützt das Modell der Immobilie die Anzeige von Linien, Bahnsteig oder Abfahrten, dann werden diese automatisch angezeigt.
  - `displayModel`: Ein RoadStationDisplayModel, z.B.
    - `RoadStationDisplayModel.SimpleStructure`
      dieses Modell unterstützt die Anzeige von TippTexten für die Haltestelle an jeder beliebigen Immobilie
    - `RoadStationDisplayModel.Tram_Schild_DL1`
      für EEP-Modell V15NDL10027 - Texturierbare Zielanzeigen für Haltestellen
    - `RoadStationDisplayModel.BusHSdfi_RG3`
      für Anzeige aus EEP-Modell V15NRG35002
    - `RoadStationDisplayModel.BusHSInfo_RG3`
      für Haltestellenschild aus EEP-Modell V15NRG35002
    - `RoadStationDisplayModel.BusHS_Tram_dfi_6_RG3`
      für Anzeige aus EEP-Modell V15NRG35023
    - `RoadStationDisplayModel.BusHS_Tram_Info_6_RG3`
      für Haltestellenschild aus EEP-Modell V15NRG35023
  - `platformId` Plattform, der dieses Display zugeordnet werden soll.
    Wenn nicht angegeben, werden am Display die Abfahrten aller Züge der Haltestelle angezeigt.

Um eine Haltestelle anzulegen, weise einer Variable z.B. `sSchnalzlaut` das Ergebnis des Aufrufs `RoadStation:new("Schnalzlaut", -1)`.
Danach kannst Du dieser Variable dann mit `:addDisplay(...)` weitere Anzeigetafeln oder Haltestellenschilder für bestimmte Steige hinzufügen, z.B. `sSchnalzlaut:addDisplay("#2", RoadStationDisplayModel.SimpleStructure, 1)`.

Das Ganze sieht dann so aus:

```lua
-- Haltestelle Schnalzlaut
sSchnalzlaut = RoadStation:new("Schnalzlaut", -1)
sSchnalzlaut:addDisplay("#2_Bus-Haltestelle modern", RoadStationDisplayModel.SimpleStructure, 1)
-- Haltestelle Windpark
sWindpark = RoadStation:new("Windpark", -1)
sWindpark:addDisplay("#4_Bus-Haltestelle modern", RoadStationDisplayModel.SimpleStructure, 1)
sWindpark:addDisplay("#5_Bus-Haltestelle modern", RoadStationDisplayModel.SimpleStructure, 2)
-- Haltestelle Baywa
sBaywa = RoadStation:new("Baywa", -1)
sBaywa:addDisplay("#6_Bus-Haltestelle modern", RoadStationDisplayModel.SimpleStructure, 1)
sBaywa:addDisplay("#7_Bus-Haltestelle modern", RoadStationDisplayModel.SimpleStructure, 2)
-- Haltestelle Hochbaum
sHochbaum = RoadStation:new("Hochbaum", -1)
sHochbaum:addDisplay("#3_Bus-Haltestelle modern", RoadStationDisplayModel.SimpleStructure, 1)
```

## ÖPNV-Linien in Lua

### Einmaliger Import von Line

```lua
local Line = require("ak.public-transport.Line")
```

### Aufrufe in Kontaktpunkten

#### wenn ein Zug eine Haltestelle verlässt

Lege einen Kontaktpunkt hinter die Haltestelle.
Nutze im Kontaktpunkt die Funktion `Line.trainDeparted(trainName, meineHaltestelle)`

Sobald der Zug (Bus, Tram) die Haltestelle `meineHaltestelle` verlässt, dann wird er automatisch an allen folgenden
Haltestellen registriert.
Die elektronischen Anzeigen der folgenden Haltestelle werden automatisch der Reihe nach aktualisiert bis zu der
Haltestelle, die der Zug grade verlassen hat.

```lua
-- wenn ein Zug eine Haltestelle verlässt:
Line.trainDeparted(trainName, station)
```

Handelt es sich bei der Haltestelle um die letzte im Linien-Abschnitt, dann wechselt der Zug automatisch die Route
und das Ziel.
Der Zug wird die Route nur dann wechseln, wenn die Routenänderung mit `abschnitt285Hochbaum:setNextSection(abschnitt285Schnalzlaut, 2)` hinterlegt wurde.

#### wenn ein Zug demnächst eine Haltestelle erreicht

Wenn der Zug die Haltestelle `meineHaltestelle` in 7 Minuten erreicht, dann nutze im Kontaktpunkt folgende Funktion: `Line.scheduleDeparture(trainName, meineHaltestelle, 7)`

```lua
-- wenn ein Zug demnächst eine Haltestelle erreicht:
Line.scheduleDeparture(trainName, station, timeInMinutes)
```

### Einrichten der Route

```lua
-- Line 285
local line285 = Line.forName("285")

-- Linie 285 Richtung Hochbaum
local abschnitt285Hochbaum = line285:addSection("Linie 285 Hochbaum", "Hochbaum")
abschnitt285Hochbaum:addStop(sSchnalzlaut:platform(1), 0) -- Steig 1 wird genutzt von Line 285 Richtung Hochbaum
abschnitt285Hochbaum:addStop(sWindpark:platform(1), 2) -- Steig 1 wird genutzt von Line 285 Richtung Hochbaum
abschnitt285Hochbaum:addStop(sBaywa:platform(1), 2) -- Steig 1 wird genutzt von Line 285 Richtung Hochbaum
-- die letzte Haltestelle wird bei mehreren Segmenten in einer Linie weggelassen,
-- weil sie die erste im folgenden Streckenabschnitt ist

-- Linie 285 Richtung Schnalzlaut
local abschnitt285Schnalzlaut = line285:addSection("Linie 285 Schnalzlaut", "Schnalzlaut")
abschnitt285Schnalzlaut:addStop(sHochbaum:platform(1), 0) -- Steig 2 wird genutzt von Line 285 Richtung Schnalzlaut
abschnitt285Schnalzlaut:addStop(sBaywa:platform(2), 2) -- Steig 2 wird genutzt von Line 285 Richtung Schnalzlaut
abschnitt285Schnalzlaut:addStop(sWindpark:platform(2), 2) -- Steig 2 wird genutzt von Line 285 Richtung Schnalzlaut
-- die letzte Haltestelle wird bei mehreren Segmenten in einer Linie weggelassen,
-- weil sie die erste im folgenden Streckenabschnitt ist


-- Geplante Linienaenderungen, wenn eine Linie die Kontaktpunktfunktion "changeDestination" aufruft
-- 1. Parameter: RoadStation, an der der Wechsel durchgeführt werden soll
-- 2. Parameter: Route - alte Fahrplan Route
-- 3. Parameter: Route - neue Fahrplan Route
-- 4. Parameter: Line - neue Linie
route285Hochbaum:setNextSection(route285Schnalzlaut, 2)
route285Schnalzlaut:setNextSection(route285Hochbaum, 2)
```
