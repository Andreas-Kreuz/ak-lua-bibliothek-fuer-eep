insulate("ak.public-transport.PublicTransportDtoFactory", function ()
    local function clearModule(name) package.loaded[name] = nil end

    before_each(function ()
        clearModule("ak.public-transport.PublicTransportDtoFactory")
    end)

    it("provides metadata for public transport DTO lists", function ()
        local PublicTransportDtoFactory = require("ak.public-transport.PublicTransportDtoFactory")

        local line = { id = "10", nr = "10", trafficType = "BUS", lineSegments = {} }
        local room, keyId, key, lineDto = PublicTransportDtoFactory.createPublicTransportLineDto(line)
        local settingsRoom, settingsKeyId, settingsDtos =
            PublicTransportDtoFactory.createPublicTransportModuleSettingDtoList({
                { name = "Next", type = "boolean", value = true }
            })

        line.nr = "11"

        assert.equals("public-transport-lines", room)
        assert.equals("id", keyId)
        assert.equals("10", key)
        assert.same({ id = "10", nr = "10", trafficType = "BUS", lineSegments = {} }, lineDto)
        assert.equals("public-transport-module-settings", settingsRoom)
        assert.equals("name", settingsKeyId)
        assert.same({ { name = "Next", type = "boolean", value = true } }, settingsDtos)
    end)
end)
