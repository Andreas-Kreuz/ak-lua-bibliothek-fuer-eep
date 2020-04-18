---
layout: page_with_toc
title: EEP-Installer selbst gemacht
subtitle: Baue eine eigene ZIP-Datei, die jeder mit EEP installieren kann.  
permalink: lua/ak/modellpacker/
feature-img: "/docs/assets/headers/ModellPacker.png"
img: "/docs/assets/headers/ModellPacker.png"
---

# Motivation
Dieses Paket hilft dabei Modell-Installer für EEP zu erzeugen.

* Die von Dir gewünschten Dateien werden automatisch in die Unterordner `Install_xx` kopiert und es wird eine zu den Dateien passende `Install_xx\install.ini` angelegt
* Es wird eine Datei `Installation.eep` mit der Beschreibung der Installation angelegt.
* Im Anschluss wird die Datei mit 7-zip gepackt, wenn installiert.

# Skript `AkModellPacker`
Das Skript liegt in `ak.modellpacker.AkModellPacker`.

* Klasse `AkModellInstaller` - legt einen Modell-Installer an, welchem Modell-Pakete hinzugefügt werden können.

  * `AkModellInstaller:neu(verzeichnisname)` - Legt einen neuen Modell-Installer an. Der Modell-Installer kann mehrere Modell-Pakete enthalten. Der `verzeichnisname` bestimmt, in welches Unterverzeichnis das Modellpaket installiert werden soll - dieses Verzeichnis wird neu angelegt.

  * `AkModellInstaller:fuegeModellPaketHinzu(paket)` - fügt dem Installer ein weiteres Paket hinzu

  * `AkModellInstaller:erzeugePaket(ausgabeverzeichnis)` - erstellt das Paket als Unterordner im Ausgabeverzeichnis.

* Klasse `AkModellPaket` - legt ein Modell-Paket an, welches zum AkModellInstaller hinzugefügt wird.

  * `AkModellPaket:neu(eepVersion, deutscherName, deutscheBeschreibung)` - erzeugt ein neues Modell-Paket mit Mindest-EEP-Version, sowie einem deutschen Namen und einer deutschen Beschreibung.

  * `AkModellPaket:fuegeDateienHinzu(verzeichnis, praefix, unterverzeichnis)` - Fügt alle Dateien im Unterverzeichnis `verzeichnis\unterverzeichnis` hinzu. Die Dateien werden mit dem Namen `praefix\unterverzeichnis\...\dateiname` erzeugt.

# Beispiel

Alle Anlagen und die Lua-Bibliothek dieser Webseite werden automatisch verpackt - Siehe [Modellinstallation.lua](https://github.com/Andreas-Kreuz/ak-lua-bibliothek-fuer-eep/blob/master/LUA/ModellInstallation.lua)

Du benötigst ein in Windows installiertes Lua - siehe:
[Demo-Anlage-Testen](../../../_anleitungen-fortgeschrittene/demo-anlage-testen.md)
