if AkDebugLoad then print("[#Start] Loading ce.hub.eep.EepSimulator ...") end

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
local Runtime = require("ce.hub.eep.EepSimulatorRuntime").create(EepSimulator, _G)


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

--- Fuegt einen Zug mit den angegebenen Rollmaterialeintraegen in den Simulator ein.
---@param trainName string Name des Zuges
---@param ... string Namen der Rollmaterialeintraege
---@return nil
function EepSimulator.simulateAddTrain(trainName, ...) return Runtime.simulateAddTrain(trainName, ...) end

--- Trennt einen Zug im Simulator an der angegebenen Fahrzeugposition.
---@param trainName string Name des Zuges
---@param index integer Trennposition innerhalb des Zuges
---@return nil
function EepSimulator.simulateSplitTrain(trainName, index) return Runtime.simulateSplitTrain(trainName, index) end

--- Haengt einen Zug in die Halteliste eines Signals ein.
---@param signalId number ID des Signals
---@param trainName string Name des Zuges
---@return nil
function EepSimulator.simulateQueueTrainOnSignal(signalId, trainName)
    return Runtime.simulateQueueTrainOnSignal(signalId,
                                              trainName)
end

--- Entfernt einen Zug aus der Halteliste eines Signals.
---@param signalId number ID des Signals
---@param trainName string Name des Zuges
---@return nil
function EepSimulator.simulateRemoveTrainFromSignal(signalId, trainName)
    return Runtime.simulateRemoveTrainFromSignal(
        signalId, trainName)
end

--- Leert die Halteliste eines Signals.
---@param signalId number ID des Signals
---@return nil
function EepSimulator.simulateRemoveAllTrainsFromSignal(signalId)
    return Runtime.simulateRemoveAllTrainsFromSignal(
        signalId)
end

--- Markiert einen Zug als auf einem Strassengleis platziert.
---@param trackId number ID des Strassengleises
---@param zugname string Name des Zuges
---@return nil
function EepSimulator.simulatePlaceTrainOnRoadTrack(trackId, zugname)
    return Runtime.simulatePlaceTrainOnRoadTrack(
        trackId, zugname)
end

--- Markiert einen Zug als auf einem Bahngleis platziert.
---@param trackId number ID des Bahngleises
---@param zugname string Name des Zuges
---@return nil
function EepSimulator.simulatePlaceTrainOnRailTrack(trackId, zugname)
    return Runtime.simulatePlaceTrainOnRailTrack(
        trackId, zugname)
end

--- Setzt die relative Ausrichtung eines Rollmaterialeintrags im Zugverband.
---@param rollingStockName string Name des Rollmaterials
---@param frontForward boolean Ob die Front nach vorn zeigt
---@return nil
function EepSimulator.simulateSetRollingStockOrientation(rollingStockName, frontForward)
    return Runtime
        .simulateSetRollingStockOrientation(rollingStockName, frontForward)
end

--- Benennt einen Zug im Simulatorzustand um.
---@param oldName string Bisheriger Zugname
---@param newName string Neuer Zugname
---@return boolean success True, wenn die Umbenennung erfolgreich war
function EepSimulator.simulateRenameTrain(oldName, newName) return Runtime.simulateRenameTrain(oldName, newName) end

--- Benennt einen Rollmaterialeintrag im Simulatorzustand um.
---@param oldName string Bisheriger Rollmaterialname
---@param newName string Neuer Rollmaterialname
---@return boolean success True, wenn die Umbenennung erfolgreich war
function EepSimulator.simulateRenameRollingStock(oldName, newName)
    return Runtime.simulateRenameRollingStock(oldName,
                                              newName)
end

--- Fuegt ein Rollmaterial hinzu und legt bei Bedarf einen Zielzug an.
---@param name string Gewuenschter Rollmaterialname
---@param trainName string|nil Optionaler Name des Zielzuges
---@return boolean success True, wenn das Rollmaterial hinzugefuegt wurde
function EepSimulator.simulateAddRollingStock(name, trainName)
    return Runtime.simulateAddRollingStock(name, trainName)
end

--- Fuegt einen Zug mit Statusinformation in ein Zugdepot ein.
---@param depotId number ID des Zugdepots
---@param trainName string Name des Zuges
---@param position number|nil Optionaler Depotplatz
---@param status number|nil Optionaler Depotstatus
---@return nil
function EepSimulator.simulateAddTrainToTrainyard(depotId, trainName, position, status)
    return Runtime
        .simulateAddTrainToTrainyard(depotId, trainName, position, status)
end

------------------
-- Emit
------------------

--- Loest den globalen Callback EEPMain aus.
---@return boolean invoked True, wenn EEPMain vorhanden und aufgerufen wurde
function EepSimulator.emitMain() return Runtime.emitMain() end

--- Loest den signalbezogenen Callback EEPOnSignal_<signalId> aus.
---@param signalId number ID des Signals
---@param stellung number Signalstellung
---@return boolean invoked True, wenn der Callback vorhanden und aufgerufen wurde
function EepSimulator.emitOnSignal(signalId, stellung) return Runtime.emitOnSignal(signalId, stellung) end

--- Loest den weichenbezogenen Callback EEPOnSwitch_<switchId> aus.
---@param switchId number ID der Weiche
---@param stellung number Weichenstellung
---@return boolean invoked True, wenn der Callback vorhanden und aufgerufen wurde
function EepSimulator.emitOnSwitch(switchId, stellung) return Runtime.emitOnSwitch(switchId, stellung) end

--- Loest den globalen Callback EEPOnTrainCoupling aus.
---@param zugA string Name des bewegten Zuges
---@param zugB string Name des stehenden Zuges
---@param zugNeu string Name des neu gebildeten Zuges
---@return boolean invoked True, wenn der Callback vorhanden und aufgerufen wurde
function EepSimulator.emitOnTrainCoupling(zugA, zugB, zugNeu)
    return Runtime.emitOnTrainCoupling(zugA, zugB, zugNeu)
end

--- Loest den globalen Callback EEPOnTrainLooseCoupling aus.
---@param zugA string Name des verbleibenden Zugteils
---@param zugB string Name des abgetrennten Zugteils
---@param zugAlt string Name des urspruenglichen Zuges
---@return boolean invoked True, wenn der Callback vorhanden und aufgerufen wurde
function EepSimulator.emitOnTrainLooseCoupling(zugA, zugB, zugAlt)
    return Runtime.emitOnTrainLooseCoupling(zugA, zugB,
                                            zugAlt)
end

--- Loest den globalen Callback EEPOnSaveAnl aus.
---@param anlagenpfad string Pfad der zu speichernden Anlage
---@return boolean invoked True, wenn der Callback vorhanden und aufgerufen wurde
function EepSimulator.emitOnSaveAnl(anlagenpfad) return Runtime.emitOnSaveAnl(anlagenpfad) end

--- Loest den globalen Callback EEPOnBeforeSaveAnl aus.
---@return boolean invoked True, wenn der Callback vorhanden und aufgerufen wurde
function EepSimulator.emitOnBeforeSaveAnl() return Runtime.emitOnBeforeSaveAnl() end

--- Loest den globalen Callback EEPOnTrainExitTrainyard aus.
---@param depotId number ID des Zugdepots
---@param trainName string Name des Zuges
---@return boolean invoked True, wenn der Callback vorhanden und aufgerufen wurde
function EepSimulator.emitOnTrainExitTrainyard(depotId, trainName)
    return Runtime.emitOnTrainExitTrainyard(depotId,
                                            trainName)
end

--- Loest den globalen Callback EEPOnTrainEnterTrainyard aus.
---@param depotId number ID des Zugdepots
---@param trainName string Name des Zuges
---@return boolean invoked True, wenn der Callback vorhanden und aufgerufen wurde
function EepSimulator.emitOnTrainEnterTrainyard(depotId, trainName)
    return Runtime.emitOnTrainEnterTrainyard(depotId,
                                             trainName)
end

--- Loest den globalen Callback EEPOnTrainStoppedOnSignal aus.
---@param signalId number ID des Signals
---@param trainName string Name des haltenden Zuges
---@return boolean invoked True, wenn der Callback vorhanden und aufgerufen wurde
function EepSimulator.emitOnTrainStoppedOnSignal(signalId, trainName)
    return Runtime.emitOnTrainStoppedOnSignal(signalId,
                                              trainName)
end

--- Schaltet ein Signal.
--- Ab: EEP 10.2 - Plugin 2.
function EEPSetSignal(signalId, signalState, invokeCallback)
    return Runtime.callEEPSetSignal(signalId,
                                    signalState, invokeCallback)
end

--- Gibt die Stellung eines Signals bezogen auf die herrschende Zugbeeinflussung zurueck (s. letzte Bemerkung).
--- Ab: EEP 10.2 - Plugin 2.
function EEPGetSignal(signalId) return Runtime.callEEPGetSignal(signalId) end

--- Schaltet eine Weiche.
--- Ab: EEP 10.2 - Plugin 2.
function EEPSetSwitch(switchId, switchPosition, activateEEPOnSwitch)
    return Runtime.callEEPSetSwitch(switchId,
                                    switchPosition, activateEEPOnSwitch)
end

--- Ermittelt die Stellung einer Weiche.
--- Ab: EEP 10.2 - Plugin 2.
function EEPGetSwitch(switchId) return Runtime.callEEPGetSwitch(switchId) end

--- Registriert ein Signal fuer den Callback EEPOnSignal_x().
--- Ab: EEP 10.2 - Plugin 2.
--- Das Signal x wird intern registriert.
--- Der Simulator definiert EEPOnSignal_x() bewusst nicht selbst.
--- Falls ein Test diesen Callback benoetigt, kann er ihn wie in EEP ueber
--- _G["EEPOnSignal_" .. signalId] = function(stellung) ... end bereitstellen.
function EEPRegisterSignal(signalId) return Runtime.callEEPRegisterSignal(signalId) end

--- Registriert eine Weiche fuer den Callback EEPOnSwitch_x().
--- Ab: EEP 10.2 - Plugin 2.
--- Die Weiche x wird intern registriert.
--- Der Simulator definiert EEPOnSwitch_x() bewusst nicht selbst.
--- Falls ein Test diesen Callback benoetigt, kann er ihn wie in EEP ueber
--- _G["EEPOnSwitch_" .. switchId] = function(stellung) ... end bereitstellen.
function EEPRegisterSwitch(switchId) return Runtime.callEEPRegisterSwitch(switchId) end

--- Aendert die EEPZeit auf die gewuenschte Zeit.
--- Ab: EEP 15.
--- Im Simulator werden EEPTime sowie EEPTimeH, EEPTimeM und EEPTimeS sofort
--- aus den uebergebenen Werten aktualisiert.
function EEPSetTime(stunde, minute, seconds) return Runtime.callEEPSetTime(stunde, minute, seconds) end

--- Gibt die aktuelle Bildrate (fps) zurueck.
--- Ab: EEP 17.2 - Plugin 2.
--- Im Simulator wird dafuer ein fester Rueckgabewert von 60 verwendet.
function EEPGetFramesPerSecond() return Runtime.callEEPGetFramesPerSecond() end

--- Gibt den aktuellen Bildzaehler ohne Bearbeitungs- und Pausenmodus zurueck.
--- Ab: EEP 17.2 - Plugin 2.
--- Im Simulator wird dafuer ein fester Rueckgabewert von 15 verwendet.
function EEPGetCurrentFrame() return Runtime.callEEPGetCurrentFrame() end

--- Gibt den gesamten Bildzaehler inklusive Bearbeitungs- und Pausenmodus zurueck.
--- Ab: EEP 17.2 - Plugin 2.
--- Im Simulator wird dafuer ein fester Rueckgabewert von 15948 verwendet.
function EEPGetCurrentRenderFrame() return Runtime.callEEPGetCurrentRenderFrame() end

--- Gibt den aktuell in EEP eingestellten Zeitrafferfaktor zurueck.
--- Ab: EEP 17.2 - Plugin 2.
--- Im Simulator wird dafuer ein fester Rueckgabewert von 1 verwendet.
function EEPGetTimeLapse() return Runtime.callEEPGetTimeLapse() end

--- Setzt die Farbparameter voruebergehend.
--- Ab: EEP 17.3 - Plugin 3.
--- Im Simulator ist diese Funktion derzeit nur als Stub ohne Laufzeitwirkung
--- vorhanden.
function EEPSetColourFilter(hue, saturation, brightness, contrast)
    return Runtime.callEEPSetColourFilter(hue,
                                          saturation, brightness, contrast)
end

--- Weist einem Zug eine Geschwindigkeit zu.
--- Ab: EEP 11.
function EEPSetTrainSpeed(trainName, speed, useTargetSpeed)
    return Runtime.callEEPSetTrainSpeed(trainName, speed, useTargetSpeed)
end

--- Ermittelt die aktuelle oder gewuenschte Geschwindigkeit eines Zuges.
--- Ab: EEP 11.
function EEPGetTrainSpeed(trainName, useTargetSpeed)
    return Runtime.callEEPGetTrainSpeed(trainName, useTargetSpeed)
end

--- Stellt die hintere Kupplung eines Rollmaterials um.
--- Ab: EEP 11.0.
function EEPRollingstockSetCouplingRear(rsName, kupplungsStatus)
    return Runtime.callEEPRollingstockSetCouplingRear(
        rsName, kupplungsStatus)
end

--- Ermittelt die Stellung der hinteren Kupplung eines Rollmaterials.
--- Ab: EEP 11.0.
function EEPRollingstockGetCouplingRear(rollingstockName)
    return Runtime.callEEPRollingstockGetCouplingRear(rollingstockName)
end

--- Stellt die vordere Kupplung eines Rollmaterials um.
--- Ab: EEP 11.0.
function EEPRollingstockSetCouplingFront(rsName, kupplungsStatus)
    return Runtime.callEEPRollingstockSetCouplingFront(
        rsName, kupplungsStatus)
end

--- Ermittelt die Stellung der vorderen Kupplung eines Rollmaterials.
--- Ab: EEP 11.0.
function EEPRollingstockGetCouplingFront(rollingstockName)
    return Runtime.callEEPRollingstockGetCouplingFront(rollingstockName)
end

--- Bewegt alle Achsen eines Rollmaterials auf eine gespeicherte Achsgruppe.
--- Ab: EEP 11.0.
function EEPRollingstockSetSlot(rsName, slot) return Runtime.callEEPRollingstockSetSlot(rsName, slot) end

--- Bewegt die mittels Achsname benannte Achse des benannten Rollmaterials in eine gewuenschte Position.
--- Ab: EEP 11.0.
function EEPRollingstockSetAxis(rollingstockName, axisName, axisPosition, useNameFilter)
    return Runtime.callEEPRollingstockSetAxis(rollingstockName, axisName,
                                                 axisPosition, useNameFilter)
end

--- Ermittelt die aktuelle Position einer mittels Achsnamen benannten Achse des benannten Rollmaterials.
--- Ab: EEP 11.0.
function EEPRollingstockGetAxis(rollingstockName, axisName)
    return Runtime.callEEPRollingstockGetAxis(rollingstockName, axisName)
end

--- Laedt einen Wert aus einem Datenslot.
--- Ab: EEP 11.
function EEPLoadData(slot) return Runtime.callEEPLoadData(slot) end

--- Speichert einen Wert in einem Datenslot.
--- Ab: EEP 11.
function EEPSaveData(storageSlot, value) return Runtime.callEEPSaveData(storageSlot, value) end

--- Schaltet den Rauch der benannten Immobilie an oder aus.
--- Ab: EEP 11.1 - Plugin 1.
function EEPStructureSetSmoke(immoName, onoff) return Runtime.callEEPStructureSetSmoke(immoName, onoff) end

--- Ermittelt, ob der Rauch der benannten Immobilie an- oder ausgeschaltet ist.
--- Ab: EEP 11.1 - Plugin 1.
function EEPStructureGetSmoke(luaName) return Runtime.callEEPStructureGetSmoke(luaName) end

--- Schaltet das Licht der benannten Immobilie an oder aus.
--- Ab: EEP 11.1 - Plugin 1.
function EEPStructureSetLight(name, onoff) return Runtime.callEEPStructureSetLight(name, onoff) end

--- Ermittelt, ob das Licht der benannten Immobilie eingeschaltet ist.
--- Ab: EEP 11.1.
function EEPStructureGetLight(luaName) return Runtime.callEEPStructureGetLight(luaName) end

--- Schaltet das Feuer der benannten Immobilie an oder aus.
--- Ab: EEP 11.1 - Plugin 1.
function EEPStructureSetFire(immoName, onoff) return Runtime.callEEPStructureSetFire(immoName, onoff) end

--- Ermittelt, ob das Feuer der benannten Immobilie an- oder ausgeschaltet ist.
--- Ab: EEP 11.1 - Plugin 1.
function EEPStructureGetFire(luaName) return Runtime.callEEPStructureGetFire(luaName) end

--- Bewegt die Achse einer Immobilie oder eines Gleisobjekts.
--- Ab: EEP 11.1 - Plugin 1.
function EEPStructureAnimateAxis(immoName, achse, schritte)
    return Runtime.callEEPStructureAnimateAxis(immoName, achse,
                                               schritte)
end

--- Setzt eine Achse einer Immobilie oder eines Gleisobjekts ohne Animation.
--- Ab: EEP 11.1 - Plugin 1.
function EEPStructureSetAxis(luaName, axisName, axisPosition)
    return Runtime.callEEPStructureSetAxis(luaName, axisName, axisPosition)
end

--- Ermittelt die Stellung einer mittels Achsnamen definierten Achse der benannten Immobilie oder des Gleisobjekts.
--- Ab: EEP 11.1 - Plugin 1.
function EEPStructureGetAxis(immoName, achse) return Runtime.callEEPStructureGetAxis(immoName, achse) end

--- Versetzt die benannte Immobilie oder das Landschaftselement an eine neue Position.
--- Ab: EEP 11.1 - Plugin 1.
function EEPStructureSetPosition(luaName, posX, posY, posZ)
    return Runtime.callEEPStructureSetPosition(luaName, posX,
                                               posY, posZ)
end

--- Dreht die benannte Immobilie oder das Landschaftselement in eine neue Position.
--- Ab: EEP 11.1 - Plugin 1.
function EEPStructureSetRotation(luaName, rotX, rotY, rotZ)
    return Runtime.callEEPStructureSetRotation(luaName, rotX,
                                               rotY, rotZ)
end

--- Weist einem Zug eine Route zu.
--- Ab: EEP 11.2 - Plugin 2.
function EEPSetTrainRoute(trainName, routeName) return Runtime.callEEPSetTrainRoute(trainName, routeName) end

--- Ermittelt die Route eines Zuges.
--- Ab: EEP 11.2 - Plugin 2.
function EEPGetTrainRoute(trainName) return Runtime.callEEPGetTrainRoute(trainName) end

--- Schaltet Licht, Blinker oder Bremslicht-Automatik eines Zuges.
--- Ab: EEP 11.2 - Plugin 2.
function EEPSetTrainLight(trainName, enabled, lightSource)
    return Runtime.callEEPSetTrainLight(trainName, enabled, lightSource)
end

--- Ermittelt den Zustand von Licht, Blinker oder Bremslicht-Automatik eines Zuges.
--- Ab: EEP 18.0.
function EEPGetTrainLight(trainName, quelle) return Runtime.callEEPGetTrainLight(trainName, quelle) end

--- Schaltet den Rauch eines Zuges an oder aus.
--- Ab: EEP 11.2 - Plugin 2.
function EEPSetTrainSmoke(trainName, enabled) return Runtime.callEEPSetTrainSmoke(trainName, enabled) end

--- Loest den Warnton eines Zuges aus.
--- Ab: EEP 11.2 - Plugin 2.
function EEPSetTrainHorn(trainName, onoff) return Runtime.callEEPSetTrainHorn(trainName, onoff) end

--- Stellt die vordere Kupplung eines Zuges auf Kuppeln oder Abstossen.
--- Ab: EEP 11.2 - Plugin 2.
function EEPSetTrainCouplingFront(trainName, couple)
    return Runtime.callEEPSetTrainCouplingFront(trainName,
                                                couple)
end

--- Ermittelt den Zustand der vorderen Kupplung eines Zuges.
--- Ab: EEP 18.0.
function EEPGetTrainCouplingFront(trainName) return Runtime.callEEPGetTrainCouplingFront(trainName) end

--- Stellt die hintere Kupplung eines Zuges auf Kuppeln oder Abstossen.
--- Ab: EEP 11.2 - Plugin 2.
function EEPSetTrainCouplingRear(trainName, kupplungOn)
    return Runtime.callEEPSetTrainCouplingRear(trainName, kupplungOn)
end

--- Ermittelt den Zustand der hinteren Kupplung eines Zuges.
--- Ab: EEP 18.0.
function EEPGetTrainCouplingRear(trainName) return Runtime.callEEPGetTrainCouplingRear(trainName) end

--- Trennt einen Zug an der angegebenen Stelle.
--- Ab: EEP 11.2 - Plugin 2.
function EEPTrainLooseCoupling(trainName, countFromFront, position)
    return Runtime.callEEPTrainLooseCoupling(trainName,
                                             countFromFront, position)
end

--- Schaltet den Gueterhaken eines Zuges an oder aus.
--- Ab: EEP 11.2 - Plugin 2.
function EEPSetTrainHook(trainName, enabled) return Runtime.callEEPSetTrainHook(trainName, enabled) end

--- Animiert ausgewaehlte Achsen eines Zuges.
--- Ab: EEP 11.2 - Plugin 2.
function EEPSetTrainAxis(trainName, achse, stellung)
    return Runtime.callEEPSetTrainAxis(trainName, achse, stellung)
end

------------------------------
-- Neu ab EEP 11 - Plugin 2 --
------------------------------

--- Registriert ein Gleiselement fuer Besetztabfragen.
--- Ab: EEP 11.3 - Plugin 3.
function EEPRegisterRailTrack(railTrackId) return Runtime.callEEPRegisterRailTrack(railTrackId) end

--- Ermittelt, ob ein Gleiselement besetzt ist, und optional den Zugnamen.
--- Ab: EEP 11.3 - Plugin 3.
function EEPIsRailTrackReserved(trackId, returnTrainName)
    return Runtime.callEEPIsRailTrackReserved(trackId,
                                              returnTrainName)
end

--- Registriert ein Strassenelement fuer Besetztabfragen.
--- Ab: EEP 11.3 - Plugin 3.
function EEPRegisterRoadTrack(roadTrackId) return Runtime.callEEPRegisterRoadTrack(roadTrackId) end

--- Ermittelt, ob ein Strassenelement besetzt ist, und optional den Zugnamen.
--- Ab: EEP 11.3 - Plugin 3.
function EEPIsRoadTrackReserved(trackId, returnTrainName)
    return Runtime.callEEPIsRoadTrackReserved(trackId,
                                              returnTrainName)
end

--- Registriert ein Strassenbahngleis fuer Besetztabfragen.
--- Ab: EEP 11.3 - Plugin 3.
function EEPRegisterTramTrack(tramTrackId) return Runtime.callEEPRegisterTramTrack(tramTrackId) end

--- Ermittelt, ob ein Strassenbahngleis besetzt ist, und optional den Zugnamen.
--- Ab: EEP 11.3 - Plugin 3.
function EEPIsTramTrackReserved(tramTrackId, returnTrainName)
    return Runtime.callEEPIsTramTrackReserved(tramTrackId,
                                              returnTrainName)
end

--- Registriert ein Weg-Element der Kategorie "Sonstige" fuer Besetztabfragen.
--- Ab: EEP 11.3 - Plugin 3.
function EEPRegisterAuxiliaryTrack(auxiliaryTrackId)
    return Runtime.callEEPRegisterAuxiliaryTrack(auxiliaryTrackId)
end

--- Ermittelt, ob ein sonstiges Weg-Element besetzt ist, und optional den Zugnamen.
--- Ab: EEP 11.3 - Plugin 3.
function EEPIsAuxiliaryTrackReserved(auxTrackId, returnTrainName)
    return Runtime.callEEPIsAuxiliaryTrackReserved(
        auxTrackId, returnTrainName)
end

--- Registriert ein Steuerstrecken-Element fuer Besetztabfragen.
--- Ab: EEP 11.3 - Plugin 3.
function EEPRegisterControlTrack(controlTrackId) return Runtime.callEEPRegisterControlTrack(controlTrackId) end

--- Ermittelt, ob ein Steuerstrecken-Element besetzt ist, und optional den Zugnamen.
--- Ab: EEP 11.3 - Plugin 3.
function EEPIsControlTrackReserved(controlTrackId, returnTrainName)
    return Runtime.callEEPIsControlTrackReserved(
        controlTrackId, returnTrainName)
end

--- Waehlt eine der gespeicherten Kameras aus der Liste.
--- Ab: EEP 11.3 - Plugin 3.
function EEPSetCamera(cameraType, cameraName) return Runtime.callEEPSetCamera(cameraType, cameraName) end

--- Waehlt eine der Verfolger-Kameras fuer den angegebenen "Fahrzeugverband".
--- Ab: EEP 11.3.
function EEPSetPerspectiveCamera(camPosition, trainName)
    return Runtime.callEEPSetPerspectiveCamera(camPosition,
                                               trainName)
end

--- Gibt an, welche Verfolger-Kamera fuer den angegebenen bzw. aktiven "Fahrzeugverband" ausgewaehlt ist.
--- Ab: EEP 18.0.
function EEPGetPerspectiveCamera(trainName) return Runtime.callEEPGetPerspectiveCamera(trainName) end

--- Schickt einen ausgewaehlten "Fahrzeugverband" aus einem ausgewaehlten virtuellen Depot.
--- Ab: EEP 11.3 - Plugin 2.
function EEPGetTrainFromTrainyard(depotId, trainName, depotSlot, departureOrientation)
    return Runtime.callEEPGetTrainFromTrainyard(depotId,
                                                trainName, depotSlot, departureOrientation)
end

--- Ermittelt, ob sich ein Zug in einem virtuellen Depot befindet.
--- Ab: EEP 18.1 - Plugin 1.
function EEPIsTrainInTrainyard(trainName) return Runtime.callEEPIsTrainInTrainyard(trainName) end

--- Verschiebt einen "Fahrzeugverband" oder alle dort registrierten in ein virtuelles Depot.
--- Ab: EEP 18.1 - Plugin 1.
function EEPPutTrainToTrainyard(depotId, trainName) return Runtime.callEEPPutTrainToTrainyard(depotId, trainName) end

--- Schaltet den Tipp-Text einer Immobilie oder eines Landschaftselements ein oder aus.
--- Ab: EEP 13.
function EEPShowInfoStructure(luaName, visible) return Runtime.callEEPShowInfoStructure(luaName, visible) end

--- Weist dem Tipp-Text einer Immobilie oder eines Landschaftselements einen neuen Text zu.
--- Ab: EEP 13.
function EEPChangeInfoStructure(immoName, text) return Runtime.callEEPChangeInfoStructure(immoName, text) end

--- Schaltet den Tipp-Text eines Signals ein oder aus.
--- Ab: EEP 13.
function EEPShowInfoSignal(signalId, visible) return Runtime.callEEPShowInfoSignal(signalId, visible) end

--- Weist dem Tipp-Text eines Signals einen neuen Text zu.
--- Ab: EEP 13.
function EEPChangeInfoSignal(signalId, text) return Runtime.callEEPChangeInfoSignal(signalId, text) end

--- Schaltet den Tipp-Text einer Weiche ein oder aus.
--- Ab: EEP 13.
function EEPShowInfoSwitch(switchId, visible) return Runtime.callEEPShowInfoSwitch(switchId, visible) end

--- Weist dem Tipp-Text einer Weiche einen neuen Text zu.
--- Ab: EEP 13.
function EEPChangeInfoSwitch(switchId, text) return Runtime.callEEPChangeInfoSwitch(switchId, text) end

-------------------------------
-- Neu ab EEP 13 - Plugin 2  --
-------------------------------

--- Gibt die Anzahl der Fahrzeuge eines Zuges zurueck.
--- Ab: EEP 13.2 - Plugin 2.
function EEPGetRollingstockItemsCount(trainName) return Runtime.callEEPGetRollingstockItemsCount(trainName) end

--- Gibt den Namen eines Fahrzeugs in einem Zug zurueck.
--- Ab: EEP 13.2 - Plugin 2.
function EEPGetRollingstockItemName(zugverband, Nummer)
    return Runtime.callEEPGetRollingstockItemName(zugverband, Nummer)
end

--- Gibt die Anzahl der von einem Signal beeinflussten Fahrzeugverbaende zurueck.
--- Ab: EEP 13.2 - Plugin 2.
function EEPGetSignalTrainsCount(signalId) return Runtime.callEEPGetSignalTrainsCount(signalId) end

--- Gibt den Namen eines von einem Signal beeinflussten Fahrzeugverbands zurueck.
--- Ab: EEP 13.2 - Plugin 2.
function EEPGetSignalTrainName(signalId, position) return Runtime.callEEPGetSignalTrainName(signalId, position) end

--- Liefert die Anzahl der im virtuellen Depot gefuehrten "Fahrzeugverbaende".
--- Ab: EEP 13.2 - Plugin 2.
function EEPGetTrainyardItemsCount(depotId) return Runtime.callEEPGetTrainyardItemsCount(depotId) end

--- Liefert den Namen eines "Fahrzeugverbands" im virtuellen Depot.
--- Ab: EEP 13.2 - Plugin 2.
function EEPGetTrainyardItemName(depotId, position) return Runtime.callEEPGetTrainyardItemName(depotId, position) end

--- Liefert den Status eines "Fahrzeugverbands" im virtuellen Depot.
--- Ab: EEP 13.2 - Plugin 2.
function EEPGetTrainyardItemStatus(depotId, trainName, depotSlot)
    return Runtime.callEEPGetTrainyardItemStatus(depotId,
                                                 trainName, depotSlot)
end

-------------------------------
-- Neu ab EEP 15  --
-------------------------------

--- Ermittelt die Laenge des angegebenen Fahrzeugs.
--- Ab: EEP 15.
function EEPRollingstockGetLength(rollingstockName) return Runtime.callEEPRollingstockGetLength(rollingstockName) end

--- Ermittelt, ob ein Fahrzeug motorisiert ist.
--- Ab: EEP 15.
function EEPRollingstockGetMotor(rollingStockName) return Runtime.callEEPRollingstockGetMotor(rollingStockName) end

--- Ermittelt Gleis, Position, Richtung und System des angegebenen Fahrzeugs.
--- Ab: EEP 15.
function EEPRollingstockGetTrack(rollingstockName) return Runtime.callEEPRollingstockGetTrack(rollingstockName) end

--- Ermittelt die Kategorie, zu welcher das genannte Fahrzeug gehoert.
--- Ab: EEP 15.
function EEPRollingstockGetModelType(rollingStockName)
    return Runtime.callEEPRollingstockGetModelType(rollingStockName)
end

--- Ermittelt die aktuelle Position einer Immobilie oder eines Landschaftselements.
--- Ab: EEP 15.
function EEPStructureGetPosition(luaName) return Runtime.callEEPStructureGetPosition(luaName) end

--- Ermittelt die Kategorie, zu welcher die genannte Immobilie oder das genannte Landschaftselement gehoert.
--- Ab: EEP 15.
function EEPStructureGetModelType(name) return Runtime.callEEPStructureGetModelType(name) end

--- Setzt den Tag-Text einer Immobilie oder eines Landschaftselements.
--- Ab: EEP 15.
function EEPStructureSetTagText(luaName, text) return Runtime.callEEPStructureSetTagText(luaName, text) end

--- Liest den Tag-Text einer Immobilie oder eines Landschaftselements.
--- Ab: EEP 15.
function EEPStructureGetTagText(name) return Runtime.callEEPStructureGetTagText(name) end

--- Setzt den Tag-Text eines Fahrzeugs.
--- Ab: EEP 15.
function EEPRollingstockSetTagText(rollingstockName, text)
    return Runtime.callEEPRollingstockSetTagText(rollingstockName, text)
end

--- Liest den Tag-Text eines Fahrzeugs.
--- Ab: EEP 15.
function EEPRollingstockGetTagText(name) return Runtime.callEEPRollingstockGetTagText(name) end

--- Setzt den Tag-Text eines Signals.
--- Ab: EEP 17.1 - Plugin 1.
function EEPSignalSetTagText(signalId, text) return Runtime.callEEPSignalSetTagText(signalId, text) end

--- Liest den Tag-Text eines Signals.
--- Ab: EEP 17.1 - Plugin 1.
function EEPSignalGetTagText(id) return Runtime.callEEPSignalGetTagText(id) end

--- Setzt den Tag-Text einer Weiche.
--- Ab: EEP 18.1 - Plugin 1.
function EEPSwitchSetTagText(switchId, text) return Runtime.callEEPSwitchSetTagText(switchId, text) end

--- Liest den Tag-Text einer Weiche.
--- Ab: EEP 18.1 - Plugin 1.
function EEPSwitchGetTagText(id) return Runtime.callEEPSwitchGetTagText(id) end

--- Setzt den Tag-Text eines Ladeguts.
--- Ab: EEP 18.0.
function EEPGoodsSetTagText(luaName, text) return Runtime.callEEPGoodsSetTagText(luaName, text) end

--- Liest den Tag-Text eines Ladeguts.
--- Ab: EEP 18.0.
function EEPGoodsGetTagText(name) return Runtime.callEEPGoodsGetTagText(name) end

--- Weist einer beschreibbaren Flaeche einer Immobilie oder eines Landschaftselements einen neuen Text zu.
--- Ab: EEP 15.
function EEPStructureSetTextureText(luaName, surfaceNumber, text)
    return Runtime.callEEPStructureSetTextureText(luaName, surfaceNumber,
                                                  text)
end

--- Liest den Text einer beschreibbaren Flaeche einer Immobilie oder eines Landschaftselements aus.
--- Ab: EEP 17.2 - Plugin 2.
function EEPStructureGetTextureText(luaName, surfaceNumber)
    return Runtime.callEEPStructureGetTextureText(luaName, surfaceNumber)
end

--- Weist einer beschreibbaren Flaeche eines Rollmaterials einen neuen Text zu.
--- Ab: EEP 15.
function EEPRollingstockSetTextureText(name, flaeche, text)
    return Runtime.callEEPRollingstockSetTextureText(name,
                                                     flaeche, text)
end

--- Weist einer beschreibbaren Flaeche eines Signals einen neuen Text zu.
--- Ab: EEP 15.
function EEPSignalSetTextureText(signalId, surfaceNumber, text)
    return Runtime.callEEPSignalSetTextureText(signalId, surfaceNumber, text)
end

--- Liest den Text einer beschreibbaren Flaeche eines Signals aus.
--- Ab: EEP 17.2 - Plugin 2.
function EEPSignalGetTextureText(id, flaeche) return Runtime.callEEPSignalGetTextureText(id, flaeche) end

--- Weist einer beschreibbaren Flaeche eines Ladeguts einen neuen Text zu.
--- Ab: EEP 15.
function EEPGoodsSetTextureText(luaName, surfaceNumber, text)
    return Runtime.callEEPGoodsSetTextureText(luaName, surfaceNumber, text)
end

--- Liest den Text einer beschreibbaren Flaeche eines Ladegutes aus.
--- Ab: EEP 17.2 - Plugin 2.
function EEPGoodsGetTextureText(name, flaeche) return Runtime.callEEPGoodsGetTextureText(name, flaeche) end

--- Weist einer beschreibbaren Flaeche eines Gleisstuecks einen neuen Text zu.
--- Ab: EEP 15.
function EEPRailTrackSetTextureText(railTrackId, surfaceNumber, text)
    return Runtime.callEEPRailTrackSetTextureText(railTrackId, surfaceNumber, text)
end

--- Liest den Text einer beschreibbaren Flaeche eines Gleisstuecks aus.
--- Ab: EEP 17.2 - Plugin 2.
function EEPRailTrackGetTextureText(id, flaeche) return Runtime.callEEPRailTrackGetTextureText(id, flaeche) end

--- Weist einer beschreibbaren Flaeche eines Strassenstuecks einen neuen Text zu.
--- Ab: EEP 15.
function EEPRoadTrackSetTextureText(roadTrackId, surfaceNumber, text)
    return Runtime.callEEPRoadTrackSetTextureText(roadTrackId, surfaceNumber, text)
end

--- Liest den Text einer beschreibbaren Flaeche eines Strassenstuecks aus.
--- Ab: EEP 17.2 - Plugin 2.
function EEPRoadTrackGetTextureText(id, flaeche) return Runtime.callEEPRoadTrackGetTextureText(id, flaeche) end

--- Weist einer beschreibbaren Flaeche eines Strassenbahngleisstuecks einen neuen Text zu.
--- Ab: EEP 15.
function EEPTramTrackSetTextureText(tramTrackId, surfaceNumber, text)
    return Runtime.callEEPTramTrackSetTextureText(tramTrackId, surfaceNumber, text)
end

--- Liest den Text einer beschreibbaren Flaeche eines Strassenbahngleisstuecks aus.
--- Ab: EEP 17.2 - Plugin 2.
function EEPTramTrackGetTextureText(id, flaeche) return Runtime.callEEPTramTrackGetTextureText(id, flaeche) end

--- Weist einer beschreibbaren Flaeche eines Weg-Elementes der Kategorie "Sonstige" einen neuen Text zu.
--- Ab: EEP 15.
function EEPAuxiliaryTrackSetTextureText(auxiliaryTrackId, surfaceNumber, text)
    return Runtime.callEEPAuxiliaryTrackSetTextureText(auxiliaryTrackId,
                                                       surfaceNumber, text)
end

--- Liest den Text einer beschreibbaren Flaeche eines Weg-Elementes der Kategorie "Sonstige" aus.
--- Ab: EEP 17.2 - Plugin 2.
function EEPAuxiliaryTrackGetTextureText(auxiliaryTrackId, surfaceNumber)
    return Runtime.callEEPAuxiliaryTrackGetTextureText(auxiliaryTrackId, surfaceNumber)
end

--- Ermittelt, welcher "Fahrzeugverband" derzeit im Steuerdialog ausgewaehlt ist.
--- Ab: EEP 15 - Plugin 1.
function EEPGetTrainActive() return Runtime.callEEPGetTrainActive() end

--- Waehlt den angegebenen "Fahrzeugverband" im Steuerdialog aus und stellt den Steuerdialog auf Automatik-Modus um.
--- Ab: EEP 15.1 - Plugin 1.
function EEPSetTrainActive(trainName) return Runtime.callEEPSetTrainActive(trainName) end

--- Ermittelt die Gesamtlaenge eines Zuges.
--- Ab: EEP 15.1 - Plugin 1.
function EEPGetTrainLength(trainName) return Runtime.callEEPGetTrainLength(trainName) end

--- Ermittelt, welches Fahrzeug derzeit im Steuerdialog ausgewaehlt ist.
--- Ab: EEP 15.1.
function EEPRollingstockGetActive() return Runtime.callEEPRollingstockGetActive() end

--- Waehlt das angegebene Fahrzeug im Steuerdialog aus und stellt den Steuerdialog auf manuellen Modus um.
--- Ab: EEP 15.1 - Plugin 1.
function EEPRollingstockSetActive(rollingstockName) return Runtime.callEEPRollingstockSetActive(rollingstockName) end

--- Ermittelt, welche relative Ausrichtung das angegebene Fahrzeug im "Fahrzeugverband" hat.
--- Ab: EEP 15.1 - Plugin 1.
function EEPRollingstockGetOrientation(rollingstockName)
    return Runtime.callEEPRollingstockGetOrientation(
        rollingstockName)
end

---------------------
-- Neu ab EEP 16.1 --
---------------------

--- Ruft ein Gleisbildstellpult (GBS) im Radarfenster auf.
--- Ab: EEP 16.1 - Plugin 1.
function EEPActivateCtrlDesk(ctrlDeskName) return Runtime.callEEPActivateCtrlDesk(ctrlDeskName) end

--- Laesst bei einem bestimmten Rollmaterial den Warnton (Pfeife, Hupe) ertoenen.
--- Ab: EEP 16.1 - Plugin 1.
function EEPRollingstockSetHorn(rollingstockName, status)
    return Runtime.callEEPRollingstockSetHorn(rollingstockName,
                                              status)
end

--- Schaltet bei einem bestimmten Rollmaterial den Haken an oder aus.
--- Ab: EEP 16.1 - Plugin 1.
function EEPRollingstockSetHook(rollingstockName, enabled)
    return Runtime.callEEPRollingstockSetHook(rollingstockName,
                                              enabled)
end

--- Ermittelt, ob der Haken eines bestimmten Rollmaterials an oder ausgeschaltet ist.
--- Ab: EEP 16.1 - Plugin 1.
function EEPRollingstockGetHook(rollingstockName) return Runtime.callEEPRollingstockGetHook(rollingstockName) end

--- Beeinflusst das Verhalten von Guetern an einem Kranhaken eines Rollmaterials.
--- Ab: EEP 16.1 - Plugin 1.
function EEPRollingstockSetHookGlue(rollingstockName, status)
    return Runtime.callEEPRollingstockSetHookGlue(
        rollingstockName, status)
end

--- Ermittelt das Verhalten von Guetern am Kranhaken eines Rollmaterials.
--- Ab: EEP 16.1 - Plugin 1.
function EEPRollingstockGetHookGlue(rollingstockName)
    return Runtime.callEEPRollingstockGetHookGlue(rollingstockName)
end

--- Ermittelt die zurueckgelegte Strecke des Rollmaterials.
--- Ab: EEP 16.1 - Plugin 1.
function EEPRollingstockGetMileage(rollingstockName)
    return Runtime.callEEPRollingstockGetMileage(rollingstockName)
end

--- Ermittelt die Position des Rollmaterials im EEP-Koordinatensystem.
--- Ab: EEP 16.1 - Plugin 1.
function EEPRollingstockGetPosition(rollingstockName)
    return Runtime.callEEPRollingstockGetPosition(rollingstockName)
end

--- Liest den Text einer beschreibbaren Flaeche eines Rollmaterials aus.
--- Ab: EEP 16.3 - Plugin 3.
function EEPRollingstockGetTextureText(rollingstockName, fleache)
    return Runtime.callEEPRollingstockGetTextureText(
        rollingstockName, fleache)
end

--- Definiert die benutzerdefinierte Mitfahrkamera eines Rollmaterials.
--- Ab: EEP 16.1 - Plugin 1.
function EEPRollingstockSetUserCamera(rollingstockName, posX, posY, posZ, rotH, rotV)
    return Runtime.callEEPRollingstockSetUserCamera(rollingstockName, posX, posY, posZ, rotH, rotV)
end

--- Liest die benutzerdefinierte Mitfahrkamera eines Rollmaterials aus.
--- Ab: EEP 17.
function EEPRollingstockGetUserCamera(rollingstockName)
    return Runtime.callEEPRollingstockGetUserCamera(rollingstockName)
end

--- Ermittelt die Position der aktuellen Kamera.
--- Ab: EEP 16.1 - Plugin 1.
function EEPGetCameraPosition() return Runtime.callEEPGetCameraPosition() end

--- Ermittelt die Ausrichtung der aktuellen Kamera.
--- Ab: EEP 16.1 - Plugin 1.
function EEPGetCameraRotation() return Runtime.callEEPGetCameraRotation() end

--- Definiert die Position der aktuellen Kamera.
--- Ab: EEP 16.1 - Plugin 1.
function EEPSetCameraPosition(PosX, PosY, PosZ) return Runtime.callEEPSetCameraPosition(PosX, PosY, PosZ) end

--- Definiert die Ausrichtung der aktuellen Kamera.
--- Ab: EEP 16.1 - Plugin 1.
function EEPSetCameraRotation(rotX, rotY, rotZ) return Runtime.callEEPSetCameraRotation(rotX, rotY, rotZ) end

--- Ermittelt, ob der Rauch des benannten Rollmaterials, an- oder ausgeschaltet ist.
--- Ab: EEP 16.1 - Plugin 1.
function EEPRollingstockGetSmoke(rollingstockName) return Runtime.callEEPRollingstockGetSmoke(rollingstockName) end

--- Schaltet den Rauch des bennanten Rollmaterials an oder aus.
--- Ab: EEP 16.1 - Plugin 1.
function EEPRollingstockSetSmoke(rollingstockName, enabled)
    return Runtime.callEEPRollingstockSetSmoke(rollingstockName,
                                               enabled)
end

--- Ermittelt die aktuelle Ausrichtung eines Ladeguts auf der Anlage.
--- Ab: EEP 16.1 - Plugin 1.
function EEPGoodsGetRotation(luaName) return Runtime.callEEPGoodsGetRotation(luaName) end

--- Ermittelt die aktuelle Ausrichtung einer Immobilie oder eines Landschaftselements.
--- Ab: EEP 11.1 - Plugin 1.
function EEPStructureGetRotation(immobilieName) return Runtime.callEEPStructureGetRotation(immobilieName) end

--- Ermittelt die globale Windstaerke (ausserhalb eventueller Wetterzonen).
--- Ab: EEP 16.1 - Plugin 1.
function EEPGetWindIntensity() return Runtime.callEEPGetWindIntensity() end

--- Ermittelt die globale Regenstaerke (ausserhalb eventueller Wetterzonen).
--- Ab: EEP 16.1 - Plugin 1.
function EEPGetRainIntensity() return Runtime.callEEPGetRainIntensity() end

--- Ermittelt die globale Schneeintensitaet (ausserhalb eventueller Wetterzonen).
--- Ab: EEP 16.1 - Plugin 1.
function EEPGetSnowIntensity() return Runtime.callEEPGetSnowIntensity() end

--- Ermittelt die globale Hagelstaerke (ausserhalb eventueller Wetterzonen).
--- Ab: EEP 16.1 - Plugin 1.
function EEPGetHailIntensity() return Runtime.callEEPGetHailIntensity() end

--- Ermittelt die globale Nebeldichte (ausserhalb eventueller Wetterzonen).
--- Ab: EEP 16.1 - Plugin 1.
function EEPGetFogIntensity() return Runtime.callEEPGetFogIntensity() end

--- Ermittelt den globalen Wolkenanteil (ausserhalb eventueller Wetterzonen).
--- Ab: EEP 16.1 - Plugin 1.
function EEPGetCloudsIntensity() return Runtime.callEEPGetCloudsIntensity() end

-- Rueckwaertskompatibel: alter Name.
function EEPGetCloudIntensity() return Runtime.callEEPGetCloudIntensity() end

--- Veraendert die globale Windstaerke (ausserhalb eventueller Wetterzonen) zwischen 10 % und 100 % (entsprechend...
--- Ab: EEP 16.1 - Plugin 1.
function EEPSetWindIntensity(intensity) return Runtime.callEEPSetWindIntensity(intensity) end

--- Veraendert die globale Regenstaerke (ausserhalb eventueller Wetterzonen) zwischen 10 % und 100 % (entsprechend...
--- Ab: EEP 16.1 - Plugin 1.
function EEPSetRainIntensity(intensity) return Runtime.callEEPSetRainIntensity(intensity) end

--- Veraendert die globale Schneefallstaerke (ausserhalb eventueller Wetterzonen) zwischen 10 % und 100 %...
--- Ab: EEP 16.1 - Plugin 1.
function EEPSetSnowIntensity(intensity) return Runtime.callEEPSetSnowIntensity(intensity) end

--- Veraendert die globale Hagelstaerke (ausserhalb eventueller Wetterzonen) zwischen 10 % und 100 % (entsprechend...
--- Ab: EEP 16.1 - Plugin 1.
function EEPSetHailIntensity(intensity) return Runtime.callEEPSetHailIntensity(intensity) end

--- Veraendert die globale Nebeldichte (ausserhalb eventueller Wetterzonen) zwischen 10 % und 100 % (entsprechend...
--- Ab: EEP 16.1.
function EEPSetFogIntensity(intensity) return Runtime.callEEPSetFogIntensity(intensity) end

--- Schaltet global (ausserhalb eventueller Wetterzonen) auf ein Wolkenbild mit "blauem" Himmel und veraendert den...
--- Ab: EEP 16.1 - Plugin 1.
function EEPSetCloudsIntensity(intensity) return Runtime.callEEPSetCloudsIntensity(intensity) end

--- Aktiviert und deaktiviert die Pause in EEP.
--- Ab: EEP 14 - Plugin 1.
function EEPPause(value) return Runtime.callEEPPause(value) end

return EepSimulator
