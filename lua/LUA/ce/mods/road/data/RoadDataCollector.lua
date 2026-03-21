if AkDebugLoad then print("[#Start] Loading ce.mods.road.data.RoadDataCollector ...") end
local IntersectionSettings = require("ce.mods.road.IntersectionSettings")
local Lane = require("ce.mods.road.Lane")
local TrafficLightState = require("ce.mods.road.TrafficLightState")

local RoadDataCollector = {}

local function padnum(d)
    local dec, n = string.match(d, "(%.?)0*(.+)")
    return #dec > 0 and ("%.12f"):format(d) or ("%s%03d%s"):format(dec, #n, n)
end

function RoadDataCollector.collectCrossings(allCrossings)
    local intersections = {}
    local intersectionLanes = {}
    local intersectionSwitchings = {}
    local intersectionTrafficLights = {}
    local allLanes = {}
    local laneSwitchings = {}

    local intersectionIdCounter = 0
    local sortedNames = {}
    for name in pairs(allCrossings) do table.insert(sortedNames, name) end
    table.sort(sortedNames, function(a, b) return a < b end)

    for _, name in ipairs(sortedNames) do
        local crossing = allCrossings[name]
        intersectionIdCounter = intersectionIdCounter + 1
        local intersection = {
            id = intersectionIdCounter,
            name = crossing.name,
            currentSwitching = crossing:getCurrentSequence() and crossing:getCurrentSequence().name or nil,
            manualSwitching = crossing:getManualSequence() and crossing:getManualSequence().name or nil,
            nextSwitching = crossing:getNextSequence() and crossing:getNextSequence().name or nil,
            ready = crossing:isGreenPhaseFinished(),
            timeForGreen = crossing:getGreenPhaseSeconds(),
            staticCams = crossing:getStaticCams()
        }
        table.insert(intersections, intersection)

        local trafficLights = {}
        for _, switching in ipairs(crossing:getSequences()) do
            table.insert(intersectionSwitchings, {
                id = crossing.name .. "-" .. switching.name,
                intersectionId = crossing.name,
                name = switching.name,
                prio = switching.prio
            })

            for lane in pairs(switching.lanes) do
                allLanes[lane] = intersection.id
                laneSwitchings[lane] = laneSwitchings[lane] or {}
                table.insert(laneSwitchings[lane], switching.name)
            end

            for trafficLight in pairs(switching.trafficLights) do trafficLights[trafficLight] = true end
        end

        for tl in pairs(trafficLights) do
            local trafficLight = {
                id = tl.signalId,
                signalId = tl.signalId,
                modelId = tl.trafficLightModel.name,
                currentPhase = tl.phase,
                intersectionId = intersectionIdCounter,
                lightStructures = {},
                axisStructures = {}
            }

            for axisStructure in pairs(tl.axisStructures) do
                table.insert(trafficLight.axisStructures, {
                    structureName = axisStructure.structureName,
                    axisName = axisStructure.axisName,
                    positionDefault = axisStructure.positionDefault,
                    positionRed = axisStructure.positionRed,
                    positionGreen = axisStructure.positionGreen,
                    positionYellow = axisStructure.positionYellow,
                    positionPedestrian = axisStructure.positionPedestrian,
                    positionRedYellow = axisStructure.positionRedYellow
                })
            end

            local lightStructureId = 0
            for lightStructure in pairs(tl.lightStructures) do
                trafficLight.lightStructures[tostring(lightStructureId)] = {
                    structureRed = lightStructure.redStructure,
                    structureGreen = lightStructure.greenStructure,
                    structureYellow = lightStructure.yellowStructure or lightStructure.redStructure,
                    structureRequest = lightStructure.requestStructure
                }
                lightStructureId = lightStructureId + 1
            end

            table.insert(intersectionTrafficLights, trafficLight)
        end
    end

    for lane, intersectionId in pairs(allLanes) do
        local laneType
        if lane.requestType == Lane.RequestType.FUSSGAENGER then
            laneType = "PEDESTRIAN"
        elseif lane.trafficType == "TRAM" then
            laneType = "TRAM"
        else
            laneType = "NORMAL"
        end

        local phase = "NONE"
        if lane.phase == TrafficLightState.YELLOW then
            phase = "YELLOW"
        elseif lane.phase == TrafficLightState.RED then
            phase = "RED"
        elseif lane.phase == TrafficLightState.REDYELLOW then
            phase = "RED_YELLOW"
        elseif lane.phase == TrafficLightState.GREEN then
            phase = "GREEN"
        elseif lane.phase == TrafficLightState.PEDESTRIAN then
            phase = "PEDESTRIAN"
        end

        local countType = "CONTACTS"
        if lane.signalUsedForRequest then
            countType = "SIGNALS"
        elseif lane.tracksUsedForRequest then
            countType = "TRACKS"
        end

        local dto = {
            id = intersectionId .. "-" .. lane.name,
            intersectionId = intersectionId,
            name = lane.name,
            phase = phase,
            vehicleMultiplier = lane.fahrzeugMultiplikator,
            eepSaveId = lane.eepSaveId,
            type = laneType,
            countType = countType,
            waitingTrains = {},
            waitingForGreenCyclesCount = lane.waitCount,
            directions = lane.directions,
            switchings = laneSwitchings[lane] or {},
            tracks = lane.tracksForHighlighting or {}
        }
        for i, value in pairs(lane.queue:elements()) do dto.waitingTrains[i] = value end
        table.insert(intersectionLanes, dto)
    end

    table.sort(intersectionLanes, function(a, b)
        return tostring(a.name):gsub("%.?%d+", padnum) .. ("%3d"):format(#b.name) <
            tostring(b.name):gsub("%.?%d+", padnum) .. ("%3d"):format(#a.name)
    end)

    return {
        intersections = intersections,
        intersectionLanes = intersectionLanes,
        intersectionSwitchings = intersectionSwitchings,
        intersectionTrafficLights = intersectionTrafficLights
    }
end

function RoadDataCollector.collectModuleSettings()
    return {
        {
            category = "Tipp-Texte fuer Kreuzungen",
            name = "Anforderungen einblenden",
            description = "Zeigt fuer alle Ampeln einen TippText mit den Anforderungen",
            type = "boolean",
            value = IntersectionSettings.showRequestsOnSignal,
            eepFunction = "IntersectionSettings.setShowRequestsOnSignal"
        },
        {
            category = "Tipp-Texte fuer Kreuzungen",
            name = "Schaltungen einblenden",
            description = "Zeigt fuer alle Ampeln einen TippText mit den Schaltungen",
            type = "boolean",
            value = IntersectionSettings.showSequenceOnSignal,
            eepFunction = "IntersectionSettings.setShowSequenceOnSignal"
        },
        {
            category = "Tipp-Texte fuer Kreuzungen",
            name = "Fahrspurzaehler einblenden",
            description = "Zeigt die Belegung der Fahrspuren an einer Kreuzung",
            type = "boolean",
            value = IntersectionSettings.showLanesOnStructure,
            eepFunction = "IntersectionSettings.setShowLanesOnStructure"
        },
        {
            category = "Tipp-Texte fuer Signale (allgemein)",
            name = "Signal-ID einblenden",
            description = "Zeigt an jedem Signal dessen Nummer als TippText",
            type = "boolean",
            value = IntersectionSettings.showSignalIdOnSignal,
            eepFunction = "IntersectionSettings.setShowSignalIdOnSignal"
        }
    }
end

return RoadDataCollector
