if AkDebugLoad then print("[#Start] Loading ak.core.eep.EepSimulator ...") end

------------------
-- EEP Functions
------------------

--- Versionsnummer von EEP.
EEPVer = 16.1

-- Der Inhalt des EEP-EreignisFensters wird geloescht
function clearlog()
    -- print("Clear ...")
end

local EepSimulator = {}
EepSimulator.debug = false
---@type table<number,number>
local signalsTrainCount = {}
---@type string[]
local signalsTrainNames = {}
---@type table<string,string> train name to route name
local trainRoutes = {}
---@type table<number,string>
local registeredRoadTracks = {}
---@type table<number,string>
local registeredRailTracks = {}
---@type table<string,table>
local structures = {}
---@type table<string,table>
local trains = {}

---Add a train and its rollingStock
---@param trainName string Name of the train
---param ... string Name of the rollingstock
function EepSimulator.addTrain(trainName, ...)
    trains[trainName] = {...}
    EEPSetTrainSpeed(trainName, 0)
end

function EepSimulator.splitTrain(trainName, index)
    local newName = trainName .. ";001"
    ---@type string[]
    local oldRs = {}
    ---@type string[]
    local newRs = {}

    for i, rollingStockName in pairs(trains[trainName]) do
        table.insert(i <= index and oldRs or newRs, rollingStockName)
    end

    trains[trainName] = oldRs
    EepSimulator.addTrain(newName, table.unpack(newRs))
    if EepSimulator.debug then
        print(string.format("Old Train: %s    : %s\nNew Train: %s: %s", trainName, table.concat(oldRs, ","), newName,
                            table.concat(newRs, ",")))
    end
    if (EEPOnTrainLooseCoupling) then EEPOnTrainLooseCoupling(trainName, newName, trainName) end
end

local function stripImmoName(name) return name:gsub("(#%d*).*", "%1") end

local function updateTrainListSize(signalId)
    local count = 0
    for _, _ in pairs(signalsTrainNames[signalId]) do count = count + 1 end
    signalsTrainCount[signalId] = count
end

--- This will add a train to the signals queue
---@param signalId number
---@param trainName string
function EepSimulator.queueTrainOnSignal(signalId, trainName)
    assert(type(signalId) == "number", "Need 'signalId' as number")
    assert(type(trainName) == "string", "Need 'trainName' as string")

    signalsTrainNames[signalId] = signalsTrainNames[signalId] or {}
    table.insert(signalsTrainNames[signalId], trainName)
    updateTrainListSize(signalId)
end

--- This will remove a train from the signals queue
---@param signalId number
---@param trainName string
function EepSimulator.removeTrainFromSignal(signalId, trainName)
    assert(type(signalId) == "number", "Need 'signalId' as number")
    assert(type(trainName) == "string", "Need 'trainName' as string")

    signalsTrainNames[signalId] = signalsTrainNames[signalId] or {}
    for i, v in ipairs(signalsTrainNames[signalId]) do
        if trainName == v then
            table.remove(signalsTrainNames[signalId], i)
            break
        end
    end
    updateTrainListSize(signalId)
end

--- This will remove all trains from the signals queue
---@param signalId number
function EepSimulator.removeAllTrainFromSignal(signalId)
    assert(type(signalId) == "number", "Need 'signalId' as number")

    signalsTrainNames[signalId] = {}
    updateTrainListSize(signalId)
end

function EepSimulator.setzeZugAufStrasse(trackId, zugname) registeredRoadTracks[trackId] = zugname end

function EepSimulator.setzeZugAufGleis(trackId, zugname) registeredRailTracks[trackId] = zugname end

local signale = {}
local switches = {}

--- Setzt das Signal signalId auf die Stellung signalStellung.
-- Der Parameter informiereEepOnSignal sollte den Wert 1 haben
-- @param signalId Id des Signals
-- @param signalStellung Stellung des Signals
-- @param informiereEepOnSignal (optional) Wenn = 1 dann aktiviere Funktion EEPOnSignal_x()
-- @return ok 1 wenn das Signal und die gewuenschte Signalstellung existieren
-- oder 0, wenn eins von beidem nicht existiert.
function EEPSetSignal(signalId, signalStellung, informiereEepOnSignal)
    assert(signalId > 0)
    signale[signalId] = signalStellung
    return 1
end

--- Liefert die aktuelle Stellung des Signal x
-- @param signalId Id des Signals
-- @return Stellung des Signals, Wenn das abgefragte Signal nicht existiert, ist der Rueckgabewert 0.
function EEPGetSignal(signalId)
    assert(signalId > 0)
    return signale[signalId] and signale[signalId] or 2
end

--- Setzt die Weiche x auf die Stellung y. Der Wert activateEEPOnSwitch sollte den Wert 1 haben.
-- @param switchId Id der Weiche
-- @param switchPosition Stellung der Weiche
-- @param activateEEPOnSwitch (optional) Wenn = 1 dann aktiviere Funktion EEPOnSignal_x()
-- @return ok 1 wenn die Weiche und die gewuenschte Weichenstellung existieren
-- oder 0, wenn eins von beidem nicht existiert.
function EEPSetSwitch(switchId, switchPosition, activateEEPOnSwitch)
    switches[switchId] = switchPosition
    return 1
end

--- Liefert die aktuelle Stellung der Weiche x
function EEPGetSwitch(switchId) return switches[switchId] and switches[switchId] or 2 end

--- Das Signal x wird intern registriert
function EEPRegisterSignal(signalId) assert(type(signalId) == "number", "Need 'signalId' as number") end

--- Die Weiche x wird intern registriert
function EEPRegisterSwitch(switchId) assert(type(switchId) == "number", "Need 'switchId' as number") end

EEPTime = 0
EEPTimeH = 0
EEPTimeM = 0
EEPTimeS = 0

-------------------
-- Neu ab EEP 11 --
-------------------
local couplingFront = {}
local couplingRear = {}
local eepdata = {}
local trainSpeeds = {}
local structureAxis = {}

--- Geschwindigkeit aendern
-- @param trainName Name des Zuges
-- @param speed Geschwindigkeit
function EEPSetTrainSpeed(trainName, speed) trainSpeeds[trainName] = speed end

--- Geschwindigkeit lesen
---@param trainName string Name des Zuges
---@return boolean Ist der Zug vorhanden
---@return number Geschwindigkeit
function EEPGetTrainSpeed(trainName) return trainSpeeds[trainName] ~= nil, trainSpeeds[trainName] or 0 end

--- Setzen der Kupplung (hinten)
-- @param rsName Name des Rollmaterial,
-- @param kupplungsStatus 1-Kupplung aktiv, 2-Kupplung inaktiv, 3-Wagen angekoppelt(nurGet),
-- z.B.: EEPRollingstockSetCouplingRear("DB 212309", 2)
function EEPRollingstockSetCouplingRear(rsName, kupplungsStatus) couplingRear[rsName] = kupplungsStatus end

--- Abfragen der Kupplung (hinten)
-- @param rsName Name des Rollmaterial,
-- @param kupplungsStatus 1-Kupplung aktiv, 2-Kupplung inaktiv, 3-Wagen angekoppelt(nurGet),
function EEPRollingstockGetCouplingRear(rsName) return couplingRear[rsName] end

--- Setzen der Kupplung (vorn)
-- @param rsName Name des Rollmaterial,
-- @param kupplungsStatus 1-Kupplung aktiv, 2-Kupplung inaktiv, 3-Wagen angekoppelt(nurGet),
-- z.B.: EEPRollingstockSetCouplingFront("DB212 309", 2)
function EEPRollingstockSetCouplingFront(rsName, kupplungsStatus) couplingFront[rsName] = kupplungsStatus end

--- Abfragen der Kupplung (vorn)
-- @param rsName Name des Rollmaterial,
-- @param kupplungsStatus 1-Kupplung aktiv, 2-Kupplung inaktiv, 3-Wagen angekoppelt(nurGet),
function EEPRollingstockGetCouplingFront(rsName) return couplingFront[rsName] end

--------------------------------------------------------------------------
-- Siehe hierzu auch Handbuch EEP 11(Achsgruppen) Setzen einer Achsgruppe,
-- z.B.: EEPRollingstockSetSlot("Loadingkran2Greifer", 1)
-- @param rsName Name des Rollmaterials als String
-- @param slot Slot mit der Achsstellung
--------------------------------------------------------------------------
function EEPRollingstockSetSlot(rsName, slot) end

--------------------------------------------------------------------------
--- Setzen einer Achse am Rollmaterial
-- z.B.: EEPRollingstockSetAxis("Bekohlungskranbruecke 1", "Drehung links", 50)
-- @param rsName Name des Rollmaterials als String
-- @param achse Name der Achse
-- @param stellung 0 - 100 - Achsstellung
--------------------------------------------------------------------------
function EEPRollingstockSetAxis(rsName, achse, stellung) end

--- Gibt die Stellung der Achse am Rollmaterial zurueck
-- z.B.: EEPRollingstockSetAxis("Bekohlungskranbr?cke 1", "Drehung links", 50)
-- @param rsName Name des Rollmaterials als String
-- @param achse Name der Achse
function EEPRollingstockGetAxis(rsName, achse) end

--- Laedt Daten aus Slot
-- @param slot Slot 1 bis 1000
-- @return true (wenn gefunden), Boolean|Zahl|"String"| nil
function EEPLoadData(slot) return ((eepdata[slot] or eepdata[slot] == false) and true or false), eepdata[slot] end

--- Speichert Daten in Slot
-- @param slot Slot 1 bis 1000
-- @param data Boolean|Zahl|"String"| nil
function EEPSaveData(slot, data)
    eepdata[slot] = data
    return true
end

------------------------------
-- Neu ab EEP 11 - Plugin 1 --
------------------------------
--- Rauch einschalten
-- @param immoName Name der Immobilie als String.
-- @param onoff true oder false
function EEPStructureSetSmoke(immoName, onoff) end

--- Rauch abfreagen
-- @param immoName Name der Immobilie als String.
function EEPStructureGetSmoke(immoName) end

--- Licht einschalten
-- @param immoName Name der Immobilie als String.
-- @param onoff true oder false
function EEPStructureSetLight(name, onoff)
    local strippedName = stripImmoName(name)
    structures[strippedName] = structures[strippedName] or {}
    structures[strippedName].light = onoff
end

--- Licht abfragen
-- @param immoName Name der Immobilie als String.
function EEPStructureGetLight(name)
    local strippedName = stripImmoName(name)
    if structures[strippedName] then
        return true, structures[strippedName].light or false
    else
        return false, false
    end
end

--- Feuer einschalten
-- @param immoName Name der Immobilie als String.
-- @param onoff true oder false
function EEPStructureSetFire(immoName, onoff) end

--- Feuer abfragen
-- @param immoName Name der Immobilie als String.
function EEPStructureGetFire(immoName) end

--- Setzen einer Achse einer Immobilie.
-- @param immoName Name der Immobilie als String.
-- @param achse Name der Achse
-- @param schritte 1000 bzw. -1000: endlos, 0: Stopp, sonst Schritte
function EEPStructureAnimateAxis(immoName, achse, schritte) end

--- Setzen einer Achse einer Immobilie
-- @param immoName Name der Immobilie als String.
-- @param achse Name der Achse
-- @param stellung position der Achse
function EEPStructureSetAxis(immoName, achse, stellung)
    if not structureAxis[immoName] then structureAxis[immoName] = {} end
    structureAxis[immoName][achse] = stellung
end

--- Gibt die Stellung der Achse am Rollmaterial zurueck.
-- z.B.: EEPRollingstockSetAxis("Bekohlungskranbruecke 1", "Drehung links", 50)
-- @param immoName Name der Immobilie als String.
-- @param achse Name der Achse
function EEPStructureGetAxis(immoName, achse)
    return true, structureAxis[immoName] and structureAxis[immoName][achse] or 0
end

--- Setzen der Position einer Immobilie
-- @param immoName Name der Immobilie als String.
-- @param posX x-Position
-- @param posY y-Position
-- @param posZ z-Position
function EEPStructureSetPosition(immoName, posX, posY, posZ) end

--- Setzen der Rotation einer Immobilie
-- @param immoName Name der Immobilie als String.
-- @param rotX x-Position
-- @param rotY y-Position
-- @param rotZ z-Position
function EEPStructureSetPosition(immoName, rotX, rotY, rotZ) end

------------------------------
-- Neu ab EEP 11 - Plugin 2 --
------------------------------
--- Route aendern
---@param trainName string Name des Zuges
---@param route string Name der Route
function EEPSetTrainRoute(trainName, route) trainRoutes[trainName] = route end

--- Route abfragen - return ok und Name der Route
---@param trainName string Name des Zuges
---@return boolean, string
function EEPGetTrainRoute(trainName) return true, trainRoutes[trainName] and trainRoutes[trainName] or "Alle" end

--- Licht ein oder ausschalten
-- @param trainName Name des Zuges
-- @param onoff true: ein, false: aus
function EEPSetTrainLight(trainName, onoff) end

--- Rauch ein oder ausschalten
-- @param trainName Name des Zuges
-- @param onoff true: ein, false: aus
function EEPSetTrainSmoke(trainName, onfoff) end

--- Hupen
-- @param trainName Name des Zuges
-- @param onoff true: signal starten, false: signal beenden
function EEPSetTrainHorn(trainName, onoff) end

--- Kupplung vorn setzen
-- @param trainName Name des Zuges
-- @param kupplungOn true: kuppeln, false: abstoﬂen
function EEPSetTrainCouplingFront(trainName, kupplungOn) end

--- Kupplung hinten setzen
-- @param trainName Name des Zuges
-- @param kupplungOn true: kuppeln, false: abstoﬂen
function EEPSetTrainCouplingRear(trainName, kupplungOn) end

--- Zugverband an bestimmter Stelle trennen
-- @param trainName Name des Zuges
-- @param countFromFront true: von vorne zaehlen, false: von hinten zaehlen
-- @param position Stelle, die getrennt wird
function EEPSetTrainLooseCoupling(trainName, countFromFront, position) end

--- Setzen des Gueterhakens an allen Wagen eines Zuges
-- @param trainName Name des Zuges als String
-- @param hookOn true: Haken fuer alle an
function EEPSetTrainHook(trainName, gueteran) end

--- Setzen einer Achse an allen Wagen eines Zuges
-- @param trainName Name des Zuges als String
-- @param achse Name der Achse
-- @param stellung 0 - 100 - Achsstellung
function EEPSetTrainAxis(trainName, achse, stellung) end

------------------------------
-- Neu ab EEP 11 - Plugin 2 --
------------------------------

--- Registriert ein Gleis fuer die Besetztabfrage.
-- @param trackId Id des Gleises
function EEPRegisterRailTrack(trackId)
    if registeredRailTracks[trackId] == nil then registeredRailTracks[trackId] = false end
    if (trackId <= 11) then return true end
end

--- Fragt ab, ob ein Gleis besetzt ist.
-- @param trackId Id des Gleises
-- @param returnTrainName wenn true, wird als dritter Wert der Zugname
-- zurueckgegeben
-- @return Erster Wert: true, wenn Gleis existiert und registriert,
-- zweiter Wert: true, wenn besetzt,
-- dritter Wert: Name des Zuges auf dem Gleis
function EEPIsRailTrackReserved(trackId, returnTrainName)
    if returnTrainName then
        return (registeredRailTracks[trackId] ~= nil and true or false),
               (registeredRailTracks[trackId] ~= false and true or false),
               (returnTrainName and registeredRailTracks[trackId] or nil)
    else
        return (registeredRailTracks[trackId] ~= nil and true or false),
               (registeredRailTracks[trackId] ~= false and true or false)
    end
end

--- Registriert ein Gleis fuer die Besetztabfrage.
-- @param trackId Id des Gleises
function EEPRegisterRoadTrack(trackId)
    if registeredRoadTracks[trackId] == nil then registeredRoadTracks[trackId] = false end
    if (trackId <= 11) then return true end
end

--- Fragt ab, ob ein Gleis besetzt ist.
---@param trackId number Id des Gleises
---@param returnTrainName boolean wenn true, wird als dritter Wert der Zugname
-- @return boolean, boolean, string
-- Erster Wert: true, wenn Gleis existiert und registriert,
-- zweiter Wert: true, wenn besetzt,
-- dritter Wert: Name des Zuges auf dem Gleis
function EEPIsRoadTrackReserved(trackId, returnTrainName)
    if returnTrainName then
        return (registeredRoadTracks[trackId] ~= nil and true or false),
               (registeredRoadTracks[trackId] ~= false and true or false),
               (returnTrainName and registeredRoadTracks[trackId] or nil)
    else
        return (registeredRoadTracks[trackId] ~= nil and true or false),
               (registeredRoadTracks[trackId] ~= false and true or false)
    end
end

--- Registriert ein Gleis fuer die Besetztabfrage.
-- @param tramTrackId Id des Gleises
function EEPRegisterTramTrack(tramTrackId) end

--- Fragt ab, ob ein Gleis besetzt ist.
-- @param tramTrackId Id des Gleises
-- @param returnTrainName wenn true, wird als dritter Wert der Zugname
-- @return Erster Wert: true, wenn Gleis existiert und registriert,
-- zweiter Wert: true, wenn besetzt,
-- dritter Wert: Name des Zuges auf dem Gleis
function EEPIsTramTrackReserved(tramTrackId, returnTrainName) end

--- Registriert ein Gleis fuer die Besetztabfrage.
-- @param auxTrackId Id des Gleises
function EEPRegisterAuxiliaryTrack(auxTrackId) end

--- Fragt ab, ob ein Gleis besetzt ist.
-- @param auxTrackId Id des Gleises
-- @param returnTrainName wenn true, wird als dritter Wert der Zugname
-- @return Erster Wert: true, wenn Gleis existiert und registriert,
-- zweiter Wert: true, wenn besetzt,
-- dritter Wert: Name des Zuges auf dem Gleis
function EEPIsAuxiliaryTrackReserved(auxTrackId, returnTrainName) end

--- Registriert ein Gleis fuer die Besetztabfrage.
-- @param controlTrackId Id des Gleises
function EEPRegisterControlTrack(controlTrackId) end

--- Fragt ab, ob ein Gleis besetzt ist.
-- @param controlTrackId Id des Gleises
-- @return Erster Wert: true, wenn Gleis existiert und registriert,
-- zweiter Wert: true, wenn besetzt
function EEPIsControlTrackReserved(controlTrackId, returnTrainName) end

--- Waehlen einer Kamera
-- @param camType 0: statisch, 1: dynamisch, 2: mobile Kamera
-- @param camName Name der Kamera
-- @return true, wenn die Kamera existiert
function EEPSetCamera(camType, camName) end

--- Waehlen einer Kameraperspektive
-- @param camPosition Tasten 1 - 9 fuer die Kameraposition
-- @param trainName Name des Zuges
-- @return true, wenn die Kamera existiert
function EEPSetCamera(camPosition, trainName) end

--- Zug aus Depot starten
-- @param depotId Id des Depots (Eigenschaftenfenster)
-- @param trainName Name des Zuges
-- @param trainNumber Wenn kein Zugname angegeben ist, dann die Nummer des Zugs im Depot
-- @return true, wenn der Zug existiert
function EEPGetTrainFromTrainyard(depotId, trainName, trainNumber) end

-------------------------------
-- Neu ab EEP 13             --
-------------------------------
--- Zeigen / Verstecken des Tipp-Textes einer Immobilie
-- @param immoName Name der Immobilie als String.
-- @param onOff true: einschalten
function EEPShowInfoStructure(immoName, onOff) end

--- Setzen des Tipp-Textes einer Immobilie
-- @param immoName Name der Immobilie als String.
-- @param text Text fuer die Anzeige
function EEPChangeInfoStructure(immoName, text) end

--- Zeigen / Verstecken des Tipp-Textes einer Immobilie
-- @param switchId Name der Immobilie als String.
-- @param onOff true: einschalten
function EEPShowInfoSignal(signalId, onOff) assert(type(signalId) == "number", "Need 'signalId' as number") end

--- Setzen des Tipp-Textes einer Immobilie
-- @param switchId Name der Immobilie als String.
-- @param text Text fuer die Anzeige
function EEPChangeInfoSignal(signalId, text) assert(type(signalId) == "number", "Need 'signalId' as number") end

--- Zeigen / Verstecken des Tipp-Textes einer Weiche
-- @param switchId Name der Weiche als String.
-- @param onOff true: einschalten
function EEPShowInfoSwitch(switchId, onOff) end

--- Setzen des Tipp-Textes einer Weiche
-- @param switchId Name der Weiche als String.
-- @param text Text fuer die Anzeige
function EEPChangeInfoSwitch(switchId, text) end

-------------------------------
-- Neu ab EEP 13 - Plugin 2  --
-------------------------------

--- Anzahl der Fahrzeuge im Zugverband Name
-- @param zugverband Names des Zugverbandes
--
function EEPGetRollingstockItemsCount(zugverband)
    return trains[zugverband] and #trains[zugverband] > 0 and #trains[zugverband] or 0
end

--- Name des Rollis Nummer im Zugverband Name
-- @param zugverband Name des Zugverbandes
-- @param Nummer
--
function EEPGetRollingstockItemName(zugverband, Nummer) return trains[zugverband][Nummer + 1] end

--- Anzahl der Zuege, welche vom Signal Signal_ID gehalten werden
-- @param signalId ID des Signals
--
function EEPGetSignalTrainsCount(signalId) return signalsTrainCount[signalId] or 0 end

--- Name des Zuges Zahl, der vom Signal Signal_ID gehalten wird
-- @param signalId ID des Signals
-- @param position Position des Zuges am Signal
--
function EEPGetSignalTrainName(signalId, position)
    if signalsTrainNames[signalId] then
        if signalsTrainNames[signalId][position] then return signalsTrainNames[signalId][position] end
    end
    return "DUMMY"
end

--- Anzahl der Zuege, welche im Depot ZugdepotId gelistet sind
-- @param depotId ID des Zugdepots
-- @return count Anzahl der Fahrzeugverbaende
function EEPGetTrainyardItemsCount(depotId) return 5 end

--- Name des Zuges am DepotPlatz im Depot depotId
-- @param depotId ID des Zugdepots
-- @param position Position (Zahl) des Zugverbandes im Depot
-- @return trainName Name des Fahrzeugverbands
function EEPGetTrainyardItemName(depotId, position) return "#trainName" end

--- Status (wartet/auf Anlage) des Zuges Name am Platz im depotId
-- @param depotId ID des Zugdepots
-- @param zugverband Name des Zugverbandes
-- @param position Position (Zahl) des Zugverbandes im Depot
-- @return status Status des Fahrzeugverbands: 0 = in Fahrt , 1 = warten
function EEPGetTrainyardItemStatus(depotId, zugverband, position) return 1 end

-------------------------------
-- Neu ab EEP 15  --
-------------------------------

--- Argument ist der Name des Fahrzeugs.
-- Rueckgabewert 1 ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
-- Rueckgabewert 2 ist die Laenge des Fahrzeugs von Kupplung zu Kupplung in Metern.
function EEPRollingstockGetLength(rollingStockName) return true, 5 end

--- Argument ist der Name des Fahrzeugs.
-- Rueckgabewert 1 ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
-- Rueckgabewert 2 ist true, wenn das angegebene Fahrzeug einen Antrieb besitzt, sonst false.
function EEPRollingstockGetMotor(rollingStockName) return true, 5 end

--- Argument ist der Name des Fahrzeugs.
-- Rueckgabewert 1 ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
-- Rueckgabewert 2 ist die ID des Gleisstuecks, auf dem sich das Fahrzeug befindet.
-- Rueckgabewert 3 ist der Abstand (in Metern) zum Anfang des Gleisstuecks, auf dem sich das
-- Fahrzeug befindet.
-- Rueckgabewert 4 ist die Ausrichtung relativ zur Fahrtrichtung des Gleisstuecks, auf dem sich das
-- Fahrzeug befindet. 1 = in Fahrtrichtung, 0 = entgegen der Fahrtrichtung
-- Rueckgabewert 5 ist die Nummer des Gleissystems, auf dem das Fahrzeug unterwegs ist.
-- 1 = Bahngleise
-- 2 = Straﬂen
-- 3 = Tramgleise
-- 4 = sonstige Splines/Wasserwege
function EEPRollingstockGetTrack(rollingStockName) return true, 5, 5, 1, 1 end

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
function EEPRollingstockGetModelType(rollingStockName) return true, 1 end

--- Argument ist der Lua-Name der Immobilie oder des LS-Elements.
-- Es genuegt die Nummer mit vorangestelltem #-Zeichen.
-- @return
-- Rueckgabewert 1 ist true, wenn die Ausfuehrung erfolgreich war, ansonsten false.
-- Rueckgabewert 2 ist die X-Position des Objekts.
-- Rueckgabewert 3 ist die Y-Position des Objekts.
-- Rueckgabewert 4 ist die Z-Position des Objekts.
function EEPStructureGetPosition(name)
    local underscoreIndex = string.find(name, "_")
    local i

    if underscoreIndex then
        i = tonumber(string.sub(name, 2, underscoreIndex - 1))
    else
        i = tonumber(string.sub(name, 2))
    end

    if (i < 5) then
        return true, 0, 0, 0
    else
        return false
    end
end

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
function EEPStructureGetModelType(name)
    local underscoreIndex = string.find(name, "_")
    local i

    if underscoreIndex then
        i = tonumber(string.sub(name, 2, underscoreIndex - 1))
    else
        i = tonumber(string.sub(name, 2))
    end

    if (i < 5) then
        return true, 0, 0, 0
    else
        return false
    end
end

local tags = {structures = {}, rollingStock = {}}

--- √Ñndert den Tag-Text einer Immobilie. Jede Immobilie kann jetzt einen individuellen String von
--- maximal 1024 Zeichen Laenge mitfuehren. Diese Strings werden mit der Anlage gespeichert und
--- geladen.
--- Bemerkungen * Argument 1 ist der Lua-Name der Immobilie oder des LS-Elements.
--- Es genuegt die Nummer mit vorangestelltem #-Zeichen.
--- * Argument 2 ist der gewuenschte Text.
--- * Rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false
function EEPStructureGetTagText(name, tag)
    tags.structures[name] = tag
    return true
end

--- Liest den Tag-Text einer Immobilie aus. Mittels Tag-Texten k√∂nnen Immobilien als permanente
--- Speicher fuer relevante Informationen genutzt werden.
--- Bemerkungen
--- * Argument 1 ist der Lua-Name der Immobilie oder des LS-Elements.
--- Es genuegt die Nummer mit vorangestelltem #-Zeichen.
--- * Rueckgabewert 1 ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
--- * Rueckgabewert 2 ist der Tag-Text, welcher der Immobilie mitgegeben wurde
function EEPStructureGetTagText(name) return true, tags.structures[name] end

--- √Ñndert den Tag-Text eines Fahrzeugs. Jedes Fahrzeug kann jetzt einen eigenen String von
--- maximal 1024 Zeichen Laenge mitfuehren. Diese Strings werden mit der Anlage gespeichert und
--- geladen. Da die Texte individuell jedem Fahrzeug zugeordnet sind, gehen sie im Gegensatz zu
--- Routen nicht durch Rangierman√∂ver etc. verloren.
--- Bemerkungen
--- * Argument 1 ist der Name des Fahrzeugs.
--- * Argument 2 ist der gewuenschte Text.
--- * Rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPRollingstockSetTagText(name, tag)
    tags.rollingStock[name] = tag
    return true
end

--- Liest den Tag-Text eines Fahrzeugs aus. Mittels Tag-Texten k√∂nnen Fahrzeuge jetzt kategorisiert
--- werden. Beispielsweise kann man dort Waggontypen speichern oder Bestimmungsorte.
--- Bemerkungen
--- * Argument 1 ist der Name des Fahrzeugs.
--- * Rueckgabewert 1 ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
--- * Rueckgabewert 2 ist der Tag-Text, welcher dem Waggon mitgegeben wurde.
function EEPRollingstockGetTagText(name) return true, tags.rollingStock[name] end

function EEPStructureSetTextureText(name, flaeche, text) return true end
function EEPRollingstockSetTextureText(name, flaeche, text) return true end
function EEPSignalSetTextureText(id, flaeche, text) return true end
function EEPGoodsSetTextureText(name, flaeche, text) return true end
function EEPRailTrackSetTextureText(id, flaeche, text) return true end
function EEPRoadTrackSetTextureText(id, flaeche, text) return true end
function EEPTramTrackSetTextureText(id, flaeche, text) return true end
function EEPAuxiliaryTrackSetTextureText(id, flaeche, text) return true end

---------------------
-- Neu ab EEP 15.1 --
---------------------

local activeTrain = ""

--- Ermittelt, welcher Zug derzeit im Steuerdialog ausgewaehlt ist. (EEP 15.1)
-- Befindet sich der Steuerdialog im manuellen Modus, dann wird der Name des Zuges zurueckgegeben,
-- welcher das ausgewaehlte Fahrzeug enthaelt
-- @return trainName Name des Zuges
function EEPGetTrainActive() return activeTrain end

--- Waehlt den angegebenen Zug im Steuerdialog aus. (EEP 15.1)
-- Stellt den Steuerdialog auf Automatik-Modus um.
-- @param trainName Name des Zuges
-- @return ok Rueckgabewert ist true wenn die Aktion erfolgreich war, sonst false
function EEPSetTrainActive(trainName)
    activeTrain = trainName
    return true
end

--- Ermittelt die Gesamtlaenge des angegebenen Zuges. (EEP 15.1)
---@param trainName string Name des Zuges
---@return boolean ok Rueckgabewert ist true wenn der angesprochene Zug existiert, sonst false
---@return integer length Laenge des Zuges in Meter
function EEPGetTrainLength(trainName) return true, 50 end

local activeRollingstock = ""

--- Ermittelt, welches Fahrzeug derzeit im Steuerdialog ausgewaehlt ist. (EEP 15.1)
-- Befindet sich der Steuerdialog im Automatikmodus, dann wird ein leerer String zurueckgegeben.
-- @return rollingstockName Name des Rollmaterials
function EEPRollingstockGetActive() return activeRollingstock end

--- Waehlt das angegebene Fahrzeug im Steuerdialog aus. (EEP 15.1)
-- Stellt den Steuerdialog auf manuellen Modus um.
-- @param rollingstockName Name des Rollmaterials
-- @return ok Rueckgabewert ist true wenn die Aktion erfolgreich war, sonst false
function EEPRollingstockSetActive(rollingstockName)
    activeRollingstock = rollingstockName
    return true
end

--- Ermittelt, welche relative Ausrichtung das angegebene Fahrzeug im Zugverband hat. (EEP 15.1)
-- @param rollingstockName Name des Rollmaterials
-- @return ok Rueckgabewert ist true wenn der angesprochene Zug existiert, sonst false
-- @return orientation Ausrichtung des Rollmaterials, true, wenn das Fahrzeug vorwaerts ausgerichtet ist, sonst false
function EEPRollingstockGetOrientation(rollingstockName) return true, true end

---------------------
-- Neu ab EEP 16.1 --
---------------------

--- Ruft das Stellpult im Radarfenster auf. (EEP 16.1)
-- @param GBSname
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPActivateCtrlDesk(GBSname) return true end

--- Laesst bei einem bestimmten Rollmaterial den Warnton (Pfeife, Hupe) ert√∂nen. (EEP 16.1)
-- @param rollingstockName Name des Rollmaterials
-- @param status true = an, false = aus
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPRollingstockSetHorn(rollingstockName, status) return true end

local hook = {}

--- Schaltet bei einem bestimmten Rollmaterial den Haken an oder aus. (EEP 16.1)
-- @param rollingstockName Name des Rollmaterials
-- @param status true = an, false = aus
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPRollingstockSetHook(rollingstockName, status)
    hook[rollingstockName] = status
    return true
end

--- Ermittelt, ob der Haken eines bestimmten Rollmaterials an oder ausgeschaltet ist (EEP 16.1)
-- @param rollingstockName Name des Rollmaterials
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return status Haken aus = 0, an = 1, in Betrieb = 3
function EEPRollingstockGetHook(rollingstockName) return true, hook[rollingstockName] and 1 or 0 end

local hookGlue = {}

--- Beeinflusst das Verhalten von Guetern an einem Kranhaken eines Rollmaterials. (EEP 16.1)
-- @param rollingstockName Name des Rollmaterials
-- @param status true = an, false = aus
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPRollingstockSetHookGlue(rollingstockName, status)
    hookGlue[rollingstockName] = status
    return true
end

--- Ermittelt das Verhalten von Guetern am Kranhaken eines Rollmaterials  (EEP 16.1)
-- @param rollingstockName Name des Rollmaterials
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return status Gueterhaken aus = 0, an = 1, in Betrieb = 3
function EEPRollingstockGetHookGlue(rollingstockName)
    return true, hookGlue[rollingstockName] and hook[rollingstockName] or 0
end

--- Ermittelt die zurueckgelegte Strecke des Rollmaterials (EEP 16.1)
-- @param rollingstockName Name des Rollmaterials
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return mileage  Die in Metern zurueckgelegte Strecke des Rollmaterials seit dem Einsetzen in EEP
function EEPRollingstockGetMileage(rollingstockName) return true, 10 end

--- Ermittelt die Position des Rollmaterials im EEP-Koordinatensystem. (EEP 16.1)
-- @param rollingstockName Name des Rollmaterials
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return PosX
-- @return PosY
-- @return PosZ
function EEPRollingstockGetPosition(rollingstockName) return true, 100, -50, 3 end

local camera = {}

--- Definiert die Position der Benutzer-definierten Mitfahrkamera in Relation zum Fahrzeug (EEP 16.1)
-- Aufruf ueber Taste 9
-- @param rollingstockName Name des Rollmaterials
-- @param PosX Kameraposition
-- @param PosY Kameraposition
-- @param PosZ Kameraposition
-- @param RotX Kameraausrichtung (Drehung)
-- @param RotY Kameraausrichtung (Drehung)
-- @param RotZ Kameraausrichtung (Drehung)
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPRollingstockSetUserCamera(rollingstockName, PosX, PosY, PosZ, RotX, RotY, RotZ)
    camera.rollingstockName = rollingstockName
    camera.PosX = PosX
    camera.PosY = PosY
    camera.PosZ = PosZ
    camera.RotX = RotX
    camera.RotY = RotY
    camera.RotZ = RotZ
    return true
end

--- Ermittelt die aktuelle Position der Kamera (EEP 16.1)
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return PosX Kameraposition
-- @return PosY Kameraposition
-- @return PosZ Kameraposition
function EEPGetCameraPosition() return true, camera.PosX or 0, camera.PosY or 0, camera.PosZ or 0 end

--- Ermittelt die aktuelle Ausrichtung der Kamera (EEP 16.1)
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return RotX Kameraausrichtung (Drehung)
-- @return RotY Kameraausrichtung (Drehung)
-- @return RotZ Kameraausrichtung (Drehung)
function EEPGetCameraRotation() return true, camera.RotX or 0, camera.RotY or 0, camera.RotZ or 0 end

--- Definiert die Kameraposition (EEP 16.1)
-- @param PosX Kameraposition
-- @param PosY Kameraposition
-- @param PosZ Kameraposition
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPSetCameraPosition(PosX, PosY, PosZ)
    camera.PosX = PosX
    camera.PosY = PosY
    camera.PosZ = PosZ
    return true
end

--- Definiert die Kameraausrichtung (EEP 16.1)
-- @param RotX Kameraausrichtung (Drehung)
-- @param RotY Kameraausrichtung (Drehung)
-- @param RotZ Kameraausrichtung (Drehung)
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPSetCameraRotation(RotX, RotY, RotZ)
    camera.RotX = RotX
    camera.RotY = RotY
    camera.RotZ = RotZ
    return true
end

--- Ermittelt, ob der Rauch des benannten Rollmaterials, an- oder ausgeschaltet ist. (EEP 16.1)
-- @param rollingstockName Name des Rollmaterials
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return status Rauch aus = 0, an = 1
function EEPRollingstockGetSmoke(rollingstockName) return true, 0 end

--- Schaltet den Rauch des bennanten Rollmaterials an oder aus. (EEP 16.1)
-- @param rollingstockName Name des Rollmaterials
-- @param status Rauch an = true oder aus = false
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPRollingstockSetSmoke(rollingstockName, status) return true end

--- Ermittelt die Ausrichtung des Ladegutes. (EEP 16.1)
-- @param goodsName Name des Ladeguts
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return RotX Ausrichtung (Drehung)
-- @return RotY Ausrichtung (Drehung)
-- @return RotZ Ausrichtung (Drehung)
function EEPGoodsGetRotation(goodsName) return true, 60, 10, -20 end

--- Ermittelt die Ausrichtung der Immobilie/des Landschaftselementes. (EEP 16.1)
-- 0 @param immobilieName Name der Immobilie/des Landschaftselementes.
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return RotX Ausrichtung (Drehung)
-- @return RotY Ausrichtung (Drehung)
-- @return RotZ Ausrichtung (Drehung)
function EEPStructureGetRotation(immobilieName) return true, 60, 10, -20 end

local WindIntensity, RainIntensity, SnowIntensity, HailIntensity, FogIntensity, CloudIntensity

--- Ermittelt die Windstaerke. (EEP 16.1)
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return intensity Windstaerke in Prozent (%)
function EEPGetWindIntensity() return true, WindIntensity or 10 end

--- Ermittelt die Niederschlagintensitaet. (EEP 16.1)
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return intensity Niederschlagintensitaet in Prozent (%)
function EEPGetRainIntensity() return RainIntensity or 10 end

--- Ermittelt die Schneeintensitaet (EEP 16.1)
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return intensity Schneeintensitaet in Prozent (%)
function EEPGetSnowIntensity() return SnowIntensity or 10 end

--- Ermittelt die Hagelintensitaet (EEP 16.1)
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return intensity Hagelintensitaet in Prozent (%)
function EEPGetHailIntensity() return HailIntensity or 10 end

--- Ermittelt die Nebelintensitaet (EEP 16.1)
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return intensity Nebelintensitaet in Prozent (%)
function EEPGetFogIntensity() return FogIntensity or 10 end

--- Ermittelt der Wolkenanteil (EEP 16.1)
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
-- @return intensity Wolkenanteil in Prozent (%)
function EEPGetCloudIntensity() return CloudIntensity or 10 end

--- Definiert die Windstaerke (EEP 16.1)
-- @param Windstaerke
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPSetWindIntensity(intensity)
    WindIntensity = intensity
    return true
end

--- Veraendert die Niederschlagintensitaet (EEP 16.1)
-- @param Niederschlagintensitaet
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPSetRainIntensity(intensity)
    RainIntensity = intensity
    return true
end

--- Veraendert die Schneeintensitaet (EEP 16.1)
-- @param Schneeintensitaet
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPSetSnowIntensity(intensity)
    SnowIntensity = intensity
    return true
end

--- Veraendert die Hagelintensitaet (EEP 16.1)
-- @param Hagelintensitaet
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPSetHailIntensity(intensity)
    HailIntensity = intensity
    return true
end

--- Veraendert die Nebelintensitaet (EEP 16.1)
-- @param Nebelintensitaet
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPSetFogIntensity(intensity)
    FogIntensity = intensity
    return true
end

--- Veraendert den Wolkenanteil (EEP 16.1)
-- @param Wolkenanteil
-- @return ok Rueckgabewert ist true wenn die Ausfuehrung erfolgreich war, sonst false
function EEPSetCloudIntensity(intensity)
    CloudIntensity = intensity
    return true
end

--- EEP ruft selbstaendig diese Funktion auf, wenn die Anlage gespeichert wird. (EEP 16.1)
-- Im Skript definiert man die zugehoerige Funktion und legt so fest, was beim Speichern der Anlage zu tun ist.
-- @param path Speicherpfad der Anlage einschlieﬂlich Dateiname
function EEPOnSaveAnl(path) end

function EEPPause(value) end

return EepSimulator
