if AkDebugLoad then print("[#Start] Loading ak.road.TrafficLight ...") end

local Crossing = require("ak.road.Crossing")
local AxisStructureTrafficLight = require("ak.road.AxisStructureTrafficLight")
local LightStructureTrafficLight = require("ak.road.LightStructureTrafficLight")
local TrafficLightState = require("ak.road.TrafficLightState")
local fmt = require("ak.core.eep.TippTextFormatter")

------------------------------------------------------------------------------------------
-- Klasse TrafficLight
-- Ampel mit einer festen signalId und einem festen Ampeltyp
-- Optional kann die Ampel bei Immobilien Licht ein- und ausschalten (Straba - Ampelsatz)
------------------------------------------------------------------------------------------
---@class TrafficLight
---@field type string
---@field name string
---@field signalId number
---@field trafficLightModel TrafficLightModel
---@field lightStructures table
---@field axisStructures table
---@field reason string
---@field lanes table
local TrafficLight = {}
TrafficLight.debug = AkStartWithDebug or false
local registeredSignals = {}
local counter = -1

---
---@param signalId number ID der Ampel auf der Anlage (Eine Ampel von diesem Typ sollte auf der Anlage sein)
---@param trafficLightModel TrafficLightModel Typ der Ampel (TrafficLightModel)
---@param redStructure string Immobilie fuer Signalbild gelb (Licht an / aus)
---@param greenStructure string Immobilie fuer Signalbild gelb (Licht an / aus)
---@param yellowStructure string Immobilie fuer Signalbild gelb (Licht an / aus)
---@param requestStructure string Immobilie fuer Signalbild "A" (Licht an / aus)
--
function TrafficLight:new(name, signalId, trafficLightModel, redStructure, greenStructure, yellowStructure,
                          requestStructure)
    assert(signalId, "Specify a signalId")
    assert(trafficLightModel, "Specify a trafficLightModel")
    local error = string.format("Signal ID already used: %s - %s", signalId, trafficLightModel.name)
    assert(not registeredSignals[tostring(signalId)] or registeredSignals[tostring(signalId)].trafficLightModel ==
           trafficLightModel, error)
    EEPShowInfoSignal(signalId, false)
    if signalId < 0 then counter = counter - 1 end
    local o = {
        name = name,
        signalId = signalId > 0 and signalId or counter,
        trafficLightModel = trafficLightModel,
        phase = signalId > 0 and trafficLightModel:phaseOf(EEPGetSignal(signalId)) or TrafficLightState.RED,
        debug = false,
        laneInfo = "",
        sequenceInfo = nil,
        buildInfo = "" .. tostring(signalId),
        lanes = {},
        ---@type table<LightStructureTrafficLight,boolean>
        lightStructures = {},
        ---@type table<AxisStructureTrafficLight,boolean>
        axisStructures = {},
        type = "TrafficLight"
    }
    self.__index = self
    o = setmetatable(o, self)

    if redStructure or greenStructure or yellowStructure or requestStructure then
        o:addLightStructure(redStructure, greenStructure, yellowStructure, requestStructure)
    end

    registeredSignals[tostring(signalId)] = o
    return o
end

--- Schaltet das Licht der angegebenen Immobilien beim Schalten der Ampel auf rot, gelb, gr¸n oder Anforderung
-- @param redStructure Name der Immobilie, deren Licht eingeschaltet wird, wenn die Ampel rot oder rot-gelb ist
-- @param greenStructure Name der Immobilie, deren Licht eingeschaltet wird, wenn die Ampel gr¸n ist
-- @param yellowStructure Name der Immobilie, deren Licht eingeschaltet wird, wenn die Ampel gelb oder rot-gelb ist
-- @param requestStructure Name der Immobilie, deren Licht eingeschaltet wird, wenn die Ampel eine Anforderung erkennt
--
function TrafficLight:addLightStructure(redStructure, greenStructure, yellowStructure, requestStructure)
    local lightStructure = LightStructureTrafficLight:new(redStructure, greenStructure, yellowStructure,
                                                          requestStructure)
    self.lightStructures[lightStructure] = true
    return self
end

--- ƒndert die Achsstellung der angegebenen Immobilien beim Schalten der Ampel auf rot, gelb, gr¸n oder Fuﬂg‰nger
-- @param structureName Name der Immobilie, deren Achse gesteuert werden soll
-- @param axisName Name der Achse in der Immobilie, die gesteuert werden soll
-- @param positionDefault Grundstellung der Achse (wird eingestellt, wenn eine Stellung nicht angegeben wurde
-- @param positionRed Achsstellung bei rot
-- @param positionGreen Achsstellung bei gr¸n
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

--- Aktualisiert den Text f¸r die aktuellen Schaltung dieser Ampel
-- @param sequenceInfo TippText f¸r die Schaltung
--
function TrafficLight:setSequenceInfo(sequenceInfo) self.sequenceInfo = sequenceInfo end

--- Aktualsisiert den Text f¸r die Fahrspuren dieser Ampel
-- @param laneInfo TippText f¸r die Fahrspur
--
function TrafficLight:setLaneInfo(laneInfo) self.laneInfo = laneInfo end

function TrafficLight:showInfoText(showInfo)
    if self.signalId > 0 then
        EEPShowInfoSignal(self.signalId, showInfo)
    else
        for l in pairs(self.lightStructures) do
            if l.redStructure then
                EEPShowInfoStructure(l.redStructure, showInfo)
                break
            end
        end
    end
end
function TrafficLight:changeInfoText(infoText)
    if self.signalId > 0 then
        EEPChangeInfoSignal(self.signalId, infoText)
    else
        for l in pairs(self.lightStructures) do
            if l.redStructure then
                EEPChangeInfoStructure(l.redStructure, infoText)
                break
            end
        end
    end
end

--- Stellt die vorher gesetzten Tipp-Texte dar.
--
function TrafficLight:refreshInfo()
    local showSwitching = Crossing.showSequenceOnSignal
    local showAllSignals = Crossing.showSignalIdOnSignal
    local showRequests = Crossing.showRequestsOnSignal and self.laneInfo:len() > 0
    local showInfo = showSwitching or showAllSignals or showRequests

    self:showInfoText(showInfo)
    if showInfo then

        local infoText = fmt.appendUpTo1023("", "<j><b>" .. self.name .. "</b> (Signal " .. self.signalId .. ")</j>")
        infoText = fmt.appendUpTo1023(infoText, "<br>" .. self.trafficLightModel.name)

        if showSwitching and self.sequenceInfo then
            local title = "<br><br><b>" .. "Schaltung: " .. "</b>"
            if infoText:len() > 0 then infoText = fmt.appendUpTo1023(infoText, title) end
            infoText = fmt.appendUpTo1023(infoText, self.sequenceInfo)
        end

        if showSwitching and self.phase and self.reason then
            local title = "<br><br>"
            if infoText:len() > 0 then infoText = fmt.appendUpTo1023(infoText, title) end
            infoText = fmt.appendUpTo1023(infoText, string.format(" %s (%s) ", self.phase, self.reason))
        end

        if showRequests then
            local title = "<br><br><b>" .. "Fahrspur/Wartezeit: " .. "</b>"
            if infoText:len() > 0 then infoText = fmt.appendUpTo1023(infoText, title) end
            infoText = fmt.appendUpTo1023(infoText, self.laneInfo)
        end

        self:changeInfoText(infoText)
    end
end

function TrafficLight.switchAll(trafficLights, phase, reason)
    for tl in pairs(trafficLights) do tl:switchTo(phase, reason) end
end

---
-- @param signalId ID der Ampel auf der Anlage (Eine Ampel von diesem Typ sollte auf der Anlage sein)
-- @param phase TrafficLightState.xxx
-- @param reason z.B. Name der Schaltung
--
function TrafficLight:switchTo(phase, reason)
    assert(type(phase) == "string", "Need 'phase' as string")
    self.phase = phase
    local lightDbg = self:switchStructureLight()
    local axisDbg = self:switchStructureAxis()

    local sigIndex = self.trafficLightModel:signalIndexOf(self.phase)
    if (self.debug or TrafficLight.debug) then
        print(
        string.format("[TrafficLight    ] Schalte Ampel %04d auf %s (%01d)", self.signalId, self.phase, sigIndex) ..
        lightDbg .. axisDbg .. " - " .. reason)
    end
    self:switchSignal(sigIndex)
    self:changed()
end

function TrafficLight:switchStructureLight()
    local lightDbg = ""
    for lightTL in pairs(self.lightStructures) do
        if lightTL.redStructure then
            local onOff = self.phase == TrafficLightState.RED or self.phase == TrafficLightState.REDYELLOW
            lightDbg = lightDbg .. string.format(", Licht in %s: %s", lightTL.redStructure, onOff and "an" or "aus")
            EEPStructureSetLight(lightTL.redStructure, onOff)
        end
        if lightTL.yellowStructure then
            local onOff = self.phase == TrafficLightState.YELLOW or self.phase == TrafficLightState.REDYELLOW
            lightDbg = lightDbg ..
                       string.format(", Licht in %s: %s", lightTL.yellowStructure, onOff and "an" or "aus")
            EEPStructureSetLight(lightTL.yellowStructure, onOff)
        end
        if lightTL.greenStructure then
            local onOff = self.phase == TrafficLightState.GREEN
            lightDbg = lightDbg .. string.format(", Licht in %s: %s", lightTL.greenStructure, onOff and "an" or "aus")
            EEPStructureSetLight(lightTL.greenStructure, onOff)
        end
    end
    return lightDbg
end

function TrafficLight:switchStructureAxis()
    local axisDbg = ""
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

        axisDbg = axisDbg ..
                  string.format(", Achse %s in %s auf: %d", axisTL.axisName, axisTL.structureName, position)
        EEPStructureSetAxis(axisTL.structureName, axisTL.axisName, position)
    end
    return axisDbg
end

function TrafficLight:switchSignal(sigIndex) if self.signalId > 0 then EEPSetSignal(self.signalId, sigIndex, 1) end end

--- Setzt die Anforderung fuer eine Ampel (damit sie weiﬂ, ob eine Anforderung vorliegt)
--- @param hasRequest boolean wo liegt die Anforderung an
function TrafficLight:showRequestOnSignal(hasRequest)
    local lightDbg = ""

    for lightTL in pairs(self.lightStructures) do
        if lightTL.requestStructure then
            lightDbg = lightDbg ..
                       string.format(", Licht in %s: %s", lightTL.requestStructure, (hasRequest) and "an" or "aus")
            EEPStructureSetLight(lightTL.requestStructure, hasRequest)
        end
    end

    if (self.debug or TrafficLight.debug) and lightDbg ~= "" then
        print(string.format("[TrafficLight    ] Schalte Ampel %04d", self.signalId) .. lightDbg)
    end
    self:refreshInfo()
end

function TrafficLight:print()
    print(string.format("[TrafficLight    ] Ampel %04d: %s (%s)", self.signalId, self.phase,
                        self.trafficLightModel.name))
end

function TrafficLight:changed() for lane in pairs(self.lanes) do lane:trafficLightChanged(self) end end

---@param lane Lane The lane apply this traffic light for
function TrafficLight:applyToLane(lane, ...)
    lane:driveOn(self, ...)
    if self ~= lane.trafficLight then lane.trafficLight.lanes[lane] = nil end
    self.lanes[lane] = true
end

return TrafficLight
