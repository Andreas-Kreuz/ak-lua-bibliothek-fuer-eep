-- Linienführung
local Line = require("ak.public-transport.Line")
local RoadStation = require("ak.public-transport.RoadStation")
local RoadStationDisplayModel = require("ak.public-transport.RoadStationDisplayModel")
local BetterContacts = require("ak.third-party.BetterContacts_BH2")
local LineSegment = require("ak.public-transport.LineSegment")
BetterContacts.setOptions({varname = "trainName", varnameTrackID = "trackId"})
Line.setShowDepartureTippText(true)
LineSegment.debug = false
RoadStation.debug = false

-- Kontaktpunktfunktion für "Das Fahrzeug hat die Haltestelle verlassen"
---@param trainName string
---@param station RoadStation
function stationLeft(trainName, station)
    assert(type(trainName) == "string", "Provide 'trainName' as 'string' was " .. type(trainName))
    assert(type(station) == "table", "Provide 'station' as 'table' was " .. type(station))
    assert(station.type == "RoadStation", "Provide 'station' as 'RoadStation'")

    Line.trainDeparted(trainName, station)
end

-- Kontaktpunktfunktion für "Das Fahrzeug erreicht die Haltestelle in X minuten"
---@param trainName string
---@param station RoadStation
---@param timeInMinutes number
function stationArrivalPlanned(trainName, station, timeInMinutes)
    assert(type(trainName) == "string", "Provide 'trainName' as 'string' was " .. type(trainName))
    assert(type(station) == "table", "Provide 'station' as 'table' was " .. type(station))
    assert(station.type == "RoadStation", "Provide 'station' as 'RoadStation'")
    assert(type(timeInMinutes) == "number", "Provide 'timeInMinutes' as 'number' was " .. type(timeInMinutes))

    Line.scheduleDeparture(trainName, station, timeInMinutes)
end

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

-- Line 285
local line285 = Line.forName("285")

-- Linie 285 Richtung Hochbaum
local abschnitt285Hochbaum = line285:addSection("Linie 285 Hochbaum", "Hochbaum")
abschnitt285Hochbaum:addStop(sSchnalzlaut:platform(1), 3) -- Steig 1 wird genutzt von Line 285 Richtung Hochbaum
abschnitt285Hochbaum:addStop(sWindpark:platform(1), 4) -- Steig 1 wird genutzt von Line 285 Richtung Hochbaum
abschnitt285Hochbaum:addStop(sBaywa:platform(1), 5) -- Steig 1 wird genutzt von Line 285 Richtung Hochbaum

-- Linie 285 Richtung Schnalzlaut
local abschnitt285Schnalzlaut = line285:addSection("Linie 285 Schnalzlaut", "Schnalzlaut")
abschnitt285Schnalzlaut:addStop(sHochbaum:platform(1), 7) -- Steig 2 wird genutzt von Line 285 Richtung Schnalzlaut
abschnitt285Schnalzlaut:addStop(sBaywa:platform(2), 5) -- Steig 2 wird genutzt von Line 285 Richtung Schnalzlaut
abschnitt285Schnalzlaut:addStop(sWindpark:platform(2), 4) -- Steig 2 wird genutzt von Line 285 Richtung Schnalzlaut

-- Geplante Linienaenderungen, wenn eine Linie die Kontaktpunktfunktion "changeDestination" aufruft
-- 1. Parameter: RoadStation, an der der Wechsel durchgeführt werden soll
-- 2. Parameter: Route - alte Fahrplan Route
-- 3. Parameter: Route - neue Fahrplan Route
-- 4. Parameter: Line - neue Linie
abschnitt285Hochbaum:setNextSection(abschnitt285Schnalzlaut, 2)
abschnitt285Schnalzlaut:setNextSection(abschnitt285Hochbaum, 2)
