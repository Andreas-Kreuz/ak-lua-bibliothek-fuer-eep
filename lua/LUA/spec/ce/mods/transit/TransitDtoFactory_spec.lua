insulate("ce.mods.transit.data.TransitDtoFactory", function ()
    local function clearModule(name) package.loaded[name] = nil end

    before_each(function ()
        clearModule("ce.mods.transit.data.TransitDtoFactory")
    end)

    it("provides metadata for public transport DTO lists", function ()
        local TransitDtoFactory = require("ce.mods.transit.data.TransitDtoFactory")

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
        local room, keyId, key, lineDto = TransitDtoFactory.createTransitLineDto(line)
        local stationRoom, stationKeyId, stationKey, stationDto =
            TransitDtoFactory.createTransitStationDto({ id = "Station A", name = "ignored" })
        local settingsRoom, settingsKeyId, settingsDtos =
            TransitDtoFactory.createTransitModuleSettingDtoList({
                {
                    category = "Display",
                    name = "Next",
                    description = "Show next departures",
                    type = "boolean",
                    value = true,
                    eepFunction = "TransitSettings.setShowDepartureTippText",
                    hidden = true
                }
            })

        line.nr = "11"
        line.lineSegments[1].stations[1].station.name = "Changed"

        assert.equals("transit-lines", room)
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
        assert.equals("transit-stations", stationRoom)
        assert.equals("id", stationKeyId)
        assert.equals("Station A", stationKey)
        assert.same({ id = "Station A" }, stationDto)
        assert.equals("transit-module-settings", settingsRoom)
        assert.equals("name", settingsKeyId)
        assert.same({
            {
                category = "Display",
                name = "Next",
                description = "Show next departures",
                type = "boolean",
                value = true,
                eepFunction = "TransitSettings.setShowDepartureTippText"
            }
        }, settingsDtos)
    end)
end)
