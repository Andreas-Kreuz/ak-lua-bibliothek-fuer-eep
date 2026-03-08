# Gemeinsamkeiten der `*StatePublisher`-Klassen

Alle Klassen unter `lua/LUA/ak/**/*StatePublisher.lua` folgen demselben Grundmuster fuer den Export von Lua- und EEP-Daten in Richtung Web-/Server-Schicht:

1. Gemeinsame Schnittstelle
   - Jeder Collector exportiert genau ein Lua-Modul mit `name`, `initialize()` und `syncState()`.
   - Diese Form wird beim Registrieren im `ak.core.StatePublisherRegistry` validiert; dort werden genau diese Felder geprueft.

2. Registrierung ueber WebConnector-Module
   - Collector werden nicht direkt von Fachlogik genutzt, sondern ueber ein passendes `*WebConnector`-Modul beim `StatePublisherRegistry` angemeldet.
   - Dadurch bleiben Domaenenlogik und Web-Export lose gekoppelt.

3. Singleton-artiger Modulzustand
   - Jeder Collector ist eine modulweite Tabelle mit lokal gehaltenem Zustand.
   - Typisch sind lokale Flags wie `enabled` und `initialized` sowie Caches oder Snapshots fuer bereits bekannte Objekte.

4. Zweiphasiger Lebenszyklus
   - `initialize()` ist fuer einmalige Vorbereitung gedacht, zum Beispiel Initialsuche, Indexaufbau oder das Merken bereits bekannter Objekte.
   - `initialize()` wird im regulaeren Ablauf vom `ak.core.MainLoopRunner` einmal pro registriertem StatePublisher aufgerufen.
   - `syncState()` wird danach ebenfalls vom `MainLoopRunner` in jedem Zyklus ausgefuehrt.
   - Viele StatePublisher sind trotzdem idempotent aufgebaut und behalten ein lokales `initialized`-Flag, damit zusaetzliche oder direkte Aufrufe keinen ungewollten Effekt haben.

5. Adapter zwischen EEP/Fachmodulen und API-Daten
   - Die Collector lesen ihren Zustand entweder direkt ueber EEP-Funktionen oder ueber fachliche Registries oder Modelle des Projekts.
   - Dabei formen sie interne Zustaende in flache, webtaugliche Tabellen mit stabilen Kennungen wie `id` oder `name` um.
   - Änderungen des Zustandes werden über `DataChangeBus.fire*()` bekanntgemacht. Dabei wird immer ein eindeutiger Identifier übergeben.

6. Ereignisgetriebener Export
   - Der eigentliche Datentransport laeuft primaer ueber Events.
   - Die meisten Collector senden ihre Ergebnisse ueber `ak.events.DataChangeBus`, meist als `fireListChange(...)`, teilweise auch granularer wie `fireDataAdded(...)` oder `fireDataChanged(...)`.
   - Auch dort, wo `syncState()` nominal Daten zurueckgeben kann, ist der Event-Strom in der Praxis meist der relevante Ausgabekanal.

7. Rueckgabewerte sind Nebenkanal oder Kompatibilitaetsschicht
   - Viele Collector geben bewusst `{}` oder nur kommentierte Platzhalter zurueck.
   - Das passt zur Verwendung im `MainLoopRunner`: Die Rueckgabewerte von `syncState()` werden dort nicht weiterverarbeitet, waehrend die aktuellen Collector ihre Nutzdaten ueberwiegend schon waehrend `syncState()` per Event veroeffentlichen.
   - Wenn ein Collector doch Tabellen zurueckgibt, muessen sie nur serialisierbare Werte enthalten; Funktionen oder nicht-string-/nicht-number-Schluessel sind unzulaessig.

8. API-orientierte Datenform
   - Exportierte Listen enthalten nach Moeglichkeit ein eindeutiges Feld (`id` oder `name`), weil Web-Clients und Aenderungsereignisse damit arbeiten.
   - Mehrere Collector erzeugen nicht nur reine Zustandslisten, sondern auch Settings- oder Metadatenlisten, damit die Web-Oberflaeche Fachmodule einheitlich darstellen und fernsteuern kann.

Zusammengefasst sind `*StatePublisher` im Projekt keine isolierten Datenklassen, sondern zustandsbehaftete Adapter mit einheitlichem Lebenszyklus: ueber WebConnectoren registrieren, vom `StatePublisherRegistry` verwalten, vom `MainLoopRunner` initialisieren und dann zyklisch Zustand lesen und Aenderungen ueber die Event- und Server-Infrastruktur veroeffentlichen.
