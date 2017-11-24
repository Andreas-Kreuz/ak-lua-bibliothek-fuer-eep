---
layout: page_with_toc
title: Ampelsteuerung 2
type: Tutorial mit Anlage
subtitle: Erfahre, wie Du Immobilien-Ampeln verwendest und wie Du die automatische Ampelschaltung anhand des Verkehrs priorisierst.
permalink: anleitungen-fortgeschrittene/ampel-aufstellen
hide: true
---
# Ampel mit Immobilien und Zählern

Diese Anleitung zeigt Dir, wie Du unsichtbare Ampeln zusammen mit Ampel-Baukästen verwenden kannst, bei denen die Lichtfunktion die Ampelschaltung steuert.

Außerdem lernst Du, wie Du Richtungen mit Zählern versehen kannst.

**Voraussetzungen:**
* [Anleitung "Ampelkreuzung automatisch steuern"](Ampelkreuzung.md) - fange hier an, um zu erfahren, was Kreuzung, Schaltung und Richtung bedeuten.
* Straßenbahnsignale als Immobilien (V80MA1F010 und V10MA1F011) -  _[Download](https://eepshopping.de/ampel-baukasten-f%C3%83%C6%92%C3%82%C2%BCr-mehrspurige-stra%C3%83%C6%92%C3%82%C5%B8enkreuzungen%7C6624.html)_


# Beispielanlage öffnen

* Lade und installiere Dir die Beispielanlagen für die Ampeln "Installer-AK-Tutorial-Ampelkreuzung.zip"
* Öffne die Beispielanlage "*Andreas_Kreuz_Tutorial_Ampelkreuzung-2.anl3*"
* Öffne die Datei `Andreas_Kreuz-Tutorial-Ampelkreuzung-2-main.lua` in einem Editor - Du findest sie unter `C:\Trend\EEP\LUA\ak\demo-anlagen\tutorial-ampel\`.


# Immobilien kennenlernen

Wähle die Kamera `Strab-Ampel-Bausatz`

Hier siehst Du nebeneinander die Signalbilder:
* `A` Anforderung
* `Waagerechter Strich:` Halt
* `Punkt:` Anhalten
* `Senkrechter Strich:` Fahrt geradeaus

Rechts daneben befindet sich ein Gehäuse, in dass diese 4 Signalbilder nacheinander eingefügt werden sollen.

:star: **_Tipp_**: Die Anleitung des Modellsets zeigt Dir, wie Du die Signale am besten aufstellst.


# Verknüpfen der Immobilien mit Ampelmodellen
