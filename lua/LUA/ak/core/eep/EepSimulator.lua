if AkDebugLoad then print("[#Start] Loading ak.core.eep.EepSimulator ...") end

----------------
-- EEP Simulator
----------------

-- Hinweis:
-- Die EEP-Systemfunktionen print() wird im Simulator bewusst
-- nicht simuliert.
-- - print() bleibt die normale globale Lua-Funktion der Host-Umgebung.


--- Versionsnummer von EEP.
EEPVer = 16.3

local EepSimulator = {}
EepSimulator.debug = false
local Runtime = require("ak.core.eep.EepSimulatorRuntime").create(EepSimulator, _G)


EEPTime = 0

EEPTimeH = 0

EEPTimeM = 0

EEPTimeS = 0


-- Der Inhalt des EEP-EreignisFensters wird geloescht.
-- Im Simulator gibt es kein eigenes EEP-Ereignisfenster; die Funktion bleibt
-- daher absichtlich ohne Laufzeitwirkung.
function clearlog() end

------------------
-- Simulate
------------------

---Add a train and its rollingStock
---@param trainName string Name of the train
---param ... string Name of the rollingstock
function EepSimulator.simulateAddTrain(trainName, ...) return Runtime.simulateAddTrain(trainName, ...) end

function EepSimulator.simulateSplitTrain(trainName, index) return Runtime.simulateSplitTrain(trainName, index) end

--- This will add a train to the signals queue
---@param signalId number
---@param trainName string
function EepSimulator.simulateQueueTrainOnSignal(signalId, trainName)
    return Runtime.simulateQueueTrainOnSignal(signalId,
                                              trainName)
end

--- This will remove a train from the signals queue
---@param signalId number
---@param trainName string
function EepSimulator.simulateRemoveTrainFromSignal(signalId, trainName)
    return Runtime.simulateRemoveTrainFromSignal(
        signalId, trainName)
end

--- This will remove all trains from the signals queue
---@param signalId number
function EepSimulator.simulateRemoveAllTrainsFromSignal(signalId)
    return Runtime.simulateRemoveAllTrainsFromSignal(
        signalId)
end

function EepSimulator.simulatePlaceTrainOnRoadTrack(trackId, zugname)
    return Runtime.simulatePlaceTrainOnRoadTrack(
        trackId, zugname)
end

function EepSimulator.simulatePlaceTrainOnRailTrack(trackId, zugname)
    return Runtime.simulatePlaceTrainOnRailTrack(
        trackId, zugname)
end

---@param rollingStockName string
---@param frontForward boolean
function EepSimulator.simulateSetRollingStockOrientation(rollingStockName, frontForward)
    return Runtime
        .simulateSetRollingStockOrientation(rollingStockName, frontForward)
end

---@param oldName string
---@param newName string
---@return boolean
function EepSimulator.simulateRenameTrain(oldName, newName) return Runtime.simulateRenameTrain(oldName, newName) end

---@param oldName string
---@param newName string
---@return boolean
function EepSimulator.simulateRenameRollingStock(oldName, newName)
    return Runtime.simulateRenameRollingStock(oldName,
                                              newName)
end

---@param name string
---@param trainName string|nil
---@return boolean
function EepSimulator.simulateAddRollingStock(name, trainName) return Runtime.simulateAddRollingStock(name, trainName) end

---@param depotId number
---@param trainName string
---@param position number|nil
---@param status number|nil
function EepSimulator.simulateAddTrainToTrainyard(depotId, trainName, position, status)
    return Runtime
        .simulateAddTrainToTrainyard(depotId, trainName, position, status)
end

------------------
-- Emit
------------------

function EepSimulator.emitMain() return Runtime.emitMain() end

function EepSimulator.emitOnSignal(signalId, stellung) return Runtime.emitOnSignal(signalId, stellung) end

function EepSimulator.emitOnSwitch(switchId, stellung) return Runtime.emitOnSwitch(switchId, stellung) end

function EepSimulator.emitOnTrainCoupling(zugA, zugB, zugNeu) return Runtime.emitOnTrainCoupling(zugA, zugB, zugNeu) end

function EepSimulator.emitOnTrainLooseCoupling(zugA, zugB, zugAlt)
    return Runtime.emitOnTrainLooseCoupling(zugA, zugB,
                                            zugAlt)
end

function EepSimulator.emitOnSaveAnl(anlagenpfad) return Runtime.emitOnSaveAnl(anlagenpfad) end

function EepSimulator.emitOnBeforeSaveAnl() return Runtime.emitOnBeforeSaveAnl() end

function EepSimulator.emitOnTrainExitTrainyard(depotId, trainName)
    return Runtime.emitOnTrainExitTrainyard(depotId,
                                            trainName)
end

function EepSimulator.emitOnTrainEnterTrainyard(depotId, trainName)
    return Runtime.emitOnTrainEnterTrainyard(depotId,
                                             trainName)
end

--- Loest den Callback fuer einen an einem Signal haltenden Zug aus.
--- Der Simulator ruft dazu eine im Test per _G.EEPOnTrainStoppedOnSignal
--- gesetzte Callback-Funktion direkt auf.
---@param signalId number
---@param trainName string
---@return boolean
function EepSimulator.emitOnTrainStoppedOnSignal(signalId, trainName)
    return Runtime.emitOnTrainStoppedOnSignal(signalId,
                                              trainName)
end

function EEPSetSignal(signalId, signalState, invokeCallback)
    return Runtime.callEEPSetSignal(signalId,
                                    signalState, invokeCallback)
end

--- Liefert die aktuelle Stellung des Signal x
-- @param signalId Id des Signals
-- @return Stellung des Signals, Wenn das abgefragte Signal nicht existiert, ist der Rueckgabewert 0.
function EEPGetSignal(signalId) return Runtime.callEEPGetSignal(signalId) end

--- Setzt die Weiche x auf die Stellung y. Der Wert activateEEPOnSwitch sollte den Wert 1 haben.
-- @param switchId Id der Weiche
-- @param switchPosition Stellung der Weiche
-- @param activateEEPOnSwitch (optional) Wenn = 1 dann aktiviere Funktion EEPOnSignal_x()
-- @return ok 1 wenn die Weiche und die gewuenschte Weichenstellung existieren
-- oder 0, wenn eins von beidem nicht existiert.
function EEPSetSwitch(switchId, switchPosition, activateEEPOnSwitch)
    return Runtime.callEEPSetSwitch(switchId,
                                    switchPosition, activateEEPOnSwitch)
end

--- Liefert die aktuelle Stellung der Weiche x
function EEPGetSwitch(switchId) return Runtime.callEEPGetSwitch(switchId) end

--- Das Signal x wird intern registriert.
--- Der Simulator definiert EEPOnSignal_x() bewusst nicht selbst.
--- Falls ein Test diesen Callback benoetigt, kann er ihn wie in EEP ueber
--- _G["EEPOnSignal_" .. signalId] = function(stellung) ... end bereitstellen.
function EEPRegisterSignal(signalId) return Runtime.callEEPRegisterSignal(signalId) end

--- Die Weiche x wird intern registriert.
--- Der Simulator definiert EEPOnSwitch_x() bewusst nicht selbst.
--- Falls ein Test diesen Callback benoetigt, kann er ihn wie in EEP ueber
--- _G["EEPOnSwitch_" .. switchId] = function(stellung) ... end bereitstellen.
function EEPRegisterSwitch(switchId) return Runtime.callEEPRegisterSwitch(switchId) end

--- Aendert die EEP-Zeit auf die gewuenschte Zeit.
--- Im Simulator werden EEPTime sowie EEPTimeH, EEPTimeM und EEPTimeS sofort
--- aus den uebergebenen Werten aktualisiert.
---@param stunde number Stundenangabe zwischen 0 und 23
---@param minute number Minutenangabe zwischen 0 und 59
---@param seconds number Sekundenangabe zwischen 0 und 59
---@return boolean ok True bei erfolgreicher Ausfuehrung, sonst false
function EEPSetTime(stunde, minute, seconds) return Runtime.callEEPSetTime(stunde, minute, seconds) end

--- Liefert die aktuelle Bildrate (fps) zurueck.
--- Im Simulator wird dafuer ein fester Rueckgabewert von 60 verwendet.
---@return number fps Bildrate in Frames pro Sekunde
function EEPGetFramesPerSecond() return Runtime.callEEPGetFramesPerSecond() end

--- Liefert den aktuellen Wert des Bildzaehlers seit Anlagenstart zurueck.
--- Im Simulator wird dafuer ein fester Rueckgabewert von 15 verwendet.
---@return number frameNummer Aktueller Bildzaehler
function EEPGetCurrentFrame() return Runtime.callEEPGetCurrentFrame() end

--- Liefert die Gesamtanzahl der gerenderten Bilder seit Anlagenstart zurueck.
--- Im Simulator wird dafuer ein fester Rueckgabewert von 15948 verwendet.
---@return number frameNummer Aktueller Render-Bildzaehler
function EEPGetCurrentRenderFrame() return Runtime.callEEPGetCurrentRenderFrame() end

--- Liefert den aktuell eingestellten Zeitrafferfaktor zurueck.
--- Im Simulator wird dafuer ein fester Rueckgabewert von 1 verwendet.
---@return number zeitrafferfaktor Aktueller Zeitrafferfaktor
function EEPGetTimeLapse() return Runtime.callEEPGetTimeLapse() end

--- Setzt die Farbfilterparameter voruebergehend.
--- Im Simulator ist diese Funktion derzeit nur als Stub ohne Laufzeitwirkung
--- vorhanden.
---@param farbton number Farbton
---@param saettigung number Saettigung
---@param helligkeit number Helligkeit
---@param kontrast number Kontrast
function EEPSetColourFilter(hue, saturation, brightness, contrast)
    return Runtime.callEEPSetColourFilter(hue,
                                          saturation, brightness, contrast)
end

--- Geschwindigkeit aendern
-- @param trainName Name des Zuges
-- @param speed Geschwindigkeit
-- @param useTargetSpeed true = Wunschgeschwindigkeit, false/nil = aktuelle Geschwindigkeit
function EEPSetTrainSpeed(trainName, speed, useTargetSpeed)
    return Runtime.callEEPSetTrainSpeed(trainName, speed, useTargetSpeed)
end

--- Geschwindigkeit lesen
---@param trainName string Name des Zuges
---@param useTargetSpeed? boolean true = Wunschgeschwindigkeit, false/nil = aktuelle Geschwindigkeit
---@return boolean Ist der Zug vorhanden
---@return number Geschwindigkeit
function EEPGetTrainSpeed(trainName, useTargetSpeed) return Runtime.callEEPGetTrainSpeed(trainName, useTargetSpeed) end

--- Setzen der Kupplung (hinten)
-- @param rsName Name des Rollmaterial,
-- @param kupplungsStatus 1-Kupplung aktiv, 2-Kupplung inaktiv, 3-Wagen angekoppelt(nurGet),
-- z.B.: EEPRollingstockSetCouplingRear("DB 212309", 2)
function EEPRollingstockSetCouplingRear(rsName, kupplungsStatus)
    return Runtime.callEEPRollingstockSetCouplingRear(
        rsName, kupplungsStatus)
end

--- Abfragen der Kupplung (hinten)
-- @param rsName Name des Rollmaterial,
-- @param kupplungsStatus 1-Kupplung aktiv, 2-Kupplung inaktiv, 3-Wagen angekoppelt(nurGet),
function EEPRollingstockGetCouplingRear(rollingstockName) return Runtime.callEEPRollingstockGetCouplingRear(rollingstockName) end

--- Setzen der Kupplung (vorn)
-- @param rollingstockName Name des Rollmaterial,
-- @param kupplungsStatus 1-Kupplung aktiv, 2-Kupplung inaktiv, 3-Wagen angekoppelt(nurGet),
-- z.B.: EEPRollingstockSetCouplingFront("DB212 309", 2)
function EEPRollingstockSetCouplingFront(rsName, kupplungsStatus)
    return Runtime.callEEPRollingstockSetCouplingFront(
        rsName, kupplungsStatus)
end

--- Abfragen der Kupplung (vorn)
-- @param rsName Name des Rollmaterial,
-- @param kupplungsStatus 1-Kupplung aktiv, 2-Kupplung inaktiv, 3-Wagen angekoppelt(nurGet),
function EEPRollingstockGetCouplingFront(rollingstockName) return Runtime.callEEPRollingstockGetCouplingFront(rollingstockName) end

--------------------------------------------------------------------------
-- Siehe hierzu auch Handbuch EEP 11(Achsgruppen) Setzen einer Achsgruppe,
-- z.B.: EEPRollingstockSetSlot("Loadingkran2Greifer", 1)
-- @param rollingstockName Name des Rollmaterials als String
-- @param slot Slot mit der Achsstellung
--------------------------------------------------------------------------
function EEPRollingstockSetSlot(rsName, slot) return Runtime.callEEPRollingstockSetSlot(rsName, slot) end

--------------------------------------------------------------------------
--- Setzen einer Achse am Rollmaterial
-- z.B.: EEPRollingstockSetAxis("Bekohlungskranbruecke 1", "Drehung links", 50)
-- @param rsName Name des Rollmaterials als String
-- @param achse Name der Achse
-- @param stellung 0 - 100 - Achsstellung
--------------------------------------------------------------------------
function EEPRollingstockSetAxis(rollingstockName, axisName, axisPosition, useNameFilter)
    return Runtime.callEEPRollingstockSetAxis(rollingstockName, axisName,
                                                 axisPosition, useNameFilter)
end

--- Gibt die Stellung der Achse am Rollmaterial zurueck
-- z.B.: EEPRollingstockSetAxis("Bekohlungskranbr?cke 1", "Drehung links", 50)
-- @param rsName Name des Rollmaterials als String
-- @param achse Name der Achse
function EEPRollingstockGetAxis(rollingstockName, axisName) return Runtime.callEEPRollingstockGetAxis(rollingstockName, axisName) end

--- Laedt Daten aus Slot.
--- Laut EEP-Handbuch kann Rueckgabewert 2 ein Boolean, eine Zahl, ein String oder nil sein.
-- @param slot Slot 1 bis 1000
-- @return true (wenn gefunden), Boolean|Zahl|String|nil
function EEPLoadData(slot) return Runtime.callEEPLoadData(slot) end

--- Speichert Daten in Slot.
--- Laut EEP-Handbuch akzeptiert EEPSaveData Boolean, Zahl, String oder nil.
--- Falls ein String gespeichert wird, darf er dabei hoechstens 999 Zeichen lang sein.
-- @param slot Slot 1 bis 1000
-- @param data Boolean|Zahl|String|nil
function EEPSaveData(storageSlot, value) return Runtime.callEEPSaveData(storageSlot, value) end

------------------------------
-- Neu ab EEP 11 - Plugin 1 --
------------------------------
--- Rauch einschalten
-- @param immoName Name der Immobilie als String.
-- @param onoff true oder false
function EEPStructureSetSmoke(immoName, onoff) return Runtime.callEEPStructureSetSmoke(immoName, onoff) end

--- Rauch abfreagen
-- @param immoName Name der Immobilie als String.
function EEPStructureGetSmoke(luaName) return Runtime.callEEPStructureGetSmoke(luaName) end

--- Licht einschalten
-- @param luaName Name der Immobilie als String.
-- @param onoff true oder false
function EEPStructureSetLight(name, onoff) return Runtime.callEEPStructureSetLight(name, onoff) end

--- Licht abfragen
-- @param immoName Name der Immobilie als String.
function EEPStructureGetLight(luaName) return Runtime.callEEPStructureGetLight(luaName) end

--- Feuer einschalten
-- @param immoName Name der Immobilie als String.
-- @param onoff true oder false
function EEPStructureSetFire(immoName, onoff) return Runtime.callEEPStructureSetFire(immoName, onoff) end

--- Feuer abfragen
-- @param immoName Name der Immobilie als String.
function EEPStructureGetFire(luaName) return Runtime.callEEPStructureGetFire(luaName) end

--- Setzen einer Achse einer Immobilie.
-- @param luaName Name der Immobilie als String.
-- @param achse Name der Achse
-- @param schritte 1000 bzw. -1000: endlos, 0: Stopp, sonst Schritte
function EEPStructureAnimateAxis(immoName, achse, schritte)
    return Runtime.callEEPStructureAnimateAxis(immoName, achse,
                                               schritte)
end

--- Setzen einer Achse einer Immobilie
-- @param immoName Name der Immobilie als String.
-- @param achse Name der Achse
-- @param stellung position der Achse
function EEPStructureSetAxis(luaName, axisName, axisPosition) return Runtime.callEEPStructureSetAxis(luaName, axisName, axisPosition) end

--- Gibt die Stellung der Achse am Rollmaterial zurueck.
-- z.B.: EEPRollingstockSetAxis("Bekohlungskranbruecke 1", "Drehung links", 50)
-- @param luaName Name der Immobilie als String.
-- @param axisName Name der Achse
function EEPStructureGetAxis(immoName, achse) return Runtime.callEEPStructureGetAxis(immoName, achse) end

--- Setzen der Position einer Immobilie
-- @param immoName Name der Immobilie als String.
-- @param posX x-Position
-- @param posY y-Position
-- @param posZ z-Position
function EEPStructureSetPosition(luaName, posX, posY, posZ)
    return Runtime.callEEPStructureSetPosition(luaName, posX,
                                               posY, posZ)
end

--- Setzen der Rotation einer Immobilie
-- @param immoName Name der Immobilie als String.
-- @param rotX x-Position
-- @param rotY y-Position
-- @param rotZ z-Position
function EEPStructureSetRotation(luaName, rotX, rotY, rotZ)
    return Runtime.callEEPStructureSetRotation(luaName, rotX,
                                               rotY, rotZ)
end

------------------------------
-- Neu ab EEP 11 - Plugin 2 --
------------------------------
--- Route aendern
---@param trainName string Name des Zuges
---@param route string Name der Route
function EEPSetTrainRoute(trainName, routeName) return Runtime.callEEPSetTrainRoute(trainName, routeName) end

--- Route abfragen - return ok und Name der Route
---@param trainName string Name des Zuges
---@return boolean, string
function EEPGetTrainRoute(trainName) return Runtime.callEEPGetTrainRoute(trainName) end

--- Licht ein oder ausschalten
-- @param trainName Name des Zuges
-- @param onoff true: ein, false: aus
function EEPSetTrainLight(trainName, enabled, lightSource) return Runtime.callEEPSetTrainLight(trainName, enabled, lightSource) end

function EEPGetTrainLight(trainName, quelle) return Runtime.callEEPGetTrainLight(trainName, quelle) end

--- Rauch ein oder ausschalten
-- @param trainName Name des Zuges
-- @param onoff true: ein, false: aus
function EEPSetTrainSmoke(trainName, enabled) return Runtime.callEEPSetTrainSmoke(trainName, enabled) end

--- Hupen
-- @param trainName Name des Zuges
-- @param enabled true: signal starten, false: signal beenden
function EEPSetTrainHorn(trainName, onoff) return Runtime.callEEPSetTrainHorn(trainName, onoff) end

--- Kupplung vorn setzen
-- @param trainName Name des Zuges
-- @param kupplungOn true: kuppeln, false: abstoßen
function EEPSetTrainCouplingFront(trainName, couple)
    return Runtime.callEEPSetTrainCouplingFront(trainName,
                                                couple)
end

function EEPGetTrainCouplingFront(trainName) return Runtime.callEEPGetTrainCouplingFront(trainName) end

--- Kupplung hinten setzen
-- @param trainName Name des Zuges
-- @param kupplungOn true: kuppeln, false: abstoßen
function EEPSetTrainCouplingRear(trainName, kupplungOn) return Runtime.callEEPSetTrainCouplingRear(trainName, kupplungOn) end

function EEPGetTrainCouplingRear(trainName) return Runtime.callEEPGetTrainCouplingRear(trainName) end

--- Zugverband an bestimmter Stelle trennen
-- @param trainName Name des Zuges
-- @param countFromFront true: von vorne zaehlen, false: von hinten zaehlen
-- @param position Stelle, die getrennt wird
function EEPTrainLooseCoupling(trainName, countFromFront, position)
    return Runtime.callEEPTrainLooseCoupling(trainName,
                                             countFromFront, position)
end

--- Setzen des Gueterhakens an allen Wagen eines Zuges
-- @param trainName Name des Zuges als String
-- @param hookOn true: Haken fuer alle an
function EEPSetTrainHook(trainName, enabled) return Runtime.callEEPSetTrainHook(trainName, enabled) end

--- Setzen einer Achse an allen Wagen eines Zuges
-- @param trainName Name des Zuges als String
-- @param achse Name der Achse
-- @param stellung 0 - 100 - Achsstellung
function EEPSetTrainAxis(trainName, achse, stellung) return Runtime.callEEPSetTrainAxis(trainName, achse, stellung) end

------------------------------
-- Neu ab EEP 11 - Plugin 2 --
------------------------------

--- Registriert ein Gleis fuer die Besetztabfrage.
-- @param trackId Id des Gleises
function EEPRegisterRailTrack(railTrackId) return Runtime.callEEPRegisterRailTrack(railTrackId) end

--- Fragt ab, ob ein Gleis besetzt ist.
-- @param railTrackId Id des Gleises
-- @param returnTrainName wenn true, wird als dritter Wert der Zugname
-- zurueckgegeben
-- @return Erster Wert: true, wenn Gleis existiert und registriert,
-- zweiter Wert: true, wenn besetzt,
-- dritter Wert: Name des Zuges auf dem Gleis
function EEPIsRailTrackReserved(trackId, returnTrainName)
    return Runtime.callEEPIsRailTrackReserved(trackId,
                                              returnTrainName)
end

--- Registriert ein Gleis fuer die Besetztabfrage.
---@param trackId number Id des Gleises
function EEPRegisterRoadTrack(roadTrackId) return Runtime.callEEPRegisterRoadTrack(roadTrackId) end

--- Fragt ab, ob ein Gleis besetzt ist.
---@param roadTrackId number Id des Gleises
---@param returnTrainName boolean wenn true, wird als dritter Wert der Zugname
-- @return boolean, boolean, string
-- Erster Wert: true, wenn Gleis existiert und registriert,
-- zweiter Wert: true, wenn besetzt,
-- dritter Wert: Name des Zuges auf dem Gleis
function EEPIsRoadTrackReserved(trackId, returnTrainName)
    return Runtime.callEEPIsRoadTrackReserved(trackId,
                                              returnTrainName)
end

--- Registriert ein Gleis fuer die Besetztabfrage.
-- @param tramTrackId Id des Gleises
function EEPRegisterTramTrack(tramTrackId) return Runtime.callEEPRegisterTramTrack(tramTrackId) end

--- Fragt ab, ob ein Gleis besetzt ist.
-- @param tramTrackId Id des Gleises
-- @param returnTrainName wenn true, wird als dritter Wert der Zugname
-- @return Erster Wert: true, wenn Gleis existiert und registriert,
-- zweiter Wert: true, wenn besetzt,
-- dritter Wert: Name des Zuges auf dem Gleis
function EEPIsTramTrackReserved(tramTrackId, returnTrainName)
    return Runtime.callEEPIsTramTrackReserved(tramTrackId,
                                              returnTrainName)
end

--- Registriert ein Gleis fuer die Besetztabfrage.
-- @param auxTrackId Id des Gleises
function EEPRegisterAuxiliaryTrack(auxiliaryTrackId) return Runtime.callEEPRegisterAuxiliaryTrack(auxiliaryTrackId) end

--- Fragt ab, ob ein Gleis besetzt ist.
-- @param auxiliaryTrackId Id des Gleises
-- @param returnTrainName wenn true, wird als dritter Wert der Zugname
-- @return Erster Wert: true, wenn Gleis existiert und registriert,
-- zweiter Wert: true, wenn besetzt,
-- dritter Wert: Name des Zuges auf dem Gleis
function EEPIsAuxiliaryTrackReserved(auxTrackId, returnTrainName)
    return Runtime.callEEPIsAuxiliaryTrackReserved(
        auxTrackId, returnTrainName)
end

--- Registriert ein Gleis fuer die Besetztabfrage.
-- @param controlTrackId Id des Gleises
function EEPRegisterControlTrack(controlTrackId) return Runtime.callEEPRegisterControlTrack(controlTrackId) end

--- Fragt ab, ob ein Gleis besetzt ist.
-- @param controlTrackId Id des Gleises
-- @return Erster Wert: true, wenn Gleis existiert und registriert,
-- zweiter Wert: true, wenn besetzt
function EEPIsControlTrackReserved(controlTrackId, returnTrainName)
    return Runtime.callEEPIsControlTrackReserved(
        controlTrackId, returnTrainName)
end

--- Waehlen einer Kamera
-- @param camType 0: statisch, 1: dynamisch, 2: mobile Kamera
-- @param camName Name der Kamera
-- @return true, wenn die Kamera existiert
function EEPSetCamera(cameraType, cameraName) return Runtime.callEEPSetCamera(cameraType, cameraName) end

--- Waehlen einer Kameraperspektive
-- @param camPosition Tasten 1 - 9 fuer die Kameraposition
-- @param trainName Name des Zuges
-- @return true, wenn die Kamera existiert
function EEPSetPerspectiveCamera(camPosition, trainName)
    return Runtime.callEEPSetPerspectiveCamera(camPosition,
                                               trainName)
end

function EEPGetPerspectiveCamera(trainName) return Runtime.callEEPGetPerspectiveCamera(trainName) end

--- Zug aus Depot starten
-- @param depotId Id des Depots (Eigenschaftenfenster)
-- @param trainName Name des Zuges
-- @param depotSlot Wenn kein Zugname angegeben ist, dann der Listenplatz des Zugs im Depot
-- @param departureOrientation Ausrichtung beim Ausfahren aus dem Depot
-- @return true, wenn der Zug existiert
function EEPGetTrainFromTrainyard(depotId, trainName, depotSlot, departureOrientation)
    return Runtime.callEEPGetTrainFromTrainyard(depotId,
                                                trainName, depotSlot, departureOrientation)
end

function EEPIsTrainInTrainyard(trainName) return Runtime.callEEPIsTrainInTrainyard(trainName) end

function EEPPutTrainToTrainyard(depotId, trainName) return Runtime.callEEPPutTrainToTrainyard(depotId, trainName) end

-------------------------------
-- Neu ab EEP 13             --
-------------------------------
--- Zeigen / Verstecken des Tipp-Textes einer Immobilie
-- @param immoName Name der Immobilie als String.
-- @param onOff true: einschalten
function EEPShowInfoStructure(luaName, visible) return Runtime.callEEPShowInfoStructure(luaName, visible) end

--- Setzen des Tipp-Textes einer Immobilie
-- @param luaName Name der Immobilie als String.
-- @param text Text fuer die Anzeige
function EEPChangeInfoStructure(immoName, text) return Runtime.callEEPChangeInfoStructure(immoName, text) end

--- Zeigen / Verstecken des Tipp-Textes einer Immobilie
-- @param switchId Name der Immobilie als String.
-- @param onOff true: einschalten
function EEPShowInfoSignal(signalId, visible) return Runtime.callEEPShowInfoSignal(signalId, visible) end

--- Setzen des Tipp-Textes einer Immobilie
-- @param switchId Name der Immobilie als String.
-- @param text Text fuer die Anzeige
function EEPChangeInfoSignal(signalId, text) return Runtime.callEEPChangeInfoSignal(signalId, text) end

--- Zeigen / Verstecken des Tipp-Textes einer Weiche
-- @param switchId Name der Weiche als String.
-- @param onOff true: einschalten
function EEPShowInfoSwitch(switchId, visible) return Runtime.callEEPShowInfoSwitch(switchId, visible) end

--- Setzen des Tipp-Textes einer Weiche
-- @param switchId Name der Weiche als String.
-- @param text Text fuer die Anzeige
function EEPChangeInfoSwitch(switchId, text) return Runtime.callEEPChangeInfoSwitch(switchId, text) end

-------------------------------
-- Neu ab EEP 13 - Plugin 2  --
-------------------------------

--- Anzahl der Fahrzeuge im Zugverband Name
-- @param zugverband Names des Zugverbandes
--
function EEPGetRollingstockItemsCount(trainName) return Runtime.callEEPGetRollingstockItemsCount(trainName) end

--- Name des Rollis Nummer im Zugverband Name
-- @param trainName Name des Zugverbandes
-- @param Nummer
--
function EEPGetRollingstockItemName(zugverband, Nummer) return Runtime.callEEPGetRollingstockItemName(zugverband, Nummer) end

--- Anzahl der Zuege, welche vom Signal Signal_ID gehalten werden
-- @param signalId ID des Signals
--
function EEPGetSignalTrainsCount(signalId) return Runtime.callEEPGetSignalTrainsCount(signalId) end

--- Name des Zuges Zahl, der vom Signal Signal_ID gehalten wird
-- @param signalId ID des Signals
-- @param position Position des Zuges am Signal
--
function EEPGetSignalTrainName(signalId, position) return Runtime.callEEPGetSignalTrainName(signalId, position) end

--- Anzahl der Zuege, welche im Depot ZugdepotId gelistet sind
-- @param depotId ID des Zugdepots
-- @return count Anzahl der Fahrzeugverbaende
function EEPGetTrainyardItemsCount(depotId) return Runtime.callEEPGetTrainyardItemsCount(depotId) end

--- Name des Zuges am DepotPlatz im Depot depotId
-- @param depotId ID des Zugdepots
-- @param position Position (Zahl) des Zugverbandes im Depot
-- @return trainName Name des Fahrzeugverbands
function EEPGetTrainyardItemName(depotId, position) return Runtime.callEEPGetTrainyardItemName(depotId, position) end

--- Status (wartet/auf Anlage) des Zuges Name am Platz im depotId
-- @param depotId ID des Zugdepots
-- @param zugverband Name des Zugverbandes
-- @param position Position (Zahl) des Zugverbandes im Depot
-- @return status Status des Fahrzeugverbands: 0 = in Fahrt , 1 = warten
function EEPGetTrainyardItemStatus(depotId, trainName, depotSlot)
    return Runtime.callEEPGetTrainyardItemStatus(depotId,
                                                 trainName, depotSlot)
end

-------------------------------
-- Neu ab EEP 15  --
-------------------------------

--- Argument ist der Name des Fahrzeugs.
-- Rueckgabewert 1 ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
-- Rueckgabewert 2 ist die Laenge des Fahrzeugs von Kupplung zu Kupplung in Metern.
function EEPRollingstockGetLength(rollingstockName) return Runtime.callEEPRollingstockGetLength(rollingstockName) end

--- Argument ist der Name des Fahrzeugs.
-- Rueckgabewert 1 ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
-- Rueckgabewert 2 ist true, wenn das angegebene Fahrzeug einen Antrieb besitzt, sonst false.
function EEPRollingstockGetMotor(rollingStockName) return Runtime.callEEPRollingstockGetMotor(rollingStockName) end

--- Argument ist der Name des Fahrzeugs.
-- Rueckgabewert 1 ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
-- Rueckgabewert 2 ist die ID des Gleisstuecks, auf dem sich das Fahrzeug befindet.
-- Rueckgabewert 3 ist der Abstand (in Metern) zum Anfang des Gleisstuecks, auf dem sich das
-- Fahrzeug befindet.
-- Rueckgabewert 4 ist die Ausrichtung relativ zur Fahrtrichtung des Gleisstuecks, auf dem sich das
-- Fahrzeug befindet. 1 = in Fahrtrichtung, 0 = entgegen der Fahrtrichtung
-- Rueckgabewert 5 ist die Nummer des Gleissystems, auf dem das Fahrzeug unterwegs ist.
-- 1 = Bahngleise
-- 2 = Straßen
-- 3 = Tramgleise
-- 4 = sonstige Splines/Wasserwege
function EEPRollingstockGetTrack(rollingstockName) return Runtime.callEEPRollingstockGetTrack(rollingstockName) end

--- Argument ist der Fahrzeugname.
-- Rueckgabewert 1 ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
-- Rueckgabewert 2 ist die Kategorie, welche der Konstrukteur im Modell eingetragen hat:
-- 1 = Tenderlok
-- 2 = Schlepptenderlok
-- 3 = Tender
-- 4 = Elektrolok
-- 5 = Diesellok
-- 6 = Triebwagen
-- 7 = U- oder S-Bahn
-- 8 = Strassenbahn
-- 9 = Gueterwaggons
-- 10 = Personenwaggons
-- 11 = Luftfahrzeuge
-- 12 = Maschinen (z.B. Kraene)
-- 13 = Wasserfahrzeuge
-- 14 = LKW
-- 15 = PKW
function EEPRollingstockGetModelType(rollingStockName) return Runtime.callEEPRollingstockGetModelType(rollingStockName) end

--- Argument ist der Lua-Name der Immobilie oder des LS-Elements.
-- Es genuegt die Nummer mit vorangestelltem #-Zeichen.
-- @return
-- Rueckgabewert 1 ist true, wenn die Ausfuehrung erfolgreich war, ansonsten false.
-- Rueckgabewert 2 ist die X-Position des Objekts.
-- Rueckgabewert 3 ist die Y-Position des Objekts.
-- Rueckgabewert 4 ist die Z-Position des Objekts.
function EEPStructureGetPosition(luaName) return Runtime.callEEPStructureGetPosition(luaName) end

--- Argument ist der Lua-Name der Immobilie oder des LS-Elements.
-- Es genuegt die Nummer mit vorangestelltem #-Zeichen.
-- @return
-- Rueckgabewert 1 ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
-- Rueckgabewert 2 ist die Kategorie, welche der Konstrukteur im Modell eingetragen hat:
-- 16 = Gleise/Gleisobjekte
-- 17 = Schiene/Gleisobjekte
-- 18 = Strassen/Gleisobjekte
-- 19 = Sonstiges/Gleisobjekte
-- 22 = Immobilien
-- 23 = Landschaftselemente/Fauna
function EEPStructureGetModelType(name) return Runtime.callEEPStructureGetModelType(name) end

--- Aendert den Tag-Text einer Immobilie. Jede Immobilie kann jetzt einen individuellen String von
--- maximal 1024 Zeichen Laenge mitfuehren. Diese Strings werden mit der Anlage gespeichert und
--- geladen.
--- Bemerkungen * Argument 1 ist der Lua-Name der Immobilie oder des LS-Elements.
--- Es genuegt die Nummer mit vorangestelltem #-Zeichen.
--- * Argument 2 ist der gewuenschte Text.
--- * Rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false
function EEPStructureSetTagText(luaName, text) return Runtime.callEEPStructureSetTagText(luaName, text) end

--- Liest den Tag-Text einer Immobilie aus. Mittels Tag-Texten können Immobilien als permanente
--- Speicher fuer relevante Informationen genutzt werden.
--- Bemerkungen
--- * Argument 1 ist der Lua-Name der Immobilie oder des LS-Elements.
--- Es genuegt die Nummer mit vorangestelltem #-Zeichen.
--- * Rueckgabewert 1 ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
--- * Rueckgabewert 2 ist der Tag-Text, welcher der Immobilie mitgegeben wurde
function EEPStructureGetTagText(name) return Runtime.callEEPStructureGetTagText(name) end

--- Aendert den Tag-Text eines Fahrzeugs. Jedes Fahrzeug kann jetzt einen eigenen String von
--- maximal 1024 Zeichen Laenge mitfuehren. Diese Strings werden mit der Anlage gespeichert und
--- geladen. Da die Texte individuell jedem Fahrzeug zugeordnet sind, gehen sie im Gegensatz zu
--- Routen nicht durch Rangiermanöver etc. verloren.
--- Bemerkungen
--- * Argument 1 ist der Name des Fahrzeugs.
--- * Argument 2 ist der gewuenschte Text als String mit maximal 1024 Zeichen.
--- * Rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPRollingstockSetTagText(rollingstockName, text) return Runtime.callEEPRollingstockSetTagText(rollingstockName, text) end

--- Liest den Tag-Text eines Fahrzeugs aus. Mittels Tag-Texten können Fahrzeuge jetzt kategorisiert
--- werden. Beispielsweise kann man dort Waggontypen speichern oder Bestimmungsorte.
--- Bemerkungen
--- * Argument 1 ist der Name des Fahrzeugs.
--- * Rueckgabewert 1 ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
--- * Rueckgabewert 2 ist der Tag-Text als String mit maximal 1024 Zeichen, welcher dem Waggon
---   mitgegeben wurde.
function EEPRollingstockGetTagText(name) return Runtime.callEEPRollingstockGetTagText(name) end

function EEPSignalSetTagText(signalId, text) return Runtime.callEEPSignalSetTagText(signalId, text) end

function EEPSignalGetTagText(id) return Runtime.callEEPSignalGetTagText(id) end

function EEPSwitchSetTagText(switchId, text) return Runtime.callEEPSwitchSetTagText(switchId, text) end

function EEPSwitchGetTagText(id) return Runtime.callEEPSwitchGetTagText(id) end

function EEPGoodsSetTagText(luaName, text) return Runtime.callEEPGoodsSetTagText(luaName, text) end

function EEPGoodsGetTagText(name) return Runtime.callEEPGoodsGetTagText(name) end

function EEPStructureSetTextureText(luaName, surfaceNumber, text)
    return Runtime.callEEPStructureSetTextureText(luaName, surfaceNumber,
                                                  text)
end

function EEPStructureGetTextureText(luaName, surfaceNumber) return Runtime.callEEPStructureGetTextureText(luaName, surfaceNumber) end

function EEPRollingstockSetTextureText(name, flaeche, text)
    return Runtime.callEEPRollingstockSetTextureText(name,
                                                     flaeche, text)
end

function EEPSignalSetTextureText(signalId, surfaceNumber, text) return Runtime.callEEPSignalSetTextureText(signalId, surfaceNumber, text) end

function EEPSignalGetTextureText(id, flaeche) return Runtime.callEEPSignalGetTextureText(id, flaeche) end

function EEPGoodsSetTextureText(luaName, surfaceNumber, text) return Runtime.callEEPGoodsSetTextureText(luaName, surfaceNumber, text) end

function EEPGoodsGetTextureText(name, flaeche) return Runtime.callEEPGoodsGetTextureText(name, flaeche) end

function EEPRailTrackSetTextureText(railTrackId, surfaceNumber, text) return Runtime.callEEPRailTrackSetTextureText(railTrackId, surfaceNumber, text) end

function EEPRailTrackGetTextureText(id, flaeche) return Runtime.callEEPRailTrackGetTextureText(id, flaeche) end

function EEPRoadTrackSetTextureText(roadTrackId, surfaceNumber, text) return Runtime.callEEPRoadTrackSetTextureText(roadTrackId, surfaceNumber, text) end

function EEPRoadTrackGetTextureText(id, flaeche) return Runtime.callEEPRoadTrackGetTextureText(id, flaeche) end

function EEPTramTrackSetTextureText(tramTrackId, surfaceNumber, text) return Runtime.callEEPTramTrackSetTextureText(tramTrackId, surfaceNumber, text) end

function EEPTramTrackGetTextureText(id, flaeche) return Runtime.callEEPTramTrackGetTextureText(id, flaeche) end

function EEPAuxiliaryTrackSetTextureText(auxiliaryTrackId, surfaceNumber, text)
    return Runtime.callEEPAuxiliaryTrackSetTextureText(auxiliaryTrackId,
                                                       surfaceNumber, text)
end

function EEPAuxiliaryTrackGetTextureText(auxiliaryTrackId, surfaceNumber) return Runtime.callEEPAuxiliaryTrackGetTextureText(auxiliaryTrackId, surfaceNumber) end

--- Ermittelt, welcher Zug derzeit im Steuerdialog ausgewaehlt ist. (EEP 15.1)
-- Befindet sich der Steuerdialog im manuellen Modus, dann wird der Name des Zuges zurueckgegeben,
-- welcher das ausgewaehlte Fahrzeug enthaelt
-- @return trainName Name des Zuges
function EEPGetTrainActive() return Runtime.callEEPGetTrainActive() end

--- Waehlt den angegebenen Zug im Steuerdialog aus. (EEP 15.1)
-- Stellt den Steuerdialog auf Automatik-Modus um.
-- @param trainName Name des Zuges
-- @return ok Rueckgabewert ist true wenn die Aktion erfolgreich war, sonst false
function EEPSetTrainActive(trainName) return Runtime.callEEPSetTrainActive(trainName) end

--- Ermittelt die Gesamtlaenge des angegebenen Zuges. (EEP 15.1)
---@param trainName string Name des Zuges
---@return boolean ok Rueckgabewert ist true wenn der angesprochene Zug existiert, sonst false
---@return integer length Laenge des Zuges in Meter
function EEPGetTrainLength(trainName) return Runtime.callEEPGetTrainLength(trainName) end

--- Ermittelt, welches Fahrzeug derzeit im Steuerdialog ausgewaehlt ist. (EEP 15.1)
-- Befindet sich der Steuerdialog im Automatikmodus, dann wird ein leerer String zurueckgegeben.
-- @return rollingstockName Name des Rollmaterials
function EEPRollingstockGetActive() return Runtime.callEEPRollingstockGetActive() end

--- Waehlt das angegebene Fahrzeug im Steuerdialog aus. (EEP 15.1)
-- Stellt den Steuerdialog auf manuellen Modus um.
-- @param rollingstockName Name des Rollmaterials
-- @return ok Rueckgabewert ist true wenn die Aktion erfolgreich war, sonst false
function EEPRollingstockSetActive(rollingstockName) return Runtime.callEEPRollingstockSetActive(rollingstockName) end

--- Ermittelt, welche relative Ausrichtung das angegebene Fahrzeug im Zugverband hat. (EEP 15.1)
-- @param rollingstockName Name des Rollmaterials
-- @return ok Rueckgabewert ist true wenn der angesprochene Zug existiert, sonst false
-- @return orientation Ausrichtung des Rollmaterials, true, wenn das Fahrzeug vorwaerts ausgerichtet ist, sonst false
function EEPRollingstockGetOrientation(rollingstockName)
    return Runtime.callEEPRollingstockGetOrientation(
        rollingstockName)
end

---------------------
-- Neu ab EEP 16.1 --
---------------------

--- Ruft das Stellpult im Radarfenster auf. (EEP 16.1)
-- @param GBSname
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPActivateCtrlDesk(ctrlDeskName) return Runtime.callEEPActivateCtrlDesk(ctrlDeskName) end

--- Laesst bei einem bestimmten Rollmaterial den Warnton (Pfeife, Hupe) ertönen. (EEP 16.1)
-- @param rollingstockName Name des Rollmaterials
-- @param status true = an, false = aus
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPRollingstockSetHorn(rollingstockName, status)
    return Runtime.callEEPRollingstockSetHorn(rollingstockName,
                                              status)
end

--- Schaltet bei einem bestimmten Rollmaterial den Haken an oder aus. (EEP 16.1)
-- @param rollingstockName Name des Rollmaterials
-- @param status true = an, false = aus
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPRollingstockSetHook(rollingstockName, enabled)
    return Runtime.callEEPRollingstockSetHook(rollingstockName,
                                              enabled)
end

--- Ermittelt, ob der Haken eines bestimmten Rollmaterials an oder ausgeschaltet ist (EEP 16.1)
-- @param rollingstockName Name des Rollmaterials
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return status Haken aus = 0, an = 1, in Betrieb = 3
function EEPRollingstockGetHook(rollingstockName) return Runtime.callEEPRollingstockGetHook(rollingstockName) end

--- Beeinflusst das Verhalten von Guetern an einem Kranhaken eines Rollmaterials. (EEP 16.1)
-- @param rollingstockName Name des Rollmaterials
-- @param status true = an, false = aus
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPRollingstockSetHookGlue(rollingstockName, status)
    return Runtime.callEEPRollingstockSetHookGlue(
        rollingstockName, status)
end

--- Ermittelt das Verhalten von Guetern am Kranhaken eines Rollmaterials  (EEP 16.1)
-- @param rollingstockName Name des Rollmaterials
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return status Gueterhaken aus = 0, an = 1, in Betrieb = 3
function EEPRollingstockGetHookGlue(rollingstockName) return Runtime.callEEPRollingstockGetHookGlue(rollingstockName) end

--- Ermittelt die zurueckgelegte Strecke des Rollmaterials (EEP 16.1)
-- @param rollingstockName Name des Rollmaterials
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return mileage  Die in Metern zurueckgelegte Strecke des Rollmaterials seit dem Einsetzen in EEP
function EEPRollingstockGetMileage(rollingstockName) return Runtime.callEEPRollingstockGetMileage(rollingstockName) end

--- Ermittelt die Position des Rollmaterials im EEP-Koordinatensystem. (EEP 16.1)
-- @param rollingstockName Name des Rollmaterials
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return PosX
-- @return PosY
-- @return PosZ
function EEPRollingstockGetPosition(rollingstockName) return Runtime.callEEPRollingstockGetPosition(rollingstockName) end

-- Liest den Text einer beschreibbaren Fläche eines Rollmaterials aus (EEP 16.3)
-- @param rollingstockName Name des Rollmaterials
-- @param flaeche Nummer der Fläche, welche den Text enthaelt.
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return textureText
function EEPRollingstockGetTextureText(rollingstockName, fleache)
    return Runtime.callEEPRollingstockGetTextureText(
        rollingstockName, fleache)
end

--- Definiert die Position der Benutzer-definierten Mitfahrkamera in Relation zum Fahrzeug (EEP 16.1)
-- Aufruf ueber Taste 9
-- @param rollingstockName Name des Rollmaterials
-- @param PosX Kameraposition
-- @param PosY Kameraposition
-- @param PosZ Kameraposition
-- @param RotX Kameraausrichtung (Drehung)
-- @param RotY Kameraausrichtung (Drehung)
-- @param RotZ Kameraausrichtung (Drehung)
-- @param setDirectly boolean Soll die Kamera sofort gesetzt werden
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPRollingstockSetUserCamera(rollingstockName, posX, posY, posZ, rotH, rotV)
    return Runtime.callEEPRollingstockSetUserCamera(rollingstockName, posX, posY, posZ, rotH, rotV)
end

function EEPRollingstockGetUserCamera(rollingstockName) return Runtime.callEEPRollingstockGetUserCamera(rollingstockName) end

--- Ermittelt die aktuelle Position der Kamera (EEP 16.1)
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return PosX Kameraposition
-- @return PosY Kameraposition
-- @return PosZ Kameraposition
function EEPGetCameraPosition() return Runtime.callEEPGetCameraPosition() end

--- Ermittelt die aktuelle Ausrichtung der Kamera (EEP 16.1)
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return RotX Kameraausrichtung (Drehung)
-- @return RotY Kameraausrichtung (Drehung)
-- @return RotZ Kameraausrichtung (Drehung)
function EEPGetCameraRotation() return Runtime.callEEPGetCameraRotation() end

--- Definiert die Kameraposition (EEP 16.1)
-- @param PosX Kameraposition
-- @param PosY Kameraposition
-- @param PosZ Kameraposition
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPSetCameraPosition(PosX, PosY, PosZ) return Runtime.callEEPSetCameraPosition(PosX, PosY, PosZ) end

--- Definiert die Kameraausrichtung (EEP 16.1)
-- @param RotX Kameraausrichtung (Drehung)
-- @param RotY Kameraausrichtung (Drehung)
-- @param RotZ Kameraausrichtung (Drehung)
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPSetCameraRotation(rotX, rotY, rotZ) return Runtime.callEEPSetCameraRotation(rotX, rotY, rotZ) end

--- Ermittelt, ob der Rauch des benannten Rollmaterials, an- oder ausgeschaltet ist. (EEP 16.1)
-- @param rollingstockName Name des Rollmaterials
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return status Rauch aus = 0, an = 1
function EEPRollingstockGetSmoke(rollingstockName) return Runtime.callEEPRollingstockGetSmoke(rollingstockName) end

--- Schaltet den Rauch des bennanten Rollmaterials an oder aus. (EEP 16.1)
-- @param rollingstockName Name des Rollmaterials
-- @param status Rauch an = true oder aus = false
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPRollingstockSetSmoke(rollingstockName, enabled)
    return Runtime.callEEPRollingstockSetSmoke(rollingstockName,
                                               enabled)
end

--- Ermittelt die Ausrichtung des Ladegutes. (EEP 16.1)
-- @param goodsName Name des Ladeguts
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return RotX Ausrichtung (Drehung)
-- @return RotY Ausrichtung (Drehung)
-- @return RotZ Ausrichtung (Drehung)
function EEPGoodsGetRotation(luaName) return Runtime.callEEPGoodsGetRotation(luaName) end

--- Ermittelt die Ausrichtung der Immobilie/des Landschaftselementes. (EEP 16.1)
-- 0 @param immobilieName Name der Immobilie/des Landschaftselementes.
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return RotX Ausrichtung (Drehung)
-- @return RotY Ausrichtung (Drehung)
-- @return RotZ Ausrichtung (Drehung)
function EEPStructureGetRotation(immobilieName) return Runtime.callEEPStructureGetRotation(immobilieName) end

--- Ermittelt die Windstaerke. (EEP 16.1)
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return intensity Windstaerke in Prozent (%)
function EEPGetWindIntensity() return Runtime.callEEPGetWindIntensity() end

--- Ermittelt die Niederschlagintensitaet. (EEP 16.1)
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return intensity Niederschlagintensitaet in Prozent (%)
function EEPGetRainIntensity() return Runtime.callEEPGetRainIntensity() end

--- Ermittelt die Schneeintensitaet (EEP 16.1)
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return intensity Schneeintensitaet in Prozent (%)
function EEPGetSnowIntensity() return Runtime.callEEPGetSnowIntensity() end

--- Ermittelt die Hagelintensitaet (EEP 16.1)
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return intensity Hagelintensitaet in Prozent (%)
function EEPGetHailIntensity() return Runtime.callEEPGetHailIntensity() end

--- Ermittelt die Nebelintensitaet (EEP 16.1)
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return intensity Nebelintensitaet in Prozent (%)
function EEPGetFogIntensity() return Runtime.callEEPGetFogIntensity() end

--- Ermittelt der Wolkenanteil (EEP 16.1)
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return intensity Wolkenanteil in Prozent (%)
function EEPGetCloudsIntensity() return Runtime.callEEPGetCloudsIntensity() end

-- Rueckwaertskompatibel: alter Name.
function EEPGetCloudIntensity() return Runtime.callEEPGetCloudIntensity() end

--- Definiert die Windstaerke (EEP 16.1)
-- @param Windstaerke
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPSetWindIntensity(intensity) return Runtime.callEEPSetWindIntensity(intensity) end

--- Veraendert die Niederschlagintensitaet (EEP 16.1)
-- @param Niederschlagintensitaet
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPSetRainIntensity(intensity) return Runtime.callEEPSetRainIntensity(intensity) end

--- Veraendert die Schneeintensitaet (EEP 16.1)
-- @param Schneeintensitaet
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPSetSnowIntensity(intensity) return Runtime.callEEPSetSnowIntensity(intensity) end

--- Veraendert die Hagelintensitaet (EEP 16.1)
-- @param Hagelintensitaet
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPSetHailIntensity(intensity) return Runtime.callEEPSetHailIntensity(intensity) end

--- Veraendert die Nebelintensitaet (EEP 16.1)
-- @param Nebelintensitaet
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPSetFogIntensity(intensity) return Runtime.callEEPSetFogIntensity(intensity) end

--- Veraendert den Wolkenanteil (EEP 16.1)
-- @param Wolkenanteil
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPSetCloudsIntensity(intensity) return Runtime.callEEPSetCloudsIntensity(intensity) end

--- EEP ruft selbstaendig diese Funktion auf, wenn die Anlage gespeichert wird. (EEP 16.1)
-- Im Skript definiert man die zugehoerige Funktion und legt so fest, was beim Speichern der Anlage zu tun ist.
-- @param path Speicherpfad der Anlage einschließlich Dateiname
function EEPPause(value) return Runtime.callEEPPause(value) end

return EepSimulator
