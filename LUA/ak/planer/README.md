---
layout: page_with_toc
title: Plane Aktionen nach Zeitablauf
subtitle: Sichere Planung zukünftiger Aktionen in EEP - so funktioniert die Ampelsteuerung auch in 10-facher Geschwindigkeit.
permalink: lua/ak/planer/
feature-img: "/docs/assets/headers/SourceCode.png"
img: "/docs/assets/headers/SourceCode.png"
---

# Motivation
Der Planer erlaubt es Dir **Aktionen** nach einer von Dir festgelegten Zeitspanne in Sekunden auszuführen.

Weiterhin kann der Planer **Folgeaktionen** dann einplanen, wenn eine von Dir festgelegte Zeitspanne nach der vorhergehenden Aktion vergangen ist.

# Funktionen

## Klasse `AkAktion`
Beinhaltet eine Funktion, die später ausgeführt werden soll und einen Namen für diese Aktion der bei der Textausgabe des Planers verwendet wird.

* Funktion `AkAktion:neu(f, name)`

  Der erste Parameter `f` ist eine Lua-Funktion, die aufgerufen wird.

  Der zweite Parameter `name` ist ein Text, der für die Ausgabe der Informationen ausgegeben wird.

  Erzeugt eine neue Aktion, die mit der Funktion `AkPlaner:planeAktion(...)` aufgerufen werden kann.


## Klasse `AkPlaner`
Nimmt Aktionen für die Planung entgegen und führt diese nach Ablauf einer bestimmten Zeitspanne aus.

* Variable: `AkPlaner.debug = false` schaltet Ausgabefunktionen zu eingeplanten Aktionen aus, `AkPlaner.debug = true` schaltet sie ein.

* Funktion `AkPlaner:planeAktion(zeitspanneInSekunden, einzuplanendeAktion, vorgaengerAktion)`

  Der erste Parameter `zeitspanneInSekunden` ist eine Zeitspanne in Sekunden, .

  Der zweite Parameter `einzuplanendeAktion` ist eine `AkAktion`, die mit `AkAktion:neu(f, name)` erstellt wurde.

  Der dritte Parameter `vorgaengerAktion` ist __optional__ und eine `AkAktion`, die mit `AkAktion:neu(f, name)` erstellt wurde. Wird die Vorgängeraktion angegeben, so wird die einzuplanende Aktionen eingeplant sobald die Vorgängeraktion durchgeführt wurde (nach der angegebenen Zeitspanne).<br>
  Wird die Vorgängeraktion nicht angegeben, so wird die einzuplanende Aktion direkt eingeplant (nach der angegebenen Zeitspanne).


* Funktion `AkPlaner:fuehreGeplanteAktionenAus()`
  Diese Funktion muss regelmäßig aufgerufen werden. Sie prüft die vergangene Zeit und führt alle eingeplanten Aktionen aus, deren Zeitspanne zum aktuellen Zeitpunkt erreicht oder vergangen ist.


# Wichtig

Damit der Planer funktioniert musst Du ihn in die EEPMain()-Methode einbinden:
  ```lua
  function EEPMain()
      AkPlaner:fuehreGeplanteAktionenAus()
      return 1
  end
  ```
