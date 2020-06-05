---
layout: page_with_toc
title: Ampelsteuerung 2
type: Tutorial mit Anlage
subtitle: Erfahre wie Du Immobilien-Ampeln verwenden kannst - wenn diese auf Licht ein- und ausschalten basieren.
img: "/assets/thumbnails/tutorial2-immo-ampel.jpg"
permalink: anleitungen-fortgeschrittene/tutorial2-immobilien-ampel
hide: false
date: 2017-09-02
---
# Immobilien mit Lichtfunktion als Ampel

<p class="lead"> Diese Anleitung zeigt Dir, wie Du Immobilien mit Lichtfunktion als Ampeln verwenden kannst.</p>

**Voraussetzungen:**
* [Anleitung "Ampelkreuzung automatisch steuern"](ampelkreuzung) - fange hier an, um zu erfahren, was Kreuzung, Schaltung und Richtung bedeuten.

* Du benötigst folgende Modelle:

  | 1Spur-Großstadtstraßen-System-Grundset (V10NAS30002)  | _[Download](https://eepshopping.de/1spur-gro%C3%83%C6%92%C3%82%C5%B8stadtstra%C3%83%C6%92%C3%82%C5%B8en-system-grundset%7C7656.html)_  |
  | 1Spur-Ergänzungsset  | _[Download](https://www.eepforum.de/filebase/file/215-freeset-zu-meinem-1spur-strassensystem/)_  |
  | Ampel-Baukasten für mehrspurige Straßenkreuzungen (V80NJS20039) | _[Download](https://eepshopping.de/ampel-baukasten-f%C3%83%C6%92%C3%82%C2%BCr-mehrspurige-stra%C3%83%C6%92%C3%82%C5%B8enkreuzungen%7C6624.html)_ |
  | Straßenbahnsignale als Immobilien (V80MA1F010 und V10MA1F011) | _[Download](http://www.eep.euma.de/download/)_ |

# Beispielanlage verwenden

* Lade und installiere Dir die Beispielanlagen für die Ampeln "Installer-AK-Tutorial-Ampelkreuzung.zip"
* Öffne die Beispielanlage "*Andreas_Kreuz_Tutorial_Ampelkreuzung-2.anl3*" in EEP
* Öffne die Datei `Andreas_Kreuz-Tutorial-Ampelkreuzung-2-main.lua` in einem Editor - Du findest sie unter `C:\Trend\EEP\LUA\ak\demo-anlagen\tutorial-ampel\`.
* So sieht die Kreuzung dieser Anlagen aus: <br>
  ![Aufbau der Kreuzung]({{ site.baseurl }}/assets/tutorial/tutorial2/kreuzungsaufbau-tutorial2.png)


# Immobilien-Ampel

Die Bibliothek unterstützt Ampelbaukästen, die ihr Schaltbild mit der Immobilien-Lichtfunktion schalten. Dieser Teil der Anleitung zeigt Dir, wie Du unsichtbare Ampeln zusammen mit solchen Ampel-Baukästen verwenden kannst.


## Immobilien kennenlernen

Wähle die Kamera `Strab-Ampel-Bausatz`, nachdem Du die Anlage geladen hast

Hier siehst Du nebeneinander die Signalbilder:
* `A` Anforderung
* `Waagerechter Strich:` Halt
* `Punkt:` Anhalten
* `Senkrechter Strich:` Fahrt geradeaus

Rechts daneben befindet sich ein leeres Gehäuse, in dass diese 4 Signalbilder nacheinander eingefügt werden. Ganz rechts, siehst Du, wie die fertige Straßenbahnampel aussieht

⭐ **_Tipp_**: Die Anleitung des Modellsets zeigt Dir, wie Du die Signale am besten aufstellst.

![]({{ site.baseurl }}/assets/tutorial/tutorial2/immo-ampel.jpg)

## Verwenden der Modelle

Die Kopplung der Lichtfunktionen der einzelnen Immobilien erfolgt in Lua.

Du kannst die Straßenbahnsignale mit unsichtbaren Signalen koppeln, so dass die Lichter der Immobilie korrekt für die Ampelphase geschaltet werden.

Eine neue Ampel kannst Du wie folgt anlegen:

* **Ohne Immobilien**: <br>
  `TrafficLight:new(id, modell)`<br>
  Für "normale" Ampeln ohne Kopplung an Immobilien mit Lichtschaltung. Das ist der Standard.

* **"rot" und "grün"**:<br>
  `TrafficLight:new(id, modell, immoRot, immoGruen)`<br>
  Für Zweier-Ampeln mit Lichtschaltung der Immobilien "rot" und "grün" (die gelbe Schaltphase zeigt dann "rot").

* **"rot" "gelb" und "grün"**:<br>
  `TrafficLight:new(id, modell, immoRot, immoGruen, immoGelb, immoAnforderung)`<br>Für Dreier-Ampeln mit Lichtschaltung der Immobilien "rot" "gelb" und "grün".

* **"rot" "gelb", "grün" und "Anforderung"**:<br>
  `TrafficLight:new(id, modell, immoRot, immoGruen, immoGelb, immoAnforderung)`<br>Für Vierer-Ampeln mit Lichtschaltung der Immobilien "rot" "gelb", "grün" und "Anforderung". Für die Anforderung musst Du die Fahrzeuge erkennen oder zählen - wie das geht, erfährst Du in [Tutorial 3 - Priorisierung]({{ site.baseurl }}/anleitungen-fortgeschrittene/tutorial3-priorisierung).

Die Werte von `immoRot`, `immoGruen`, `immoGelb` und `immoAnforderung` kannst Du ganz einfach über den Eigenschaften-Dialog der Immobilie herausfinden. Dort findest Du den kompletten Namen der Immobilie heraus, den Du in den Code übernimmst.

## Beispiel Vierer-Ampel

So sieht das fertige Beispiel für eine Vierer-Ampel mit Anforderung aus:
  ```lua
  -- Richtungen fuer Strassenbahnen:
  os = Lane:new("OS", 107, {
      TrafficLight:new(14, TrafficLightModel.Unsichtbar_2er,
          "#29_Straba Signal Halt", --       rot   schaltet das Licht dieser Immobilie ein
          "#28_Straba Signal geradeaus", --  gruen schaltet das Licht dieser Immobilie ein
          "#27_Straba Signal anhalten", --   gelb  schaltet das Licht dieser Immobilie ein
          "#26_Straba Signal A") --    Anforderung schaltet das Licht dieser Immobilie ein
  })
  ```

⭐ **Beachte bitte**: Die Anforderung wird nur aktiv, wenn Du Anforderungen an dieser Richtung erkennst. Wie das geht, steht in [Tutorial 3 - Priorisierung]({{ site.baseurl }}/anleitungen-fortgeschrittene/tutorial3-priorisierung).

## Beispiel Dreier-Ampel

Für eine Dreier-Ampel ohne Anforderung kannst Du einfach die letze Immobilie `immoAnforderung` entfernen:

  ```lua
  -- Richtungen fuer Strassenbahnen:
  os = Lane:new("OS", 107, {
      TrafficLight:new(14, TrafficLightModel.Unsichtbar_2er,
          "#29_Straba Signal Halt", --       rot   schaltet das Licht dieser Immobilie ein
          "#28_Straba Signal geradeaus", --  gruen schaltet das Licht dieser Immobilie ein
          "#27_Straba Signal anhalten", --   gelb  schaltet das Licht dieser Immobilie ein
  })
  ```
