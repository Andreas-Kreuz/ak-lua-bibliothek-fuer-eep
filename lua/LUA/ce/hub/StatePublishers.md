# Gemeinsamkeiten der `*StatePublisher`-Klassen

Alle Klassen unter `lua/LUA/ce/**/*StatePublisher.lua` folgen demselben Grundmuster für den Export von Lua- und EEP-Daten in Richtung Web-/Server-Schicht:

1. Gemeinsame Schnittstelle
   - Jeder Collector exportiert genau ein Lua-Modul mit `name`, `initialize()` und `syncState()`.
   - Diese Form wird beim Registrieren im `ce.hub.StatePublisherRegistry` validiert; dort werden genau diese Felder geprüft.

2. Registrierung über BridgeConnector-Module
   - Collector werden nicht direkt von Fachlogik genutzt, sondern über ein passendes `*BridgeConnector`-Modul beim `StatePublisherRegistry` angemeldet.
   - Dadurch bleiben Domänenlogik und Web-Export lose gekoppelt.

3. Singleton-artiger Modulzustand
   - Jeder Collector ist eine modulweite Tabelle mit lokal gehaltenem Zustand.
   - Typisch sind lokale Flags wie `enabled` und `initialized` sowie Caches oder Snapshots für bereits bekannte Objekte.

4. Zweiphasiger Lebenszyklus
   - `initialize()` ist für einmalige Vorbereitung gedacht, zum Beispiel Initialsuche, Indexaufbau oder das Merken bereits bekannter Objekte.
   - `initialize()` wird im regulären Ablauf vom `ce.hub.MainLoopRunner` einmal pro registriertem StatePublisher aufgerufen.
   - `syncState()` wird danach ebenfalls vom `MainLoopRunner` in jedem Zyklus ausgeführt.
   - Viele StatePublisher sind trotzdem idempotent aufgebaut und behalten ein lokales `initialized`-Flag, damit zusätzliche oder direkte Aufrufe keinen ungewollten Effekt haben.

5. Adapter zwischen EEP/Fachmodulen und API-Daten
   - Die Collector lesen ihren Zustand entweder direkt über EEP-Funktionen oder über fachliche Registries oder Modelle des Projekts.
   - Dabei formen sie interne Zustände in flache, webtaugliche Tabellen mit stabilen Kennungen wie `id` oder `name` um.
   - Änderungen des Zustandes werden über `DataChangeBus.fire*()` bekanntgemacht. Dabei wird immer ein eindeutiger Identifier übergeben.

6. Ereignisgetriebener Export
   - Der eigentliche Datentransport läuft primär über Events.
   - Die meisten Collector senden ihre Ergebnisse über `ce.hub.publish.DataChangeBus`, meist als `fireListChange(...)`, teilweise auch granularer wie `fireDataAdded(...)` oder `fireDataChanged(...)`.
   - Auch dort, wo `syncState()` nominal Daten zurückgeben kann, ist der Event-Strom in der Praxis meist der relevante Ausgabekanal.

7. Rückgabewerte sind Nebenkanal oder Kompatibilitätsschicht
   - Viele Collector geben bewusst `{}` oder nur kommentierte Platzhalter zurück.
   - Das passt zur Verwendung im `MainLoopRunner`: Die Rückgabewerte von `syncState()` werden dort nicht weiterverarbeitet, während die aktuellen Collector ihre Nutzdaten überwiegend schon während `syncState()` per Event veröffentlichen.
   - Wenn ein Collector doch Tabellen zurückgibt, müssen sie nur serialisierbare Werte enthalten; Funktionen oder nicht-string-/nicht-number-Schlüssel sind unzulässig.

8. API-orientierte Datenform
   - Exportierte Listen enthalten nach Möglichkeit ein eindeutiges Feld (`id` oder `name`), weil Web-Clients und Änderungsereignisse damit arbeiten.
   - Mehrere Collector erzeugen nicht nur reine Zustandslisten, sondern auch Settings- oder Metadatenlisten, damit die Web-Oberfläche Fachmodule einheitlich darstellen und fernsteuern kann.

Zusammengefasst sind `*StatePublisher` im Projekt keine isolierten Datenklassen, sondern zustandsbehaftete Adapter mit einheitlichem Lebenszyklus: über BridgeConnectoren registrieren, vom `StatePublisherRegistry` verwalten, vom `MainLoopRunner` initialisieren und dann zyklisch Zustand lesen und Änderungen über die Event- und Server-Infrastruktur veröffentlichen.
