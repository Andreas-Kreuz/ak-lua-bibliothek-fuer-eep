# Paket ak.eep - Funktionen für EEP

![SourceCode](../../../assets/headers/EEP14.jpg)

## Skripte, Klassen und Funktionen
* `ak.eep.AkEepFunktionen`

  Das Skript AkEepFunktionen stellt alle dokumentierten Funktionen von EEP zur Verfügung und ist für die Verwendung in Test-Klassen vorgesehen.

### Verwendung:

* Ein Testskript lädt zuerst die Funktionen von EEP:
    ```lua
    require 'ak.eep.AkEepFunktionen'
    ```

* Danach wird das eigentliche Skript geladen:
    ```lua
    require 'anlagen-script'
    ```


### Beispiel

```lua
require("ak.eep.AkEepFunktionen")

EEPSetSignal(32, 2)
assert (2 == EEPGetSignal(32))
```
