insulate("ce.mods.public-transport.data.PublicTransportDtoFactory", function ()
    local function clearModule(name) package.loaded[name] = nil end

    before_each(function ()
        clearModule("ce.mods.public-transport.data.PublicTransportDtoFactory")
    end)

    it("provides metadata for public transport DTO lists", function ()
        local PublicTransportDtoFactory = require("ce.mods.public-transport.data.PublicTransportDtoFactory")

        local line = {
            id = "10",
            nr = "10",
            trafficType = "BUS",
            hidden = true,
            lineSegments = {
                {
                    id = "route-10",
                    destination = "Central",
                    routeName = "Route 10",
                    lineNr = "10",
                    hidden = true,
                    stations = {
                        {
                            station = { name = "Station A", hidden = true },
                            timeToStation = 3,
                            hidden = true
                        }
                    }
                }
            }
        }
        local room, keyId, key, lineDto = PublicTransportDtoFactory.createPublicTransportLineDto(line)
        local stationRoom, stationKeyId, stationKey, stationDto =
            PublicTransportDtoFactory.createPublicTransportStationDto({ id = "Station A", name = "ignored" })
        local settingsRoom, settingsKeyId, settingsDtos =
            PublicTransportDtoFactory.createPublicTransportModuleSettingDtoList({
                {
                    category = "Display",
                    name = "Next",
                    description = "Show next departures",
                    type = "boolean",
                    value = true,
                    eepFunction = "PublicTransportSettings.setShowDepartureTippText",
                    hidden = true
                }
            })

        line.nr = "11"
        line.lineSegments[1].stations[1].station.name = "Changed"

        assert.equals("public-transport-lines", room)
        assert.equals("id", keyId)
        assert.equals("10", key)
        assert.same({
            id = "10",
            nr = "10",
            trafficType = "BUS",
            lineSegments = {
                {
                    id = "route-10",
                    destination = "Central",
                    routeName = "Route 10",
                    lineNr = "10",
                    stations = {
                        {
                            station = { name = "Station A" },
                            timeToStation = 3
                        }
                    }
                }
            }
        }, lineDto)
        assert.equals("public-transport-stations", stationRoom)
        assert.equals("id", stationKeyId)
        assert.equals("Station A", stationKey)
        assert.same({ id = "Station A" }, stationDto)
        assert.equals("public-transport-module-settings", settingsRoom)
        assert.equals("name", settingsKeyId)
        assert.same({
            {
                category = "Display",
                name = "Next",
                description = "Show next departures",
                type = "boolean",
                value = true,
                eepFunction = "PublicTransportSettings.setShowDepartureTippText"
            }
        }, settingsDtos)
    end)
end)
