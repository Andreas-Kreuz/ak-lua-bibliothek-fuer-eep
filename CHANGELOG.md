# Änderungen an der Software

## 0.9.0

- ⭐ Neu: Ein Projekt, alle Inhalte (Lua, Server und Web App in einem Projekt)
- ⭐ Neu: Daten für den Server werden nur noch dann geschrieben, wenn der Server gestartet ist
- ⭐ Neu: Einmaliges Suchen nach globalen Daten macht das Ganze schneller
- ⭐ Neu: Warnung, wenn die Datenausgabe länger dauert

- ℹ️ Info: Für folgende Lua Dateien müssen die Imports geändert werden:
  - `ak.core.eep.AkEepFunktionen` ersetzt ~~`ak.eep.AkEepFunktionen`~~
  - `ak.core.eep.AkTippTextFormat` ersetzt ~~`ak.text.AkFormat`~~

## v0.8.4

- ⭐ Neu: Umbenannt: Es werden nun die ersten 20 "**leeren**" Speicherplätze in EEP-Web unter Speicher angezeigt
- ⭐ Neu: Performance: Das Einlesen von nicht veränderlichen Daten erfolgt nun nur noch einmal (beigesteuert von [FrankBucholz](https://github.com/FrankBuchholz) - Danke!)

## v0.8.3

- ⭐ Neu: Ausgabe der ersten 20 leeren Speicherplätze in EEP-Web unter Speicher
- ⭐ Neu: Ausgabe an EEP-Web enthält nun auch Fehlermeldungen die mit assert ausgegeben werden.
- ⭐ Neu: Der Name wird nun auch für Speicherplätze angezeigt, die mit AkSpeicherHilfe.registriereId(id, name) angelegt
  wurden

## v0.8.2

- 🐞 Bugfix: AkSpeicherHilfe zeigt nun beim Hinzufügen von doppelten Speicherslots den Stacktrace an.

## v0.8.1

- 🐞 Bugfix: Der Hilfedialog bei fehlenden Kameras erscheint nun auf dem Bildschirm.

## v0.8.0

- ⭐ Neu: Neues Design (<http://material.angular.io>)
- ⭐ Neu: Steuerung von Kamera für Kreuzungen

## v0.7.0

- ⭐ Neu: Manuelle Schaltung von Kreuzungen
  - Schalte Deine Kreuzungen von Hand oder Automatisch

## v0.6.0

- ⭐ Neu: Anzeige von Zügen
- ⭐ Neu: Anzeige der Log-Datei

- ℹ️ Info: `AkStrasse` sollte nicht mehr importiert werden.

    Requires von Lua sollten immer einer lokalen Variable zugewiesen werden.
    Darum wird ab dieser Version die Funktion `require("ak.planer.AkStrasse")`
    nicht mehr empfohlen.

    **Import vor Version 0.6.0:**

    👎 **schlecht!**

    ```lua
    require("ak.planer.AkStrasse")
    ```

    **Import ab Version 0.6.0:**

    👍 **Besser!**

    ```lua
    local AkPlaner = require("ak.planer.AkPlaner")
    local AkAmpelModell = require("ak.strasse.AkAmpelModell")
    local AkAmpel = require("ak.strasse.AkAmpel")
    local AkRichtung = require("ak.strasse.AkRichtung")
    local AkKreuzung = require("ak.strasse.AkKreuzung")
    local AkKreuzungsSchaltung = require("ak.strasse.AkKreuzungsSchaltung")
    ```

- ⭐ Neu: Komplette Überarbeitung der Kommunikation (jetzt über Websockets ohne Polling)

## v0.5.0

- ⭐ Neu: Enthält EEP-Web (Tutorial **[EEP-Web installieren](https://andreas-kreuz.github.io/ak-lua-bibliothek-fuer-eep/anleitungen-fortgeschrittene/einrichten-von-eep-web)**)
- ⭐ Neu: Demo-Anlagen enthalten nun den Code für EEP-Web

  - **EEP-Web nutzen**

    Verwende eine der mitgelieferten Demo-Anlagen um EEP-Web zu nutzen (**[Installation](https://andreas-kreuz.github.io/ak-lua-bibliothek-fuer-eep/anleitungen-fortgeschrittene/einrichten-von-eep-web)**).

    In Deinem eigenden Code brauchst Du zwei Zeilen:

    - Lade AkStatistik mit require - dies machst Du in der Lua-Datei mit der `EEPMain()`-Methode:

    ```lua
    local AkStatistik = require("ak.io.AkStatistik")
    ```

    - Schreibe `AkStatistik.statistikAusgabe()` vor das `return 1` in Deiner `EEPMain()`-Methode:

    ```lua
    function EEPMain()
        -- Dein bisheriger Code

        AkStatistik.statistikAusgabe()
        return 1
    end
    ```

- ⭐ Neu: Richtung und Typ in AkRichtung angeben

  - Gib an, in welche Richtung die Fahrspuren zeigen:

    ```lua
    w1:setRichtungen({ 'STRAIGHT', 'RIGHT' })
    w2:setRichtungen({ 'LEFT' })
    ```

    *Tipp: Hast Du mehrere Richtungen, dann verwende die Reihenfolge `{ 'LEFT', 'STRAIGHT', 'RIGHT' }` für EEP-Web.*

    - Gib an, welcher Verkehrstyp die Fahrspur benutzt. So kannst Du in EEP-Web besser unterscheiden, welche Richtung grade geschaltet wird:

    - Verwende `PEDESTRIAN` für Fussgänger 🚶:

        ```lua
        richtung1:setTrafficType('PEDESTRIAN')
        ```

    - Verwende `TRAM` für Straßenbahnen 🚋:

        ```lua
        richtung2:setTrafficType('TRAM')
        ```

    - Verwende `NORMAL` für normalen Verkehr 🚗:

        ```lua
        richtung3:setTrafficType('NORMAL')
        ```

## v0.4.1

Neue Funktionen:

- ⭐ Neu: Generelle Unterstützung für Ampeln mit Immobilien sowie Licht-Funktionen.
  Dafür gibt es folgende neue Funktionen in AkAmpel:

- ⭐ Neu: Unterstützung für die Lichtsteuerung mehrerer Immobilien je Ampel:

  ```lua
  --- Schaltet das Licht der angegebenen Immobilien beim Schalten der Ampel auf rot, gelb, grün oder Anforderung
  -- @param rotImmo Name der Immobilie, deren Licht eingeschaltet wird, wenn die Ampel rot oder rot-gelb ist
  -- @param gruenImmo Name der Immobilie,  deren Licht eingeschaltet wird, wenn die Ampel grün ist
  -- @param gelbImmo Name der Immobilie,  deren Licht eingeschaltet wird, wenn die Ampel gelb oder rot-gelb ist
  -- @param anforderungImmo Name der Immobilie,  deren Licht eingeschaltet wird, wenn die Ampel eine Anforderung erkennt
  --
  function AkAmpel:fuegeLichtImmoHinzu(rotImmo, gruenImmo, gelbImmo, anforderungImmo) end
  ```

- ⭐ Neu: Unterstützung für die Achssteuerung mehrere Immobilien je Ampel:

  ```lua
  --- Ändert die Achsstellung der angegebenen Immobilien beim Schalten der Ampel auf rot, gelb, grün oder Fußgänger
  -- @param immoName Name der Immobilie, deren Achse gesteuert werden soll
  -- @param achsName Name der Achse in der Immobilie, die gesteuert werden soll
  -- @param grundStellung Grundstellung der Achse (wird eingestellt, wenn eine Stellung nicht angegeben wurde
  -- @param stellungRot Achsstellung bei rot
  -- @param stellungGruen Achsstellung bei grün
  -- @param stellungGelb Achsstellung bei gelb
  -- @param stellungFG Achsstellung bei FG
  --
  function AkAmpel:fuegeAchsenImmoHinzu(immoName, achsName, grundStellung,
  stellungRot, stellungGruen, stellungGelb, stellungFG) end
  ```

  Hier ein Beispiel für die Verwendung:

  ```lua
  local a1 = AkAmpel:neu(101, AkAmpelModell.JS2_2er_nur_FG)
  a1:fuegeAchsenImmoHinzu("#5816_Warnblink Fußgänger rechts", "Blinklicht", 0, nil, nil, nil, 50)
  local a2 = AkAmpel:neu(102, AkAmpelModell.JS2_2er_nur_FG)
  a2:fuegeAchsenImmoHinzu("#5815_Warnblink Fußgänger links", "Blinklicht", 0, nil, nil, nil, 50)
  ```

- ⭐ Neu: Die Achssteuerung unterstützt z.B. Modelle von Kju

  - Warnblinklichter <http://www.eep.euma.de/downloads/V80MA1F016.zip>
    ![Ampel mit Achsensteuerung](/docs/assets/web/immo-achsen.png)

## v0.4.0

- ⭐ Neu: Das Projekt heißt nun **[Lua-Bibliothek für EEP](https://andreas-kreuz.github.io/ak-lua-bibliothek-fuer-eep/)**

- ⭐ Neu: Erkennen von Verkehr an roten Signalen
  `richtung:zaehleAnSignalAlle(xx)`
  `richtung:zaehleAnSignalBeiRoute(xx)`

- ⭐ Neu: Erkennen von Verkehr auf Straßen
  `richtung:zaehleAnStrasseAlle(xx)`
  `richtung:zaehleAnStrasseBeiRoute(xx)`

- ⭐ Neu: Komplett neue Webseite
- ⭐ Neu: Verbesserter Tooltip für die Ampeln bei Anzeige der Debug-Informationen
- ⭐ Neu: Die Dokumentation liegt nun nicht mehr als PDF in der Anlage

## vorherige Versionen

- Aufbau einer API
