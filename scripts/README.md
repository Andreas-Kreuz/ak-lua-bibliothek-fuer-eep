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

Benutze danach das Skript `.\scripts\build-package.cmd` um das ganze Programm einmal zu bauen.

Dabei werden App, Server und Lua in eine EEP-Installationsdatei zusammengepackt.

### Testmodus starten

Das Skript `.\scripts\start-developing.cmd` startet den Server und die Web-App im "Testmodus".  
Das erlaubt das automatische Ausführen von Test, während Du die App entwickelst.  
Der Testmodus zeigt unter <http://localhost:4200/> die Daten des aktuellen Tests an. Willst Du Deine Anlage in EEP sehen, kannst Du den Spielmodus starten.

#### Von Hand testen

Wenn Du vor dem Upload selbst testen willst, kannst Du

- Tests für Lua ausführen: `.\scripts\check-lua.cmd`
- Web-App Tests ausführen: `.\scripts\check-web-app-e2e.cmd`

### Spielmodus starten

Das Skript `.\scripts\start-playing.cmd` starten den Server und die Web-App im "Spielmodus".  
Der Spielmodus zeigt unter <http://localhost:4200/> die aktuell in EEP geöffnete Anlage an.

## Sonstiges

### Lua in EEP nutzen

Wenn Du möchtest, kannst Du das Lua-Verzeichnis aus Git direkt in EEP nutzen. Erstelle dazu einen Link mit der Kommandozeile:

```cmd
mklink /D C:\Trend\EEP15\LUA\ak C:\GitHub\ak-lua-bibliothek-fuer-eep\lua\LUA\ak
```

### Webseite bearbeiten

Das Skript `.\scripts\start-doc-server.cmd` startet jekyll und erlaubt es Dir die generierte Webseite vor dem Upload zu betrachten.
