# Zielarchitektur der Lua-Bibliothek

Diese Datei beschreibt das angestrebte Zielbild des Lua-Teils der Bibliothek.
Sie dokumentiert bewusst nicht den heutigen Ist-Zustand, sondern die fachlich gewünschte Aufteilung der Verantwortlichkeiten für einen schrittweisen Umbau.

## Architekturprinzipien

Die Zielarchitektur soll den Lua-Code in drei klar getrennte Bereiche aufteilen:

1. `hub`
   - gemeinsame Laufzeit-, Daten- und Event-Infrastruktur
2. `bridge`
   - Kommunikation mit dem Server und dateibasierter Austausch
3. `modules`
   - Fachlogik wie Straße, Schiene und ÖPNV

Daraus folgen diese Leitlinien:

- jede Datei soll eine kleine, klar benannte Verantwortung haben
- fachlicher Zustand und Server-Kommunikation sollen getrennt bleiben
- öffentliche Einstiegspunkte sollen stabil bleiben, interne Pfade gelten als Infrastruktur
- modulbezogenes Publishing soll beim jeweiligen Owner bleiben
- generische Infrastruktur soll keine Fachsemantik kennen

## Hub

Der Hub ist die interne Plattform des Lua-Teils. Er soll keine Server-I/O kapseln, sondern die gemeinsame Laufzeit und Datenhaltung bereitstellen.

### `hub`

Direkt unter `hub/` sollen die zentralen Laufzeitbausteine der gesamten Lua-Laufzeit liegen:

- Modul-Lebenszyklus
- Registrieren und Ausführen von Modulen
- Registrieren und Ausführen von `StatePublisher`
- DTO-Factories und Publisher für hub-weite Metadaten

Typische Verantwortungen in diesem Bereich:

- `ModuleRegistry` als zentraler Einstieg für die registrierten Lua-Module
- `MainLoopRunner` als Orchestrierung des Zyklus
- `StatePublisherRegistry` als Verwaltung der Publishing-Adapter
- `*CeModule.lua` direkt unter `hub/`

Diese Ebene soll nicht selbst für Dateiaustausch, Logging-Dateien oder Remote-Kommandos verantwortlich sein. Diese Verantwortung gehört in die Bridge.

### `hub/scheduler`

`hub/scheduler` soll die gemeinsame Ablaufhilfe für zeitversetzte Aktionen enthalten:

- `Scheduler`
- `Task`
- weitere scheduler-nahe Helfer

Der Scheduler bleibt Teil des Hubs, ist aber kein eigener Laufzeit-Hauptbereich mehr neben `hub`, sondern eine klar abgegrenzte Unterkategorie.

### `hub/eep`

`hub/eep` soll technische EEP-Adapter und Simulator-Unterstützung enthalten:

- Wrapper um EEP-Funktionen
- Simulator-Unterstützung für Tests
- Hilfen für EEP-spezifische Text- und Anzeigeformate

### `hub/data`

`hub/data` soll alle gemeinsam genutzten Datenbereiche bündeln:

- DTO-Verträge
- Collectors für allgemeine EEP-Daten
- Registries und Snapshots
- DtoFactories für Hub-eigene Daten
- materialisierte Zustände wie `InternalDataStore`

Unterbereiche des Zielbilds:

- `contracts`
  - gemeinsame DTO-Definitionen wie `DtoTypes.d.lua` und `DtoTypes.d.md`
- `slots`
  - Datenslot-Namen, Datenslot-DTOs und Datenslot-Publisher
- `signals`
  - Signalerkennung, Signal-DTOs und Signal-Publisher
- `switches`
  - Weichenerkennung, Weichen-DTOs und Weichen-Publisher
- `structures`
  - Struktur-Erkennung, Struktur-DTOs und Struktur-Publisher
- `time`
  - Zeit-DTOs und Zeit-Publisher
- `tracks`
  - Gleiserkennung und Gleis-DTOs
- `trains`
  - Zugmodelle, Zugerkennung, Zugregistries und zugehöriges Publishing
- `rollingstock`
  - Rollmaterialmodelle, Registries, Tags und Rollmaterial-DTOs
- `store`
  - materialisierte Snapshots und zustandsbezogene Hilfen

Wichtig: Zug-, Gleis- und Rollmaterialdaten sollen im Zielbild Teil des Hub-Datenbereichs sein und kein eigenständiges Plugin darstellen.

### `hub/publish`

`hub/publish` soll die generische Event-Infrastruktur bereitstellen:

- `DataChangeBus`
- Eventtypen
- gemeinsame Regeln für das Veröffentlichen von Zustandsänderungen

Dabei gilt:

- `DataChangeBus` soll generisch bleiben
- der Bus soll keine Fachobjekte interpretieren
- der Bus soll nicht selbst fest verdrahten, welche Listener registriert werden

Die Verdrahtung von Listenern wie `InternalDataStore` oder `ServerEventBuffer` soll außerhalb des Busses erfolgen.

### `hub/util`

`hub/util` soll technische Helfer enthalten, die nicht zur Fachdomäne gehören:

- Tabellen- und Queue-Helfer
- Laufzeitmetriken
- Typdefinitionen für Utilities
- Persistenzhilfen wie `StorageUtility`

`storage` ist in diesem Zielbild kein eigener Hauptbereich mehr, sondern eine Unterkategorie des Hubs.

## DataBridge

Die DataBridge soll sämtliche Kommunikation zwischen Lua und Server kapseln, ohne selbst fachlichen Zustand zu besitzen.

Im Zielbild liegt dieser Bereich unter `bridge/server`.

Seine Verantwortung umfasst:

- Initialisierung der I/O-Infrastruktur
- Verwaltung des Austauschverzeichnisses
- Lesen und Ausführen erlaubter Remote-Kommandos
- Puffern und Schreiben ausgehender Events
- Dateihandshake mit dem Server
- Spiegelung von Logausgaben in Austauschdateien

Typische Unterbereiche:

- `init`
  - I/O-Initialisierung und Austauschverzeichnis
- `commands`
  - erlaubte Kommandos und Kommandoeingabe
- `output`
  - Eventbuffer, Logausgabe, optionale JSON-Snapshots
- `exchange`
  - Dateiprotokoll und Server-Austausch
- `connectors`
  - Verdrahtung zwischen Hub bzw. Modulen und der Bridge

Die Bridge soll keinen eigenen Fachzustand pflegen. Sie transportiert, puffert, liest und schreibt nur.

Der modernere Name für diese Verdrahtung ist im Zielbild `ServerConnector`. Historische Namen wie `WebConnector` können in bestehendem Code oder älterer Dokumentation noch vorkommen, sollen aber langfristig durch die präzisere Verantwortungsbezeichnung ersetzt werden.

## Module

Unter `modules` soll die Fachlogik liegen. Hierzu gehören insbesondere:

- `road`
- `rail`
- `transit`

Jedes Fachmodul soll intern mindestens zwischen zwei Rollen unterscheiden:

1. Domänenlogik
   - Modelle, Regeln, Zustandsübergänge, Registries und EEP-Fachlogik
2. modulbezogenes Publishing
   - modulbezogene `StatePublisher`
   - modulbezogene DtoFactories
   - modulbezogene Server-Connectoren

Das bedeutet insbesondere:

- `Crossing`, `Line`, `RoadStation` oder `Rail` gehören zur Domänenlogik
- `RoadStatePublisher` oder `TransitStatePublisher` bleiben beim jeweiligen Modul
- modulbezogene DtoFactories bleiben ebenfalls beim jeweiligen Modul

Die Module sollen ihre Fachdaten besitzen und veröffentlichen, aber keine generische Server-Infrastruktur nachbauen.

## Laufzeitfluss

Der gewünschte Laufzeitfluss ist:

1. `ce.ControlExtension` dient als stabiler Einstiegspunkt für EEP-Skripte.
2. `ModuleRegistry` registriert die verwendeten Lua-Module.
3. `MainLoopRunner` führt Initialisierung und Zyklus aus.
4. Module registrieren ihre `StatePublisher` über die dafür vorgesehenen Connectoren.
5. `StatePublisher` lesen Zustand aus Hub- oder Modulbereichen.
6. Änderungen werden über `DataChangeBus` veröffentlicht.
7. `InternalDataStore` kann daraus einen materialisierten Snapshot halten.
8. `ServerEventBuffer` nimmt veröffentlichte Events für die Bridge entgegen.
9. Die Bridge schreibt Austauschdateien und liest Remote-Kommandos.

Wichtig ist dabei die Trennung der Rollen:

- `MainLoopRunner` orchestriert
- `DataChangeBus` verteilt Events
- `InternalDataStore` hält Snapshot-Daten
- `ServerEventBuffer` puffert für den Transport
- die Bridge übernimmt ausschließlich den Austausch mit dem Server

## Zielstruktur im Repository

Die Zielstruktur soll in kompakter Form so aussehen:

```text
lua/LUA/ce/
  ControlExtension.lua
  hub/
    CoreCeModule.lua
    DataCeModule.lua
    MainLoopRunner.lua
    ModuleRegistry.lua
    StatePublisherRegistry.lua
    scheduler/
    eep/
    data/
      contracts/
      slots/
      signals/
      switches/
      structures/
      time/
      tracks/
      trains/
      rollingstock/
      store/
    publish/
    util/
  bridge/
    server/
      init/
      commands/
      output/
      exchange/
      connectors/
  modules/
    road/
    rail/
    transit/
```

Diese Darstellung ist bewusst kompakt gehalten. Sie soll die Verantwortlichkeiten zeigen und nicht jede einzelne Datei vollständig aufzählen.

## Öffentliche Schnittstellen

Stabil gehalten werden sollen nur wenige öffentliche Einstiegspunkte:

- `ce.ControlExtension`
- `ce.modules.road.RoadCeModule`
- `ce.modules.transit.TransitCeModule`
- perspektivisch weitere Einstiegspunkte unter `ce.modules.rail.*`

Interne Pfade unter `ce.hub.*` und `ce.bridge.*` sind Infrastruktur und sollen nicht als stabile öffentliche API behandelt werden.

## StatePublisher im Zielbild

`StatePublisher` sind in diesem Projekt keine bloßen Datenklassen. Sie sind zustandsbehaftete Publishing-Adapter mit einheitlichem Lebenszyklus:

- sie werden registriert
- einmalig initialisiert
- zyklisch synchronisiert
- veröffentlichen Änderungen in Richtung Event- und Bridge-Infrastruktur

Die gemeinsamen Muster der `*StatePublisher` sind weiterhin in [StatePublishers.md](./hub/StatePublishers.md) dokumentiert. Diese Dokumentation ist im Licht des Zielbilds zu lesen: `StatePublisher` gehören fachlich zum Publishing ihrer jeweiligen Owner und nicht zu einer generischen Datenablage.

## Dokumentationskonsequenzen

Diese Datei ist als führende Zielbild-Dokumentation auf Root-Ebene gedacht.

Andere Dokumente können vorübergehend noch historische Begriffe oder den aktuellen Ist-Zustand beschreiben, zum Beispiel:

- `hub/StatePublishers.md`
- `hub/README.md`
- `databridge/ARCHITECTURE.md`
- Modul-READMEs

Wenn diese Dokumente Begriffe wie `WebConnector` oder ältere Paketgrenzen verwenden, ist diese Datei für das Zielbild maßgeblich.
