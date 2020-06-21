# Änderungen an der Software

## 0.10.6

- 🐞 Bugfix: Fix displaying traffic light states in Web App

## 0.10.5

- 🐞 Bugfix: Lua-Skript für die Grundmodelle-Demo wird korrekt geladen

## 0.10.4

- ⭐ Neu: Skript für das Tutorial `ak/demo-anlagen/tutorial-ampel/code-video-tutorial-3.lua`
- ⭐ Neu: Anlage für das Tutorial `Andreas_Kreuz-Tutorial-Ampelkreuzung-3-rechtsabbieger`

## 0.10.3

- ⭐ Neu: Skript für das Tutorial `ak/demo-anlagen/tutorial-ampel/code-video-tutorial-2.lua`

## 0.10.2

- ⭐ Neu: Skript für das Tutorial `ak/demo-anlagen/tutorial-ampel/code-video-tutorial-1.lua`

- 🐞 Bugfix: Unnötiger horizontaler Scroll-Balken im EEP-Web entfernt
- 🐞 Bugfix: Funktionsnamen in der Dokumentation korrigiert

## 0.10.1

- ⭐ Neu: Nutze `require("ak.template.eep-web-main")` in einer Anlage ohne eigenen Lua-Code um EEP-Web zu verwenden
- ⭐ Neu: Nutze `AkStartWithDebug=true` wenn Du ausführliche Informationen im Log sehen möchtest

## 0.10.0

- ⭐ Neu: Die Angabe von Ampeln und Schaltungen wurde von Grund auf neu gestaltet um die Anwendung zu vereinfachen.

- Jede Fahrspur `Lane` hat nur noch genau eine Fahrspur-Ampel. Dieses Ampel steuert den Verkehr.

- Jede Schaltung `CrossingSequence` schaltet Ampeln, keine Fahrspuren mehr.

- Einfache Schaltung: Es kann direkt die Fahrspur-Ampel angegeben werden: `switchingA:addTrafficLight(tl1)`

  ```lua
  local c1 = Crossing:new("Bahnhofstr. - Hauptstr.")
  local K1 = TrafficLight:new("K1", 34, TrafficLightModel.JS2_3er_mit_FG, { "STRAIGHT", "RIGHT" })

  -- Einfache Steuerung direkt über die Fahrspur-Ampel K1 - diese ist sichtbar und wird direkt verwendet
  c1Lane1 = c1:newLane("Fahrspur 1 - K1", 101, K1)
  sequenceA = c1:newSequence("Schaltung A")
  sequenceA:addTrafficLight(K1)
  ```

- Komplexe Schaltung: Die Fahrspur darf bei mehreren Ampeln fahren `lane:driveOn(trafficLight, [route])`.
  Optional kann dabei eine Route angegeben werden:

  ```lua
  local c1 = Crossing:new("Bahnhofstr. - Hauptstr.")
  local LANE_SIGNAL1 = TrafficLight:new("SIGNAL1", 34, TrafficLightModel.Unsichtbar_2er)
  local K1 = TrafficLight:new("K1", 35, TrafficLightModel.JS2_3er_mit_FG)           -- Ampel für grade/rechts
  local K2 = TrafficLight:new("K2", 36, TrafficLightModel.JS2_2er_OFF_YELLOW_GREEN) -- Ampel nur Rechtsabbieger

  -- Erweiterte Steuerung indirekt die Signale K1 und K2 - die Fahrspur-Ampel ist unsichtbar
  c1Lane1 = c1:newLane("Fahrspur 1 - K1", 101, K1)
  c1Lane8:driveOn(K1)
  c1Lane8:driveOn(K2, "Route Rechtsabbieger") -- K2 wird mit Route Rechtsabbieger verknüpft

  sequenceA = c1:newSequence("Schaltung A") -- alle in Fahrspur c1Lane1 fahren
  sequenceA:addTrafficLight(K1)

  sequenceB = c1:newSequence("Schaltung B") -- nur Rechtsabbieger in Fahrspur c1Lane1 fahren
  sequenceB:addTrafficLight(K2)
  ```

- Anforderungen der Fahrspuren können an Signalen gezeigt werden, die dies unterstützen
  `lane:showRequestsOn(trafficLight)`:

  ```lua
  local S4 = TrafficLight:new("S4", 95, TrafficLightModel.Unsichtbar_2er, "#5525_Straba Signal Halt",
                              "#5436_Straba Signal rechts", "#5526_Straba Signal anhalten", "#5524_Straba Signal A")
  c1Lane11 = Lane:new("K1 - Fahrspur 11", 11, S4, {Lane.Directions.RIGHT}, Lane.Type.TRAM)
  c1Lane11:showRequestsOn(S4)
  ```

- Fahrspuren für Fußgänger werden nicht mehr unterstützt
  (stattdessen werden die Fußgängerampeln in der Schaltung hinterlegt).

- Die Web-App Einstellungen für die Anzeige der Signale können in der Anlage hinterlegt werden.
  Der folgende Befehl lädt die Daten beim Start aus EEP Speicherslot 22: `Crossing.loadSettingsFromSlot(22)`.

- ⭐ Neu: Umbenennung verschiedener Lua-Dateien und Namen
  - ~~`ak.core.eep.AkEepFunktionen`~~ => `ak.core.eep.EepSimulator`
  - ~~`ak.core.eep.AkTippTextFormat`~~ => `ak.core.eep.TippTextFormatter`
  - ~~`ak.planer.AkAktion`~~ => `ak.scheduler.Task`
  - ~~`ak.planer.AkPlaner`~~ => `ak.scheduler.Scheduler`
  - ~~`ak.planer.PlanerLuaModul`~~ => `ak.scheduler.SchedulerLuaModule`
  - ~~`ak.schiene.AkSchiene`~~ => `ak.rail.Rail`
  - ~~`ak.speicher.AkSpeicher.lua`~~ => `ak.storage.StorageUtility.lua`
  - ~~`ak.speicher.AkSpeicherTest.lua`~~ => `ak.storage.StorageUtilityTest.lua`
  - ~~`ak.strasse.AkAchsenImmoAmpel`~~ => `ak.road.AxisStructureTrafficLight`
  - ~~`ak.strasse.AkAmpelModell`~~ => `ak.road.TrafficLightModel`
  - ~~`ak.strasse.AkAmpel`~~ => `ak.road.TrafficLight`
  - ~~`ak.strasse.AkBus`~~ => `road.Bus`
  - ~~`ak.strasse.AkKreuzung`~~ => `ak.road.Crossing`
  - ~~`ak.strasse.AkKreuzungsSchaltung`~~ => `ak.road.CrossingSequence`
  - ~~`ak.strasse.AkLichtImmoAmpel`~~ => `ak.road.LightStructureTrafficLight`
  - ~~`ak.strasse.AkPhase`~~ => `ak.road.TrafficLightState`
  - ~~`ak.strasse.AkRichtung`~~ => `ak.road.Lane` ℹ Das Konzept Richtung wurde komplett überarbeitet!
  - ~~`ak.strasse.AkStrabWeiche`~~ => `ak.road.TramSwitch`
  - ~~`ak.strasse.AkStrasse`~~ wurde entfernt
  - ~~`ak.strasse.AmpelModellJsonCollector`~~ => `ak.road.TrafficLightModelJsonCollector`
  - ~~`ak.strasse.KreuzungJsonCollector`~~ => `ak.road.CrossingJsonCollector`
  - ~~`ak.strasse.KreuzungLuaModul`~~ => `ak.road.CrossingLuaModul`
  - ~~`ak.strasse.KreuzungWebConnector`~~ => `ak.road.CrossingWebConnector`

## 0.9.0

- ⭐ Neu: Umschalten der Debug-Einstellungen für Kreuzungen in der Web-App
- ⭐ Neu: Ein Projekt, alle Inhalte (Lua, Server und Web App in einem Projekt)
- ⭐ Neu: Daten für den Server werden nur noch dann geschrieben, wenn der Server gestartet ist
- ⭐ Neu: Module:
  - Werden nur dann geladen, wenn sie registriert wurden
  - Werden nur dann in EEP-Web angezeigt, wenn sie geladen wurden
- ⭐ Neu: Einmaliges Suchen nach globalen Daten macht das Ganze schneller
- ⭐ Neu: Warnung, wenn die Datenausgabe länger dauert, als der refresh, der in EEPMain aufgerufen wird

ℹ️ Wichtige Informationen

Der Code wurde wie folgt geändert:

- `ak.core.eep.EepSimulator` ersetzt die alte Datei ~~`ak.eep.EepSimulator`~~
- `ak.core.eep.AkTippTextFormat` ersetzt die alte Datei ~~`ak.text.AkFormat`~~
- 👎 **Bisheriger Code** (funktioniert so nicht mehr!)

  ```lua
    function EEPMain()
      AkKreuzung:planeSchaltungenEin()
      Scheduler:fuehreGeplanteAktionenAus()
      AkStatistik.statistikAusgabe()
      return 1
  end
  ```

  👍 **Neuer Code**

  ```lua
  local ModuleRegistry = require("ak.core.ModuleRegistry")
  ModuleRegistry.registerModules(
      require("ak.core.CoreLuaModule"),
      require("ak.data.DataLuaModule"),
      require("ak.strasse.KreuzungLuaModul")
  )

  function EEPMain()
      ModuleRegistry.runTasks()
      return 1
  end
  ```

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
  Darum wird ab dieser Version die Funktion `require("ak.scheduler.AkStrasse")`
  nicht mehr empfohlen.

  **Import vor Version 0.6.0:**

  👎 **schlecht!**

  ```lua
  require("ak.scheduler.AkStrasse")
  ```

  **Import ab Version 0.6.0:**

  👍 **Besser!**

  ```lua
  local Scheduler = require("ak.scheduler.Scheduler")
  local AkAmpelModell = require("ak.strasse.AkAmpelModell")
  local AkAmpel = require("ak.strasse.AkAmpel")
  local AkRichtung = require("ak.strasse.AkRichtung")
  local AkKreuzung = require("ak.strasse.AkKreuzung")
  local AkKreuzungsSchaltung = require("ak.strasse.AkKreuzungsSchaltung")
  ```

- ⭐ Neu: Komplette Überarbeitung der Kommunikation (jetzt über Websockets ohne Polling)

## v0.5.0

- ⭐ Neu: Enthält EEP-Web (Tutorial **[EEP-Web installieren](https://andreas-kreuz.github.io/ak-lua-bibliothek-fuer-eep/anleitungen-anfaenger/einrichten-von-eep-web)**)
- ⭐ Neu: Demo-Anlagen enthalten nun den Code für EEP-Web

  - **EEP-Web nutzen**

    Verwende eine der mitgelieferten Demo-Anlagen um EEP-Web zu nutzen (**[Installation](https://andreas-kreuz.github.io/ak-lua-bibliothek-fuer-eep/anleitungen-anfaenger/einrichten-von-eep-web)**).

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

    _Tipp: Hast Du mehrere Richtungen, dann verwende die Reihenfolge `{ 'LEFT', 'STRAIGHT', 'RIGHT' }` für EEP-Web._

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
