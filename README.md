# Lua-Skripte für EEP

Die Skripte und Beispiel-Anlagen werden für die Verwendung in Eisenbahn.exe professional bereitgestellt.

Es wurde darauf geachtet, dass die Klassen mit "Ak" beginnen, so dass es keine Namenskonflikte gibt.

## Verfügbare Pakete

## Beispielanlagen in `ak-demo-anlagen` deren Skripte in `ak-demo-lua`
* [ak-demo-anlagen/ampel](ak-demo-anlagen/ampel/) - __Demonstration der Ampelschaltungen__ - Diese Anlage zeigt die Grundlagen anhand zweier Schaltungen (nur mit Grundmodellen aus EEP 14)
* [ak-demo-anlagen/testen](ak-demo-anlagen/testen/) - __Demonstration des Testens__ - Der Aufbau der Skripte dieser Anlage zeigt, wie man ohne EEP testen kann, siehe [ak-demo-lua/testen](ak-demo-lua/testen/)

### Skripte in `ak`
* __[ak/eep](ak/eep/README.md)__ - EEP-eigene Funktionen für Testskripte
* __[ak/eisenbahn](ak/eisenbahn/README.md)__ Steuerung für die Eisenbahn (IN ARBEIT)
* __[ak/modellpacker](ak/modellpacker/README.md)__ - Erzeugt Installationsdateien
* __[ak/planer](ak/planer/README.md)__ - Aufgabenplaner für EEP
* __[ak/speicher](ak/speicher/README.md)__ - Speichern und Laden von String-Tabellen
* __[ak/strasse](ak/strasse/README.md)__ - Steuerung für den Straßenverkehr



## TODOs

* [x] Anlagen mit EEP-Installer bereitstellen
* [ ] ak/strasse - umstellen auf deutsche Funktionsnamen
* [ ] ak/strasse - dokumentieren, welche Funktionen öffentlich verwendet werden sollen
* [ ] ak/strasse - Demo-Anlage mit einem Kauf-Ampelset und  Strassenbahn-Ampeln Grundmodellen
* [ ] ak/strasse - ausführliche Dokumentation für den Aufbau einer Ampelkreuzung
* [ ] ak/strasse - Vorrangschaltung mit Prüfung auf Gleisbelegung in EEP (EEPRegisterTrack)
* [ ] ak/strasse - Ausführliches Testskript, welches Kreuzungen anlegt und die Schaltungen prüft - Vorrangschaltung usw.
* [ ] ak/planer - Ausgabe der geplanten Aufgaben in eine Text-Datei

## Geplant

* [ ] ak/eisenbahn - Allgemein verbessern, besonders Übersetzung, Test, Verallgemeinerung der Funktionen
