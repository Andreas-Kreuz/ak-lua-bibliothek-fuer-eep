---
layout: page_with_toc
title: Ampelsteuerung 3
type: Tutorial mit Anlage
subtitle: Erfahre wie Du anliegenden Verkehr erkennen kannst und wie dieser die Schaltungen beeinflusst.  
img: "/assets/thumbnails/tutorial3-verkehr-erkennen.jpg"
permalink: anleitungen-fortgeschrittene/tutorial3-priorisierung
hide: false
date: 2017-09-03
---
# Priorisierung an der Ampel

**Voraussetzungen:**
* [Anleitung "Ampelkreuzung automatisch steuern"](ampelkreuzung) - fange hier an, um zu erfahren, was Kreuzung, Schaltung und Richtung bedeuten.

# Beispielanlage öffnen

* Lade und installiere Dir die Beispielanlagen für die Ampeln "Installer-AK-Tutorial-Ampelkreuzung.zip"
* Öffne die Beispielanlage "*Andreas_Kreuz_Tutorial_Ampelkreuzung-2.anl3*" in EEP
* Öffne die Datei `Andreas_Kreuz-Tutorial-Ampelkreuzung-2-main.lua` in einem Editor - Du findest sie unter `C:\Trend\EEP\LUA\ak\demo-anlagen\tutorial-ampel\`.

# So funktioniert Priorisierung

## ... innerhalb einer Richtung

Es gibt 4 Arten von Priorisierungen für Richtungen. Nur eine davon kann  verwendet werden:

<ul class="list-unstyled">
  <li class="media mt-5">
    <img class="img-thumbnail mr-3" src="{{ site.baseurl }}/assets/tutorial/tutorial3/erkennung-wartezeit.png" width="128" height="128" alt="Priorisierung nach Wartezeit">
    <div class="media-body">
      <h5 class="mt-0">Priorisierung nach Wartezeit</h5>
      Werden die Fahrzeuge nicht anhand von unten stehenden Mechanismen erkannt, so erfolgt die Priorisierung dieser Richtung anhand der Wartezeit. Die Wartezeit wird immer um eins hochgezählt, wenn diese Richtung beim Ändern der Ampelschaltung rot bekommt. Sie wird auf 0 zurükgesetzt, wenn die Ampel grün bekommt.<br><br>

      Wenn Du <strong>keine</strong> Priorisierung einrichtest, dann werden die Richtungen anhand ihrer Wartezeit geschaltet.
    </div>
  </li>
  <li class="media mt-5">
    <img class="img-thumbnail mr-3" src="{{ site.baseurl }}/assets/tutorial/tutorial3/erkennung-kontaktpunkt.png" width="128" height="128" alt="Zählen von Fahrzeugen">
    <div class="media-body">
      <h5 class="mt-0">Zählen von Fahrzeugen</h5>
      Wenn Du die Anzahl der Fahrzeuge einer Richtung mit Kontaktpunkten zählst, bekommst Du die bestmögliche Erkennung für mehrere Fahrzeuge.

      Setze für jeder Richtung zwei Kontaktpunkte: Den ersten vor der Ampel, der der Richtung sagt, dass sich ein weiteres Fahrzeug vor der Ampel befindet. Den zweiten nach der Ampel, der der Richtung sagt, dass sich ein Fahrzeug weniger an der Ampel befindet.
    </div>
  </li>
  <li class="media mt-5">
    <img class="img-thumbnail mr-3" src="{{ site.baseurl }}/assets/tutorial/tutorial3/erkennung-signal.png" width="128" height="128" alt="Erkennen von Fahrzeugen am roten Signal">
    <div class="media-body">
      <h5 class="mt-0">Erkennen von Fahrzeugen am roten Signal</h5>
      Du kannst den Verkehr einer Richtung erkennen, wenn sie an einer roten Ampel stehen. Die Funktion erkennt Fahrzeuge, die <strong>zwischen dem Vor- und Hauptsignal einer roten Ampel</strong> stehen - intern wird regelmäßig <code>EEPGetSignalTrainsCount</code> abgefragt.
    </div>
  </li>
  <li class="media mt-5">
    <img class="img-thumbnail mr-3" src="{{ site.baseurl }}/assets/tutorial/tutorial3/erkennung-strasse.png" width="128" height="128" alt="Erkennen von Fahrzeugen auf Straße">
    <div class="media-body">
      <h5 class="mt-0">Erkennen von Fahrzeugen auf Straße</h5>
      Du kannst die Ampelschaltung einer Richtung priorisieren, indem Du prüfst, ob auf dem Straßenstück vor der Ampel ein Fahrzeug steht - intern wird dazu <code>EEPRegisterRoadTrack</code> verwendet.
    </div>
  </li>
</ul>

:star: **Bitte beachte**: Pro Richtung kann nur ein Mechanismus verwendet werden. Bei mehreren Mechanismen, gewinnt der erste in der folgenden Liste:
1. Erkennen von Fahrzeugen auf Straßen
2. Erkennen von Fahrzeugen an Signalen
3. Zählen mit Kontaktpunkten
4. Automatisch anhand der Wartezeit


## ... innerhalb einer Kreuzung

Die nächste Schaltung wird immer durch die höchsten Durchschnittspriorität aller Richtungen bestimmt.

Durch das Einbeziehen der Wartezeit wird sichergestellt, dass jede Richtung berücksichtigt wird.

:star: Am besten verwendest Du die Priorisierung für alle Richtungen einer Kreuzung - oder für gar keine.


# Erkennung mit Strassen

![]({{ site.baseurl }}/assets/tutorial/tutorial3/reservierung-strasse.jpg)

## ... alle Fahrzeuge
<div class="media mb-5">
  <img class="img-thumbnail mr-3" src="{{ site.baseurl }}/assets/tutorial/tutorial3/erkennung-strasse.png" width="128" height="128" alt="Priorisierung nach Wartezeit">
  <div class="media-body">
    Erkenne eine belegte Richtung daran, ob sich ein Fahrzeug auf dem Straßenstück vor dem Signal befindet.
  </div>
</div>

* Verwende dazu folgenden Code (`ws` ist eine Richtung):

  ```lua
  richtung = AkRichtung:neu("WS", 108, {
      AkAmpel:neu(15, AkAmpelModell.Unsichtbar_2er
  })
  richtung:zaehleAnStrasseAlle(2) -- Erfasst Anforderungen, wenn ein Fahrzeug auf Strasse 2 steht
  ```

* Die Code-Zeile `ws:zaehleAnStrasseAlle(xx)` sorgt dafür, dass die Richtung priorisiert wird, wenn das Straßenstück mit der ID `xx` belegt ist. Dies erfolgt jedoch immer nur für ein Fahrzeug pro Straßenstück.

* Es können auch mehrere Straßenstücke gleichzeitig beobachtet werden, z.B. für mehrspurige Straßen.

  ```lua
  ws:zaehleAnStrasseAlle(2)
  ws:zaehleAnStrasseAlle(3)
  ```

* Insgesamt werden alle belegten Straßenstück der Richtung als ein Fahrzeug gezählt.

## ... Fahrzeuge bestimmter Routen
<div class="media mb-5">
  <img class="img-thumbnail mr-3" src="{{ site.baseurl }}/assets/tutorial/tutorial3/erkennung-strasse.png" width="128" height="128" alt="Priorisierung nach Wartezeit">
  <div class="media-body">
    Erkenne eine belegte Richtung daran, ob sich ein Fahrzeug auf dem Straßenstück vor dem Signal befindet <strong>und</strong> dieses Fahrzeug eine bestimmte Route hat.
  </div>
</div>

Auf Wunsch kann die Priorisierung nur dann erfolgen, wenn Fahrzeuge einer bestimmten Route auf der Straße vor der Ampel stehen. - Willst Du dies erreichen, dann sollte das Straßenstück so kurz sein, dass nur ein Fahrzeug gleichzeitig darauf stehen kann.

* Verwende dazu folgenden Code (`ws` ist eine Richtung)

  ```lua
  richtung = AkRichtung:neu("WS", 108, {
      AkAmpel:neu(15, AkAmpelModell.Unsichtbar_2er
  })
  richtung:zaehleAnStrasseBeiRoute(2, "Linie 1")
  ```

* Die Code-Zeile `ws:zaehleAnStrasseAlle(xx, route)` sorgt dafür, dass die Richtung priorisiert wird, wenn die Straße mit der ID `xx` von einem Fahrzeug mit der Route `route` belegt ist.

* Es können auch mehrere Routen hintereinander beobachtet werden:

  ```lua
  richtung = AkRichtung:neu("WS", 108, {
      AkAmpel:neu(15, AkAmpelModell.Unsichtbar_2er
  })
  richtung:zaehleAnStrasseBeiRoute(2, "Linie 1")
  richtung:zaehleAnStrasseBeiRoute(2, "Linie 4")
  ```

:star: **Bitte beachte**: Die Kombination der Erkennung von Fahrzeugen jeder Route und Fahrzeugen bestimmter Routen ist nicht sinnvoll.


# Erkennung mit Signalen

![]({{ site.baseurl }}/assets/tutorial/tutorial3/reservierung-signal.jpg)

## ... alle Fahrzeuge
<div class="media mb-5">
  <img class="img-thumbnail mr-3" src="{{ site.baseurl }}/assets/tutorial/tutorial3/erkennung-signal.png" width="128" height="128" alt="Priorisierung nach Wartezeit">
  <div class="media-body">
    Erkenne eine belegte Richtung anhand der Fahrzeuge die am <strong>roten</strong> Signal warten.
  </div>
</div>

Die Erkennung erfolgt ähnlich wie bei der Straße (Details siehe oben).

  ```lua
  richtung:zaehleAnAmpelAlle(14)
  ```

## ... Fahrzeuge bestimmter Routen
<div class="media mb-5">
  <img class="img-thumbnail mr-3" src="{{ site.baseurl }}/assets/tutorial/tutorial3/erkennung-signal.png" width="128" height="128" alt="Priorisierung nach Wartezeit">
  <div class="media-body">
    Erkenne eine belegte Richtung anhand der Fahrzeuge die am <strong>roten</strong> Signal warten, aber nur wenn das erste Fahrzeug eine bestimmte Route hat.
  </div>
</div>

  ```lua
  richtung:zaehleAnAmpelBeiRoute(14, "Linie 2")
  ```

:star: Die Erkennung funktioniert nur, wenn die Ampel rot ist.


# Erkennung mit Kontaktpunkten

![]({{ site.baseurl }}/assets/tutorial/tutorial3/reservierung-zaehler.jpg)

<div class="media mb-5">
  <img class="img-thumbnail mr-3" src="{{ site.baseurl }}/assets/tutorial/tutorial3/erkennung-signal.png" width="128" height="128" alt="Priorisierung nach Wartezeit">
  <div class="media-body">
    Wenn Du die Anzahl der Fahrzeuge einer Richtung mit Kontaktpunkten zählst, bekommst Du die bestmögliche Erkennung für mehrere Fahrzeuge.
  </div>
</div>

Setze für jeder Richtung zwei Kontaktpunkte:

1. Vor dem Signal der Richtung

    Dieser Kontaktpunkt muss die Funktion `richtung:betritt()` aufrufen - in der Demo-Anlage wird in den Kontaktpunkten `KpBetritt(richtung)` verwendet.

    :star: Achte darauf, dass nur Fahrzeuge den Kontaktpunkt aufrufen, die diese Richtung betreten.<br>
    :star: Achte darauf, dass der Kontaktpunkt nicht vor einer Verzweigungen liegt, die die Fahrzeuge auf andere Richtungen verteilt.

2. Hinter dem Signal der Richtung

    Dieser Kontaktpunkt muss die Funktion `richtung:verlasse()` aufrufen - in der Demo-Anlage wird in den Kontaktpunkten `KpVerlasse(richtung)` verwendet.

    :star: Achte darauf, dass nur Fahrzeuge den Kontaktpunkt aufrufen, die die korrekte Richtung verlassen.<br>
    :star: Achte darauf, dass der Kontaktpunkt hinter der Haltelinie liegt.
