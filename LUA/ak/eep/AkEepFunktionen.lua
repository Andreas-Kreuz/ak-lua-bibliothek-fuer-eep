print("Lade AkEepFunktionen ...")

------------------
-- EEP Functions
------------------

EEPVer = 15

-- Der Inhalt des EEP-EreignisFensters wird geloescht
function clearlog()
    --print("Clear ...")
end

AkEEPHilfe = {}
AkEEPHilfe.zahlDerZuegeAnSignal = {}
AkEEPHilfe.namenDerZuegeAnSignal = {}
AkEEPHilfe.routenDerZuege = {}
AkEEPHilfe.registrierteStrassen = {}
function AkEEPHilfe.setzeZugAufStrasse(trackId, zugname)
    AkEEPHilfe.registrierteStrassen[trackId] = zugname
end

AkEEPHilfe.registrierteGleise = {}
function AkEEPHilfe.setzeZugAufGleis(trackId, zugname)
    AkEEPHilfe.registrierteGleise[trackId] = zugname
end


local signale = {}
local switches = {}

--- Setzt das Signal signalId auf die Stellung signalStellung. Der Wert z sollte den Wert 1 haben
-- @param signalId Id des Signals
-- @param signalStellung Stellung des Signals
function EEPSetSignal(signalId, signalStellung, z)
    signale[signalId] = signalStellung
end

--- Liefert die aktuelle Stellung des Signal x
-- @param switchId Id des Signals
-- @return Stellung des Signals
function EEPGetSignal(signalId)
    return signale[signalId] and signale[signalId] or 2
end

--- Setzt die Weiche x auf die Stellung y. Der Wert z sollte den Wert 1 haben
function EEPSetSwitch(switchId, switchPosition, z)
    switches[switchId] = switchPosition
end

--- Liefert die aktuelle Stellung der Weiche x
function EEPGetSwitch(switchId)
    return switches[switchId] and switches[switchId] or 2
end

--- Das Signal x wird intern registriert
function EEPRegisterSignal(signalId)
    assert(signalId)
end

--- Die Weiche x wird intern registriert
function EEPRegisterSwitch(switchId)
    assert(switchId)
end

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

--- Geschwindigkeit aendern
-- @param trainName Name des Zuges
-- @return Geschwindigkeit
function EEPGetTrainSpeed(trainName) return trainSpeeds[trainName] ~= nil, trainSpeeds[trainName] end

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
-- z.B.: EEPRollingstockSetSlot("Ladekran2Greifer", 1)
-- @param rsName Name des Rollmaterials als String
-- @param slot Slot mit der Achsstellung
--------------------------------------------------------------------------
function EEPRollingstockSetSlot(rsName, slot)
end

--------------------------------------------------------------------------
--- Setzen einer Achse am Rollmaterial
-- z.B.: EEPRollingstockSetAxis("Bekohlungskranbruecke 1", "Drehung links", 50)
-- @param rsName Name des Rollmaterials als String
-- @param achse Name der Achse
-- @param stellung 0 - 100 - Achsstellung
--------------------------------------------------------------------------
function EEPRollingstockSetAxis(rsName, achse, stellung)
end

--- Gibt die Stellung der Achse am Rollmaterial zurueck
-- z.B.: EEPRollingstockSetAxis("Bekohlungskranbr?cke 1", "Drehung links", 50)
-- @param rsName Name des Rollmaterials als String
-- @param achse Name der Achse
function EEPRollingstockGetAxis(rsName, achse)
end

--- Laedt Daten aus Slot
-- @param slot Slot 1 bis 1000
-- @return true (wenn gefunden), Boolean|Zahl|"String"| nil
function EEPLoadData(slot) return (eepdata[slot] and true or false), eepdata[slot] end

--- Speichert Daten in Slot
-- @param slot Slot 1 bis 1000
-- @param data Boolean|Zahl|"String"| nil
function EEPSaveData(slot, data) eepdata[slot] = data end

------------------------------
-- Neu ab EEP 11 - Plugin 1 --
------------------------------
--- Rauch einschalten
-- @param immoName Name der Immobilie als String.
-- @param onoff true oder false
function EEPStructureSetSmoke(immoName, onoff)
end

--- Rauch abfreagen
-- @param immoName Name der Immobilie als String.
function EEPStructureGetSmoke(immoName)
end

--- Licht einschalten
-- @param immoName Name der Immobilie als String.
-- @param onoff true oder false
function EEPStructureSetLight(immoName, onoff)
end

--- Licht abfragen
-- @param immoName Name der Immobilie als String.
function EEPStructureGetLight(immoName)
    return true, true
end

--- Feuer einschalten
-- @param immoName Name der Immobilie als String.
-- @param onoff true oder false
function EEPStructureSetFire(immoName, onoff)
end

--- Feuer abfragen
-- @param immoName Name der Immobilie als String.
function EEPStructureGetFire(immoName)
end

--- Setzen einer Achse einer Immobilie.
-- @param immoName Name der Immobilie als String.
-- @param achse Name der Achse
-- @param schritte 1000 bzw. -1000: endlos, 0: Stopp, sonst Schritte
function EEPStructureAnimateAxis(immoName, achse, schritte)
end

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
function EEPStructureSetPosition(immoName, posX, posY, posZ)
end

--- Setzen der Rotation einer Immobilie
-- @param immoName Name der Immobilie als String.
-- @param rotX x-Position
-- @param rotY y-Position
-- @param rotZ z-Position
function EEPStructureSetPosition(immoName, rotX, rotY, rotZ)
end

------------------------------
-- Neu ab EEP 11 - Plugin 2 --
------------------------------
--- Route aendern
-- @param trainName Name des Zuges
-- @param route Name der Route
function EEPSetTrainRoute(trainName, route) AkEEPHilfe.routenDerZuege[trainName] = route end

--- Route abfragen
-- @param trainName Name des Zuges
-- @return ok, routeName (ok und Name der Route)
function EEPGetTrainRoute(trainName)
    return true, AkEEPHilfe.routenDerZuege[trainName] and AkEEPHilfe.routenDerZuege[trainName] or "Alle"
end

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
-- @param kupplungOn true: kuppeln, false: absto�en
function EEPSetTrainCouplingFront(trainName, kupplungOn) end

--- Kupplung hinten setzen
-- @param trainName Name des Zuges
-- @param kupplungOn true: kuppeln, false: absto�en
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
    if AkEEPHilfe.registrierteGleise[trackId] == nil then
        AkEEPHilfe.registrierteGleise[trackId] = false
    end
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
        return (AkEEPHilfe.registrierteGleise[trackId] ~= nil and true or false),
        (AkEEPHilfe.registrierteGleise[trackId] ~= false and true or false),
        (returnTrainName and AkEEPHilfe.registrierteGleise[trackId] or nil)
    else
        return (AkEEPHilfe.registrierteGleise[trackId] ~= nil and true or false),
        (AkEEPHilfe.registrierteGleise[trackId] ~= false and true or false)
    end
end

--- Registriert ein Gleis fuer die Besetztabfrage.
-- @param trackId Id des Gleises
function EEPRegisterRoadTrack(trackId)
    if AkEEPHilfe.registrierteStrassen[trackId] == nil then
        AkEEPHilfe.registrierteStrassen[trackId] = false
    end
    if (trackId <= 11) then return true end
end

--- Fragt ab, ob ein Gleis besetzt ist.
-- @param trackId Id des Gleises
-- @param returnTrainName wenn true, wird als dritter Wert der Zugname
-- @return Erster Wert: true, wenn Gleis existiert und registriert,
-- zweiter Wert: true, wenn besetzt,
-- dritter Wert: Name des Zuges auf dem Gleis
function EEPIsRoadTrackReserved(trackId, returnTrainName)
    if returnTrainName then
        return (AkEEPHilfe.registrierteStrassen[trackId] ~= nil and true or false),
        (AkEEPHilfe.registrierteStrassen[trackId] ~= false and true or false),
        (returnTrainName and AkEEPHilfe.registrierteStrassen[trackId] or nil)
    else
        return (AkEEPHilfe.registrierteStrassen[trackId] ~= nil and true or false),
        (AkEEPHilfe.registrierteStrassen[trackId] ~= false and true or false)
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
function EEPShowInfoSignal(signalId, onOff)
    assert(signalId)
end

--- Setzen des Tipp-Textes einer Immobilie
-- @param switchId Name der Immobilie als String.
-- @param text Text fuer die Anzeige
function EEPChangeInfoSignal(signalId, text)
    assert(signalId)
end

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
    return 2
end

--- Name des Rollis Nummer im Zugverband Name
-- @param zugverband Name des Zugverbandes
-- @param Nummer
--
function EEPGetRollingstockItemName(zugverband, Nummer)
    return zugverband .. '-Wagen-' .. Nummer
end

--- Anzahl der Zuege, welche vom Signal Signal_ID gehalten werden
-- @param signalId ID des Signals
--
function EEPGetSignalTrainsCount(signalId)
    return AkEEPHilfe.zahlDerZuegeAnSignal[signalId] or 0
end

--- Name des Zuges Zahl, der vom Signal Signal_ID gehalten wird
-- @param signalId ID des Signals
-- @param position Position des Zuges am Signal
--
function EEPGetSignalTrainName(signalId, position)
    if AkEEPHilfe.namenDerZuegeAnSignal[signalId] then
        if AkEEPHilfe.namenDerZuegeAnSignal[signalId][position] then
            return AkEEPHilfe.namenDerZuegeAnSignal[signalId][position]
        end
    end
    return "DUMMY"
end

--- Anzahl der Zuege, welche im Depot ZugdepotId gelistet sind
-- @param depotId ID des Zugdepots
--
function EEPGetTrainyardItemsCount(depotId)
end

--- Name des Zuges am DepotPlatz im Depot depotId
-- @param depotId ID des Zugdepots
-- @param position Position (Zahl) des Zugverbandes im Depot
--
function EEPGetTrainyardItemName(depotId, position)
end

--- Status (wartet/auf Anlage) des Zuges Name am Platz im depotId
-- @param depotId ID des Zugdepots
-- @param zugverband Name des Zugverbandes
-- @param position Position (Zahl) des Zugverbandes im Depot
--
function EEPGetTrainyardItemStatus(depotId, zugverband, position)
end


-------------------------------
-- Neu ab EEP 15  --
-------------------------------

--- Argument ist der Name des Fahrzeugs.
-- Rueckgabewert 1 ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
-- Rueckgabewert 2 ist die Länge des Fahrzeugs von Kupplung zu Kupplung in Metern.
function EEPRollingstockGetLength(rollingStockName)
    return true, 5
end

--- Argument ist der Name des Fahrzeugs.
-- Rueckgabewert 1 ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
-- Rueckgabewert 2 ist true, wenn das angegebene Fahrzeug einen Antrieb besitzt, sonst false.
function EEPRollingstockGetMotor(rollingStockName)
    return true, 5
end

--- Argument ist der Name des Fahrzeugs.
-- Rueckgabewert 1 ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
-- Rückgabewert 2 ist die ID des Gleisstücks, auf dem sich das Fahrzeug befindet.
-- Rueckgabewert 3 ist der Abstand (in Metern) zum Anfang des Gleisstücks, auf dem sich das
-- Fahrzeug befindet.
-- Rueckgabewert 4 ist die Ausrichtung relativ zur Fahrtrichtung des Gleisstücks, auf dem sich das
-- Fahrzeug befindet. 1 = in Fahrtrichtung, 0 = entgegen der Fahrtrichtung
-- Rueckgabewert 5 ist die Nummer des Gleissystems, auf dem das Fahrzeug unterwegs ist.
-- 1 = Bahngleise
-- 2 = Straßen
-- 3 = Tramgleise
-- 4 = sonstige Splines/Wasserwege
function EEPRollingstockGetTrack(rollingStockName)
    return true, 5, 5, 1, 1
end

--- • Argument ist der Fahrzeugname.
-- Rueckgabewert 1 ist true, wenn die Ausführung erfolgreich war, sonst false.
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
function EEPRollingstockGetModelType(rollingStockName)
    return true, 1
end


--- Argument ist der Lua-Name der Immobilie oder des LS-Elements.
-- Es genuegt die Nummer mit vorangestelltem #-Zeichen.
-- @return
-- Rueckgabewert 1 ist true, wenn die Ausfuehrung erfolgreich war, ansonsten false.
-- Rueckgabewert 2 ist die X-Position des Objekts.
-- Rueckgabewert 3 ist die Y-Position des Objekts.
-- Rueckgabewert 4 ist die Z-Position des Objekts.
function EEPStructureGetPosition(name)
    local underscoreIndex = string.find(name, '_')
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
    local underscoreIndex = string.find(name, '_')
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