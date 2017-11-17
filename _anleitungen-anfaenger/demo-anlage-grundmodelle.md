---
layout: page
title: Anlage Ampel-Demo 1
description: Diese Anlage wurde ausschließlich mit Grundmodellen aus EEP 14 erstellt und demonstriert die Möglichkeiten der Steuerung für den Straßenverkehr.
feature-img: "/assets/headers/AmpelDemo.jpg"
img: "/assets/headers/AmpelDemo.jpg"
date: 2017-09-07
---

Diese Anlage wurde mit EEP 14 erstellt und demonstriert die Möglichkeiten der Steuerung für den Straßenverkehr.

Siehe __[LUA/ak/strasse](../../../LUA/ak/strasse/)__


## Inhalt

Es gibt zwei Kreuzungen:

__Kreuzung 1__:

* Eine Kreuzung aus vier aufeinandertreffenden Straßen mit 8 Ampeln und Fussgängerampeln.

* Die Schaltung erfolgt immer für zwei gegenüberliegende Fahrspuren.
Dabei wird beim geradeaus fahren immer auch die passende Fussgängerampel geschaltet.
Beim Linksabbiegen wird dies nicht getan, da diese Ampeln normalerweise mit Pfeilen ausgestattet sind und die Fahrzeuge daher die Fussgänger nicht beachten müssen.

* Alle Richtungen der Kreuzung zählen die Fahrzeuge, so dass die Richtungen mit der größten Anzahl von Fahrzeugen bevorzugt werden.

__Kreuzung 2__:

+ Hier handelt es sich um eine Einmündung mit einzelnen Spuren.

* Für keine der Richtungen werden die Fahrzeuge gezählt, so dass die Richtungen, die am längsten Rot waren, bei der Schaltung auf grün bevorzugt werden.
