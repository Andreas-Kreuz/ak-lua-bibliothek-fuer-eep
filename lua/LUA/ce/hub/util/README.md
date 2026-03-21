---
layout: page_with_toc
title: Einfacheres Speichern
subtitle: Packe mehrere Daten in EEPData und erkenne doppelt belegte Speicher-IDs.
permalink: lua/ce/hub/util/
feature-img: "/docs/assets/headers/SourceCode.png"
img: "/docs/assets/headers/SourceCode.png"
---

# Paket `ce.hub.util`

Dieses Paket enthält Hilfsfunktionen für die persistente Ablage kleiner Zustände in EEP-Datenslots und in Rollingstock-Tags.

Es wird produktiv in mehreren Paketen der Bibliothek verwendet, z.B. in `ce.mods.road`, `ce.mods.transit`, `ce.rail` sowie in den Hub-Datenbereichen unter `ce.hub.data.*`.

## Dateien

- `StorageUtility.lua`
  Zentrale Hilfsfunktionen zum Registrieren, Speichern, Laden und Debuggen von Storage-Daten.

## Wichtige Einschränkungen

- `StorageUtility.saveTable()` und `StorageUtility.loadTable()` arbeiten bewusst mit **String-Werten**.
- Vor dem Speichern müssen Zahlen und Boolean-Werte daher mit `tostring(...)` serialisiert werden.
- Nach dem Laden müssen Werte mit `tonumber(...)` oder `StorageUtility.toboolean(...)` zurückgewandelt werden.
- Schlüssel und Werte dürfen keine Kommata enthalten, da das Format intern als `key=value,` gespeichert wird.
- Für `EEPSaveData` begrenzt `StorageUtility` die Länge des erzeugten Strings auf `999` Zeichen.
- Für Rollingstock-Tags liegt die Grenze bei `1024` Zeichen.

## Zentrale Funktionen

### `StorageUtility.registerId(eepSaveId, name)`

Reserviert einen EEP-Speicherslot zwischen `1` und `1000`.
Wird dieselbe ID mehrfach verwendet, löst das Modul absichtlich einen Fehler aus.

### `StorageUtility.saveTable(eepSaveId, table, name)`

Speichert eine Tabelle mit String-Schlüsseln und String-Werten in einem EEP-Datenslot.

### `StorageUtility.loadTable(eepSaveId, name)`

Lädt einen Datenslot und gibt immer eine Tabelle zurück.
Nicht vorhandene oder leere Slots führen zu einer leeren Tabelle.

### `StorageUtility.loadTableRollingStock(rollingStockName)`

Lädt String-Daten aus `EEPRollingstockGetTagText(...)` und wandelt sie in dieselbe Tabellenstruktur um.

### `StorageUtility.toboolean(value)`

Konvertiert den String `"true"` zu `true`.
Andere Werte ergeben `false`.

## Beispiel

```lua
local StorageUtility = require("ce.hub.util.StorageUtility")

StorageUtility.registerId(700, "Meine Kreuzung")

local data = {
    b = tostring(true),
    z = tostring(5),
    n = "Nord"
}

StorageUtility.saveTable(700, data, "Meine Kreuzung")

local loaded = StorageUtility.loadTable(700, "Meine Kreuzung")
local belegt = StorageUtility.toboolean(loaded.b)
local zaehler = tonumber(loaded.z)
local name = loaded.n
```

## Empfehlung

Für persistente Zustände kurze Schlüssel wie `b`, `z`, `r` oder `t` verwenden und optionale Felder beim Speichern lieber weglassen als Platzhalter wie `"nil"` abzulegen.
