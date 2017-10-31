# Paket ak.modellpacker - Modell-Installer erzeugen

## Motivation
Dieses Paket hilft dabei Modell-Installer zu erzeugen.

* Die gewünschten Dateien werden automatisch in die Unterordner `Install_xx` kopiert und es wird eine zu den Dateien passende `Install_xx\install.ini` angelegt
* Es wird eine Datei `Installation.eep` mit der Beschreibung der Installation angelegt.


## Zur Verwendung vorgesehene Klassen und Funktionen

### Skript `ak.modellpacker.AkModellPacker`
* Klasse `AkModellInstaller` - legt einen Modell-Installer an, welchem Modell-Pakete hinzugefügt werden können.

  * `AkModellInstaller:neu(verzeichnisname)` - Legt einen neuen Modell-Installer an. Der Modell-Installer kann mehrere Modell-Pakete enthalten. Der `verzeichnisname` bestimmt, in welches Unterverzeichnis das Modellpaket installiert werden soll - dieses Verzeichnis wird neu angelegt.

  * `AkModellInstaller:fuegeModellPaketHinzu(paket)` - fügt dem Installer ein weiteres Paket hinzu

  * `AkModellInstaller:erzeugePaket(ausgabeverzeichnis)` - erstellt das Paket als Unterordner im Ausgabeverzeichnis.

* Klasse `AkModellPaket` - legt ein Modell-Paket an, welches zum AkModellInstaller hinzugefügt wird.

  * `AkModellPaket:neu(eepVersion, deutscherName, deutscheBeschreibung)` - erzeugt ein neues Modell-Paket mit Mindest-EEP-Version, sowie einem deutschen Namen und einer deutschen Beschreibung.

  * `AkModellPaket:fuegeDateienHinzu(verzeichnis, praefix, unterverzeichnis)` - Fügt alle Dateien im Unterverzeichnis `verzeichnis\unterverzeichnis` hinzu. Die Dateien werden mit dem Namen `praefix\unterverzeichnis\...\dateiname` erzeugt.

## Beispiel

Siehe [Modellinstallation](../../ModellInstallation.lua)
