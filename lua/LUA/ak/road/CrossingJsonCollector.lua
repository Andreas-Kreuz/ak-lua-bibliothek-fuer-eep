print("Lade ak.road.CrossingJsonCollector ...")
CrossingJsonCollector = {}
local enabled = true
local initialized = false
CrossingJsonCollector.name = "ak.data.CrossingJsonCollector"
local Crossing = require("ak.road.Crossing")
local Lane = require("ak.road.Lane")
local TrafficLightState = require("ak.road.TrafficLightState")

local function collect(alleKreuzungen)
    local intersections = {}
    local intersectionLanes = {}
    local intersectionSwitching = {}
    local intersectionTrafficLights = {}
    local alleRichtungen = {}
    local richtungsSchaltungen = {}

    local intersectionIdCounter = 0
    for _, kreuzung in pairs(alleKreuzungen) do
        intersectionIdCounter = intersectionIdCounter + 1
        local intersection = {
            id = intersectionIdCounter,
            name = kreuzung.name,
            currentSwitching = kreuzung.aktuelleSchaltung and kreuzung.aktuelleSchaltung.name or nil,
            manualSwitching = kreuzung.manuelleSchaltung and kreuzung.manuelleSchaltung.name or nil,
            nextSwitching = kreuzung.nextSchaltung and kreuzung.nextSchaltung.name or nil,
            ready = kreuzung.bereit,
            timeForGreen = kreuzung.gruenZeit,
            staticCams = kreuzung.staticCams
        }
        table.insert(intersections, intersection)

        for schaltung in pairs(kreuzung:getSchaltungen()) do
            local switching = {
                id = kreuzung.name .. "-" .. schaltung.name,
                intersectionId = kreuzung.name,
                name = schaltung.name,
                prio = schaltung.prio
            }
            table.insert(intersectionSwitching, switching)

            for richtung in pairs(schaltung:getAlleRichtungen()) do
                alleRichtungen[richtung] = intersection.id
                richtungsSchaltungen[richtung] = richtungsSchaltungen[richtung] or {}
                table.insert(richtungsSchaltungen[richtung], schaltung.name)
            end
        end
    end

    for lane, intersectionId in pairs(alleRichtungen) do
        local type
        if (lane.schaltungsTyp == Lane.SchaltungsTyp.FUSSGAENGER) then
            type = "PEDESTRIAN"
        elseif (lane.trafficType == "TRAM") then
            type = "TRAM"
        else
            type = "NORMAL"
        end

        local phase = "NONE"
        if lane.phase == TrafficLightState.GELB then
            phase = "YELLOW"
        elseif lane.phase == TrafficLightState.ROT then
            phase = "RED"
        elseif lane.phase == TrafficLightState.ROTGELB then
            phase = "RED_YELLOW"
        elseif lane.phase == TrafficLightState.GRUEN then
            phase = "GREEN"
        elseif lane.phase == TrafficLightState.FG then
            phase = "PEDESTRIAN"
        end

        local countType = "CONTACTS"
        if lane.verwendeZaehlAmpeln then
            countType = "SIGNALS"
        elseif lane.verwendeZaehlStrassen then
            countType = "TRACKS"
        end

        local o = {
            id = intersectionId .. "-" .. lane.name,
            intersectionId = intersectionId,
            name = lane.name,
            phase = phase,
            vehicleMultiplier = lane.fahrzeugMultiplikator,
            eepSaveId = lane.eepSaveId,
            type = type,
            countType = countType,
            waitingTrains = {},
            waitingForGreenCyclesCount = lane.warteZeit,
            directions = lane.richtungen,
            switchings = richtungsSchaltungen[lane] or {}
        }
        for i = 1, lane.fahrzeuge or 1, 1 do
            o.waitingTrains[i] = "?"
        end
        table.insert(intersectionLanes, o)

        for _, ampel in pairs(lane.ampeln) do
            local trafficLight = {
                id = ampel.signalId,
                type = type,
                signalId = ampel.signalId,
                modelId = ampel.ampelTyp.name,
                currentPhase = ampel.phase,
                laneId = lane.name,
                intersectionId = intersectionId,
                lightStructures = {},
                axisStructures = {}
            }

            for axisStructure in pairs(ampel.achsenImmos) do
                local as = {
                    structureName = axisStructure.immoName,
                    axis = axisStructure.achse,
                    positionDefault = axisStructure.grundStellung,
                    positionRed = axisStructure.stellungRot,
                    positionGreen = axisStructure.stellungGruen,
                    positionYellow = axisStructure.stellungGelb,
                    positionPedestrants = axisStructure.stellungFG,
                    positionRedYellow = axisStructure.stellungRotGelb
                }
                table.insert(trafficLight.axisStructures, as)
            end

            local lsId = 0
            for lightStructure in pairs(ampel.lichtImmos) do
                local ls = {
                    structureRed = lightStructure.rotImmo,
                    structureGreen = lightStructure.gruenImmo,
                    structureYellow = lightStructure.gelbImmo or lightStructure.rotImmo,
                    structureRequest = lightStructure.anforderungImmo
                }
                trafficLight.lightStructures[tostring(lsId)] = ls
                lsId = lsId + 1
            end

            table.insert(intersectionTrafficLights, trafficLight)
        end
    end

    local function padnum(d)
        local dec, n = string.match(d, "(%.?)0*(.+)")
        return #dec > 0 and ("%.12f"):format(d) or ("%s%03d%s"):format(dec, #n, n)
    end

    table.sort(
        intersectionLanes,
        function(o1, o2)
            local a = o1.name
            local b = o2.name

            return tostring(a):gsub("%.?%d+", padnum) .. ("%3d"):format(#b) <
                tostring(b):gsub("%.?%d+", padnum) .. ("%3d"):format(#a)
        end
    )

    return {
        ["intersections"] = intersections,
        ["intersection-lanes"] = intersectionLanes,
        ["intersection-switchings"] = intersectionSwitching,
        ["intersection-traffic-lights"] = intersectionTrafficLights
    }
end
local function collectModuleSettings()
    return {
        {
            ["category"] = "Kreuzung",
            ["name"] = "Anforderungen als TippText",
            ["description"] = "Zeigt für alle Ampeln einen TippText mit den Anforderungen",
            ["type"] = "boolean",
            ["value"] = Crossing.zeigeAnforderungenAlsInfo,
            ["eepFunction"] = "Crossing.setZeigeAnforderungenAlsInfo"
        },
        {
            ["category"] = "Kreuzung",
            ["name"] = "Schaltungen als TippText",
            ["description"] = "Zeigt für alle Ampeln einen TippText mit den Schaltungen",
            ["type"] = "boolean",
            ["value"] = Crossing.zeigeSchaltungAlsInfo,
            ["eepFunction"] = "Crossing.setZeigeSchaltungAlsInfo"
        },
        {
            ["category"] = "Signale",
            ["name"] = "Signal-ID als TippText",
            ["description"] = "Zeigt an jedem Signal dessen Nummer als TippText",
            ["type"] = "boolean",
            ["value"] = Crossing.zeigeSignalIdsAllerSignale,
            ["eepFunction"] = "Crossing.setZeigeSignalIdsAllerSignale"
        }
    }
end

function CrossingJsonCollector.initialize()
    if not enabled or initialized then
        return
    end

    initialized = true
end

function CrossingJsonCollector.collectData()
    if not enabled then
        return
    end

    if not initialized then
        CrossingJsonCollector.initialize()
    end

    local data = collect(Crossing.alleKreuzungen)
    data["intersection-module-settings"] = collectModuleSettings()
    return data
end

return CrossingJsonCollector
