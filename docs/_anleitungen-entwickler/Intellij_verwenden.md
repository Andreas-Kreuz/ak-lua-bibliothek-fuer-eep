---
layout: page_with_toc
title: IntelliJ verwenden
type: Anleitung
subtitle: Hier erfährst Du, wie Du Lua mit IntelliJ verwenden kannst. Dazu wird die Testanlage dieser Bibliothek verwendet.
img: "/assets/thumbnails/intellij.png"
feature-img: "/assets/headers/intellij.png"
date: 2017-09-07
permalink: docs/anleitungen-entwickler/intellij-verwenden
tags: [Fortgeschrittene, Entwickler]
---
# IntelliJ verwenden

<p class="lead">IntelliJ ist ein Programm für Entwickler.
Es wurde für die Programmiersprache JAVA entworfen.
Mit einem Plugin ist IntelliJ auch für Lua geeignet.</p>

⭐ Diese Anleitung richtet sich an fortgeschrittene Benutzer.

**Vorteile von IntelliJ**
* Du kannst Programme auf Knopfdruck starten
* Beim Programmieren werden Variablen und Funktionen erkannt

**Nachteile von IntelliJ**
* Das Programm ist in englischer Sprache
* Die Software wirkt sehr komplex
* Die Einrichtung eines Lua-Projektes ist nicht ganz einfach

# Das Programm IntelliJ
* Gesamtansicht des Hauptfensters<br>
<img src="../assets/tutorial/intellij/44.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

Das Programm ist in mehrere Bereiche unterteilt.
* Das Menü<br>
  <img src="../assets/tutorial/intellij/44-menu.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* Der Teil für das Ausführen von Code im Menü<br>
<img src="../assets/tutorial/intellij/44-ausfuehren.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* Bereich für den Quellcode<br>
<img src="../assets/tutorial/intellij/44-quellcode.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* Bereich für die Ausgabe "Run"<br>
<img src="../assets/tutorial/intellij/44-ausgabefenster.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">



# Herunterladen
IntelliJ kannst hier herunterladen: [https://www.jetbrains.com/idea/download/#section=windows](https://www.jetbrains.com/idea/download/#section=windows)

Die Community Edition ist kostenlos verfügbar.

<img src="../assets/tutorial/intellij/download.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

Nach dem Download muss Du das Programm installieren.


# Starten

Beim ersten Starten wirst Du nach diversen Einstellungen gefragt:

* Starte das Programm über das Icon auf dem Desktop<br>
<img src="../assets/tutorial/intellij/01.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* Wähle **Do not import settings**<br>
<img src="../assets/tutorial/intellij/02.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* Akzeptiere die Lizenz mit **Accept**<br>
<img src="../assets/tutorial/intellij/03.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* Wähle das helle oder das dunkle Design<br>
<img src="../assets/tutorial/intellij/04.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* Setze alle Plugins auf **Disable**<br>
<img src="../assets/tutorial/intellij/06.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* **Wenn Du Dich mit Git auskennst:** Aktiviere bei Version Controls mit **Customize** die beiden Haken _Git_ und _GitHub_, danach **Save Changes and Go Back**<br>
<img src="../assets/tutorial/intellij/07.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* Wähle **Start using IntelliJ IDEA**<br>
<img src="../assets/tutorial/intellij/08.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* IntelliJ wird gestartet<br>
<img src="../assets/tutorial/intellij/14.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

# Lua-Plugin installieren

Nun müsst Du das Lua-Plugin installieren. Erst nach dieser Installation kann IntelliJ die Sprache `Lua` verstehen, da es eigentlich für `JAVA` gedacht ist.

* **Configure** - **Plugins** wählen <br>
<img src="../assets/tutorial/intellij/09.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* Wähle **Browse Repositories**<br>
<img src="../assets/tutorial/intellij/10.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* Tippe im Suchfeld `lua` ein, wähle das Plugin **Lua** aus und klicke auf **Install**<br>
<img src="../assets/tutorial/intellij/11.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* Nach dem Download klicke auf **Restart IntelliJ IDEA** <br>
<img src="../assets/tutorial/intellij/12.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* Klicke auf **Restart** <br>
<img src="../assets/tutorial/intellij/13.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

# Lua-Projekt anlegen
Nun kannst Du das Projekt mit den Lua-Skripten anlegen. Der Einfachheit halber verwendest Du das `LUA`-Verzeichnis Deiner EEP-Installation.

* **Create New Project**<br>
<img src="../assets/tutorial/intellij/15.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* Wähle **Lua** aus und klicke **Next** <br>
<img src="../assets/tutorial/intellij/16.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* Wähle **LuaJ** <br>
<img src="../assets/tutorial/intellij/17.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">
* Verwende den Namen `EEP` und das LUA-Verzeichnis Deiner EEP-Installation `C:\Trend\EEP14\LUA` <br>
<img src="../assets/tutorial/intellij/18.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* Beende mit **Finish** <br>
<img src="../assets/tutorial/intellij/19.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* Das Hauptfenster wird angezeigt. Drücke **Close** um es zu schließen <br>
<img src="../assets/tutorial/intellij/20.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* Nun siehst Du das Projektfenster mit dem Ordner ".idea" und der Datei "LUA.iml". Beide werden von IntelliJ verwaltet.<br>
<img src="../assets/tutorial/intellij/21.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

# Test-Skripte Herunterladen
Laden Dir nun die Testanlage aus dem EEP-Shop, damit das Projekt ein paar Dateien erhält.

* Lade Dir die Anlage **Lua testen vor EEP** herunter: [https://www.eepforum.de/filebase/file/262-andreas-kreuz-lua-testen-vor-eep/](https://www.eepforum.de/filebase/file/262-andreas-kreuz-lua-testen-vor-eep/) <br>
<img src="../assets/tutorial/intellij/22.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* Starte EEP und wähle **Modell-Installer** <br>
<img src="../assets/tutorial/intellij/23.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* Wähle die Anlage **Installer-AK-Demo-Lua-Testbeispiel** in **Downloads** <br>
<img src="../assets/tutorial/intellij/24.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* Wähle **Installieren** und **OK** <br>
<img src="../assets/tutorial/intellij/25.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* Wechsele zurück zu IntelliJ - dort findest Du den Ordner `ak`<br>
<img src="../assets/tutorial/intellij/27.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

# Lua-Laufzeitumgebung installieren

Nun versuchst Du das Lua-Skript auszuführen.
Das wird voraussichtlich noch nicht funktionieren, da die Lua-Umgebung noch fehlt.

* Klappe nun den Ordner `ak.demo-anlagen.testen` auf und öffne die Datei `Andreas_Kreuz-Lua-Testbeispiel-test.lua` <br>
<img src="../assets/tutorial/intellij/29.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* Klicke mit der rechten Maustaste auf die Datei  `Andreas_Kreuz-Lua-Testbeispiel-test.lua` und wähle **Run ...**<br>
<img src="../assets/tutorial/intellij/31.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* Es erscheint eine Fehlermeldung **Cannot run programm "java"**. <br>
Das liegt daran, das die Lua-Laufzeitumgebung noch nicht konfiguriert ist. <br>
<img src="../assets/tutorial/intellij/32.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* Lade nun die Lua-Laufzeitumgebung 5.2.4 von http://luabinaries.sourceforge.net/download.html<br>
(Die Version 5.2 entspricht der von EEP 14.)<br>
<img src="../assets/tutorial/intellij/36.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* Der Download startet automatisch <br>
<img src="../assets/tutorial/intellij/37.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* Entpacke die Zip-Datei **lua-5.3.4-Win64_bin** <br>
<img src="../assets/tutorial/intellij/38.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* Wenn Du in den Ordner **lua-5.3.4-Win64_bin** wechselst, siehst Du 4 Dateien: <br>
<img src="../assets/tutorial/intellij/39.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* Wähle nun _File_ - _Project Structure_. <br>
<img src="../assets/tutorial/intellij/33.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

<!--* **** <br>
<img src="../assets/tutorial/intellij/34.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">-->

* Wähle **SDK** und dann LuaJ - wähle mit "**...**" nun den Download-Ordner **lua-5.3.4-Win64_bin** <br>
<img src="../assets/tutorial/intellij/35.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* Wenn Du dieses Verzeichnis auswählst, dann kommt die Fehlermeldung, dass dieses nicht als Lua-Laufzeitumgebung (Lua-SDK) verwendbar ist. <br>
<img src="../assets/tutorial/intellij/40.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* Das liegt daran, dass das Lua-Plugin die Dateien in dem Ordner anders erwartet. <br>Die  exe-Dateien müssen ohne `52` im Namen vorliegen.<br>Benenne daher die Dateien wie folgt um:
  * `lua52.exe` in `lua.exe`
  * `luac52.exe` in `luac.exe`
  * `wlua52.exe` in `wlua.exe`

  <img src="../assets/tutorial/intellij/41.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* Nach der Umbenennung funktioniert das Auswählen des Verzeichnisses.<br>
<img src="../assets/tutorial/intellij/42.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

# Das Lua-Skript starten
* Klicke mit der rechten Maustaste auf die Datei `Andreas_Kreuz-Lua-Testbeispiel-test.lua` und wähle **Run ...**<br>
<img src="../assets/tutorial/intellij/43.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

* Das Skript wird ausgeführt und das Test-Skript erzeugt die korrekte Ausgabe.<br>
<img src="../assets/tutorial/intellij/44.png" class="img-fluid img-thumbnail" style="border: 1 solid #aaaaaa;" alt="">

<br>
🍀 Herzlichen Glückwunsch, Du hast es bis hierhin geschafft!
<br><br>
<p class="lead">Nun kannst Du Deine Anlagen ohne EEP in IntelliJ testen. Bei Erfolg, kannst Du sie in EEP übernehmen. Eine Beschreibung findest Du in der Anleitung <a href="../anleitungen-ampelkreuzung/demo-anlage-testen">Testen vor EEP</a></p>
