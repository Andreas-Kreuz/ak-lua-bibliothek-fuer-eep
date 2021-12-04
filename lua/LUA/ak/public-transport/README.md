# Haltestellen in Lua

## Einmaliger Import für Haltestellen

```lua
local RoadStation = require("ak.public-transport.RoadStation")
local RoadStationDisplayModel = require("ak.public-transport.RoadStationDisplayModel")
```

## Einrichten der Haltestellen in der Anlage

- Neue Haltestelle anlegen: `RoadStation:new(name, speicherSlot)`

  - `name`: Name der Haltestelle
  - `speicherSlot`: Freier Speicherslot in EEP - hier könnten optional die Einstellungen gespeichert werden (`-1`, wenn nicht benötigt)

- Ein Display zur Haltestelle hinzufügen: `RoadStation:addDisplay(eepImmoId, displayModel, platformId)`
  fügt der Haltestelle ein Display für eine bestimmte Plattform hinzu (Bussteig, Tramsteig, Bahnsteig)
  - `eepImmoId`: ID der Immobilie in EEP, z.B. `#223` oder `#223_Bus-Haltestelle modern` - unterstützt das Modell der Immobilie die Anzeige von Linien, Bahnsteig oder Abfahrten, dann werden diese automatisch angezeigt.
  - `displayModel`: Ein RoadStationDisplayModel, z.B.
    - `RoadStationDisplayModel.SimpleStructure` - dieses Modell unterstütz die Anzeige von TippTexten für die Haltestelle an jeder beliebigen Immobilie
    - ``

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

# ÖPNV-Linien in Lua

## Einmaliger Import von Line

```lua
local Line = require("ak.public-transport.Line")
```

## Aufrufe in Kontaktpunkten

````lua
-- wenn ein Zug eine Haltestelle verlässt:
Line.trainDeparted(trainName, station)

-- wenn ein Zug demnächst eine Haltestelle erreicht:
Line.scheduleDeparture(trainName, station, timeInMinutes)

-- wenn ein Zug eine Route wechseln soll:
Line.changeRoute(trainName, station, departureTime)
```lua

## Einrichten der Route

```lua
-- Line 285
local line285 = Line:new({{ "{" }}nr = "285"{{ "}" }})

-- Linie 285 Richtung Hochbaum
local route285Hochbaum = line285:newRoute("Linie 285 Hochbaum")
-- Steig 1 wird genutzt von Line 285 Richtung Hochbaum
route285Hochbaum:addStation(sSchnalzlaut, 1, 0)
-- Steig 1 wird genutzt von Line 285 Richtung Hochbaum
route285Hochbaum:addStation(sWindpark, 1, 2)
-- Steig 1 wird genutzt von Line 285 Richtung Hochbaum
route285Hochbaum:addStation(sBaywa, 1, 2)
-- Steig 1 wird genutzt von Line 285 Richtung Hochbaum
route285Hochbaum:addStation(sHochbaum, 1, 2)

-- Linie 285 Richtung Schnalzlaut
local route285Schnalzlaut = line285:newRoute("Linie 285 Schnalzlaut")
-- Steig 2 wird genutzt von Line 285 Richtung Schnalzlaut
route285Schnalzlaut:addStation(sHochbaum, 1, 0)
-- Steig 2 wird genutzt von Line 285 Richtung Schnalzlaut
route285Schnalzlaut:addStation(sBaywa, 2, 2)
-- Steig 2 wird genutzt von Line 285 Richtung Schnalzlaut
route285Schnalzlaut:addStation(sWindpark, 2, 2)
-- Steig 2 wird genutzt von Line 285 Richtung Schnalzlaut
route285Schnalzlaut:addStation(sSchnalzlaut, 1, 2)

-- Geplante Linienaenderungen, wenn eine Linie die Kontaktpunktfunktion "changeDestination" aufruft
-- 1. Parameter: RoadStation, an der der Wechsel durchgeführt werden soll
-- 2. Parameter: Route - alte Fahrplan Route
-- 3. Parameter: Route - neue Fahrplan Route
-- 4. Parameter: Line - neue Linie
Line.addRouteChange(sHochbaum, route285Hochbaum, route285Schnalzlaut, line285)
Line.addRouteChange(sSchnalzlaut, route285Schnalzlaut, route285Hochbaum, line285)
````
