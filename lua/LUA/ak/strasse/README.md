---
layout: page_with_toc
title: Ampeln? Automatisch!
subtitle: Du willst Dich nicht mehr um die Steuerung Deiner Ampeln kümmern? - Dann beschreibe in Lua, wie Deine Kreuzung aussieht und das Skript AkStrasse übernimmt für Dich den Rest.
permalink: lua/ak/strasse/
feature-img: "/docs/assets/headers/SourceCode.png"
img: "/docs/assets/headers/SourceCode.png"
---

# Motivation
Willst Du mehr? - Lege Kontaktpunkte für die Verkehrszählung an, damit die Ampel mit dem meisten Andrang bevorzugt geschaltet wird.

Features:
* Automatisches Schalten von Ampeln an Kreuzungen
* Priorisiertes Schalten der Ampeln nach Verkehrsandrang
* Optional, Ampeln nur dann schalten, wenn jemand davor wartet

# Zur Verwendung vorgesehene Klassen und Funktionen

# Skript `AkStrasse`

## Klasse `AkAmpelModell`

Beschreibt das Modell einer Ampel mit den Schaltungen für rot, grün, gelb und rot-gelb, sowie dem Fußgängersignal (falls vorhanden - dann hat die Ampel für den Straßenverkehr rot)

### Mitgelieferte Ampelmodelle

* `AkAmpelModell.NP1_3er_mit_FG = AkAmpelModell:neu("Ampel_NP1_mit_FG", 2, 4, 5, 3, 1)`
* `AkAmpelModell.NP1_3er_ohne_FG = AkAmpelModell:neu("Ampel_NP1_ohne_FG", 1, 3, 4, 2)`
* `AkAmpelModell.JS2_2er_nur_FG = AkAmpelModell:neu("Ak_Ampel_2er_nur_FG", 1, 1, 1, 1, 2)`
* `AkAmpelModell.JS2_3er_ohne_FG = AkAmpelModell:neu("Ampel_3er_XXX_ohne_FG", 1, 3, 5, 2)`
* `AkAmpelModell.JS2_3er_mit_FG = AkAmpelModell:neu("Ampel_3er_XXX_mit_FG", 1, 3, 5, 2, 6)`
* `AkAmpelModell.Unsichtbar_2er = AkAmpelModell:neu("Unsichtbares Signal", 2, 1, 2, 2)`

  Siehe auch https://eepshopping.de/ - Ampel-Baukasten für mehrspurige Straßenkreuzungen (V80NJS20039)

### Ampelmodell anlegen
`function AkAmpelModell:neu(name, sigIndexRot, sigIndexGruen, sigIndexGelb, sigIndexRotGelb, sigIndexFgGruen)`

_Beschreibung:_
* Legt eine neues Ampelmodell an, welches in `AkAmpel` verwendet werden kann.

_Parameter:_
* `name` Name des Modells für die Ausgabe im Log
* `sigIndexRot` ist der Index der Signalstellung der Stellung **rot** (erforderlich)
* `sigIndexGruen` ist der Index der Signalstellung der Stellung **grün** (erforderlich)
* `sigIndexGelb` ist der Index der Signalstellung der Stellung **gelb** (optional, wenn nicht vorhanden wird rot verwendet)
* `sigIndexRotGelb` ist der Index der Signalstellung der Stellung **rot-gelb** (optional, wenn nicht vorhanden wird rot verwendet)
* `sigIndexFgGruen` ist der Index der Signalstellung der Stellung **Fußgänger grün** (optional, wenn nicht vorhanden, werden Fußgänger nicht auf grün geschaltet)

_Rückgabewert_
* Die Ampel (Typ `AkAmpel`)

## Klasse `AkAmpel`
Diese Klasse wird dazu verwendet eine Signal auf der Anlage (signalId) mit einem Modell zu verknüpfen. Eine so verknüpfte Ampel kann dann einer Richtung zugewiesen werden.

### Neue Ampel erzeugen

`function AkAmpel:neu(signalId, ampelModell)`

_Beschreibung:_
* Legt eine neue Ampel an, welche einer Richtung hinzugefügt werden kann.
* Normalerweise wird jede in der Anlage eingesetzte Ampel mit ihrer `signalId` nur einmal verwendet, da es für jede Ampel normalerweise nur eine Richtung gibt. Folgende Ausnahmen beschreiben, wann man eine Ampel für mehrere Richtungen benötigt:
  * Soll eine unsichtbare Ampel für mehrere Richtungen an unterschiedliche Immobilien gekoppelt werden, dann ist es notwendig diese Ampel für jede Richtung einzeln anzulegen, da sonst die Umschaltung der Ampel die falschen Immobilien schalten würde.

_Parameter:_
* `signalId` ist die Signal-ID der zu steuernden Ampel in EEP
* `ampelModell` muss vom Typ `AkAmpelModell` sein

_Rückgabewert_
* Die Ampel (Typ `AkAmpel`)

### Lichtsteuerung von Immobilien

`function AkAmpel:fuegeLichtImmoHinzu(rotImmo, gruenImmo, gelbImmo, anforderungImmo)`

_Beschreibung:_
* Fügt bis zu vier Immobilien hinzu, deren Licht ein oder ausgeschaltet wird, sobald die Ampel auf rot, gelb oder grün geschaltet wird bzw. wenn sich die Anforderung an der Ampel ändert.

_Parameter:_
* `rotImmo` Name der Immobilie, deren Licht eingeschaltet wird, wenn die Ampel rot oder rot-gelb ist
* `gruenImmo` Name der Immobilie,  deren Licht eingeschaltet wird, wenn die Ampel grün ist
* `gelbImmo` Name der Immobilie,  deren Licht eingeschaltet wird, wenn die Ampel gelb oder rot-gelb ist
* `anforderungImmo` Name der Immobilie,  deren Licht eingeschaltet wird, wenn die Ampel eine Anforderung erkennt

_Rückgabewert_
* Die Ampel (Typ `AkAmpel`)

Passende Modelle für die Steuerung der Immobilien mit Licht findest Du im Modellset V10MA1F011. Download unter http://eep.euma.de/download/ - Im Modell befindet sich eine ausführliche Doku.

### Achssteuerung einer Immobilie

`function AkAmpel:fuegeAchsenImmoHinzu(immoName, achsName, grundStellung,
stellungRot, stellungGruen, stellungGelb, stellungFG)`

_Beschreibung:_
* Ändert die Achsstellung der angegebenen Immobilien beim Schalten der Ampel auf rot, gelb, grün oder Fußgänger

_Parameter:_
* `immoName` Name der Immobilie, deren Achse gesteuert werden soll
* `achsName` Name der Achse in der Immobilie, die gesteuert werden soll
* `grundStellung` Grundstellung der Achse (wird eingestellt, wenn eine Stellung nicht angegeben wurde
* `stellungRot` Achsstellung bei rot
* `stellungGruen` Achsstellung bei grün
* `stellungGelb` Achsstellung bei gelb
* `stellungFG` Achsstellung bei FG

_Rückgabewert_
* Die Ampel (Typ `AkAmpel`)


## Klasse `AkRichtung`
Wird dazu verwendet mehrere Ampeln gleichzeitig zu schalten. Die kann für eine oder mehrere Fahrspuren geschehen.

### Neue Richtung anlegen
`function AkRichtung:neu(name, eepSaveId, ...)`

_Beschreibung:_
* Legt eine neue Richtung mit den dazu passenden Ampeln an

_Parameter:_
* `name` Name der Richtung (z.B. "Richtung 1")
* `eepSaveId` Freie EEP-Speicher-ID (1 - 1000)
* `...` List von Ampeln (Typ `AkAmpel`), mindestens eine

_Rückgabewert_
* Die Ampel (Typ `AkRichtung`)

### Fahrzeuge erkennen
Es gibt drei Möglichkeiten Fahrzeuge zu erkennen:

1. **Fahrzeuge am roten Signal zählen**

    Über diese Funktion wird erkannt, wie viele Fahrzeuge zwischen einem bestimmten Vor- und Hauptsignal auf dem Straßenstück warten.

    * Um die Richtung zu priorisieren, wenn sich **ein beliebiges Fahrzeug** auf der Straße vor der Ampel befindet, muss die signalID der Ampel einmalig hinterlegt werden: `meineRichtung:zaehleAnAmpelAlle(signalId)`

    * Um die Richtung nur dann zu Priorisieren, wenn ein bestimmtes Fahrzeug an der Ampel wartet, kann stattdessen die Funktion mit Route verwendet werden: `meineRichtung:zaehleAnAmpelBeiRoute(strassenId, route)`<br>
    Diese Funktion prüft, ob das erste Fahrzeug an der Ampel die passende Route hat.

2. **Fahrzeuge auf der Straße vor dem Signal erkennen**

    Über diese Funktion wird erkannt, ob sich _ein_ Fahrzeuge auf dem Straßenstück befindet.

    * Um die Richtung zu priorisieren, wenn sich **ein beliebiges Fahrzeug** auf der Straße vor der Ampel befindet, muss die ID des Straßenstücks einmalig hinterlegt werden: `meineRichtung:zaehleAnStrasseAlle(strassenId)``

    * Um die Richtung nur dann zu Priorisieren, wenn sich ein bestimmtes Fahrzeug auf der Straße vor der Ampel befindet, kann stattdessen die Funktion mit Route verwendet werden: `meineRichtung:zaehleAnStrasseBeiRoute(strassenId, route)`


3. **Fahrzeuge mit Kontaktpunkten zählen**

    Das Zählen mit Kontaktpunkten hinterlegt die Anzahl der Fahrzeuge in der Richtung und führt dazu, dass Richtungen mit mehr Fahrzeugen bevorzugt werden.

    Es werden zwei Kontaktpunkte benötigt:

    1. _Richtung betreten_<br> Rufe im Kontaktpunkt die Funktion `meineRichtung:betritt()` auf, wenn ein Fahrzeug den Bereich betritt.

    2. _Richtung verlassen_<br> Rufe im Kontaktpunkt die Funktion `meineRichtung:verlasse(signalaufrot, fahrzeugName)` auf, wenn ein Fahrzeug den Bereich verläßt.

        Wenn das Fahrzeug die Richtung verläßt, dann kann es die Ampel auf rot setzen, wenn gewünscht.


## Klasse `AkKreuzungsSchaltung`

Wird dazu verwendet, mehrere Richtungen gleichzeitig zu schalten. Es muss sichergestellt werden, dass sich die Fahrwege der Richtungen einer Schaltung nicht überlappen.

  * `function AkKreuzungsSchaltung:neu(name)` - legt eine neue Schaltung an

  * `function AkKreuzungsSchaltung:fuegeRichtungHinzu(richtung)` fügt eine Richtung hinzu, für die mit den Zyklen Rot, Rot-Gelb, Gruen und Gelb geschaltet wird.

  * `function AkKreuzungsSchaltung:fuegeRichtungFuerFussgaengerHinzu(richtung)` fügt eine Richtung hinzu, für die mit den Zyklen Rot, Gruen_Fussgaenger geschaltet wird.

  * `function AkKreuzungsSchaltung:fuegeRichtungMitAnforderungHinzu(richtung)` fügt eine Richtung hinzu, für die mit den Zyklen Rot, Rot-Gelb, Gruen und Gelb geschaltet wird.

  __Beachte:__ Eine solche Richtung wird nur dann auf Grün geschaltet, wenn eine Anforderung vorliegt. Sie schaltet sofort wieder auf Rot, wenn keine weitere Anforderung vorliegt.


## Klasse `AkKreuzung`
Wird dazu verwendet, die Kreuzung zu verwalten, enthält mehrere Schaltungen.

  * `AkKreuzung:neu(name)` - legt eine neue Kreuzung an. Diese wird automatisch anhand ihrer Richtungen geschaltet.

  * `function AkKreuzung:fuegeSchaltungHinzu(schaltung)` fügt eine Schaltung zur Kreuzung hinzu.

## Funktion `AkKreuzung:planeSchaltungenEin()`
Muss in `EEPMain()` aufgerufen werden - plant die Umschaltung von Kreuzungsschaltungen.

# Wichtige Hinweise

* __Damit das Ganze funktioniert__, muss `EEPMain()` mindestens folgende Befehle verwenden:

    ```lua
    local ModuleRegistry = require("ak.core.ModuleRegistry")
    ModuleRegistry.registerModules(
        require("ak.core.CoreLuaModule"),
        require("ak.strasse.KreuzungLuaModul") -- Registriert das Kreuzungsmodul
    )

    function EEPMain()
        ModuleRegistry.runTasks()               -- Führt alle anstehenden Aktionen der registrierten Module aus
        return 1
    end```

* __Richtungen mit Anforderungen benötigen zwingend Zählfunktionen__ für die Fahrzeuge dieser Richtung. Für andere Richtungen ist dies optional.

  * `richtung:betritt()` - im Kontaktpunkt aufrufen, wenn eine Richtung betreten wird (z.B. 50m vor der Ampel; aber nur auf dieser Richtungsfahrbahn)

  * `richtung:verlasse(signalaufrot, Zugname)` - im Kontaktpunkt aufrufen, wenn eine Richtung verlassen wird (hinter der Ampel)

    `signalaufrot` sollte nur für Richtungen mit Anforderung auf `true` gesetzt werden. Es sorgt dafür, dass die Richtungsampeln sofort auf rot gesetzt werden, wenn keine Anforderung mehr vorliegt.

    __Beachte:__ Die Zählfunktionen müssen beim Betreten und Verlassen einer Richtung verwendet werden.
