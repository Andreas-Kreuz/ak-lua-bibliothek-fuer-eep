# Anlage Ampeldemo-Grundmodelle

Diese Anlage wurde mit EEP 14 erstellt und demonstriert die Möglichkeiten der Steuerung für den Straßenverkehr.

Siehe __[ak/strasse](../../ak/strasse/README.md)__


## Inhalt

Es gibt zwei Kreuzungen:

* Kreuzung 1:
  Eine Kreuzung aus vier aufeinandertreffenden Straßen mit 8 Ampeln und Fussgängerampeln.
  
  * Die Schaltung erfolgt immer für zwei gegenüberliegende Fahrspuren. Dabei wird beim geradeaus fahren immer auch die 
    passende Fussgängerampel geschaltet. Beim Linksabbiegen wird dies nicht getan, da diese Ampeln normalerweise mit 
    Pfeilen ausgestattet sind und die Fahrzeuge daher die Fussgänger nicht beachten müssen.
    
  * Alle Richtungen der Kreuzung zählen die Fahrzeuge, so dass die Richtungen mit der größten Anzahl von Fahrzeugen 
    bevorzugt werden.

* Kreuzung 2: 
  
  * Hier handelt es sich um eine Einmündung mit einzelnen Spuren.
  
  * Für keine der Richtungen werden die Fahrzeuge gezählt, so dass die Richtungen, die am längsten Rot waren, bei der
    Schaltung auf grün bevorzugt werden.
   