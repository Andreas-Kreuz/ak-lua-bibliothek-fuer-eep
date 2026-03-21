<p align="center">
  <a href="http://andreas-kreuz.github.io/ak-lua-bibliothek-fuer-eep">
    <img src="../assets/img/eep-web-logo-shadow-72.png" alt="" width=72 height=72>
  </a>
  <h3 align="center">Lua-Bibliothek entwickeln</h3>
  <p align="center">
    Hier findest Du alle Informationen zum Einrichten und Entwickeln.
  </p>
<br>
<hr>

# Einrichtung für Entwickler

## Bestandteile

**Bestandteile** enthalten:

- **`lua`** - enthält den Lua-Code für EEP; dieser wird direkt genutzt
- **`scripts`** - enthält Hilfsskripte für Entwicklung, Build und Tests
- **`apps/web-app`** - das Frontend, geschrieben mit React und Vite
- **`apps/web-server`** - eine Electron- und Node-Anwendung
- **`apps/web-shared`** - geteilte Typen und Events von Web-App und Web-Server

Weitere Verzeichnisse sind:

- `.vscode` - Projektdateien für VS Code
- `assets` - Bilder und CSS für die generierte Webseite
- `docs` - generierte Webseite

## Werkzeuge

### Notwendige Werkzeuge

- [Lua 5.3](http://luabinaries.sourceforge.net/download.html) (für Lua-Skripte)
- [Node.js](https://nodejs.org/en/) (für Web-App und Web-Server)
- [7-Zip](https://www.7-zip.org/) (für das Erstellen des Release-Pakets)

### Empfohlene Werkzeuge

#### Empfohlene Entwicklungswerkzeuge

- [VS Code](https://code.visualstudio.com/) - die empfohlenen Erweiterungen sind im Projektverzeichnis hinterlegt
- [git Kommandozeile](https://git-scm.com/downloads) oder [GitHub Desktop](https://desktop.github.com/)

#### Empfohlen für Lua-Tests

Für das Testen werden die Lua-Werkzeuge [`luacheck`](https://github.com/mpeterv/luacheck) und [`busted`](https://github.com/lunarmodules/busted) empfohlen.

- `luacheck --config .luacheckrc lua/LUA`
- `busted --config-file .busted --verbose --coverage --`

#### Empfohlen für die Webseite

Für das Betrachten der statischen Dokumentation vor dem Upload wird [Jekyll](https://jekyllrb.com/docs/installation/windows/) empfohlen.

## Entwicklung

### Projekt klonen auf der Kommandozeile

- Dieses Projekt klonen (wird in ein Unterverzeichnis `ak-lua-bibliothek-fuer-eep` gespeichert):

  ```bash
  cd ein-verzeichnis-deiner-wahl
  git clone https://github.com/Andreas-Kreuz/ak-lua-bibliothek-fuer-eep.git
  ```

### Projekt öffnen

Nun kann das Verzeichnis `ak-lua-bibliothek-fuer-eep` in VS Code als Ordner geöffnet werden.

### Vorbereitung der Entwicklung

Für die Entwicklung der Web-Komponenten musst Du noch die notwendigen Pakete installieren:

```bash
npm install -g corepack
yarn
```

Wenn Du die Windows-Skripte verwenden willst, kannst Du alternativ `.\scripts\install-npms.cmd` benutzen.

### Einmal komplett bauen

Mit `.\scripts\build-release.cmd` wird das gesamte Projekt gebaut und ein Installationspaket für EEP erzeugt.

Wenn Du nur Web-App und Web-Server gemeinsam bauen willst, ohne das Release-Paket zu erstellen, benutze `.\scripts\build-server-with-app.cmd`.

### Testmodus starten

Das Skript `.\scripts\start-developing.cmd` startet die E2E-Testumgebung für die Web-App.
Dabei werden der Test-Server, eine Preview der Web-App und Cypress gestartet.
Die Preview der Web-App ist typischerweise unter <http://localhost:4173/> erreichbar.

#### Von Hand testen

Wenn Du vor dem Upload selbst testen willst, kannst Du

- Lua-Tests ausführen: `.\scripts\check-lua.cmd`
- Web-App-E2E-Tests ausführen: `.\scripts\check-web-app-e2e.cmd`

### Spielmodus starten

Das Skript `.\scripts\start-playing.cmd` startet den Server und die Web-App im Spielmodus.
Die Web-App läuft dabei typischerweise unter <http://localhost:5173/>.

Wenn Du Server und Web-App getrennt starten willst, benutze:

- `.\scripts\start-web-server.cmd`
- `.\scripts\start-web-app.cmd`

## Sonstiges

### Lua in EEP nutzen

Wenn Du möchtest, kannst Du das Lua-Verzeichnis aus Git direkt in EEP nutzen. Erstelle dazu einen Link mit der Kommandozeile:

```cmd
mklink /D C:\Trend\EEP15\LUA\ce C:\GitHub\ak-lua-bibliothek-fuer-eep\lua\LUA\ce
```

### Webseite bearbeiten

Das Skript `.\scripts\start-doc-server.cmd` startet Jekyll und erlaubt es Dir, die generierte Webseite vor dem Upload zu betrachten.
