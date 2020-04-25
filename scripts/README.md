<p align="center">
  <a href="http://andreas-kreuz.github.io/ak-lua-bibliothek-fuer-eep">
    <img src="docs/assets/img/eep-web-logo-shadow-72.png" alt="" width=72 height=72>
  </a>
  <h3 align="center">Projektdateien für EEP-Web</h3>
  <p align="center">
    Dieses Repository enthält die notwendigen Dateien für die Entwicklung von EEP-Web.
  </p>
<br>
<hr>

# Beschreibung

Im Repository sind alle notwendigen Dateien für die Entwicklung der folgenden **Projekte** enthalten:
_web-app_, _server_, _lua_.

Folgende **Bibliotheken** sind notwendig:

* [Lua 5.2](http://luabinaries.sourceforge.net/download.html) (für Lua-Skripte)
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

Für die Entwicklung der Web App müssen noch die Angular Pakete installiert werden.

Installiere die notwendigen Pakete für Angular mit der Kommandozeile. Verwende dazu folgende Befehle:

   ```bash
   cd web-app
   ```

   ```bash
   npm install
   ```

## Server im Entwicklungsmodus starten

Das Skript `scripts\start-server-for-testing.cmd` startet den Server im Testmodus.

## App im Entwicklungsmodus starten

Das Skript `start-app-dev-server` erlaubt die Entwicklung der Angular App. Sobald es läuft, kannst Du unter <http://localhost:4200/> auf die Web App zugreifen.

# Das ganze Projekt ausliefern

Benutze das Skript `scripts\build-package.cmd` um das ganze Programm zu bauen.

Dabei werden App, Server und Lua in eine EEP-Installationsdatei zusammengepackt.
