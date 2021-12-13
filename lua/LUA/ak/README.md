---
layout: page_landing
title: Dokumentation der Lua-Bibliothek
subtitle: Hier findest Du Informationen zum Verwenden der Programmierschnittstelle
permalink: lua/ak/
feature-img: "/docs/assets/headers/SourceCode.png"
img: "/docs/assets/headers/SourceCode.png"
---

## ⚠ Bitte beachten

⚠ **Diese Bibliothek verwenden `EEPRollingstockSetTagText` um Daten in Fahrzeugen abzulegen.**

- **Eigene mit `EEPRollingstockSetTagText` gespeicherte Daten werden dabei verloren gehen!**
- Man kann jedoch eigene Daten in einem Zug wie folgt ablegen:
  - `Train.forName("#meinZug")`**`.setValue("schlüssel","wert")`**
  - `local meinWert = Train.forName("#meinZug")`**`.getValue("schlüssel")`**

## Pakete

<table class="table flex" style="width: 35em; max-width: inherit;">
  <thead>
    <tr>
      <th scope="col">📦&nbsp;Paket</th>
      <th scope="col">Inhalt</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><a href="core/">📦&nbsp;ak/core</a></td>
      <td>Das Hauptmodul der App</td>
    </tr>
    <tr>
      <td><a href="core/eep/">📦&nbsp;ak/core/eep</a></td>
      <td>Alle Funktionen von EEP für Deine Tests</td>
    </tr>
    <tr>
      <td><nobr><a href="modellpacker/">📦&nbsp;ak/modellpacker</a></nobr></td>
      <td>Erzeuge installierbare Dateien für EEP</td>
    </tr>
    <tr>
      <td><a href="public-transport/">📦&nbsp;ak/public-transport</a></td>
      <td>Linienverkehr im ÖPNV</td>
    </tr>
    </tr>
    <tr>
      <td><a class="text-muted" href="rail/">⚡&nbsp;ak/rail</a></td>
      <td>In Arbeit<span class="text-muted"> - Steuerung für die Eisenbahn</span></td>
    </tr>
    <tr>
      <td><a href="road/">📦&nbsp;ak/road</a></td>
      <td>Steuerung für den Straßenverkehr</td>
    </tr>
    <tr>
      <td><a href="scheduler/">📦&nbsp;ak/scheduler</a></td>
      <td>Plane Dinge in der Zukunft</td>
    </tr>
    <tr>
      <td><a href="storage/">📦&nbsp;ak/storage</a></td>
      <td>Speichern und Laden von String-Tabellen</td>
    </tr>
    <tr>
      <td><a href="template/">📦&nbsp;ak/template</a></td>
      <td>Skripte zum Kopieren und Wiederverwenden</td>
    </tr>
  </tbody>
</table>
