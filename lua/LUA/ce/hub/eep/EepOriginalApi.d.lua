---@meta

-- Automatisch erzeugt mit scripts/generate_eep_original_api.py aus Lua_manual.pdf

-- === EEPVer =======================================================================================================
---Liefert die Versionsnummer der installierten EEP-Version.
---@type number
EEPVer = 0
-- Verfuegbar ab EEP 10.2 - Plugin 2.
-- Beispielaufrufe:
--   if EEPVer >= 11 then
--   print("Zugbeeinflussung per Lua moeglich!")
--   end

-- === EEPTime ======================================================================================================
---Liefert die aktuelle Zeit in der EEP-Anlage. Der Wert entspricht den seit Mitternacht (EEP-Zeit) vergangenen
---Sekunden. Anmerkung: Die EEP-Zeit hinkt der realen Zeit pro Stunde ca. 100 Sekunden hinterher.
---@type number
EEPTime = 0
-- Verfuegbar ab EEP 10.2 - Plugin 2.
-- Beispielaufrufe:
--   if EEPTime == alteZeit + 50 then
--   print("Es sind genau 50 Sekunden vergangen")
--   alteZeit = EEPTime
--   elseif EEPTime > alte Zeit + 50 then
--   print("Es sind mehr als 50 Sekunden vergangen")
--   alteZeit = EEPTime
--   else
--   print("Es sind noch keine 50 Sek. vergangen")
--   end

-- === EEPTimeH =====================================================================================================
---Liefert den Stunden-Teil der EEP-Zeit, ausgedrueckt als Wert zwischen 0 und 23.
---@type number
EEPTimeH = 0
-- Verfuegbar ab EEP 10.2 - Plugin 2.
-- Beispielaufrufe:
--   print("Die Uhr hat "..EEPTimeH.." geschlagen!")

-- === EEPTimeM =====================================================================================================
---Liefert den Minuten-Teil der EEP-Zeit, ausgedrueckt als Wert zwischen 0 und 59.
---@type number
EEPTimeM = 0
-- Verfuegbar ab EEP 10.2 - Plugin 2.
-- Beispielaufrufe:
--   if EEPTimeM == 37 then
--   hole ICE325 aus Depot 2
--   EEPGetTrainFromTrainyard(, "#ICE325")
--   end

-- === EEPTimeS =====================================================================================================
---Liefert den Sekunden-Teil der EEP-Zeit, ausgedrueckt als Wert zwischen 0 und 59.
---@type number
EEPTimeS = 0
-- Verfuegbar ab EEP 10.2 - Plugin 2.
-- Beispielaufrufe:
--   if EEPTimeS == 15 then
--   schalte Ampel 1 auf Gruen
--   EEPSetSignal(1, 1)
--   elseif EEPTimeS == 45 then
--   schalte Ampel 1 auf Rot
--   EEPSetSignal(1 , 2)
--   end

-- === EEPLng =======================================================================================================
---Liefert das Kuerzel fuer die Sprache der installierten EEP-Version: GER = deutsche Version, ENG = englische
---Version, FRA = franzoesische Version.
---@type string
EEPLng = ""
-- Verfuegbar ab EEP 17.
-- Beispielaufrufe:
--   if EEPLng == "GER" then
--   print("Dies ist eine deutsche EEP-Version")
--   elseif EEPLng == "ENG" then
--   print("This is an English version of EEP")
--   elseif EEPLng == "FRA" then
--   print("Il s'agit d'une version francaise de l'EEP")
--   end

-- === clearlog() ===================================================================================================
---Loescht den Inhalt des Ereignisfensters
function clearlog() end

--       ==========
-- Verfuegbar ab EEP 10.2 - Plugin 2.
-- Bemerkungen:
--   Der Funktionsaufruf durch EEP erfolgt ohne Parameter.
-- Beispielaufrufe:
--   clearlog()

-- === print() ======================================================================================================
---Gibt das, was in den Klammern steht, im Ereignisfenster als Text aus.
---@param ... any Auszugebende Werte.
---@return any text rueckgabewert ist der komplette, ausgegebene String.
function print(...) end

--       ==========
-- Verfuegbar ab EEP 10.2 - Plugin 2.
-- Bemerkungen:
--   Alle Typen werden automatisch in Text umgewandelt.
--   Es koennen mehrere Parameter mitgegeben werden. Sie muessen durch ein Komma getrennt sein.
-- Beispielaufrufe:
--   print("Text1", "Text2", Variable, "TextN")
--   print("Es ist jetzt: ", EEPTimeH, ":", EEPTimeM, " Uhr")

-- === EEPMain() ====================================================================================================
---Wird zyklisch alle 200 Millisekunden, also fuenf Mal je Sekunde, von EEP aufgerufen. Geeignet fuer alle Aktionen,
---die regelmaessig ausgefuehrt werden sollen.
---@return number weiterlauf funktion muss eine Zahl ungleich Null zurueck liefern. Liefert die Funktion den Wert 0
--- zurueck, dann wird die Funktion nicht erneut aufgerufen. Alle anderen Funktionsaufrufe funktionieren weiterhin.
--- Fehlt der Rueckgabewert oder ist er keine Zahl, dann erfolgt eine Fehlermeldung und die Verbindung zu Lua wird
--- beendet.
function EEPMain() end

--       =========
-- Verfuegbar ab EEP 10.2 - Plugin 2.
-- Bemerkungen:
--   Muss im Skript deklariert sein, sonst stellt EEP die Verbindung zu Lua nicht her.
--   Der Funktionsaufruf durch EEP erfolgt ohne Parameter.
--   Die Funktion muss eine Zahl ungleich Null zurueck liefern.
--   Liefert die Funktion den Wert 0 zurueck, dann wird die Funktion nicht erneut aufgerufen. Alle anderen
--   Funktionsaufrufe funktionieren weiterhin.
--   Fehlt der Rueckgabewert oder ist er keine Zahl, dann erfolgt eine Fehlermeldung und die Verbindung zu Lua wird
--   beendet.
-- Beispielaufrufe:
--   EEPMain()
--   function EEPMain()
--   return 1
--   end

-- === EEPPause() ===================================================================================================
---Aktiviert und deaktiviert die Pause in EEP.
---@alias EEPPauseStatus
---| 0 # Betrieb weiter
---| 1 # Betrieb gestoppt, Lua laeuft weiter
---| 2 # Betrieb und Lua gestoppt
---@param pauseStatus EEPPauseStatus parameter bestimmt den Status der Pause.
---@return any pause rueckgabewert ist 0, wenn die Pause beendet oder 1, wenn sie aktiviert wurde.
function EEPPause(pauseStatus) end

--       =====================
-- Verfuegbar ab EEP 14 - Plugin 1.
-- Beispielaufrufe:
--   EEPPause(Status)
--   Status = 1
--   Pause = EEPPause(Status)
--   Pause = EEPPause(0)

-- === EEPSetTime() =================================================================================================
---Aendert die EEPZeit auf die gewuenschte Zeit.
---@param hour number parameter ist fuer die Stundenangabe.
---@param minute number parameter ist fuer die Minutenangabe.
---@param seconds number parameter ist fuer die Sekundenangabe.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false
function EEPSetTime(hour, minute, seconds) end

--       =================================
-- Verfuegbar ab EEP 15.
-- Bemerkungen:
--   Alle drei Parameter sind zwingend erforderlich.
-- Beispielaufrufe:
--   EEPSetTime(Stunde, Minute, Sekunde)
--   Stunde = 9
--   Minute = 15
--   Sekunde = 30
--   ok = EEPSetTime(Stunde, Minute, Sekunde)
--   ok = EEPSetTime(14, 35, 20)

-- === EEPGetFramesPerSecond() ======================================================================================
---Gibt die aktuelle Bildrate (fps) zurueck.
---@return number fps rueckgabewert ist die aktuelle Bildrate (Anzahl Bilder[Frames] pro Sekunde) als Zahl.
function EEPGetFramesPerSecond() end

--       =======================
-- Verfuegbar ab EEP 17.2 - Plugin 2.
-- Bemerkungen:
--   Der Funktionsaufruf durch EEP erfolgt ohne Parameter.
-- Beispielaufrufe:
--   EEPGetFramesPerSecond()
--   fps = EEPGetFramesPerSecond()

-- === EEPGetCurrentFrame() =========================================================================================
---Gibt den aktuellen Wert des Bildzaehlers seit Anlagenstart ohne die Bilder waehrend des Bearbeitungs- und
---Pausenmodus zurueck.
---@return number frameNummer rueckgabewert ist der aktuelle Wert des Bildzaehlers beginnend mit dem Laden der
--- Anlagendatei (.anl3) als Zahl, wobei allerdings die Bilder im Bearbeitungs- und Pausenmodus nicht mitgezaehlt
--- wurden.
function EEPGetCurrentFrame() end

--       ====================
-- Verfuegbar ab EEP 17.2 - Plugin 2.
-- Bemerkungen:
--   Der Funktionsaufruf durch EEP erfolgt ohne Parameter.
-- Beispielaufrufe:
--   EEPGetCurrentFrame()
--   FrameNummer = EEPGetCurrentFrame()

-- === EEPGetCurrentRenderFrame() ===================================================================================
---Gibt die Gesamtanzahl der gerenderten Bilder seit Anlagenstart zurueck und zwar inklusive der Bilder waehrend des
---Bearbeitungs- und Pausenmodus.
---@return number frameNummer rueckgabewert ist der aktuelle Wert des Bildzaehlers beginnend mit dem Laden der
--- Anlagendatei (.anl3) als Zahl, wobei die Bilder im Bearbeitungs- und Pausenmodus mitgezaehlt wurden.
function EEPGetCurrentRenderFrame() end

--       ==========================
-- Verfuegbar ab EEP 17.2 - Plugin 2.
-- Bemerkungen:
--   Der Funktionsaufruf durch EEP erfolgt ohne Parameter.
-- Beispielaufrufe:
--   EEPGetCurrentRenderFrame()
--   FrameNummer = EEPGetCurrentRenderFrame()

-- === EEPGetTimeLapse() ============================================================================================
---Gibt den aktuell in EEP eingestellten Zeitrafferfaktor zurueck.
---@return number zeitrafferfaktor rueckgabewert ist der aktuell in EEP eingestellte Zeitrafferfaktor 1, 5 oder 10
--- als Zahl.
function EEPGetTimeLapse() end

--       =================
-- Verfuegbar ab EEP 17.2 - Plugin 2.
-- Bemerkungen:
--   Der Funktionsaufruf durch EEP erfolgt ohne Parameter.
-- Beispielaufrufe:
--   EEPGetTimeLapse()
--   Zeitrafferfaktor = EEPGetTimeLapse()

-- === EEPSetColourFilter() =========================================================================================
---Diese Funktion dient nur zur voruebergehenden Einstellung der Farbparameter zum Beispiel nach einem Wechsel der
---Kameraaufnahme und nicht zur dauerhaften Aenderung der Programmeinstellungen.
---@param hue number parameter entspricht der Farbtoneinstellung in den Programmeinstellungen.
---@param saturation number parameter entspricht der Saettigungseinstellung in den Programmeinstellungen.
---@param brightness number parameter entspricht der Helligkeitseinstellung in den Programmeinstellungen.
---@param contrast number parameter entspricht der Kontrasteinstellung in den Programmeinstellungen.
function EEPSetColourFilter(hue, saturation, brightness, contrast) end

--       =========================================================
-- Verfuegbar ab EEP 17.3 - Plugin 3.
-- Bemerkungen:
--   Achtung: Die Parameter werden nicht in die Programmeinstellungen uebernommen.
--   Diese Funktion hat keinen Rueckgabewert.
-- Beispielaufrufe:
--   EEPSetColourFilter(Farbton, Saettigung, Helligkeit, Kontrast)
--   EEPSetColourFilter(-3, 0.83, 1.18, 1.19)

-- === EEPSetSignal() ===============================================================================================
---Schaltet ein Signal
---@overload fun(signalId: number, signalState: number): number
---@param signalId number parameter ist die Signal-ID.
---@param signalState number parameter ist die gewuenschte Signalstellung. Werte ab 1 aufwaerts schalten direkt die
--- korrespondierende Signalstellung. Der Wert 0 bewirkt, dass um eine Stellung weiter geschaltet wird. Ab EEP 14.1
--- Plugin 1 kann man mit einem negativen Wert auf die vorherige Stellung zurueckschalten. Bei Fahrstrassensignalen
--- entspricht die Stellung 1 "Aufloesen", die Stellung 2 "Fahrt" fuer die 1. Fahrstrasse sowie entsprechend die
--- Stellung n fuer die Fahrstrasse n-1.
---@param invokeCallback? number eine 1 als 3. (optionales) Parameter bewirkt, dass die fuer dieses Signal definierte
--- Funktion EEPOnSignal_x() aufgerufen wird. Hierzu muss das Signal fuer EEPOnSignal_x() registriert und die
--- Funktion definiert sein. Bitte mit Bedacht einsetzen! Es besteht die Gefahr, dass man sich bei unbedachtem
--- Einsatz Programmschleifen einhandelt, die EEP und Lua lahm legen.
---@return number ergebnis rueckgabewert ist 1, wenn das Signal und die gewuenschte Signalstellung existieren oder 0,
--- wenn eins von beidem nicht existiert.
function EEPSetSignal(signalId, signalState, invokeCallback) end

--       ===================================================
-- Verfuegbar ab EEP 10.2 - Plugin 2; EEP 14.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPSetSignal(Signal-ID, Stellung [, Rueckruf])
--   stell Signal 0023 auf 1
--   (kann Fahrt oder Halt sein)
--   Ergebnis = EEPSetSignal(23, 1)
--   stell Signal 0045 auf 1 und
--   ruf EEPOnSignal_45() auf
--   Ergebnis = EEPSetSignal(45, 1, 1)

-- === EEPGetSignal() ===============================================================================================
---Gibt die Stellung eines Signals bezogen auf die herrschende Zugbeeinflussung zurueck (s. letzte Bemerkung).
---@param signalId number parameter ist die ID des Signals, dessen Stellung man ermitteln moechte.
---@return number stellung rueckgabewert ist die Signalstellung. Die Nummer entspricht der Position dieser
--- Signalstellung in der Auswahlliste unter den Signaleigenschaften. Wenn das abgefragte Signal nicht existiert, ist
--- der Rueckgabewert 0. Bei Fahrstrassensignalen zeigen Rueckgabewerte groesser 1 an, welche (Wert - 1) vom Signal
--- ausgehende Fahrstrasse auf "Fahrt" steht (z.B. Wert = 4: die 3. Fahrstrasse).
function EEPGetSignal(signalId) end

--       ======================
-- Verfuegbar ab EEP 10.2 - Plugin 2.
-- Bemerkungen:
--   Achtung: Nach EEPSetSignal() liefert EEPGetSignal() fruehestens im naechsten Zyklus der EEPMain() die neue
--   Signalstellung.
--   Achtung: Bei einer im Signal eingestellten Aktivierungsverzoegerung wird die geaenderte "Signalstellung" erst
--   nach dessen Ablauf wiedergegeben. D.h., auch wenn z.B. das Signal bereits sichtbar Fahrt anzeigt, der Zug aber
--   noch durch die Aktivierungsverzoegerung am Signal "gehalten" wird, gibt die Funktion weiter Halt zurueck.
-- Beispielaufrufe:
--   EEPGetSignal(Signal-ID)
--   Stellung = EEPGetSignal(1)
--   if Stellung == 0 then
--   print("Signal 1 existiert nicht")
--   elseif Stellung == 1 then
--   print("Signal 1 steht auf Halt")
--   elseif Stellung == 2 then
--   print("Signal 1 steht auf Fahrt")
--   end
--   ACHTUNG: Bei aelteren Signalen kann Stellung
--   1 Fahrt und 2 Halt sein.

-- === EEPRegisterSignal() ==========================================================================================
---Registriert ein Signal fuer die Rueckruf(Callback)-Funktion EEPOnSignal_x() Diese notwendige Registrierung soll
---verhindern, dass Signale die Callback-Funktion aufrufen, fuer die keine entsprechende Funktion im Skript definiert
---wurde.
---@param signalId number parameter ist die Signal-ID.
---@return any ergebnis rueckgabewert ist 1, wenn das zu registrierende Signal existiert oder 0, wenn es nicht
--- existiert.
function EEPRegisterSignal(signalId) end

--       ===========================
-- Verfuegbar ab EEP 10.2 - Plugin 2.
-- Bemerkungen:
--   Die Registrierung eines Signals ist zwingend erforderlich, damit es bei Schaltvorgaengen selbstaendig die
--   Funktion EEPOnSignal_x() aufruft.
-- Beispielaufrufe:
--   EEPRegisterSignal(Signal-ID)
--   Ergebnis = EEPRegisterSignal(1)
--   function EEPOnSignal_1(Stellung)
--   print("Signal 1 auf "..Stellung.." gestellt")
--   end

-- === EEPOnSignal_x() ==============================================================================================
---Registrierte Signale rufen selbstaendig diese Funktion auf, wenn sich ihre Stellung durch einen Kontakt oder durch
---manuelle Bedienung (direkt oder in einer Verknuepfung) aendert. Im Skript definiert man die zugehoerige Funktion
---und legt so fest, was bei Aenderung der Signalstellung zu tun ist. Wichtig: Wird die Stellung dieses oder eines
---verknuepften Signals durch die Funktion EEPSetSignal() geaendert, so wird EEPOnSignal_x() nur dann aufgerufen,
---wenn der 3. Parameter "Rueckruf" der Funktion EEPSetSignal() auf 1 gesetzt ist.
---@param signalState number parameter ist die neue Signalstellung als Zahl, entsprechend der Position dieser
--- Signalstellung in der Auswahlliste der Signal-Eigenschaften. Eine selbst definierte Variable in den
--- Funktionsklammern nimmt diesen Wert fuer die weitere Verwendung auf.
function EEPOnSignal_x(signalState) end

--       ==========================
-- Verfuegbar ab EEP 10.2 - Plugin 2.
-- Bemerkungen:
--   Der Name der Funktion darf nicht mit _x enden, wie oben geschrieben, sondern muss mit der Signal-ID enden. Fuer
--   Signal 0012 muss die Funktion also EEPOnSignal_12() heissen! Bitte beachten: Die fuehrenden Nullen duerfen nicht
--   im Funktionsnamen stehen!
--   EEP erwartet bei Aufruf dieser Funktion keinen Rueckgabewert.
-- Beispielaufrufe:
--   EEPOnSignal_x(Stellung)
--   function EEPOnSignal_13(Stellung)
--   if Stellung > 1 then
--   EEPPlaySound("User/ZugFaehrtAb.wav")
--   end
--   EEPRegisterSignal(13) --zwingend erforderlich!

-- === EEPGetSignalTrainsCount() ====================================================================================
---Gibt die Anzahl "Fahrzeugverbaende" zurueck, welche vom spezifizierten Signal beeinflusst werden, d.h. vom
---Passieren des Vorsignals bis zur tatsaechlichen Abfahrt des Fahrzeugverbandes.
---@param signalId number parameter ist die Signal ID.
---@return number count rueckgabewert ist die Anzahl vom Signal gehaltener "Fahrzeugverbaende". Als 1
--- "Fahrzeugverband" gelten in EEP sowohl mehrere zu einer Einheit zusammengekoppelte Fahrzeuge (wie z.B. 1 Zug oder
--- 1 LKW mit Anhaenger) aber auch 1 einzelnes Fahrzeug.
function EEPGetSignalTrainsCount(signalId) end

--       =================================
-- Verfuegbar ab EEP 13.2 - Plugin 2.
-- Beispielaufrufe:
--   EEPGetSignalTrainsCount(Signal-ID)
--   Anzahl = EEPGetSignalTrainsCount(3)

-- === EEPGetSignalTrainName() ======================================================================================
---Gibt den Namen eines "Fahrzeugverband"s zurueck, welcher vom spezifizierten Signal beeinflusst wird, d.h. vom
---Passieren des Vorsignals bis zur tatsaechlichen Abfahrt des Fahrzeugverbandes.
---@param signalId number parameter ist die Signal ID.
---@param trainIndex number parameter ist die Positionsnummer des gewuenschten "Fahrzeugverband"es vor dem Signal.
--- Als 1 "Fahrzeugverband" gelten in EEP sowohl mehrere zu einer Einheit zusammengekoppelte Fahrzeuge (wie z.B. 1
--- Zug oder 1 LKW mit Anhaenger) aber auch 1 einzelnes Fahrzeug.
---@return string name rueckgabewert ist der Name des spezifizierten "Fahrzeugverband"s.
function EEPGetSignalTrainName(signalId, trainIndex) end

--       ===========================================
-- Verfuegbar ab EEP 13.2 - Plugin 2.
-- Beispielaufrufe:
--   EEPGetSignalTrainName(Signal-ID, Position)
--   Name = EEPGetSignalTrainName(3, 1)

-- === EEPOnTrainStoppedOnSignal() ==================================================================================
---Wird immer dann aufgerufen, wenn ein Fahrzeugverband an einem Signal haelt.
---@param signalId number parameter ist die ID des Signals, an dem der Fahrzeugverband haelt.
---@param trainName string parameter ist der Name des Fahrzeugverbands, der am Signal angehalten hat.
function EEPOnTrainStoppedOnSignal(signalId, trainName) end

--       ==============================================
-- Verfuegbar ab EEP 17.3 - Plugin 3.
-- Bemerkungen:
--   Die Parameternamen sind frei waehlbar.
--   EEP erwartet bei Aufruf dieser Funktion keinen Rueckgabewert.
-- Beispielaufrufe:
--   EEPOnTrainStoppedOnSignal(Signal-ID, "Zugname")
--   function EEPOnTrainStoppedOnSignal(sigID,zugname)
--   print("Zug ".. zugname.." hat am Signal "..sigID.. " gehalten.")
--   end

-- === EEPSetSignalStopDistance() ===================================================================================
---Aendert den Halteabstand eines Signals
---@param signalId number parameter ist die Signal-ID.
---@param stopDistance number parameter ist der gewuenschte Halteabstand in Meter. Bei Eingabe eines negativen Wertes
--- wird der Halteabstand auf null gesetzt.
---@return boolean ok rueckgabewert ist true, wenn das Signal existiert, oder false, wenn es nicht existiert.
function EEPSetSignalStopDistance(signalId, stopDistance) end

--       ================================================
-- Verfuegbar ab EEP 17.3 - Plugin 3.
-- Beispielaufrufe:
--   EEPSetSignalStopDistance(Signal-ID, Halteabstand)
--   ok = EEPSetSignalStopDistance(9, 45)

-- === EEPGetSignalStopDistance() ===================================================================================
---Ermittelt den Halteabstand eines Signals
---@param signalId number parameter ist die ID des Signals, dessen Halteabstand man ermitteln moechte.
---@return boolean ok rueckgabewert ist true, wenn das angesprochene Signal existiert, oder false, wenn es nicht
--- existiert.
---@return number halteabstand rueckgabewert ist der Halteabstand in Meter.
function EEPGetSignalStopDistance(signalId) end

--       ==================================
-- Verfuegbar ab EEP 17.3 - Plugin 3.
-- Bemerkungen:
--   Nach EEPSetSignalStopDistance() liefert EEPGetSignalSignalStopDistance() sofort den neuen Halteabstand.
-- Beispielaufrufe:
--   EEPGetSignalStopDistance(Signal-ID)
--   ok, Halteabstand = EEPGetSignalStopDistance(9)
--   print("Signal 9 hat einen Halteabstand von ", Halteabstand, " Meter.")

-- === EEPGetSignalFunctions() ======================================================================================
---Ermittelt die Anzahl der im NOS definierten Signal-Funktionen
---@param signalId number parameter ist die ID des Signals.
---@return boolean ok rueckgabewert ist true, wenn das angesprochene Signal existiert, oder false, wenn es nicht
--- existiert.
---@return number count rueckgabewert gibt die Anzahl der im NOS definierten Signal-Funktionen zurueck. Diese ist
--- identisch mit der Anzahl der Signalstellungen in der Auswahlbox in den Objekteigenschaften des Signals.
function EEPGetSignalFunctions(signalId) end

--       ===============================
-- Verfuegbar ab EEP 17.3 - Plugin 3.
-- Beispielaufrufe:
--   EEPGetSignalFunctions(Signal-ID)
--   ok, Anzahl = EEPGetSignalFunctions(14)

-- === EEPGetSignalFunction() =======================================================================================
---Gibt die vom Konstrukteur im NOS eingetragene Funktion fuer die angegebene Position in der Auswahlbox in den
---Objekteigenschaften des definierten Signals zurueck
---@param signalId number parameter ist die ID des Signals.
---@param selectionIndex number parameter ist die Position in der Auswahlbox in den Objekteigenschaften des
--- definierten Signals, zu der die im NOS definierte Funktion ermittelt werden soll.
---@return boolean ok rueckgabewert ist true, wenn das Signal und die gewuenschte Position existieren, oder false,
--- wenn eines von beiden nicht existiert.
---@return number funktion rueckgabewert ist die im NOS definierte Funktion. Hierbei bedeuten: 1 -> Fahrt 2 -> Halt
--- sowie, wenn das Signal ueber eine Geschwindigkeitsbeeinflussung verfuegt, z.B. 1025 -> Fahrt mit 25 km/h 1040 ->
--- Fahrt mit 40 km/h 1100 -> Fahrt mit 100 km/h je nach Konstruktion des Signals.
function EEPGetSignalFunction(signalId, selectionIndex) end

--       ==============================================
-- Verfuegbar ab EEP 17.3 - Plugin 3.
-- Bemerkungen:
--   Die Rueckgabewerte entsprechen den im NOS durch den Konstrukteur eingetragenen Werten.
-- Beispielaufrufe:
--   EEPGetSignalFunction(Signal-ID, Position)
--   ok, Funktion = EEPGetSignalFunction(14, 3)

-- === EEPGetSignalItemName() =======================================================================================
---Gibt den Modellnamen des Signals aus der ini-Datei oder den Namen der 3dm-Datei inklusive deren Pfad zurueck.
---@overload fun(signalId: number): boolean, string
---@param signalId number parameter ist die Signal ID.
---@param includeModelPath? boolean parameter ist optional und kann mit true oder false eingegeben werden. bei false
--- oder Nichtexistenz wird im 2. Rueckgabewert der Modellname aus der ini- Datei zurueckgegeben. bei true wird im 2.
--- Rueckgabewert der Pfad mit dem Namen der 3dm-Datei zurueckgegeben.
---@return boolean ok rueckgabewert ist true, wenn das Signal existiert, oder false, wenn es nicht existiert.
---@return string name rueckgabewert ist entweder der Modellname oder der Pfad mit dem Namen der 3dm-Datei des
--- spezifizierten Signals abhaengig vom optionalen 2. Parameter.
function EEPGetSignalItemName(signalId, includeModelPath) end

--       ================================================
-- Verfuegbar ab EEP 17.3 - Plugin 3.
-- Beispielaufrufe:
--   EEPGetSignalItemName(Signal-ID, [false | true])
--   ok, Name = EEPGetSignalItemName(3)
--   ok, Name = EEPGetSignalItemName(3, false)
--   Name => "Ks_Sig_A_Schirm (GK3)"
--   ok, Name = EEPGetSignalItemName(3, true)
--   Name => "Signale\Signale\KsSigASch_GK3.3dm"

-- === EEPCheckSetRoute() ===========================================================================================
---Ueberprueft, ob die Strecke einer Fahrstrasse vom Startsignal bis zum Ziel frei oder besetzt ist
---@param signalId number parameter ist die Signal-ID des Fahrstrassenstartsignals.
---@param routeTargetIndex number parameter ist die Zielnummer der Fahrstrasse, wie sie in den Objekteigenschaften
--- des Startsignals angegeben ist
---@return boolean ok rueckgabewert ist true, wenn die Strecke frei ist und damit die Fahrstrasse geschaltet werden
--- koennte, oder false, wenn die Strecke besetzt ist.
function EEPCheckSetRoute(signalId, routeTargetIndex) end

--       ============================================
-- Verfuegbar ab EEP 18.1 - Plugin 1.
-- Bemerkungen:
--   ACHTUNG: Denken Sie daran, falls Sie anschliessend die Fahrstrasse schalten, dass die Signalstellung in der
--   Funktion EEPSetSignal() 'Zielnummer + 1' ist, da Stellung 1 "Fahrstrasse aufloesen" bedeutet, und wenn
--   anschliessend die Rueckruffunktion EEPOnSignal_x() aufgerufen werden soll, als 3. Parameter eine 1 gesetzt
--   werden muss.
-- Beispielaufrufe:
--   EEPCheckSetRoute(FahrstrassenstartsignalID, Fahrstrassen-Zielnummer)
--   ok = EEPCheckSetRoute(33, 2)
--   if ok then
--   EEPSetSignal(33, 3, 1)
--   end

-- === EEPSetSwitch() ===============================================================================================
---Schaltet eine Weiche
---@overload fun(switchId: number, switchState: number): number
---@param switchId number parameter ist die Weichen-ID.
---@param switchState number parameter ist die gewuenschte Weichenstellung. Werte ab 1 aufwaerts schalten direkt die
--- korrespondierende Weichenstellung. Der Wert 0 bewirkt, dass um eine Stellung weiter geschaltet wird. Ab EEP 14.1
--- Plugin 1 kann man mit dem Wert -1 auf die vorherige Stellung zurueckschalten.
---@param invokeCallback? number eine 1 als 3. (optionales) Parameter bewirkt, dass die fuer diese Weiche definierte
--- Funktion EEPOnSwitch_x() aufgerufen wird. Die Weiche muss fuer EEPOnSwitch_x() registriert und die Funktion
--- definiert sein. Bitte mit Bedacht einsetzen! Es besteht die Gefahr, dass man sich bei unbedachtem Einsatz
--- Programmschleifen einhandelt, die EEP und Lua lahm legen.
---@return number ergebnis rueckgabewert ist 1, wenn die Weiche und die gewuenschte Weichenstellung existieren, oder
--- 0, wenn eins von beidem nicht existiert.
function EEPSetSwitch(switchId, switchState, invokeCallback) end

--       ===================================================
-- Verfuegbar ab EEP 10.2 - Plugin 2; EEP 14.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPSetSwitch(Weichen-ID, Stellung [, Rueckruf])
--   stell Weiche 0067 auf 1 (Fahrt)
--   Ergebnis = EEPSetSwitch(67, 1)
--   stell Weiche 0089 auf 2 (Abzweig) und ruf
--   EEPOnSwitch_89() auf
--   Ergebnis = EEPSetSwitch(89, 2, 1)

-- === EEPGetSwitch() ===============================================================================================
---Ermittelt die Stellung einer Weiche
---@param switchId number parameter ist die ID der Weiche, deren Stellung man ermitteln moechte.
---@return number weichenstellung rueckgabewert ist die Weichenstellung. Die Nummer entspricht der Position dieser
--- Weichenstellung in der Auswahlliste unter den Eigenschaften. Wenn die abgefragte Weiche nicht existiert, ist der
--- Rueckgabewert 0.
function EEPGetSwitch(switchId) end

--       ======================
-- Verfuegbar ab EEP 10.2 - Plugin 2.
-- Bemerkungen:
--   Achtung: Nach EEPSetSwitch() liefert EEPGetSwitch() fruehestens im naechsten Zyklus der EEPMain() die neue
--   Weichenstellung.
-- Beispielaufrufe:
--   EEPGetSwitch(Weichen-ID)
--   Weichenstellung = EEPGetSwitch(1)
--   if Weichenstellung == 0 then
--   print("Weiche 1 existiert nicht")
--   elseif Weichenstellung == 1 then
--   print("Weiche 1 steht auf Fahrt")
--   elseif Weichenstellung == 2 then
--   print("Weiche 1 steht auf Abzweig")
--   end

-- === EEPRegisterSwitch() ==========================================================================================
---Registriert eine Weiche fuer die Rueckruf(Callback)-Funktion EEPOnSwitch_x() Diese notwendige Registrierung soll
---verhindern, dass Weichen die Callback-Funktion aufrufen, fuer die keine entsprechende Funktion im Skript definiert
---wurde.
---@param switchId number parameter ist die ID der Weiche.
---@return any ergebnis rueckgabewert ist 1, wenn die zu registrierende Weiche existiert, oder 0, wenn sie nicht
--- existiert.
function EEPRegisterSwitch(switchId) end

--       ===========================
-- Verfuegbar ab EEP 10.2 - Plugin 2.
-- Bemerkungen:
--   Die Registrierung einer Weiche ist zwingend erforderlich, damit sie bei Schaltvorgaengen selbstaendig die
--   Funktion EEPOnSwitch_x() aufruft.
-- Beispielaufrufe:
--   EEPRegisterSwitch(Weichen-ID)
--   Ergebnis = EEPRegisterSwitch(3)
--   function EEPOnSwitch_3(Stellung)
--   print("Weiche 3 auf "..Stellung.." gestellt")
--   end

-- === EEPOnSwitch_x() ==============================================================================================
---Registrierte Weichen rufen selbstaendig diese Funktion auf, wenn sich ihre Stellung durch einen Kontakt oder durch
---manuelle Bedienung (direkt oder in einer Verknuepfung) aendert. Im Skript definiert man die zugehoerige Funktion
---und legt so fest, was bei Aenderung der Weichenstellung zu tun ist. Wichtig: Wird die Stellung dieser oder einer
---verknuepften Weiche durch die Funktion EEPSetSwitch() geaendert, so wird EEPOnSwitch_x() nur dann aufgerufen, wenn
---der 3. Parameter "Rueckruf" der Funktion EEPSetSwitch() auf 1 gesetzt ist.
---@param switchState number parameter ist die neue Weichenstellung als Zahl, entsprechend der Position dieser
--- Weichenstellung in der Auswahlliste der Eigenschaften. Eine selbst definierte Variable in den Funktionsklammern
--- nimmt diesen Wert fuer die weitere Verwendung auf.
function EEPOnSwitch_x(switchState) end

--       ==========================
-- Verfuegbar ab EEP 10.2 - Plugin 2.
-- Bemerkungen:
--   Der Name der Funktion darf nicht mit _x enden, wie oben geschrieben, sondern muss mit der Weichen-ID enden. Fuer
--   Weiche 0034 muss die Funktion also EEPOnSwitch_34() heissen! Bitte beachten: Die fuehrenden Nullen duerfen nicht
--   im Funktionsnamen stehen!
--   EEP erwartet bei Aufruf dieser Funktion keinen Rueckgabewert.
-- Beispielaufrufe:
--   EEPOnSwitch_x(Stellung)
--   function EEPOnSwitch_34(Stellung)
--   print("Weiche 34 auf "..Stellung.." gestellt")
--   end
--   EEPRegisterSwitch(34) -- zwingend erforderlich!

-- === EEPSaveData() ================================================================================================
---Speichert etwas in einem speziellen Speicherbereich ("Slot") ab. Wird automatisch zusammen mit der Anlage
---gespeichert und geladen
---@param storageSlot number parameter ist die Nummer des Speicherplatzes ("Slot")
---@param value number parameter ist der zu speichernde Inhalt. Mit nil kann der Speicher geloescht werden.
---@return boolean ok rueckgabewert ist true bei erfolgreicher Speicherung oder false bei Misserfolg.
function EEPSaveData(storageSlot, value) end

--       ===============================
-- Verfuegbar ab EEP 11.
-- Bemerkungen:
--   Es gibt 1000 Speicherplaetze ("Slots"), durchnummeriert von 1 bis 1000.
--   Man kann entweder Booleans, Zahlen oder Zeichenketten ("Strings") speichern. Fuer Zeichenketten stehen max. 999
--   Zeichen zur Verfuegung, wobei diese keine Formatierungszeichen enthalten duerfen.
--   Wenn die Anlage gespeichert wird, dann haengt EEP selbstaendig die Inhalte dieser Speicherplaetze an das
--   zugehoerige Lua-Skript an. Dieser Bereich ist bei geoeffneter EEP-Anlage in keinem Editor sichtbar, wohl aber
--   bei geschlossener EEP-Anlage in einem externen Editor und kann dann mit ihm bearbeitet werden.
-- Beispielaufrufe:
--   EEPSaveData(Speichernummer, Boolean|Zahl|"Zeichenkette"|nil)
--   speicher "wahr" in Speicher 1
--   ok = EEPSaveData(1 , true)
--   speicher die Zahl 42 in Speicher 2
--   ok = EEPSaveData(2 , 42)
--   speicher die Zeichenkette "Ich bin Speicher 3" in Speicher 3
--   ok = EEPSaveData(3 , "Ich bin Speicher 3")
--   loesche den Inhalt von Speicher 4
--   ok = EEPSaveData(4 , nil)

-- === EEPLoadData() ================================================================================================
---Laedt etwas aus einem speziellen Speicherbereich ("Slot"). Wird automatisch zusammen mit der Anlage gespeichert
---und geladen.
---@param storageSlot number parameter ist die Nummer des Speicherplatzes ("Slot").
---@return boolean ok rueckgabewert ist true, wenn der betroffene Speicher einen Inhalt hat oder false, wenn er leer
--- ist.
---@return boolean funktion rueckgabewert ist der Inhalt des Speichers. Warnung: Wenn der Slot noch nicht existiert
--- oder mit nil geloescht wurde, gibt die Funktion als 2. Rueckgabewert nicht (wie vielleicht zu erwarten) nil
--- zurueck sondern die Zahl 0. Fragt man nun unter Umgehung des 1. Rueckgabewertes den 2. Rueckgabewert direkt ueber
--- die allgemeine Lua-Funktion select() ab, kann es zu Logikproblemen kommen, denn Lua interpretiert nil (wie false)
--- als "falsch" jedoch die Zahl 0 (wie true) als "wahr".
function EEPLoadData(storageSlot) end

--       ========================
-- Verfuegbar ab EEP 11.
-- Bemerkungen:
--   Es gibt 1000 Speicherplaetze ("Slots"), durchnummeriert von 1 bis 1000.
--   Man kann entweder Zahlen oder Zeichenketten ("Strings") speichern Fuer Zeichenketten stehen max. 999 Zeichen zur
--   Verfuegung, wobei diese keine Formatierungszeichen enthalten duerfen.
--   Wenn die Anlage geladen wird, dann holt EEP selbstaendig alle Inhalte dieser Speicherplaetze aus dem Anhang des
--   Skripts. Damit koennen sie bei Bedarf durch Aufruf von EEPLoadData() abgefragt und Variablen zugewiesen werden.
--   Achtung: Nach EEPSaveData() liefert EEPLoadData() fruehestens im naechsten Zyklus der EEPMain() die neuen
--   Inhalt.
-- Beispielaufrufe:
--   EEPLoadData(Speichernummer)
--   ok, Inhalt = EEPLoadData(1)
--   if ok then
--   print("Speicher 1 enthaelt: "..Inhalt)
--   else
--   print("Speicher 1 ist leer")
--   end

-- === EEPSetTrainSpeed() ===========================================================================================
---Weist einem "Fahrzeugverband" (z.B. einem Zug) eine Geschwindigkeit zu.
---@overload fun(trainName: string, speed: number): boolean
---@param trainName string parameter ist der komplette Name des "Fahrzeugverbands" (mit vorangestelltem #-Zeichen)
--- als String.
---@param speed number parameter ist die Geschwindigkeit. Ein negativer Wert bewirkt Rueckwaertsfahrt.
---@param useTargetSpeed? boolean kann ein optionaler 3. Parameter mit true oder false bzw. 1 oder 0 eingegeben
--- werden. bei false oder 0 oder Nichtexistenz wird - wie auch vorher - eine neue Sollgeschwindigkeit zugewiesen,
--- wobei eine eventuelle Signalbeeinflussung aufgehoben wird (d.h. ein "Fahrzeugverband", der gegenwaertig durch ein
--- Signal aufgehalten wird, faehrt los). bei true oder 1 wird dem "Fahrzeugverband" eine "Reise"geschwindigkeit
--- zugewiesen, wobei eine Signalbeeinflussung bestehen bleibt (d.h. ein "Fahrzeugverband", der gegenwaertig durch
--- ein Signal aufgehalten wird, bleibt weiterhin stehen.)
---@return boolean ok rueckgabewert ist entweder true, wenn der angesprochene "Fahrzeugverband" existiert oder false,
--- wenn er nicht existiert. .
function EEPSetTrainSpeed(trainName, speed, useTargetSpeed) end

--       ==================================================
-- Verfuegbar ab EEP 11; EEP 17.2 - Plugin 2.
-- Beispielaufrufe:
--   EEPSetTrainSpeed("#Name", Geschwindigkeit [, false|true])
--   ok = EEPSetTrainSpeed("#Rheingold", 80)
--   ok = EEPSetTrainSpeed("#Rheingold", 80, false)
--   ok = EEPSetTrainSpeed("#Rheingold", 80, true)

-- === EEPGetTrainSpeed() ===========================================================================================
---Ermittelt die Geschwindigkeit eines Fahrzeugverbandes (z.B. eines Zuges).
---@overload fun(trainName: string): boolean, any
---@param trainName string parameter ist der komplette Name des "Fahrzeugverbands" (mit vorangestelltem #-Zeichen)
--- als String.
---@param useTargetSpeed? boolean kann ein optionaler 2. Parameter mit true oder false bzw. 1 oder. 0 eingegeben
--- werden. bei false oder 0 oder Nichtexistenz wird - wie auch vorher - die augenblickliche Ist-Geschwindigkeit
--- zurueckgegeben. bei true oder 1 wird die "Reise"geschwindigkeit zurueckgegeben, auch wenn er vor einem Signal
--- wartet! Aber WICHTIG zu wissen: Nach einem "Sanften Ankuppeln" betraegt auch die Reisegeschwindigkeit 0 km/h.
---@return boolean ok rueckgabewert ist entweder true, wenn der angesprochene "Fahrzeugverband" existiert oder false,
--- wenn er nicht existiert.
---@return any istGeschwindigkeit rueckgabewert ist die ermittelte Geschwindigkeit.
function EEPGetTrainSpeed(trainName, useTargetSpeed) end

--       ===========================================
-- Verfuegbar ab EEP 11; EEP 17.2 - Plugin 2.
-- Bemerkungen:
--   Achtung: Nach EEPSetTrainSpeed() liefert EEPGetTrainSpeed() fruehestens im naechsten Zyklus der EEPMain() den
--   neuen Wert.
-- Beispielaufrufe:
--   EEPGetTrainSpeed("#Name"[, false|true])
--   ok, IstGeschwindigkeit = EEPGetTrainSpeed("#VT98;001")
--   ok, IstGeschwindigkeit = EEPGetTrainSpeed("#VT98;001", false)
--   ok, ReiseGeschwindigkeit = EEPGetTrainSpeed("#VT98;001", true)

-- === EEPSetTrainRoute() ===========================================================================================
---Weist einem "Fahrzeugverband" (z.B. einem Zug) eine in EEP definierte Route zu.
---@param trainName string parameter ist der komplette Name des "Fahrzeugverbands" (mit vorangestelltem #-Zeichen)
--- als String.
---@param routeName string parameter ist die Route als String. Bitte beachten: Die Route muss vorher in EEP definiert
--- worden sein.
---@return boolean ok rueckgabewert ist entweder true, wenn der angesprochene "Fahrzeugverband" und die gewuenschte
--- Route existieren oder false, wenn eins von beidem nicht existiert.
function EEPSetTrainRoute(trainName, routeName) end

--       ======================================
-- Verfuegbar ab EEP 11.2 - Plugin 2.
-- Beispielaufrufe:
--   EEPSetTrainRoute("#Name", "Route")
--   ok = EEPSetTrainRoute("#Personenzug", "RB20")

-- === EEPGetTrainRoute() ===========================================================================================
---Ermittelt die Route eines Fahrzeugverbandes (z.B. eines Zuges).
---@param trainName string parameter ist der komplette Name des "Fahrzeugverbands" (mit vorangestelltem #-Zeichen)
--- als String.
---@return boolean ok rueckgabewert ist true, wenn der angesprochene "Fahrzeugverband" existiert oder false, wenn er
--- nicht existiert.
---@return string route rueckgabewert ist die ermittelte Route. Wurde dem Fahrzeugverband keine Route zugewiesen,
--- wird als Route "Alle" zurueckgegeben.
function EEPGetTrainRoute(trainName) end

--       ===========================
-- Verfuegbar ab EEP 11.2 - Plugin 2.
-- Bemerkungen:
--   Achtung: Nach EEPSetTrainRoute() liefert EEPGetTrainRoute() fruehestens im naechsten Zyklus der EEPMain() die
--   neuen Inhalt.
-- Beispielaufrufe:
--   EEPGetTrainRoute("#Name")
--   ok, Route = EEPGetTrainRoute("#Rheingold")

-- === EEPSetTrainLight() ===========================================================================================
---Schaltet an einem "Fahrzeugverband" (z.B. einem Zug) die Lichter sowie Blinker ein oder aus. Bitte beachten: Die
---Unterscheidung zwischen Licht und Blinker ist mit EEP 15 hinzugekommen. Ab EEP 16.3 Plugin 3 kann das automatische
---Aufleuchten der Bremsleuchten von Fahrzeugen bei einer Bremsung ein- oder ausgeschaltet werden. Die alte
---Schreibweise mit nur zwei Parametern ist weiterhin gueltig.
---@alias EEPTrainLightSource
---| 0 # Fahrlicht und Innenraumbeleuchtung
---| 1 # Linker Blinker
---| 2 # Rechter Blinker
---| 3 # Bremslicht-Automatik
---@overload fun(trainName: string, enabled: boolean): boolean
---@param trainName string parameter ist der komplette Name des "Fahrzeugverbands" (mit vorangestelltem #-Zeichen)
--- als String.
---@param enabled boolean parameter schaltet das Licht mit true ein oder mit false, aus.
---@param lightSource? EEPTrainLightSource optionaler Parameter definiert die Lichtquelle.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPSetTrainLight(trainName, enabled, lightSource) end

--       =================================================
-- Verfuegbar ab EEP 11.2 - Plugin 2; EEP 15; EEP 16.3 - Plugin 3.
-- Beispielaufrufe:
--   EEPSetTrainLight("#Name", true|false [, Quelle])
--   Licht ein
--   ok = EEPSetTrainLight("#Rheingold",true)
--   ok = EEPSetTrainLight("#Rheingold",true,0)
--   rechter Blinker aus
--   ok = EEPSetTrainLight("#Ford_Transit",false,2)
--   linker Blinker ein
--   ok = EEPSetTrainLight("#Ford_Transit",true,1)
--   Bremslicht aktiviert
--   ok = EEPSetTrainLight("#Ford_Transit",true,3)
--   Bremslicht deaktiviert
--   ok = EEPSetTrainLight("#Ford_Transit",false,3)

-- === EEPGetTrainLight() ===========================================================================================
---Ermittelt, ob bei einem "Fahrzeugverband" (z.B. einem Zug) die Lichter oder Blinker ein oder aus sind.
---@overload fun(trainName: string): boolean, boolean
---@param trainName string parameter ist der komplette Name des "Fahrzeugverbands" (mit vorangestelltem #-Zeichen)
--- als String.
---@param lightSource? EEPTrainLightSource optionaler Parameter definiert die Lichtquelle.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
---@return boolean brennt rueckgabewert ist true, wenn die spezifierte Lichtquelle brennt, sonst false.
function EEPGetTrainLight(trainName, lightSource) end

--       ========================================
-- Verfuegbar ab EEP 18.0.
-- Beispielaufrufe:
--   EEPGetTrainLight("#Name", [, Quelle])
--   ok, brennt = EEPGetTrainLight("#Rheingold")
--   ok, brennt = EEPGetTrainLight("#Rheingold",0)
--   ok, brennt = EEPGetTrainLight("#Ford_Transit",2)

-- === EEPSetTrainSmoke() ===========================================================================================
---Schaltet an einem "Fahrzeugverband" (z.B. einem Zug) den Rauch an oder aus.
---@param trainName string parameter ist der komplette Name des "Fahrzeugverbands" (mit vorangestelltem #-Zeichen)
--- als String.
---@param enabled boolean parameter schaltet den Rauch mit true an oder mit false aus.
---@return boolean ok rueckgabewert ist true, wenn der angesprochene "Fahrzeugverband" existiert, sonst false.
function EEPSetTrainSmoke(trainName, enabled) end

--       ====================================
-- Verfuegbar ab EEP 11.2 - Plugin 2.
-- Beispielaufrufe:
--   EEPSetTrainSmoke("#Name", true|false)
--   ok = EEPSetTrainSmoke("#Personenzug", true)

-- === EEPSetTrainHorn() ============================================================================================
---Laesst bei einem "Fahrzeugverband" (z.B. einem Zug) den Warnton (Pfeife, Hupe) ertoenen.
---@overload fun(trainName: string): boolean
---@param trainName string parameter ist der komplette Name des "Fahrzeugverbands" als String.
---@param enabled? boolean parameter ist true um den Warnton ertoenen zu lassen oder false um ihn abzustellen, bevor
--- er verklungen ist. Da true der Default-Wert ist, ertoent der Warnton auch, wenn der 2. Parameter weggelassen
--- wird.
---@return boolean ok rueckgabewert ist true, wenn der angesprochene "Fahrzeugverband" existiert, sonst false.
function EEPSetTrainHorn(trainName, enabled) end

--       ===================================
-- Verfuegbar ab EEP 11.2 - Plugin 2.
-- Beispielaufrufe:
--   EEPSetTrainHorn("#Name" [,true|false])
--   ok = EEPSetTrainHorn("#Personenzug")
--   ok = EEPSetTrainHorn("#Personenzug", true)
--   ok = EEPSetTrainHorn("#Personenzug", false)

-- === EEPSetTrainCouplingFront() ===================================================================================
---Schaltet bei einem "Fahrzeugverband" (z.B. einem Zug) die vordere Kupplung auf Kuppeln oder Abstossen.
---@param trainName string parameter ist der komplette Name des "Fahrzeugverbands" (mit vorangestelltem #-Zeichen)
--- als String.
---@param couple boolean parameter schaltet die vordere Kupplung mit true auf Kuppeln oder mit false auf Abstossen.
---@return boolean ok rueckgabewert ist true, wenn der angesprochene "Fahrzeugverband" existiert, sonst false.
function EEPSetTrainCouplingFront(trainName, couple) end

--       ===========================================
-- Verfuegbar ab EEP 11.2 - Plugin 2.
-- Beispielaufrufe:
--   EEPSetTrainCouplingFront("#Name", true|false)
--   ok = EEPSetTrainCouplingFront("#Gueterzug", true)

-- === EEPGetTrainCouplingFront() ===================================================================================
---Ermittelt bei einem "Fahrzeugverband" (z.B. einem Zug), ob die vordere Kupplung auf Kuppeln oder Abstossen
---gestellt ist.
---@alias EEPCouplingState
---| 1 # Kupplung scharf
---| 2 # Abstossen
---@param trainName string parameter ist der komplette Name des "Fahrzeugverbands" (mit vorangestelltem #-Zeichen)
--- als String.
---@return boolean ok rueckgabewert ist true, wenn der angesprochene "Fahrzeugverband" existiert, sonst false.
---@return EEPCouplingState stellung rueckgabewert ist die Stellung der vorderen Kupplung.
function EEPGetTrainCouplingFront(trainName) end

--       ===================================
-- Verfuegbar ab EEP 18.0.
-- Beispielaufrufe:
--   EEPGetTrainCouplingFront("#Name")
--   ok, Stellung = EEPSetTrainCouplingFront("#Gueterzug")

-- === EEPSetTrainCouplingRear() ====================================================================================
---Schaltet bei einem "Fahrzeugverband" (z.B. einem Zug) die hintere Kupplung auf Kuppeln oder Abstossen.
---@param trainName string parameter ist der komplette Name des "Fahrzeugverbands" (mit vorangestelltem #-Zeichen)
--- als String.
---@param couple boolean parameter schaltet die hintere Kupplung mit true auf Kuppeln oder mit false auf Abstossen.
---@return boolean ok rueckgabewert ist true, wenn der angesprochene "Fahrzeugverband" existiert, sonst false.
function EEPSetTrainCouplingRear(trainName, couple) end

--       ==========================================
-- Verfuegbar ab EEP 11.2 - Plugin 2.
-- Beispielaufrufe:
--   EEPSetTrainCouplingRear("#Name", true|false)
--   ok = EEPSetTrainCouplingRear("#Gueterzug", true)

-- === EEPGetTrainCouplingRear() ====================================================================================
---Ermittelt bei einem "Fahrzeugverband" (z.B. einem Zug), ob die hintere Kupplung auf Kuppeln oder Abstossen
---geschaltet ist.
---@param trainName string parameter ist der komplette Name des "Fahrzeugverbands" (mit vorangestelltem #-Zeichen)
--- als String.
---@return boolean ok rueckgabewert ist true, wenn der angesprochene "Fahrzeugverband" existiert, sonst false.
---@return EEPCouplingState stellung rueckgabewert ist die Stellung der hinteren Kupplung.
function EEPGetTrainCouplingRear(trainName) end

--       ==================================
-- Verfuegbar ab EEP 18.0.
-- Beispielaufrufe:
--   EEPGetTrainCouplingRear("#Name")
--   ok, Stellung = EEPGetTrainCouplingRear("#Gueterzug")

-- === EEPTrainLooseCoupling() ======================================================================================
---Trennt einen "Fahrzeugverband" (z.B. einen Zug) an der angegebenen Stelle.
---@overload fun(trainName: string, fromFront: boolean, rollingstockCount: number): boolean
---@param trainName string parameter ist der komplette Name des "Fahrzeugverbands" (mit vorangestelltem #-Zeichen)
--- als String.
---@param fromFront boolean parameter bestimmt, ob von vorne oder hinten (bezogen auf die Fahrtrichtung des Zuges)
--- gezaehlt wird: true = vorne, false = hinten
---@param rollingstockCount number parameter bestimmt die Anzahl an Rollmaterialien, die von vorne oder hinten
--- abgekuppelt werden sollen.
---@param detachedTrainName? string ueber den optionalen 4. Parameter kann diesem abgekoppelten Teil ein neuer Name
--- (String mit vorangestelltem #-Zeichen) gegeben werden. Tipp: Es empfiehlt sich also zuerst zu ueberlegen, welchem
--- spaeteren Zugteil man einen neuen Namen geben will und dann diesen mit den Parametern 2 und 3 zu definieren.
---@return boolean ok rueckgabewert ist true, wenn der angesprochene "Fahrzeugverband" existiert, sonst false.
function EEPTrainLooseCoupling(trainName, fromFront, rollingstockCount, detachedTrainName) end

--       =================================================================================
-- Verfuegbar ab EEP 11.2 - Plugin 2.
-- Beispielaufrufe:
--   EEPTrainLooseCoupling("#Name", true|false, Anzahl, "#Name2")
--   ok = EEPTrainLooseCoupling("#Gueterzug",true,3)
--   ok = EEPTrainLooseCoupling("#Gueterzug",false,2, "#Waggons")

-- === EEPOnTrainCoupling() =========================================================================================
---Wird immer dann aufgerufen, wenn zwei "Fahrzeugverbaende" gekoppelt werden.
---@param movingTrainName string parameter ist der Name des Teilverbands, der in Bewegung war und somit seine ID auf
--- den neuen "Fahrzeugverband" uebertragen hat. Sind beide Verbandsteile in Bewegung, dann zaehlt die schnellere von
--- beiden Bewegungen.
---@param standingTrainName string parameter ist der Name des Teilverbands, der stand (oder sich langsamer bewegt
--- hat) und somit seine ID verloren hat.
---@param combinedTrainName string parameter ist der Name des neu gebildeten "Fahrzeugverbands".
function EEPOnTrainCoupling(movingTrainName, standingTrainName, combinedTrainName) end

--       =========================================================================
-- Verfuegbar ab EEP 14.1 - Plugin 1.
-- Bemerkungen:
--   EEP erwartet bei Aufruf dieser Funktion keinen Rueckgabewert
-- Beispielaufrufe:
--   EEPOnTrainCoupling("Zug_A", "Zug_B", "Zug_neu")
--   function EEPOnTrainCoupling(Zug_A,Zug_B,Zug_neu)
--   print("Aus "..Zug_A.." und "..Zug_B.." wurde "..Zug_neu)
--   end

-- === EEPOnTrainLooseCoupling() ====================================================================================
---Wird immer dann aufgerufen, wenn ein "Fahrzeugverband" (z.B. ein Zug) geteilt wird.
---@param retainedTrainName string parameter ist der Name des Teilverbands, dessen Kupplung deaktiviert wurde. Dieser
--- Zugteil behaelt die ID des bisherigen "Fahrzeugverbands" bei.
---@param detachedTrainName string parameter ist der Name des Teilverbands, der abgekuppelt wurde. Dieser
--- Verbandsteil bekommt eine neue ID.
---@param originalTrainName string parameter ist der Name des urspruenglichen "Fahrzeugverbands".
function EEPOnTrainLooseCoupling(retainedTrainName, detachedTrainName, originalTrainName) end

--       ================================================================================
-- Verfuegbar ab EEP 14.1 - Plugin 1.
-- Bemerkungen:
--   EEP erwartet bei Aufruf dieser Funktion keinen Rueckgabewert
-- Beispielaufrufe:
--   EEPOnTrainLooseCoupling("Zug_A", "Zug_B", "Zug_alt")
--   function EEPOnTrainLooseCoupling(Zug_A, Zug_B, Zug_alt)
--   print(Zug_alt.." geteilt in "..Zug_A.." und "..Zug_B)
--   end

-- === EEPSetTrainHook() ============================================================================================
---Schaltet an einem "Fahrzeugverband" (z.B. einem Zug) den Haken fuer Gueter an oder aus.
---@param trainName string parameter ist der komplette Name des "Fahrzeugverbands" (mit vorangestelltem #-Zeichen)
--- als String.
---@param enabled boolean parameter schaltet den Haken mit true an oder mit false aus.
---@return boolean ok rueckgabewert ist true, wenn der angesprochene "Fahrzeugverband" existiert, sonst false.
function EEPSetTrainHook(trainName, enabled) end

--       ===================================
-- Verfuegbar ab EEP 11.2 - Plugin 2.
-- Beispielaufrufe:
--   EEPSetTrainHook("#Name", true|false)
--   ok = EEPSetTrainHook("#Kranzug" , true)

-- === EEPSetTrainHookGlue() ========================================================================================
---Beeinflusst das Verhalten von Guetern an einem Kranhaken eines "Fahrzeugverbands".
---@param trainName string parameter ist der komplette Name des "Fahrzeugverbands" (mit vorangestelltem #-Zeichen)
--- als String.
---@param fixedLoad boolean parameter bestimmt das Verhalten: false = Gueter schaukeln (geeignet fuer Haken), true =
--- Gueter sind fixiert (geeignet fuer Greifer).
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPSetTrainHookGlue(trainName, fixedLoad) end

--       =========================================
-- Verfuegbar ab EEP 11.2 - Plugin 2.
-- Beispielaufrufe:
--   EEPSetTrainHookGlue("#Name", true|false)
--   ok = EEPSetTrainHookGlue("#Kranzug", true)

-- === EEPSetTrainAxis() ============================================================================================
---Animiert bei einem "Fahrzeugverband" (z.B. einem Zug) eine oder mehrere ausgewaehlte Achsen.
---@overload fun(trainName: string, axisName: string, axisPosition: number): boolean
---@param trainName string parameter ist der komplette Name des "Fahrzeugverbands" (mit vorangestelltem #-Zeichen)
--- als String.
---@param axisName string parameter ist der Name der Achse als String.
---@param axisPosition number parameter ist die Position, zu der sich die Achse bewegen soll.
---@param useNameFilter? boolean kann ein 4. (optionaler) Parameter mit true oder false eingegeben werden. bei true
--- dient der als 2. Parameter eingetragene Begriff als Filter fuer alle Achsennamen, die mit dem Filterfragment
--- beginnen. Wird z.B., als 2. Parameter "Domdeckel" eingegeben, so setzt die Funktion die Achsen "Domdeckel 1", "
--- Domdeckel 2", " Domdeckel 3", usw. (wenn sie existieren) auf die als 3. Parameter eingegebene Position. bei false
--- oder wenn der 4. Parameter nicht existiert, muss als 2. Parameter immer der vollstaendige Achsenname eingetragen
--- werden.
---@return boolean ok rueckgabewert ist true, wenn der angesprochene Zug und die angesprochene Achse existieren, oder
--- false, wenn eins von beidem nicht existiert.
function EEPSetTrainAxis(trainName, axisName, axisPosition, useNameFilter) end

--       =================================================================
-- Verfuegbar ab EEP 11.2 - Plugin 2; EEP 17.2.
-- Beispielaufrufe:
--   EEPSetTrainAxis("#Name", "Achse", Position [, true|false])
--   ok = EEPSetTrainAxis("#Kranzug", "Ausleger heben/senken", 100)
--   ok = EEPSetTrainAxis("#Staubgutzug", "Domdeckel", 100, true)

-- === EEPSetTrainName() ============================================================================================
---Weist einem "Fahrzeugverband" (z.B. einem Zug) einen neuen Namen zu.
---@param trainName string parameter ist der bisherige Name des "Fahrzeugverbands" (mit vorangestelltem #-Zeichen)
--- als String.
---@param newTrainName string parameter ist der neue Name des "Fahrzeugverbands" (mit vorangestelltem #-Zeichen) als
--- String.
---@return boolean ok rueckgabewert ist true, wenn die Funktion erfolgreich ausgefuehrt wurde, sonst false
function EEPSetTrainName(trainName, newTrainName) end

--       ========================================
-- Verfuegbar ab EEP 14.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPSetTrainName("#AlterName", "#NeuerName")
--   ok = EEPSetTrainName("#RE 1", "#RE 5")

-- === EEPGetTrainLength() ==========================================================================================
---Ermittelt die Gesamtlaenge des angegebenen Fahrzeugverbandes (z.B. eines Zuges).
---@param trainName string parameter ist der komplette Name des "Fahrzeugverbands" (mit vorangestelltem #-Zeichen)
--- als String.
---@return boolean ok rueckgabewert ist entweder true, wenn der angegebene "Fahrzeugverband" existiert, oder false,
--- wenn er nicht existiert.
---@return number laenge rueckgabewert ist die Laenge des "Fahrzeugverbands" in Meter.
function EEPGetTrainLength(trainName) end

--       ============================
-- Verfuegbar ab EEP 15.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPGetTrainLength("#Name")
--   ok, Laenge = EEPGetTrainLength("#Gueterzug")

-- === EEPTrainChangeOrientation() ==================================================================================
---Dreht die Ausrichtung und die Fahrtrichtung eines "Fahrzeugverbands" (z.B. eines Zug).
---@param trainName string parameter ist der komplette Name des "Fahrzeugverbands" (mit vorangestelltem #-Zeichen)
--- als String.
---@return boolean ok rueckgabewert ist true, wenn der angesprochene "Fahrzeugverband" existiert und die Funktion
--- erfolgreich ausgefuehrt wurde, sonst false.
function EEPTrainChangeOrientation(trainName) end

--       ====================================
-- Verfuegbar ab EEP 18.0.
-- Bemerkungen:
--   Hinweis: Die Drehung des Fahrzeugverbandes erfolgt auch, wenn er sich in Fahrt befindet, aber nicht in einem
--   virtuellen Depot.
-- Beispielaufrufe:
--   EEPTrainChangeOrientation("#Name")
--   ok = EEPTrainChangeOrientation("#Gueterzug")

-- === EEPRollingstockSetCouplingFront() ============================================================================
---Stellt die vordere Kupplung eines Rollmaterials um.
---@param rollingstockName string parameter ist der komplette Name des Rollmaterials als String.
---@param couplingState EEPCouplingState parameter ist der gewuenschte Kupplungszustand.
---@return boolean ok rueckgabewert ist entweder true, wenn das angesprochene Rollmaterial existiert oder false, wenn
--- es nicht existiert.
function EEPRollingstockSetCouplingFront(rollingstockName, couplingState) end

--       ================================================================
-- Verfuegbar ab EEP 11.0.
-- Beispielaufrufe:
--   EEPRollingstockSetCouplingFront("Fahrzeugname", Kupplungszustand)
--   ok = EEPRollingstockSetCouplingFront("Castor 1;001",1)

-- === EEPRollingstockGetCouplingFront() ============================================================================
---Ermittelt die Stellung der vorderen Kupplung eines Rollmaterials.
---@alias EEPRollingstockCouplingStatus
---| 1 # Kupplung scharf
---| 2 # Abstossen
---| 3 # Gekuppelt
---@param rollingstockName string parameter ist der komplette Name des Rollmaterials als String.
---@return boolean ok rueckgabewert ist entweder true, wenn das angesprochene Rollmaterial existiert oder false, wenn
--- es nicht existiert.
---@return EEPRollingstockCouplingStatus kupplung rueckgabewert ist die Stellung der Kupplung.
function EEPRollingstockGetCouplingFront(rollingstockName) end

--       =================================================
-- Verfuegbar ab EEP 11.0.
-- Beispielaufrufe:
--   EEPRollingstockGetCouplingFront("Fahrzeugname")
--   ok, Kupplung = EEPRollingstockGetCouplingFront("Castor 1;001")

-- === EEPRollingstockSetCouplingRear() =============================================================================
---Stellt die hintere Kupplung eines Rollmaterials um.
---@param rollingstockName string parameter ist der komplette Name des Rollmaterials als String.
---@param couplingState EEPCouplingState parameter ist der gewuenschte Kupplungszustand.
---@return boolean ok rueckgabewert ist entweder true, wenn das angesprochene Rollmaterial existiert oder false, wenn
--- es nicht existiert.
function EEPRollingstockSetCouplingRear(rollingstockName, couplingState) end

--       ===============================================================
-- Verfuegbar ab EEP 11.0.
-- Beispielaufrufe:
--   EEPRollingstockSetCouplingRear("Fahrzeugname", Kupplungszustand)
--   ok = EEPRollingstockSetCouplingRear("fals 175 Kalk", 1)

-- === EEPRollingstockGetCouplingRear() =============================================================================
---Ermittelt die Stellung der hinteren Kupplung eines Rollmaterials.
---@param rollingstockName string parameter ist der komplette Name des Rollmaterials als String.
---@return boolean ok rueckgabewert ist entweder true, wenn das angesprochene Rollmaterial existiert oder false, wenn
--- es nicht existiert.
---@return EEPRollingstockCouplingStatus kupplung rueckgabewert ist die Stellung der Kupplung.
function EEPRollingstockGetCouplingRear(rollingstockName) end

--       ================================================
-- Verfuegbar ab EEP 11.0.
-- Beispielaufrufe:
--   EEPRollingstockGetCouplingRear("Fahrzeugname")
--   ok, Kupplung = EEPRollingstockGetCouplingRear("fals 175 Kalk")

-- === EEPRollingstockSetAxis() =====================================================================================
---Bewegt die mittels Achsname benannte Achse des benannten Rollmaterials in eine gewuenschte Position.
---@overload fun(rollingstockName: string, axisName: string, axisPosition: number): boolean
---@param rollingstockName string parameter ist der komplette Name des Rollmaterials als String.
---@param axisName string parameter ist der komplette Name der zu bewegenden Achse als String. Er kann in diversen
--- EEP-Sprachversionen unterschiedlich sein.
---@param axisPosition number parameter ist die Position, zu der sich die Achse bewegen soll.
---@param useNameFilter? boolean kann ein 4. (optionaler) Parameter mit true oder false eingegeben werden. bei true
--- dient der als 2. Parameter eingetragene Begriff als Filter fuer alle Achsennamen, die mit dem Filterfragment
--- beginnen. Wird z.B., als 2. Parameter "Stromabnehmer" eingegeben, so setzt die Funktion z.B. die Achsen
--- "Stromabnehmer CH", "Stromabnehmer DE", "Stromabnehmer IT", usw. (wenn sie existieren) auf die als 3. Parameter
--- eingegebene Position. bei false oder wenn der 4. Parameter nicht existiert, muss als 2. Parameter immer der
--- vollstaendige Achsenname eingetragen werden.
---@return boolean ok rueckgabewert ist true, wenn Rollmaterial und Achse existieren oder false, falls mindestens
--- eins von beidem nicht existiert.
function EEPRollingstockSetAxis(rollingstockName, axisName, axisPosition, useNameFilter) end

--       ===============================================================================
-- Verfuegbar ab EEP 11.0; EEP 17.2 - Plugin 2.
-- Beispielaufrufe:
--   EEPRollingstockSetAxis("Fahrzeugname", "Achse", Position [, true|false])
--   ok = EEPRollingstockSetAxis("Dispolok 189-917 EpVI", "Stromabnehmer DE", 100)
--   ok = EEPRollingstockSetAxis("Dispolok 189-917 EpVI", "Stromabnehmer", 0, true)

-- === EEPRollingstockGetAxis() =====================================================================================
---Ermittelt die aktuelle Position einer mittels Achsnamen benannten Achse des benannten Rollmaterials.
---@param rollingstockName string parameter ist der komplette Name des Rollmaterials als String.
---@param axisName string parameter ist der komplette Name der Achse als String. Er kann in diversen
--- EEP-Sprachversionen unterschiedlich sein.
---@return boolean ok rueckgabewert ist true, wenn Rollmaterial und Achse existieren oder false, falls mindestens
--- eins von beidem nicht existiert.
---@return number position rueckgabewert ist die momentane Position der Achse als Zahl.
function EEPRollingstockGetAxis(rollingstockName, axisName) end

--       ==================================================
-- Verfuegbar ab EEP 11.0.
-- Beispielaufrufe:
--   EEPRollingstockGetAxis("Fahrzeugname", "Achse")
--   Name = ("Dispolok 189-917 EpVI"
--   Achse = "Stromabnehmer DE"
--   ok, Position = EEPRollingstockGetAxis(Name, Achse)

-- === EEPRollingstockSetAxisByNumber() =============================================================================
---Bewegt die mittels Achsnummer benannte Achse des benannten Rollmaterials in eine gewuenschte Position.
---@param rollingstockName string parameter ist der komplette Name des Rollmaterials als String.
---@param axisNumber number parameter ist die Achsnummer der zu bewegenden Achse als Zahl. Sie ist in allen
--- EEP-Sprachversionen gleich und steht sowohl in der ini-Datei als auch im Modellkatalog bei den Achsbezeichnungen
--- des Modells.
---@param axisPosition number parameter ist die Position, zu der sich die Achse bewegen soll.
---@return boolean ok rueckgabewert ist true, wenn Rollmaterial und die Achsnummer existieren oder false, falls
--- mindestens eins von beidem nicht existiert.
function EEPRollingstockSetAxisByNumber(rollingstockName, axisNumber, axisPosition) end

--       ==========================================================================
-- Verfuegbar ab EEP 18.0.
-- Beispielaufrufe:
--   EEPRollingstockSetAxisByNumber("Fahrzeugname", Achsnummer, Position)
--   ok = EEPRollingstockSetAxisByNumber("Dispolok 189-917 EpVI", 26, 100)

-- === EEPRollingstockGetAxisByNumber() =============================================================================
---Ermittelt die aktuelle Position einer mittels Achsnummer benannten Achse des benannten Rollmaterials.
---@param rollingstockName string parameter ist der komplette Name des Rollmaterials als String.
---@param axisNumber number parameter ist die Achsnummer der zu bewegenden Achse als Zahl. Sie ist in allen
--- EEP-Sprachversionen gleich und steht sowohl in der ini-Datei als auch im Modellkatalog bei den Achsbezeichnungen
--- des Modells.
---@return boolean ok rueckgabewert ist true, wenn Rollmaterial und die Achsnummer existieren oder false, falls
--- mindestens eins von beidem nicht existiert.
---@return number position rueckgabewert ist die momentane Position der Achse als Zahl.
function EEPRollingstockGetAxisByNumber(rollingstockName, axisNumber) end

--       ============================================================
-- Verfuegbar ab EEP 18.0.
-- Beispielaufrufe:
--   EEPRollingstockGetAxisByNumber("Fahrzeugname", Achsnummer)
--   Name = "Dispolok 189-917 EpVI"
--   ok, Position = EEPRollingstockGetAxisByNumber(Name, 26)

-- === EEPRollingstockSetSlot() =====================================================================================
---Bewegt alle Achsen des genannten Rollmaterials zu den in der definierten Einstellungsgruppe fuer Achseinstellungen
---gespeicherten Positionen
---@param rollingstockName string parameter ist der komplette Name des Rollmaterials als String.
---@param axisGroup number parameter ist die ID (ohne #-Zeichen) der Einstellungsgruppe, in der die gewuenschten
--- Achsenstellungen gespeichert sind.
---@return boolean ok rueckgabewert ist true, wenn das Rollmaterial und die Gruppennummer existieren oder false, wenn
--- mindestens eins von beidem nicht existiert. Es wird nicht geprueft, ob in der Gruppe tatsaechlich etwas
--- gespeichert ist.
function EEPRollingstockSetSlot(rollingstockName, axisGroup) end

--       ===================================================
-- Verfuegbar ab EEP 11.0.
-- Bemerkungen:
--   Es ist notwendig, zunaechst alle Achsen auf die gewuenschte Position zu setzen und diesen Zustand in einer der
--   16 fuer jedes Fahrzeug verfuegbaren Achsengruppen zu speichern (Kontextmenue). Wenn diese Funktion dann spaeter
--   ausgefuehrt wird, fahren alle Achsen von ihrer aktuellen Position auf die in der entsprechenden Achsengruppe
--   (Slot) gespeicherte Position.
-- Beispielaufrufe:
--   EEPRollingstockSetSlot("Fahrzeugname", Achsengruppe)
--   ok = EEPRollingstockSetSlot("Ladekran2 Greifer", 3)

-- === EEPGetRollingstockItemsCount() ===============================================================================
---Gibt die Anzahl der Fahrzeuge in einem "Fahrzeugverband" (z.B. einem Zug) zurueck
---@param trainName string parameter ist der komplette Name des "Fahrzeugverbands" (mit vorangestelltem #-Zeichen)
--- als String.
---@return number count rueckgabewert ist die Anzahl der Fahrzeuge, aus denen der "Fahrzeugverband" besteht. Zwischen
--- Loks, Tendern, Waggons und Spezialteilen wie zwischengekoppelten Drehgestellen wird nicht unterschieden. Wenn der
--- genannte "Fahrzeugverband" nicht existiert, dann ist der Wert 0.
function EEPGetRollingstockItemsCount(trainName) end

--       =======================================
-- Verfuegbar ab EEP 13.2 - Plugin 2.
-- Beispielaufrufe:
--   EEPGetRollingstockItemsCount("#Name")
--   Anzahl = EEPGetRollingstockItemsCount("#Gueterzug")

-- === EEPGetRollingstockItemName() =================================================================================
---Gibt den Namen eines Fahrzeugs im "Fahrzeugverband" (z.B. einem Zug) zurueck
---@param trainName string parameter ist der komplette Name des "Fahrzeugverbands" (mit vorangestelltem #-Zeichen)
--- als String.
---@param vehicleIndex string parameter ist die Positionsnummer des Fahrzeugs im Verband, dessen Namen man erfahren
--- moechte. Bitte beachten: Das erste Fahrzeug hat die Nummer 0
---@return string name rueckgabewert ist der Fahrzeugname. Wenn der "Fahrzeugverband" oder das Fahrzeug im
--- "Fahrzeugverband" nicht existieren, gibt EEP einen Leerstring zurueck.
function EEPGetRollingstockItemName(trainName, vehicleIndex) end

--       ===================================================
-- Verfuegbar ab EEP 13.2 - Plugin 2.
-- Beispielaufrufe:
--   EEPGetRollingstockItemName("#Name", Nummer)
--   Name = EEPGetRollingstockItemName("#Gueterzug", 3)

-- === EEPRollingstockGetTrainName() ================================================================================
---Ermittelt den Namen des "Fahrzeugverbands", in dem das angegebene Fahrzeug mitgefuehrt wird.
---@param rollingstockName string parameter ist der Name des Fahrzeugs als String.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
---@return string name rueckgabewert ist der Name des Fahrzeugverbandes (z.B. der "Name").
function EEPRollingstockGetTrainName(rollingstockName) end

--       =============================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
--   EEPRollingstockGetTrainName("Fahrzeugname")
--   ok, Name = EEPRollingstockGetTrainName("Castor 1")

-- === EEPRollingstockGetLength() ===================================================================================
---Ermittelt die Laenge des angegebenen Fahrzeugs.
---@param rollingstockName string parameter ist der Name des Fahrzeugs als String.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
---@return number laenge rueckgabewert ist die Laenge des Fahrzeugs von Kupplung zu Kupplung in Metern.
function EEPRollingstockGetLength(rollingstockName) end

--       ==========================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
--   EEPRollingstockGetLength("Fahrzeugame")
--   ok, Laenge = EEPRollingstockGetLength("Container 0100")

-- === EEPRollingstockGetMotor() ====================================================================================
---Ermittelt die Anzahl der Getriebegaenge des angegebenen Fahrzeugs und damit indirekt ob das Fahrzeug motorisiert
---ist.
---@param rollingstockName string parameter ist der Name des Fahrzeugs als String.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
---@return number gaenge rueckgabewert ist die Anzahl der Getriebegaenge, die das Fahrzeug besitzt. Nicht
--- motorisierte Fahrzeuge haben 0 Gaenge.
function EEPRollingstockGetMotor(rollingstockName) end

--       =========================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
--   EEPRollingstockGetMotor("Fahrzeugname")
--   ok, Gaenge = EEPRollingstockGetMotor("DB_360_339")

-- === EEPRollingstockGetTrack() ====================================================================================
---Ermittelt die aktuelle Position des angegebenen Fahrzeugs auf der Anlage.
---@alias EEPRollingstockTrackDirection
---| 1 # In Fahrtrichtung
---| 0 # Entgegen der Fahrtrichtung

---@alias EEPTrackSystem
---| 1 # Bahngleise
---| 2 # Strassen
---| 3 # Tramgleise
---| 4 # Sonstige Splines oder Wasserwege
---@param rollingstockName string parameter ist der Name des Fahrzeugs als String.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
---@return number gleis_ID rueckgabewert ist die ID des Gleisstuecks, auf dem sich das Fahrzeug befindet.
---@return number position rueckgabewert ist der Abstand (in Metern) zum Anfang des Gleisstuecks, auf dem sich das
--- Fahrzeug befindet.
---@return EEPRollingstockTrackDirection richtung rueckgabewert ist die Ausrichtung relativ zur Fahrtrichtung des
--- Gleisstuecks.
---@return EEPTrackSystem system rueckgabewert ist die Nummer des Gleissystems.
function EEPRollingstockGetTrack(rollingstockName) end

--       =========================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
--   EEPRollingstockGetTrack("Fahrzeugname")
--   ok, Gleis_ID, Position, Richtung, System = EEPRollingstockGetTrack("BR 212 376-8")

-- === EEPRollingstockGetModelType() ================================================================================
---Ermittelt die Kategorie, zu welcher das genannte Fahrzeug gehoert.
---@alias EEPRollingstockModelType
---| 1 # Tenderlok
---| 2 # Schlepptenderlok
---| 3 # Tender
---| 4 # Elektrolok
---| 5 # Diesellok
---| 6 # Triebwagen
---| 7 # U- oder S-Bahn
---| 8 # Strassenbahn
---| 9 # Gueterwaggon
---| 10 # Personenwaggon
---| 11 # Luftfahrzeug
---| 12 # Maschine
---| 13 # Wasserfahrzeug
---| 14 # LKW
---| 15 # PKW
---@param rollingstockName string parameter ist der Fahrzeugname als String.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
---@return EEPRollingstockModelType typ rueckgabewert ist die Modellkategorie.
function EEPRollingstockGetModelType(rollingstockName) end

--       =============================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
--   EEPRollingstockGetModelType("Fahrzeugname")
--   ok, Typ = EEPRollingstockGetModelType("Castor 1")

-- === EEPRollingstockChangeOrientation() ===========================================================================
---Dreht die Ausrichtung des angegebenen Fahrzeugs in einem "Fahrzeugverband" (z.B. einem Zug).
---@param rollingstockName string parameter ist der komplette Name des Fahrzeugs als String.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPRollingstockChangeOrientation(rollingstockName) end

--       ==================================================
-- Verfuegbar ab EEP 18.0.
-- Bemerkungen:
--   Hinweis: Die Drehung des Fahrzeugs erfolgt auch waehrend der Fahrt in einem Fahrzeugverband
-- Beispielaufrufe:
--   EEPRollingstockChangeOrientation("Fahrzeug- name")
--   ok, = EEPRollingstockChangeOrientation("DB Gbrs")

-- === EEPRollingstockGetOrientation() ==============================================================================
---Ermittelt, welche relative Ausrichtung das angegebene Fahrzeug im "Fahrzeugverband" hat.
---@param rollingstockName string parameter ist der komplette Name des Fahrzeugs als String.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
---@return boolean vorwaerts rueckgabewert ist true, wenn das angegebene Fahrzeug vorwaerts ausgerichtet ist, sonst
--- false.
function EEPRollingstockGetOrientation(rollingstockName) end

--       ===============================================
-- Verfuegbar ab EEP 15.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPRollingstockGetOrientation("Fahrzeugname")
--   ok, vorwaerts = EEPRollingstockGetOrientation("DB Gbrs")

-- === EEPRollingstockSetHook() =====================================================================================
---Schaltet bei einem bestimmten Rollmaterial den Haken an oder aus.
---@param rollingstockName string parameter ist der komplette Name des Rollmaterials als String.
---@param enabled boolean parameter schaltet den Haken mit true an oder mit false aus.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPRollingstockSetHook(rollingstockName, enabled) end

--       =================================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPRollingstockSetHook("Fahrzeugname", true|false)
--   ok = EEPRollingstockSetHook("Schienenkran DB EDK 300/5", true)

-- === EEPRollingstockGetHook() =====================================================================================
---Ermittelt, ob der Haken eines bestimmten Rollmaterials an oder ausgeschaltet ist.
---@alias EEPRollingstockHookStatus
---| 0 # Ausgeschaltet
---| 1 # Eingeschaltet
---| 3 # Ladegut am Haken
---@param rollingstockName string parameter ist der komplette Name des Rollmaterials als String.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
---@return EEPRollingstockHookStatus status rueckgabewert gibt den Status des Hakens an.
function EEPRollingstockGetHook(rollingstockName) end

--       ========================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPRollingstockGetHook("Fahrzeugname")
--   ok, Status = EEPRollingstockGetHook("Schienenkran DB EDK 300/5")

-- === EEPRollingstockSetHookGlue() =================================================================================
---Beeinflusst das Verhalten von Guetern an einem Kranhaken eines Rollmaterials.
---@param rollingstockName string parameter ist der Name des Rollmaterials als String.
---@param fixedLoad boolean parameter bestimmt das Verhalten. false = Gueter schaukeln (geeignet fuer Haken) true =
--- Gueter sind fixiert (geeignet fuer Greifer)
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPRollingstockSetHookGlue(rollingstockName, fixedLoad) end

--       =======================================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPRollingstockSetHookGlue("Fahrzeugname", true|false)
--   ok = EEPRollingstockSetHookGlue("Schienenkran DB EDK 300/5", true)

-- === EEPRollingstockGetHookGlue() =================================================================================
---Ermittelt das Verhalten von Guetern am Kranhaken eines Rollmaterials
---@alias EEPHookGlueMode
---| 0 # Gueter schaukeln
---| 1 # Gueter sind fixiert
---@param rollingstockName string parameter ist der komplette Name des Rollmaterials als String.
---@return EEPHookGlueMode ok rueckgabewert gibt das Verhalten der Gueter an.
function EEPRollingstockGetHookGlue(rollingstockName) end

--       ============================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPRollingstockGetHookGlue("Fahrzeugname")
--   ok = EEPRollingstockGetHookGlue("Schienenkran DB EDK 300/5")

-- === EEPRollingstockGetHookPosition() =============================================================================
---Ermittelt die Position des Kranhakens des Rollmaterials im EEP-Koordinatensystem.
---@overload fun(rollingstockName: string): boolean, number, number, number
---@param rollingstockName string parameter ist der komplette Name des Rollmaterials als String.
---@param hookNumber? number optionale 2. Parameter ist die Hakennummer, wenn mehrere Haken vorhanden.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
---@return number posX rueckgabewert ist die X-Position in Metern.
---@return number posY rueckgabewert ist die Y-Position in Metern.
---@return number posZ rueckgabewert ist die Z-Position in Metern.
function EEPRollingstockGetHookPosition(rollingstockName, hookNumber) end

--       ============================================================
-- Verfuegbar ab EEP 18.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPRollingstockGetHookPosition("Fahrzeugname" [, Kranhakennummer])
--   ok, PosX, PosY, PosZ = EEPRollingstockGetHookPosition("Brueckenkran - Haken")
--   ok, PosX, PosY, PosZ = EEPRollingstockGetHookPosition("Brueckenkran - 3 Haken", 2)

-- === EEPRollingstockSetSmoke() ====================================================================================
---Schaltet den Rauch des bennanten Rollmaterials an oder aus.
---@param rollingstockName string parameter ist der komplette Name des Rollmaterials als String.
---@param enabled boolean parameter schaltet den Rauch mit true an oder mit false aus.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPRollingstockSetSmoke(rollingstockName, enabled) end

--       ==================================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPRollingstockSetSmoke("Fahrzeugname", true|false)
--   ok = EEPRollingstockSetSmoke("DR_96020", true)

-- === EEPRollingstockGetSmoke() ====================================================================================
---Ermittelt, ob der Rauch des benannten Rollmaterials, an- oder ausgeschaltet ist.
---@param rollingstockName string parameter ist der komplette Name des Rollmaterials als String.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
---@return boolean rauch rueckgabewert ist entweder true, wenn der Rauch an-, oder false, wenn er ausgeschaltet ist.
function EEPRollingstockGetSmoke(rollingstockName) end

--       =========================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPRollingstockGetSmoke("Fahrzeugname")
--   ok, Rauch = EEPRollingstockGetSmoke("DR_96020")

-- === EEPRollingstockSetHorn() =====================================================================================
---Laesst bei einem bestimmten Rollmaterial den Warnton (Pfeife, Hupe) ertoenen.
---@overload fun(rollingstockName: string): boolean
---@param rollingstockName string parameter ist der komplette Name des Rollmaterials als String.
---@param enabled? boolean parameter ist optional und laesst den Warnton mit true ertoenen oder stellt ihn mit false
--- ab, bevor er verklungen ist. Da true der Default-Wert ist, ertoent der Warnton auch, wenn der 2. Parameter
--- weggelassen wird.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPRollingstockSetHorn(rollingstockName, enabled) end

--       =================================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPRollingstockSetHorn("Fahrzeugname" [, true|false])
--   ok = EEPRollingstockSetHorn("DR_96020")
--   ok = EEPRollingstockSetHorn("DR_96020", true)
--   ok = EEPRollingstockSetHorn("DR_96020", false)

-- === EEPRollingstockGetMileage() ==================================================================================
---Ermittelt die zurueckgelegte Strecke des Rollmaterials
---@param rollingstockName string parameter ist der komplette Name des Rollmaterials als String.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
---@return number strecke rueckgabewert ermittelt die in Metern zurueckgelegte Strecke des Rollmaterials seit dem
--- Einsetzen in EEP
function EEPRollingstockGetMileage(rollingstockName) end

--       ===========================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPRollingstockGetMileage("Fahrzeugname")
--   ok, Strecke = EEPRollingstockGetMileage("BR 212 376- 8")

-- === EEPRollingstockGetPosition() =================================================================================
---Ermittelt die Position des Rollmaterials im EEP-Koordinatensystem.
---@param rollingstockName string parameter ist der komplette Name des Rollmaterials als String.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
---@return number posX rueckgabewert ist die X-Position in Metern.
---@return number posY rueckgabewert ist die Y-Position in Metern.
---@return number posZ rueckgabewert ist die Z-Position in Metern.
function EEPRollingstockGetPosition(rollingstockName) end

--       ============================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPRollingstockGetPosition("Fahrzeugname")
--   ok, PosX, PosY, PosZ = EEPRollingstockGetPosition("BR 212 376-8")

-- === EEPRollingstockGetRotation() =================================================================================
---Ermittelt die Ausrichtung des Rollmaterials im EEP-Koordinatensystem.
---@param rollingstockName string parameter ist der komplette Name des Rollmaterials als String.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
---@return any rotX rueckgabewert ist die Drehung um die X-Achse .
---@return any rotY rueckgabewert ist die Drehung um die Y-Achse .
---@return any rotZ rueckgabewert ist die Drehung um die Z-Achse .
function EEPRollingstockGetRotation(rollingstockName) end

--       ============================================
-- Verfuegbar ab EEP 18.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPRollingstockGetRotation("Fahrzeugname")
--   ok, RotX, RotY, RotZ = EEPRollingstockGetRotation("DB_Sdgkms_3180409-355")

-- === EEPStructureSetSmoke() =======================================================================================
---Schaltet den Rauch der benannten Immobilie an oder aus.
---@param luaName string parameter ist der Lua-Name der Immobilie als String. Er steht in den Objekteigenschaften und
--- unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die Nummer mit vorangestelltem
--- #-Zeichen als Identifikator.
---@param enabled boolean parameter schaltet den Rauch mit true an oder mit false aus.
---@return boolean ok rueckgabewert ist entweder true, wenn die Immobilie existiert und eine Rauchfunktion hat oder
--- false, falls mindestens eins von beidem nicht zutrifft.
function EEPStructureSetSmoke(luaName, enabled) end

--       ======================================
-- Verfuegbar ab EEP 11.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPStructureSetSmoke("#Lua-Name", true|false)
--   Name = "#1_Abfertigung Lauscha"
--   ok = EEPStructureSetSmoke(Name, true)
--   ok = EEPStructureSetSmoke("#1", true)

-- === EEPStructureGetSmoke() =======================================================================================
---Ermittelt, ob der Rauch der benannten Immobilie an- oder ausgeschaltet ist.
---@param luaName string parameter ist der Lua-Name der Immobilie als String. Er steht in den Objekteigenschaften und
--- unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die Nummer mit vorangestelltem
--- #-Zeichen als Identifikator.
---@return boolean ok rueckgabewert ist entweder true, wenn die Immobilie existiert und eine Rauchfunktion hat oder
--- false, falls mindestens eins von beidem nicht zutrifft.
---@return boolean rauch rueckgabewert ist entweder true, wenn der Rauch an- oder false, wenn der Rauch ausgeschaltet
--- ist.
function EEPStructureGetSmoke(luaName) end

--       =============================
-- Verfuegbar ab EEP 11.1 - Plugin 1.
-- Bemerkungen:
--   Achtung: Nach EEPStructureSetSmoke() liefert EEPStructureGetSmoke() fruehestens im naechsten Zyklus der
--   EEPMain() den neuen Rauchstatus.
-- Beispielaufrufe:
--   EEPStructureGetSmoke("#Lua-Name")
--   Name = "#1_Abfertigung Lauscha"
--   ok, Rauch = EEPStructureGetSmoke(Name)
--   ok, Rauch = EEPStructureGetSmoke("#1")

-- === EEPStructureSetLight() =======================================================================================
---Schaltet das Licht der benannten Immobilie an oder aus.
---@param luaName string parameter ist der Lua-Name der Immobilie als String. Er steht in den Objekteigenschaften und
--- unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die Nummer mit vorangestelltem
--- #-Zeichen als Identifikator.
---@param enabled boolean parameter schaltet das Licht mit true an oder mit false aus.
---@return boolean ok rueckgabewert ist entweder true, wenn die Immobilie existiert und eine Lichtfunktion hat oder
--- false, falls mindestens eins von beidem nicht zutrifft.
function EEPStructureSetLight(luaName, enabled) end

--       ======================================
-- Verfuegbar ab EEP 11.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPStructureSetLight("#Lua-Name", true|false)
--   Name = "#13_Betriebsdienstgebaeude"
--   ok = EEPStructureSetLight(Name, true)
--   ok = EEPStructureSetLight("#13", true)

-- === EEPStructureGetLight() =======================================================================================
---Plugin 1 Ermittelt, ob das Licht der benannten Immobilie an- oder ausgeschaltet ist.
---@param luaName string parameter ist der Lua-Name der Immobilie als String. Er steht in den Objekteigenschaften und
--- unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die Nummer mit vorangestelltem
--- #-Zeichen als Identifikator.
---@return boolean ok rueckgabewert ist entweder true, wenn die Immobilie existiert und eine Lichtfunktion hat oder
--- false, falls mindestens eins von beidem nicht zutrifft.
---@return boolean licht rueckgabewert ist entweder true, wenn das Licht an-, oder false, wenn das Licht
--- ausgeschaltet bzw. im "Automatik"-Modus ist.
function EEPStructureGetLight(luaName) end

--       =============================
-- Verfuegbar ab EEP 11.1.
-- Bemerkungen:
--   Achtung: Nach EEPStructureSetLight() liefert EEPStructureGetLight() fruehestens im naechsten Zyklus der
--   EEPMain() den neuen Beleuchtungsstatus.
-- Beispielaufrufe:
--   EEPStructureGetLight("#Lua-Name")
--   Name = "#13_Betriebsdienstgebaeude"
--   ok, Licht = EEPStructureGetLight(Name)
--   ok, Licht = EEPStructureGetLight("#13")

-- === EEPStructureSetFire() ========================================================================================
---Schaltet das Feuer der benannten Immobilie an oder aus.
---@param luaName string parameter ist der Lua-Name der Immobilie als String. Er steht in den Objekteigenschaften und
--- unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die Nummer mit vorangestelltem
--- #-Zeichen als Identifikator..
---@param enabled boolean parameter schaltet das Feuer mit true an oder false aus.
---@return boolean ok rueckgabewert ist entweder true, wenn die Immobilie existiert und eine Brandfunktion hat oder
--- false, falls mindestens eins von beidem nicht zutrifft.
function EEPStructureSetFire(luaName, enabled) end

--       =====================================
-- Verfuegbar ab EEP 11.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPStructureSetFire("#Lua-Name", true|false)
--   Name = "#15_Brandhaus_01_SB1"
--   ok = EEPStructureSetFire(Name, true)
--   ok = EEPStructureSetFire("#15 ", true)

-- === EEPStructureGetFire() ========================================================================================
---Ermittelt, ob das Feuer der benannten Immobilie an- oder ausgeschaltet ist.
---@param luaName string parameter ist der Lua-Name der Immobilie als String. Er steht in den Objekteigenschaften und
--- unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die Nummer mit vorangestelltem
--- #-Zeichen als Identifikator.
---@return boolean ok rueckgabewert ist entweder true, wenn die Immobilie existiert und eine Brandfunktion hat oder
--- false, falls mindestens eins von beidem nicht zutrifft.
---@return boolean feuer rueckgabewert ist entweder true, wenn das Feuer an-, oder false, wenn das Feuer
--- ausgeschaltet ist.
function EEPStructureGetFire(luaName) end

--       ============================
-- Verfuegbar ab EEP 11.1 - Plugin 1.
-- Bemerkungen:
--   Achtung: Nach EEPStructureSetFire() liefert EEPStructureGetFire() fruehestens im naechsten Zyklus der EEPMain()
--   den neuen Brandstatus.
-- Beispielaufrufe:
--   EEPStructureGetFire("#Lua-Name")
--   Name = "#15_Brandhaus_01_SB1"
--   ok, Feuer = EEPStructureGetFire(Name)
--   ok, Feuer = EEPStructureGetFire("#15")

-- === EEPStructureSetAxis() ========================================================================================
---Setzt die mittels Achsnamen definierte Achse einer Immobilie oder eines Gleisobjekts auf eine bestimmte Stellung
---(ohne Animation).
---@param luaName string parameter ist der Lua-Name der Immobilie oder des Gleisobjektes als String. Er steht in den
--- Objekteigenschaften und unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die Nummer mit
--- vorangestelltem #-Zeichen als Identifikator.
---@param axisName string parameter ist der Name der Achse als String. Er kann in den diversen EEP- Sprachversionen
--- unterschiedlich sein.
---@param axisPosition number parameter ist die Stellung, zu der die Achse springen soll.
---@return boolean ok rueckgabewert ist true, wenn Objekt und Achse existieren oder false, falls mindestens eins von
--- beidem nicht existiert.
function EEPStructureSetAxis(luaName, axisName, axisPosition) end

--       ====================================================
-- Verfuegbar ab EEP 11.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPStructureSetAxis("#Lua-Name", "Achse", Stellung)
--   Name = "#83_Drehscheibe"
--   Achse = "Bruecke"
--   ok = EEPStructureSetAxis(Name, Achse, 50)
--   ok = EEPStructureSetAxis("#83", "Bruecke", 50)

-- === EEPStructureGetAxis() ========================================================================================
---Ermittelt die Stellung einer mittels Achsnamen definierten Achse der benannten Immobilie oder des Gleisobjekts
---@param luaName string parameter ist der Lua-Name der Immobilie oder des Gleisobjektes als String. Er steht in den
--- Objekteigenschaften und unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die Nummer mit
--- vorangestelltem #-Zeichen als Identifikator.
---@param axisName string parameter ist der Name der Achse als String.Er kann in den diversen EEP- Sprachversionen
--- unterschiedlich sein.
---@return boolean ok rueckgabewert ist true, wenn Objekt und Achse existieren oder false, falls mindestens eins von
--- beidem nicht existiert.
---@return number stellung rueckgabewert ist die momentane Stellung der Achse als Zahl.
function EEPStructureGetAxis(luaName, axisName) end

--       ======================================
-- Verfuegbar ab EEP 11.1 - Plugin 1.
-- Bemerkungen:
--   Achtung: Nach EEPStructureSetAxis() oder EEPStructureSetAxisByNumber() liefert EEPStructureGetAxis() fruehestens
--   im naechsten Zyklus der EEPMain() die neue Achsenstellung.
-- Beispielaufrufe:
--   EEPStructureGetAxis("#Lua-Name", "Achse")
--   Name = "#83_Drehscheibe"
--   Achse = "Bruecke"
--   ok, Stellung = EEPStructureGetAxis(Name, Achse)
--   ok, Stellung = EEPStructureGetAxis("#83", "Bruecke")

-- === EEPStructureSetAxisByNumber() ================================================================================
---Setzt die mittels Achsnummer definierte Achse einer Immobilie oder eines Gleisobjekts auf eine bestimmte Stellung
---(ohne Animation).
---@param luaName string parameter ist der Lua-Name der Immobilie oder des Gleisobjektes als String. Er steht in den
--- Objekteigenschaften und unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die Nummer mit
--- vorangestelltem #-Zeichen als Identifikator.
---@param axisNumber number parameter ist die Achsnummer der zu bewegenden Achse als Zahl. Sie ist in allen
--- EEP-Sprachversionen gleich und steht sowohl in der ini-Datei als auch im Modellkatalog bei den Achsbezeichnungen
--- des Modells.
---@param axisPosition number parameter ist die Stellung, zu der die Achse springen soll.
---@return boolean ok rueckgabewert ist true, wenn Objekt und Achsnummer existieren oder false, falls mindestens eins
--- von beidem nicht existiert.
function EEPStructureSetAxisByNumber(luaName, axisNumber, axisPosition) end

--       ==============================================================
-- Verfuegbar ab EEP 18.0.
-- Beispielaufrufe:
--   EEPStructureSetAxisByNumber("#Lua-Name", Achsnummer, Stellung)
--   Name = "#83_Drehscheibe"
--   ok = EEPStructureSetAxisByNumber(Name, 1, 50)
--   ok = EEPStructureSetAxisByNumber("#83", 1, 50)

-- === EEPStructureGetAxisByNumber() ================================================================================
---Ermittelt die Stellung einer mittels Achsnummer definierten Achse der benannten Immobilie oder des Gleisobjekts
---@param luaName string parameter ist der Lua-Name der Immobilie oder des Gleisobjektes als String. Er steht in den
--- Objekteigenschaften und unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die Nummer mit
--- vorangestelltem #-Zeichen als Identifikator.
---@param axisNumber number parameter ist die Achsnummer der zu bewegenden Achse als Zahl. Sie ist in allen
--- EEP-Sprachversionen gleich und steht sowohl in der ini-Datei als auch im Modellkatalog bei den Achsbezeichnungen
--- des Modells.
---@return boolean ok rueckgabewert ist true, wenn Objekt und Achsnummer existieren oder false, falls mindestens eins
--- von beidem nicht existiert.
---@return number stellung rueckgabewert ist die momentane Stellung der Achse als Zahl.
function EEPStructureGetAxisByNumber(luaName, axisNumber) end

--       ================================================
-- Verfuegbar ab EEP 18.0.
-- Bemerkungen:
--   Achtung: Nach EEPSructureSetAxisByNumer() oder EEPStructureSetAxis() liefert EEPStructureGetAxis() fruehestens
--   im naechsten Zyklus der EEPMain() die neue Achsenstellung.
-- Beispielaufrufe:
--   EEPStructureGetAxisByNumber("#Lua-Name", Achsnummer)
--   Name = "#83_Drehscheibe"
--   ok, Stellung = EEPStructureGetAxisByNumber
--   (Name, 1)
--   ok, Stellung = EEPStructureGetAxisByNumber("#83", 1)

-- === EEPStructureAnimateAxis() ====================================================================================
---Bewegt die Achse einer Immobilie oder eines Gleisobjekts.
---@param luaName string parameter ist der Lua-Name der Immobilie oder des Gleisobjekts als String. Er steht in den
--- Objekteigenschaften und unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die Nummer mit
--- vorangestelltem #-Zeichen als Identifikator.
---@param axisName string parameter ist der Name der Achse als String
---@param stepDelta number parameter ist die (positive oder negative) Schrittzahl, um welche die Achse weiterbewegt
--- werden soll. Der Wert 1000 bzw. -1000 bewirkt eine endlose Bewegung. Der Wert 0 stoppt die Bewegung.
---@return boolean ok rueckgabewert ist true, wenn Objekt und Achse existieren oder false, falls mindestens eins von
--- beidem nicht existiert.
function EEPStructureAnimateAxis(luaName, axisName, stepDelta) end

--       =====================================================
-- Verfuegbar ab EEP 11.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPStructureAnimateAxis("#Lua-Name", "Achse", Stellung)
--   ok = EEPStructureAnimateAxis("#17_Windmuehle", "Muehlrad", 1000)
--   ok = EEPStructureAnimateAxis("#17", "Muehlrad", 1000)

-- === EEPStructureIsAxisAnimate() ==================================================================================
---Ermittelt, ob sich das genannte bewegliche Teil der genannten Immobilie oder des Gleisobjektes aktuell in Bewegung
---befindet und ob diese Bewegung endlos ist.
---@param luaName string parameter ist der Lua-Name der Immobilie oder des Gleisobjektes als String. Er steht in den
--- Objekteigenschaften und unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die Nummer mit
--- vorangestelltem #-Zeichen als Identifikator.
---@param axisName string parameter ist der Name des beweglichen Teils.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
---@return number status rueckgabewert ist: 0, wenn das genannte Teil steht, 1, wenn sich das genannte Teil in einer
--- endlosen Bewegung befindet, 2, wenn das Teil sich um eine endliche Anzahl Schritte bewegt.
function EEPStructureIsAxisAnimate(luaName, axisName) end

--       ============================================
-- Verfuegbar ab EEP 15.
-- Bemerkungen:
--   Achtung: Nach EEPStructureAnimateAxis() liefert EEPStructureIsAxisAnimate() fruehestens im naechsten Zyklus der
--   EEPMain() den neuen Animationsstatus.
-- Beispielaufrufe:
--   EEPStructureIsAxisAnimate("#Lua-Name", "Achse")
--   ok, Status = EEPStructureIsAxisAnimate("#17","Muehlrad")
--   if Status > 0 then
--   print("Die Windmuehle ist in Bewegung")
--   end

-- === EEPStructureSetPosition() ====================================================================================
---Versetzt die benannte Immobilie oder das Landschaftselement an eine neue Position.
---@param luaName string parameter ist der Lua-Name der Immobilie oder des Landschaftselementes als String. Er steht
--- in den Objekteigenschaften und unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die
--- Nummer mit vorangestelltem #-Zeichen als Identifikator.
---@param posX number parameter ist die Position in X-Richtung.
---@param posY number parameter ist die Position in Y-Richtung.
---@param posZ number parameter ist die Position in Z-Richtung.
---@return boolean ok rueckgabewert ist true, wenn das Objekt existiert oder false, wenn nicht oder ausserhalb des
--- Anlagenbereichs positioniert werden sollte.
function EEPStructureSetPosition(luaName, posX, posY, posZ) end

--       ==================================================
-- Verfuegbar ab EEP 11.1 - Plugin 1.
-- Bemerkungen:
--   Eine Positionierung ausserhalb des Anlagenbereichs ist nicht moeglich
-- Beispielaufrufe:
--   EEPStructureSetPosition("#Lua-Name", PosX, PosY, PosZ)
--   Name = "#55_Strohballen"
--   ok = EEPStructureSetPosition(Name, 11, 17, 3)
--   ok = EEPStructureSetPosition("#55", 11, 17, 3)

-- === EEPStructureGetPosition() ====================================================================================
---Ermittelt die aktuelle Position einer Immobilie oder eines Landschaftselements.
---@param luaName string parameter ist der Lua-Name der Immobilie oder des Landschaftselementes als String. Er steht
--- in den Objekteigenschaften und unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die
--- Nummer mit vorangestelltem #-Zeichen als Identifikator.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, ansonsten false.
---@return any posX rueckgabewert ist die X-Position des Objekts.
---@return any posY rueckgabewert ist die Y-Position des Objekts.
---@return any posZ rueckgabewert ist die Z-Position des Objekts.
function EEPStructureGetPosition(luaName) end

--       ================================
-- Verfuegbar ab EEP 15.
-- Bemerkungen:
--   Achtung: Nach EEPStructureSetPosition() liefert EEPStructureGetPosition() fruehestens im naechsten Zyklus der
--   EEPMain() die neuen Positionswerte.
-- Beispielaufrufe:
--   EEPStructureGetPosition("#Lua-Name")
--   ok, Pos_X, Pos_Y, Pos_Z = EEPStructureGetPosition("#55_Strohballen")
--   ok, Pos_X, Pos_Y, Pos_Z = EEPStructureGetPosition("#55")

-- === EEPStructureSetRotation() ====================================================================================
---Dreht die benannte Immobilie oder das Landschaftselement in eine neue Position.
---@param luaName string parameter ist der Lua-Name der Immobilie oder des Landschaftselementes als String. Er steht
--- in den Objekteigenschaften und unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die
--- Nummer mit vorangestelltem #-Zeichen als Identifikator.
---@param rotX number parameter ist die Drehung um die X-Achse
---@param rotY number parameter ist die Drehung um die Y-Achse
---@param rotZ number parameter ist die Drehung um die Z-Achse
---@return boolean ok rueckgabewert ist true, wenn das Objekt existiert oder false, wenn nicht.
function EEPStructureSetRotation(luaName, rotX, rotY, rotZ) end

--       ==================================================
-- Verfuegbar ab EEP 11.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPStructureSetRotation("#Lua-Name", RotX, RotY, RotZ)
--   Name = "#55_Strohballen"
--   ok = EEPStructureSetRotation(Name, 0, 0, 25)
--   ok = EEPStructureSetRotation("#55", 0, 0, 25)

-- === EEPStructureGetRotation() ====================================================================================
---Ermittelt die aktuelle Ausrichtung einer Immobilie oder eines Landschaftselements.
---@param luaName string parameter ist der Lua-Name der Immobilie oder des Landschaftselementes als String. Er steht
--- in den Objekteigenschaften und unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die
--- Nummer mit vorangestelltem #-Zeichen als Identifikator.
---@return boolean ok rueckgabewert ist true, wenn das Objekt existiert oder false, wenn nicht.
---@return any rotX rueckgabewert ist die Drehung um die X-Achse
---@return any rotY rueckgabewert ist die Drehung um die Y-Achse
---@return any rotZ rueckgabewert ist die Drehung um die Z-Achse
function EEPStructureGetRotation(luaName) end

--       ================================
-- Verfuegbar ab EEP 11.1 - Plugin 1.
-- Bemerkungen:
--   Achtung: Nach EEPStructureSetRotation() liefert EEPStructureGetRotation() fruehestens im naechsten Zyklus der
--   EEPMain() die neuen Rotationswerte.
-- Beispielaufrufe:
--   EEPStructureGetRotation("#Lua-Name")
--   ok, Rot_X, Rot_Y, Rot_Z = EEPStructureGetRotation("#55_Strohballen")
--   ok, Rot_X, Rot_Y, Rot_Z = EEPStructureGetRotation("#55")

-- === EEPStructureGetModelType() ===================================================================================
---Ermittelt die Kategorie, zu welcher die genannte Immobilie oder das genannte Landschaftselement gehoert.
---@alias EEPStructureModelType
---| 16 # Gleisobjekte Bahngleise
---| 17 # Gleisobjekte Strassenbahn
---| 18 # Gleisobjekte Strassen
---| 19 # Gleisobjekte Wasserwege oder Diverse
---| 22 # Immobilien
---| 23 # Landschaftselemente Fauna
---| 24 # Landschaftselemente Flora
---| 25 # Landschaftselemente Terra
---| 38 # Landschaftselemente Bodenmodelle zur 3D-Texturierung
---@param luaName string parameter ist der Lua-Name der Immobilie oder des Landschaftselements. Er steht in den
--- Objekteigenschaften und unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die Nummer mit
--- vorangestelltem #-Zeichen als Identifikator.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
---@return EEPStructureModelType typ rueckgabewert ist die Modellkategorie.
function EEPStructureGetModelType(luaName) end

--       =================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
--   EEPStructureGetModelType("#Lua-Name")
--   ok, Typ = EEPStructureGetModelType("#23")

-- === EEPStructureSetLightningColour() =============================================================================
---Setzt alternative Beleuchtungsfarbe fuer benannte Immobilie.
---@param luaName string parameter ist der Lua-Name der Immobilie als String. Er steht in den Objekteigenschaften und
--- unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die Nummer mit vorangestelltem
--- #-Zeichen als Identifikator.
---@param red number die Parameter 2 - 4 bestimmen die Farbe aus den Anteilen fuer rot, gruen und blau jeweils im
--- Bereich von 0 - 255.
---@param green number die Parameter 2 - 4 bestimmen die Farbe aus den Anteilen fuer rot, gruen und blau jeweils im
--- Bereich von 0 - 255.
---@param blue number die Parameter 2 - 4 bestimmen die Farbe aus den Anteilen fuer rot, gruen und blau jeweils im
--- Bereich von 0 - 255.
---@return boolean ok rueckgabewert ist entweder true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPStructureSetLightningColour(luaName, red, green, blue) end

--       =========================================================
-- Verfuegbar ab EEP 18.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPStructureSetLightingColour("#Lua-Name", R, G, B)
--   Name = "#13_Hermannsdenkmal"
--   ok = EEPStructureSetLightingColour(Name, 128, 255, 128)
--   ok = EEPStructureSetLightingColour("#13", 128, 255, 128)

-- === EEPGoodsSetPosition() ========================================================================================
---Aendert die Position eines Ladeguts auf der Anlage.
---@param luaName string parameter ist der Lua-Name des Ladeguts. Er steht in den Objekteigenschaften und
--- unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die Nummer mit vorangestelltem
--- #-Zeichen als Identifikator.
---@param posX number parameter ist die X-Position des Objekts.
---@param posY number parameter ist die Y-Position des Objekts.
---@param posZ number parameter ist die Z-Position des Objekts.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, ansonsten false.
function EEPGoodsSetPosition(luaName, posX, posY, posZ) end

--       ==============================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
--   EEPGoodsSetPosition("#Lua-Name", Pos_X, Pos_Y, Pos_Z)
--   ok = EEPGoodsSetPosition("#66_Kartons", 13, 20, 5)
--   ok = EEPGoodsSetPosition("#66", 13, 20, 5)

-- === EEPGoodsGetPosition() ========================================================================================
---Ermittelt die aktuelle Position eines Ladeguts auf der Anlage.
---@param luaName string parameter ist der Lua-Name des Ladeguts. Er steht in den Objekteigenschaften und
--- unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die Nummer mit vorangestelltem
--- #-Zeichen als Identifikator.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, ansonsten false.
---@return any posX rueckgabewert ist die X-Position des Objekts.
---@return any posY rueckgabewert ist die Y-Position des Objekts.
---@return any posZ rueckgabewert ist die Z-Position des Objekts.
function EEPGoodsGetPosition(luaName) end

--       ============================
-- Verfuegbar ab EEP 15.
-- Bemerkungen:
--   Achtung: Nach EEPGoodsSetPosition() liefert EEPGoodsGetPosition() fruehestens im naechsten Zyklus der EEPMain()
--   die neuen Positionswerte.
-- Beispielaufrufe:
--   EEPGoodsGetPosition("#Lua-Name")
--   ok, Pos_X, Pos_Y, Pos_Z = EEPGoodsGetPosition("#66_Kartons")
--   ok, Pos_X, Pos_Y, Pos_Z = EEPGoodsGetPosition("#66")

-- === EEPGoodsSetRotation() ========================================================================================
---Aendert die Ausrichtung eines Ladeguts auf der Anlage.
---@param luaName string parameter ist der Lua-Name des Ladeguts. Er steht in den Objekteigenschaften und
--- unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die Nummer mit vorangestelltem
--- #-Zeichen als Identifikator.
---@param rotX number parameter ist die Drehung des Objekts um die X-Achse in Grad.
---@param rotY number parameter ist die Drehung des Objekts um die Y-Achse in Grad.
---@param rotZ number parameter ist die Drehung des Objekts um die Z-Achse in Grad.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, ansonsten false.
function EEPGoodsSetRotation(luaName, rotX, rotY, rotZ) end

--       ==============================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
--   EEPGoodsSetRotation("#Lua-Name", Rot_X, Rot_Y, Rot_Z)
--   ok = EEPGoodsSetRotation("#66_Kartons", 0, 0, 30)
--   ok = EEPGoodsSetRotation("#66", 0, 0, 30)

-- === EEPGoodsGetRotation() ========================================================================================
---Ermittelt die aktuelle Ausrichtung eines Ladeguts auf der Anlage.
---@param luaName string parameter ist der Lua-Name des Ladeguts. Er steht in den Objekteigenschaften und
--- unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die Nummer mit vorangestelltem
--- #-Zeichen als Identifikator.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, ansonsten false.
---@return number rot_X rueckgabewert ist die Drehung des Objekts um die X-Achse in Grad.
---@return number rot_Y rueckgabewert ist die Drehung des Objekts um die Y-Achse in Grad.
---@return number rot_Z rueckgabewert ist die Drehung des Objekts um die Z-Achse in Grad.
function EEPGoodsGetRotation(luaName) end

--       ============================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Bemerkungen:
--   Achtung: Nach EEPGoodsSetRotation() liefert EEPGoodsGetRotation() fruehestens im naechsten Zyklus der EEPMain()
--   die neuen Rotationswerte.
-- Beispielaufrufe:
--   EEPGoodsGetRotation("#Lua-Name)
--   ok, Rot_X, Rot_Y, Rot_Z = EEPGoodsGetRotation("#66_Kartons")
--   ok, Rot_X, Rot_Y, Rot_Z = EEPGoodsGetRotation("#66 ")

-- === EEPGoodsSetAxis() ============================================================================================
---Setzt die mittels Achsnamen definierte Achse eines Ladegutes auf eine bestimmte Stellung (ohne Animation).
---@param luaName string parameter ist der Lua-Name des Ladegutes als String. Er steht in den Objekteigenschaften und
--- unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die Nummer mit vorangestelltem
--- #-Zeichen als Identifikator.
---@param axisName string parameter ist der Name der Achse als String. Er kann in den diversen EEP- Sprachversionen
--- unterschiedlich sein.
---@param axisPosition number parameter ist die Stellung, zu der die Achse springen soll.
---@return boolean ok rueckgabewert ist true, wenn Objekt und Achse existieren oder false, falls mindestens eins von
--- beidem nicht existiert.
function EEPGoodsSetAxis(luaName, axisName, axisPosition) end

--       ================================================
-- Verfuegbar ab EEP 18.0.
-- Beispielaufrufe:
--   EEPGoodsSetAxis("#Lua-Name", "Achse", Stellung)
--   Name = "#83_IF_ctnr_OT20_C1 (MS7)"
--   Achse = "Ebene der Ladung"
--   ok = EEPGoodsSetAxis(Name, Achse, 50)
--   ok = EEPGoodsSetAxis("#83", "Ebene der Ladung", 50)

-- === EEPGoodsGetAxis() ============================================================================================
---Ermittelt die Stellung einer mittels Achsnamen definierten Achse des benannten Ladegutes.
---@param luaName string parameter ist der Lua-Name des Ladegutes als String. Er steht in den Objekteigenschaften und
--- unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die Nummer mit vorangestelltem
--- #-Zeichen als Identifikator.
---@param axisName string parameter ist der Name der Achse als String.Er kann in den diversen EEP- Sprachversionen
--- unterschiedlich sein.
---@return boolean ok rueckgabewert ist true, wenn Objekt und Achse existieren oder false, falls mindestens eins von
--- beidem nicht existiert.
---@return number stellung rueckgabewert ist die momentane Stellung der Achse als Zahl.
function EEPGoodsGetAxis(luaName, axisName) end

--       ==================================
-- Verfuegbar ab EEP 18.0.
-- Beispielaufrufe:
--   EEPGoodsGetAxis("#Lua-Name", "Achse")
--   Name = "#83_IF_ctnr_OT20_C1 (MS7)"
--   Achse = "Ebene der Ladung"
--   ok, Stellung = EEPGoodsGetAxis(Name, Achse)
--   ok, Stellung = EEPGoodsGetAxis("#83", "Ebene der Ladung")

-- === EEPGoodsSetAxisByNumber() ====================================================================================
---Setzt die mittels Achsnummer definierte Achse eines Ladegutes auf eine bestimmte Stellung (ohne Animation).
---@param luaName string parameter ist der Lua-Name des Ladegutes als String. Er steht in den Objekteigenschaften und
--- unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die Nummer mit vorangestelltem
--- #-Zeichen als Identifikator.
---@param axisNumber number parameter ist die Achsnummer der zu bewegenden Achse als Zahl. Sie ist in allen
--- EEP-Sprachversionen gleich und steht sowohl in der ini-Datei als auch im Modellkatalog bei den Achsbezeichnungen
--- des Modells.
---@param axisPosition number parameter ist die Stellung, zu der die Achse springen soll.
---@return boolean ok rueckgabewert ist true, wenn Objekt und Achsnummer existieren oder false, falls mindestens eins
--- von beiden nicht existiert.
function EEPGoodsSetAxisByNumber(luaName, axisNumber, axisPosition) end

--       ==========================================================
-- Verfuegbar ab EEP 18.0.
-- Beispielaufrufe:
--   EEPGoodsSetAxisByNumber("#Lua-Name", Achsnummer, Stellung)
--   Name = "#83_IF_ctnr_OT20_C1 (MS7)"
--   ok = EEPGoodsSetAxisByNumber(Name, 1, 50)
--   ok = EEPGoodsSetAxisByNumber("#83", 1, 50)

-- === EEPGoodsGetAxisByNumber() ====================================================================================
---Ermittelt die Stellung einer mittels Achsnummer definierten Achse des benannten Ladegutes.
---@param luaName string parameter ist der Lua-Name des Ladegutes als String. Er steht in den Objekteigenschaften und
--- unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die Nummer mit vorangestelltem
--- #-Zeichen als Identifikator.
---@param axisNumber number parameter ist die Achsnummer der zu bewegenden Achse als Zahl. Sie ist in allen
--- EEP-Sprachversionen gleich und steht sowohl in der ini-Datei als auch im Modellkatalog bei den Achsbezeichnungen
--- des Modells.
---@return boolean ok rueckgabewert ist true, wenn Objekt und Achsnummer existieren oder false, falls mindestens eins
--- von beiden nicht existiert.
---@return number stellung rueckgabewert ist die momentane Stellung der Achse als Zahl.
function EEPGoodsGetAxisByNumber(luaName, axisNumber) end

--       ============================================
-- Verfuegbar ab EEP 18.0.
-- Bemerkungen:
--   Achtung: Nach EEPGoodsSetAxisByNumer() oder EEGoodsSetAxis() liefert EEPGoodsGetAxis() fruehestens im naechsten
--   Zyklus der EEPMain() die neue Achsenstellung.
-- Beispielaufrufe:
--   EEPGoodsGetAxisByNumber("#Lua-Name", Achsnummer)
--   Name = "#83_IF_ctnr_OT20_C1 (MS7)"
--   ok, Stellung = EEPGoodsGetAxisByNumber(Name, 1)
--   ok, Stellung = EEPGoodsGetAxisByNumber("#83", 1)

-- === EEPGoodsGetModelType() =======================================================================================
---Ermittelt die Kategorie, zu welcher das genannte Ladegut gehoert.
---@alias EEPGoodsModelType
---| 20 # Gueter mit kubischer Form
---| 21 # Gueter mit zylindrischer Form
---@param luaName string parameter ist der Lua-Name des Ladeguts. Er steht in den Objekteigenschaften und
--- unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die Nummer mit vorangestelltem
--- #-Zeichen als Identifikator.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
---@return EEPGoodsModelType typ rueckgabewert ist die Modellkategorie.
function EEPGoodsGetModelType(luaName) end

--       =============================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
--   EEPGoodsGetModelType("#Lua-Name")
--   ok, Typ = EEPGoodsGetModelType("#78")

-- === EEPRegisterRailTrack() =======================================================================================
---Registriert ein Gleiselement fuer Besetztabfragen.
---@param railTrackId number parameter ist die ID des zu registrierenden Gleises.
---@return boolean ok rueckgabewert ist true, wenn das Gleis existiert, andernfalls false
function EEPRegisterRailTrack(railTrackId) end

--       =================================
-- Verfuegbar ab EEP 11.3 - Plugin 3.
-- Bemerkungen:
--   Eine Registrierung ist zwingende Voraussetzung fuer Besetztabfragen.
-- Beispielaufrufe:
--   EEPRegisterRailTrack(Gleis-ID)
--   ok = EEPRegisterRailTrack(123)

-- === EEPIsRailTrackReserved() =====================================================================================
---Ermittelt, ob ein Gleiselement besetzt ist bzw. ob es mit dem x-ten Zugverband besetzt ist und gibt dann dessen
---Namen zurueck.
---@overload fun(railTrackId: number): boolean, boolean
---@param railTrackId number parameter ist die ID des Gleises, das auf "besetzt" geprueft werden soll.
---@param occupiedIndex? boolean kann ein optionaler 2. Parameter true oder 1 mitgegeben werden, damit die Funktion
--- als 3. Rueckgabewert den Namen des vordersten Zugverbandes in Gleisrichtung liefert. Ab EEP 17.2 Plugin 2 koennen
--- auch Zahlen groesser 1 eingegeben werden, damit die Funktion den Namen des Zugverbandes auf der entsprechenden
--- hinteren Position als 3. Rueckgabewert ausgibt.
---@return boolean ok rueckgabewert ist true, wenn das zu pruefende Gleis existiert und registriert ist, andernfalls
--- false.
---@return boolean besetzt rueckgabewert ist ohne den 2. Parameter true, wenn das Gleis besetzt ist, andernfalls
--- false. Mit dem 2. Parameter gibt er true zurueck, wenn an der im 2. Parameter bezeichneten Stelle (wobei dort
--- true = 1 entspricht) ein Zugverband steht, andernfalls false.
---@return string trainName rueckgabewert ist der Name des Zugverbandes, welcher das Gleis auf der als 2. Parameter
--- angegebenen Position (wobei true = 1 entspricht) besetzt. Wird als 3. Parameter eine Zahl eingegeben, die
--- groesser als die Anzahl der Zugverbaende ist, die auf dem Gleis stehen, so ist der 3. Rueckgabewert eine leere
--- Zeichenkette (String). ACHTUNG: Der 3. Rueckgabewert ist korrekt, solange die Zuege nicht in Bewegung sind! Wenn
--- sich aber die Fahrzeuge bewegen, kann der Lua- Interpreter falsche Namen liefern, da sich die Liste mit den Namen
--- z.B. mit 60 fps aendert, Lua aber asynchron in einem anderen Thread (CPU) laeuft, um EEP nicht zu verlangsamen.
function EEPIsRailTrackReserved(railTrackId, occupiedIndex) end

--       ==================================================
-- Verfuegbar ab EEP 11.3 - Plugin 3; EEP 13.2 - Plugin 2; EEP 17.2 - Plugin 2.
-- Bemerkungen:
--   Das Gleis muss zuvor fuer Besetztabfragen registriert worden sein!
-- Beispielaufrufe:
--   EEPIsRailTrackReserved(Gleis-ID [, true|Zahl])
--   ok, besetzt = EEPIsRailTrackReserved(123)
--   ok, besetzt, Zugname = EEPIsRailTrackReserved(123, true)
--   ok, besetzt, Zugname = EEPIsRailTrackReserved(123, 2)

-- === EEPRegisterRoadTrack() =======================================================================================
---Registriert ein Strassenelement fuer Besetztabfragen.
---@param roadTrackId number parameter ist die ID der zu registrierenden Strasse.
---@return boolean ok rueckgabewert ist true, wenn die Strasse existiert, andernfalls false
function EEPRegisterRoadTrack(roadTrackId) end

--       =================================
-- Verfuegbar ab EEP 11.3 - Plugin 3.
-- Bemerkungen:
--   Eine Registrierung ist zwingende Voraussetzung fuer Besetztabfragen.
-- Beispielaufrufe:
--   EEPRegisterRoadTrack(Strassen-ID)
--   ok = EEPRegisterRoadTrack(211)

-- === EEPIsRoadTrackReserved() =====================================================================================
---Ermittelt, ob ein Strassenelement besetzt ist bzw. ob es mit dem x-ten Fahrzeugverband besetzt ist und gibt dann
---dessen Namen zurueck.
---@overload fun(roadTrackId: number): boolean, boolean
---@param roadTrackId number parameter ist die ID der Strasse, welche auf "besetzt" geprueft werden soll.
---@param occupiedIndex? boolean kann ein optionaler 2. Parameter true oder 1 mitgegeben werden, damit die Funktion
--- als 3. Rueckgabewert den Namen des vordersten Fahrzeugverbandes in Strassenrichtung liefert. Ab EEP 17.2 Plugin 2
--- koennen auch Zahlen groesser 1 eingegeben werden, damit die Funktion den Namen des Fahrzeugverbandes auf der
--- entsprechenden hinteren Position als 3. Rueckgabewert ausgibt.
---@return boolean ok rueckgabewert ist true, wenn die zu pruefende Strasse existiert und registriert ist,
--- andernfalls false.
---@return boolean besetzt rueckgabewert ist ohne den 2. Parameter true, wenn die Strasse besetzt ist, andernfalls
--- false. Mit dem 2. Parameter gibt er true zurueck, wenn an der im 2. Parameter bezeichneten Stelle (wobei dort
--- true = 1 entspricht) ein Fahrzeugverband steht, andernfalls false.
---@return string name_Fahrzeugverband rueckgabewert ist der Name des Fahrzeugverbandes, welcher die Strasse auf der
--- als 2. Parameter angegebenen Position (wobei true = 1 entspricht) besetzt. Wird als 3. Parameter eine Zahl
--- eingegeben, die groesser als die Anzahl der Fahrzeugverbaende ist, die auf der Strasse stehen, so ist der 3.
--- Rueckgabewert eine leere Zeichenkette (String). ACHTUNG: Der 3. Rueckgabewert ist korrekt, solange die
--- Fahrzeugver- baende nicht in Bewegung sind! Wenn sich aber die Fahrzeuge bewegen, kann der Lua-Interpreter
--- falsche Namen liefern, da sich die Liste mit den Namen z.B. mit 60 fps aendert, Lua aber asynchron in einem
--- anderen Thread (CPU) laeuft, um EEP nicht zu verlangsamen.
function EEPIsRoadTrackReserved(roadTrackId, occupiedIndex) end

--       ==================================================
-- Verfuegbar ab EEP 11.3 - Plugin 3; EEP 13.2 - Plugin 2; EEP 17.2 - Plugin 2.
-- Bemerkungen:
--   Die Strasse muss zuvor fuer Besetztabfragen registriert worden sein!
-- Beispielaufrufe:
--   EEPIsRoadTrackReserved(Strassen-ID [, true|Zahl])
--   ok, besetzt = EEPIsRoadTrackReserved(211)
--   ok, besetzt, Name_Fahrzeugverband = EEPIsRoadTrackReserved(211, true)
--   ok, besetzt, Name_Fahrzeugverband = EEPIsRoadTrackReserved(211, 3)

-- === EEPRegisterTramTrack() =======================================================================================
---Registriert ein Strassenbahngleis fuer Besetztabfragen.
---@param tramTrackId number parameter ist die ID des zu registrierenden Strassenbahngleises.
---@return boolean ok rueckgabewert ist true, wenn das Strassenbahngleis existiert, andernfalls false
function EEPRegisterTramTrack(tramTrackId) end

--       =================================
-- Verfuegbar ab EEP 11.3 - Plugin 3.
-- Bemerkungen:
--   Eine Registrierung ist zwingende Voraussetzung fuer Besetztabfragen.
-- Beispielaufrufe:
--   EEPRegisterTramTrack(Strassenbahngleis-ID)
--   ok = EEPRegisterTramTrack(187)

-- === EEPIsTramTrackReserved() =====================================================================================
---Ermittelt, ob ein Strassenbahngleis besetzt ist bzw. ob es mit dem x-ten Zugverband besetzt ist und gibt dann
---dessen Namen zurueck.
---@overload fun(tramTrackId: number): boolean, boolean
---@param tramTrackId number parameter ist die ID des Strassenbahngleises, welches auf "besetzt" geprueft werden
--- soll.
---@param occupiedIndex? boolean kann ein optionaler 2. Parameter true oder 1 mitgegeben werden, damit die Funktion
--- als 3. Rueckgabewert den Namen des vordersten Zugverbandes in Gleisrichtung liefert. Ab EEP 17.2 Plugin 2 koennen
--- auch Zahlen groesser 1 eingegeben werden, damit die Funktion den Namen des Zuges auf der entsprechenden hinteren
--- Position als 3. Rueckgabewert ausgibt.
---@return boolean ok rueckgabewert ist true, wenn das zu pruefende Strassenbahngleis existiert und registriert ist,
--- andernfalls false.
---@return boolean besetzt rueckgabewert ist ohne den 2. Parameter true, wenn das Strassenbahngleis besetzt ist,
--- andernfalls false. Mit dem 2. Parameter gibt er true zurueck, wenn an der im 2. Parameter bezeichneten Stelle
--- (wobei dort true = 1 entspricht) ein Zugverband steht, andernfalls false.
---@return string name_Strassenbahnverband rueckgabewert ist der Name des Strassenbahnverbandes, welcher das
--- Strassenbahngleis auf der als 2. Parameter angegebenen Position (wobei true = 1 entspricht) besetzt. Wird als 3.
--- Parameter eine Zahl eingegeben, die groesser als die Anzahl der Zugverbaende ist, die auf dem Gleis stehen, so
--- ist der 3. Rueckgabewert eine leere Zeichenkette (String). ACHTUNG: Der 3. Rueckgabewert ist korrekt, solange die
--- Zuege nicht in Bewegung sind! Wenn sich aber die Fahrzeuge bewegen, kann der Lua- Interpreter falsche Namen
--- liefern, da sich die Liste mit den Namen z.B. mit 60 fps aendert, Lua aber asynchron in einem anderen Thread
--- (CPU) laeuft, um EEP nicht zu verlangsamen.
function EEPIsTramTrackReserved(tramTrackId, occupiedIndex) end

--       ==================================================
-- Verfuegbar ab EEP 11.3 - Plugin 3; EEP 13.2 - Plugin 2; EEP 17.2 - Plugin 2.
-- Bemerkungen:
--   Das Strassenbahngleis muss zuvor fuer Besetztabfragen registriert worden sein!
-- Beispielaufrufe:
--   EEPIsTramTrackReserved(Strassenbahngleis-ID [, true|Zahl])
--   ok, besetzt = EEPIsTramTrackReserved(187)
--   ok, besetzt, Name_Strassenbahnverband = EEPIsTramTrackReserved(187, true)
--   ok, besetzt, Name_Strassenbahnverband = EEPIsTramTrackReserved(187, 2)

-- === EEPRegisterAuxiliaryTrack() ==================================================================================
---Registriert ein Weg-Element der Kategorie "Sonstige" fuer Besetztabfragen.
---@param auxiliaryTrackId number parameter ist die ID des zu registrierenden Weges der Kategorie "Sonstige".
---@return boolean ok rueckgabewert ist true, wenn der Weg existiert, andernfalls false
function EEPRegisterAuxiliaryTrack(auxiliaryTrackId) end

--       ===========================================
-- Verfuegbar ab EEP 11.3 - Plugin 3.
-- Bemerkungen:
--   Eine Registrierung ist zwingende Voraussetzung fuer Besetztabfragen.
-- Beispielaufrufe:
--   EEPRegisterAuxiliaryTrack(Weg-ID)
--   ok = EEPRegisterAuxiliaryTrack(321)

-- === EEPIsAuxiliaryTrackReserved() ================================================================================
---Ermittelt, ob ein Weg-Element der Kategorie "Sonstige" besetzt ist bzw. ob es mit dem x-ten Fahrzeugverband
---besetzt ist und gibt dann dessen Namen zurueck.
---@overload fun(auxiliaryTrackId: number): boolean, boolean
---@param auxiliaryTrackId number parameter ist die ID des Weges der Kategorie "Sonstige", welcher auf "besetzt"
--- geprueft werden soll.
---@param occupiedIndex? boolean kann ein optionaler 2. Parameter true oder 1 mitgegeben werden, damit die Funktion
--- als 3. Rueckgabewert den Namen des vordersten Fahrzeugverbandes in Wegrichtung liefert. Ab EEP 17.2 Plugin 2
--- koennen auch Zahlen groesser 1 eingegeben werden, damit die Funktion den Namen des Fahrzeugverbandes auf der
--- entsprechenden hinteren Position als 3. Rueckgabewert ausgibt.
---@return boolean ok rueckgabewert ist true, wenn der zu pruefende Weg existiert und registriert ist, andernfalls
--- false.
---@return boolean besetzt rueckgabewert ist ohne den 2. Parameter true, wenn der Weg besetzt ist, andernfalls false.
--- Mit dem 2. Parameter gibt er true zurueck, wenn an der im 2. Parameter bezeichneten Stelle (wobei dort true = 1
--- entspricht) ein Fahrzeugverband steht, andernfalls false.
---@return string name_Fahrzeugverband rueckgabewert ist der Name des Fahrzeugverbandes, welcher den Weg auf der als
--- 2. Parameter angegebenen Position (wobei true = 1 entspricht) besetzt. Wird als 3. Parameter eine Zahl
--- eingegeben, die groesser als die Anzahl der Fahrzeugverbaende ist, die auf dem Weg stehen, so ist der 3.
--- Rueckgabe- wert eine leere Zeichenkette (String). ACHTUNG: Der 3. Rueckgabewert ist korrekt, solange die
--- Fahrzeugverbaende nicht in Bewegung sind! Wenn sich aber die Fahrzeuge bewegen, kann der Lua-Interpreter falsche
--- Namen liefern, da sich die Liste mit den Namen z.B. mit 60 fps aendert, Lua aber asynchron in einem anderen
--- Thread (CPU) laeuft, um EEP nicht zu verlangsamen.
function EEPIsAuxiliaryTrackReserved(auxiliaryTrackId, occupiedIndex) end

--       ============================================================
-- Verfuegbar ab EEP 11.3 - Plugin 3; EEP 13.2 - Plugin 2; EEP 17.2 - Plugin 2.
-- Bemerkungen:
--   Der Weg muss zuvor fuer Besetztabfragen registriert worden sein!
-- Beispielaufrufe:
--   EEPIsAuxiliaryTrackReserved(Weg-ID [, true|Zahl])
--   ok, besetzt = EEPIsAuxiliaryTrackReserved(321)
--   ok, besetzt, Name_Fahrzeugverband = EEPIsAuxiliaryTrackReserved(321,true)
--   ok, besetzt, Name_Fahrzeugverband = EEPIsAuxiliaryTrackReserved(321,3)

-- === EEPRegisterControlTrack() ====================================================================================
---Registriert ein Steuerstrecken-Element fuer Besetztabfragen.
---@param controlTrackId number parameter ist die ID der zu registrierenden Steuerstrecke.
---@return boolean ok rueckgabewert ist true, wenn die Steuerstrecke existiert, andernfalls false
function EEPRegisterControlTrack(controlTrackId) end

--       =======================================
-- Verfuegbar ab EEP 11.3 - Plugin 3.
-- Bemerkungen:
--   Eine Registrierung ist zwingende Voraussetzung fuer Besetztabfragen.
-- Beispielaufrufe:
--   EEPRegisterControlTrack(Steuerstrecken-ID)
--   ok = EEPRegisterControlTrack(333)

-- === EEPIsControlTrackReserved() ==================================================================================
---Ermittelt, ob ein Steuerstrecken-Element besetzt ist bzw. ob es mit dem x-ten Fahrzeugverband besetzt ist und gibt
---dann dessen Namen zurueck.
---@overload fun(controlTrackId: number): boolean, boolean
---@param controlTrackId number parameter ist die ID der Steuerstrecke, welche auf "besetzt" geprueft werden soll.
---@param occupiedIndex? boolean kann ein optionaler 2. Parameter true oder 1 mitgegeben werden, damit die Funktion
--- als 3. Rueckgabewert den Namen des vordersten Fahrzeugverbandes in Steuerstreckenrichtung liefert. Ab EEP 17.2
--- Plugin 2 koennen auch Zahlen groesser 1 eingegeben werden, damit die Funktion den Namen des Fahrzeugverbandes auf
--- der entsprechenden hinteren Position als 3. Rueckgabewert ausgibt.
---@return boolean ok rueckgabewert ist true, wenn die zu pruefende Steuerstrecke existiert und registriert ist,
--- andernfalls false.
---@return boolean besetzt rueckgabewert ist ohne den 2. Parameter true, wenn die Steuerstrecke besetzt ist,
--- andernfalls false. Mit dem 2. Parameter gibt er true zurueck, wenn an der im 2. Parameter bezeichneten Stelle
--- (wobei dort true = 1 entspricht) ein Fahrzeugverband steht, andernfalls false.
---@return string name_Fahrzeugverband rueckgabewert ist der Name des Fahrzeugverbandes, welcher die Steuerstrecke
--- auf der als 2. Parameter angegebenen Position (wobei true = 1 entspricht) besetzt. Wird als 3. Parameter eine
--- Zahl eingegeben, die groesser als die Anzahl der Fahrzeugverbaende ist, die auf der Steuerstrecke stehen, so ist
--- der 3. Rueckgabewert eine leere Zeichenkette (String). ACHTUNG: Der 3. Rueckgabewert ist korrekt, solange die
--- Fahrzeugverbaende nicht in Bewegung sind! Wenn sich aber die Fahrzeuge bewegen, kann der Lua-Interpreter falsche
--- Namen liefern, da sich die Liste mit den Namen z.B. mit 60 fps aendert, Lua aber asynchron in einem anderen
--- Thread (CPU) laeuft, um EEP nicht zu verlangsamen.
function EEPIsControlTrackReserved(controlTrackId, occupiedIndex) end

--       ========================================================
-- Verfuegbar ab EEP 11.3 - Plugin 3; EEP 13.2 - Plugin 2; EEP 17.2 - Plugin 2.
-- Bemerkungen:
--   Die Steuerstrecke muss zuvor fuer Besetztabfragen registriert worden sein!
-- Beispielaufrufe:
--   EEPIsControlTrackReserved(Steuerstrecken-ID [, true|Zahl])
--   ok, besetzt = EEPIsControlTrackReserved(333)
--   ok, besetzt, Name_Fahrzeugverband = EEPIsControlTrackReserved(333, true)
--   ok, besetzt, Name_Fahrzeugverband = EEPIsControlTrackReserved(333, 1)

-- === EEPRailTrackChangeAppearance() ===============================================================================
---Aendert die Ebene eines Gleises mit mehreren Ebenen und damit das Aussehen der Oberflaeche des Gleises.
---@param railTrackId number parameter ist die ID des Gleises, dessen Ebene geaendert werden soll.
---@param appearanceLevel number parameter ist die Nummer der gewuenschten Ebene. Wird eine Zahl groesser als die
--- Anzahl der vorhandenen Ebenen angegeben, wird die Eingabe intern auf die hoechste Ebenennummer gesetzt.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPRailTrackChangeAppearance(railTrackId, appearanceLevel) end

--       ==========================================================
-- Verfuegbar ab EEP 18.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPRailTrackChangeAppearance(Gleis-ID, Ebenennummer)
--   ok = EEPRailTrackChangeAppearance(97, 2)

-- === EEPRoadTrackChangeAppearance() ===============================================================================
---Aendert die Ebene einer Strasse mit mehreren Ebenen und damit das Aussehen der Oberflaeche der Strasse.
---@param roadTrackId number parameter ist die ID der Strasse, deren Ebene geaendert werden soll.
---@param appearanceLevel number parameter ist die Nummer der gewuenschten Ebene. Wird eine Zahl groesser als die
--- Anzahl der vorhandenen Ebenen angegeben, wird die Eingabe intern auf die hoechste Ebenennummer gesetzt.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPRoadTrackChangeAppearance(roadTrackId, appearanceLevel) end

--       ==========================================================
-- Verfuegbar ab EEP 18.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPRoadTrackChangeAppearance(Strassen-ID, Ebenennummer)
--   ok = EEPRoadTrackChangeAppearance(87, 3)

-- === EEPTramTrackChangeAppearance() ===============================================================================
---Aendert die Ebene eines Strassenbahngleises mit mehreren Ebenen und damit das Aussehen der Oberflaeche des
---Strassenbahngleises.
---@param tramTrackId number parameter ist die ID des Strassenbahngleises, dessen Ebene geaendert werden soll.
---@param appearanceLevel number parameter ist die Nummer der gewuenschten Ebene. Wird eine Zahl groesser als die
--- Anzahl der vorhandenen Ebenen angegeben, wird die Eingabe intern auf die hoechste Ebenennummer gesetzt.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPTramTrackChangeAppearance(tramTrackId, appearanceLevel) end

--       ==========================================================
-- Verfuegbar ab EEP 18.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPTramTrackChangeAppearance(Strassenbahngleis-ID, Ebenennummer)
--   ok = EEPTramTrackChangeAppearance(87, 3)

-- === EEPAuxiliaryTrackChangeAppearance() ==========================================================================
---Aendert die Ebene eines Weg-Elementes der Kategorie "Sonstige" mit mehreren Ebenen und damit die Oberflaeche des
---Weges.
---@param auxiliaryTrackId number parameter ist die ID des Weges der Kategorie "Sonstige", dessen Ebene geaendert
--- werden soll.
---@param appearanceLevel number parameter ist die Nummer der gewuenschten Ebene. Wird eine Zahl groesser als die
--- Anzahl der vorhandenen Ebenen angegeben, wird die Eingabe intern auf die hoechste Ebenennummer gesetzt.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPAuxiliaryTrackChangeAppearance(auxiliaryTrackId, appearanceLevel) end

--       ====================================================================
-- Verfuegbar ab EEP 18.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPAuxiliaryTrackChangeAppearance(Weg-ID, Ebenennummer)
--   ok = EEPAuxiliaryTrackChangeAppearance(87, 3)

-- === EEPSetCamera() ===============================================================================================
---Waehlt eine der gespeicherten Kameras aus der Liste.
---@alias EEPCameraType
---| 0 # Statisch
---| 1 # Dynamisch
---| 2 # Mobile Kamera
---@param cameraType EEPCameraType parameter ist der Kameratyp.
---@param cameraName string parameter ist der Name der Kamera als String
---@return boolean ok rueckgabewert ist true, wenn die Kamera existiert, andernfalls false.
function EEPSetCamera(cameraType, cameraName) end

--       ====================================
-- Verfuegbar ab EEP 11.3 - Plugin 3.
-- Beispielaufrufe:
--   EEPSetCamera(Typ, "Kameraname")
--   ok = EEPSetCamera(0, "Bahnhof")

-- === EEPSetCameraPosition() =======================================================================================
---Definiert die Position der aktuellen Kamera
---@param posX number parameter definiert die Kameraposition X in Metern.
---@param posY number parameter definiert die Kameraposition Y in Metern.
---@param posZ number parameter definiert die Kameraposition Z in Metern.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPSetCameraPosition(posX, posY, posZ) end

--       ======================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPSetCameraPosition(Pos_X, Pos_Y, Pos_Z)
--   ok = EEPSetCameraPosition(3, 4, 5)

-- === EEPGetCameraPosition() =======================================================================================
---Ermittelt die Position der aktuellen Kamera
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
---@return number posX rueckgabewert ist die Kameraposition X in Metern.
---@return number posY rueckgabewert ist die Kameraposition Y in Metern.
---@return number posZ rueckgabewert ist die Kameraposition Z in Metern.
function EEPGetCameraPosition() end

--       ======================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Bemerkungen:
--   Achtung: Nach EEPSetCameraPosition() liefert EEPGetCameraPosition() fruehestens im naechsten Zyklus der
--   EEPMain() die neu gesetzten Werte.
-- Beispielaufrufe:
--   EEPGetCameraPosition()
--   ok, Pos_X, Pos_Y, Pos_Z = EEPGetCameraPosition()

-- === EEPSetCameraRotation() =======================================================================================
---Definiert die Ausrichtung der aktuellen Kamera
---@param rotX number parameter definiert die Kameraausrichtung um die X-Achse in Grad.
---@param rotY number parameter definiert die Kameraausrichtung um die Y-Achse in Grad.
---@param rotZ number parameter definiert die Kameraausrichtung um die Z-Achse. in Grad
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPSetCameraRotation(rotX, rotY, rotZ) end

--       ======================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPSetCameraRotation(Rot_X, Rot_Y, Rot_Z)
--   ok = EEPSetCameraRotation(30, 45, 25)

-- === EEPGetCameraRotation() =======================================================================================
---Ermittelt die Ausrichtung der aktuellen Kamera.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
---@return number rot_X rueckgabewert ist die Kameraausrichtung um die X-Achse in Grad.
---@return number rot_Y rueckgabewert ist die Kameraausrichtung um die Y-Achse in Grad.
---@return number rot_Z rueckgabewert ist die Kameraausrichtung um die Z-Achse in Grad.
function EEPGetCameraRotation() end

--       ======================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Bemerkungen:
--   Achtung: Nach EEPSetCameraRotation() liefert EEPGetCameraRotation() fruehestens im naechsten Zyklus der
--   EEPMain() die neu gesetzten Werte.
-- Beispielaufrufe:
--   EEPGetCameraRotation()
--   ok, Rot_X, Rot_Y, Rot_Z = EEPGetCameraRotation()

-- === EEPSetPerspectiveCamera() ====================================================================================
---Waehlt eine der Verfolger-Kameras fuer den angegebenen "Fahrzeugverband".
---@overload fun(cameraPosition: number): boolean
---@param cameraPosition number parameter ist die Kameraposition - entspricht den Tasten 1 bis 9 fuer Kameraauswahl
--- (ab EEP 16.4 Plugin 4 auch der Taste 0): 1 = direkt auf die linke Seite des Fahrzeugverbandes, 2 = direkt auf die
--- rechte Seite des Fahrzeugverbandes, 3 = seitlich von oben auf die linke Seite des Fahrzeugverbandes, 4 = seitlich
--- von oben auf die rechte Seite des Fahrzeugverbandes, 5 = von der Front des Fahrzeugverbandes in Fahrtrichtung, 6
--- = von vorn auf die Front des Fahrzeugverbandes, 7 = aktiviert diejenige automatische Kamera, die dem
--- ausgewaehlten "Fahrzeugverband" (z.B. einem Zug) am naechsten steht, 8 = aus dem Fuehrerstand, 9 = oberhalb des
--- Fahrzeugverbandes in oder gegen die Fahrtrichtung bzw. wenn vorhanden die vom Konstrukteur (ausserhalb des
--- Fuehrerstands) vorgegebene Mitfahrkamera bzw. wenn definiert die letzte vom Benutzer mit
--- EEPRollingstockSetUserCamera() definierte Kameraposition. ab EEP 16.4 Plugin 4: 10 = Perspektive der "alten
--- Kabine" (entspricht Taste 0) (ggf. andere Perspektive als bei 8).
---@param trainName? string parameter ist der Name des Fahrzeugverbandes (mit vorangestelltem #- Zeichen) als String.
--- Ab EEP 15 kann der 2. Parameter weggelassen werden. Dann wird die Mitfahrkamera auf den aktiven "Fahrzeugverband"
--- ausgerichtet.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, andernfalls false.
function EEPSetPerspectiveCamera(cameraPosition, trainName) end

--       ==================================================
-- Verfuegbar ab EEP 11.3; EEP 15; EEP 16.4 - Plugin 4.
-- Bemerkungen:
--   Achtung: Wenn bei einem Fahrzeugverband mit mehr als 1 Fahrzeug ein Fuehrerstand mit EEPSetPerspectiveCamera(8)
--   [oder (10)] aufgerufen werden soll, aber derzeit ein anderes Fahrzeug im Verband aktiv (im Handbetrieb) ist, so
--   muss vorher unbedingt das Fahrzeug mit dem Fuehrerstand mit EEPRollingstockSetActive() aktiviert werden.
-- Beispielaufrufe:
--   EEPSetPerspectiveCamera(Kameraposition [, "#Name")
--   ok = EEPSetPerspectiveCamera(3,"#Personenzug")
--   ab EEP15:
--   ok = EEPSetPerspectiveCamera(6)
--   ab EEP 16 Plugin 4:
--   ok = EEPSetPerspectiveCamera(10)

-- === EEPGetPerspectiveCamera() ====================================================================================
---Gibt an, welche Verfolger-Kamera fuer den angegebenen bzw. aktiven "Fahrzeugverband" ausgewaehlt ist.
---@alias EEPPerspectiveCameraPosition
---| 1 # Direkt auf die linke Seite des Fahrzeugverbandes
---| 2 # Direkt auf die rechte Seite des Fahrzeugverbandes
---| 3 # Seitlich von oben auf die linke Seite des Fahrzeugverbandes
---| 4 # Seitlich von oben auf die rechte Seite des Fahrzeugverbandes
---| 5 # Von der Front des Fahrzeugverbandes in Fahrtrichtung
---| 6 # Von vorn auf die Front des Fahrzeugverbandes
---| 7 # Automatische Kamera am naechsten zum Fahrzeugverband
---| 8 # Aus dem Fuehrerstand
---| 9 # Oberhalb des Fahrzeugverbandes oder User-Kamera
---| 10 # Perspektive der alten Kabine
---@param trainName? string optionale Parameter ist der Name des Fahrzeugverbandes (mit vorangestelltem #-Zeichen)
--- als String. Ohne Namensangabe wird die auf den aktiven "Fahrzeugverband" ausgerichtete Mitfahrkamera als 2.
--- Rueckgabewert ausgewiesen.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, andernfalls false.
---@return EEPPerspectiveCameraPosition richtung rueckgabewert ist die Kameraposition.
function EEPGetPerspectiveCamera(trainName) end

--       ==================================
-- Verfuegbar ab EEP 18.0.
-- Beispielaufrufe:
--   EEPGetPerspectiveCamera(["#Zugname")
--   ok, Kameraposition = EEPGetPerspectiveCamera("#Personenzug")
--   ok, Kameraposition = EEPGetPerspectiveCamera()

-- === EEPRollingstockSetUserCamera() ===============================================================================
---Definiert die Position der User-definierten Mitfahrkamera [Aufruf ueber Taste 9 oder EEPSetPerspectiveCamera(9,
---"#Name") bzw. EEPSetPerspectiveCamera(9). Ab EEP 17.1 Plugin 1 auch direkt durch zusaetzlichen Parameter.]
---@param rollingstockName string parameter ist der komplette Name des Rollmaterials als String.
---@param posX number parameter ist die Kameraposition auf der X-Achse (gruen) in Meter in Relation zum Nullpunkt des
--- Fahrzeugs (positiv nach vorne).
---@param posY number parameter ist die Kameraposition auf der Y-Achse (rot) in Meter in Relation zum Nullpunkt des
--- Fahrzeugs (positiv nach rechts).
---@param posZ number parameter ist die Kameraposition auf der Z-Achse (blau) in Meter in Relation nach oben).
---@param rotH number parameter ist die horizontale Kameraausrichtung (Drehung) um die Z- Achse (blauer Kreis) in
--- Grad von 0 bis 359.9 (Blick nach hinten = 0.0, weiter gegen den Uhrzeigersinn).
---@param rotV number parameter ist die vertikale Kameraausrichtung (Drehung) um die Y-Achse (roter Kreis) in Grad
--- von 0 bis 359.9 (Blick nach unten = 0.0, weiter im Uhrzeigersinn).
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPRollingstockSetUserCamera(rollingstockName, posX, posY, posZ, rotH, rotV) end

--       ============================================================================
-- Verfuegbar ab EEP 16.1 - Plugin 1; EEP 17.1 - Plugin 1.
-- Bemerkungen:
--   Ab EEP 17.1 Plugin 1 bewirkt ein optionaler 7. Parameter mit dem Wert 1, dass die Kameraeinstellung sofort
--   uebernommen wird. Ohne den 7. Parameter [Default] werden nur die Werte definiert. Zur Ausfuehrung ist dann die
--   Betaetigung des Taste 9 oder im Lua-Skript die Funktion EEPSetPerspectiveCamera(9, "#Name") bzw.
--   EEPSetPerspectiveCamera(9) erforderlich.
--   Eine Drehung um die X-Achse (gruener Kreis) und damit der Blick einer liegenden Person ist aus technischen
--   Gruenden nicht moeglich.
--   Wichtig: Bei mehr als 1 Fahrzeug im Fahrzeugverband ist folgendes unbedingt zu beachten: Soll die Kamera sich
--   auf ein anderes als das vorderste Fahrzeug im Fahrzeugverband beziehen, so muss unbedingt dieses Fahrzeug mit
--   EEPRollingstockSetActive() vorher aktiviert werden. Ansonsten reagiert EEP nicht auf die folgenden
--   Kameraeinstellungen. Es empfiehlt sich allerdings - fuer eine immer gleiche Handlungsweise - dies auch auf das
--   vorderste Fahrzeug anzuwenden. Da sich bei einem Fahrtrichtungswechsel das vorderste Fahrzeug aendert, wechselt
--   EEP eigenstaendig in bestimmte vordefinierte Kamerapositionen. Ist dies nicht gewuenscht, muss man in der
--   gleichen Funktion [vor oder nach dem Befehl EEPSetTrainSpeed()] unbedingt das fuer die Kameraposition nach dem
--   Wechsel verantwortliche Fahrzeug mit EEPRollingstockSetActive() aktivieren und die Kameraposition mit
--   EEPSetPerspectiveCamera(9, "#Name") neu setzen. Hierbei ist es egal, ob es dasselbe (wie vorher) oder ein
--   anderes, neues Fahrzeug ist. Bei demselben Fahrzeug ist eine erneute Definition der Position mit
--   EEPRollingstockSetUserCamera() nicht erforderlich. Fortsetzung naechste Seite Soll nach einer mit
--   EEPRollingstockSetUserCamera() definierten Kamerafahrt mit EEPSetPerspectiveCamera(8 [,"#Name"]) oder
--   EEPSetPerspectiveCamera(10 [,"#Name"]) eine Fuehrerstandsmitfahrt erfolgen und das fuer die User-Camera
--   definierte Fahrzeug ist nicht das vorderste, so muss vorher das vorderste Fahrzeug mit
--   EEPRollingstockSetActive() aktiviert werden [siehe auch EEPSetPerspectiveCamera()].
-- Beispielaufrufe:
--   EEPRollingstockSetUserCamera("Fahrzeugname", Pos_X, Pos_Y, Pos_Z, Rot_H, Rot_V[, 1])
--   ok = EEPRollingstockSetUserCamera("Salonwagen", -4, 0, 2, 180, 90, 1) - sofortige Ausfuehrung
--   ok = EEPRollingstockSetUserCamera("Salonwagen", -4, 0, 2, 180, 90) - nur Definition

-- === EEPRollingstockGetUserCamera() ===============================================================================
---Ermittelt (wenn vorhanden) die Position der vom Konstrukteur (ausserhalb des Fuehrerstands) vorgegebenen
---Mitfahrkamera bzw. vorrangig die vom User mit EEPRollingstockSetUserCamera() definierte Mitfahrkamera.
---@param rollingstockName string parameter ist der komplette Name des Rollmaterials als String.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
---@return number posX rueckgabewert ist die Kameraposition auf der X-Achse in Meter in Relation zum Nullpunkt des
--- Fahrzeugs.
---@return number posY rueckgabewert ist die Kameraposition auf der Y-Achse in Meter
---@return number posZ rueckgabewert ist die Kameraposition auf der Z-Achse in Meter
---@return number rotH rueckgabewert ist die horizontale Kameraausrichtung (Drehung) um die Z- Achse in Grad in
--- Relation zum Fahrzeug.
---@return any rotV rueckgabewert ist die vertikale Kameraausrichtung (Drehung) um die Y-
function EEPRollingstockGetUserCamera(rollingstockName) end

--       ==============================================
-- Verfuegbar ab EEP 17.
-- Bemerkungen:
--   Achtung: Diese Funktion ermittelt nicht die Position der anderen in EEP vorhandenen Verfolger-Kameras.
-- Beispielaufrufe:
--   EEPRollingstockGetUserCamera("Fahrzeugname")
--   ok, Pos_X, Pos_Y, Pos_Z, Rot_H, Rot_V = EEPRollingstockGetUserCamera("Salonwagen")

-- === EEPLoadProject() =============================================================================================
---Laedt eine Anlage aus dem Ordner "Resourcen\Anlagen" oder dem unter Programmeinstellungen eingetragenen
---Anlagenordner bzw. deren Unterordnern.
---@param projectPath string parameter ist der Unterordner (wenn erforderlich) und der Dateiname einschliesslich
--- ".anl3"-Suffix. Trennzeichen zwischen Ordner- und Dateiname ist entweder ein einfacher Schraegstrich oder ein
--- doppelter Backslash.
---@return boolean ok rueckgabewert ist true, wenn die Anlage existiert, andernfalls false.
function EEPLoadProject(projectPath) end

--       ===========================
-- Verfuegbar ab EEP 11.3 - Plugin 3.
-- Beispielaufrufe:
--   EEPLoadProject("[Unterordner /|\\ ] Dateiname")
--   ok = EEPLoadProject("MeineAnlage.anl3")
--   ok = EEPLoadProject("Tutorials/Tutorial_49_LUA.anl3")
--   ok = EEPLoadProject("Tutorials\\Tutorial_54_LUA.anl3")

-- === EEPOnSaveAnl() ===============================================================================================
---EEP ruft selbstaendig diese Funktion waehrend der Speicherung auf und liefert im selbstgewaehlten Parameter den
---Pfad, in dem die Anlage gespeichert wurde.
---@param projectPath string parameter ist der Speicherpfad der Anlage einschliesslich Dateiname als String. Eine
--- selbst definierte Variable in den Funktionsklammern nimmt diesen Wert fuer die weitere Verwendung auf.
function EEPOnSaveAnl(projectPath) end

--       =========================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Bemerkungen:
--   EEP erwartet bei Aufruf dieser Funktion keinen Rueckgabewert.
--   Achtung: Diese Funktion eignet sich nicht fuer Festlegungen, was vor dem Speichern zu tun ist. Dies kann in der
--   Funktion EEPOnBeforeSaveAnl() erfolgen.
-- Beispielaufrufe:
--   EEPOnSaveAnl(Anlagenpfad)
--   function EEPOnSaveAnl(Anlagenpfad)
--   print("Die Anlage wurde unter "..Anlagenpfad.." gespeichert!")
--   end

-- === EEPOnBeforeSaveAnl() =========================================================================================
---EEP ruft selbstaendig diese Funktion vor jeder Speicherung auf. In der Funktion kann man festlegen, was vor dem
---Speichern der Anlage zu tun ist.
function EEPOnBeforeSaveAnl() end

--       ====================
-- Verfuegbar ab EEP 17.
-- Bemerkungen:
--   Der Funktionsaufruf durch EEP erfolgt ohne Parameter.
--   EEP erwartet bei Aufruf dieser Funktion keinen Rueckgabewert.
-- Beispielaufrufe:
--   EEPOnBeforeSaveAnl()
--   function EEPOnBeforeSaveAnl()
--   EEPSaveData(1, "Lua macht's moeglich!")
--   end

-- === EEPGetAnlVer() ===============================================================================================
---Liefert die EEP-Version, mit der die Anlage zuletzt gespeichert wurde.
---@return number anlagenversion rueckgabewert ist dieVersionsnummer von EEP, in der die Anlage zuletzt gespeichert
--- wurde. Er ist sofort nach jeder Speicherung aktuell.
function EEPGetAnlVer() end

--       ==============
-- Verfuegbar ab EEP 17.
-- Bemerkungen:
--   Der Funktionsaufruf durch EEP erfolgt ohne Parameter.
-- Beispielaufrufe:
--   EEPGetAnlVer()
--   Anlagenversion = EEPGetAnlVer()
--   print(Die Anlage wurde zuletzt vor dem Oeffnen in EEP ", Anlagenversion, " gespeichert")

-- === EEPGetAnlLng() ===============================================================================================
---Liefert die auf Achsnamen bezogene "Anlagensprache". Diese wird mit dem ersten Einsetzen eines Modells mit Achsen
---von EEP vergeben und aendert sich danach nicht mehr. Solange noch kein Modell mit Achsen eingesetzt wurde,
---entspricht diese "Anlagensprache" der Sprache der aktuellen EEP-Version, d.h. der EEP-spezifischen Variablen
---EEPLng.
---@return string anlagensprache rueckgabewert ist das Kuerzel fuer die in Bezug auf Achsnamen vergebene
--- "Anlagensprache" (Definition siehe oben unter Zweck): GER = deutsche Version ENG = englische Version FRA =
--- franzoesische Version
function EEPGetAnlLng() end

--       ==============
-- Verfuegbar ab EEP 17.
-- Bemerkungen:
--   Der Funktionsaufruf durch EEP erfolgt ohne Parameter.
-- Beispielaufrufe:
--   EEPGetAnlLng()
--   Anlagensprache = EEPGetAnlLng()
--   if Anlagensprache == "GER" then
--   print("Die Anlagensprache in Bezug auf Achsen ist deutsch.")
--   elseif Anlagensprache == "ENG" then
--   print("Die Anlagensprache in Bezug auf Achsen ist englisch.")
--   elseif Anlagensprache == "FRA" then
--   print("Die Anlagensprache in Bezug auf Achsen ist franzoesisch.")
--   end

-- === EEPGetAnlName() ==============================================================================================
---Liefert den Namen mit dem die Anlage zuletzt gespeichert wurde.
---@return string name rueckgabewert ist der Anlagenname als String.
function EEPGetAnlName() end

--       ===============
-- Verfuegbar ab EEP 17.1 - Plugin 1.
-- Bemerkungen:
--   Der Funktionsaufruf durch EEP erfolgt ohne Parameter.
-- Beispielaufrufe:
--   EEPGetAnlName()
--   Name = EEPGetAnlName()
--   print("Willkommen in der Anlage ", Name)

-- === EEPGetAnlPath() ==============================================================================================
---Liefert den Speicherpfad der Anlagendatei (.anl3) ohne den Dateinamen zurueck. Hierdurch koennen z.B. im
---Anlagenordner gespeicherte Lua-Dateien in die Anlagen- Lua-Datei eingebunden werden.
---@return string pfad rueckgabewert ist der Pfad der Anlagendatei (ohne dessen Name) als String.
function EEPGetAnlPath() end

--       ===============
-- Verfuegbar ab EEP 18.1 - Plugin 1.
-- Bemerkungen:
--   Der Funktionsaufruf durch EEP erfolgt ohne Parameter.
-- Beispielaufrufe:
--   EEPGetAnlPath()
--   Pfad = EEPGetAnlPath()
--   dofile(Pfad.."\\Dateiname.lua")

-- === EEPGetTrainFromTrainyard() ===================================================================================
---Schickt einen ausgewaehlten "Fahrzeugverband" aus einem ausgewaehlten virtuellen Depot.
---@alias EEPTrainyardDepartureOrientation
---| 0 # Wie im Depot vorgegeben
---| 1 # Vorwaerts
---| 2 # Rueckwaerts
---| 3 # Entgegengesetzt zur Depotvorgabe
---@overload fun(depotId: number, trainName: string, depotSlot: number): boolean
---@param depotId number parameter ist die ID des virtuellen Depots. Sie steht in der Kopfzeile des
--- Eigenschaftenfensters.
---@param trainName string parameter ist der Name des Fahrzeugverbandes mit vorangestelltem #- Zeichen als String.
--- Wird ein Leerstring als Name angegeben, dann bestimmt der 3. Parameter den "Fahrzeugverband".
---@param depotSlot number parameter ist der Listenplatz des Fahrzeugverbandes im Depot. Dieser Parameter gilt nur,
--- wenn kein Name angegeben ist. Bei vorgegebenem Namen ist diese Zahl beliebig, aber dennoch erforderlich. In dem
--- Fall setzt man ihn am besten auf 0.
---@param departureOrientation? EEPTrainyardDepartureOrientation optionale 4. Parameter bestimmt die Ausrichtung des
--- Zuges beim Ausfahren aus dem Depot.
---@return boolean ok rueckgabewert ist true, wenn das Depot und der angeforderte "Fahrzeugverband" existieren,
--- andernfalls false.
function EEPGetTrainFromTrainyard(depotId, trainName, depotSlot, departureOrientation) end

--       =============================================================================
-- Verfuegbar ab EEP 11.3 - Plugin 2; EEP 15.
-- Beispielaufrufe:
--   EEPGetTrainFromTrainyard(Depot_ID, "#Name", Listenplatz [, Fahrtrichtung])
--   ok = EEPGetTrainFromTrainyard(1, "#Rheingold", 0)
--   ok = EEPGetTrainFromTrainyard(2, "", 4, 1)

-- === EEPOnTrainExitTrainyard() ====================================================================================
---Wird immer dann aufgerufen, wenn ein "Fahrzeugverband" ein virtuelles Depot verlaesst.
---@param depotId number uebertraegt EEP die ID des virtuellen Depots, aus dem etwas ausgefahren ist.
---@param trainName string uebertraegt EEP den Namen des ausfahrenden "Fahrzeugverbands".
function EEPOnTrainExitTrainyard(depotId, trainName) end

--       ===========================================
-- Verfuegbar ab EEP 14.1 - Plugin 1.
-- Bemerkungen:
--   Zwei selbst definierte Variablen in den Funktionsklammern nehmen fuer die weitere Verarbeitung folgende Werte
--   auf:
--   EEP erwartet bei Aufruf dieser Funktion keinen Rueckgabewert.
-- Beispielaufrufe:
--   EEPOnTrainExitTrainyard(Depot_ID, Name)
--   function EEPOnTrainExitTrainyard(Depot_ID, Name)
--   print(Name.." hat Depot "..Depot_ID.." verlassen")
--   end

-- === EEPOnTrainEnterTrainyard() ===================================================================================
---Wird immer dann aufgerufen, wenn ein "Fahrzeugverband" in ein virtuelles Depot einfaehrt.
---@param depotId number uebertraegt EEP die ID des virtuellen Depots, in das etwas eingefahren ist.
---@param trainName string uebertraegt EEP den Namen des eingefahrenen "Fahrzeugverbands".
function EEPOnTrainEnterTrainyard(depotId, trainName) end

--       ============================================
-- Verfuegbar ab EEP 18.1 - Plugin 1.
-- Bemerkungen:
--   Zwei selbst definierte Variablen in den Funktionsklammern nehmen fuer die weitere Verarbeitung folgende Werte
--   auf:
--   EEP erwartet bei Aufruf dieser Funktion keinen Rueckgabewert.
-- Beispielaufrufe:
--   EEPOnTrainEnterTrainyard(DepotID, Name)
--   function EEPOnTrainEnterTrainyard(DepotID, Name)
--   print(Name.." ist in Depot "..DepotID.." eingefahren")
--   end

-- === EEPGetTrainyardItemsCount() ==================================================================================
---Liefert die Anzahl der im virtuellen Depot gefuehrten "Fahrzeugverbaende"
---@param depotId number parameter ist die ID des virtuellen Depots. Sie steht in der Kopfzeile des
--- Eigenschaftenfensters.
---@return number count rueckgabewert ist die Anzahl der gemeldeten "Fahrzeugverbaende" im Depot. Achtung: Dies
--- entspricht nicht der Anzahl wartender (anwesender) "Fahrzeugverbaende". Diese muss mit Hilfe der Funktion
--- EEPGetTrainyardItemStatus() ermittelt werden.
function EEPGetTrainyardItemsCount(depotId) end

--       ==================================
-- Verfuegbar ab EEP 13.2 - Plugin 2.
-- Beispielaufrufe:
--   EEPGetTrainyardItemsCount(Depot-ID)
--   Anzahl = EEPGetTrainyardItemsCount(2)

-- === EEPGetTrainyardItemName() ====================================================================================
---Liefert den Namen eines "Fahrzeugverbands" im virtuellen Depot
---@param depotId number parameter ist die ID des virtuellen Depots. Sie steht in der Kopfzeile des
--- Eigenschaftenfensters.
---@param depotSlot number parameter ist die Position in der Depotliste.
---@return string name rueckgabewert ist der Name des "Fahrzeugverbands" an der angegebenen Position.
function EEPGetTrainyardItemName(depotId, depotSlot) end

--       ===========================================
-- Verfuegbar ab EEP 13.2 - Plugin 2.
-- Beispielaufrufe:
--   EEPGetTrainyardItemName(Depot-ID, Listenplatz)
--   Name = EEPGetTrainyardItemName(3, 5)

-- === EEPGetTrainyardItemStatus() ==================================================================================
---Liefert den Status eines "Fahrzeugverbands" im virtuellen Depot
---@alias EEPTrainyardItemStatus
---| 0 # In Fahrt
---| 1 # Im Depot wartend
---@param depotId number parameter ist die ID des virtuellen Depots. Sie steht in der Kopfzeile des
--- Eigenschaftenfensters.
---@param trainName string parameter ist der Name des "Fahrzeugverbands" (mit vorangestelltem #- Zeichen) als String.
--- Wenn er vorgegeben wird, dann ignoriert EEP die Listennummer.
---@param depotSlot string parameter ist die Position in der Depotliste. Wenn an zweiter Stelle ein Leerstring als
--- Name angegeben wird, dann zaehlt der Listenplatz. Aber er ist auch dann Pflicht, wenn ein Name mitgegeben wird.
--- In dem Fall setzt man ihn am besten auf 0.
---@return EEPTrainyardItemStatus status rueckgabewert ist der Status des "Fahrzeugverbands".
function EEPGetTrainyardItemStatus(depotId, trainName, depotSlot) end

--       ========================================================
-- Verfuegbar ab EEP 13.2 - Plugin 2.
-- Beispielaufrufe:
--   EEPGetTrainyardItemStatus(Depot-ID, "#Name", Listenplatz)
--   Status = EEPGetTrainyardItemStatus(1, "#Gueterzug",0)
--   Status = EEPGetTrainyardItemStatus(1, "", 3)
--   if EEPGetTrainyardItemStatus(3, "#Rheingold", 0) == 1 then
--   print("Der Zug wartet im Depot!")
--   else
--   print("Der Zug ist bereits ausgefahren!")
--   endif

-- === EEPIsTrainInTrainyard() ======================================================================================
---Gibt die Nummer des virtuellen Depots zurueck, in dem sich der "Fahrzeugverband" befindet, oder die Zahl Null,
---wenn er sich in der Anlage befindet.
---@param trainName string parameter ist der Name des " Fahrzeugverbandes", dessen Aufenthaltsort ermittelt werden
--- soll.
---@return boolean ok rueckgabewert ist true, wenn der "Fahrzeugverband" existiert, oder false, wenn nicht.
---@return number depotID rueckgabewert ist die Nummer des virtuellen Depots in dem sich der "Fahrzeugverband"
--- befindet oder 0, wenn er sich in der Anlage befindet. Ein Rueckgabewert von -1 bedeutet, dass der
--- "Fahrzeugverband" auf der Anlage existiert, aber in keinem Depot registriert ist.
function EEPIsTrainInTrainyard(trainName) end

--       ================================
-- Verfuegbar ab EEP 18.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPIsTrainInTrainyard(Name)
--   ok, DepotID = EEPIsTrainInTrainyard("#Rheingold")

-- === EEPPutTrainToTrainyard() =====================================================================================
---Verschiebt einen "Fahrzeugverband" oder alle dort registrierten in ein virtuelles Depot.
---@param depotId number parameter ist die ID des virtuellen Depots. Sie steht in der Kopfzeile des
--- Eigenschaftenfensters.
---@param trainName string parameter ist der Name des "Fahrzeugverbands", der in das ausgewaehlte Depot verschoben
--- werden soll. (Wichtig: Der "Fahrzeugverband" muss dort zuvor registriert sein.) Bei Eingabe eines Leerstrings
--- ("") werden alle dort registrierten "Fahrzeugverbaende" zurueck ins spezifizierte virtuelle Depot verschoben.
---@return boolean ok rueckgabewert ist true, wenn die Funktion erfolgreich war, andernfalls false.
function EEPPutTrainToTrainyard(depotId, trainName) end

--       ==========================================
-- Verfuegbar ab EEP 18.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPPutTrainToTrainyard(DepotID, Name)
--   ok = EEPPutTrainToTrainyard(3, "#Rheingold")
--   ok = EEPPutTrainToTrainyard(3, "")

-- === EEPChangeInfoStructure() =====================================================================================
---Weist dem Tipp-Text einer Immobilie oder eines Landschaftselements einen neuen Text zu
---@param luaName string parameter ist der Lua-Name der Immobilie bzw. des Landschaftselements als String. Er steht
--- in den Objekteigenschaften und unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die
--- Nummer mit vorangestelltem #-Zeichen als Identifikator.
---@param text string parameter ist der gewuenschte Text. Zeilenumbruch mit \n
---@return boolean ok rueckgabewert ist true, wenn die Immobilie bzw. das Landschaftselement existiert, sonst false.
function EEPChangeInfoStructure(luaName, text) end

--       =====================================
-- Verfuegbar ab EEP 13.
-- Beispielaufrufe:
--   EEPChangeInfoStructure("#Lua-Name", "Text")
--   ok = EEPChangeInfoStructure("#23", "Lokleitung")

-- === EEPShowInfoStructure() =======================================================================================
---Schaltet den Tipp-Text einer Immobilie oder eines Landschaftselements ein oder aus
---@param luaName string parameter ist der Lua-Name der Immobilie bzw. des Landschaftselements als String. Er steht
--- in den Objekteigenschaften und unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die
--- Nummer mit vorangestelltem #-Zeichen als Identifikator.
---@param visible boolean parameter schaltet den Tipp-Text mit true ein oder mit false aus.
---@return boolean ok rueckgabewert ist true, wenn die Immobilie bzw. das Landschaftselement existiert, sonst false.
function EEPShowInfoStructure(luaName, visible) end

--       ======================================
-- Verfuegbar ab EEP 13.
-- Beispielaufrufe:
--   EEPShowInfoStructure("#Lua-Name", true|false)
--   ok = EEPShowInfoStructure("#23", true)

-- === EEPChangeInfoSignal() ========================================================================================
---Weist dem Tipp-Text eines Signals einen neuen Text zu
---@param signalId number parameter ist die Signal-ID.
---@param text string parameter ist der gewuenschte Text. Zeilenumbruch mit \n
---@return boolean ok rueckgabewert ist true, wenn das spezifizierte Signal existiert, sonst false.
function EEPChangeInfoSignal(signalId, text) end

--       ===================================
-- Verfuegbar ab EEP 13.
-- Beispielaufrufe:
--   EEPChangeInfoSignal(Signal-ID, "Text")
--   ok = EEPChangeInfoSignal(74, "Ausfahrsignal Gleis 2")

-- === EEPShowInfoSignal() ==========================================================================================
---Schaltet den Tipp-Text eines Signals ein oder aus
---@param signalId number parameter ist die Signal-ID
---@param visible boolean parameter schaltet den Tipp-Text mit true ein oder mit false aus.
---@return boolean ok rueckgabewert ist true, wenn das spezifizierte Signal existiert, sonst false.
function EEPShowInfoSignal(signalId, visible) end

--       ====================================
-- Verfuegbar ab EEP 13.
-- Beispielaufrufe:
--   EEPShowInfoSignal(Signal-ID, true|false)
--   ok = EEPShowInfoSignal(74, true)

-- === EEPChangeInfoSwitch() ========================================================================================
---Weist dem Tipp-Text einer Weiche einen neuen Text zu
---@param switchId number parameter ist die Weichen-ID.
---@param text string parameter ist der gewuenschte Text. Zeilenumbruch mit \n
---@return boolean ok rueckgabewert ist true, wenn die spezifizierte Weiche existiert, sonst false.
function EEPChangeInfoSwitch(switchId, text) end

--       ===================================
-- Verfuegbar ab EEP 13.
-- Beispielaufrufe:
--   EEPChangeInfoSwitch(Weichen-ID, "Text")
--   Text = "Abzweig nach\nHintertupfingen"
--   ok = EEPChangeInfoSwitch(63, Text)

-- === EEPShowInfoSwitch() ==========================================================================================
---Schaltet den Tipp-Text einer Weiche ein oder aus
---@param switchId number parameter ist die Weichen-ID
---@param visible boolean parameter schaltet den Tipp-Text mit true ein oder mit false aus.
---@return boolean ok rueckgabewert ist true, wenn die spezifizierte Weiche existiert, sonst false.
function EEPShowInfoSwitch(switchId, visible) end

--       ====================================
-- Verfuegbar ab EEP 13.
-- Beispielaufrufe:
--   EEPShowInfoSwitch(Weichen-ID, true|false)
--   ok = EEPShowInfoSwitch(63, true)

-- === EEPShowInfoTextTop() =========================================================================================
---Erzeugt einen Infotext am oberen Bildrand des 3D-Fensters
---@alias EEPInfoTextAlignment
---| 0 # Blocksatz
---| 1 # Zentriert
---| 2 # Linksbuendig
---| 3 # Rechtsbuendig
---@param red number die ersten 3 Parameter bestimmen die Farbe aus den Anteilen fuer rot, gruen und blau.
---@param green number die ersten 3 Parameter bestimmen die Farbe aus den Anteilen fuer rot, gruen und blau.
---@param blue number die ersten 3 Parameter bestimmen die Farbe aus den Anteilen fuer rot, gruen und blau.
---@param textSize string parameter bestimmt die Textgroesse (von 0.5 bis 2-fach).
---@param seconds number parameter bestimmt die Anzeigedauer in Sekunden. Minimum 5 Sekunden.
---@param alignment EEPInfoTextAlignment parameter bestimmt die Textausrichtung.
---@param text string parameter ist der anzuzeigende Text. Zeilenumbruch mit \n.
---@return boolean ok rueckgabewert ist true, wenn die Funktion erfolgreich ausgefuehrt wurde, sonst false.
function EEPShowInfoTextTop(red, green, blue, textSize, seconds, alignment, text) end

--       ========================================================================
-- Verfuegbar ab EEP 13.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPShowInfoTextTop(r, g, b, sz, t, j, "Text")
--   r = 1 -- Rot
--   g = 1 -- Gruen
--   b = 1 -- Blau
--   S = 1 -- Schriftgroesse
--   Z = 10 -- Zeit
--   A = 1 -- Ausrichtung
--   Text = "Weiss oben zentriert fuer 10 Sekunden"
--   ok = EEPShowInfoTextTop(r,g,b,S,Z,A,Text)

-- === EEPShowInfoTextBottom() ======================================================================================
---Erzeugt einen Infotext am unteren Bildrand des 3D-Fensters
---@param red number die ersten 3 Parameter bestimmen die Farbe aus den Anteilen fuer rot, gruen und blau.
---@param green number die ersten 3 Parameter bestimmen die Farbe aus den Anteilen fuer rot, gruen und blau.
---@param blue number die ersten 3 Parameter bestimmen die Farbe aus den Anteilen fuer rot, gruen und blau.
---@param textSize string parameter bestimmt die Textgroesse (von 0.5 bis 2-fach).
---@param seconds number parameter bestimmt die Anzeigedauer in Sekunden. Minimum 5 Sekunden.
---@param alignment EEPInfoTextAlignment parameter bestimmt die Textausrichtung.
---@param text string parameter ist der anzuzeigende Text. Zeilenumbruch mit \n.
---@return boolean ok rueckgabewert ist true, wenn die Funktion erfolgreich ausgefuehrt wurde, sonst false.
function EEPShowInfoTextBottom(red, green, blue, textSize, seconds, alignment, text) end

--       ===========================================================================
-- Verfuegbar ab EEP 13.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPShowInfoTextBottom(r, g, b, sz, t, j, "Text")
--   r = 1 -- Rot
--   g = 1 -- Gruen
--   b = 0 -- Blau
--   S = 0.75 -- Schriftgroesse
--   Z = 15 -- Zeit
--   A = 2 -- Ausrichtung
--   Text = "Gelb unten linksbuendig fuer 15 Sekunden"
--   ok = EEPShowInfoTextBottom(r,g,b,S,Z,A,Text)

-- === EEPShowScrollInfoTextTop() ===================================================================================
---Erzeugt einen durchlaufenden Infotext am oberen Bildrand des 3D-Fensters
---@param red number die ersten 3 Parameter bestimmen die Farbe aus den Anteilen fuer rot, gruen und blau.
---@param green number die ersten 3 Parameter bestimmen die Farbe aus den Anteilen fuer rot, gruen und blau.
---@param blue number die ersten 3 Parameter bestimmen die Farbe aus den Anteilen fuer rot, gruen und blau.
---@param textSize string parameter bestimmt die Textgroesse (von 0.5 bis 2-fach).
---@param seconds number parameter bestimmt die Anzeigedauer in Sekunden. Minimum 5 Sekunden.
---@param alignment string parameter (fuer die Textausrichtung) ist ohne Wirkung, aber erforderlich. Bitte hier eine
--- Zahl (z.B. 0) eintragen.
---@param scrollSpeed number parameter bestimmt die Laufgeschwindigkeit.
---@param text string parameter ist der anzuzeigende Text.
---@return boolean ok rueckgabewert ist true, wenn die Funktion erfolgreich ausgefuehrt wurde, sonst false.
function EEPShowScrollInfoTextTop(red, green, blue, textSize, seconds, alignment, scrollSpeed, text) end

--       ===========================================================================================
-- Verfuegbar ab EEP 13.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPShowScrollInfoTextTop(r, g, b, sz, t, j, "Text")
--   r = 0 -- Rot
--   g = 1 -- Gruen
--   b = 0.7 -- Blau
--   S = 1.2 -- Schriftgroesse
--   Z = 20 -- Zeit
--   A = 0 -- Ausrichtung
--   G = 0.2 -- Geschwindigkeit
--   Text = "Laufschrift oben in tuerkis fuer 20 Sekunden"
--   ok = EEPShowScrollInfoTextTop(r,g,b,S,Z,A,G,Text)

-- === EEPShowScrollInfoTextBottom() ================================================================================
---Erzeugt einen durchlaufenden Infotext am unteren Bildrand des 3D-Fensters
---@param red number die ersten 3 Parameter bestimmen die Farbe aus den Anteilen fuer rot, gruen und blau.
---@param green number die ersten 3 Parameter bestimmen die Farbe aus den Anteilen fuer rot, gruen und blau.
---@param blue number die ersten 3 Parameter bestimmen die Farbe aus den Anteilen fuer rot, gruen und blau.
---@param textSize string parameter bestimmt die Textgroesse (von 0.5 bis 2-fach).
---@param seconds number parameter bestimmt die Anzeigedauer in Sekunden. Minimum 5 Sekunden.
---@param alignment string parameter (fuer die Textausrichtung) ist ohne Wirkung, aber erforderlich. Bitte hier eine
--- Zahl (z.B. 0) eintragen.
---@param scrollSpeed number parameter bestimmt die Laufgeschwindigkeit.
---@param text string parameter ist der anzuzeigende Text.
---@return boolean ok rueckgabewert ist true, wenn die Funktion erfolgreich ausgefuehrt wurde, sonst false.
function EEPShowScrollInfoTextBottom(red, green, blue, textSize, seconds, alignment, scrollSpeed, text) end

--       ==============================================================================================
-- Verfuegbar ab EEP 13.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPShowScrollInfoTextBottom(r, g, b, sz, t, j, "Text")
--   r = 1 -- Rot
--   g = 0 -- Gruen
--   b = 1 -- Blau
--   S = 0.6 -- Schriftgroesse
--   Z = 10 -- Zeit
--   A = 0 -- Ausrichtung
--   G = 0.1 -- Geschwindigkeit
--   Text = "Laufschrift unten, magenta, 10 Sekunden"
--   ok = EEPShowScrollInfoTextBottom(r,g,b,S,Z,A,G,Text)

-- === EEPHideInfoTextTop() =========================================================================================
---Blendet den Infotext am oberen Bildrand aus.
---@return boolean ok rueckgabewert ist true, wenn die Funktion erfolgreich ausgefuehrt wurde, sonst false.
function EEPHideInfoTextTop() end

--       ====================
-- Verfuegbar ab EEP 13.1 - Plugin 1.
-- Bemerkungen:
--   Diese Funktion benoetigt keine Parameter.
-- Beispielaufrufe:
--   EEPHideInfoTextTop()
--   ok = EEPHideInfoTextTop()

-- === EEPHideInfoTextBottom() ======================================================================================
---Blendet den Infotext am unteren Bildrand aus.
---@return boolean ok rueckgabewert ist true, wenn die Funktion erfolgreich ausgefuehrt wurde, sonst false.
function EEPHideInfoTextBottom() end

--       =======================
-- Verfuegbar ab EEP 13.1 - Plugin 1.
-- Bemerkungen:
--   Diese Funktion benoetigt keine Parameter.
-- Beispielaufrufe:
--   EEPHideInfoTextBottom()
--   ok = EEPHideInfoTextBottom()

-- === EEPPlaySound() ===============================================================================================
---Spielt ortsunabhaengig eine Sounddatei ab.
---@param soundFile string parameter ist der Pfad (relativ zum Ordner Resourcen/Sounds) und der Dateiname einer
--- geeigneten Mono-Wav-Datei als String. Trennzeichen zwischen Ordner- und Dateiname ist entweder ein einfacher
--- Schraegstrich oder ein doppelter Backslash.
---@return boolean ok rueckgabewert ist true, wenn die Funktion erfolgreich ausgefuehrt wurde, sonst false.
function EEPPlaySound(soundFile) end

--       =======================
-- Verfuegbar ab EEP 13 - Plugin 1.
-- Beispielaufrufe:
--   EEPPlaySound(["Pfad/|Pfad\\]Dateiname")
--   ok = EEPPlaySound("siren_polizei.wav")
--   ok = EEPPlaySound("User/Bimmel.wav")
--   ok = EEPPlaySound("EEXP\\Route1.wav")

-- === EEPStructurePlaySound() ======================================================================================
---Schaltet den Ton eines Soundmodells aus der Kategorie Landschaftselemente / Klaenge ein oder aus.
---@param luaName string parameter ist der Lua Name des Soundmodells als String. Er steht in den Objekteigenschaften
--- und unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die Nummer mit vorangestelltem
--- #-Zeichen als Identifikator.
---@param enabled boolean parameter schaltet mit true den Ton ein oder mit false aus.
---@return boolean ok rueckgabewert ist true, wenn die Funktion erfolgreich ausgefuehrt wurde, sonst false.
function EEPStructurePlaySound(luaName, enabled) end

--       =======================================
-- Verfuegbar ab EEP 13 - Plugin 1.
-- Bemerkungen:
--   Wenn dieser Ton ausschliesslich ueber Lua gesteuert werden soll, dann ist es ratsam die Aktivierungsdistanz im
--   Modell auf 0 zu setzen.
-- Beispielaufrufe:
--   EEPStructurePlaySound("#Lua-Name", true|false)
--   ok = EEPStructurePlaySound("#33", true)

-- === EEPStructureSetTextureText() =================================================================================
---Weist einer beschreibbaren Flaeche einer Immobilie oder eines Landschaftselements einen neuen Text zu.
---@param luaName string parameter ist der Lua-Name der Immobilie oder des Landschaftselements als String. Er steht
--- in den Objekteigenschaften und unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die
--- Nummer mit vorangestelltem #- Zeichen als Identifikator.
---@param surfaceNumber string parameter ist die Nummer der Flaeche, welche den Text erhalten soll. Manche Modelle
--- haben mehrere, individuell beschreibbare Flaechen.
---@param text string parameter ist der gewuenschte Text. Zeilenumbruch mit \n.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false
function EEPStructureSetTextureText(luaName, surfaceNumber, text) end

--       ========================================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
--   EEPStructureSetTextureText("#Lua-Name", Flaechennummer,"Text")
--   ok = EEPStructureSetTextureText("#147", 1, "Neustadt")

-- === EEPStructureGetTextureText() =================================================================================
---Liest den Text einer beschreibbaren Flaeche einer Immobilie oder eines Landschaftselements aus.
---@param luaName string parameter ist der Lua-Name der Immobilie oder des Landschaftselements als String. Er steht
--- in den Objekteigenschaften und unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die
--- Nummer mit vorangestelltem #- Zeichen als Identifikator.
---@param surfaceNumber string parameter ist die Nummer der Flaeche, dessen Text ausgelesen werden soll. Manche
--- Modelle haben mehrere, individuell beschreibbare Flaechen.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
---@return string text rueckgabewert ist der Text, mit dem die ausgewaehlte Flaeche beschriftet ist.
function EEPStructureGetTextureText(luaName, surfaceNumber) end

--       ==================================================
-- Verfuegbar ab EEP 17.2 - Plugin 2.
-- Beispielaufrufe:
--   EEPStructureGetTextureText("#Lua-Name", Flaechennummer)
--   ok, Text = EEPStructureGetTextureText("#147", 1)

-- === EEPRollingstockSetTextureText() ==============================================================================
---Weist einer beschreibbaren Flaeche eines Rollmaterials einen neuen Text zu.
---@param rollingstockName string parameter ist der Name des Fahrzeugs als String.
---@param surfaceNumber string parameter ist die Nummer der Flaeche, welche den Text erhalten soll. Manche Modelle
--- haben mehrere, individuell beschreibbare Flaechen.
---@param text string parameter ist der gewuenschte Text. Zeilenumbruch mit \n.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false
function EEPRollingstockSetTextureText(rollingstockName, surfaceNumber, text) end

--       ====================================================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
--   EEPRollingstockSetTextureText("Fahrzeugname", Flaechennummer,"Text")
--   ok = EEPRollingstockSetTextureText("BR481",1,"Dienstf ahrt")

-- === EEPRollingstockGetTextureText() ==============================================================================
---Liest den Text einer beschreibbaren Flaeche eines Rollmaterials aus.
---@param rollingstockName string parameter ist der Name des Fahrzeugs als String.
---@param surfaceNumber string parameter ist die Nummer der Flaeche, dessen Text ausgelesen werden soll. Manche
--- Modelle haben mehrere, individuell beschreibbare Flaechen.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
---@return string text rueckgabewert ist der Text, mit dem die ausgewaehlte Flaeche beschriftet ist.
function EEPRollingstockGetTextureText(rollingstockName, surfaceNumber) end

--       ==============================================================
-- Verfuegbar ab EEP 16.3 - Plugin 3.
-- Beispielaufrufe:
--   EEPRollingstockGetTextureText("Fahrzeugname", Flaechennummer)
--   ok, Text = EEPRollingstockGetTextureText("BR481", 1)

-- === EEPSignalSetTextureText() ====================================================================================
---Weist einer beschreibbaren Flaeche eines Signals einen neuen Text zu.
---@param signalId number parameter ist die ID des Signals.
---@param surfaceNumber string parameter ist die Nummer der Flaeche, welche den Text erhalten soll. Manche Modelle
--- haben mehrere, individuell beschreibbare Flaechen.
---@param text string parameter ist der gewuenschte Text. Zeilenumbruch mit \n.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false
function EEPSignalSetTextureText(signalId, surfaceNumber, text) end

--       ======================================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
--   EEPSignalSetTextureText(Signal-ID, Flaechennummer, "Text")
--   ok = EEPSignalSetTextureText(88, 1, "Feuerwehr Ausfahrt")

-- === EEPSignalGetTextureText() ====================================================================================
---Liest den Text einer beschreibbaren Flaeche eines Signals aus.
---@param signalId number parameter ist die ID des Signals
---@param surfaceNumber string parameter ist die Nummer der Flaeche, dessen Text ausgelesen werden soll. Manche
--- Modelle haben mehrere, individuell beschreibbare Flaechen.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
---@return string text rueckgabewert ist der Text, mit dem die ausgewaehlte Flaeche beschriftet ist.
function EEPSignalGetTextureText(signalId, surfaceNumber) end

--       ================================================
-- Verfuegbar ab EEP 17.2 - Plugin 2.
-- Beispielaufrufe:
--   EEPSignalGetTextureText(Signal-ID, Flaechennummer)
--   ok, Text = EEPSignalGetTextureText(88, 1)

-- === EEPGoodsSetTextureText() =====================================================================================
---Weist einer beschreibbaren Flaeche eines Ladeguts einen neuen Text zu.
---@param luaName string parameter ist der Lua-Name des Ladeguts als String. Er steht in den Objekteigenschaften und
--- unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die Nummer mit vorangestelltem
--- #-Zeichen als Identifikator.
---@param surfaceNumber string parameter ist die Nummer der Flaeche, welche den Text erhalten soll. Manche Modelle
--- haben mehrere, individuell beschreibbare Flaechen.
---@param text string parameter ist der gewuenschte Text. Zeilenumbruch mit \n.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false
function EEPGoodsSetTextureText(luaName, surfaceNumber, text) end

--       ====================================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
--   EEPGoodsSetTextureText("#Lua-Name", Flaechennummer,"Text")
--   ok = EEPGoodsSetTextureText("#137", 2, "Lua Logistik")

-- === EEPGoodsGetTextureText() =====================================================================================
---Liest den Text einer beschreibbaren Flaeche eines Ladegutes aus.
---@param luaName string parameter ist der Lua-Name des Ladeguts als String. Er steht in den Objekteigenschaften und
--- unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die Nummer mit vorangestelltem
--- #-Zeichen als Identifikator.
---@param surfaceNumber string parameter ist die Nummer der Flaeche, dessen Text ausgelesen werden soll. Manche
--- Modelle haben mehrere, individuell beschreibbare Flaechen.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
---@return string text rueckgabewert ist der Text, mit dem die ausgewaehlte Flaeche beschriftet ist.
function EEPGoodsGetTextureText(luaName, surfaceNumber) end

--       ==============================================
-- Verfuegbar ab EEP 17.2 - Plugin 2.
-- Beispielaufrufe:
--   EEPGoodsGetTextureText("#Lua-Name", Flaechennummer)
--   ok, Text = EEPGoodsGetTextureText("#137", 1)

-- === EEPRailTrackSetTextureText() =================================================================================
---Weist einer beschreibbaren Flaeche eines Gleisstuecks einen neuen Text zu.
---@param railTrackId number parameter ist die ID des Gleisstuecks.
---@param surfaceNumber string parameter ist die Nummer der Flaeche, welche den Text erhalten soll. Manche Modelle
--- haben mehrere, individuell beschreibbare Flaechen.
---@param text string parameter ist der gewuenschte Text. Zeilenumbruch mit \n.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false
function EEPRailTrackSetTextureText(railTrackId, surfaceNumber, text) end

--       ============================================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
--   EEPRailTrackSetTextureText(Gleis-ID, Flaechennummer, "Text")
--   ok = EEPRailTrackSetTextureText(67, 1, "Schiene")

-- === EEPRailTrackGetTextureText() =================================================================================
---Liest den Text einer beschreibbaren Flaeche eines Gleisstuecks aus.
---@param railTrackId number parameter ist die ID des Gleisstuecks
---@param surfaceNumber string parameter ist die Nummer der Flaeche, dessen Text ausgelesen werden soll. Manche
--- Modelle haben mehrere, individuell beschreibbare Flaechen.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
---@return string text rueckgabewert ist der Text, mit dem die ausgewaehlte Flaeche beschriftet ist.
function EEPRailTrackGetTextureText(railTrackId, surfaceNumber) end

--       ======================================================
-- Verfuegbar ab EEP 17.2 - Plugin 2.
-- Beispielaufrufe:
--   EEPRailTrackGetTextureText(Gleis-ID, Flaechennummer)
--   ok, Text = EEPRailTrackGetTextureText(67, 1)

-- === EEPRoadTrackSetTextureText() =================================================================================
---Weist einer beschreibbaren Flaeche eines Strassenstuecks einen neuen Text zu.
---@param roadTrackId number parameter ist die ID des Strassenstuecks.
---@param surfaceNumber string parameter ist die Nummer der Flaeche, welche den Text erhalten soll. Manche Modelle
--- haben mehrere, individuell beschreibbare Flaechen.
---@param text string parameter ist der gewuenschte Text. Zeilenumbruch mit \n.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false
function EEPRoadTrackSetTextureText(roadTrackId, surfaceNumber, text) end

--       ============================================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
--   EEPRoadTrackSetTextureText(Strassen-ID, Flaechennummer, "Text")
--   ok = EEPRoadTrackSetTextureText(128, 1, "Strasse")

-- === EEPRoadTrackGetTextureText() =================================================================================
---Liest den Text einer beschreibbaren Flaeche eines Strassenstuecks aus.
---@param roadTrackId number parameter ist die ID des Strassenstuecks
---@param surfaceNumber string parameter ist die Nummer der Flaeche, dessen Text ausgelesen werden soll. Manche
--- Modelle haben mehrere, individuell beschreibbare Flaechen.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
---@return string text rueckgabewert ist der Text, mit dem die ausgewaehlte Flaeche beschriftet ist.
function EEPRoadTrackGetTextureText(roadTrackId, surfaceNumber) end

--       ======================================================
-- Verfuegbar ab EEP 17.2 - Plugin 2.
-- Beispielaufrufe:
--   EEPRoadTrackGetTextureText(Strassen-ID, Flaechennummer)
--   ok, Text = EEPRoadTrackGetTextureText(128, 1)

-- === EEPTramTrackSetTextureText() =================================================================================
---Weist einer beschreibbaren Flaeche eines Strassenbahngleisstuecks einen neuen Text zu.
---@param tramTrackId number parameter ist die ID des Strassenbahngleisstuecks.
---@param surfaceNumber string parameter ist die Nummer der Flaeche, welche den Text erhalten soll. Manche Modelle
--- haben mehrere, individuell beschreibbare Flaechen.
---@param text string parameter ist der gewuenschte Text. Zeilenumbruch mit \n.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false
function EEPTramTrackSetTextureText(tramTrackId, surfaceNumber, text) end

--       ============================================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
--   EEPTramTrackSetTextureText(Strassenbahngleis-ID, Flaechennummer, "Text")
--   ok = EEPTramTrackSetTextureText(213, 1, "Strassenbahngleis")

-- === EEPTramTrackGetTextureText() =================================================================================
---Liest den Text einer beschreibbaren Flaeche eines Strassenbahngleisstuecks aus.
---@param tramTrackId number parameter ist die ID des Strassenbahngleisstuecks
---@param surfaceNumber string parameter ist die Nummer der Flaeche, dessen Text ausgelesen werden soll. Manche
--- Modelle haben mehrere, individuell beschreibbare Flaechen.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
---@return string text rueckgabewert ist der Text, mit dem die ausgewaehlte Flaeche beschriftet ist.
function EEPTramTrackGetTextureText(tramTrackId, surfaceNumber) end

--       ======================================================
-- Verfuegbar ab EEP 17.2 - Plugin 2.
-- Beispielaufrufe:
--   EEPTramTrackGetTextureText(Strassenbahngleis-ID, Flaechennummer)
--   ok, Text = EEPTramTrackGetTextureText(213, 1)

-- === EEPAuxiliaryTrackSetTextureText() ============================================================================
---Weist einer beschreibbaren Flaeche eines Weg-Elementes der Kategorie "Sonstige" einen neuen Text zu.
---@param auxiliaryTrackId number parameter ist die ID des Weg-Elements der Kategorie "Sonstige".
---@param surfaceNumber string parameter ist die Nummer der Flaeche, welche den Text erhalten soll. Manche Modelle
--- haben mehrere, individuell beschreibbare Flaechen.
---@param text string parameter ist der gewuenschte Text.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false
function EEPAuxiliaryTrackSetTextureText(auxiliaryTrackId, surfaceNumber, text) end

--       ======================================================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
--   EEPAuxiliaryTrackSetTextureText(Spline-ID, Flaechennummer, "Text")
--   ok = EEPAuxiliaryTrackSetTextureText(197, 1, "Bauzaun")

-- === EEPAuxiliaryTrackGetTextureText() ============================================================================
---Liest den Text einer beschreibbaren Flaeche eines Weg-Elementes der Kategorie "Sonstige" aus.
---@param auxiliaryTrackId number parameter ist die ID des Weg-Elements der Kategorie "Sonstige".
---@param surfaceNumber string parameter ist die Nummer der Flaeche, dessen Text ausgelesen werden soll. Manche
--- Modelle haben mehrere, individuell beschreibbare Flaechen.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
---@return string text rueckgabewert ist der Text, mit dem die ausgewaehlte Flaeche beschriftet ist.
function EEPAuxiliaryTrackGetTextureText(auxiliaryTrackId, surfaceNumber) end

--       ================================================================
-- Verfuegbar ab EEP 17.2 - Plugin 2.
-- Beispielaufrufe:
--   EEPAuxiliaryTrackGetTextureText(Spline-ID, Flaechennummer)
--   ok, Text = EEPAuxiliaryTrackGetTextureText(197, 1)

-- === EEPStructureSetTagText() =====================================================================================
---Aendert den Tag-Text einer Immobilie oder eines Landschaftselementes. Jede Immobilie bzw. jedes Landschaftselement
---kann einen individuellen String von maximal 1024 Zeichen Laenge mitfuehren. Diese Strings werden mit der Anlage
---gespeichert und geladen.
---@param luaName string parameter ist der Lua-Name der Immobilie oder des Landschaftselements als String. Er steht
--- in den Objekteigenschaften und unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die
--- Nummer mit vorangestelltem #-Zeichen als Identifikator.
---@param text string parameter ist der gewuenschte Text.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false. Hinweis: Ab EEP 18
--- kann einer Immobilie oder einem Landschaftselement auch ein Tag-Text ueber dessen Objekteigenschaften zugewiesen
--- bzw. dies veraendert werden.
function EEPStructureSetTagText(luaName, text) end

--       =====================================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
--   EEPStructureSetTagText("#Lua-Name","Text")
--   ok = EEPStructureSetTagText("#112","besetzt:2,3,5,8")

-- === EEPStructureGetTagText() =====================================================================================
---Liest den Tag-Text einer Immobilie oder eines Landschaftselementes aus. Mittels Tag-Texten koennen Immobilien bzw.
---Landschaftselemente als permanente Speicher fuer relevante Informationen genutzt werden.
---@param luaName string parameter ist der Lua-Name der Immobilie oder des Landschaftselements als String. Er steht
--- in den Objekteigenschaften und unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die
--- Nummer mit vorangestelltem #-Zeichen als Identifikator.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
---@return string text rueckgabewert ist der Tag-Text, welcher der Immobilie oder dem Landschaftselement mitgegeben
--- wurde. Nach EEPStructureSetTagText() liefert EEPStructureGetTagText() noch im selben Zyklus der EEPMain() den
--- neuen, geaenderten TagText. Hinweis: Ab EEP 18 kann bei einer Immobilie oder einem Landschaftselement auch ein
--- eingetragener Tag-Text ueber dessen Objekteigenschaften ausgelesen werden.
function EEPStructureGetTagText(luaName) end

--       ===============================
-- Verfuegbar ab EEP 15.
-- Beispielaufrufe:
--   EEPStructureGetTagText("#Lua-Name")
--   ok, Text = EEPStructureGetTagText("#112")

-- === EEPRollingstockSetTagText() ==================================================================================
---Aendert den Tag-Text eines Fahrzeugs. Jedes Fahrzeug kann einen eigenen String von maximal 1024 Zeichen Laenge
---mitfuehren. Diese Strings werden mit der Anlage gespeichert und geladen. Da die Texte individuell jedem Fahrzeug
---zugeordnet sind, gehen sie im Gegensatz zu Routen nicht durch Rangiermanoever etc. verloren.
---@param rollingstockName string parameter ist der Name des Fahrzeugs als String.
---@param text string parameter ist der gewuenschte Text.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPRollingstockSetTagText(rollingstockName, text) end

--       =================================================
-- Verfuegbar ab EEP 15.
-- Bemerkungen:
--   Hinweis: Ab EEP 18 kann einem Fahrzeug auch ein Tag-Text ueber dessen Objekteigenschaften zugewiesen bzw. dies
--   veraendert werden.
-- Beispielaufrufe:
--   EEPRollingstockSetTagText("Fahrzeugname","Text")
--   ok = EEPRollingstockSetTagText("DB Zcs-Eva" , "Tankwagen")

-- === EEPRollingstockGetTagText() ==================================================================================
---Liest den Tag-Text eines Fahrzeugs aus. Mittels Tag-Texten koennen Fahrzeuge jetzt kategorisiert werden.
---Beispielsweise kann man dort Waggontypen speichern oder Bestimmungsorte.
---@param rollingstockName string parameter ist der Name des Fahrzeugs als String.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
---@return string text rueckgabewert ist der Tag-Text, welcher dem Fahrzeug mitgegeben wurde. Nach
--- EEPRollingstockSetTagText() liefert EEPRollingstockGetTagText() noch im selben Zyklus der EEPMain() den neuen,
--- geaenderten TagText.
function EEPRollingstockGetTagText(rollingstockName) end

--       ===========================================
-- Verfuegbar ab EEP 15.
-- Bemerkungen:
--   Hinweis: Ab EEP 18 kann bei einem Fahrzeug auch ein eingetragener Tag-Text ueber dessen Objekteigenschaften
--   ausgelesen werden.
-- Beispielaufrufe:
--   EEPRollingstockGetTagText("Fahrzeugname")
--   ok, Text = EEPRollingstockGetTagText("DB Zcs-Eva")

-- === EEPSignalSetTagText() ========================================================================================
---Aendert den Tag-Text eines Signals. Jedes Signal kann einen eigenen String von maximal 1024 Zeichen Laenge
---mitfuehren. Diese Strings werden mit der Anlage gespeichert und geladen. Da die Texte individuell jedem Signal
---zugeordnet sind, gehen sie nicht verloren.
---@param signalId number parameter ist die Signal-ID.
---@param text string parameter ist der gewuenschte Text.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPSignalSetTagText(signalId, text) end

--       ===================================
-- Verfuegbar ab EEP 17.1 - Plugin 1.
-- Bemerkungen:
--   Hinweis: Ab EEP 18 kann einem Signal auch ein Tag-Text ueber dessen Objekteigenschaften zugewiesen bzw. dies
--   veraendert werden.
-- Beispielaufrufe:
--   EEPSignalSetTagText(Signal-ID,"Text")
--   ok = EEPSignalSetTagText(87 , "Route_C")

-- === EEPSignalGetTagText() ========================================================================================
---Liest den Tag-Text eines Signals aus. Mittels Tag-Texten koennen z.B. Informationen zu Fahrstrassenschaltungen
---oder Bahnuebergaengen direkt in den Signalen anstatt in Datenslots gespeichert werden.
---@param signalId number parameter ist die Signal-ID.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
---@return string text rueckgabewert ist der Tag-Text, welcher dem Signal mitgegeben wurde. Nach
--- EEPSignalSetTagText() liefert EEPSignalGetTagText() noch im selben Zyklus der EEPMain() den neuen, geaenderten
--- TagText.
function EEPSignalGetTagText(signalId) end

--       =============================
-- Verfuegbar ab EEP 17.1 - Plugin 1.
-- Bemerkungen:
--   Hinweis: Ab EEP 18 kann bei einem Signal auch ein eingetragener Tag-Text ueber dessen Objekteigenschaften
--   ausgelesen werden.
-- Beispielaufrufe:
--   EEPSignalGetTagText(Signal-ID)
--   ok, Text = EEPSignalGetTagText(87)

-- === EEPGoodsSetTagText() =========================================================================================
---Aendert den Tag-Text eines Ladegutes. Jedes Ladegut kann einen eigenen String von maximal 1024 Zeichen Laenge
---mitfuehren. Diese Strings werden mit der Anlage gespeichert und geladen. Da die Texte individuell jedem Ladegut
---zugeordnet sind, gehen sie nicht verloren.
---@param luaName string parameter ist der Lua-Name des Ladeguts. Er steht in den Objekteigenschaften und
--- unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die Nummer mit vorangestelltem
--- #-Zeichen als Identifikator.
---@param text string parameter ist der gewuenschte Text.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPGoodsSetTagText(luaName, text) end

--       =================================
-- Verfuegbar ab EEP 18.0.
-- Bemerkungen:
--   Hinweis: Sie koennen einen Tag-Text auch ueber die Objekteigenschaften des Ladegutes eingeben.
-- Beispielaufrufe:
--   EEPGoodsSetTagText("#Lua-Name","Text")
--   ok = EEPGoodsSetTagText("#44" , "DB Schenker")

-- === EEPGoodsGetTagText() =========================================================================================
---Liest den Tag-Text eines Ladegutes aus. Mittels Tag-Texten koennen z.B. Informationen zu Verladezielen direkt in
---den Ladeguetern gespeichert werden.
---@param luaName string parameter ist der Lua-Name des Ladeguts. Er steht in den Objekteigenschaften und
--- unterscheidet sich durch die vorangestellte ID vom Modellnamen. Es genuegt die Nummer mit vorangestelltem
--- #-Zeichen als Identifikator.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
---@return string text rueckgabewert ist der Tag-Text, welcher dem Ladegut mitgegeben wurde. Nach
--- EEPGoodsSetTagText() liefert EEPGoodsGetTagText() noch im selben Zyklus der EEPMain() den neuen, geaenderten
--- TagText.
function EEPGoodsGetTagText(luaName) end

--       ===========================
-- Verfuegbar ab EEP 18.0.
-- Bemerkungen:
--   Hinweis: Sie koennen einen eingetragenen Tag-Text auch ueber die Objekteigenschaften des Ladegutes ausgelesen.
-- Beispielaufrufe:
--   EEPGoodsGetTagText("#Lua-Name")
--   ok, Text = EEPGoodsGetTagText("#44")

-- === EEPSwitchSetTagText() ========================================================================================
---Aendert den Tag-Text einer Weiche. Jede Weiche kann einen eigenen String von maximal 1024 Zeichen Laenge
---mitfuehren. Diese Strings werden mit der Anlage gespeichert und geladen. Da die Texte individuell jeder Weiche
---zugeordnet sind, gehen sie nicht verloren.
---@param switchId number parameter ist die Weichen-ID.
---@param text string parameter ist der gewuenschte Text.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPSwitchSetTagText(switchId, text) end

--       ===================================
-- Verfuegbar ab EEP 18.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPSwitchSetTagText(WeichenID,"Text")
--   ok = EEPSwitchSetTagText(87, "besetzt")

-- === EEPSwitchGetTagText() ========================================================================================
---Liest den Tag-Text einer Weiche aus. Mittels Tag-Texten koennen auch Weichen als permanente Speicher fuer
---relevante Informationen genutzt werden.
---@param switchId number parameter ist die Weichen-ID.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
---@return boolean text rueckgabewert ist der Tag-Text, welcher der Weiche mitgegeben wurde. Wenn der 1.
--- Rueckgabewert false ist, ist der 2. Rueckgabewert nil. Nach EEPSwitchSetTagText() liefert EEPSwitchGetTagText()
--- noch im selben Zyklus der EEPMain() den neuen, geaenderten TagText.
function EEPSwitchGetTagText(switchId) end

--       =============================
-- Verfuegbar ab EEP 18.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPSwitchGetTagText(WeichenID)
--   ok, Text = EEPSwitchGetTagText(87)

-- === EEPRollingstockSetActive() ===================================================================================
---Waehlt das angegebene Fahrzeug im Steuerdialog aus und stellt den Steuerdialog auf manuellen Modus um
---@param rollingstockName string parameter ist der komplette Name des Rollmaterials als String.
---@return boolean ok rueckgabewert ist true wenn die Aktion erfolgreich war, sonst false.
function EEPRollingstockSetActive(rollingstockName) end

--       ==========================================
-- Verfuegbar ab EEP 15.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPRollingstockSetActive("Fahrzeugname")
--   ok = EEPRollingstockSetActive("BR 212 376-8")

-- === EEPRollingstockGetActive() ===================================================================================
---Ermittelt, welches Fahrzeug derzeit im Steuerdialog ausgewaehlt ist.
---@return string rollingstockName rueckgabewert ist der Name des im Steuerdialog ausgewaehlten Fahrzeugs. Befindet
--- sich der Steuerdialog im Automatikmodus, dann wird ein leerer String zurueckgegeben.
function EEPRollingstockGetActive() end

--       ==========================
-- Verfuegbar ab EEP 15.1.
-- Bemerkungen:
--   Plug in 1
-- Beispielaufrufe:
--   EEPRollingstockGetActive()
--   Fahrzeugname = EEPRollingstockGetActive()

-- === EEPSetTrainActive() ==========================================================================================
---Waehlt den angegebenen "Fahrzeugverband" im Steuerdialog aus und stellt den Steuerdialog auf Automatik-Modus um.
---@param trainName string parameter ist der komplette Name des "Fahrzeugverbands" (mit vorangestelltem #-Zeichen)
--- als String.
---@return boolean ok rueckgabewert ist true wenn die Aktion erfolgreich war, sonst false.
function EEPSetTrainActive(trainName) end

--       ============================
-- Verfuegbar ab EEP 15.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPSetTrainActive("#Name")
--   ok = EEPSetTrainActive("#Gueterzug")

-- === EEPGetTrainActive() ==========================================================================================
---Ermittelt, welcher "Fahrzeugverband" derzeit im Steuerdialog ausgewaehlt ist
---@return string name rueckgabewert ist der Name des im Steuerdialog ausgewaehlten Fahrzeugverbandes ("Name").
--- Befindet sich der Steuerdialog im manuellen Modus, dann wird der Name des Fahrzeugverbandes zurueckgegeben,
--- welcher das im Steuerdialog ausgewaehlte Fahrzeug enthaelt.
function EEPGetTrainActive() end

--       ===================
-- Verfuegbar ab EEP 15 - Plugin 1.
-- Beispielaufrufe:
--   EEPGetTrainActive()
--   Name = EEPGetTrainActive()

-- === EEPSetCloudsIntensity() ======================================================================================
---Schaltet global (ausserhalb eventueller Wetterzonen) auf ein Wolkenbild mit "blauem" Himmel und veraendert den
---Wolkenanteil zwischen 10 % und 100 % (entsprechend dem Bereich unter "Einstellung der Umwelt").
---@param intensity number parameter ist der Wolkenanteil in Prozent. Bei Eingabe eines Wertes unter 10 % wird der
--- Wolkenanteil auf NULL gesetzt. Der neue Wert wird sofort gesetzt, aber das Wolkenbild aendert sich schleichend.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPSetCloudsIntensity(intensity) end

--       ================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPSetCloudsIntensity(Wolkenanteil)
--   ok = EEPSetCloudsIntensity(75)

-- === EEPSetDarkCloudsIntensity() ==================================================================================
---Schaltet global (ausserhalb eventueller Wetterzonen) auf ein Wolkenbild mit "grauem" Himmel und veraendert den
---Wolkenanteil zwischen 10 % und 100 % (entsprechend dem Bereich unter "Einstellung der Umwelt").
---@param intensity number parameter ist der Wolkenanteil in Prozent. Bei Eingabe eines Wertes unter 10 % wird der
--- Wolkenanteil auf NULL gesetzt. Der neue Wert wird sofort gesetzt, aber das Wolkenbild aendert sich schleichend.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPSetDarkCloudsIntensity(intensity) end

--       ====================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPSetDarkCloudsIntensity(Wolkenanteil)
--   ok = EEPSetDarkCloudsIntensity(10)

-- === EEPGetCloudsIntensity() ======================================================================================
---Ermittelt den globalen Wolkenanteil (ausserhalb eventueller Wetterzonen).
---@return number funktion rueckgabewert ist der Wolkenanteil in Prozent unabhaengig davon, wie der Wolkenanteil
--- vorher gesetzt wurde, ob unter "Einstellung der Umwelt" oder mit den Lua- Funktionen EEPSetCloudsIntensity() bzw.
--- EEPSetDarkCloudsIntensity().
function EEPGetCloudsIntensity() end

--       =======================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Bemerkungen:
--   Achtung: Nach EEPSetCloudsIntensity() bzw. EEPSetDarkCloudsIntensity() liefert EEPGetCloudsIntensity()
--   fruehestens im naechsten Zyklus der EEPMain() die neuen Wolkenanteile.
-- Beispielaufrufe:
--   EEPGetCloudsIntensity()
--   Wolkenanteil = EEPGetCloudsIntensity()

-- === EEPGetCloudsMode() ===========================================================================================
---Ermittelt, ob global (ausserhalb eventueller Wetterzonen) Wolken am Himmel sind und welcher Art sie sind.
---@alias EEPCloudMode
---| 0 # Keine Wolken
---| 1 # Wolken
---| 2 # Dunkle Wolken
---@return EEPCloudMode modus rueckgabewert gibt den Wolken-Modus an.
function EEPGetCloudsMode() end

--       ==================
-- Verfuegbar ab EEP 17.1 - Plugin 1.
-- Bemerkungen:
--   Der Funktionsaufruf durch EEP erfolgt ohne Parameter.
--   Achtung: Nach EEPSetCloudsIntensity() bzw. EEPSetDarkCloudsIntensity() liefert EEPGetCloudsMode() fruehestens im
--   naechsten Zyklus der EEPMain() den neuen Wolkenmodus.
-- Beispielaufrufe:
--   EEPGetCloudsMode()
--   Modus = EEPGetCloudsMode()

-- === EEPSetWindIntensity() ========================================================================================
---Veraendert die globale Windstaerke (ausserhalb eventueller Wetterzonen) zwischen 10 % und 100 % (entsprechend dem
---Bereich unter "Einstellung der Umwelt").
---@param windIntensity number parameter ist die Windstaerke in Prozent. Bei Eingabe eines Wertes unter 10 % wird die
--- Windstaerke auf NULL gesetzt. Die Einstellung wird sofort uebernommen.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPSetWindIntensity(windIntensity) end

--       ==================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPSetWindIntensity(Windstaerke)
--   ok = EEPSetWindIntensity(60)

-- === EEPGetWindIntensity() ========================================================================================
---Ermittelt die globale Windstaerke (ausserhalb eventueller Wetterzonen).
---@return any windstaerke rueckgabewert ist die Windstaerke in Prozent.
function EEPGetWindIntensity() end

--       =====================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Bemerkungen:
--   Achtung: Nach EEPSetWindIntensity() liefert EEPGetWindIntensity() fruehestens im naechsten Zyklus der EEPMain()
--   die neue Windstaerke.
-- Beispielaufrufe:
--   EEPGetWindIntensity()
--   Windstaerke = EEPGetWindIntensity()

-- === EEPSetRainIntensity() ========================================================================================
---Veraendert die globale Regenstaerke (ausserhalb eventueller Wetterzonen) zwischen 10 % und 100 % (entsprechend dem
---Bereich unter "Einstellung der Umwelt").
---@param intensity number parameter ist die Regenstaerke in Prozent. Bei Eingabe eines Wertes unter 10 % wird die
--- Regenstaerke auf NULL gesetzt. Die Einstellung veraendert sich allmaehlich innerhalb von ca. 20 Sekunden.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPSetRainIntensity(intensity) end

--       ==============================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPSetRainIntensity(Regenstaerke)
--   ok = EEPSetRainIntensity(50)

-- === EEPGetRainIntensity() ========================================================================================
---Ermittelt die globale Regenstaerke (ausserhalb eventueller Wetterzonen).
---@return any regenstaerke rueckgabewert ist die Regenstaerke in Prozent. Waehrend einer Uebergangsphase werden auch
--- Werte unter 10 % angezeigt.
function EEPGetRainIntensity() end

--       =====================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Bemerkungen:
--   Achtung: Nach EEPSetRainIntensity() liefert EEPGetRainIntensity() fruehestens im naechsten Zyklus der EEPMain()
--   die neue Regenstaerke.
-- Beispielaufrufe:
--   EEPGetRainIntensity()
--   Regenstaerke = EEPGetRainIntensity()

-- === EEPSetSnowIntensity() ========================================================================================
---Veraendert die globale Schneefallstaerke (ausserhalb eventueller Wetterzonen) zwischen 10 % und 100 %
---(entsprechend dem Bereich unter "Einstellung der Umwelt")
---@param snowIntensity number parameter ist die Schneefallstaerke in Prozent. Bei Eingabe eines Wertes unter 10 %
--- wird die Schneefallstaerke auf NULL gesetzt. Die Einstellung veraendert sich allmaehlich innerhalb von ca. 20
--- Sekunden.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPSetSnowIntensity(snowIntensity) end

--       ==================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPSetSnowIntensity(Schneefallstaerke)
--   ok = EEPGetSnowIntensity(35)

-- === EEPGetSnowIntensity() ========================================================================================
---Ermittelt die globale Schneeintensitaet (ausserhalb eventueller Wetterzonen)
---@return any schneefallstaerke rueckgabewert ist die Schneefallstaerke in Prozent. Waehrend einer Uebergangsphase
--- werden auch Werte unter 10 % angezeigt.
function EEPGetSnowIntensity() end

--       =====================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Bemerkungen:
--   Achtung: Nach EEPSetSnowIntensity() liefert EEPGetSnowIntensity() fruehestens im naechsten Zyklus der EEPMain()
--   die neue Schneefallstaerke.
-- Beispielaufrufe:
--   EEPGetSnowIntensity()
--   Schneefallstaerke = EEPGetSnowIntensity()

-- === EEPSetHailIntensity() ========================================================================================
---Veraendert die globale Hagelstaerke (ausserhalb eventueller Wetterzonen) zwischen 10 % und 100 % (entsprechend dem
---Bereich unter "Einstellung der Umwelt").
---@param intensity number parameter ist die Hagelstaerke in Prozent. Bei Eingabe eines Wertes unter 10 % wird die
--- Hagelstaerke auf NULL gesetzt. Die Einstellung veraendert sich allmaehlich innerhalb von ca. 20 Sekunden.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPSetHailIntensity(intensity) end

--       ==============================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPSetHailIntensity(Hagelstaerke)
--   ok = EEPSetHailIntensity(55)

-- === EEPGetHailIntensity() ========================================================================================
---Ermittelt die globale Hagelstaerke (ausserhalb eventueller Wetterzonen).
---@return any hagelstaerke rueckgabewert ist die Hagelstaerke in Prozent. Waehrend einer Uebergangsphase werden auch
--- Werte unter 10 % angezeigt.
function EEPGetHailIntensity() end

--       =====================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Bemerkungen:
--   Achtung: Nach EEPSetHailIntensity() liefert EEPGetHailIntensity() fruehestens im naechsten Zyklus der EEPMain()
--   die neue Hagelstaerke.
-- Beispielaufrufe:
--   EEPGetHailIntensity()
--   Hagelstaerke = EEPGetHailIntensity()

-- === EEPSetFogIntensity() =========================================================================================
---Veraendert die globale Nebeldichte (ausserhalb eventueller Wetterzonen) zwischen 10 % und 100 % (entsprechend dem
---Bereich unter "Einstellung der Umwelt")
---@param fogIntensity number parameter ist die Nebeldichte in Prozent. Bei Eingabe eines Wertes unter 10 % wird die
--- Nebeldichte auf NULL gesetzt. Die Einstellung wird sofort uebernommen.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPSetFogIntensity(fogIntensity) end

--       ================================
-- Verfuegbar ab EEP 16.1.
-- Beispielaufrufe:
--   EEPSetFogIntensity(Nebeldichte)
--   ok = EEPSetFogIntensity(40)

-- === EEPGetFogIntensity() =========================================================================================
---Ermittelt die globale Nebeldichte (ausserhalb eventueller Wetterzonen).
---@return any nebeldichte rueckgabewert ist die Nebeldichte in Prozent.
function EEPGetFogIntensity() end

--       ====================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Bemerkungen:
--   Achtung: Nach EEPSetFogIntensity() liefert EEPGetFogIntensity() fruehestens im naechsten Zyklus der EEPMain()
--   die neue Nebeldichte.
-- Beispielaufrufe:
--   EEPGetFogIntensity()
--   Nebeldichte = EEPGetFogIntensity()

-- === EEPSetZonePos() ==============================================================================================
---Versetzt die benannte Wetterzone an eine neue Position und/oder veraendert ihren Radius.
---@param zoneId number parameter ist die Nummer der bestehenden Wetterzone als numerische Zahl. Sie steht in der
--- obersten Zeile ihrer Objekteigenschaften
---@param posX number parameter ist die Position des Zonenmittelpunktes in X-Richtung.
---@param posY number parameter ist die Position des Zonenmittelpunktes in Y-Richtung.
---@param posZ number parameter ist die Position des Zonenmittelpunktes in Z-Richtung.
---@param radius number parameter ist der Radius der Wetterzone.
---@return boolean ok rueckgabewert ist true, wenn die Zone existiert oder false, wenn nicht.
function EEPSetZonePos(zoneId, posX, posY, posZ, radius) end

--       ===============================================
-- Verfuegbar ab EEP 17.1 - Plugin 1.
-- Bemerkungen:
--   Achtung: Die Positionierung des Mittelpunktes der Wetterzone darf nur innerhalb der Anlagengrenzen abzueglich
--   jeweils 1 Pixels in alle Richtungen erfolgen. Darueber hinaus wird die Funktion nicht ausgefuehrt. Es erfolgt
--   keine Fehlermeldung!
-- Beispielaufrufe:
--   EEPSetZonePos(Zonennummer, PosX, PosY, PosZ, Radius)
--   ok = EEPSetZonePos(3, 250, -160, 0, 300)

-- === EEPGetZonePos() ==============================================================================================
---Ermittelt die aktuelle Position einer Wetterzone und ihren Radius.
---@param zoneId number parameter ist die Nummer der Wetterzone als numerische Zahl. Sie steht in der obersten Zeile
--- ihrer Objekteigenschaften.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, ansonsten false.
---@return any posX rueckgabewert ist die X-Position des Zonenmittelpunktes.
---@return any posY rueckgabewert ist die Y-Position des Zonenmittelpunktes.
---@return any posZ rueckgabewert ist die Z-Position des Zonenmittelpunktes.
---@return any radius rueckgabewert ist der Radius der Zone.
function EEPGetZonePos(zoneId) end

--       =====================
-- Verfuegbar ab EEP 17.1 - Plugin 1.
-- Bemerkungen:
--   Achtung: Nach EEPSetZonePos() liefert EEPGetZonePos() fruehestens im naechsten Zyklus der EEPMain() die neuen
--   Werte.
-- Beispielaufrufe:
--   EEPGetZonePos(Zonennummer)
--   ok, Pos_X, Pos_Y, Pos_Z, Radius = EEPGetZonePos(3)

-- === EEPSetZoneWindIntensity() ====================================================================================
---Veraendert die Windstaerke in einer Wetterzone zwischen 10 % und 100 % (entsprechend dem Bereich in den
---Objekteigenschaften der Wetterzone).
---@param zoneId number parameter ist die Nummer der Wetterzone als numerische Zahl. Sie steht in der obersten Zeile
--- ihrer Objekteigenschaften.
---@param windIntensity number parameter ist die Windstaerke in Prozent. Bei Eingabe eines Wertes unter 10 % wird die
--- Windstaerke auf NULL gesetzt. Die Einstellung wird sofort uebernommen.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPSetZoneWindIntensity(zoneId, windIntensity) end

--       ==============================================
-- Verfuegbar ab EEP 17.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPSetZoneWindIntensity(Zonennummer, Windstaerke)
--   ok = EEPSetZoneWindIntensity(2, 60)

-- === EEPGetZoneWindIntensity() ====================================================================================
---Ermittelt die Windstaerke in einer Wetterzone.
---@param zoneId number parameter ist die Nummer der Wetterzone als numerische Zahl. Sie steht in der obersten Zeile
--- ihrer Objekteigenschaften.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, ansonsten false.
---@return any windstaerke rueckgabewert ist die Windstaerke in Prozent.
function EEPGetZoneWindIntensity(zoneId) end

--       ===============================
-- Verfuegbar ab EEP 17.1 - Plugin 1.
-- Bemerkungen:
--   Achtung: Nach EEPSetZoneWindIntensity() liefert EEPGetZoneWindIntensity() fruehestens im naechsten Zyklus der
--   EEPMain() die neue Windstaerke.
-- Beispielaufrufe:
--   EEPGetZoneWindIntensity(Zonennummer)
--   ok, Windstaerke = EEPGetZoneWindIntensity(2)

-- === EEPSetZoneRainIntensity() ====================================================================================
---Veraendert die Regenstaerke in einer Wetterzone zwischen 10 % und 100 % (entsprechend dem Bereich in den
---Objekteigenschaften der Wetterzone).
---@param zoneId number parameter ist die Nummer der Wetterzone als numerische Zahl. Sie steht in der obersten Zeile
--- ihrer Objekteigenschaften.
---@param intensity number parameter ist die Regenstaerke in Prozent. Bei Eingabe eines Wertes unter 10 % wird die
--- Regenstaerke auf NULL gesetzt. Der neue Wert wird sofort gesetzt, aber Regen und Wolken aendern sich schleichend.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPSetZoneRainIntensity(zoneId, intensity) end

--       ==========================================
-- Verfuegbar ab EEP 17.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPSetZoneRainIntensity(Zonennummer, Regenstaerke)
--   ok, = EEPSetZoneRainIntensity(1, 50)

-- === EEPGetZoneRainIntensity() ====================================================================================
---Ermittelt die Regenstaerke in einer Wetterzone.
---@param zoneId number parameter ist die Nummer der Wetterzone als numerische Zahl. Sie steht in der obersten Zeile
--- ihrer Objekteigenschaften.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, ansonsten false.
---@return any regenstaerke rueckgabewert ist die Regenstaerke in Prozent.
function EEPGetZoneRainIntensity(zoneId) end

--       ===============================
-- Verfuegbar ab EEP 17.1 - Plugin 1.
-- Bemerkungen:
--   Achtung: Nach EEPSetZoneRainIntensity() liefert EEPGetZoneRainIntensity() fruehestens im naechsten Zyklus der
--   EEPMain() die neue Regenstaerke.
-- Beispielaufrufe:
--   EEPGetZoneRainIntensity(Zonennummer)
--   ok, Regenstaerke = EEPGetZoneRainIntensity(1)

-- === EEPSetZoneSnowIntensity() ====================================================================================
---Veraendert die Schneefallstaerke in einer Wetterzone zwischen 10 % und 100 % (entsprechend dem Bereich in den
---Objekteigenschaften der Wetterzone)
---@param zoneId number parameter ist die Nummer der Wetterzone als numerische Zahl. Sie steht in der obersten Zeile
--- ihrer Objekteigenschaften.
---@param snowIntensity number parameter ist die Schneefallstaerke in Prozent. Bei Eingabe eines Wertes unter 10 %
--- wird die Schneefallstaerke auf NULL gesetzt. Der neue Wert wird sofort gesetzt, aber Schneefall und Wolken
--- aendern sich schleichend.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPSetZoneSnowIntensity(zoneId, snowIntensity) end

--       ==============================================
-- Verfuegbar ab EEP 17.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPSetZoneSnowIntensity(Zonennummer, Schneefallstaerke)
--   ok = EEPGetZoneSnowIntensity(3, 35)

-- === EEPGetZoneSnowIntensity() ====================================================================================
---Ermittelt die Schneefallstaerke in einer Wetterzone
---@param zoneId number parameter ist die Nummer der Wetterzone als numerische Zahl. Sie steht in der obersten Zeile
--- ihrer Objekteigenschaften.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, ansonsten false.
---@return any schneefallstaerke rueckgabewert ist die Schneefallstaerke in Prozent.
function EEPGetZoneSnowIntensity(zoneId) end

--       ===============================
-- Verfuegbar ab EEP 17.1 - Plugin 1.
-- Bemerkungen:
--   Achtung: Nach EEPSetZoneSnowIntensity() liefert EEPGetZoneSnowIntensity() fruehestens im naechsten Zyklus der
--   EEPMain() die neue Schneefallstaerke.
-- Beispielaufrufe:
--   EEPGetZoneSnowIntensity(Zonennummer)
--   ok, Schneefallstaerke = EEPGetZoneSnowIntensity(3)

-- === EEPSetZoneHailIntensity() ====================================================================================
---Veraendert die Hagel-/Graupelstaerke in einer Wetterzone zwischen 10 % und 100 % (entsprechend dem Bereich in den
---Objekteigenschaften der Wetterzone).
---@param zoneId number parameter ist die Nummer der Wetterzone als numerische Zahl. Sie steht in der obersten Zeile
--- ihrer Objekteigenschaften.
---@param intensity number parameter ist die Hagel-/Graupelstaerke in Prozent. Bei Eingabe eines Wertes unter 10 %
--- wird die Hagel/-Graupelstaerke auf NULL gesetzt. Der neue Wert wird sofort gesetzt, aber Hagel/Graupel und Wolken
--- aendern sich schleichend,
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPSetZoneHailIntensity(zoneId, intensity) end

--       ==========================================
-- Verfuegbar ab EEP 17.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPSetZoneHailIntensity(Zonennummer, Hagelstaerke)
--   ok, = EEPSetZoneHailIntensity(4, 55)

-- === EEPGetZoneHailIntensity() ====================================================================================
---Ermittelt die Hagel-/Graupelstaerke in einer Wetterzone
---@param zoneId number parameter ist die Nummer der Wetterzone als numerische Zahl. Sie steht in der obersten Zeile
--- ihrer Objekteigenschaften.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, ansonsten false.
---@return any hagelstaerke rueckgabewert ist die Hagel-/Graupelstaerke in Prozent.
function EEPGetZoneHailIntensity(zoneId) end

--       ===============================
-- Verfuegbar ab EEP 17.1 - Plugin 1.
-- Bemerkungen:
--   Achtung: Nach EEPSetZoneHailIntensity() liefert EEPGetHailIntensity() fruehestens im naechsten Zyklus der
--   EEPMain() die neue Hagel-/Graupelstaerke.
-- Beispielaufrufe:
--   EEPGetZoneHailIntensity(Zonennummer)
--   ok, Hagelstaerke = EEPGetZoneHailIntensity(4)

-- === EEPSetZoneFogIntensity() =====================================================================================
---Veraendert die Nebeldichte in einer Wetterzone zwischen 10 % und 100 % (entsprechend dem Bereich in den
---Objekteigenschaften der Wetterzone)
---@param zoneId number parameter ist die Nummer der Wetterzone als numerische Zahl. Sie steht in der obersten Zeile
--- ihrer Objekteigenschaften.
---@param fogIntensity number parameter ist die Nebeldichte in Prozent. Bei Eingabe eines Wertes unter 10 % wird die
--- Nebeldichte auf NULL gesetzt. Die Einstellung wird sofort uebernommen.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPSetZoneFogIntensity(zoneId, fogIntensity) end

--       ============================================
-- Verfuegbar ab EEP 17.1.
-- Beispielaufrufe:
--   EEPSetZoneFogIntensity(Zonennummer, Nebeldichte)
--   ok = EEPSetZoneFogIntensity(2, 40)

-- === EEPGetZoneFogIntensity() =====================================================================================
---Ermittelt die Nebeldichte in einer Wetterzone.
---@param zoneId number parameter ist die Nummer der Wetterzone als numerische Zahl. Sie steht in der obersten Zeile
--- ihrer Objekteigenschaften.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, ansonsten false.
---@return any nebeldichte rueckgabewert ist die Nebeldichte in Prozent.
function EEPGetZoneFogIntensity(zoneId) end

--       ==============================
-- Verfuegbar ab EEP 17.1 - Plugin 1.
-- Bemerkungen:
--   Achtung: Nach EEPSetZoneFogIntensity() liefert EEPGetZoneFogIntensity() fruehestens im naechsten Zyklus der
--   EEPMain() die neue Nebeldichte.
-- Beispielaufrufe:
--   EEPGetZoneFogIntensity(Zonennummer)
--   ok, Nebeldichte = EEPGetZoneFogIntensity(2)

-- === EEPSetZoneClouds() ===========================================================================================
---Bestimmt, ob in einer Wetterzone Wolken am Himmel sind und welcher Art sie sind.
---@param zoneId number parameter ist die Nummer der Wetterzone als numerische Zahl. Sie steht in der obersten Zeile
--- ihrer Objekteigenschaften.
---@param cloudMode EEPCloudMode parameter bestimmt den Wolken-Modus.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPSetZoneClouds(zoneId, cloudMode) end

--       ===================================
-- Verfuegbar ab EEP 17.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPSetZoneClouds(Zonennummer, Modus)
--   ok = EEPSetZoneClouds(2, 0)

-- === EEPGetZoneClouds() ===========================================================================================
---Ermittelt, ob in einer Wetterzone Wolken am Himmel sind und welcher Art sie sind.
---@param zoneId number parameter ist die Nummer der Wetterzone als numerische Zahl. Sie steht in der obersten Zeile
--- ihrer Objekteigenschaften.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
---@return EEPCloudMode modus rueckgabewert gibt den Wolken-Modus an.
function EEPGetZoneClouds(zoneId) end

--       ========================
-- Verfuegbar ab EEP 17.1 - Plugin 1.
-- Bemerkungen:
--   Achtung: Nach EEPSetZoneClouds() liefert EEPGetZoneClouds() fruehestens im naechsten Zyklus der EEPMain() den
--   neuen Wolkenmodus.
-- Beispielaufrufe:
--   EEPGetZoneClouds(Zonennummer)
--   ok, Modus = EEPGetZoneClouds(3)

-- === EEPSetSeason() ===============================================================================================
---Veraendert die Einstellung der Jahreszeit in der Anlage.
---@alias EEPSeason
---| 1 # Fruehling
---| 2 # Sommer
---| 3 # Herbst
---| 4 # Winter
---@param season EEPSeason parameter ist die in der Anlage einzustellende Jahreszeit.
function EEPSetSeason(season) end

--       ====================
-- Verfuegbar ab EEP 18.0.
-- Bemerkungen:
--   Die Funktion hat keinen Rueckgabewert.
-- Beispielaufrufe:
--   EEPSetSeason()
--   EEPSetSeason(3)

-- === EEPGetSeason() ===============================================================================================
---Ermittelt die in der Anlage eingestellte Jahreszeit.
---@return EEPSeason jahreszeit rueckgabewert ist die in der Anlage eingestellte Jahreszeit.
function EEPGetSeason() end

--       ==============
-- Verfuegbar ab EEP 17.2 - Plugin 2.
-- Bemerkungen:
--   Der Funktionsaufruf durch EEP erfolgt ohne Parameter.
-- Beispielaufrufe:
--   EEPGetSeason()
--   Jahreszeit = EEPGetSeason()

-- === EEPActivateCtrlDesk() ========================================================================================
---Ruft ein Gleisbildstellpult (GBS) im Radarfenster auf.
---@param ctrlDeskName string parameter ist der "Stellpult-Name" des GBS als String. (Nicht dessen Lua- Name!) Der
--- "Stellpult-Name" ist in den Objekteigenschaften des Stellpults in dem gleichnamigen Feld eingetragen.
---@return boolean ok rueckgabewert ist true, wenn die Ausfuehrung erfolgreich war, sonst false.
function EEPActivateCtrlDesk(ctrlDeskName) end

--       =================================
-- Verfuegbar ab EEP 16.1 - Plugin 1.
-- Beispielaufrufe:
--   EEPActivateCtrlDesk("Stellpult-Name")
--   ok = EEPActivateCtrlDesk("Wildungen")
