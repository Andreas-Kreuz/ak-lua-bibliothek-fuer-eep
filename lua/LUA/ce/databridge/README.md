---
layout: page_with_toc
title: Kommunikation mit dem Server
subtitle: Die Dateien in diesem Paket dienen dazu, mit dem EEP-Web-Server zu kommunizieren.
permalink: lua/ce/databridge/
feature-img: "/docs/assets/headers/SourceCode.png"
img: "/docs/assets/headers/SourceCode.png"
---

# Motivation

Dieses Paket kommuniziert über Dateien mit dem EEP-Web-Server. Die schreibende und lesende Seite innerhalb der Lua-Bibliothek wird dabei als Control-Extension Data-Bridge beschrieben.

## Dateien

`exchange/commands-to-ce`
Die Control-Extension Data-Bridge liest Befehle aus dieser Datei und wenn die Kommandos erlaubt sind, werden sie eingelesen.

`exchange/events-from-ce`
Die Control-Extension Data-Bridge schreibt JSON-Ereignisse zeilenweise in diese Datei.
Das geschieht nur dann, wenn der Web-Server läuft und die vorherige Version bereits verarbeitet hat.

`exchange/events-from-ce.pending`
Die Control-Extension Data-Bridge legt diese leere Markerdatei an, nachdem sie `events-from-ce` vollständig geschrieben hat. Damit signalisiert sie, dass ein Ereignispaket zur Verarbeitung bereitliegt und vom Web-Server konsumiert werden kann.
Der Web-Server löscht diese Datei nach dem Einlesen der Ereignisse.
Solange diese Datei existiert, ist also noch ein Ereignispaket zur Verarbeitung ausstehend.
Beim Initialisieren sollte diese Datei gelöscht werden, damit die nächste Ereignisdatei neu erzeugt wird.

`exchange/log-from-ce`
Die Control-Extension Data-Bridge hängt Log-Ausgaben an diese Datei an.

`exchange/server-is-running`
Der Web-Server legt diese Datei beim Start an und löscht sie beim Beenden wieder.
Solange diese Datei existiert, läuft der Server und hört auf neue Daten.
