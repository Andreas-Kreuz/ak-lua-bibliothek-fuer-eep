insulate("Line Management Ring Line", function()
    local EepSimulator = require("ce.hub.eep.EepSimulator")

    EepSimulator.simulateAddTrain("train1", "RollingStock 1a", "RollingStock 2b")
    EepSimulator.simulateAddTrain("train2", "RollingStock 2a", "RollingStock 2b")
    EepSimulator.simulateAddTrain("train3", "RollingStock 3a", "RollingStock 3b")
    it("EEPLoadData exists", function() assert.is_truthy(_G.EEPLoadData) end)

    local Line = require("ce.mods.transit.Line")
    local RoadStation = require("ce.mods.transit.RoadStation")
    local RSDM = require("ce.mods.transit.models.RoadStationDisplayModel")

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
        local TrainRegistry = require("ce.hub.data.trains.TrainRegistry")
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

        local stations = ringLineSegment:nextStationList(ringLineSegment.routeName, RoadStation.forName("C"))
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
    local EepSimulator = require("ce.hub.eep.EepSimulator")

    EepSimulator.simulateAddTrain("train1", "RollingStock 1a", "RollingStock 2b")
    EepSimulator.simulateAddTrain("train2", "RollingStock 2a", "RollingStock 2b")
    EepSimulator.simulateAddTrain("train3", "RollingStock 3a", "RollingStock 3b")
    it("EEPLoadData exists", function() assert.is_truthy(_G.EEPLoadData) end)

    -- Core Stuff
    local ControlExtension = require("ce.ControlExtension")

    -- Intersections
    local RoadCeModule = require("ce.mods.road.RoadCeModule")

    -- Public Transport
    local TransitCeModule = require("ce.mods.transit.TransitCeModule")
    local Line = require("ce.mods.transit.Line")
    local RoadStation = require("ce.mods.transit.RoadStation")
    local RSDM = require("ce.mods.transit.models.RoadStationDisplayModel")

    ---------------------------------------------------------------------------------------------------------------
    -- Register the required modules
    ControlExtension.addModules(RoadCeModule, TransitCeModule)
    RoadCeModule.loadSettingsFromSlot(1)
    TransitCeModule.loadSettingsFromSlot(2)
    ---------------------------------------------------------------------------------------------------------------
    -- Die folgende Methode wird von EEP mind. alle 200 ms ausgeführt
    function EEPMain()
        ControlExtension.runTasks(1)
        return 1
    end
    ---------------------------------------------------------------------------------------------------------------

    local linie10 = Line.forName("10")
    local linie12 = Line.forName("12")

    -- Linie mit Hin- und Rückweg
    ---@type LineSegment
    local linie10Messe = linie10:addSection("Linie 10: Tram in Richtung Messe Dresden", "Messe Dresden")
    linie10Messe:addStop(RoadStation.forName("Ludwig-Hartmann-Straße"):platform(1), 0)
    linie10Messe:addStop(RoadStation.forName("Straßbuger Platz"):platform(1), 2)
    linie10Messe:addStop(RoadStation.forName("Hauptbahnhof"):platform(1), 2)
    -- linie10Messe:addStop(RoadStation.forName("Messe Dresden"):platform(1), 2)

    ---@type LineSegment
    local linie10Striesen = linie10:addSection("Linie 10: Tram in Richtung Striesen", "Striesen")
    linie10Striesen:addStop(RoadStation.forName("Messe Dresden"):platform(1), 0)
    linie10Striesen:addStop(RoadStation.forName("Hauptbahnhof"):platform(2), 2)
    linie10Striesen:addStop(RoadStation.forName("Straßbuger Platz"):platform(2), 2)
    -- linie10Striesen:addStop(RoadStation.forName("Ludwig-Hartmann-Straße"):platform(1), 2)

    ---@type LineSegment
    local linie12Leutewitz = linie12:addSection("Linie 12: Tram in Richtung Leutewitz", "Leutewitz")
    linie12Leutewitz:addStop(RoadStation.forName("Ludwig-Hartmann-Straße"):platform(2), 0)
    linie12Leutewitz:addStop(RoadStation.forName("Straßbuger Platz"):platform(1), 2)
    linie12Leutewitz:addStop(RoadStation.forName("Irgendwo"):platform(1), 2)

    ---@type LineSegment
    local linie12Striesen = linie12:addSection("Linie 12: Tram in Richtung Striesen", "Striesen")
    linie12Striesen:addStop(RoadStation.forName("Leutewitz"):platform(2), 2)
    linie12Striesen:addStop(RoadStation.forName("Irgendwo"):platform(2), 2)
    linie12Striesen:addStop(RoadStation.forName("Straßbuger Platz"):platform(2), 2)

    linie10Messe:setNextSection(linie10Striesen, 6)
    linie10Striesen:setNextSection(linie12Leutewitz, 7)
    linie12Leutewitz:setNextSection(linie12Striesen, 8)
    linie12Striesen:setNextSection(linie10Messe, 9)

    RoadStation.forName("Ludwig-Hartmann-Straße"):platform(1):addDisplay("#1", RSDM.SimpleStructure)
    RoadStation.forName("Straßbuger Platz"):platform(1):addDisplay("#2", RSDM.SimpleStructure)
    RoadStation.forName("Straßbuger Platz"):platform(2):addDisplay("#3", RSDM.SimpleStructure)
    RoadStation.forName("Hauptbahnhof"):platform(1):addDisplay("#4", RSDM.SimpleStructure)
    RoadStation.forName("Hauptbahnhof"):platform(2):addDisplay("#5", RSDM.SimpleStructure)
    RoadStation.forName("Messe Dresden"):platform(1):addDisplay("#6", RSDM.SimpleStructure)

    insulate("train1", function()
        local TrainRegistry = require("ce.hub.data.trains.TrainRegistry")
        local train1 = TrainRegistry.forName("train1")
        train1:setRoute(linie10Messe.routeName)
        train1:changeDestination(linie10Messe.destination, linie10Messe.line.nr)
        it("initial route",
           function() assert.are.equal("Linie 10: Tram in Richtung Messe Dresden", train1:getRoute()) end)
        it("initial destination", function() assert.are.equal("Messe Dresden", train1:getDestination()) end)
        it("initial line", function() assert.are.equal("10", train1:getLine()) end)

        insulate("train1", function()
            Line.trainDeparted("train1", RoadStation.forName("Hauptbahnhof"))
            local route = train1:getRoute()
            local destination = train1:getDestination()

            it("changes line to Striesen",
               function() assert.are.equal("Linie 10: Tram in Richtung Striesen", route) end)
            it("changes destination to Striesen", function() assert.are.equal("Striesen", destination) end)
        end)

        insulate("nextStations", function()
            EepSimulator.simulateAddTrain("train4", "RollingStock 4a", "RollingStock 4b")
            local train4 = TrainRegistry.forName("train4")
            train4:setRoute(linie10Messe.routeName)
            train4:changeDestination(linie10Messe.destination, linie10Messe.line.nr)
            local LineSegment = require("ce.mods.transit.LineSegment")

            -- Depart from 1st station
            Line.trainDeparted("train4", RoadStation.forName("Straßbuger Platz"))
            local route = train4:getRoute()
            it("", function() assert.are.equal("Linie 10: Tram in Richtung Messe Dresden", route) end)

            -- Depart for Line Change
            Line.trainDeparted("train4", RoadStation.forName("Hauptbahnhof"))
            local route2 = train4:getRoute()
            local queue = RoadStation.forName("Hauptbahnhof").queue
            local queueLength = #queue.entriesByArrival
            local queueText = RoadStation.queueToText(queue)
            it("", function() assert.are.equal("Linie 10: Tram in Richtung Striesen", route2) end)
            it("", function() assert.are.equal(4, queueLength) end)
            it("", function()
                assert.are.equal(
                "10&Striesen&train1|10&Striesen&train4|10&Messe Dresden&train1|10&Messe Dresden&train4", queueText)
            end)

            LineSegment.debug = false
            -- Depart for last Line Change
            train4:setRoute(linie12Striesen.routeName)
            train4:changeDestination(linie12Striesen.destination, linie12Striesen.line.nr)
            Line.trainDeparted("train4", RoadStation.forName("Straßbuger Platz"))
            local route5 = train4:getRoute()
            it("", function() assert.are.equal("Linie 10: Tram in Richtung Messe Dresden", route5) end)
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
    local EepSimulator = require("ce.hub.eep.EepSimulator")
    local TrainRegistry = require("ce.hub.data.trains.TrainRegistry")
    local Line = require("ce.mods.transit.Line")
    local RoadStation = require("ce.mods.transit.RoadStation")

    local testTrain = "#Train 1"
    EepSimulator.simulateAddTrain(testTrain, "RollingStock 1", "RollingStock 2")

    -- Station definition
    local sMesseDresden = RoadStation:new("Messe Dresden", -1)
    local sFeuerwehrGasse = RoadStation:new("Feuerwehrgasse", -1)
    local sHauptbahnhof = RoadStation:new("Hauptbahnhof", -1)
    local sStriesen = RoadStation:new("Striesen", -1)

    -- Route definition
    local line10 = Line.forName("10")
    local l10Striesen = line10:addSection("10 Striesen", "Striesen")
    l10Striesen:addStop(sMesseDresden:platform(1))
    l10Striesen:addStop(sFeuerwehrGasse:platform(1), 2)
    l10Striesen:addStop(sHauptbahnhof:platform(1), 2)
    l10Striesen:addStop(sStriesen:platform(1), 3)

    local l10MesseDresden = line10:addSection("10 Messe Dresden", "Messe Dresden")
    l10MesseDresden:addStop(sStriesen:platform(2), 0)
    l10MesseDresden:addStop(sHauptbahnhof:platform(2), 3)
    l10MesseDresden:addStop(sFeuerwehrGasse:platform(2), 2)
    l10MesseDresden:addStop(sMesseDresden:platform(2))

    -- Check route
    it("Station 1", function() assert.equals("Messe Dresden", l10Striesen:getFirstStation().name) end)
    it("Station 4", function() assert.equals("Striesen", l10Striesen:getLastStation().name) end)

    it("", function() assert.equals("2", sHauptbahnhof.routePlatforms["10->Messe Dresden"].platform) end)
    it("", function() assert.equals("1", sHauptbahnhof.routePlatforms["10->Striesen"].platform) end)
    it("", function() assert.equals("2", sFeuerwehrGasse.routePlatforms["10->Messe Dresden"].platform) end)
    it("", function() assert.equals("1", sFeuerwehrGasse.routePlatforms["10->Striesen"].platform) end)

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
