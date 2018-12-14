 
# Versionshinweise   

## Version 0.8.0

* Startseite nun im Material Design

* Bugfixes:
  
  * EEPSetSignal informiert nun Lua, dass geschaltet wurde

## Version 0.7.0

### EEP-Web
* ⭐ Manuelle Schaltung von Kreuzungen

## Version 0.6.0

* `AkStrasse` sollte nicht mehr importiert werden.

    Requires von Lua sollten immer einer lokalen Variable zugewiesen werden. 
    Darum wird ab dieser Version die Funktion `require("ak.planer.AkStrasse")` 
    nicht mehr empfohlen.

    **Import vor Version 0.6.0:**
    
    `require("ak.planer.AkStrasse")` _Bitte nicht mehr verwenden!_

    **Import ab Version 0.6.0:**
    
    ```lua
    local AkPlaner = require("ak.planer.AkPlaner")
    local AkAmpelModell = require("ak.strasse.AkAmpelModell")
    local AkAmpel = require("ak.strasse.AkAmpel")
    local AkRichtung = require("ak.strasse.AkRichtung")
    local AkKreuzung = require("ak.strasse.AkKreuzung")
    local AkKreuzungsSchaltung = require("ak.strasse.AkKreuzungsSchaltung")
    ```
    
## Version 0.5.0

* enthält EEP-Web