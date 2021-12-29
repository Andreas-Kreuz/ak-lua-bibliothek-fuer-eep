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

- **_lua_** - enhält den Lua-Code für EEP - dieser wird direkt genutzt
- **_scripts_** - enthält Hilfsskripte für die Entwicklung
- **_web-app_** - das Frontend geschrieben in Angular
- **_web-server_** - eine Electron App
- **_web-shared_** - geteilter Code von web-app und web-server

Weitere Verzeichnisse sind:

- `.vscode` - Projektdateien für VSCode
- `assets` - Bilder und CSS für die generierte Webseite
- `docs` - generierte Webseite

## Werkzeuge

### Notwendige Werkzeuge

- [Lua 5.3](http://luabinaries.sourceforge.net/download.html) (für Lua-Skripte)
- [Node.js](https://nodejs.org/en/) (für EEP-Web App)
- [7-zip](https://www.7-zip.org/) (für das Erstellen des Modellpakets als Zip)

### Empfohlene Werkzeuge

- [VS-Code](https://code.visualstudio.com/) - die empfohlenen Erweiterungen sind im Projektverzeichnis hinterlegt
- [git Kommandozeile](https://git-scm.com/downloads) oder [gitHub Desktop](https://desktop.github.com/)

Für das Testen werden die Lua-Werkzeuge `luacheck` und `busted` empfohlen.

- `luacheck --std max+busted lua/LUA`
- `busted --verbose --coverage --`

Für das Betrachten der Webseite _vor_ dem Upload wird [Jekyll](https://jekyllrb.com/docs/installation/windows/) empfohlen.

## Entwicklung

### Projekt klonen auf der Kommandozeile

- Dieses Projekt klonen (wird in ein Unterverzeichnis ak-lua-bibliothek-fuer-eep gespeichert):

  ```bash
  cd ein-verzeichnis-deiner-wahl
  git clone https://github.com/Andreas-Kreuz/ak-lua-bibliothek-fuer-eep.git
  ```

### Projekt öffnen

Nun kann das Verzeichnis `ak-lua-bibliothek-fuer-eep` in VS Code als Ordner geöffnet werden.

### Vorbereitung der Entwicklung

Für die Entwicklung der Web-Komponenten musst Du noch die notwendigen npm Pakete installieren:

```bash
cd web-app
npm install
```

```bash
cd web-server
npm install
```

```bash
cd web-shared
npm install
```

Anstatt dieser 3 Befehle kannst du auch das Skript `.\scripts\install-npms.cmd` starten.

Benutze danach das Skript `.\scripts\build-server-with-app.cmd` um das ganze Programm einmal zu bauen.

Mit dem Skript `.\scripts\build-package.cmd` wird ebenfalls das ganze Programm gebaut und es werden die App, der Server und alle Lua-Dateien  in eine EEP-Installationsdatei zusammengepackt.

### Server im Entwicklungsmodus starten

Das Skript `.\scripts\start-web-server.cmd` startet den Server im Testmodus. Das erlaubt das lokale Verwenden des Servers, während Du die App entwickelst.

### App im Entwicklungsmodus starten

Das Skript `.\scripts\start-web-app.cmd` startet die Web-App. Du findest sie nach dem Start unter <http://localhost:4200/>. Der Web-Server kann dann genutzt werden, um die Web-App mit Daten zu versorgen. Er muss auf dem selben Rechner gestartet werden.

## Sonstiges

### Lua in EEP nutzen

Wenn Du möchtest, kannst Du das Lua-Verzeichnis aus Git direkt in EEP nutzen. Erstelle dazu einen Link mit der Kommandozeile:

```cmd
mklink /D C:\Trend\EEP15\LUA\ak C:\GitHub\ak-lua-bibliothek-fuer-eep\lua\LUA\ak
```

### Webseite bearbeiten

Das Skript `.\scripts\start-doc-server.cmd` startet jekyll und erlaubt es Dir die generierte Webseite vor dem Upload zu betrachten.
