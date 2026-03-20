---
layout: page_with_toc
title: EEP-Installer selbst gemacht
subtitle: Baue eine eigene ZIP-Datei, die jeder mit EEP installieren kann.
permalink: lua/ce/modellpacker/
feature-img: "/docs/assets/headers/ModellPacker.png"
img: "/docs/assets/headers/ModellPacker.png"
---

# Motivation

Dieses Paket hilft dabei Modell-Installer für EEP zu erzeugen.

- Die von Dir gewünschten Dateien werden automatisch in die Unterordner `Install_xx` kopiert und es wird eine zu den Dateien passende `Install_xx\install.ini` angelegt
- Es wird eine Datei `Installation.eep` mit der Beschreibung der Installation angelegt.
- Im Anschluss wird die Datei mit 7-zip gepackt, wenn installiert.

# Skript `AkModellPacker`

Das Skript liegt in `ce.modellpacker.AkModellPacker`.

- Klasse `AkModellInstaller` - legt einen Modell-Installer an, welchem Modell-Pakete hinzugefügt werden können.

  - `AkModellInstaller:new(directoryName)` - Legt einen neuen Modell-Installer an. Der Modell-Installer kann mehrere Modell-Pakete enthalten. Der `directoryName` bestimmt, in welches Unterverzeichnis das Modellpaket installiert werden soll - dieses Verzeichnis wird new angelegt.

  - `AkModellInstaller:addModelPackage(paket)` - fügt dem Installer ein weiteres Paket hinzu

  - `AkModellInstaller:generatePackage(outputDirectory)` - erstellt das Paket als Unterordner im Ausgabeverzeichnis.

- Klasse `AkModellPaket` - legt ein Modell-Paket an, welches zum AkModellInstaller hinzugefügt wird.

  - `AkModellPaket:new(eepVersion, germanName, germanDescription)` - erzeugt ein neues Modell-Paket mit Mindest-EEP-Version, sowie einem deutschen Namen und einer deutschen Beschreibung.

  - `AkModellPaket:addFiles(baseDirectory, prefix, subdirectory)` - Fügt alle Dateien im Unterverzeichnis `baseDirectory\subdirectory` hinzu. Die Dateien werden mit dem Namen `prefix\subdirectory\...\fileName` erzeugt.

# Beispiel

Alle Anlagen und die Lua-Bibliothek dieser Webseite werden automatisch verpackt - Siehe [Modellinstallation.lua](https://github.com/Andreas-Kreuz/ak-lua-bibliothek-fuer-eep/blob/master/LUA/ModellInstallation.lua)

Du benötigst ein in Windows installiertes Lua - siehe:
[Demo-Anlage-Testen](../../../anleitungen-ampelkreuzung/demo-anlage-testen)
