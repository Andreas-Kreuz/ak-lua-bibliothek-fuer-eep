insulate("ce.mods.road.RoadDtoFactories", function ()
    local function clearModule(name) package.loaded[name] = nil end

    before_each(function ()
        clearModule("ce.mods.road.data.RoadDtoFactory")
        clearModule("ce.mods.road.data.TrafficLightModelDtoFactory")
    end)

    it("provides metadata for road DTO lists", function ()
        local RoadDtoFactory = require("ce.mods.road.data.RoadDtoFactory")
        local TrafficLightModelDtoFactory = require("ce.mods.road.data.TrafficLightModelDtoFactory")

        local intersection = {
            id = 1,
            name = "A",
            currentSwitching = "S1",
            manualSwitching = "S2",
            nextSwitching = "S3",
            ready = true,
            timeForGreen = 15,
            staticCams = { "Cam 1" },
            hidden = true
        }
        local lane = {
            id = "1-L1",
            intersectionId = 1,
            name = "L1",
            phase = "GREEN",
            vehicleMultiplier = 2,
            eepSaveId = 5,
            type = "NORMAL",
            countType = "TRACKS",
            waitingTrains = { "T1" },
            waitingForGreenCyclesCount = 4,
            directions = { "LEFT" },
            switchings = { "S1" },
            tracks = { 10 },
            hidden = true
        }
        local switching = { id = "A-S1", intersectionId = "A", name = "S1", prio = 1, hidden = true }
        local trafficLight = {
            id = 2,
            signalId = 2,
            modelId = "road",
            currentPhase = "GREEN",
            intersectionId = 1,
            lightStructures = {
                ["0"] = {
                    structureRed = "Red",
                    structureGreen = "Green",
                    structureYellow = "Yellow",
                    structureRequest = "Request",
                    hidden = true
                }
            },
            axisStructures = {
                {
                    structureName = "Axis",
                    axisName = "Signal",
                    positionDefault = 0,
                    positionRed = 1,
                    positionGreen = 2,
                    positionYellow = 3,
                    positionPedestrian = 4,
                    positionRedYellow = 5,
                    hidden = true
                }
            },
            hidden = true
        }
        local moduleSetting = {
            category = "Display",
            name = "Show",
            description = "Show requests",
            type = "boolean",
            value = true,
            eepFunction = "IntersectionSettings.setShowRequestsOnSignal",
            hidden = true
        }
        local room, keyId, key, intersectionDto = RoadDtoFactory.createRoadIntersectionDto(intersection)
        local laneRoom, laneKeyId, laneKey, laneDto = RoadDtoFactory.createRoadIntersectionLaneDto(lane)
        local switchingRoom, switchingKeyId, switchingKey, switchingDto =
            RoadDtoFactory.createRoadIntersectionSwitchingDto(switching)
        local tlRoom, tlKeyId, tlKey, trafficLightDto =
            RoadDtoFactory.createRoadIntersectionTrafficLightDto(trafficLight)
        local moduleRoom, moduleKeyId, moduleKey, moduleDto =
            RoadDtoFactory.createRoadIntersectionModuleSettingDto(moduleSetting)
        local defsRoom, defsKeyId, defs =
            TrafficLightModelDtoFactory.createSignalTypeDefinitionDtoList({
                {
                    id = "road",
                    name = "road",
                    type = "road",
                    positions = {
                        positionRed = 1,
                        positionGreen = 2,
                        positionYellow = 3,
                        positionRedYellow = 4,
                        positionPedestrians = 5,
                        positionOff = 6,
                        positionOffBlinking = 7,
                        hidden = true
                    },
                    hidden = true
                }
            })

        intersection.name = "B"
        intersection.staticCams[2] = "Cam 2"

        assert.equals("road-intersections", room)
        assert.equals("id", keyId)
        assert.equals(1, key)
        assert.same({
            id = 1,
            name = "A",
            currentSwitching = "S1",
            manualSwitching = "S2",
            nextSwitching = "S3",
            ready = true,
            timeForGreen = 15,
            staticCams = { "Cam 1" }
        }, intersectionDto)
        assert.equals("road-intersection-lanes", laneRoom)
        assert.equals("id", laneKeyId)
        assert.equals("1-L1", laneKey)
        assert.same({
            id = "1-L1",
            intersectionId = 1,
            name = "L1",
            phase = "GREEN",
            vehicleMultiplier = 2,
            eepSaveId = 5,
            type = "NORMAL",
            countType = "TRACKS",
            waitingTrains = { "T1" },
            waitingForGreenCyclesCount = 4,
            directions = { "LEFT" },
            switchings = { "S1" },
            tracks = { 10 }
        }, laneDto)
        assert.equals("road-intersection-switchings", switchingRoom)
        assert.equals("id", switchingKeyId)
        assert.equals("A-S1", switchingKey)
        assert.same({ id = "A-S1", intersectionId = "A", name = "S1", prio = 1 }, switchingDto)
        assert.equals("road-intersection-traffic-lights", tlRoom)
        assert.equals("id", tlKeyId)
        assert.equals(2, tlKey)
        assert.same({
            id = 2,
            signalId = 2,
            modelId = "road",
            currentPhase = "GREEN",
            intersectionId = 1,
            lightStructures = {
                ["0"] = {
                    structureRed = "Red",
                    structureGreen = "Green",
                    structureYellow = "Yellow",
                    structureRequest = "Request"
                }
            },
            axisStructures = {
                {
                    structureName = "Axis",
                    axisName = "Signal",
                    positionDefault = 0,
                    positionRed = 1,
                    positionGreen = 2,
                    positionYellow = 3,
                    positionPedestrian = 4,
                    positionRedYellow = 5
                }
            }
        }, trafficLightDto)
        assert.equals("road-module-settings", moduleRoom)
        assert.equals("name", moduleKeyId)
        assert.equals("Show", moduleKey)
        assert.same({
            category = "Display",
            name = "Show",
            description = "Show requests",
            type = "boolean",
            value = true,
            eepFunction = "IntersectionSettings.setShowRequestsOnSignal"
        }, moduleDto)
        assert.equals("signal-type-definitions", defsRoom)
        assert.equals("id", defsKeyId)
        assert.same({
            {
                id = "road",
                name = "road",
                type = "road",
                positions = {
                    positionRed = 1,
                    positionGreen = 2,
                    positionYellow = 3,
                    positionRedYellow = 4,
                    positionPedestrians = 5,
                    positionOff = 6,
                    positionOffBlinking = 7
                }
            }
        }, defs)
    end)
end)
