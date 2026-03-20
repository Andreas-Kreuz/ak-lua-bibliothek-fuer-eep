<p align="center">
  <a href="http://andreas-kreuz.github.io/ak-lua-bibliothek-fuer-eep">
    <img src="assets/img/ce-logo-72@2x.png" alt="" width=72 height=72>
  </a>

  <h3 align="center">Control Extension für EEP</h3>

  <p align="center">
    Eine modulare Steuerungserweiterung für EEP mit<br> 
    <b>Lua Hub</b> | <b>Data Bridge</b> | <b>Web App</b>
    <br>
    <br>
    <a href="http://andreas-kreuz.github.io/ak-lua-bibliothek-fuer-eep"><strong>Anleitungen und Dokumentation</strong></a>
  </p>
</p>
<br>
<hr>

# Überblick

Die Control Extension für EEP erweitert EEP um einen strukturierten Laufzeitkern für Lua-Module. Damit kannst Du Anlagenlogik in wiederverwendbare Module aufteilen und bei Bedarf Daten und Steuerfunktionen über zusätzliche Werkzeuge nach außen bereitstellen.

Das Paket besteht aus vier Bausteinen:

1. **Lua Hub** in `ce.hub` als Laufzeitkern für registrierte `CeModule`
2. **Data Bridge _(optional)_** in `ce.databridge` für den Datenaustausch mit externen Werkzeugen
3. **Control Extension Server _(optional)_** zur Aufbereitung und Bereitstellung der Daten
4. **Control Extension Web App _(optional)_** als Browser-Oberfläche für Anzeige und Bedienung

## Grundprinzipien

- Für die Anlagensteuerung genügt die Lua-Seite der Control Extension; Server und Web App sind optional.
- Der öffentliche Einstiegspunkt in EEP ist `ce.ControlExtension`.
- Zusätzliche Werkzeuge bauen auf den Daten der Data Bridge auf und sind nicht Voraussetzung für die Lua-Module.

## Ausführliche Dokumentation

- Die Webseite enthält [Anleitungen und Dokumentation](http://andreas-kreuz.github.io/ak-lua-bibliothek-fuer-eep/lua/ce/) zur Verwendung der Control Extension für EEP.

## Beiträge sind Willkommen

- [Fehler gefunden, Verbesserungsvorschläge?](CONTRIBUTING.md) <br>So kannst Du zum Projekt beitragen

- So kannst Du die [Entwicklungsumgebung einrichten](scripts/README.md)

## Was ist EEP

EEP (Eisenbahn.exe Professional) ist eine [Simulationssoftware des Trendverlags](https://trendverlag.com/was-ist-eep-eisenbahn-exe.html). Seit Version 11 wird eine Integration von Lua angeboten.

## Danke

- [FrankBuchholz](https://github.com/FrankBuchholz)
  für Performance-Optimierungen und kleine Verbesserungen
- [Damian-Rutkowski](https://github.com/Damian-Rutkowski)
  für die Langzeitmotivation
- [EEP-Benny](https://github.com/EEP-Benny)
  für Ideen zur Umsetzung und Modularisierung

## Danksagungen an andere Projekte

Teile der Webseite basieren auf folgenden anderen Projekten:

- Inhaltsverzeichnis: <https://github.com/allejo/jekyll-toc>
- Layout: <https://github.com/Sylhare/Type-on-Strap>
- Layout: <https://github.com/twbs/bootstrap>
- Javascript: <https://github.com/FezVrasta/popper.js>
