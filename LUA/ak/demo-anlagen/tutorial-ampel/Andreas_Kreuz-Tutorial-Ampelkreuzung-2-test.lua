print("Lade AkEepFunctions ...")
require("ak.eep.AkEepFunktionen")

clearlog()
--------------------------------------------------------------------
-- Zeigt erweiterte Informationen waehrend der Initialisierung an --
--------------------------------------------------------------------
AkStartMitDebug = false

--------------------------------------------------------------------
-- Zeigt erweiterte Informationen waehrend der erste Schitte an   --
--------------------------------------------------------------------
print("Lade ak.demo-anlagen.tutorial-ampel.Andreas_Kreuz-Tutorial-Ampelkreuzung-2-main ...")
require("ak.demo-anlagen.tutorial-ampel.Andreas_Kreuz-Tutorial-Ampelkreuzung-2-main")

--------------------------------------------------------------------
-- Zeige erweiterte Informationen an                              --
--------------------------------------------------------------------
AkPlaner.debug = true
AkSpeicherHilfe.debug = false
AkAmpel.debug = false
AkKreuzung.debug = false
AkKreuzung.zeigeSignalIdsAllerSignale = false
AkKreuzung.zeigeAnforderungenAlsInfo = true
AkKreuzung.zeigeSchaltungAlsInfo = true

--------------------------------------------------------------------
-- Erste Hilfe - normalerweise nicht notwendig                    --
--------------------------------------------------------------------
-- AkKreuzung.zaehlerZuruecksetzen()


-------------------------------------------------------------------
--AkKreuzung.debug = true
-------------------------------------------------------------------
local function run()
    EEPTime = EEPTime + 20
    EEPMain()
end

AkEEPHilfe.zahlDerZuegeAnSignal[14] = 1
AkEEPHilfe.namenDerZuegeAnSignal[14] = {}
AkEEPHilfe.namenDerZuegeAnSignal[14][1] = "#Zug1"
EEPSetTrainRoute("#Zug1", "Meine Route 1")

assert(true == os:pruefeAnforderungenAnSignalen())
assert(true == os.anforderungAnSignal)

for i = 1, 10 do
    print(i)
    run()
    run()
    run()
    run()
    run()
end
