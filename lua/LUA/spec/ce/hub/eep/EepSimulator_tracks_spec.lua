describe("EepSimulator track state", function()
    local function trackCases(EepSimulator)
        return {
            {
                name = "rail",
                register = EEPRegisterRailTrack,
                reserved = EEPIsRailTrackReserved,
                occupy = function(trackId, trainName) EepSimulator.simulatePlaceTrainOnRailTrack(trackId, trainName) end
            },
            {
                name = "road",
                register = EEPRegisterRoadTrack,
                reserved = EEPIsRoadTrackReserved,
                occupy = function(trackId, trainName) EepSimulator.simulatePlaceTrainOnRoadTrack(trackId, trainName) end
            },
            {
                name = "tram",
                register = EEPRegisterTramTrack,
                reserved = EEPIsTramTrackReserved
            },
            {
                name = "auxiliary",
                register = EEPRegisterAuxiliaryTrack,
                reserved = EEPIsAuxiliaryTrackReserved
            },
            {
                name = "control",
                register = EEPRegisterControlTrack,
                reserved = EEPIsControlTrackReserved
            }
        }
    end

    insulate("returns consistent registration state for all track types", function()
        local EepSimulator = require("ce.hub.eep.EepSimulator")

        for index, track in ipairs(trackCases(EepSimulator)) do
            local unknownTrackId = 200 + index
            local existingTrackId = index
            local nonExistingTrackId = 20 + index

            it(track.name .. " reports unknown tracks as unregistered", function()
                local registered, occupied, trainName = track.reserved(unknownTrackId, true)
                assert.equals("boolean", type(registered))
                assert.is_false(registered)
                assert.is_false(occupied)
                assert.is_nil(trainName)
            end)

            it(track.name .. " keeps the existing-track return value", function()
                assert.is_true(track.register(existingTrackId))
            end)

            it(track.name .. " registers non-existing tracks without returning true", function()
                assert.is_nil(track.register(nonExistingTrackId))
            end)

            it(track.name .. " reports registered but free tracks", function()
                local registered, occupied, trainName = track.reserved(existingTrackId, true)
                assert.is_true(registered)
                assert.is_false(occupied)
                assert.equals("", trainName)
            end)

            it(track.name .. " reports registered non-existing tracks as free", function()
                local registered, occupied, trainName = track.reserved(nonExistingTrackId, true)
                assert.is_true(registered)
                assert.is_false(occupied)
                assert.equals("", trainName)
            end)

            it(track.name .. " supports returnTrainName = false", function()
                local registered, occupied = track.reserved(existingTrackId, false)
                assert.equals("boolean", type(registered))
                assert.is_true(registered)
                assert.is_false(occupied)
            end)
        end
    end)

    insulate("keeps occupancy behavior for road and rail", function()
        local EepSimulator = require("ce.hub.eep.EepSimulator")

        EepSimulator.simulatePlaceTrainOnRailTrack(301, "#RailTrain")
        EepSimulator.simulatePlaceTrainOnRoadTrack(302, "#RoadTrain")

        it("marks rail tracks as occupied and returns the train name", function()
            local registered, occupied, trainName = EEPIsRailTrackReserved(301, true)
            assert.is_true(registered)
            assert.is_true(occupied)
            assert.equals("#RailTrain", trainName)
        end)

        it("marks road tracks as occupied and returns the train name", function()
            local registered, occupied, trainName = EEPIsRoadTrackReserved(302, true)
            assert.is_true(registered)
            assert.is_true(occupied)
            assert.equals("#RoadTrain", trainName)
        end)
    end)

    insulate("lets tram track detection initialize against the shared state", function()
        require("ce.hub.eep.EepSimulator")
        local TrackDetection = require("ce.hub.data.tracks.TrackDetection")

        local tramDetection = TrackDetection:new("tram")
        tramDetection:initialize()

        it("discovers the simulated existing tram tracks", function()
            assert.is_not_nil(tramDetection.tracks["1"])
            assert.is_not_nil(tramDetection.tracks["11"])
            assert.is_nil(tramDetection.tracks["12"])
        end)
    end)
end)
