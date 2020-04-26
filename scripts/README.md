<p align="center">
  <a href="http://andreas-kreuz.github.io/ak-lua-bibliothek-fuer-eep">
    <img src="../assets/img/eep-web-logo-shadow-72.png" alt="" width=72 height=72>
  </a>
  <h3 align="center">EEP-Web entwickeln</h3>
  <p align="center">
    Informationen zu den notwendigen Dateien für die Entwicklung von EEP-Web.
  </p>
<br>
<hr>

# Beschreibung

Im Repository sind alle notwendigen Dateien für die Entwicklung der folgenden **Projekte** enthalten:
_web-app_, _server_, _lua_.

Folgende **Bibliotheken** sind notwendig:

* [Lua 5.3](http://luabinaries.sourceforge.net/download.html) (für Lua-Skripte)
* [Node.js](https://nodejs.org/en/) (für EEP-Web App)
* [Angular-CLI](https://angular.io/) (für EEP-Web App)
* [Java 11](https://jdk.java.net/11/) (für EEP-Web-Server)
* [Maven](https://maven.apache.org) (für EEP-Web-Server)
* [7-zip](https://www.7-zip.org/) (für das Erstellen des Modellpakets als Zip)

Folgende **Entwicklungswerkzeuge** können verwendet werden:

* [VS-Code](https://code.visualstudio.com/)
* [git Kommandozeile](https://git-scm.com/downloads)
* [gitHub Desktop](https://desktop.github.com/)

# Entwicklung

## Projekt klonen auf der Kommandozeile

* Dieses Projekt klonen (wird in ein Unterverzeichnis ak-lua-bibliothek-fuer-eep gespeichert):

  ```bash
  cd ein-verzeichnis-deiner-wahl
  git clone https://github.com/Andreas-Kreuz/ak-lua-bibliothek-fuer-eep.git
  ```

## Projekt öffnen

Nun kann das Verzeichnis `ak-lua-bibliothek-fuer-eep` in VS Code als Ordner geöffnet werden.

# Web App entwickeln

## Vorbereitung der Entwicklung

Für die Entwicklung der Web App musst Du noch die Angular Pakete installieren:

   ```bash
   cd web-app
   npm install
   ```

Benutze das Skript `.\scripts\build-package.cmd` um das ganze Programm einmal zu bauen.

Dabei werden App, Server und Lua in eine EEP-Installationsdatei zusammengepackt.

## Lua in EEP nutzen

Wenn Du möchtest, kannst Du das Lua-Verzeichnis aus Git direkt in EEP nutzen. Erstelle dazu einen Link mit der Kommandozeile:

```cmd
mklink /D C:\Trend\EEP15\LUA\ak C:\GitHub\ak-lua-bibliothek-fuer-eep\lua\LUA\ak
```

## Server im Entwicklungsmodus starten

Das Skript `.\scripts\start-server.cmd` startet den Server im Testmodus. Damit stellst Du der Web-App die EEP-Daten zur Verfügung.

## App im Entwicklungsmodus starten

Das Skript `.\scripts\start-web-app` erlaubt die Entwicklung der Web App. Du findest sie nach dem Start unter <http://localhost:4200/>.
