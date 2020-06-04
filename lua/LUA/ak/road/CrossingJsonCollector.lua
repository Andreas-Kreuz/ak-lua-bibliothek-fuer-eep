if AkDebugLoad then print("Loading ak.road.CrossingJsonCollector ...") end

---@class CrossingJsonCollector
CrossingJsonCollector = {}
local enabled = true
local initialized = false
CrossingJsonCollector.name = "ak.data.CrossingJsonCollector"
local Crossing = require("ak.road.Crossing")
local Lane = require("ak.road.Lane")
local TrafficLightState = require("ak.road.TrafficLightState")

---@param alleKreuzungen table<string,Crossing>
local function collect(alleKreuzungen)
    local intersections = {}
    local intersectionLanes = {}
    local intersectionSwitching = {}
    local intersectionTrafficLights = {}
    -- @type table<Lane,string>
    local alleRichtungen = {}
    local richtungsSchaltungen = {}

    local intersectionIdCounter = 0
    -- FIXME table.sort(alleKreuzungen, function(a, b) return a.name < b.name end)

    for _, crossing in pairs(alleKreuzungen) do
        intersectionIdCounter = intersectionIdCounter + 1
        local intersection = {
            id = intersectionIdCounter,
            name = crossing.name,
            currentSwitching = crossing.aktuelleSchaltung and crossing.aktuelleSchaltung.name or nil,
            manualSwitching = crossing.manuelleSchaltung and crossing.manuelleSchaltung.name or nil,
            nextSwitching = crossing.nextSchaltung and crossing.nextSchaltung.name or nil,
            ready = crossing.bereit,
            timeForGreen = crossing.gruenZeit,
            staticCams = crossing.staticCams
        }
        table.insert(intersections, intersection)

        local trafficLights = {}

        for schaltung in pairs(crossing:getSchaltungen()) do
            local switching = {
                id = crossing.name .. "-" .. schaltung.name,
                intersectionId = crossing.name,
                name = schaltung.name,
                prio = schaltung.prio
            }
            table.insert(intersectionSwitching, switching)

            for lane in pairs(schaltung:getAlleRichtungen()) do
                alleRichtungen[lane] = intersection.id
                richtungsSchaltungen[lane] = richtungsSchaltungen[lane] or {}
                table.insert(richtungsSchaltungen[lane], schaltung.name)
            end

            for id, trafficLight in pairs(schaltung.trafficLights) do trafficLights[id] = trafficLight end
            for id, trafficLight in pairs(schaltung.pedestrianLights) do trafficLights[id] = trafficLight end
        end

        for _, tl in pairs(trafficLights) do
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
                local as = {
                    structureName = axisStructure.structureName,
                    axisName = axisStructure.axisName,
                    positionDefault = axisStructure.positionDefault,
                    positionRed = axisStructure.positionRed,
                    positionGreen = axisStructure.positionGreen,
                    positionYellow = axisStructure.positionYellow,
                    positionPedestrian = axisStructure.positionPedestrian,
                    positionRedYellow = axisStructure.positionRedYellow
                }
                table.insert(trafficLight.axisStructures, as)
            end

            local lsId = 0
            for lightStructure in pairs(tl.lightStructures) do
                local ls = {
                    structureRed = lightStructure.redStructure,
                    structureGreen = lightStructure.greenStructure,
                    structureYellow = lightStructure.yellowStructure or lightStructure.redStructure,
                    structureRequest = lightStructure.requestStructure
                }
                trafficLight.lightStructures[tostring(lsId)] = ls
                lsId = lsId + 1
            end

            table.insert(intersectionTrafficLights, trafficLight)
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
            waitingForGreenCyclesCount = lane.waitCount,
            directions = lane.directions,
            switchings = richtungsSchaltungen[lane] or {}
        }
        for i, f in pairs(lane.queue:elements()) do o.waitingTrains[i] = f end
        table.insert(intersectionLanes, o)
    end

    local function padnum(d)
        local dec, n = string.match(d, "(%.?)0*(.+)")
        return #dec > 0 and ("%.12f"):format(d) or ("%s%03d%s"):format(dec, #n, n)
    end

    table.sort(intersectionLanes, function(o1, o2)
        local a = o1.name
        local b = o2.name

        return tostring(a):gsub("%.?%d+", padnum) .. ("%3d"):format(#b) < tostring(b):gsub("%.?%d+", padnum) ..
                   ("%3d"):format(#a)
    end)

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
        }, {
            ["category"] = "Kreuzung",
            ["name"] = "Schaltungen als TippText",
            ["description"] = "Zeigt für alle Ampeln einen TippText mit den Schaltungen",
            ["type"] = "boolean",
            ["value"] = Crossing.zeigeSchaltungAlsInfo,
            ["eepFunction"] = "Crossing.setZeigeSchaltungAlsInfo"
        }, {
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
    if not enabled or initialized then return end

    initialized = true
end

function CrossingJsonCollector.collectData()
    if not enabled then return end

    if not initialized then CrossingJsonCollector.initialize() end

    local data = collect(Crossing.alleKreuzungen)
    data["intersection-module-settings"] = collectModuleSettings()
    return data
end

return CrossingJsonCollector
