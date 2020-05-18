print("Loading ak.road.TrafficLight ...")

local Crossing = require("ak.road.Crossing")
local AxisStructureTrafficLight = require("ak.road.AxisStructureTrafficLight")
local LightStructureTrafficLight = require("ak.road.LightStructureTrafficLight")
local TrafficLightState = require("ak.road.TrafficLightState")
local fmt = require("ak.core.eep.AkTippTextFormat")

------------------------------------------------------------------------------------------
-- Klasse TrafficLight
-- Ampel mit einer festen signalId und einem festen Ampeltyp
-- Optional kann die Ampel bei Immobilien Licht ein- und ausschalten (Straba - Ampelsatz)
------------------------------------------------------------------------------------------
---@class TrafficLight
local TrafficLight = {}
TrafficLight.debug = AkStartMitDebug or false
local registeredSignals = {}

---
---@param signalId number ID der Ampel auf der Anlage (Eine Ampel von diesem Typ sollte auf der Anlage sein
---@param trafficLightModel TrafficLightModel Typ der Ampel (TrafficLightModel)
---@param redStructure string Immobilie fuer Signalbild gelb (Licht an / aus)
---@param greenStructure string Immobilie fuer Signalbild gelb (Licht an / aus)
---@param yellowStructure string Immobilie fuer Signalbild gelb (Licht an / aus)
---@param requestStructure string Immobilie fuer Signalbild "A" (Licht an / aus)
--
function TrafficLight:new(signalId, trafficLightModel, redStructure, greenStructure, yellowStructure, requestStructure)
    assert(signalId, "Specify a signalId")
    assert(trafficLightModel, "Specify a trafficLightModel")
    local error = string.format("Signal ID already used: %s - %s", signalId, trafficLightModel.name)
    assert(not registeredSignals[tostring(signalId)] or registeredSignals[tostring(signalId)].trafficLightModel ==
               trafficLightModel, error)
    EEPShowInfoSignal(signalId, false)
    local o = {
        signalId = signalId,
        trafficLightModel = trafficLightModel,
        phase = TrafficLightState.RED,
        hasRequest = false,
        debug = false,
        laneInfo = "",
        circuitInfo = "",
        buildInfo = "" .. tostring(signalId),
        lanes = {},
        ---@type table<LightStructureTrafficLight,boolean>
        lightStructures = {},
        ---@type table<AxisStructureTrafficLight,boolean>
        axisStructures = {}
    }
    self.__index = self
    o = setmetatable(o, self)

    if redStructure or greenStructure or yellowStructure or requestStructure then
        o:addLightStructure(redStructure, greenStructure, yellowStructure, requestStructure)
    end

    registeredSignals[tostring(signalId)] = o
    return o
end

--- Schaltet das Licht der angegebenen Immobilien beim Schalten der Ampel auf rot, gelb, grün oder Anforderung
-- @param redStructure Name der Immobilie, deren Licht eingeschaltet wird, wenn die Ampel rot oder rot-gelb ist
-- @param greenStructure Name der Immobilie, deren Licht eingeschaltet wird, wenn die Ampel grün ist
-- @param yellowStructure Name der Immobilie, deren Licht eingeschaltet wird, wenn die Ampel gelb oder rot-gelb ist
-- @param requestStructure Name der Immobilie, deren Licht eingeschaltet wird, wenn die Ampel eine Anforderung erkennt
--
function TrafficLight:addLightStructure(redStructure, greenStructure, yellowStructure, requestStructure)
    local lightStructure = LightStructureTrafficLight:new(redStructure, greenStructure, yellowStructure,
                                                          requestStructure)
    self.lightStructures[lightStructure] = true
    return self
end

--- Ändert die Achsstellung der angegebenen Immobilien beim Schalten der Ampel auf rot, gelb, grün oder Fußgänger
-- @param structureName Name der Immobilie, deren Achse gesteuert werden soll
-- @param axisName Name der Achse in der Immobilie, die gesteuert werden soll
-- @param positionDefault Grundstellung der Achse (wird eingestellt, wenn eine Stellung nicht angegeben wurde
-- @param positionRed Achsstellung bei rot
-- @param positionGreen Achsstellung bei grün
-- @param positionYellow Achsstellung bei gelb
-- @param positionRedYellow Achsstellung bei gelbrot
-- @param positionPedestrian Achsstellung bei FG
--
function TrafficLight:addAxisStructure(structureName, axisName, positionDefault, positionRed, positionGreen,
                                       positionRedYellow, positionPedestrian)
    local axisStructure = AxisStructureTrafficLight:new(structureName, axisName, positionDefault, positionRed,
                                                        positionGreen, positionRedYellow, positionPedestrian)
    self.axisStructures[axisStructure] = true
    return self
end

--- Aktualisiert den Text für die aktuellen Schaltung dieser Ampel
-- @param circuitInfo TippText für die Schaltung
--
function TrafficLight:setCircuitInfo(circuitInfo) self.circuitInfo = circuitInfo end

--- Aktualsisiert den Text für die Richtungen dieser Ampel
-- @param laneInfo TippText für die Richtung
--
function TrafficLight:setLaneInfo(laneInfo) self.laneInfo = laneInfo end

--- Stellt die vorher gesetzten Tipp-Texte dar.
--
function TrafficLight:refreshInfo()
    local showRequests = Crossing.zeigeAnforderungenAlsInfo
    local showSwitching = Crossing.zeigeSchaltungAlsInfo
    local showAllSignals = Crossing.zeigeSignalIdsAllerSignale
    local showInfo = showRequests or showSwitching or showAllSignals

    EEPShowInfoSignal(self.signalId, showInfo)
    if showInfo then
        local infoText = "<j><b>Ampel ID: " .. fmt.hintergrund_grau(self.signalId) .. "</b></j>"
        infoText = infoText .. "<br>" .. self.trafficLightModel.name

        if Crossing.zeigeSchaltungAlsInfo then
            if infoText:len() > 0 then infoText = infoText .. "<br>___________________________<br>" end
            infoText = infoText .. self.circuitInfo
        end

        if showSwitching and self.phase and self.grund then
            if infoText:len() > 0 then infoText = infoText .. "<br><br>" end
            infoText = infoText .. string.format(" %s (%s) ", self.phase, self.grund)
        end

        if showRequests then
            if infoText:len() > 0 then infoText = infoText .. "<br>___________________________<br>" end
            infoText = infoText .. self.laneInfo
        end
        assert(infoText:len() < 1023)
        EEPChangeInfoSignal(self.signalId, infoText)
    end
end

---
-- @param signalId ID der Ampel auf der Anlage (Eine Ampel von diesem Typ sollte auf der Anlage sein)
-- @param phase TrafficLightState.xxx
-- @param grund z.B. Name der Schaltung
--
function TrafficLight:switchTo(phase, grund)
    assert(phase)
    self.phase = phase
    local lightDbg = self:switchStructureLight()
    local structureDbg = self:switchStructureAxis()

    local sigIndex = self.trafficLightModel:signalIndexFuer(self.phase)
    if (self.debug or TrafficLight.debug) then
        print(
            string.format("[TrafficLight    ] Schalte Ampel %04d auf %s (%01d)", self.signalId, self.phase, sigIndex) ..
                lightDbg .. structureDbg .. " - " .. grund)
    end
    self:switchSignal(sigIndex)
end

function TrafficLight:switchStructureLight()
    local immoDbg = ""
    for lightTL in pairs(self.lightStructures) do
        if lightTL.redStructure then
            immoDbg = immoDbg .. string.format(", Licht in %s: %s", lightTL.redStructure, (self.phase ==
                                                   TrafficLightState.RED or self.phase == TrafficLightState.REDYELLOW) and
                                                   "an" or "aus")
            EEPStructureSetLight(lightTL.redStructure,
                                 self.phase == TrafficLightState.RED or self.phase == TrafficLightState.REDYELLOW)
        end
        if lightTL.yellowStructure then
            immoDbg = immoDbg .. string.format(", Licht in %s: %s", lightTL.yellowStructure, (self.phase ==
                                                   TrafficLightState.YELLOW or self.phase == TrafficLightState.REDYELLOW) and
                                                   "an" or "aus")
            EEPStructureSetLight(lightTL.yellowStructure,
                                 self.phase == TrafficLightState.YELLOW or self.phase == TrafficLightState.REDYELLOW)
        end
        if lightTL.greenStructure then
            immoDbg = immoDbg ..
                          string.format(", Licht in %s: %s", lightTL.greenStructure,
                                        (self.phase == TrafficLightState.GREEN) and "an" or "aus")
            EEPStructureSetLight(lightTL.greenStructure, self.phase == TrafficLightState.GREEN)
        end
    end
    return immoDbg
end

function TrafficLight:switchStructureAxis()
    local immoDbg = ""
    for axisTL in pairs(self.axisStructures) do
        local position = axisTL.positionDefault

        if axisTL.positionRedYellow and self.phase == TrafficLightState.REDYELLOW then
            position = axisTL.positionRedYellow
        elseif axisTL.positionRed and
            (self.phase == TrafficLightState.YELLOW or self.phase == TrafficLightState.REDYELLOW) then
            position = axisTL.positionRed
        elseif axisTL.positionRed and self.phase == TrafficLightState.RED then
            position = axisTL.positionRed
        elseif axisTL.positionGreen and self.phase == TrafficLightState.GREEN then
            position = axisTL.positionGreen
        elseif axisTL.positionPedestrian and self.phase == TrafficLightState.PEDESTRIAN then
            position = axisTL.positionPedestrian
        end

        immoDbg = immoDbg .. string.format(", Achse %s in %s auf: %d", axisTL.axisName, axisTL.structureName, position)
        EEPStructureSetAxis(axisTL.structureName, axisTL.axisName, position)
    end
    return immoDbg
end

function TrafficLight:switchSignal(sigIndex) EEPSetSignal(self.signalId, sigIndex, 1) end

--- Setzt die Anforderung fuer eine Ampel (damit sie weiß, ob eine Anforderung vorliegt)
--- @param lane Lane, für welche die Anforderung vorliegt
function TrafficLight:refreshRequests(lane)
    local immoDbg = ""
    self.lanes[lane] = true
    local hasRequest = lane:hasRequest()

    for lightTL in pairs(self.lightStructures) do
        if lightTL.requestStructure then
            immoDbg = immoDbg ..
                          string.format(", Licht in %s: %s", lightTL.requestStructure, (hasRequest) and "an" or "aus")
            EEPStructureSetLight(lightTL.requestStructure, hasRequest)
        end
    end

    if (self.debug or TrafficLight.debug) and immoDbg ~= "" then
        print(string.format("[TrafficLight    ] Schalte Ampel %04d", self.signalId) .. immoDbg)
    end
    self:refreshInfo()
end

function TrafficLight:print()
    print(
        string.format("[TrafficLight    ] Ampel %04d: %s (%s)", self.signalId, self.phase, self.trafficLightModel.name))
end

return TrafficLight
