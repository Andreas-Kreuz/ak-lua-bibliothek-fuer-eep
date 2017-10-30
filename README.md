# Lua-Skripte für EEP

Die Skripte und Beispiel-Anlagen werden für die Verwendung in Eisenbahn.exe professional bereitgestellt.

Es wurde darauf geachtet, dass die Klassen mit "Ak" beginnen, so dass es keine Namenskonflikte gibt.

## Verfügbare Pakete

### Beispielanlagen in `ak-demo-anlagen` deren Skripte in `ak-demo-lua`
* __[ak-demo-anlagen/ampel](ak-demo-anlagen/ampel/) - Demonstration der Ampelschaltungen__ - Diese Anlage zeigt die Grundlagen anhand zweier Schaltungen (nur mit Grundmodellen aus EEP 14)
* __[ak-demo-anlagen/testen](ak-demo-anlagen/testen/) - Demonstration des Testens__ - Der Aufbau der Skripte dieser Anlage zeigt, wie man ohne EEP testen kann, siehe [ak-demo-lua/testen](ak-demo-lua/testen/)

### Skripte in `ak`
* __[ak/eep](ak/eep/)__ - EEP-eigene Funktionen für Testskripte
* __[ak/eisenbahn](ak/eisenbahn/)__ Steuerung für die Eisenbahn (IN ARBEIT)
* __[ak/modellpacker](ak/modellpacker/)__ - Erzeugt Installationsdateien
* __[ak/planer](ak/planer/)__ - Aufgabenplaner für EEP
* __[ak/speicher](ak/speicher/)__ - Speichern und Laden von String-Tabellen
* __[ak/strasse](ak/strasse/)__ - Steuerung für den Straßenverkehr


## Anstehende Aufgaben

* [x] Anlagen mit EEP-Installer bereitstellen
* [x] ak/strasse - Umstellen auf deutsche Funktionsnamen
* [x] ak/planer - Umstellen auf deutsche Funktionsnamen
* [ ] ak/strasse - Dokumentieren, welche Funktionen öffentlich verwendet werden sollen
* [ ] ak/strasse - Demo-Anlage mit einem Kauf-Ampelset und Strassenbahn-Ampeln Grundmodellen
* [ ] ak/strasse - ausführliche Dokumentation für den Aufbau einer Ampelkreuzung
* [ ] ak/strasse - Vorrangschaltung mit Prüfung auf Gleisbelegung in EEP (EEPRegisterTrack)
* [ ] ak/strasse - Ausführliches Testskript, welches Kreuzungen anlegt und die Schaltungen prüft - Vorrangschaltung usw.
* [ ] ak/planer - Ausgabe der geplanten Aufgaben in eine Text-Datei


## Geplante Aufgaben

* [ ] ak/eisenbahn - Allgemein verbessern, besonders Übersetzung, Test, Verallgemeinerung der Funktionen
