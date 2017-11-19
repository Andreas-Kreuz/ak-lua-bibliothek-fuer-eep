---
layout: page
title: Github verwenden
type: Anleitung
description: Hier erfährst Du, wie Du die Skripte direkt aus GitHub verwenden kannst.
img: "/assets/headers/GitHub.png"
feature-img: "/assets/headers/GitHub.png"
date: 2017-09-03
tags: [Fortgeschrittene, Entwickler]
---
# So kannst Du die Skripte aus GitHub nutzen

* Melde Dich bei [GitHub](https://github.com/) an.

* Erstelle Deinen eigenen Fork (eine Kopie auf GitHub) von [ak-lua-skripte-fuer-eep](https://github.com/Andreas-Kreuz/ak-lua-skripte-fuer-eep). Dazu drückst Du rechts oben in der Ecke auf "Fork".

* Lade Dir das Programm [GitHub Desktop](https://desktop.github.com/) herunter.

* Erstelle mit _File_ - _Clone Repository_ eine Arbeitskopie auf der selben Festplatte, auf der auch EEP 14 liegt (dies ist für das Anlegen eines Verzeichnis-Links notwendig), z.B. in `C:\GitHub\ak-lua-skripte-fuer-eep`

* Starte die Kommandozeile als Administrator (`<Windows>`-Taste drücken, `cmd` eintippen, ein Rechtsklick auf `Eingabeaufforderung` und dann _Als Administrator ausführen_.

* Erstelle nun einen Verzeichnis-Link (Verknüpfung) des `ak`-Verzeichnisses im Unterverzeichnis `LUA` Deiner EEP-Installation (z.B. in `C:\Trend\EEP14\LUA`):

    `mklink /D C:\Trend\EEP14\LUA\ak C:\GitHub\ak-lua-skripte-fuer-eep\LUA\ak\`

* Fertig: Nun sind alle Skripte im Ordner `ak` auch in EEP unter `ak` verfügbar und Du kannst nun eine Demo-Anlage aus `C:\GitHub\ak-lua-skripte-fuer-eep\Resourcen\Anlagen\` öffnen. Wenn alles geklappt hat, wird die Steuerung funktionieren.
