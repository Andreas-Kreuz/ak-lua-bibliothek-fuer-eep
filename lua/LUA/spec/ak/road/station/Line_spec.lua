insulate("Line Management", function()
    require("ak.core.eep.EepSimulator")
    local Train = require("ak.train.Train")
    local Line = require("ak.road.line.Line")
    local RoadStation = require("ak.road.line.RoadStation")
    assert(RoadStation)

    -- Station definition
    local sMesseDresden = RoadStation:new("Messe Dresden", -1)
    local sFeuerwehrGasse = RoadStation:new("Feuerwehrgasse", -1)
    local sHauptbahnhof = RoadStation:new("Hauptbahnhof", -1)
    local sStriesen = RoadStation:new("Striesen", -1)


    -- Route definition
    local line1 = Line:new({nr = "1a"})
    line1.route1 = line1:newRoute("10 Striesen")
    line1.route1:addStation(sMesseDresden)
    line1.route1:addStation(sFeuerwehrGasse, 2)
    line1.route1:addStation(sHauptbahnhof, 2)
    line1.route1:addStation(sStriesen, 3)

    it("Station 1", function() assert.equals("Messe Dresden", line1.route1:getFirstStation().name) end)
    it("Station 4", function() assert.equals("Striesen", line1.route1:getLastStation().name) end)

    line1.route2 = line1.route1:newReverseRoute("10 Messe Dresden")

    it("Station 1", function() assert.equals("Striesen", line1.route2:getFirstStation().name) end)
    it("Station 4", function() assert.equals("Messe Dresden", line1.route2:getLastStation().name) end)

    -- Create a new train
    local train1 = Train.forName("#Train 1")
    assert(train1.trainName)

    -- Prepare to use route 1
    line1:prepareDepartureAt(train1.trainName, line1.route1, 10)-- The following stations are informed

    -- Drive through route 1 by contacts
    sMesseDresden:trainLeft(train1.trainName)
    sFeuerwehrGasse:trainArrivesIn(train1.trainName, 3)
    sFeuerwehrGasse:trainArrivesIn(train1.trainName, 2)
    sFeuerwehrGasse:trainArrivesIn(train1.trainName, 1)
    sFeuerwehrGasse:trainArrivesIn(train1.trainName, 0)
    sFeuerwehrGasse:trainLeft(train1.trainName)
    sHauptbahnhof:trainArrivesIn(train1.trainName, 0)
    sHauptbahnhof:trainLeft(train1.trainName)
    sStriesen:trainArrivesIn(train1.trainName, 0)
    sStriesen:trainLeft(train1.trainName)

    -- Prepare to use route 2
    line1:prepareDepartureAt(train1.trainName, line1.route1, 10)-- The following stations are informed

    -- Drive through route 2 by contacts

    sStriesen:trainArrivesIn(train1.trainName, 0)
    sStriesen:trainLeft(train1.trainName)
    sHauptbahnhof:trainArrivesIn(train1.trainName, 0)
    sHauptbahnhof:trainLeft(train1.trainName)
    sFeuerwehrGasse:trainArrivesIn(train1.trainName, 3)
    sFeuerwehrGasse:trainArrivesIn(train1.trainName, 2)
    sFeuerwehrGasse:trainArrivesIn(train1.trainName, 1)
    sFeuerwehrGasse:trainArrivesIn(train1.trainName, 0)
    sFeuerwehrGasse:trainLeft(train1.trainName)
    sMesseDresden:trainArrivesIn(train1.trainName, 0)
    sMesseDresden:trainLeft(train1.trainName)

end)
