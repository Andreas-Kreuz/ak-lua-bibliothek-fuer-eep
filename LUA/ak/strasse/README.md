# Paket ak.strasse - Steuerung für den Strassenverkehr

![SourceCode](../../../assets/headers/SourceCode.png)

## Inhalt
<!-- TOC depthFrom:2 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [Inhalt](#inhalt)
- [Motivation](#motivation)
- [Zur Verwendung vorgesehene Klassen und Funktionen](#zur-verwendung-vorgesehene-klassen-und-funktionen)
	- [Skript `AkStrasse`](#skript-akstrasse)
		- [Klasse `AkAmpelModell`](#klasse-akampelmodell)
		- [Klasse `AkAmpel`](#klasse-akampel)
		- [Klasse `AkRichtung`](#klasse-akrichtung)
		- [Klasse `AkKreuzungsSchaltung`](#klasse-akkreuzungsschaltung)
		- [Klasse `AkKreuzung`](#klasse-akkreuzung)
		- [Funktion `AkKreuzung:planeSchaltungenEin()`](#funktion-akkreuzungplaneschaltungenein)
- [Wichtige Hinweise](#wichtige-hinweise)

<!-- /TOC -->
## Motivation

Du willst Dich nicht mehr um die Steuerung Deiner Ampeln kümmern? - Dann beschreibe in Lua, wie Deine Kreuzung aussieht und das Skript AkStrasse übernimmt für Dich den Rest.

Willst Du mehr? - Lege Kontaktpunkte für die Verkehrszählung an, damit die Ampel mit dem meisten Andrang bevorzugt geschaltet wird.

Features:
* Automatisches Schalten von Ampeln an Kreuzungen
* Priorisiertes Schalten der Ampeln nach Verkehrsandrang
* Optional, Ampeln nur dann schalten, wenn jemand davor wartet

## Zur Verwendung vorgesehene Klassen und Funktionen

### Skript `AkStrasse`

#### Klasse `AkAmpelModell`

Beschreibt das Modell einer Ampel mit den Schaltungen für rot, grün, gelb und rot-gelb, sowie dem Fußgängersignal (falls vorhanden - dann hat die Verkehrsampel rot)

* `function AkAmpelModell:neu(name, sigIndexRot, sigIndexGruen, sigIndexGelb, sigIndexRotGelb, sigIndexFgGruen)` es müssen mindestens rot und grün angegeben werden.

Mitgelieferte Ampelmodelle sind:

* `AkAmpelModell.NP1_3er_mit_FG = AkAmpelModell:neu("Ampel_NP1_mit_FG", 2, 4, 5, 3, 1)`
* `AkAmpelModell.NP1_3er_ohne_FG = AkAmpelModell:neu("Ampel_NP1_ohne_FG", 1, 3, 4, 2)`
* `AkAmpelModell.JS2_2er_nur_FG = AkAmpelModell:neu("Ak_Ampel_2er_nur_FG", 1, 1, 1, 1, 2)`
* `AkAmpelModell.JS2_3er_ohne_FG = AkAmpelModell:neu("Ampel_3er_XXX_ohne_FG", 1, 3, 5, 2)`
* `AkAmpelModell.JS2_3er_mit_FG = AkAmpelModell:neu("Ampel_3er_XXX_mit_FG", 1, 3, 5, 2, 6)`
* `AkAmpelModell.Unsichtbar_2er = AkAmpelModell:neu("Unsichtbares Signal", 2, 1, 2, 2)`

  Siehe auch https://eepshopping.de/ - Ampel-Baukasten für mehrspurige Straßenkreuzungen (V80NJS20039)


#### Klasse `AkAmpel`
wird dazu verwendet eine Signal auf der Anlage (signalId) mit einem Modell zu verküpfen.

* `function AkAmpel:neu(signalId, ampelModell, rotImmo, gruenImmo, gelbImmo, anforderungImmo)`

  Erforderlich sind `signalId` und `ampelModell`.

  Die Einstellungen `rotImmo`, `gruenImmo`, `gelbImmo` und `anforderungImmo` sind für die Verwendung von Straßenbahn Signalen gedacht, deren Signalbilder durch das Ein- und Ausschalten von Licht in diesen Immobilien geschaltet werden. Dabei ist `anforderungsImmo` z.B. das Symbol "A" in der Ampel. Als Signal kann hier das ein Unsichtbares Signal verwendet werden.

  Passende Modelle für die Steuerung der Immobilien findest Du im Modellset V10MA1F011. Download unter http://eep.euma.de/download/ - Im Modell befindet sich eine ausführliche Doku.


#### Klasse `AkRichtung`
Wird dazu verwendet mehrere Ampeln gleichzeitig zu schalten. Die kann für eine oder mehrere Fahrspuren geschehen.

* `function AkRichtung:neu(name, eepSaveId, ...)`

    Erforderlich sind name (z.B. "Richtung 1"), eepSaveId (Speicher-ID in EEP; 1 - 1000) und eine Liste mit mindestens einer Ampel (AkAmpel).

#### Klasse `AkKreuzungsSchaltung`
Wird dazu verwendet, mehrere Richtungen gleichzeitig zu schalten. Es muss sichergestellt werden, dass sich die Fahrwege der Richtungen einer Schaltung nicht überlappen.

  * `function AkKreuzungsSchaltung:neu(name)` - legt eine neue Schaltung an

  * `function AkKreuzungsSchaltung:fuegeRichtungHinzu(richtung)` fügt eine Richtung hinzu, für die mit den Zyklen Rot, Rot-Gelb, Gruen und Gelb geschaltet wird.

  * `function AkKreuzungsSchaltung:fuegeRichtungFuerFussgaengerHinzu(richtung)` fügt eine Richtung hinzu, für die mit den Zyklen Rot, Gruen_Fussgaenger geschaltet wird.

  * `function AkKreuzungsSchaltung:fuegeRichtungMitAnforderungHinzu(richtung)` fügt eine Richtung hinzu, für die mit den Zyklen Rot, Rot-Gelb, Gruen und Gelb geschaltet wird.

  __Beachte:__ Eine solche Richtung wird nur dann auf Grün geschaltet, wenn eine Anforderung vorliegt. Sie schaltet sofort wieder auf Rot, wenn keine weitere Anforderung vorliegt.


#### Klasse `AkKreuzung`
Wird dazu verwendet, die Kreuzung zu verwalten, enthält mehrere Schaltungen.

  * `AkKreuzung:neu(name)` - legt eine neue Kreuzung an. Diese wird automatisch anhand ihrer Richtungen geschaltet.

  * `function AkKreuzung:fuegeSchaltungHinzu(schaltung)` fügt eine Schaltung zur Kreuzung hinzu.

#### Funktion `AkKreuzung:planeSchaltungenEin()`
Muss in `EEPMain()` aufgerufen werden - plant die Umschaltung von Kreuzungsschaltungen.

## Wichtige Hinweise

* __Damit das Ganze funktioniert__, muss `EEPMain()` mindestens folgende Befehle verwenden:

    ```lua
    function EEPMain()
        AkKreuzung:planeSchaltungenEin()     -- Plant die Ampelschaltungen ein
        AkPlaner:fuehreGeplanteAktionenAus() -- Führt Aktionen nach Zeit aus
        return 1
    end```

* __Richtungen mit Anforderungen benötigen zwingend Zählfunktionen__ für die Fahrzeuge dieser Richtung. Für andere Richtungen ist dies optional.

  * `richtung:betritt()` - im Kontaktpunkt aufrufen, wenn eine Richtung betreten wird (z.B. 50m vor der Ampel; aber nur auf dieser Richtungsfahrbahn)

  * `richtung:verlasse(signalaufrot, Zugname)` - im Kontaktpunkt aufrufen, wenn eine Richtung verlassen wird (hinter der Ampel)

    `signalaufrot` sollte nur für Richtungen mit Anforderung auf `true` gesetzt werden. Es sorgt dafür, dass die Richtungsampeln sofort auf rot gesetzt werden, wenn keine Anforderung mehr vorliegt.

    __Beachte:__ Die Zählfunktionen müssen beim Betreten und Verlassen einer Richtung verwendet werden.
