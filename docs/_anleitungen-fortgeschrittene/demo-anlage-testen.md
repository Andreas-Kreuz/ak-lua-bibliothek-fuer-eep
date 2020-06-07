---
layout: page_with_toc
title: Lua testen
type: Tutorial mit Anlage
subtitle: Hier erfährst Du, wie Du Deine Lua-Skripte testen kannst, ohne EEP zu starten. Dabei kannst auch simulieren, dass Fahrzeuge einen Kontaktpunkt betreten.
img: "/assets/thumbnails/test-demo.png"
permalink: anleitungen-fortgeschrittene/demo-anlage-testen
date: 2017-09-06
---

# Motivation

Je komplexer die eigenen Lua-Skripte werden, umso mehr möchte man sie selbst testen. Am besten, ohne dass die Skripte fehlerhaft in EEP laufen und zu "Unfällen" führen.

_Die Grundidee_: __Das Lua-Skript wird erst nach dem bestandenen Test in EEP geladen.__

Die Anlage `Andreas_Kreuz-Lua-Testbeispiel` - oder besser deren Lua-Skripte - demonstriert folgendes:

* Lua-Skript auf Syntax-Fehler prüfen
* Lua-Skript auf Herz und Nieren testen
* Lua-Skript Änderungen ohne Copy & Paste in EEP übernehmen - Einfach im Lua-Fenster auf _Skript neu laden_ klicken

# Vorbereitungen

* Sämtlicher Inhalt des Anlagen-Skriptes `Andreas_Kreuz-Lua-Testbeispiel.lua`, welches die `EEPMain()`-Funktion enthält, wird in ein
  Haupt-Skript, z.B. `ak-demo-lua\testen\Andreas_Kreuz-Lua-Testbeispiel-main.lua` in `C:\Trend\EEP14\LUA` abgelegt.

* Die Aufgabe des Anlagen-Skriptes `Andreas_Kreuz-Lua-Testbeispiel.lua` ist nur noch das Einbinden Haupt-Skript mittels `require
  'ak-demo-lua.testen.Andreas_Kreuz-Lua-Testbeispiel-main'`, so dass EEP die Main-Methode und alles andere findet
  (da EEP bei require-Befehlen immer in `C:\Trend\EEP14\LUA` schaut, wird das Haupt-Skript von EEP gefunden)

* Es wird ein Testskript `ak-demo-lua\testen\Andreas_Kreuz-Lua-Testbeispiel-test.lua` in `C:\Trend\EEP14\LUA` erstellt,
  welches das Haupt-Skript auch mittels require 'Andreas_Kreuz-Lua-Testbeispiel-main' einbindet.

* Damit das Haupt-Skript ohne EEP funktioniert gibt es von mir ein Skript `EepSimulator.lua` welches auch in
  `C:\Trend\EEP14\LUA` abgelegt werden muss, damit es beim testen die Funktionen von EEP bereitstellt.
  Dieses muss in `ak-demo-lua\testen\Andreas_Kreuz-Lua-Testbeispiel-test.lua` an erster Stelle eingebunden werden:
  `require 'ak.core.eep.EepSimulator'`

* Zum Ausführen des Test-Skriptes ohne EEP ist Lua 5.2 erforderlich - z.B. `lua.exe`, `lua52.dll` und `luac.exe` aus
folgendem Link. [https://sourceforge.net/projects/luabinaries/files/5.2.4/Tools%20Executables/lua-5.2.4_Win64_bin.zip/download](https://sourceforge.net/projects/luabinaries/files/5.2.4/Tools%20Executables/lua-5.2.4_Win64_bin.zip/download)
 diese 3 Dateien einfacherweise auch in `C:\Trend\EEP14\LUA` ablegen


# Der Arbeitsablauf

1. Speichere die Datei `Andreas_Kreuz-Lua-Testbeispiel-main.lua` nach einer Änderung

2. Führe `Andreas_Kreuz-Lua-Testbeispiel-test.lua` auf eine der folgenden drei Arten aus:

    * **Starte das Test-Skript in IntelliJ** (Für Fortgeschrittene: [so verwendest Du IntelliJ mit Lua](../anleitungen-entwickler/intellij-verwenden))

    * **In Notepad++** drückst Du <kbd>F5</kbd> und führst dann folgenden Befehl aus:
    `cmd /k C:\Trend\EEP14\LUA\lua.exe Andreas_Kreuz-Lua-Testbeispiel-test.lua`

    * **Auf der Kommandozeile**: Drücke <kbd><kbd>Windows</kbd> + <kbd>R</kbd></kbd> und starte dann das Programm `cmd`
      * Gehe in der Kommandozeile in den `LUA` Ordner von EEP: `cd C:\Trend\EEP14\LUA`
      * Starte das Test-Skript starten: `lua.exe Andreas_Kreuz-Lua-Testbeispiel-test.lua`


3. Sobald Du mit dem Ergebnis zufrieden bist, klicke im Lua-Fenster von EEP auf "Skript neu laden" und der Inhalt des Haupt-Skriptes wird in EEP ausgeführt.


# Testen der Funktion

In EEP ist es manchmal schlecht möglich alle Zustände einer Funktion zu prüfen, ohne diverse Rollmaterialien auf den Weg zu schicken.

Ein Test hilft Dir, indem er die Kontaktpunkte manuell auslöst - im Beispiel wird nach `zaehleHoch()` der Rückgabewert von `EEPGetSignal()` geprüft, da sich dieses Signal nach den Hochzählen verändert haben muss.

```lua
zaehleHoch() -- simuliere ein Fahrzeug, welches in den Bereich einfährt
assert(1 == zaehler) -- Prüfe den "zaehler"
EEPMain() -- EEPMain aufrufen und danach das Signal prüfen
assert (4 == EEPGetSignal(1)) -- Prüfe das Signal - der "zaehler" ist 1, das Signal muss auf 4 stehen
```
