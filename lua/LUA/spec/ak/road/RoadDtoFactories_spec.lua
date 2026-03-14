insulate("ak.road.RoadDtoFactories", function ()
    local function clearModule(name) package.loaded[name] = nil end

    before_each(function ()
        clearModule("ak.road.CrossingDtoFactory")
        clearModule("ak.road.TrafficLightModelDtoFactory")
    end)

    it("provides metadata for road DTO lists", function ()
        local CrossingDtoFactory = require("ak.road.CrossingDtoFactory")
        local TrafficLightModelDtoFactory = require("ak.road.TrafficLightModelDtoFactory")

        local intersection = { id = 1, name = "A" }
        local room, keyId, key, intersectionDto = CrossingDtoFactory.createIntersectionDto(intersection)
        local defsRoom, defsKeyId, defs =
            TrafficLightModelDtoFactory.createSignalTypeDefinitionDtoList({ { id = "road", positions = {} } })

        intersection.name = "B"

        assert.equals("intersections", room)
        assert.equals("id", keyId)
        assert.equals(1, key)
        assert.same({ id = 1, name = "A" }, intersectionDto)
        assert.equals("signal-type-definitions", defsRoom)
        assert.equals("id", defsKeyId)
        assert.same({ { id = "road", positions = {} } }, defs)
    end)
end)
