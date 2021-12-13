insulate("Line Management Ring Line", function()
    local EepSimulator = require("ak.core.eep.EepSimulator")

    EepSimulator.addTrain("train1", "RollingStock 1a", "RollingStock 2b")
    EepSimulator.addTrain("train2", "RollingStock 2a", "RollingStock 2b")
    EepSimulator.addTrain("train3", "RollingStock 3a", "RollingStock 3b")
    it("EEPLoadData exists", function() assert.is_truthy(_G.EEPLoadData) end)

    local Line = require("ak.public-transport.Line")
    local RoadStation = require("ak.public-transport.RoadStation")
    local RSDM = require("ak.public-transport.RoadStationDisplayModel")

    local ringLine = Line.forName("R")
    ---@type LineSegment
    local ringLineSegment = ringLine:addSection("Linie R: Tram Innerer Ring", "Innerer Ring")
    ringLineSegment:addStop(RoadStation.forName("A"):platform(2), 3)
    ringLineSegment:addStop(RoadStation.forName("B"):platform(2), 4)
    ringLineSegment:addStop(RoadStation.forName("C"):platform(2), 5)

    RoadStation.forName("A"):platform(2):addDisplay("#1", RSDM.SimpleStructure)
    RoadStation.forName("B"):platform(2):addDisplay("#2", RSDM.SimpleStructure)
    RoadStation.forName("C"):platform(2):addDisplay("#3", RSDM.SimpleStructure)

    insulate("train1 changes destination correctly", function()
        local TrainRegistry = require("ak.train.TrainRegistry")
        local train1 = TrainRegistry.forName("train1")
        train1:setRoute(ringLineSegment.routeName)
        train1:changeDestination(ringLineSegment.destination, ringLineSegment.line.nr)
        it("train1 has correct initial route",
           function() assert.are.equal(train1.route, "Linie R: Tram Innerer Ring") end)
        it("train1 got initial destination to Messe Dresden",
           function() assert.are.equal("Innerer Ring", train1:getDestination()) end)

        Line.trainDeparted("train1", RoadStation.forName("C"))
        it("train1 has correct initial route",
           function() assert.are.equal(train1.route, "Linie R: Tram Innerer Ring") end)
        it("train1 got initial destination to Messe Dresden",
           function() assert.are.equal("Innerer Ring", train1:getDestination()) end)
    end)

    insulate("LineSegments", function()
        local segments = ringLineSegment:getAllSegments()
        it("Got 1 line segments", function() assert.are.equal(1, #segments) end)
        it("1st line ok", function() assert.are.equal(ringLineSegment, segments[1].segment) end)
        it("1st time ok", function() assert.are.equal(2, segments[1].timeInMinutes) end)

        local stations = ringLineSegment:stationsListAfterStation(ringLineSegment.routeName, RoadStation.forName("C"))
        it("Got 1 line segments", function() assert.are.equal(3, #stations) end)
        it("1st line ok", function() assert.are.equal("C", stations[1].station.name) end)
        it("1st line ok", function() assert.are.equal("A", stations[2].station.name) end)
        it("1st line ok", function() assert.are.equal("B", stations[3].station.name) end)
        it("1st time ok", function() assert.are.equal(0, stations[1].totalTime) end)
        it("1st time ok", function() assert.are.equal(3, stations[2].totalTime) end)
        it("1st time ok", function() assert.are.equal(7, stations[3].totalTime) end)
    end)
end)

insulate("Line Management 4 Line segments", function()
    local EepSimulator = require("ak.core.eep.EepSimulator")

    EepSimulator.addTrain("train1", "RollingStock 1a", "RollingStock 2b")
    EepSimulator.addTrain("train2", "RollingStock 2a", "RollingStock 2b")
    EepSimulator.addTrain("train3", "RollingStock 3a", "RollingStock 3b")
    it("EEPLoadData exists", function() assert.is_truthy(_G.EEPLoadData) end)

    -- Core Stuff
    local ModuleRegistry = require("ak.core.ModuleRegistry")
    local CoreLuaModule = require("ak.core.CoreLuaModule")
    local DataLuaModule = require("ak.data.DataLuaModule")

    -- Intersections
    local CrossingLuaModule = require("ak.road.CrossingLuaModul")
    local Crossing = require("ak.road.Crossing")

    -- Public Transport
    local PublicTransportLuaModule = require("ak.public-transport.PublicTransportLuaModule")
    local Line = require("ak.public-transport.Line")
    local RoadStation = require("ak.public-transport.RoadStation")
    local RSDM = require("ak.public-transport.RoadStationDisplayModel")

    ---------------------------------------------------------------------------------------------------------------
    -- Register the required modules
    ModuleRegistry.registerModules(CoreLuaModule, DataLuaModule, CrossingLuaModule, PublicTransportLuaModule)
    Crossing.loadSettingsFromSlot(1)
    Line.loadSettingsFromSlot(2)
    ---------------------------------------------------------------------------------------------------------------
    -- Die folgende Methode wird von EEP mind. alle 200 ms ausgef¸hrt
    function EEPMain()
        ModuleRegistry.runTasks(1)
        return 1
    end
    ---------------------------------------------------------------------------------------------------------------

    local linie10 = Line.forName("10")
    local linie12 = Line.forName("12")

    -- Linie mit Hin- und R¸ckweg
    ---@type LineSegment
    local linie10Messe = linie10:addSection("Linie 10: Tram in Richtung Messe Dresden", "Messe Dresden")
    linie10Messe:addStop(RoadStation.forName("Ludwig-Hartmann-Straﬂe"):platform(1), 0)
    linie10Messe:addStop(RoadStation.forName("Straﬂbuger Platz"):platform(1), 2)
    linie10Messe:addStop(RoadStation.forName("Hauptbahnhof"):platform(1), 2)
    -- linie10Messe:addStop(RoadStation.forName("Messe Dresden"):platform(1), 2)

    ---@type LineSegment
    local linie10Striesen = linie10:addSection("Linie 10: Tram in Richtung Striesen", "Striesen")
    linie10Striesen:addStop(RoadStation.forName("Messe Dresden"):platform(1), 0)
    linie10Striesen:addStop(RoadStation.forName("Hauptbahnhof"):platform(2), 2)
    linie10Striesen:addStop(RoadStation.forName("Straﬂbuger Platz"):platform(2), 2)
    -- linie10Striesen:addStop(RoadStation.forName("Ludwig-Hartmann-Straﬂe"):platform(1), 2)

    ---@type LineSegment
    local linie12Leutewitz = linie12:addSection("Linie 12: Tram in Richtung Leutewitz", "Leutewitz")
    linie12Leutewitz:addStop(RoadStation.forName("Ludwig-Hartmann-Straﬂe"):platform(2), 0)
    linie12Leutewitz:addStop(RoadStation.forName("Straﬂbuger Platz"):platform(1), 2)
    linie12Leutewitz:addStop(RoadStation.forName("Irgendwo"):platform(1), 2)

    ---@type LineSegment
    local linie12Striesen = linie12:addSection("Linie 12: Tram in Richtung Striesen", "Striesen")
    linie12Striesen:addStop(RoadStation.forName("Leutewitz"):platform(2), 2)
    linie12Striesen:addStop(RoadStation.forName("Irgendwo"):platform(2), 2)
    linie12Striesen:addStop(RoadStation.forName("Straﬂbuger Platz"):platform(2), 2)

    linie10Messe:setNextSection(linie10Striesen, 6)
    linie10Striesen:setNextSection(linie12Leutewitz, 7)
    linie12Leutewitz:setNextSection(linie12Striesen, 8)
    linie12Striesen:setNextSection(linie10Messe, 9)

    RoadStation.forName("Ludwig-Hartmann-Straﬂe"):platform(1):addDisplay("#1", RSDM.SimpleStructure)
    RoadStation.forName("Straﬂbuger Platz"):platform(1):addDisplay("#2", RSDM.SimpleStructure)
    RoadStation.forName("Straﬂbuger Platz"):platform(2):addDisplay("#3", RSDM.SimpleStructure)
    RoadStation.forName("Hauptbahnhof"):platform(1):addDisplay("#4", RSDM.SimpleStructure)
    RoadStation.forName("Hauptbahnhof"):platform(2):addDisplay("#5", RSDM.SimpleStructure)
    RoadStation.forName("Messe Dresden"):platform(1):addDisplay("#6", RSDM.SimpleStructure)

    insulate("train1", function()
        local TrainRegistry = require("ak.train.TrainRegistry")
        local train1 = TrainRegistry.forName("train1")
        train1:setRoute(linie10Messe.routeName)
        train1:changeDestination(linie10Messe.destination, linie10Messe.line.nr)
        it("initial route",
           function() assert.are.equal("Linie 10: Tram in Richtung Messe Dresden", train1:getRoute()) end)
        it("initial destination", function() assert.are.equal("Messe Dresden", train1:getDestination()) end)
        it("initial line", function() assert.are.equal("10", train1:getLine()) end)

        insulate("train1", function()
            Line.trainDeparted("train1", RoadStation.forName("Hauptbahnhof"))
            it("changes line to Striesen",
               function() assert.are.equal("Linie 10: Tram in Richtung Striesen", train1.route) end)
            it("changes destination to Striesen", function()
                assert.are.equal("Striesen", train1:getDestination())
            end)
        end)
    end)

    insulate("LineSegments", function()
        local segments = linie10Messe:getAllSegments()

        it("Got 4 line segments", function() assert.are.equal(4, #segments) end)
        it("1st line ok", function() assert.are.equal(linie10Messe, segments[1].segment) end)
        it("2nd line ok", function() assert.are.equal(linie10Striesen, segments[2].segment) end)
        it("3rd line ok", function() assert.are.equal(linie12Leutewitz, segments[3].segment) end)
        it("4th line ok", function() assert.are.equal(linie12Striesen, segments[4].segment) end)
        it("1st time ok", function() assert.are.equal(9, segments[1].timeInMinutes) end)
        it("2nd time ok", function() assert.are.equal(6, segments[2].timeInMinutes) end)
        it("3rd time ok", function() assert.are.equal(7, segments[3].timeInMinutes) end)
        it("4th time ok", function() assert.are.equal(8, segments[4].timeInMinutes) end)

    end)
end)

insulate("Line Management", function()
    local EepSimulator = require("ak.core.eep.EepSimulator")
    local TrainRegistry = require "ak.train.TrainRegistry"
    local Line = require("ak.public-transport.Line")
    local RoadStation = require("ak.public-transport.RoadStation")

    local testTrain = "#Train 1"
    EepSimulator.addTrain(testTrain, "RollingStock 1", "RollingStock 2")

    -- Station definition
    local sMesseDresden = RoadStation:new("Messe Dresden", -1)
    local sFeuerwehrGasse = RoadStation:new("Feuerwehrgasse", -1)
    local sHauptbahnhof = RoadStation:new("Hauptbahnhof", -1)
    local sStriesen = RoadStation:new("Striesen", -1)

    -- Route definition
    local line10 = Line:new({nr = "1a"})
    local l10Striesen = line10:addSection("10 Striesen", "Striesen")
    l10Striesen:addStop(sMesseDresden:platform(1))
    l10Striesen:addStop(sFeuerwehrGasse:platform(1), 2)
    l10Striesen:addStop(sHauptbahnhof:platform(1), 2)
    l10Striesen:addStop(sStriesen:platform(1), 3)

    local l10MesseDresden = line10:addSection("10 Messe Dresden", "Dresden")
    l10MesseDresden:addStop(sStriesen:platform(2), 0)
    l10MesseDresden:addStop(sHauptbahnhof:platform(2), 3)
    l10MesseDresden:addStop(sFeuerwehrGasse:platform(2), 2)
    l10MesseDresden:addStop(sMesseDresden:platform(2))

    -- Check route
    it("Station 1", function() assert.equals("Messe Dresden", l10Striesen:getFirstStation().name) end)
    it("Station 4", function() assert.equals("Striesen", l10Striesen:getLastStation().name) end)

    it("", function() assert.equals("2", sHauptbahnhof.routePlatforms[l10MesseDresden.routeName].platform) end)
    it("", function() assert.equals("1", sHauptbahnhof.routePlatforms[l10Striesen.routeName].platform) end)
    it("", function() assert.equals("2", sFeuerwehrGasse.routePlatforms[l10MesseDresden.routeName].platform) end)
    it("", function() assert.equals("1", sFeuerwehrGasse.routePlatforms[l10Striesen.routeName].platform) end)

    -- Check reverse route
    it("Station 1", function() assert.equals("Striesen", l10MesseDresden:getFirstStation().name) end)
    it("Station 4", function() assert.equals("Messe Dresden", l10MesseDresden:getLastStation().name) end)

    -- add contact-point functions
    local function stationArrivalPlanned(trainName, station, timeInMinutes)
        assert(type(trainName) == "string", "Need 'trainName' as string")
        assert(type(station) == "table", "Need 'station' as table")
        assert(station.type == "RoadStation", "Provide 'station' as 'RoadStation'")
        assert(type(timeInMinutes) == "number", "Need 'timeInMinutes' as number")

        Line.scheduleDeparture(trainName, station, timeInMinutes)
    end

    local function stationLeft(trainName, station)
        assert(type(trainName) == "string", "Need 'trainName' as string")
        assert(type(station) == "table", "Need 'station' as table")
        assert(station.type == "RoadStation", "Provide 'station' as 'RoadStation'")

        Line.trainDeparted(trainName, station)
    end

    local function changeDestination(trainName, station, departureTime)
        assert(type(trainName) == "string", "Need 'trainName' as string")
        assert(type(station) == "table", "Need 'station' as table")
        assert(station.type == "RoadStation", "Provide 'station' as 'RoadStation'")
        if departureTime then assert(type(departureTime) == "number", "Need 'departureTime' as number") end

        -- THIS METHOD IS OBSOLETE - use Line.scheduleDeparture(...)
    end

    l10Striesen:setNextSection(l10MesseDresden, 2)
    l10MesseDresden:setNextSection(l10Striesen, 2)

    -- Create a new train

    TrainRegistry.forName(testTrain):setRoute(l10MesseDresden.routeName)
    TrainRegistry.forName(testTrain):changeDestination(l10MesseDresden.destination, l10MesseDresden.line.nr)

    -- Prepare to use route 1
    -- line10:prepareDepartureAt(trainName, l10MesseDresden, 10)-- The following stations are informed
    changeDestination(testTrain, sMesseDresden)

    -- Drive through route 1 by contacts
    stationLeft(testTrain, sMesseDresden)
    stationArrivalPlanned(testTrain, sFeuerwehrGasse, 3)
    stationArrivalPlanned(testTrain, sFeuerwehrGasse, 2)
    stationArrivalPlanned(testTrain, sFeuerwehrGasse, 1)
    stationArrivalPlanned(testTrain, sFeuerwehrGasse, 0)
    stationLeft(testTrain, sFeuerwehrGasse)
    stationArrivalPlanned(testTrain, sHauptbahnhof, 0)
    stationLeft(testTrain, sHauptbahnhof)
    stationArrivalPlanned(testTrain, sStriesen, 0)
    stationLeft(testTrain, sStriesen)

    -- Prepare to use route 2
    -- line10:prepareDepartureAt(trainName, l10Striesen, 10)-- The following stations are informed
    changeDestination(testTrain, sStriesen)

    -- Drive through route 2 by contacts
    stationArrivalPlanned(testTrain, sStriesen, 0)
    stationLeft(testTrain, sStriesen)
    stationArrivalPlanned(testTrain, sHauptbahnhof, 0)
    stationLeft(testTrain, sHauptbahnhof)
    stationArrivalPlanned(testTrain, sFeuerwehrGasse, 3)
    stationArrivalPlanned(testTrain, sFeuerwehrGasse, 2)
    stationArrivalPlanned(testTrain, sFeuerwehrGasse, 1)
    stationArrivalPlanned(testTrain, sFeuerwehrGasse, 0)
    stationLeft(testTrain, sFeuerwehrGasse)
    stationArrivalPlanned(testTrain, sMesseDresden, 0)
    stationLeft(testTrain, sMesseDresden)

end)
