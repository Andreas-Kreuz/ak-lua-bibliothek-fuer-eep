# Architektur der Lua-Bibliothek von Andreas Kreuz

Diese Bibliothek hat folgende Ziele:

1. Extraktion von Daten aus EEP
   - Nutzung von EEP-Funktionen
   - Parsen des XMLs von Anlage-Daten, wenn notwendig
2. Aufbereitung der Daten
3. Nutzung der extrahierten Daten für Steuerung von Fachmodulen

## Datenhaltung

Alle Daten werden strikt nach EEP Core Daten und Fachmodulen getrennt:

1. Allgemeine Daten von EEP werden hier gehalten:
   - 'modules/core'

2. Daten und Code der Fachmodule kommen in die passenden Verzeichnisse
   - 'modules/road'
   - 'modules/rail'
   - 'modules/public-transport'
   - usw.

## Code Konventionen

- 'XxxStatePublisher' ist eine Klasse

## StatePublisher-Dokumentation

Die gemeinsamen Muster aller `*StatePublisher`-Klassen sind in [StatePublishers.md](./StatePublishers.md) separat dokumentiert.
