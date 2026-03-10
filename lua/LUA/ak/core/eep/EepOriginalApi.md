# Hinweise für KI-Agenten zum parsen von EepOriginalApi.d.lua aus dem Handbuch

Das Lua_Manual.pdf scheint wie folgt aufgebaut zu sein:

## Variablen

Es gibt pro Variable eine Tabelle mit drei Spalten und folgenden Zeilen:
1: "EEPVariable" (dynamischer Text über zwei Spalten) | EEPVariable (wiederholt)
2: "Voraussetzung" | Anzahl der Parameter | Beispielaufruf
3: "Zweck" | Beschreibung der Variable (über zwei Zeilen)

## Funktionen

Es gibt pro Funktion eine Tabelle mit drei Spalten und folgenden Zeilen:
1: "EEPFunktion()" (dynamischer Text über zwei Spalten) | Aufruf der EEPFunktion(...) mit Parametern
2: "Parameter" | Anzahl der Parameter | Beispielaufruf (über drei Zeilen)
3: "Rückgabewerte" | Anzahl der Rückgabewerte | hier weiter der Beispielaufruf
4: "Voraussetzung" | Mindestversion von EEP und Plugin | hier weiter der Beispielaufruf
5: "Zweck" | Beschreibung der Funktion für LuaDoc (über zwei Spalten)
6: "Bemerkungen" | Auflistung / Beschreibung der Parameter und Rückgabewerte (über zwei Spalten)
