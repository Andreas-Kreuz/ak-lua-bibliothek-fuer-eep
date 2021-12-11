-- Linienführung
local Line = require("ak.public-transport.Line")
local RoadStation = require("ak.public-transport.RoadStation")
local RoadStationDisplayModel = require("ak.public-transport.RoadStationDisplayModel")
local BetterContacts = require("ak.third-party.BetterContacts_BH2")
BetterContacts.setOptions({varname = "trainName", varnameTrackID = "trackId"})

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

-- Kontaktpunktfunktion
-- 1. Parameter: Zugname aus Bennys EEP-Schnipsel
-- 2. Parameter: Stationsname wie in Destinations.changeOn() hinterlegt
-- 3. Parameter: Abfahrtszeit in Minuten (optional)
function changeDestination(trainName, station, departureTime)
    assert(type(trainName) == "string", "Provide 'trainName' as 'string' was " .. type(trainName))
    assert(type(station) == "table", "Provide 'station' as 'table' was " .. type(station))
    assert(station.type == "RoadStation", "Provide 'station' as 'RoadStation'")
    if departureTime then
        assert(type(departureTime) == "number", "Provide 'departureTime' as 'number' was " .. type(departureTime))
    end

    Line.changeRoute(trainName, station, departureTime)
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
local line285 = Line:new({nr = "285"})

-- Linie 285 Richtung Hochbaum
local route285Hochbaum = line285:newRoute("Linie 285 Hochbaum")
route285Hochbaum:addStation(sSchnalzlaut, 1, 0) -- Steig 1 wird genutzt von Line 285 Richtung Hochbaum
route285Hochbaum:addStation(sWindpark, 1, 2) -- Steig 1 wird genutzt von Line 285 Richtung Hochbaum
route285Hochbaum:addStation(sBaywa, 1, 2) -- Steig 1 wird genutzt von Line 285 Richtung Hochbaum
route285Hochbaum:addStation(sHochbaum, 1, 2) -- Steig 1 wird genutzt von Line 285 Richtung Hochbaum

-- Linie 285 Richtung Schnalzlaut
local route285Schnalzlaut = line285:newRoute("Linie 285 Schnalzlaut")
route285Schnalzlaut:addStation(sHochbaum, 1, 0) -- Steig 2 wird genutzt von Line 285 Richtung Schnalzlaut
route285Schnalzlaut:addStation(sBaywa, 2, 2) -- Steig 2 wird genutzt von Line 285 Richtung Schnalzlaut
route285Schnalzlaut:addStation(sWindpark, 2, 2) -- Steig 2 wird genutzt von Line 285 Richtung Schnalzlaut
route285Schnalzlaut:addStation(sSchnalzlaut, 1, 2) -- Steig 2 wird genutzt von Line 285 Richtung Schnalzlaut

-- Geplante Linienaenderungen, wenn eine Linie die Kontaktpunktfunktion "changeDestination" aufruft
-- 1. Parameter: RoadStation, an der der Wechsel durchgeführt werden soll
-- 2. Parameter: Route - alte Fahrplan Route
-- 3. Parameter: Route - neue Fahrplan Route
-- 4. Parameter: Line - neue Linie
Line.addRouteChange(sHochbaum, route285Hochbaum, route285Schnalzlaut, line285)
Line.addRouteChange(sSchnalzlaut, route285Schnalzlaut, route285Hochbaum, line285)

