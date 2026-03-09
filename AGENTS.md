# AGENTS.md

## Projektkontext

- Dieses Repository enthält eine Lua-Bibliothek für EEP (`lua/LUA/ak`) sowie eine optionale Web-Oberfläche mit Server.
- Die Lua-Module sind der Kern des Projekts. Web-Server und Web-App sind Zusatzwerkzeuge für Anzeige, Steuerung und Tests.
- Wichtige Bereiche:
  - `lua/LUA/ak`: produktiver Lua-Code für EEP
  - `lua/LUA/spec`: Lua-Tests
  - `apps/web-app`: React/Vite-Frontend
  - `apps/web-server`: Electron- und Headless-Server
  - `packages/web-shared`: gemeinsam genutzte TypeScript-Typen und Events
  - `docs`: statische Dokumentation / Website

## Arbeitsregeln

- Änderungen möglichst lokal und minimal halten. In diesem Repo sind viele Module zustandsbehaftet; kleine gezielte Patches sind besser als breite Refactorings.
- Lua-Dateien verwenden das Charset latin1, alle anderen Dateien utf-8 (vergleiche .editorconfig)

## Dateikodierung

- Alle Dateien mit der Endung `.lua` sind immer als `latin1` / `ISO-8859-1` zu lesen und zu schreiben.
- Alle anderen Dateien sind als `UTF-8` zu lesen und zu schreiben.
- Bei Shell-Kommandos zum Lesen oder Schreiben von `.lua`-Dateien immer die Kodierung explizit auf `latin1` setzen.
- Die Kodierung bestehender Dateien muss beim Bearbeiten erhalten bleiben; `.lua`-Dateien duerfen niemals versehentlich als `UTF-8` zurueckgeschrieben werden.
- Wenn ein Tool keine Kodierung pro Datei explizit setzen kann, fuer Aenderungen an `.lua`-Dateien lieber ein geeignetes Shell-Kommando mit `latin1` verwenden als eine Aenderung mit unklarer Kodierung vorzunehmen.
- Fuer PowerShell gilt:
  - `.lua` lesen: `Get-Content -Encoding Latin1`
  - `.lua` schreiben: `Set-Content -Encoding Latin1`
  - andere Dateien lesen: `Get-Content -Encoding UTF8`
  - andere Dateien schreiben: `Set-Content -Encoding UTF8`

## Lua-Hinweise

- Im Repository liegt der produktive Lua-Code unter `lua/LUA/`; im installierten EEP-System liegen diese Lua-Dateien standardmäßig unter `C:\Trend\EEP18\LUA` (je nach EEP-Version entsprechend z.B. `EEP17`, `EEP18`).
- Bestehende deutsche Bezeichner, Kommentare und Logmeldungen beibehalten, wenn du vorhandenen Lua-Code änderst.
- Beschreibungen für Funktionen, Parameter und Return-Werte gerne aus dem Lua-Manual übernehmen.
- `Lua_manual.pdf` wird in diesem Projekt mit `pdftotext -layout` ausgewertet. Dabei enthält Spalte 1 den Feldnamen wie `Parameter`, `Rückgabewerte`, `Voraussetzung`, `Zweck` oder `Bemerkungen`, Spalte 2 die inhaltliche Beschreibung und Spalte 3 Beispielaufrufe bzw. Beispielcode. Mindestversionen werden aus `Voraussetzung`, Parameter- und Rückgabesemantik vorrangig aus `Bemerkungen` abgeleitet.
- Bei Änderungen an Zustandslogik in Lua immer auf Persistenz achten `StorageUtility.loadTable()` und `StorageUtility.saveTable()` akzeptieren nur String-Werte
  - Optionale Felder beim Speichern lieber weglassen als `"nil"` oder andere Platzhalter-Strings zu schreiben.
- EEP-nahe Fehlerpfade sind oft absichtlich `fail-loud`: bestehende `print(... debug.traceback())`-Muster nicht ohne klaren Grund in stilles Fehlerhandling umwandeln.
- Module unter `lua/LUA/ak` laufen in einer Lua 5.3 Umgebung des Programmes EEP. Das Programm EEP stellt die globalen EEP-Funktionen wie in LUA_Manual.pdf beschrieben zur Verfügung wie `EEPSetSignal`, `EEPLoadData` oder `EEPTime`. Was das Programm kann ist in EEP18_Manual_GER.pdf beschrieben.
- EEPSimulator.lua soll die Funktionen des Programms EEP abbilden, so dass der Lua Code auch mit dem Simulatur getestet werden kann.
- Viele Module registrieren globale Callbacks über `_G[...]`. Bei Änderungen an Registrierungslogik auf bestehende Namenskonventionen achten.
- Persistenter Zustand liegt typischerweise in EEP-Datenslots; dafür werden kurze Schlüssel wie `b`, `z`, `r`, `t` verwendet.
- Hard-Resets und Recovery-Pfade sind wichtig. Wenn neue zustandsbehaftete Objekte eingeführt werden, muss auch deren Reset-Verhalten bedacht werden.

## Web-Hinweise

- Die Web-App ist React 19 mit Vite und MUI, nicht Angular.
- Der Web-Server ist eine Electron-/Node-Anwendung in TypeScript.
- Gemeinsame Typen und Events liegen in `packages/web-shared` und sollten bei API-Änderungen konsistent mit angepasst werden.

## Nützliche Kommandos

- Abhängigkeiten installieren: `yarn`
- Web-App lokal starten: `yarn start-app`
- Web-App + Server im Spielmodus: `yarn start-playing`
- Headless-Server starten: `yarn start-server`
- Gesamtbuild: `yarn build`
- Web-App Storybook: `yarn storybook`
- Web-App E2E headless: `yarn workspace @ak/web-app run cy-tests-run-headless`
- Web-Server linten: `yarn workspace @ak/web-server run lint`
- Lua prüfen, falls lokal installiert:
  - `luacheck --config .luacheckrc lua/LUA`
  - `busted --config-file .busted --verbose --coverage --`
- Lua formatieren, falls lokal installiert:
  - `lua-format -c lua-format.conf -i <datei.lua>`
  - `lua-format -c lua-format.conf --check <datei.lua>`

## Testing und Verifikation

- Für Lua-Änderungen zuerst betroffene Specs unter `lua/LUA/spec` prüfen.
- Für Änderungen an Web-Typen oder Events mindestens `@ak/web-shared` und den betroffenen Consumer mitdenken.
- Wenn keine passende Laufzeit verfügbar ist, statisch prüfen und explizit benennen, was nicht ausgeführt werden konnte.

## Änderungsstil

- Keine unnötigen Umbenennungen oder Formatierungswellen.
- Keine bestehenden lokalen Benutzeränderungen zurücksetzen.
- Bei Reviews Schwerpunkt auf:
  - Zustandskonsistenz
  - Persistenzfehler
  - EEP-/Callback-Integration
  - Verhaltensregressionen
  - fehlende Tests
- Gegencheck der Architekturdokumentationen in ARCHITECTURE.md wo vorhanden

