---
layout: page_with_toc
title: Github verwenden
type: Anleitung
subtitle: Hier erfährst Du, wie Du die Lua-Bibliothek direkt aus GitHub verwenden kannst.
img: "/assets/thumbnails/GitHub.png"
feature-img: "/assets/headers/GitHub.png"
date: 2017-09-03
permalink: anleitungen-entwickler/github-verwenden
tags: [Fortgeschrittene, Entwickler]
---
# Bibliothek aus GitHub nutzen

:star: Für weniger versierte Anwender wird die Installation mit dem EEP-Installer empfohlen.

* Melde Dich bei [GitHub](https://github.com/) an.

* Erstelle Deinen eigenen Fork (eine Kopie auf GitHub) von [ak-lua-bibliothek-fuer-eep](https://github.com/Andreas-Kreuz/ak-lua-bibliothek-fuer-eep). Dazu drückst Du rechts oben in der Ecke auf "Fork".

* Lade Dir das Programm [GitHub Desktop](https://desktop.github.com/) herunter.

* Erstelle mit _File_ - _Clone Repository_ eine Arbeitskopie auf der selben Festplatte, auf der auch EEP 14 liegt (dies ist für das Anlegen eines Verzeichnis-Links notwendig), z.B. in `C:\GitHub\ak-lua-bibliothek-fuer-eep`

* Starte die Kommandozeile als Administrator (`<Windows>`-Taste drücken, `cmd` eintippen, ein Rechtsklick auf `Eingabeaufforderung` und dann _Als Administrator ausführen_.

* Erstelle nun einen Verzeichnis-Link (Verknüpfung) des `ak`-Verzeichnisses im Unterverzeichnis `LUA` Deiner EEP-Installation (z.B. in `C:\Trend\EEP14\LUA`):

    `mklink /D C:\Trend\EEP14\LUA\ak C:\GitHub\ak-lua-bibliothek-fuer-eep\LUA\ak\`

* Fertig: Nun ist die Bibliothek im Ordner `ak` auch in EEP unter `ak` verfügbar und Du kannst nun eine Demo-Anlage aus `C:\GitHub\ak-lua-bibliothek-fuer-eep\Resourcen\Anlagen\` öffnen. Wenn alles geklappt hat, wird die automatische Steuerung der Demo-Anlage funktionieren.
