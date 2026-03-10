---@meta

-- -------------------------------------------------------------------------------------------------------------------
---Liefert die Versionsnummer der installierten EEP-Version.
---@type number
EEPVer = 0
-- Verfuegbar ab EEP 10.2 - Plugin 2.
-- Beispielaufrufe:
-- if EEPVer >= 11 then
-- print("Zugbeeinflussung per Lua moeglich!")
-- end

-- -------------------------------------------------------------------------------------------------------------------
---Liefert die aktuelle Zeit in der EEP-Anlage. Der Wert entspricht den seit Mitternacht (EEP-Zeit) vergangenen
---Sekunden. Anmerkung: Die EEP-Zeit hinkt der realen Zeit pro Stunde ca. 100 Sekunden hinterher.
---@type number
EEPTime = 0
-- Verfuegbar ab EEP 10.2 - Plugin 2.
-- Beispielaufrufe:
-- if EEPTime == alteZeit + 50 then
-- print("Es sind genau 50 Sekunden vergangen")
-- alteZeit = EEPTime
-- elseif EEPTime > alte Zeit + 50 then
-- print("Es sind mehr als 50 Sekunden vergangen")
-- alteZeit = EEPTime
-- else
-- print("Es sind noch keine 50 Sek. vergangen")
-- end

-- -------------------------------------------------------------------------------------------------------------------
---Liefert den Stunden-Teil der EEP-Zeit, ausgedrueckt als Wert zwischen 0 und 23.
---@type number
EEPTimeH = 0
-- Verfuegbar ab EEP 10.2 - Plugin 2.
-- Beispielaufrufe:
-- print("Die Uhr hat "..EEPTimeH.." geschlagen!")

-- -------------------------------------------------------------------------------------------------------------------
---Liefert den Minuten-Teil der EEP-Zeit, ausgedrueckt als Wert zwischen 0 und 59.
---@type number
EEPTimeM = 0
-- Verfuegbar ab EEP 10.2 - Plugin 2.
-- Beispielaufrufe:
-- if EEPTimeM == 37 then
-- hole ICE325 aus Depot 2
-- EEPGetTrainFromTrainyard(, "#ICE325")
-- end

-- -------------------------------------------------------------------------------------------------------------------
---Liefert den Sekunden-Teil der EEP-Zeit, ausgedrueckt als Wert zwischen 0 und 59.
---@type number
EEPTimeS = 0
-- Verfuegbar ab EEP 10.2 - Plugin 2.
-- Beispielaufrufe:
-- if EEPTimeS == 15 then
-- schalte Ampel 1 auf Gruen
-- EEPSetSignal(1, 1)
-- elseif EEPTimeS == 45 then
-- schalte Ampel 1 auf Rot
-- EEPSetSignal(1 , 2)
-- end

-- -------------------------------------------------------------------------------------------------------------------
---Liefert das Kuerzel fuer die Sprache der installierten EEP-Version: GER = deutsche Version, ENG = englische
---Version, FRA = franzoesische Version.
---@type string
EEPLng = ""
-- Verfuegbar ab EEP 17.
-- Beispielaufrufe:
-- if EEPLng == "GER" then
-- print("Dies ist eine deutsche EEP-Version")
-- elseif EEPLng == "ENG" then
-- print("This is an English version of EEP")
-- elseif EEPLng == "FRA" then
-- print("Il s'agit d'une version francaise de l'EEP")
-- end

-- -------------------------------------------------------------------------------------------------------------------
---Loescht den Inhalt des Ereignisfensters
function clearlog() end
--       ==========
-- Verfuegbar ab EEP 10.2 - Plugin 2.
-- Beispielaufrufe:
-- clearlog()

-- -------------------------------------------------------------------------------------------------------------------
---Gibt das, was in den Klammern steht, im Ereignisfenster als Text aus.
---@param ... any Auszugebende Werte.
function print(...) end
--       ==========
-- Verfuegbar ab EEP 10.2 - Plugin 2.
-- Beispielaufrufe:
-- print("Text1", "Text2", Variable, "TextN")

-- -------------------------------------------------------------------------------------------------------------------
---Wird zyklisch alle 200 Millisekunden, also fuenf Mal je Sekunde, von EEP aufgerufen. Geeignet fuer alle Aktionen,
---die regelmaessig ausgefuehrt werden sollen.
function EEPMain() end
--       =========
-- Verfuegbar ab EEP 10.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPMain()
-- function EEPMain()
-- end

-- -------------------------------------------------------------------------------------------------------------------
---Aktiviert und deaktiviert die Pause in EEP.
---@param status any Parameter.
function EEPPause(status) end
--       ================
-- Verfuegbar ab EEP 14 - Plugin 1.
-- Beispielaufrufe:
-- EEPPause(Status)
-- Status = 1
-- Pause = EEPPause(0)

-- -------------------------------------------------------------------------------------------------------------------
---Aendert die EEPZeit auf die gewuenschte Zeit.
---@param stunde any Parameter.
---@param minute any Parameter.
---@param sekunde any Parameter.
function EEPSetTime(stunde, minute, sekunde) end
--       ===================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
-- EEPSetTime(Stunde, Minute, Sekunde)
-- Stunde = 9
-- Minute = 15
-- ok = EEPSetTime(Stunde, Minute, Sekunde)
-- ok = EEPSetTime(14, 35, 20)

-- -------------------------------------------------------------------------------------------------------------------
---Gibt die aktuelle Bildrate (fps) zurueck.
function EEPGetFramesPerSecond() end
--       =======================
-- Verfuegbar ab EEP 17.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPGetFramesPerSecond()

-- -------------------------------------------------------------------------------------------------------------------
---Gibt den aktuellen Wert des Bildzaehlers seit Anlagenstart ohne die Bilder waehrend des Bearbeitungs- und
---Pausenmodus zurueck.
function EEPGetCurrentFrame() end
--       ====================
-- Verfuegbar ab EEP 17.2 - Plugin 2.

-- -------------------------------------------------------------------------------------------------------------------
---Gibt die Gesamtanzahl der gerenderten Bilder seit Anlagenstart zurueck und zwar inklusive der Bilder waehrend des
---Bearbeitungs- und Pausenmodus.
function EEPGetCurrentRenderFrame() end
--       ==========================
-- Verfuegbar ab EEP 17.2 - Plugin 2.

-- -------------------------------------------------------------------------------------------------------------------
---Gibt den aktuell in EEP eingestellten Zeitrafferfaktor zurueck.
function EEPGetTimeLapse() end
--       =================
-- Verfuegbar ab EEP 17.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPGetTimeLapse()

-- -------------------------------------------------------------------------------------------------------------------
---Diese Funktion dient nur zur voruebergehenden Einstellung der Farbparameter zum Beispiel nach einem Wechsel der
---Kameraaufnahme und nicht zur dauerhaften Aenderung der Programmeinstellungen.
---@param farbton any Parameter.
---@param saettigung any Parameter.
---@param helligkeit any Parameter.
---@param kontrast any Parameter.
function EEPSetColourFilter(farbton, saettigung, helligkeit, kontrast) end
--       =============================================================
-- Verfuegbar ab EEP 17.3 - Plugin 3.
-- Beispielaufrufe:
-- EEPSetColourFilter(Farbton, Saettigung, Helligkeit, Kontrast)

-- -------------------------------------------------------------------------------------------------------------------
---Schaltet ein Signal
---@overload fun(signalId: number, stellung: number): nil
---@param signalId number Parameter.
---@param stellung number Parameter.
---@param rueckruf? any Parameter.
function EEPSetSignal(signalId, stellung, rueckruf) end
--       ==========================================
-- Verfuegbar ab EEP 10.2 - Plugin 2; EEP 14.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPSetSignal(Signal-ID, Stellung [, Rueckruf])
-- stell Signal 0023 auf 1
-- (kann Fahrt oder Halt sein)
-- stell Signal 0045 auf 1 und
-- ruf EEPOnSignal_45() auf
-- Ergebnis = EEPSetSignal(45, 1, 1)

-- -------------------------------------------------------------------------------------------------------------------
---Gibt die Stellung eines Signals bezogen auf die herrschende Zugbeeinflussung zurueck (s. letzte Bemerkung).
---@param signalId number Parameter.
function EEPGetSignal(signalId) end
--       ======================
-- Verfuegbar ab EEP 10.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPGetSignal(Signal-ID)
-- Stellung = EEPGetSignal(1)
-- if Stellung == 0 then
-- elseif Stellung == 1 then
-- print("Signal 1 steht auf Halt")
-- elseif Stellung == 2 then
-- print("Signal 1 steht auf Fahrt")
-- end
-- ACHTUNG: Bei aelteren Signalen kann Stellung
-- 1 Fahrt und 2 Halt sein.

-- -------------------------------------------------------------------------------------------------------------------
---Registriert ein Signal fuer die Rueckruf(Callback)-Funktion EEPOnSignal_x() Diese notwendige Registrierung soll
---verhindern, dass Signale die Callback-Funktion aufrufen, fuer die keine entsprechende Funktion im Skript definiert
---wurde.
---@param signalId number Parameter.
function EEPRegisterSignal(signalId) end
--       ===========================
-- Verfuegbar ab EEP 10.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPRegisterSignal(Signal-ID)
-- Ergebnis = EEPRegisterSignal(1)
-- print("Signal 1 auf "..Stellung.." gestellt")
-- end

-- -------------------------------------------------------------------------------------------------------------------
---Registrierte Signale rufen selbstaendig diese Funktion auf, wenn sich ihre Stellung durch einen Kontakt oder durch
---manuelle Bedienung (direkt oder in einer Verknuepfung) aendert. Im Skript definiert man die zugehoerige Funktion
---und legt so fest, was bei Aenderung der Signalstellung zu tun ist. Wichtig: Wird die Stellung dieses oder eines
---verknuepften Signals durch die Funktion EEPSetSignal() geaendert, so wird EEPOnSignal_x() nur dann aufgerufen, wenn
---der 3. Parameter "Rueckruf" der Funktion EEPSetSignal() auf 1 gesetzt ist.
---@param stellung number Parameter.
function EEPOnSignal_x(stellung) end
--       =======================
-- Verfuegbar ab EEP 10.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPOnSignal_x(Stellung)
-- function EEPOnSignal_13(Stellung)
-- if Stellung > 1 then
-- end
-- EEPRegisterSignal(13) --zwingend erforderlich!

-- -------------------------------------------------------------------------------------------------------------------
---Gibt die Anzahl "Fahrzeugverbaende" zurueck, welche vom spezifizierten Signal beeinflusst werden, d.h. vom
---Passieren des Vorsignals bis zur tatsaechlichen Abfahrt des Fahrzeugverbandes.
---@param signalId number Parameter.
function EEPGetSignalTrainsCount(signalId) end
--       =================================
-- Verfuegbar ab EEP 13.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPGetSignalTrainsCount(Signal-ID)

-- -------------------------------------------------------------------------------------------------------------------
---Gibt den Namen eines "Fahrzeugverband"s zurueck, welcher vom spezifizierten Signal beeinflusst wird, d.h. vom
---Passieren des Vorsignals bis zur tatsaechlichen Abfahrt des Fahrzeugverbandes.
---@param signalId number Parameter.
---@param position number Parameter.
function EEPGetSignalTrainName(signalId, position) end
--       =========================================
-- Verfuegbar ab EEP 13.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPGetSignalTrainName(Signal-ID, Position)

-- -------------------------------------------------------------------------------------------------------------------
---Wird immer dann aufgerufen, wenn ein Fahrzeugverband an einem Signal haelt.
---@param signalId number Parameter.
---@param trainName string Parameter.
function EEPOnTrainStoppedOnSignal(signalId, trainName) end
--       ==============================================
-- Verfuegbar ab EEP 17.3 - Plugin 3.
-- Beispielaufrufe:
-- EEPOnTrainStoppedOnSignal(Signal-ID, "Zugname")
-- function EEPOnTrainStoppedOnSignal(sigID,zugname)
-- end

-- -------------------------------------------------------------------------------------------------------------------
---Aendert den Halteabstand eines Signals
---@param signalId number Parameter.
---@param halteabstand any Parameter.
function EEPSetSignalStopDistance(signalId, halteabstand) end
--       ================================================
-- Verfuegbar ab EEP 17.3 - Plugin 3.
-- Beispielaufrufe:
-- EEPSetSignalStopDistance(Signal-ID, Halteabstand)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt den Halteabstand eines Signals
---@param signalId number Parameter.
function EEPGetSignalStopDistance(signalId) end
--       ==================================
-- Verfuegbar ab EEP 17.3 - Plugin 3.
-- Beispielaufrufe:
-- EEPGetSignalStopDistance(Signal-ID)
-- ok, Halteabstand = EEPGetSignalStopDistance(9)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die Anzahl der im NOS definierten Signal-Funktionen
---@param signalId number Parameter.
function EEPGetSignalFunctions(signalId) end
--       ===============================
-- Verfuegbar ab EEP 17.3 - Plugin 3.
-- Beispielaufrufe:
-- EEPGetSignalFunctions(Signal-ID)

-- -------------------------------------------------------------------------------------------------------------------
---Gibt die vom Konstrukteur im NOS eingetragene Funktion fuer die angegebene Position in der Auswahlbox in den
---Objekteigenschaften des definierten Signals zurueck
---@param signalId number Parameter.
---@param position number Parameter.
function EEPGetSignalFunction(signalId, position) end
--       ========================================
-- Verfuegbar ab EEP 17.3 - Plugin 3.
-- Beispielaufrufe:
-- EEPGetSignalFunction(Signal-ID, Position)

-- -------------------------------------------------------------------------------------------------------------------
---Gibt den Modellnamen des Signals aus der ini-Datei oder den Namen der 3dm-Datei inklusive deren Pfad zurueck.
---@overload fun(signalId: number): nil
---@param signalId number Parameter.
---@param state? boolean Parameter.
function EEPGetSignalItemName(signalId, state) end
--       =====================================
-- Verfuegbar ab EEP 17.3 - Plugin 3.
-- Beispielaufrufe:
-- EEPGetSignalItemName(Signal-ID, [false | true])
-- ok, Name = EEPGetSignalItemName(3)
-- Name => "Ks_Sig_A_Schirm (GK3)"
-- ok, Name = EEPGetSignalItemName(3, true)
-- Name => "Signale\Signale\KsSigASch_GK3.3dm"

-- -------------------------------------------------------------------------------------------------------------------
---Ueberprueft, ob die Strecke einer Fahrstrasse vom Startsignal bis zum Ziel frei oder besetzt ist
---@param fahrstrassenstartsignalID number Parameter.
---@param fahrstrassenZielnummer any Parameter.
function EEPCheckSetRoute(fahrstrassenstartsignalID, fahrstrassenZielnummer) end
--       ===================================================================
-- Verfuegbar ab EEP 18.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPCheckSetRoute(FahrstrassenstartsignalID, Fahrstrassen-Zielnummer)
-- ok = EEPCheckSetRoute(33, 2)
-- EEPSetSignal(33, 3, 1)
-- end

-- -------------------------------------------------------------------------------------------------------------------
---Schaltet eine Weiche
---@overload fun(weichenID: number, stellung: number): nil
---@param weichenID number Parameter.
---@param stellung number Parameter.
---@param rueckruf? any Parameter.
function EEPSetSwitch(weichenID, stellung, rueckruf) end
--       ===========================================
-- Verfuegbar ab EEP 10.2 - Plugin 2; EEP 14.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPSetSwitch(Weichen-ID, Stellung [, Rueckruf])
-- stell Weiche 0067 auf 1 (Fahrt)
-- stell Weiche 0089 auf 2 (Abzweig) und ruf
-- EEPOnSwitch_89() auf
-- Ergebnis = EEPSetSwitch(89, 2, 1)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die Stellung einer Weiche
---@param weichenID number Parameter.
function EEPGetSwitch(weichenID) end
--       =======================
-- Verfuegbar ab EEP 10.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPGetSwitch(Weichen-ID)
-- Weichenstellung = EEPGetSwitch(1)
-- print("Weiche 1 existiert nicht")
-- elseif Weichenstellung == 1 then
-- print("Weiche 1 steht auf Fahrt")
-- elseif Weichenstellung == 2 then
-- print("Weiche 1 steht auf Abzweig")
-- end

-- -------------------------------------------------------------------------------------------------------------------
---Registriert eine Weiche fuer die Rueckruf(Callback)-Funktion EEPOnSwitch_x() Diese notwendige Registrierung soll
---verhindern, dass Weichen die Callback-Funktion aufrufen, fuer die keine entsprechende Funktion im Skript definiert
---wurde.
---@param weichenID number Parameter.
function EEPRegisterSwitch(weichenID) end
--       ============================
-- Verfuegbar ab EEP 10.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPRegisterSwitch(Weichen-ID)
-- Ergebnis = EEPRegisterSwitch(3)
-- print("Weiche 3 auf "..Stellung.." gestellt")
-- end

-- -------------------------------------------------------------------------------------------------------------------
---Registrierte Weichen rufen selbstaendig diese Funktion auf, wenn sich ihre Stellung durch einen Kontakt oder durch
---manuelle Bedienung (direkt oder in einer Verknuepfung) aendert. Im Skript definiert man die zugehoerige Funktion
---und legt so fest, was bei Aenderung der Weichenstellung zu tun ist. Wichtig: Wird die Stellung dieser oder einer
---verknuepften Weiche durch die Funktion EEPSetSwitch() geaendert, so wird EEPOnSwitch_x() nur dann aufgerufen, wenn
---der 3. Parameter "Rueckruf" der Funktion EEPSetSwitch() auf 1 gesetzt ist.
---@param stellung number Parameter.
function EEPOnSwitch_x(stellung) end
--       =======================
-- Verfuegbar ab EEP 10.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPOnSwitch_x(Stellung)
-- function EEPOnSwitch_34(Stellung)
-- end
-- EEPRegisterSwitch(34) -- zwingend erforderlich!

-- -------------------------------------------------------------------------------------------------------------------
---Speichert etwas in einem speziellen Speicherbereich ("Slot") ab. Wird automatisch zusammen mit der Anlage
---gespeichert und geladen
---@param speichernummer any Parameter.
---@param booleanZahlZeichenkettenil any Parameter.
function EEPSaveData(speichernummer, booleanZahlZeichenkettenil) end
--       =======================================================
-- Verfuegbar ab EEP 11.
-- Beispielaufrufe:
-- EEPSaveData(Speichernummer, Boolean|Zahl|"Zeichenkette"|nil)
-- speicher "wahr" in Speicher 1
-- ok = EEPSaveData(1 , true)
-- ok = EEPSaveData(2 , 42)
-- speicher die Zeichenkette "Ich bin Speicher 3" in
-- ok = EEPSaveData(3 , "Ich bin Speicher 3")
-- loesche den Inhalt von Speicher 4
-- ok = EEPSaveData(4 , nil)

-- -------------------------------------------------------------------------------------------------------------------
---Laedt etwas aus einem speziellen Speicherbereich ("Slot"). Wird automatisch zusammen mit der Anlage gespeichert und
---geladen.
---@param speichernummer any Parameter.
function EEPLoadData(speichernummer) end
--       ===========================
-- Verfuegbar ab EEP 11.
-- Beispielaufrufe:
-- EEPLoadData(Speichernummer)
-- ok, Inhalt = EEPLoadData(1)
-- print("Speicher 1 enthaelt: "..Inhalt)
-- else
-- print("Speicher 1 ist leer")
-- end

-- -------------------------------------------------------------------------------------------------------------------
---Weist einem "Fahrzeugverband" (z.B. einem Zug) eine Geschwindigkeit zu.
---@overload fun(name: string, geschwindigkeit: any): nil
---@param name string Parameter.
---@param geschwindigkeit any Parameter.
---@param state? boolean Parameter.
function EEPSetTrainSpeed(name, geschwindigkeit, state) end
--       ==============================================
-- Verfuegbar ab EEP 11; EEP 17.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPSetTrainSpeed("#Name", Geschwindigkeit [, false|true])
-- ok = EEPSetTrainSpeed("#Rheingold", 80)
-- ok = EEPSetTrainSpeed("#Rheingold", 80, false)
-- ok = EEPSetTrainSpeed("#Rheingold", 80, true)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die Geschwindigkeit eines Fahrzeugverbandes (z.B. eines Zuges).
---@overload fun(name: string): nil
---@param name string Parameter.
---@param state? boolean Parameter.
function EEPGetTrainSpeed(name, state) end
--       =============================
-- Verfuegbar ab EEP 11; EEP 17.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPGetTrainSpeed("#Name"[, false|true])
-- ok, IstGeschwindigkeit = EEPGetTrainSpeed("#VT98;001")
-- EEPGetTrainSpeed("#VT98;001", false)
-- ok, ReiseGeschwindigkeit = EEPGetTrainSpeed("#VT98;001", true)

-- -------------------------------------------------------------------------------------------------------------------
---Weist einem "Fahrzeugverband" (z.B. einem Zug) eine in EEP definierte Route zu.
---@param name string Parameter.
---@param route any Parameter.
function EEPSetTrainRoute(name, route) end
--       =============================
-- Verfuegbar ab EEP 11.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPSetTrainRoute("#Name", "Route")

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die Route eines Fahrzeugverbandes (z.B. eines Zuges).
---@param name string Parameter.
function EEPGetTrainRoute(name) end
--       ======================
-- Verfuegbar ab EEP 11.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPGetTrainRoute("#Name")

-- -------------------------------------------------------------------------------------------------------------------
---Schaltet an einem "Fahrzeugverband" (z.B. einem Zug) die Lichter sowie Blinker ein oder aus. Bitte beachten: Die
---Unterscheidung zwischen Licht und Blinker ist mit EEP 15 hinzugekommen. Ab EEP 16.3 Plugin 3 kann das automatische
---Aufleuchten der Bremsleuchten von Fahrzeugen bei einer Bremsung ein- oder ausgeschaltet werden. Die alte
---Schreibweise mit nur zwei Parametern ist weiterhin gueltig.
---@overload fun(name: string, state: boolean): nil
---@param name string Parameter.
---@param state boolean Parameter.
---@param quelle? any Parameter.
function EEPSetTrainLight(name, state, quelle) end
--       =====================================
-- Verfuegbar ab EEP 11.2 - Plugin 2; EEP 15; EEP 16.3 - Plugin 3.
-- Beispielaufrufe:
-- EEPSetTrainLight("#Name", true|false [, Quelle])
-- Licht ein
-- ok = EEPSetTrainLight("#Rheingold",true)
-- rechter Blinker aus
-- ok = EEPSetTrainLight("#Ford_Transit",false,2)
-- linker Blinker ein
-- ok = EEPSetTrainLight("#Ford_Transit",true,1)
-- Bremslicht aktiviert
-- ok = EEPSetTrainLight("#Ford_Transit",true,3)
-- Bremslicht deaktiviert
-- ok = EEPSetTrainLight("#Ford_Transit",false,3)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt, ob bei einem "Fahrzeugverband" (z.B. einem Zug) die Lichter oder Blinker ein oder aus sind.
---@overload fun(name: string): nil
---@param name string Parameter.
---@param quelle? any Parameter.
function EEPGetTrainLight(name, quelle) end
--       ==============================
-- Verfuegbar ab EEP 18.0.
-- Beispielaufrufe:
-- EEPGetTrainLight("#Name", [, Quelle])
-- ok, brennt = EEPGetTrainLight("#Rheingold")
-- ok, brennt = EEPGetTrainLight("#Ford_Transit",2)

-- -------------------------------------------------------------------------------------------------------------------
---Schaltet an einem "Fahrzeugverband" (z.B. einem Zug) den Rauch an oder aus.
---@param name string Parameter.
---@param state boolean Parameter.
function EEPSetTrainSmoke(name, state) end
--       =============================
-- Verfuegbar ab EEP 11.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPSetTrainSmoke("#Name", true|false)

-- -------------------------------------------------------------------------------------------------------------------
---Laesst bei einem "Fahrzeugverband" (z.B. einem Zug) den Warnton (Pfeife, Hupe) ertoenen.
---@overload fun(name: string): nil
---@param name string Parameter.
---@param state? boolean Parameter.
function EEPSetTrainHorn(name, state) end
--       ============================
-- Verfuegbar ab EEP 11.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPSetTrainHorn("#Name" [,true|false])
-- ok = EEPSetTrainHorn("#Personenzug", true)
-- ok = EEPSetTrainHorn("#Personenzug", false)

-- -------------------------------------------------------------------------------------------------------------------
---Schaltet bei einem "Fahrzeugverband" (z.B. einem Zug) die vordere Kupplung auf Kuppeln oder Abstossen.
---@param name string Parameter.
---@param state boolean Parameter.
function EEPSetTrainCouplingFront(name, state) end
--       =====================================
-- Verfuegbar ab EEP 11.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPSetTrainCouplingFront("#Name", true|false)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt bei einem "Fahrzeugverband" (z.B. einem Zug), ob die vordere Kupplung auf Kuppeln oder Abstossen gestellt
---ist.
---@param name string Parameter.
function EEPGetTrainCouplingFront(name) end
--       ==============================
-- Verfuegbar ab EEP 18.0.
-- Beispielaufrufe:
-- EEPGetTrainCouplingFront("#Name")

-- -------------------------------------------------------------------------------------------------------------------
---Schaltet bei einem "Fahrzeugverband" (z.B. einem Zug) die hintere Kupplung auf Kuppeln oder Abstossen.
---@param name string Parameter.
---@param state boolean Parameter.
function EEPSetTrainCouplingRear(name, state) end
--       ====================================
-- Verfuegbar ab EEP 11.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPSetTrainCouplingRear("#Name", true|false)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt bei einem "Fahrzeugverband" (z.B. einem Zug), ob die hintere Kupplung auf Kuppeln oder Abstossen
---geschaltet ist.
---@param name string Parameter.
function EEPGetTrainCouplingRear(name) end
--       =============================
-- Verfuegbar ab EEP 18.0.
-- Beispielaufrufe:
-- EEPGetTrainCouplingRear("#Name")

-- -------------------------------------------------------------------------------------------------------------------
---Trennt einen "Fahrzeugverband" (z.B. einen Zug) an der angegebenen Stelle.
---@overload fun(name: string, state: boolean, count: number): nil
---@param name string Parameter.
---@param state boolean Parameter.
---@param count number Parameter.
---@param name2? any Parameter.
function EEPTrainLooseCoupling(name, state, count, name2) end
--       ================================================
-- Verfuegbar ab EEP 11.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPTrainLooseCoupling("#Name", true|false, Anzahl, "#Name2")
-- ok = EEPTrainLooseCoupling("#Gueterzug",true,3)
-- EEPTrainLooseCoupling("#Gueterzug",false,2, "#Waggons")

-- -------------------------------------------------------------------------------------------------------------------
---Wird immer dann aufgerufen, wenn zwei "Fahrzeugverbaende" gekoppelt werden.
---@param zug_A any Parameter.
---@param zug_B any Parameter.
---@param zug_neu any Parameter.
function EEPOnTrainCoupling(zug_A, zug_B, zug_neu) end
--       =========================================
-- Verfuegbar ab EEP 14.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPOnTrainCoupling("Zug_A", "Zug_B", "Zug_neu")
-- function EEPOnTrainCoupling(Zug_A,Zug_B,Zug_neu) " wurde "..Zug_neu)
-- end

-- -------------------------------------------------------------------------------------------------------------------
---Wird immer dann aufgerufen, wenn ein "Fahrzeugverband" (z.B. ein Zug) geteilt wird.
---@param zug_A any Parameter.
---@param zug_B any Parameter.
---@param zug_alt any Parameter.
function EEPOnTrainLooseCoupling(zug_A, zug_B, zug_alt) end
--       ==============================================
-- Verfuegbar ab EEP 14.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPOnTrainLooseCoupling("Zug_A", "Zug_B", "Zug_alt")
-- function EEPOnTrainLooseCoupling(Zug_A, Zug_B, Zug_alt) " und "..Zug_B)
-- end

-- -------------------------------------------------------------------------------------------------------------------
---Schaltet an einem "Fahrzeugverband" (z.B. einem Zug) den Haken fuer Gueter an oder aus.
---@param name string Parameter.
---@param state boolean Parameter.
function EEPSetTrainHook(name, state) end
--       ============================
-- Verfuegbar ab EEP 11.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPSetTrainHook("#Name", true|false)

-- -------------------------------------------------------------------------------------------------------------------
---Beeinflusst das Verhalten von Guetern an einem Kranhaken eines "Fahrzeugverbands".
---@param name string Parameter.
---@param state boolean Parameter.
function EEPSetTrainHookGlue(name, state) end
--       ================================
-- Verfuegbar ab EEP 11.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPSetTrainHookGlue("#Name", true|false)

-- -------------------------------------------------------------------------------------------------------------------
---Animiert bei einem "Fahrzeugverband" (z.B. einem Zug) eine oder mehrere ausgewaehlte Achsen.
---@overload fun(name: string, axisName: string, position: number): nil
---@param name string Parameter.
---@param axisName string Parameter.
---@param position number Parameter.
---@param state? boolean Parameter.
function EEPSetTrainAxis(name, axisName, position, state) end
--       ================================================
-- Verfuegbar ab EEP 11.2 - Plugin 2; EEP 17.2.
-- Beispielaufrufe:
-- EEPSetTrainAxis("#Name", "Achse", Position [, true|false])
-- ok = EEPSetTrainAxis("#Kranzug", Rueckgabewerte einer "Ausleger heben/senken", 100)
-- ok = EEPSetTrainAxis("#Staubgutzug", "Domdeckel", 100, true)

-- -------------------------------------------------------------------------------------------------------------------
---Weist einem "Fahrzeugverband" (z.B. einem Zug) einen neuen Namen zu.
---@param alterName string Parameter.
---@param neuerName string Parameter.
function EEPSetTrainName(alterName, neuerName) end
--       =====================================
-- Verfuegbar ab EEP 14.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPSetTrainName("#AlterName", "#NeuerName")

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die Gesamtlaenge des angegebenen Fahrzeugverbandes (z.B. eines Zuges).
---@param name string Parameter.
function EEPGetTrainLength(name) end
--       =======================
-- Verfuegbar ab EEP 15.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPGetTrainLength("#Name")

-- -------------------------------------------------------------------------------------------------------------------
---Dreht die Ausrichtung und die Fahrtrichtung eines "Fahrzeugverbands" (z.B. eines Zug).
---@param name string Parameter.
function EEPTrainChangeOrientation(name) end
--       ===============================
-- Verfuegbar ab EEP 18.0.
-- Beispielaufrufe:
-- EEPTrainChangeOrientation("#Name")

-- -------------------------------------------------------------------------------------------------------------------
---Stellt die vordere Kupplung eines Rollmaterials um.
---@param rollingstockName string Parameter.
---@param kupplungszustand any Parameter.
function EEPRollingstockSetCouplingFront(rollingstockName, kupplungszustand) end
--       ===================================================================
-- Verfuegbar ab EEP 11.0.
-- Beispielaufrufe:
-- EEPRollingstockSetCouplingFront("Fahrzeugname", Kupplungszustand)
-- ok = Rueckgabewerte einer EEPRollingstockSetCouplingFront("Castor 1;001",1)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die Stellung der vorderen Kupplung eines Rollmaterials.
---@param rollingstockName string Parameter.
function EEPRollingstockGetCouplingFront(rollingstockName) end
--       =================================================
-- Verfuegbar ab EEP 11.0.
-- Beispielaufrufe:
-- EEPRollingstockGetCouplingFront("Fahrzeugname")
-- EEPRollingstockGetCouplingFront("Castor 1;001")

-- -------------------------------------------------------------------------------------------------------------------
---Stellt die hintere Kupplung eines Rollmaterials um.
---@param rollingstockName string Parameter.
---@param kupplungszustand any Parameter.
function EEPRollingstockSetCouplingRear(rollingstockName, kupplungszustand) end
--       ==================================================================
-- Verfuegbar ab EEP 11.0.
-- Beispielaufrufe:
-- EEPRollingstockSetCouplingRear("Fahrzeugname", Kupplungszustand)
-- ok = Rueckgabewerte einer EEPRollingstockSetCouplingRear("fals 175 Kalk", 1)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die Stellung der hinteren Kupplung eines Rollmaterials.
---@param rollingstockName string Parameter.
function EEPRollingstockGetCouplingRear(rollingstockName) end
--       ================================================
-- Verfuegbar ab EEP 11.0.
-- Beispielaufrufe:
-- EEPRollingstockGetCouplingRear("Fahrzeugname")
-- EEPRollingstockGetCouplingRear("fals 175 Kalk")

-- -------------------------------------------------------------------------------------------------------------------
---Bewegt die mittels Achsname benannte Achse des benannten Rollmaterials in eine gewuenschte Position.
---@overload fun(rollingstockName: string, axisName: string, position: number): nil
---@param rollingstockName string Parameter.
---@param axisName string Parameter.
---@param position number Parameter.
---@param state? boolean Parameter.
function EEPRollingstockSetAxis(rollingstockName, axisName, position, state) end
--       ===================================================================
-- Verfuegbar ab EEP 11.0; EEP 17.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPRollingstockSetAxis("Fahrzeugname", "Achse", Position [, true|false])
-- ok = EEPRollingstockSetAxis("Dispolok 189-917 Rueckgabewerte einer EpVI", "Stromabnehmer DE", 100)
-- ok = EEPRollingstockSetAxis("Dispolok 189-917 EpVI", "Stromabnehmer", 0, true)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die aktuelle Position einer mittels Achsnamen benannten Achse des benannten Rollmaterials.
---@param rollingstockName string Parameter.
---@param axisName string Parameter.
function EEPRollingstockGetAxis(rollingstockName, axisName) end
--       ==================================================
-- Verfuegbar ab EEP 11.0.
-- Beispielaufrufe:
-- EEPRollingstockGetAxis("Fahrzeugname", "Achse")
-- Name = ("Dispolok 189-917 EpVI" Rueckgabewerte zwei Achse = "Stromabnehmer DE"
-- ok, Position = EEPRollingstockGetAxis(Name, Achse)

-- -------------------------------------------------------------------------------------------------------------------
---Bewegt die mittels Achsnummer benannte Achse des benannten Rollmaterials in eine gewuenschte Position.
---@param rollingstockName string Parameter.
---@param achsnummer any Parameter.
---@param position number Parameter.
function EEPRollingstockSetAxisByNumber(rollingstockName, achsnummer, position) end
--       ======================================================================
-- Verfuegbar ab EEP 18.0.
-- Beispielaufrufe:
-- EEPRollingstockSetAxisByNumber("Fahrzeugname", Achsnummer, Position)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die aktuelle Position einer mittels Achsnummer benannten Achse des benannten Rollmaterials.
---@param rollingstockName string Parameter.
---@param achsnummer any Parameter.
function EEPRollingstockGetAxisByNumber(rollingstockName, achsnummer) end
--       ============================================================
-- Verfuegbar ab EEP 18.0.
-- Beispielaufrufe:
-- EEPRollingstockGetAxisByNumber("Fahrzeugname", Achsnummer)
-- Name = "Dispolok 189-917 EpVI"
-- EEPRollingstockGetAxisByNumber(Name, 26)

-- -------------------------------------------------------------------------------------------------------------------
---Bewegt alle Achsen des genannten Rollmaterials zu den in der definierten Einstellungsgruppe fuer Achseinstellungen
---gespeicherten Positionen
---@param rollingstockName string Parameter.
---@param achsengruppe any Parameter.
function EEPRollingstockSetSlot(rollingstockName, achsengruppe) end
--       ======================================================
-- Verfuegbar ab EEP 11.0.
-- Beispielaufrufe:
-- EEPRollingstockSetSlot("Fahrzeugname", Achsengruppe)

-- -------------------------------------------------------------------------------------------------------------------
---Gibt die Anzahl der Fahrzeuge in einem "Fahrzeugverband" (z.B. einem Zug) zurueck
---@param name string Parameter.
function EEPGetRollingstockItemsCount(name) end
--       ==================================
-- Verfuegbar ab EEP 13.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPGetRollingstockItemsCount("#Name")
-- EEPGetRollingstockItemsCount("#Gueterzug")

-- -------------------------------------------------------------------------------------------------------------------
---Gibt den Namen eines Fahrzeugs im "Fahrzeugverband" (z.B. einem Zug) zurueck
---@param name string Parameter.
---@param nummer any Parameter.
function EEPGetRollingstockItemName(name, nummer) end
--       ========================================
-- Verfuegbar ab EEP 13.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPGetRollingstockItemName("#Name", Nummer)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt den Namen des "Fahrzeugverbands", in dem das angegebene Fahrzeug mitgefuehrt wird.
---@param rollingstockName string Parameter.
function EEPRollingstockGetTrainName(rollingstockName) end
--       =============================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
-- EEPRollingstockGetTrainName("Fahrzeugname")
-- ok, Name = Rueckgabewerte zwei EEPRollingstockGetTrainName("Castor 1")

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die Laenge des angegebenen Fahrzeugs.
---@param fahrzeugame any Parameter.
function EEPRollingstockGetLength(fahrzeugame) end
--       =====================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
-- EEPRollingstockGetLength("Fahrzeugame")
-- EEPRollingstockGetLength("Container 0100")

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die Anzahl der Getriebegaenge des angegebenen Fahrzeugs und damit indirekt ob das Fahrzeug motorisiert
---ist.
---@param rollingstockName string Parameter.
function EEPRollingstockGetMotor(rollingstockName) end
--       =========================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
-- EEPRollingstockGetMotor("Fahrzeugname")

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die aktuelle Position des angegebenen Fahrzeugs auf der Anlage.
---@param rollingstockName string Parameter.
function EEPRollingstockGetTrack(rollingstockName) end
--       =========================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
-- EEPRollingstockGetTrack("Fahrzeugname")
-- EEPRollingstockGetTrack("BR 212 376-8")

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die Kategorie, zu welcher das genannte Fahrzeug gehoert.
---@param rollingstockName string Parameter.
function EEPRollingstockGetModelType(rollingstockName) end
--       =============================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
-- EEPRollingstockGetModelType("Fahrzeugname")
-- EEPRollingstockGetModelType("Castor 1")

-- -------------------------------------------------------------------------------------------------------------------
---Dreht die Ausrichtung des angegebenen Fahrzeugs in einem "Fahrzeugverband" (z.B. einem Zug).
---@param rollingstockName string Parameter.
function EEPRollingstockChangeOrientation(rollingstockName) end
--       ==================================================
-- Verfuegbar ab EEP 18.0.
-- Beispielaufrufe:
-- EEPRollingstockChangeOrientation("Fahrzeug- name")
-- EEPRollingstockChangeOrientation("DB Gbrs")

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt, welche relative Ausrichtung das angegebene Fahrzeug im "Fahrzeugverband" hat.
---@param rollingstockName string Parameter.
function EEPRollingstockGetOrientation(rollingstockName) end
--       ===============================================
-- Verfuegbar ab EEP 15.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPRollingstockGetOrientation("Fahrzeugname")
-- EEPRollingstockGetOrientation("DB Gbrs")

-- -------------------------------------------------------------------------------------------------------------------
---Schaltet bei einem bestimmten Rollmaterial den Haken an oder aus.
---@param rollingstockName string Parameter.
---@param state boolean Parameter.
function EEPRollingstockSetHook(rollingstockName, state) end
--       ===============================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPRollingstockSetHook("Fahrzeugname", true|false)
-- EEPRollingstockSetHook("Schienenkran DB EDK 300/5", true)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt, ob der Haken eines bestimmten Rollmaterials an oder ausgeschaltet ist.
---@param rollingstockName string Parameter.
function EEPRollingstockGetHook(rollingstockName) end
--       ========================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPRollingstockGetHook("Fahrzeugname")
-- EEPRollingstockGetHook("Schienenkran DB EDK 300/5")

-- -------------------------------------------------------------------------------------------------------------------
---Beeinflusst das Verhalten von Guetern an einem Kranhaken eines Rollmaterials.
---@param rollingstockName string Parameter.
---@param state boolean Parameter.
function EEPRollingstockSetHookGlue(rollingstockName, state) end
--       ===================================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPRollingstockSetHookGlue("Fahrzeugname", true|false)
-- EDK 300/5", true)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt das Verhalten von Guetern am Kranhaken eines Rollmaterials
---@param rollingstockName string Parameter.
function EEPRollingstockGetHookGlue(rollingstockName) end
--       ============================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPRollingstockGetHookGlue("Fahrzeugname")
-- EDK 300/5")

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die Position des Kranhakens des Rollmaterials im EEP-Koordinatensystem.
---@param rollingstockName string Parameter.
function EEPRollingstockGetHookPosition(rollingstockName) end
--       ================================================
-- Verfuegbar ab EEP 18.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPRollingstockGetHookPosition("Fahrzeugname" [, Kranhakennummer])
-- ok, PosX, PosY, PosZ = Rueckgabewerte vier EEPRollingstockGetHookPosition("Brueckenkran - Haken")
-- ok, PosX, PosY, PosZ = EEPRollingstockGetHookPosition("Brueckenkran - 3 Haken", 2)

-- -------------------------------------------------------------------------------------------------------------------
---Schaltet den Rauch des bennanten Rollmaterials an oder aus.
---@param rollingstockName string Parameter.
---@param state boolean Parameter.
function EEPRollingstockSetSmoke(rollingstockName, state) end
--       ================================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPRollingstockSetSmoke("Fahrzeugname", true|false)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt, ob der Rauch des benannten Rollmaterials, an- oder ausgeschaltet ist.
---@param rollingstockName string Parameter.
function EEPRollingstockGetSmoke(rollingstockName) end
--       =========================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPRollingstockGetSmoke("Fahrzeugname")
-- EEPRollingstockGetSmoke("DR_96020")

-- -------------------------------------------------------------------------------------------------------------------
---Laesst bei einem bestimmten Rollmaterial den Warnton (Pfeife, Hupe) ertoenen.
---@param rollingstockName string Parameter.
function EEPRollingstockSetHorn(rollingstockName) end
--       ========================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPRollingstockSetHorn("Fahrzeugname" [, true|false])
-- ok = EEPRollingstockSetHorn("DR_96020", true)
-- ok = EEPRollingstockSetHorn("DR_96020", false)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die zurueckgelegte Strecke des Rollmaterials
---@param rollingstockName string Parameter.
function EEPRollingstockGetMileage(rollingstockName) end
--       ===========================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPRollingstockGetMileage("Fahrzeugname")
-- 8")

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die Position des Rollmaterials im EEP-Koordinatensystem.
---@param rollingstockName string Parameter.
function EEPRollingstockGetPosition(rollingstockName) end
--       ============================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPRollingstockGetPosition("Fahrzeugname")
-- EEPRollingstockGetPosition("BR 212 376-8")

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die Ausrichtung des Rollmaterials im EEP-Koordinatensystem.
---@param rollingstockName string Parameter.
function EEPRollingstockGetRotation(rollingstockName) end
--       ============================================
-- Verfuegbar ab EEP 18.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPRollingstockGetRotation("Fahrzeugname")
-- EEPRollingstockGetRotation("DB_Sdgkms_3180409-355")

-- -------------------------------------------------------------------------------------------------------------------
---Schaltet den Rauch der benannten Immobilie an oder aus.
---@param luaName string Parameter.
---@param state boolean Parameter.
function EEPStructureSetSmoke(luaName, state) end
--       ====================================
-- Verfuegbar ab EEP 11.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPStructureSetSmoke("#Lua-Name", true|false)
-- Name = "#1_Abfertigung Lauscha"
-- ok = EEPStructureSetSmoke("#1", true)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt, ob der Rauch der benannten Immobilie an- oder ausgeschaltet ist.
---@param luaName string Parameter.
function EEPStructureGetSmoke(luaName) end
--       =============================
-- Verfuegbar ab EEP 11.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPStructureGetSmoke("#Lua-Name")
-- Name = "#1_Abfertigung Lauscha"
-- ok, Rauch = EEPStructureGetSmoke("#1")

-- -------------------------------------------------------------------------------------------------------------------
---Schaltet das Licht der benannten Immobilie an oder aus.
---@param luaName string Parameter.
---@param state boolean Parameter.
function EEPStructureSetLight(luaName, state) end
--       ====================================
-- Verfuegbar ab EEP 11.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPStructureSetLight("#Lua-Name", true|false)
-- Name = "#13_Betriebsdienstgebaeude"
-- ok = EEPStructureSetLight("#13", true)

-- -------------------------------------------------------------------------------------------------------------------
---Plugin 1 Ermittelt, ob das Licht der benannten Immobilie an- oder ausgeschaltet ist.
---@param luaName string Parameter.
function EEPStructureGetLight(luaName) end
--       =============================
-- Verfuegbar ab EEP 11.1.
-- Beispielaufrufe:
-- EEPStructureGetLight("#Lua-Name")
-- Name = "#13_Betriebsdienstgebaeude"
-- ok, Licht = EEPStructureGetLight("#13")

-- -------------------------------------------------------------------------------------------------------------------
---Schaltet das Feuer der benannten Immobilie an oder aus.
---@param luaName string Parameter.
---@param state boolean Parameter.
function EEPStructureSetFire(luaName, state) end
--       ===================================
-- Verfuegbar ab EEP 11.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPStructureSetFire("#Lua-Name", true|false)
-- Name = "#15_Brandhaus_01_SB1"
-- ok = EEPStructureSetFire("#15 ", true)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt, ob das Feuer der benannten Immobilie an- oder ausgeschaltet ist.
---@param luaName string Parameter.
function EEPStructureGetFire(luaName) end
--       ============================
-- Verfuegbar ab EEP 11.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPStructureGetFire("#Lua-Name")
-- Name = "#15_Brandhaus_01_SB1"
-- ok, Feuer = EEPStructureGetFire("#15")

-- -------------------------------------------------------------------------------------------------------------------
---Setzt die mittels Achsnamen definierte Achse einer Immobilie oder eines Gleisobjekts auf eine bestimmte Stellung
---(ohne Animation). - Der 1. Parameter ist der Lua-Name der Immobilie oder des Gleisobjektes als String. Er steht in
---den Objekteigenschaften und unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die Nummer
---mit vorangestelltem #-Zeichen als Identifikator.
---@param luaName string Parameter.
---@param axisName string Parameter.
---@param stellung number Parameter.
function EEPStructureSetAxis(luaName, axisName, stellung) end
--       ================================================
-- Verfuegbar ab EEP 11.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPStructureSetAxis("#Lua-Name", "Achse", Stellung)
-- Name = "#83_Drehscheibe"
-- ok = EEPStructureSetAxis("#83", "Bruecke", 50)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die Stellung einer mittels Achsnamen definierten Achse der benannten Immobilie oder des Gleisobjekts
---@param luaName string Parameter.
---@param axisName string Parameter.
function EEPStructureGetAxis(luaName, axisName) end
--       ======================================
-- Verfuegbar ab EEP 11.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPStructureGetAxis("#Lua-Name", "Achse")
-- Name = "#83_Drehscheibe"
-- ok, Stellung = EEPStructureGetAxis("#83", "Bruecke")

-- -------------------------------------------------------------------------------------------------------------------
---Setzt die mittels Achsnummer definierte Achse einer Immobilie oder eines Gleisobjekts auf eine bestimmte Stellung
---(ohne Animation). - Der 1. Parameter ist der Lua-Name der Immobilie oder des Gleisobjektes als String. Er steht in
---den Objekteigenschaften und unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die Nummer
---mit vorangestelltem #-Zeichen als Identifikator. - Der 2. Parameter ist die Achsnummer der zu bewegenden Achse als
---Zahl. Sie ist
---@param luaName string Parameter.
---@param achsnummer any Parameter.
---@param stellung number Parameter.
function EEPStructureSetAxisByNumber(luaName, achsnummer, stellung) end
--       ==========================================================
-- Verfuegbar ab EEP 18.0.
-- Beispielaufrufe:
-- EEPStructureSetAxisByNumber("#Lua-Name", Achsnummer, Stellung)
-- Name = "#83_Drehscheibe"
-- ok = EEPStructureSetAxisByNumber("#83", 1, 50)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die Stellung einer mittels Achsnummer definierten Achse der benannten Immobilie oder des Gleisobjekts
---@param luaName string Parameter.
---@param achsnummer any Parameter.
function EEPStructureGetAxisByNumber(luaName, achsnummer) end
--       ================================================
-- Verfuegbar ab EEP 18.0.
-- Beispielaufrufe:
-- EEPStructureGetAxisByNumber("#Lua-Name", Achsnummer)
-- Name = "#83_Drehscheibe"
-- ok, Stellung = EEPStructureGetAxisByNumber
-- ok, Stellung = EEPStructureGetAxisByNumber("#83", 1)

-- -------------------------------------------------------------------------------------------------------------------
---Bewegt die Achse einer Immobilie oder eines Gleisobjekts.
---@overload fun(luaName: string): nil
---@param luaName string Parameter.
---@param axisName? string Parameter.
---@param stellung? number Parameter.
function EEPStructureAnimateAxis(luaName, axisName, stellung) end
--       ====================================================
-- Verfuegbar ab EEP 11.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPStructureAnimateAxis("#Lua-Name", "Achse", Stellung)
-- ok = EEPStructureAnimateAxis("#17_Windmuehle", Rueckgabewerte "Muehlrad", 1000)
-- ok = EEPStructureAnimateAxis("#17", "Muehlrad", 1000)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt, ob sich das genannte bewegliche Teil der genannten Immobilie oder des Gleisobjektes aktuell in Bewegung
---befindet und ob diese Bewegung endlos ist.
---@param luaName string Parameter.
---@param axisName string Parameter.
function EEPStructureIsAxisAnimate(luaName, axisName) end
--       ============================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
-- EEPStructureIsAxisAnimate("#Lua-Name", "Achse")
-- ok, Status = EEPStructureIsAxisAnimate("#17","Muehlrad")
-- if Status > 0 then
-- print("Die Windmuehle ist in Bewegung")
-- end

-- -------------------------------------------------------------------------------------------------------------------
---Versetzt die benannte Immobilie oder das Landschaftselement an eine neue Position.
---@param luaName string Parameter.
---@param posX number Parameter.
---@param posY number Parameter.
---@param posZ number Parameter.
function EEPStructureSetPosition(luaName, posX, posY, posZ) end
--       ==================================================
-- Verfuegbar ab EEP 11.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPStructureSetPosition("#Lua-Name", PosX, PosY, PosZ)
-- Name = "#55_Strohballen"
-- ok = EEPStructureSetPosition("#55", 11, 17, 3)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die aktuelle Position einer Immobilie oder eines Landschaftselements.
---@param luaName string Parameter.
function EEPStructureGetPosition(luaName) end
--       ================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
-- EEPStructureGetPosition("#Lua-Name")
-- ok, Pos_X, Pos_Y, Pos_Z = Rueckgabewerte EEPStructureGetPosition("#55_Strohballen")
-- ok, Pos_X, Pos_Y, Pos_Z = EEPStructureGetPosition("#55")

-- -------------------------------------------------------------------------------------------------------------------
---Dreht die benannte Immobilie oder das Landschaftselement in eine neue Position.
---@param luaName string Parameter.
---@param rotX number Parameter.
---@param rotY number Parameter.
---@param rotZ number Parameter.
function EEPStructureSetRotation(luaName, rotX, rotY, rotZ) end
--       ==================================================
-- Verfuegbar ab EEP 11.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPStructureSetRotation("#Lua-Name", RotX, RotY, RotZ)
-- Name = "#55_Strohballen"
-- ok = EEPStructureSetRotation("#55", 0, 0, 25)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die aktuelle Ausrichtung einer Immobilie oder eines Landschaftselements.
---@param luaName string Parameter.
function EEPStructureGetRotation(luaName) end
--       ================================
-- Verfuegbar ab EEP 11.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPStructureGetRotation("#Lua-Name")
-- ok, Rot_X, Rot_Y, Rot_Z = Rueckgabewerte EEPStructureGetRotation("#55_Strohballen")
-- ok, Rot_X, Rot_Y, Rot_Z = EEPStructureGetRotation("#55")

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die Kategorie, zu welcher die genannte Immobilie oder das genannte Landschaftselement gehoert.
---@param luaName string Parameter.
function EEPStructureGetModelType(luaName) end
--       =================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
-- EEPStructureGetModelType("#Lua-Name")

-- -------------------------------------------------------------------------------------------------------------------
---Setzt alternative Beleuchtungsfarbe fuer benannte Immobilie.
function EEPStructureSetLightningColour() end
--       ================================
-- Verfuegbar ab EEP 18.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPStructureSetLightingColour() EEPStructureSetLightingColour("#Lua-Name", R, G, B)
-- Name = "#13_Hermannsdenkmal"
-- ok = EEPStructureSetLightingColour(Name, 128, Rueckgabewerte einer 255, 128)
-- ok = EEPStructureSetLightingColour("#13", 128, 255, 128)

-- -------------------------------------------------------------------------------------------------------------------
---Aendert die Position eines Ladeguts auf der Anlage.
---@param luaName string Parameter.
---@param posX number Parameter.
---@param posY number Parameter.
---@param posZ number Parameter.
function EEPGoodsSetPosition(luaName, posX, posY, posZ) end
--       ==============================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
-- EEPGoodsSetPosition("#Lua-Name", Pos_X, Pos_Y, Pos_Z)
-- ok = EEPGoodsSetPosition("#66_Kartons", 13, 20, 5)
-- ok = EEPGoodsSetPosition("#66", 13, 20, 5)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die aktuelle Position eines Ladeguts auf der Anlage.
---@param luaName string Parameter.
function EEPGoodsGetPosition(luaName) end
--       ============================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
-- EEPGoodsGetPosition("#Lua-Name")
-- ok, Pos_X, Pos_Y, Pos_Z = EEPGoodsGetPosition("#66_Kartons")
-- ok, Pos_X, Pos_Y, Pos_Z = EEPGoodsGetPosition("#66")

-- -------------------------------------------------------------------------------------------------------------------
---Aendert die Ausrichtung eines Ladeguts auf der Anlage.
---@param luaName string Parameter.
---@param rot_X any Parameter.
---@param rot_Y any Parameter.
---@param rot_Z any Parameter.
function EEPGoodsSetRotation(luaName, rot_X, rot_Y, rot_Z) end
--       =================================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
-- EEPGoodsSetRotation("#Lua-Name", Rot_X, Rot_Y, Rot_Z)
-- ok = EEPGoodsSetRotation("#66_Kartons", 0, 0, 30)
-- ok = EEPGoodsSetRotation("#66", 0, 0, 30)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die aktuelle Ausrichtung eines Ladeguts auf der Anlage.
---@param luaName string Parameter.
function EEPGoodsGetRotation(luaName) end
--       ============================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPGoodsGetRotation("#Lua-Name)
-- ok, Rot_X, Rot_Y, Rot_Z = EEPGoodsGetRotation("#66_Kartons")
-- ok, Rot_X, Rot_Y, Rot_Z = EEPGoodsGetRotation("#66 ")

-- -------------------------------------------------------------------------------------------------------------------
---Setzt die mittels Achsnamen definierte Achse eines Ladegutes auf eine bestimmte Stellung (ohne Animation). - Der 1.
---Parameter ist der Lua-Name des Ladegutes als String. Er steht in den Objekteigenschaften und unterscheidet sich
---durch die vorangestellte ID vom Modellnamen. Es genuegt die Nummer mit vorangestelltem #-Zeichen als Identifikator.
---@param luaName string Parameter.
---@param axisName string Parameter.
---@param stellung number Parameter.
function EEPGoodsSetAxis(luaName, axisName, stellung) end
--       ============================================
-- Verfuegbar ab EEP 18.0.
-- Beispielaufrufe:
-- EEPGoodsSetAxis("#Lua-Name", "Achse", Stellung)
-- Name = "#83_IF_ctnr_OT20_C1 (MS7)"
-- ok = EEPGoodsSetAxis("#83", "Ebene der Ladung", 50)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die Stellung einer mittels Achsnamen definierten Achse des benannten Ladegutes.
---@param luaName string Parameter.
---@param axisName string Parameter.
function EEPGoodsGetAxis(luaName, axisName) end
--       ==================================
-- Verfuegbar ab EEP 18.0.
-- Beispielaufrufe:
-- EEPGoodsGetAxis("#Lua-Name", "Achse")
-- Name = "#83_IF_ctnr_OT20_C1 (MS7)"
-- Achse = "Ebene der Ladung"
-- ok, Stellung = EEPGoodsGetAxis("#83", "Ebene der Ladung")

-- -------------------------------------------------------------------------------------------------------------------
---Setzt die mittels Achsnummer definierte Achse eines Ladegutes auf eine bestimmte Stellung (ohne Animation). - Der
---1. Parameter ist der Lua-Name des Ladegutes als String. Er steht in den Objekteigenschaften und unterscheidet sich
---durch die vorangestellte ID vom Modellnamen. Es genuegt die Nummer mit vorangestelltem #-Zeichen als Identifikator.
---- Der 2. Parameter ist die Achsnummer der zu bewegenden Achse als Zahl. Sie ist
---@param luaName string Parameter.
---@param achsnummer any Parameter.
---@param stellung number Parameter.
function EEPGoodsSetAxisByNumber(luaName, achsnummer, stellung) end
--       ======================================================
-- Verfuegbar ab EEP 18.0.
-- Beispielaufrufe:
-- EEPGoodsSetAxisByNumber("#Lua-Name", Achsnummer, Stellung)
-- Name = "#83_IF_ctnr_OT20_C1 (MS7)"
-- ok = EEPGoodsSetAxisByNumber("#83", 1, 50)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die Stellung einer mittels Achsnummer definierten Achse des benannten Ladegutes.
---@param luaName string Parameter.
---@param achsnummer any Parameter.
function EEPGoodsGetAxisByNumber(luaName, achsnummer) end
--       ============================================
-- Verfuegbar ab EEP 18.0.
-- Beispielaufrufe:
-- EEPGoodsGetAxisByNumber("#Lua-Name", Achsnummer)
-- Name = "#83_IF_ctnr_OT20_C1 (MS7)"
-- ok, Stellung = EEPGoodsGetAxisByNumber("#83", 1)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die Kategorie, zu welcher das genannte Ladegut gehoert.
---@param luaName string Parameter.
function EEPGoodsGetModelType(luaName) end
--       =============================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
-- EEPGoodsGetModelType("#Lua-Name")

-- -------------------------------------------------------------------------------------------------------------------
---Registriert ein Gleiselement fuer Besetztabfragen.
---@param gleisID number Parameter.
function EEPRegisterRailTrack(gleisID) end
--       =============================
-- Verfuegbar ab EEP 11.3 - Plugin 3.
-- Beispielaufrufe:
-- EEPRegisterRailTrack(Gleis-ID)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt, ob ein Gleiselement besetzt ist bzw. ob es mit dem x-ten Zugverband besetzt ist und gibt dann dessen
---Namen zurueck.
---@overload fun(gleisID: number): nil
---@param gleisID number Parameter.
---@param trueZahl? any Parameter.
function EEPIsRailTrackReserved(gleisID, trueZahl) end
--       =========================================
-- Verfuegbar ab EEP 11.3 - Plugin 3; EEP 13.2 - Plugin 2; EEP 17.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPIsRailTrackReserved(Gleis-ID [, true|Zahl])
-- ok, besetzt = EEPIsRailTrackReserved(123)
-- EEPIsRailTrackReserved(123, true)
-- ok, besetzt, Zugname = EEPIsRailTrackReserved(123, 2)

-- -------------------------------------------------------------------------------------------------------------------
---Registriert ein Strassenelement fuer Besetztabfragen.
---@param strassenID number Parameter.
function EEPRegisterRoadTrack(strassenID) end
--       ================================
-- Verfuegbar ab EEP 11.3 - Plugin 3.
-- Beispielaufrufe:
-- EEPRegisterRoadTrack(Strassen-ID)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt, ob ein Strassenelement besetzt ist bzw. ob es mit dem x-ten Fahrzeugverband besetzt ist und gibt dann
---dessen Namen zurueck.
---@overload fun(strassenID: number): nil
---@param strassenID number Parameter.
---@param trueZahl? any Parameter.
function EEPIsRoadTrackReserved(strassenID, trueZahl) end
--       ============================================
-- Verfuegbar ab EEP 11.3 - Plugin 3; EEP 13.2 - Plugin 2; EEP 17.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPIsRoadTrackReserved(Strassen-ID [, true|Zahl])
-- ok, besetzt = EEPIsRoadTrackReserved(211)
-- EEPIsRoadTrackReserved(211, true)
-- ok, besetzt, Name_Fahrzeugverband = EEPIsRoadTrackReserved(211, 3)

-- -------------------------------------------------------------------------------------------------------------------
---Registriert ein Strassenbahngleis fuer Besetztabfragen.
---@param strassenbahngleisID number Parameter.
function EEPRegisterTramTrack(strassenbahngleisID) end
--       =========================================
-- Verfuegbar ab EEP 11.3 - Plugin 3.
-- Beispielaufrufe:
-- EEPRegisterTramTrack(Strassenbahngleis-ID)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt, ob ein Strassenbahngleis besetzt ist bzw. ob es mit dem x-ten Zugverband besetzt ist und gibt dann
---dessen Namen zurueck.
---@overload fun(strassenbahngleisID: number): nil
---@param strassenbahngleisID number Parameter.
---@param trueZahl? any Parameter.
function EEPIsTramTrackReserved(strassenbahngleisID, trueZahl) end
--       =====================================================
-- Verfuegbar ab EEP 11.3 - Plugin 3; EEP 13.2 - Plugin 2; EEP 17.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPIsTramTrackReserved(Strassenbahngleis-ID [, true|Zahl])
-- ok, besetzt = EEPIsTramTrackReserved(187)
-- EEPIsTramTrackReserved(187, true)
-- ok, besetzt, Name_Strassenbahnverband = EEPIsTramTrackReserved(187, 2)

-- -------------------------------------------------------------------------------------------------------------------
---Registriert ein Weg-Element der Kategorie "Sonstige" fuer Besetztabfragen.
---@param wegID number Parameter.
function EEPRegisterAuxiliaryTrack(wegID) end
--       ================================
-- Verfuegbar ab EEP 11.3 - Plugin 3.
-- Beispielaufrufe:
-- EEPRegisterAuxiliaryTrack(Weg-ID)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt, ob ein Weg-Element der Kategorie "Sonstige" besetzt ist bzw. ob es mit dem x-ten Fahrzeugverband besetzt
---ist und gibt dann dessen Namen zurueck.
---@overload fun(wegID: number): nil
---@param wegID number Parameter.
---@param trueZahl? any Parameter.
function EEPIsAuxiliaryTrackReserved(wegID, trueZahl) end
--       ============================================
-- Verfuegbar ab EEP 11.3 - Plugin 3; EEP 13.2 - Plugin 2; EEP 17.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPIsAuxiliaryTrackReserved(Weg-ID [, true|Zahl])
-- ok, besetzt = EEPIsAuxiliaryTrackReserved(321)
-- EEPIsAuxiliaryTrackReserved(321,true)
-- ok, besetzt, Name_Fahrzeugverband = EEPIsAuxiliaryTrackReserved(321,3)

-- -------------------------------------------------------------------------------------------------------------------
---Registriert ein Steuerstrecken-Element fuer Besetztabfragen.
---@param steuerstreckenID number Parameter.
function EEPRegisterControlTrack(steuerstreckenID) end
--       =========================================
-- Verfuegbar ab EEP 11.3 - Plugin 3.
-- Beispielaufrufe:
-- EEPRegisterControlTrack(Steuerstrecken-ID)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt, ob ein Steuerstrecken-Element besetzt ist bzw. ob es mit dem x-ten Fahrzeugverband besetzt ist und gibt
---dann dessen Namen zurueck.
---@overload fun(steuerstreckenID: number): nil
---@param steuerstreckenID number Parameter.
---@param trueZahl? any Parameter.
function EEPIsControlTrackReserved(steuerstreckenID, trueZahl) end
--       =====================================================
-- Verfuegbar ab EEP 11.3 - Plugin 3; EEP 13.2 - Plugin 2; EEP 17.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPIsControlTrackReserved(Steuerstrecken-ID [, true|Zahl])
-- ok, besetzt = EEPIsControlTrackReserved(333)
-- EEPIsControlTrackReserved(333, true)
-- ok, besetzt, Name_Fahrzeugverband = EEPIsControlTrackReserved(333, 1)

-- -------------------------------------------------------------------------------------------------------------------
---Aendert die Ebene eines Gleises mit mehreren Ebenen und damit das Aussehen der Oberflaeche des Gleises.
---@param gleisID number Parameter.
---@param ebenennummer any Parameter.
function EEPRailTrackChangeAppearance(gleisID, ebenennummer) end
--       ===================================================
-- Verfuegbar ab EEP 18.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPRailTrackChangeAppearance(Gleis-ID, Ebenennummer)

-- -------------------------------------------------------------------------------------------------------------------
---Aendert die Ebene einer Strasse mit mehreren Ebenen und damit das Aussehen der Oberflaeche der Strasse.
---@param strassenID number Parameter.
---@param ebenennummer any Parameter.
function EEPRoadTrackChangeAppearance(strassenID, ebenennummer) end
--       ======================================================
-- Verfuegbar ab EEP 18.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPRoadTrackChangeAppearance(Strassen-ID, Ebenennummer)

-- -------------------------------------------------------------------------------------------------------------------
---Aendert die Ebene eines Strassenbahngleises mit mehreren Ebenen und damit das Aussehen der Oberflaeche des
---Strassenbahngleises.
---@param strassenbahngleisID number Parameter.
---@param ebenennummer any Parameter.
function EEPTramTrackChangeAppearance(strassenbahngleisID, ebenennummer) end
--       ===============================================================
-- Verfuegbar ab EEP 18.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPTramTrackChangeAppearance(Strassenbahngleis-ID, Ebenennummer)

-- -------------------------------------------------------------------------------------------------------------------
---Aendert die Ebene eines Weg-Elementes der Kategorie "Sonstige" mit mehreren Ebenen und damit die Oberflaeche des
---Weges.
---@param wegID number Parameter.
---@param ebenennummer any Parameter.
function EEPAuxiliaryTrackChangeAppearance(wegID, ebenennummer) end
--       ======================================================
-- Verfuegbar ab EEP 18.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPAuxiliaryTrackChangeAppearance(Weg-ID, Ebenennummer)

-- -------------------------------------------------------------------------------------------------------------------
---Waehlt eine der gespeicherten Kameras aus der Liste.
---@param typ any Parameter.
---@param kameraname string Parameter.
function EEPSetCamera(typ, kameraname) end
--       =============================
-- Verfuegbar ab EEP 11.3 - Plugin 3.
-- Beispielaufrufe:
-- EEPSetCamera(Typ, "Kameraname")

-- -------------------------------------------------------------------------------------------------------------------
---Definiert die Position der aktuellen Kamera
---@param posX number Parameter.
---@param posY number Parameter.
---@param posZ number Parameter.
function EEPSetCameraPosition(posX, posY, posZ) end
--       ======================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPSetCameraPosition(Pos_X, Pos_Y, Pos_Z)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die Position der aktuellen Kamera
function EEPGetCameraPosition() end
--       ======================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPGetCameraPosition()

-- -------------------------------------------------------------------------------------------------------------------
---Definiert die Ausrichtung der aktuellen Kamera
---@param rot_X any Parameter.
---@param rot_Y any Parameter.
---@param rot_Z any Parameter.
function EEPSetCameraRotation(rot_X, rot_Y, rot_Z) end
--       =========================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPSetCameraRotation(Rot_X, Rot_Y, Rot_Z)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die Ausrichtung der aktuellen Kamera.
function EEPGetCameraRotation() end
--       ======================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPGetCameraRotation()

-- -------------------------------------------------------------------------------------------------------------------
---Waehlt eine der Verfolger-Kameras fuer den angegebenen "Fahrzeugverband".
---@overload fun(kameraposition: any): nil
---@param kameraposition any Parameter.
---@param name? string Parameter.
function EEPSetPerspectiveCamera(kameraposition, name) end
--       =============================================
-- Verfuegbar ab EEP 11.3; EEP 15; EEP 16.4 - Plugin 4.
-- Beispielaufrufe:
-- EEPSetPerspectiveCamera(Kameraposition [, "#Name")
-- ok = EEPSetPerspectiveCamera(3,"#Personenzug")
-- ab EEP15:
-- ok = EEPSetPerspectiveCamera(6)
-- ab EEP 16 Plugin 4:
-- ok = EEPSetPerspectiveCamera(10)

-- -------------------------------------------------------------------------------------------------------------------
---Gibt an, welche Verfolger-Kamera fuer den angegebenen bzw. aktiven "Fahrzeugverband" ausgewaehlt ist.
---@param trainName? string Parameter.
function EEPGetPerspectiveCamera(trainName) end
--       ==================================
-- Verfuegbar ab EEP 18.0.
-- Beispielaufrufe:
-- EEPGetPerspectiveCamera(["#Zugname")
-- ok, Kameraposition = Rueckgabewerte zwei EEPGetPerspectiveCamera("#Personenzug")
-- ok, Kameraposition = EEPGetPerspectiveCamera()

-- -------------------------------------------------------------------------------------------------------------------
---Definiert die Position der User-definierten Mitfahrkamera [Aufruf ueber Taste 9 oder EEPSetPerspectiveCamera(9,
---"#Name") bzw. EEPSetPerspectiveCamera(9). Ab EEP 17.1 Plugin 1 auch direkt durch zusaetzlichen Parameter.]
---@param rollingstockName string Parameter.
---@param posX number Parameter.
---@param posY number Parameter.
---@param posZ number Parameter.
---@param rotH number Parameter.
---@param rotV number Parameter.
function EEPRollingstockSetUserCamera(rollingstockName, posX, posY, posZ, rotH, rotV) end
--       ============================================================================
-- Verfuegbar ab EEP 16.1 - Plugin 1; EEP 17.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPRollingstockSetUserCamera("Fahrzeugname", Pos_X, Pos_Y, Pos_Z, Rot_H, Rot_V[, 1])
-- ok = Rueckgabewerte einer EEPRollingstockSetUserCamera("Salonwagen", -4, 0, 2, 180, 90, 1) - sofortige Ausfuehrung
-- ok = EEPRollingstockSetUserCamera("Salonwagen", -4, 0, 2, 180, 90) - nur Definition

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt (wenn vorhanden) die Position der vom Konstrukteur (ausserhalb des Fuehrerstands) vorgegebenen
---Mitfahrkamera bzw. vorrangig die vom User mit EEPRollingstockSetUserCamera() definierte Mitfahrkamera.
---@param rollingstockName string Parameter.
function EEPRollingstockGetUserCamera(rollingstockName) end
--       ==============================================
-- Verfuegbar ab EEP 17.
-- Beispielaufrufe:
-- EEPRollingstockGetUserCamera("Fahrzeugname")
-- EEPRollingstockGetUserCamera("Salonwagen")

-- -------------------------------------------------------------------------------------------------------------------
---Laedt eine Anlage aus dem Ordner "Resourcen\Anlagen" oder dem unter Programmeinstellungen eingetragenen
---Anlagenordner bzw. deren Unterordnern.
---@param unterordnerDateiname string Parameter.
function EEPLoadProject(unterordnerDateiname) end
--       ====================================
-- Verfuegbar ab EEP 11.3 - Plugin 3.
-- Beispielaufrufe:
-- EEPLoadProject("[Unterordner /|\\ ] Dateiname")
-- ok = EEPLoadProject("MeineAnlage.anl3")
-- ok = EEPLoadProject("Tutorials\\Tutorial_54_LUA.anl3")

-- -------------------------------------------------------------------------------------------------------------------
---EEP ruft selbstaendig diese Funktion waehrend der Speicherung auf und liefert im selbstgewaehlten Parameter den
---Pfad, in dem die Anlage gespeichert wurde.
---@param anlagenpfad any Parameter.
function EEPOnSaveAnl(anlagenpfad) end
--       =========================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPOnSaveAnl(Anlagenpfad)
-- function EEPOnSaveAnl(Anlagenpfad) " gespeichert!")
-- end

-- -------------------------------------------------------------------------------------------------------------------
---EEP ruft selbstaendig diese Funktion vor jeder Speicherung auf. In der Funktion kann man festlegen, was vor dem
---Speichern der Anlage zu tun ist.
function EEPOnBeforeSaveAnl() end
--       ====================
-- Verfuegbar ab EEP 17.
-- Beispielaufrufe:
-- EEPOnBeforeSaveAnl()
-- function EEPOnBeforeSaveAnl()
-- end

-- -------------------------------------------------------------------------------------------------------------------
---Liefert die EEP-Version, mit der die Anlage zuletzt gespeichert wurde.
function EEPGetAnlVer() end
--       ==============
-- Verfuegbar ab EEP 17.
-- Beispielaufrufe:
-- EEPGetAnlVer()
-- Anlagenversion = EEPGetAnlVer()

-- -------------------------------------------------------------------------------------------------------------------
---Liefert die auf Achsnamen bezogene "Anlagensprache". Diese wird mit dem ersten Einsetzen eines Modells mit Achsen
---von EEP vergeben und aendert sich danach nicht mehr. Solange noch kein Modell mit Achsen eingesetzt wurde,
---entspricht diese "Anlagensprache" der Sprache der aktuellen EEP-Version, d.h. der EEP-spezifischen Variablen
---EEPLng.
function EEPGetAnlLng() end
--       ==============
-- Verfuegbar ab EEP 17.
-- Beispielaufrufe:
-- EEPGetAnlLng()
-- Anlagensprache = EEPGetAnlLng()
-- if Anlagensprache == "GER" then
-- elseif Anlagensprache == "ENG" then
-- print("Die Anlagensprache in Bezug auf Achsen ist englisch.")
-- elseif Anlagensprache == "FRA" then
-- print("Die Anlagensprache in Bezug auf Achsen ist franzoesisch.")
-- end

-- -------------------------------------------------------------------------------------------------------------------
---Liefert den Namen mit dem die Anlage zuletzt gespeichert wurde.
function EEPGetAnlName() end
--       ===============
-- Verfuegbar ab EEP 17.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPGetAnlName()
-- Name = EEPGetAnlName()
-- print("Willkommen in der Anlage ", Name)

-- -------------------------------------------------------------------------------------------------------------------
---Liefert den Speicherpfad der Anlagendatei (.anl3) ohne den Dateinamen zurueck. Hierdurch koennen z.B. im
---Anlagenordner gespeicherte Lua-Dateien in die Anlagen- Lua-Datei eingebunden werden.
function EEPGetAnlPath() end
--       ===============
-- Verfuegbar ab EEP 18.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPGetAnlPath()
-- Pfad = EEPGetAnlPath()

-- -------------------------------------------------------------------------------------------------------------------
---Schickt einen ausgewaehlten "Fahrzeugverband" aus einem ausgewaehlten virtuellen Depot.
---@overload fun(depot_ID: number, name: string, listenplatz: number): nil
---@param depot_ID number Parameter.
---@param name string Parameter.
---@param listenplatz number Parameter.
---@param fahrtrichtung? any Parameter.
function EEPGetTrainFromTrainyard(depot_ID, name, listenplatz, fahrtrichtung) end
--       ====================================================================
-- Verfuegbar ab EEP 11.3 - Plugin 2; EEP 15.
-- Beispielaufrufe:
-- EEPGetTrainFromTrainyard(Depot_ID, "#Name", Listenplatz [, Fahrtrichtung])
-- ok = EEPGetTrainFromTrainyard(2, "", 4, 1)

-- -------------------------------------------------------------------------------------------------------------------
---Wird immer dann aufgerufen, wenn ein "Fahrzeugverband" ein virtuelles Depot verlaesst.
---@param depot_ID number Parameter.
---@param name string Parameter.
function EEPOnTrainExitTrainyard(depot_ID, name) end
--       =======================================
-- Verfuegbar ab EEP 14.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPOnTrainExitTrainyard(Depot_ID, Name)
-- function EEPOnTrainExitTrainyard(Depot_ID, Name)
-- end

-- -------------------------------------------------------------------------------------------------------------------
---Wird immer dann aufgerufen, wenn ein "Fahrzeugverband" in ein virtuelles Depot einfaehrt.
---@param depotID number Parameter.
---@param name string Parameter.
function EEPOnTrainEnterTrainyard(depotID, name) end
--       =======================================
-- Verfuegbar ab EEP 18.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPOnTrainEnterTrainyard(DepotID, Name)
-- function EEPOnTrainEnterTrainyard(DepotID, Name)
-- end

-- -------------------------------------------------------------------------------------------------------------------
---Liefert die Anzahl der im virtuellen Depot gefuehrten "Fahrzeugverbaende"
---@param depotID number Parameter.
function EEPGetTrainyardItemsCount(depotID) end
--       ==================================
-- Verfuegbar ab EEP 13.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPGetTrainyardItemsCount(Depot-ID)

-- -------------------------------------------------------------------------------------------------------------------
---Liefert den Namen eines "Fahrzeugverbands" im virtuellen Depot
---@param depotID number Parameter.
---@param listenplatz number Parameter.
function EEPGetTrainyardItemName(depotID, listenplatz) end
--       =============================================
-- Verfuegbar ab EEP 13.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPGetTrainyardItemName(Depot-ID, Listenplatz)

-- -------------------------------------------------------------------------------------------------------------------
---endif Liefert den Status eines "Fahrzeugverbands" im virtuellen Depot
---@param depotID number Parameter.
---@param name string Parameter.
---@param listenplatz number Parameter.
function EEPGetTrainyardItemStatus(depotID, name, listenplatz) end
--       =====================================================
-- Verfuegbar ab EEP 13.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPGetTrainyardItemStatus(Depot-ID, "#Name", Listenplatz)
-- Status = EEPGetTrainyardItemStatus(1, "#Gueterzug",0)
-- if EEPGetTrainyardItemStatus(3, "#Rheingold", 0)
-- then
-- print("Der Zug wartet im Depot!")
-- else
-- print("Der Zug ist bereits ausgefahren!")

-- -------------------------------------------------------------------------------------------------------------------
---Gibt die Nummer des virtuellen Depots zurueck, in dem sich der "Fahrzeugverband" befindet, oder die Zahl Null, wenn
---er sich in der Anlage befindet.
---@param name string Parameter.
function EEPIsTrainInTrainyard(name) end
--       ===========================
-- Verfuegbar ab EEP 18.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPIsTrainInTrainyard(Name)

-- -------------------------------------------------------------------------------------------------------------------
---Verschiebt einen "Fahrzeugverband" oder alle dort registrierten in ein virtuelles Depot.
function EEPPutTrainToTrainyard() end
--       ========================
-- Verfuegbar ab EEP 18.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPPutTrainToTrainyard (DepotID, Name)
-- ok = EEPPutTrainToTrainyard(3, "#Rheingold")
-- ok = EEPPutTrainToTrainyard(3, "")

-- -------------------------------------------------------------------------------------------------------------------
---Weist dem Tipp-Text einer Immobilie oder eines Landschaftselements einen neuen Text zu
---@param luaName string Parameter.
---@param text string Parameter.
function EEPChangeInfoStructure(luaName, text) end
--       =====================================
-- Verfuegbar ab EEP 13.
-- Beispielaufrufe:
-- EEPChangeInfoStructure("#Lua-Name", "Text")

-- -------------------------------------------------------------------------------------------------------------------
---Schaltet den Tipp-Text einer Immobilie oder eines Landschaftselements ein oder aus
---@param luaName string Parameter.
---@param state boolean Parameter.
function EEPShowInfoStructure(luaName, state) end
--       ====================================
-- Verfuegbar ab EEP 13.
-- Beispielaufrufe:
-- EEPShowInfoStructure("#Lua-Name", true|false)

-- -------------------------------------------------------------------------------------------------------------------
---Weist dem Tipp-Text eines Signals einen neuen Text zu
---@param signalId number Parameter.
---@param text string Parameter.
function EEPChangeInfoSignal(signalId, text) end
--       ===================================
-- Verfuegbar ab EEP 13.
-- Beispielaufrufe:
-- EEPChangeInfoSignal(Signal-ID, "Text")

-- -------------------------------------------------------------------------------------------------------------------
---Schaltet den Tipp-Text eines Signals ein oder aus
---@param signalId number Parameter.
---@param state boolean Parameter.
function EEPShowInfoSignal(signalId, state) end
--       ==================================
-- Verfuegbar ab EEP 13.
-- Beispielaufrufe:
-- EEPShowInfoSignal(Signal-ID, true|false)

-- -------------------------------------------------------------------------------------------------------------------
---Weist dem Tipp-Text einer Weiche einen neuen Text zu
---@param weichenID number Parameter.
---@param text string Parameter.
function EEPChangeInfoSwitch(weichenID, text) end
--       ====================================
-- Verfuegbar ab EEP 13.
-- Beispielaufrufe:
-- EEPChangeInfoSwitch(Weichen-ID, "Text")
-- ok = EEPChangeInfoSwitch(63, Text)

-- -------------------------------------------------------------------------------------------------------------------
---Schaltet den Tipp-Text einer Weiche ein oder aus
---@param weichenID number Parameter.
---@param state boolean Parameter.
function EEPShowInfoSwitch(weichenID, state) end
--       ===================================
-- Verfuegbar ab EEP 13.
-- Beispielaufrufe:
-- EEPShowInfoSwitch(Weichen-ID, true|false)

-- -------------------------------------------------------------------------------------------------------------------
---Erzeugt einen Infotext am oberen Bildrand des 3D-Fensters
---@param r any Parameter.
---@param g any Parameter.
---@param b any Parameter.
---@param sz any Parameter.
---@param t any Parameter.
---@param j any Parameter.
---@param text string Parameter.
function EEPShowInfoTextTop(r, g, b, sz, t, j, text) end
--       ===========================================
-- Verfuegbar ab EEP 13.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPShowInfoTextTop(r, g, b, sz, t, j, "Text")
-- r = 1 -- Rot
-- g = 1 -- Gruen
-- S = 1 -- Schriftgroesse
-- Z = 10 -- Zeit
-- A = 1 -- Ausrichtung
-- Text = "Weiss oben zentriert fuer 10 Sekunden"
-- ok = EEPShowInfoTextTop(r,g,b,S,Z,A,Text)

-- -------------------------------------------------------------------------------------------------------------------
---Erzeugt einen Infotext am unteren Bildrand des 3D-Fensters
---@param r any Parameter.
---@param g any Parameter.
---@param b any Parameter.
---@param sz any Parameter.
---@param t any Parameter.
---@param j any Parameter.
---@param text string Parameter.
function EEPShowInfoTextBottom(r, g, b, sz, t, j, text) end
--       ==============================================
-- Verfuegbar ab EEP 13.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPShowInfoTextBottom(r, g, b, sz, t, j, "Text")
-- r = 1 -- Rot
-- g = 1 -- Gruen
-- S = 0.75 -- Schriftgroesse
-- Z = 15 -- Zeit
-- A = 2 -- Ausrichtung
-- Text = "Gelb unten linksbuendig fuer 15 Sekunden"
-- ok = EEPShowInfoTextBottom(r,g,b,S,Z,A,Text)

-- -------------------------------------------------------------------------------------------------------------------
---Sekunden" ok = EEPShowScrollInfoTextTop(r,g,b,S,Z,A,G,Text) Erzeugt einen durchlaufenden Infotext am oberen
---Bildrand des 3D-Fensters
function EEPShowScrollInfoTextTop() end
--       ==========================
-- Verfuegbar ab EEP 13.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPShowScrollInfoTextTop(r, g, b, sz, t, j, "Text")
-- acht r = 0 -- Rot
-- g = 1 -- Gruen
-- S = 1.2 -- Schriftgroesse
-- Z = 20 -- Zeit
-- A = 0 -- Ausrichtung
-- G = 0.2 -- Geschwindigkeit
-- Text = "Laufschrift oben in tuerkis fuer 20

-- -------------------------------------------------------------------------------------------------------------------
---Erzeugt einen durchlaufenden Infotext am unteren Bildrand des 3D-Fensters
function EEPShowScrollInfoTextBottom() end
--       =============================
-- Verfuegbar ab EEP 13.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPShowScrollInfoTextBottom(r, g, b, sz, t, j, "Text")
-- acht r = 1 -- Rot
-- g = 0 -- Gruen
-- S = 0.6 -- Schriftgroesse
-- Z = 10 -- Zeit
-- A = 0 -- Ausrichtung
-- G = 0.1 -- Geschwindigkeit
-- Text = "Laufschrift unten, magenta, 10 Sekunden"
-- ok = EEPShowScrollInfoTextBottom(r,g,b,S,Z,A,G,Text)

-- -------------------------------------------------------------------------------------------------------------------
---Blendet den Infotext am oberen Bildrand aus.
function EEPHideInfoTextTop() end
--       ====================
-- Verfuegbar ab EEP 13.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPHideInfoTextTop()

-- -------------------------------------------------------------------------------------------------------------------
---Blendet den Infotext am unteren Bildrand aus.
function EEPHideInfoTextBottom() end
--       =======================
-- Verfuegbar ab EEP 13.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPHideInfoTextBottom()

-- -------------------------------------------------------------------------------------------------------------------
---Spielt ortsunabhaengig eine Sounddatei ab.
---@param pfadPfadDateiname string Parameter.
function EEPPlaySound(pfadPfadDateiname) end
--       ===============================
-- Verfuegbar ab EEP 13 - Plugin 1.
-- Beispielaufrufe:
-- EEPPlaySound(["Pfad/|Pfad\\]Dateiname")
-- ok = EEPPlaySound("siren_polizei.wav")
-- ok = EEPPlaySound("EEXP\\Route1.wav")

-- -------------------------------------------------------------------------------------------------------------------
---Schaltet den Ton eines Soundmodells aus der Kategorie Landschaftselemente / Klaenge ein oder aus.
---@param luaName string Parameter.
---@param state boolean Parameter.
function EEPStructurePlaySound(luaName, state) end
--       =====================================
-- Verfuegbar ab EEP 13 - Plugin 1.
-- Beispielaufrufe:
-- EEPStructurePlaySound("#Lua-Name", true|false)

-- -------------------------------------------------------------------------------------------------------------------
---Weist einer beschreibbaren Flaeche einer Immobilie oder eines Landschaftselements einen neuen Text zu.
---@param luaName string Parameter.
---@param flaechennummer any Parameter.
---@param text string Parameter.
function EEPStructureSetTextureText(luaName, flaechennummer, text) end
--       =========================================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
-- EEPStructureSetTextureText("#Lua-Name", Flaechennummer,"Text")
-- ok = Rueckgabewerte einer EEPStructureSetTextureText("#147", 1, "Neustadt")

-- -------------------------------------------------------------------------------------------------------------------
---Liest den Text einer beschreibbaren Flaeche einer Immobilie oder eines Landschaftselements aus.
---@param luaName string Parameter.
---@param flaechennummer any Parameter.
function EEPStructureGetTextureText(luaName, flaechennummer) end
--       ===================================================
-- Verfuegbar ab EEP 17.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPStructureGetTextureText("#Lua-Name", Flaechennummer)

-- -------------------------------------------------------------------------------------------------------------------
---Weist einer beschreibbaren Flaeche eines Rollmaterials einen neuen Text zu.
---@param rollingstockName string Parameter.
---@param flaechennummer any Parameter.
---@param text string Parameter.
function EEPRollingstockSetTextureText(rollingstockName, flaechennummer, text) end
--       =====================================================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
-- EEPRollingstockSetTextureText("Fahrzeugname", Flaechennummer,"Text")
-- ok = Rueckgabewerte einer EEPRollingstockSetTextureText("BR481",1,"Dienstf ahrt")

-- -------------------------------------------------------------------------------------------------------------------
---Liest den Text einer beschreibbaren Flaeche eines Rollmaterials aus.
---@param rollingstockName string Parameter.
---@param flaechennummer any Parameter.
function EEPRollingstockGetTextureText(rollingstockName, flaechennummer) end
--       ===============================================================
-- Verfuegbar ab EEP 16.3 - Plugin 3.
-- Beispielaufrufe:
-- EEPRollingstockGetTextureText("Fahrzeugname", Flaechennummer)
-- EEPRollingstockGetTextureText("BR481", 1)

-- -------------------------------------------------------------------------------------------------------------------
---Weist einer beschreibbaren Flaeche eines Signals einen neuen Text zu.
---@param signalId number Parameter.
---@param flaechennummer any Parameter.
---@param text string Parameter.
function EEPSignalSetTextureText(signalId, flaechennummer, text) end
--       =======================================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
-- EEPSignalSetTextureText(Signal-ID, Flaechennummer, "Text")
-- ok = Rueckgabewerte einer EEPSignalSetTextureText(88, 1, "Feuerwehr Ausfahrt")

-- -------------------------------------------------------------------------------------------------------------------
---Liest den Text einer beschreibbaren Flaeche eines Signals aus.
---@param signalId number Parameter.
---@param flaechennummer any Parameter.
function EEPSignalGetTextureText(signalId, flaechennummer) end
--       =================================================
-- Verfuegbar ab EEP 17.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPSignalGetTextureText(Signal-ID, Flaechennummer)

-- -------------------------------------------------------------------------------------------------------------------
---Weist einer beschreibbaren Flaeche eines Ladeguts einen neuen Text zu.
---@param luaName string Parameter.
---@param flaechennummer any Parameter.
---@param text string Parameter.
function EEPGoodsSetTextureText(luaName, flaechennummer, text) end
--       =====================================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
-- EEPGoodsSetTextureText("#Lua-Name", Flaechennummer,"Text")
-- ok = Rueckgabewerte einer EEPGoodsSetTextureText("#137", 2, "Lua Logistik")

-- -------------------------------------------------------------------------------------------------------------------
---Liest den Text einer beschreibbaren Flaeche eines Ladegutes aus.
---@param luaName string Parameter.
---@param flaechennummer any Parameter.
function EEPGoodsGetTextureText(luaName, flaechennummer) end
--       ===============================================
-- Verfuegbar ab EEP 17.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPGoodsGetTextureText("#Lua-Name", Flaechennummer)

-- -------------------------------------------------------------------------------------------------------------------
---Weist einer beschreibbaren Flaeche eines Gleisstuecks einen neuen Text zu.
---@param gleisID number Parameter.
---@param flaechennummer any Parameter.
---@param text string Parameter.
function EEPRailTrackSetTextureText(gleisID, flaechennummer, text) end
--       =========================================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
-- EEPRailTrackSetTextureText(Gleis-ID, Flaechennummer, "Text")

-- -------------------------------------------------------------------------------------------------------------------
---Liest den Text einer beschreibbaren Flaeche eines Gleisstuecks aus.
---@param gleisID number Parameter.
---@param flaechennummer any Parameter.
function EEPRailTrackGetTextureText(gleisID, flaechennummer) end
--       ===================================================
-- Verfuegbar ab EEP 17.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPRailTrackGetTextureText(Gleis-ID, Flaechennummer)

-- -------------------------------------------------------------------------------------------------------------------
---Weist einer beschreibbaren Flaeche eines Strassenstuecks einen neuen Text zu.
---@param strassenID number Parameter.
---@param flaechennummer any Parameter.
---@param text string Parameter.
function EEPRoadTrackSetTextureText(strassenID, flaechennummer, text) end
--       ============================================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
-- EEPRoadTrackSetTextureText(Strassen-ID, Flaechennummer, "Text")

-- -------------------------------------------------------------------------------------------------------------------
---Liest den Text einer beschreibbaren Flaeche eines Strassenstuecks aus.
---@param strassenID number Parameter.
---@param flaechennummer any Parameter.
function EEPRoadTrackGetTextureText(strassenID, flaechennummer) end
--       ======================================================
-- Verfuegbar ab EEP 17.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPRoadTrackGetTextureText(Strassen-ID, Flaechennummer)

-- -------------------------------------------------------------------------------------------------------------------
---Weist einer beschreibbaren Flaeche eines Strassenbahngleisstuecks einen neuen Text zu.
---@param strassenbahngleisID number Parameter.
---@param flaechennummer any Parameter.
---@param textStrassenbahngleis any Parameter.
function EEPTramTrackSetTextureText(strassenbahngleisID, flaechennummer, textStrassenbahngleis) end
--       ======================================================================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
-- EEPTramTrackSetTextureText(Strassenbahngleis-ID, Flaechennummer, "Text") "Strassenbahngleis")

-- -------------------------------------------------------------------------------------------------------------------
---Liest den Text einer beschreibbaren Flaeche eines Strassenbahngleisstuecks aus.
---@param strassenbahngleisID number Parameter.
---@param flaechennummer any Parameter.
function EEPTramTrackGetTextureText(strassenbahngleisID, flaechennummer) end
--       ===============================================================
-- Verfuegbar ab EEP 17.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPTramTrackGetTextureText(Strassenbahngleis-ID, Flaechennummer)

-- -------------------------------------------------------------------------------------------------------------------
---Weist einer beschreibbaren Flaeche eines Weg-Elementes der Kategorie "Sonstige" einen neuen Text zu.
---@param splineID number Parameter.
---@param flaechennummer any Parameter.
---@param textBauzaun any Parameter.
function EEPAuxiliaryTrackSetTextureText(splineID, flaechennummer, textBauzaun) end
--       ======================================================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
-- EEPAuxiliaryTrackSetTextureText(Spline-ID, Flaechennummer, "Text") "Bauzaun")

-- -------------------------------------------------------------------------------------------------------------------
---Liest den Text einer beschreibbaren Flaeche eines Weg-Elementes der Kategorie "Sonstige" aus.
---@param splineID number Parameter.
---@param flaechennummer any Parameter.
function EEPAuxiliaryTrackGetTextureText(splineID, flaechennummer) end
--       =========================================================
-- Verfuegbar ab EEP 17.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPAuxiliaryTrackGetTextureText(Spline-ID, Flaechennummer)
-- EEPAuxiliaryTrackGetTextureText(197, 1)

-- -------------------------------------------------------------------------------------------------------------------
---Aendert den Tag-Text einer Immobilie oder eines Landschaftselementes. Jede Immobilie bzw. jedes Landschaftselement
---kann einen individuellen String von maximal 1024 Zeichen Laenge mitfuehren. Diese Strings werden mit der Anlage
---gespeichert und geladen.
---@param luaName string Parameter.
---@param text string Parameter.
function EEPStructureSetTagText(luaName, text) end
--       =====================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
-- EEPStructureSetTagText("#Lua-Name","Text")

-- -------------------------------------------------------------------------------------------------------------------
---Liest den Tag-Text einer Immobilie oder eines Landschaftselementes aus. Mittels Tag-Texten koennen Immobilien bzw.
---Landschaftselemente als permanente Speicher fuer relevante Informationen genutzt werden.
---@param luaName string Parameter.
function EEPStructureGetTagText(luaName) end
--       ===============================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
-- EEPStructureGetTagText("#Lua-Name")

-- -------------------------------------------------------------------------------------------------------------------
---Aendert den Tag-Text eines Fahrzeugs. Jedes Fahrzeug kann einen eigenen String von maximal 1024 Zeichen Laenge
---mitfuehren. Diese Strings werden mit der Anlage gespeichert und geladen. Da die Texte individuell jedem Fahrzeug
---zugeordnet sind, gehen sie im Gegensatz zu Routen nicht durch Rangiermanoever etc. verloren.
---@param rollingstockName string Parameter.
---@param textTankwagen any Parameter.
function EEPRollingstockSetTagText(rollingstockName, textTankwagen) end
--       ==========================================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
-- EEPRollingstockSetTagText("Fahrzeugname","Text") "Tankwagen")

-- -------------------------------------------------------------------------------------------------------------------
---Liest den Tag-Text eines Fahrzeugs aus. Mittels Tag-Texten koennen Fahrzeuge jetzt kategorisiert werden.
---Beispielsweise kann man dort Waggontypen speichern oder Bestimmungsorte.
---@param rollingstockName string Parameter.
function EEPRollingstockGetTagText(rollingstockName) end
--       ===========================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
-- EEPRollingstockGetTagText("Fahrzeugname")

-- -------------------------------------------------------------------------------------------------------------------
---Aendert den Tag-Text eines Signals. Jedes Signal kann einen eigenen String von maximal 1024 Zeichen Laenge
---mitfuehren. Diese Strings werden mit der Anlage gespeichert und geladen. Da die Texte individuell jedem Signal
---zugeordnet sind, gehen sie nicht verloren.
---@param signalId number Parameter.
---@param text string Parameter.
function EEPSignalSetTagText(signalId, text) end
--       ===================================
-- Verfuegbar ab EEP 17.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPSignalSetTagText(Signal-ID,"Text")

-- -------------------------------------------------------------------------------------------------------------------
---Liest den Tag-Text eines Signals aus. Mittels Tag-Texten koennen z.B. Informationen zu Fahrstrassenschaltungen oder
---Bahnuebergaengen direkt in den Signalen anstatt in Datenslots gespeichert werden.
---@param signalId number Parameter.
function EEPSignalGetTagText(signalId) end
--       =============================
-- Verfuegbar ab EEP 17.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPSignalGetTagText(Signal-ID)

-- -------------------------------------------------------------------------------------------------------------------
---Aendert den Tag-Text eines Ladegutes. Jedes Ladegut kann einen eigenen String von maximal 1024 Zeichen Laenge
---mitfuehren. Diese Strings werden mit der Anlage gespeichert und geladen. Da die Texte individuell jedem Ladegut
---zugeordnet sind, gehen sie nicht verloren.
---@param luaName string Parameter.
---@param text string Parameter.
function EEPGoodsSetTagText(luaName, text) end
--       =================================
-- Verfuegbar ab EEP 18.0.
-- Beispielaufrufe:
-- EEPGoodsSetTagText("#Lua-Name","Text")

-- -------------------------------------------------------------------------------------------------------------------
---Liest den Tag-Text eines Ladegutes aus. Mittels Tag-Texten koennen z.B. Informationen zu Verladezielen direkt in
---den Ladeguetern gespeichert werden.
---@param luaName string Parameter.
function EEPGoodsGetTagText(luaName) end
--       ===========================
-- Verfuegbar ab EEP 18.0.
-- Beispielaufrufe:
-- EEPGoodsGetTagText("#Lua-Name")

-- -------------------------------------------------------------------------------------------------------------------
---Aendert den Tag-Text einer Weiche. Jede Weiche kann einen eigenen String von maximal 1024 Zeichen Laenge
---mitfuehren. Diese Strings werden mit der Anlage gespeichert und geladen. Da die Texte individuell jeder Weiche
---zugeordnet sind, gehen sie nicht verloren.
---@param weichenID number Parameter.
---@param text string Parameter.
function EEPSwitchSetTagText(weichenID, text) end
--       ====================================
-- Verfuegbar ab EEP 18.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPSwitchSetTagText(WeichenID,"Text")

-- -------------------------------------------------------------------------------------------------------------------
---Liest den Tag-Text einer Weiche aus. Mittels Tag-Texten koennen auch Weichen als permanente Speicher fuer relevante
---Informationen genutzt werden.
---@param weichenID number Parameter.
function EEPSwitchGetTagText(weichenID) end
--       ==============================
-- Verfuegbar ab EEP 18.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPSwitchGetTagText(WeichenID)

-- -------------------------------------------------------------------------------------------------------------------
---Waehlt das angegebene Fahrzeug im Steuerdialog aus und stellt den Steuerdialog auf manuellen Modus um
---@param rollingstockName string Parameter.
function EEPRollingstockSetActive(rollingstockName) end
--       ==========================================
-- Verfuegbar ab EEP 15.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPRollingstockSetActive("Fahrzeugname")

-- -------------------------------------------------------------------------------------------------------------------
---- Plug in 1 Ermittelt, welches Fahrzeug derzeit im Steuerdialog ausgewaehlt ist.
function EEPRollingstockGetActive() end
--       ==========================
-- Verfuegbar ab EEP 15.1.
-- Beispielaufrufe:
-- EEPRollingstockGetActive()

-- -------------------------------------------------------------------------------------------------------------------
---Waehlt den angegebenen "Fahrzeugverband" im Steuerdialog aus und stellt den Steuerdialog auf Automatik-Modus um.
---@param name string Parameter.
function EEPSetTrainActive(name) end
--       =======================
-- Verfuegbar ab EEP 15.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPSetTrainActive("#Name")

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt, welcher "Fahrzeugverband" derzeit im Steuerdialog ausgewaehlt ist
function EEPGetTrainActive() end
--       ===================
-- Verfuegbar ab EEP 15 - Plugin 1.
-- Beispielaufrufe:
-- EEPGetTrainActive()

-- -------------------------------------------------------------------------------------------------------------------
---Schaltet global (ausserhalb eventueller Wetterzonen) auf ein Wolkenbild mit "blauem" Himmel und veraendert den
---Wolkenanteil zwischen 10 % und 100 % (entsprechend dem Bereich unter "Einstellung der Umwelt").
---@param wolkenanteil any Parameter.
function EEPSetCloudsIntensity(wolkenanteil) end
--       ===================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPSetCloudsIntensity(Wolkenanteil)

-- -------------------------------------------------------------------------------------------------------------------
---Schaltet global (ausserhalb eventueller Wetterzonen) auf ein Wolkenbild mit "grauem" Himmel und veraendert den
---Wolkenanteil zwischen 10 % und 100 % (entsprechend dem Bereich unter "Einstellung der Umwelt").
---@param wolkenanteil any Parameter.
function EEPSetDarkCloudsIntensity(wolkenanteil) end
--       =======================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPSetDarkCloudsIntensity(Wolkenanteil)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt den globalen Wolkenanteil (ausserhalb eventueller Wetterzonen).
function EEPGetCloudsIntensity() end
--       =======================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPGetCloudsIntensity()

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt, ob global (ausserhalb eventueller Wetterzonen) Wolken am Himmel sind und welcher Art sie sind.
function EEPGetCloudsMode() end
--       ==================
-- Verfuegbar ab EEP 17.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPGetCloudsMode()

-- -------------------------------------------------------------------------------------------------------------------
---Veraendert die globale Windstaerke (ausserhalb eventueller Wetterzonen) zwischen 10 % und 100 % (entsprechend dem
---Bereich unter "Einstellung der Umwelt").
---@param windstaerke any Parameter.
function EEPSetWindIntensity(windstaerke) end
--       ================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPSetWindIntensity(Windstaerke)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die globale Windstaerke (ausserhalb eventueller Wetterzonen).
function EEPGetWindIntensity() end
--       =====================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPGetWindIntensity()

-- -------------------------------------------------------------------------------------------------------------------
---Veraendert die globale Regenstaerke (ausserhalb eventueller Wetterzonen) zwischen 10 % und 100 % (entsprechend dem
---Bereich unter "Einstellung der Umwelt").
---@param regenstaerke any Parameter.
function EEPSetRainIntensity(regenstaerke) end
--       =================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPSetRainIntensity(Regenstaerke)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die globale Regenstaerke (ausserhalb eventueller Wetterzonen).
function EEPGetRainIntensity() end
--       =====================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPGetRainIntensity()

-- -------------------------------------------------------------------------------------------------------------------
---Veraendert die globale Schneefallstaerke (ausserhalb eventueller Wetterzonen) zwischen 10 % und 100 % (entsprechend
---dem Bereich unter "Einstellung der Umwelt")
---@param schneefallstaerke any Parameter.
function EEPSetSnowIntensity(schneefallstaerke) end
--       ======================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPSetSnowIntensity(Schneefallstaerke)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die globale Schneeintensitaet (ausserhalb eventueller Wetterzonen)
function EEPGetSnowIntensity() end
--       =====================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPGetSnowIntensity()

-- -------------------------------------------------------------------------------------------------------------------
---Veraendert die globale Hagelstaerke (ausserhalb eventueller Wetterzonen) zwischen 10 % und 100 % (entsprechend dem
---Bereich unter "Einstellung der Umwelt").
---@param hagelstaerke any Parameter.
function EEPSetHailIntensity(hagelstaerke) end
--       =================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPSetHailIntensity(Hagelstaerke)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die globale Hagelstaerke (ausserhalb eventueller Wetterzonen).
function EEPGetHailIntensity() end
--       =====================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPGetHailIntensity()

-- -------------------------------------------------------------------------------------------------------------------
---Veraendert die globale Nebeldichte (ausserhalb eventueller Wetterzonen) zwischen 10 % und 100 % (entsprechend dem
---Bereich unter "Einstellung der Umwelt")
---@param nebeldichte any Parameter.
function EEPSetFogIntensity(nebeldichte) end
--       ===============================
-- Verfuegbar ab EEP 16.1.
-- Beispielaufrufe:
-- EEPSetFogIntensity(Nebeldichte)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die globale Nebeldichte (ausserhalb eventueller Wetterzonen).
function EEPGetFogIntensity() end
--       ====================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPGetFogIntensity()

-- -------------------------------------------------------------------------------------------------------------------
---Versetzt die benannte Wetterzone an eine neue Position und/oder veraendert ihren Radius.
---@param zonennummer any Parameter.
---@param posX number Parameter.
---@param posY number Parameter.
---@param posZ number Parameter.
---@param radius number Parameter.
function EEPSetZonePos(zonennummer, posX, posY, posZ, radius) end
--       ====================================================
-- Verfuegbar ab EEP 17.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPSetZonePos(Zonennummer, PosX, PosY, PosZ, Radius)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die aktuelle Position einer Wetterzone und ihren Radius.
function EEPGetZonePos() end
--       ===============
-- Verfuegbar ab EEP 17.1 - Plugin 1.

-- -------------------------------------------------------------------------------------------------------------------
---Veraendert die Windstaerke in einer Wetterzone zwischen 10 % und 100 % (entsprechend dem Bereich in den
---Objekteigenschaften der Wetterzone).
---@param zonennummer any Parameter.
---@param windstaerke any Parameter.
function EEPSetZoneWindIntensity(zonennummer, windstaerke) end
--       =================================================
-- Verfuegbar ab EEP 17.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPSetZoneWindIntensity(Zonennummer, Windstaerke)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die Windstaerke in einer Wetterzone.
---@param zonennummer any Parameter.
function EEPGetZoneWindIntensity(zonennummer) end
--       ====================================
-- Verfuegbar ab EEP 17.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPGetZoneWindIntensity(Zonennummer)

-- -------------------------------------------------------------------------------------------------------------------
---Veraendert die Regenstaerke in einer Wetterzone zwischen 10 % und 100 % (entsprechend dem Bereich in den
---Objekteigenschaften der Wetterzone).
---@param zonennummer any Parameter.
---@param regenstaerke any Parameter.
function EEPSetZoneRainIntensity(zonennummer, regenstaerke) end
--       ==================================================
-- Verfuegbar ab EEP 17.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPSetZoneRainIntensity(Zonennummer, Regenstaerke)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die Regenstaerke in einer Wetterzone.
---@param zonennummer any Parameter.
function EEPGetZoneRainIntensity(zonennummer) end
--       ====================================
-- Verfuegbar ab EEP 17.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPGetZoneRainIntensity(Zonennummer)

-- -------------------------------------------------------------------------------------------------------------------
---Veraendert die Schneefallstaerke in einer Wetterzone zwischen 10 % und 100 % (entsprechend dem Bereich in den
---Objekteigenschaften der Wetterzone)
---@param zonennummer any Parameter.
---@param schneefallstaerke any Parameter.
function EEPSetZoneSnowIntensity(zonennummer, schneefallstaerke) end
--       =======================================================
-- Verfuegbar ab EEP 17.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPSetZoneSnowIntensity(Zonennummer, Schneefallstaerke)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die Schneefallstaerke in einer Wetterzone
---@param zonennummer any Parameter.
function EEPGetZoneSnowIntensity(zonennummer) end
--       ====================================
-- Verfuegbar ab EEP 17.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPGetZoneSnowIntensity(Zonennummer)

-- -------------------------------------------------------------------------------------------------------------------
---Veraendert die Hagel-/Graupelstaerke in einer Wetterzone zwischen 10 % und 100 % (entsprechend dem Bereich in den
---Objekteigenschaften der Wetterzone).
---@param zonennummer any Parameter.
---@param hagelstaerke any Parameter.
function EEPSetZoneHailIntensity(zonennummer, hagelstaerke) end
--       ==================================================
-- Verfuegbar ab EEP 17.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPSetZoneHailIntensity(Zonennummer, Hagelstaerke)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die Hagel-/Graupelstaerke in einer Wetterzone
---@param zonennummer any Parameter.
function EEPGetZoneHailIntensity(zonennummer) end
--       ====================================
-- Verfuegbar ab EEP 17.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPGetZoneHailIntensity(Zonennummer)

-- -------------------------------------------------------------------------------------------------------------------
---Veraendert die Nebeldichte in einer Wetterzone zwischen 10 % und 100 % (entsprechend dem Bereich in den
---Objekteigenschaften der Wetterzone)
---@param zonennummer any Parameter.
---@param nebeldichte any Parameter.
function EEPSetZoneFogIntensity(zonennummer, nebeldichte) end
--       ================================================
-- Verfuegbar ab EEP 17.1.
-- Beispielaufrufe:
-- EEPSetZoneFogIntensity(Zonennummer, Nebeldichte)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die Nebeldichte in einer Wetterzone.
---@param zonennummer any Parameter.
function EEPGetZoneFogIntensity(zonennummer) end
--       ===================================
-- Verfuegbar ab EEP 17.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPGetZoneFogIntensity(Zonennummer)

-- -------------------------------------------------------------------------------------------------------------------
---Bestimmt, ob in einer Wetterzone Wolken am Himmel sind und welcher Art sie sind.
function EEPSetZoneClouds() end
--       ==================
-- Verfuegbar ab EEP 17.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPSetZoneClouds (Zonennummer, Modus)

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt, ob in einer Wetterzone Wolken am Himmel sind und welcher Art sie sind.
---@param zonennummer any Parameter.
function EEPGetZoneClouds(zonennummer) end
--       =============================
-- Verfuegbar ab EEP 17.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPGetZoneClouds(Zonennummer)

-- -------------------------------------------------------------------------------------------------------------------
---Veraendert die Einstellung der Jahreszeit in der Anlage.
function EEPSetSeason() end
--       ==============
-- Verfuegbar ab EEP 18.0.
-- Beispielaufrufe:
-- EEPSetSeason()

-- -------------------------------------------------------------------------------------------------------------------
---Ermittelt die in der Anlage eingestellte Jahreszeit.
function EEPGetSeason() end
--       ==============
-- Verfuegbar ab EEP 17.2 - Plugin 2.
-- Beispielaufrufe:
-- EEPGetSeason()

-- -------------------------------------------------------------------------------------------------------------------
---Ruft ein Gleisbildstellpult (GBS) im Radarfenster auf.
---@param stellpultName string Parameter.
function EEPActivateCtrlDesk(stellpultName) end
--       ==================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
-- EEPActivateCtrlDesk("Stellpult-Name")
