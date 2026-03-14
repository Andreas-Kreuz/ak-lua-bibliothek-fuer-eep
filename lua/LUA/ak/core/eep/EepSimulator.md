# EepSimulator

`EepSimulator.lua` kann innerhalb von Lua-Tests genutzt werden, um das Verhalten von EEP für bestimmte Funktionen abzubilden. Die Funktionen gliedern sich in drei Typen:

- `EEP...` bildet die originale EEP-API ab.
- `emit...` löst EEP-Callbacks gezielt im Simulator aus.
- `simulate...` stellt Hilfsfunktionen für Benutzer-Aktionen in EEP bereit.

## `EEP...`

Diese Funktionen bilden die originale EEP-API nach, wie sie in
[`EepOriginalApi.d.lua`](./EepOriginalApi.d.lua) beschrieben ist.

Intention:

- Testcode soll dieselben globalen `EEP...`-Funktionen aufrufen können wie in EEP.
- Die Implementierung liefert im Simulator konsistenten, testbaren Zustand, ohne dass EEP laufen muss.

## `emit...`

Diese Methoden lösen EEP-Callbacks gezielt im Simulator aus.

Intention:

- Testcode oder Anlagencode kann Callback-Situationen nachstellen, die in echtem EEP vom Programm ausgelöst werden.
- Die Methoden rufen in der Runtime direkt die zugehörigen globalen Callback-Funktionen aus `_G` auf, zum Beispiel `EEPMain()`, `EEPOnBeforeSaveAnl()` oder `EEPOnTrainStoppedOnSignal(...)`.
- `emit...` ist deshalb keine Nachbildung einer normalen EEP-Funktion, sondern ein kontrollierter Callback-Auslöser.

Beispiele:

- `EepSimulator.emitMain()` ruft `EEPMain()` auf.
- `EepSimulator.emitOnSignal(signalId, stellung)` ruft `EEPOnSignal_<signalId>(stellung)` auf.
- `EepSimulator.emitOnSwitch(switchId, stellung)` ruft `EEPOnSwitch_<switchId>(stellung)` auf.
- `EepSimulator.emitOnBeforeSaveAnl()` ruft `EEPOnBeforeSaveAnl()` auf.
- `EepSimulator.emitOnTrainStoppedOnSignal(signalId, trainName)` ruft `EEPOnTrainStoppedOnSignal(signalId, trainName)` auf.

## `simulate...`

Diese Methoden sind zusätzliche Simulator-Hilfen und gehören nicht zur originalen EEP-API.

Intention:

- Sie simulieren Aktionen, die normalerweise durch den Anwender oder die EEP-Oberfläche ausgelöst werden.
- Sie helfen dabei, Anlagen- und Testzustand gezielt vorzubereiten, zum Beispiel Züge anlegen, umbenennen, auf Gleise setzen oder in Signalwarteschlangen einreihen.
- In `EepSimulator.lua` delegieren diese Methoden an `Runtime.simulate...`.

Beispiele:

- `EepSimulator.simulateAddTrain(...)`
- `EepSimulator.simulatePlaceTrainOnRailTrack(trackId, trainName)`
- `EepSimulator.simulateQueueTrainOnSignal(signalId, trainName)`
- `EepSimulator.simulateRenameTrain(oldName, newName)`
